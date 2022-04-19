// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:assignment_6/helpers/constants.dart';
import 'package:assignment_6/helpers/sql_helper.dart';
import 'package:assignment_6/model/user_model.dart';
import 'package:assignment_6/screens/login_screens.dart';
import 'package:assignment_6/widget/update_info.dart';
import 'package:flutter/material.dart';

class AllData extends StatefulWidget {
  const AllData({Key? key}) : super(key: key);

  @override
  State<AllData> createState() => _AllDataState();
}

class _AllDataState extends State<AllData> {
  bool _isLoading = true;

  void _getAllUsers() async {
    final data = await SQLHelper.getItems();
    setState(() {
      UserModel.allUsers = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllUsers();
  }

  void _deleteUser(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kRedColor,
        content: Text(
          'Successfully deleted a user',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
    _getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    for (int i = 0; i < UserModel.allUsers.length; i++) {
      print("id $i " + UserModel.allUsers[i]["id"].toString());
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreens(),
            ),
          );
        },
        backgroundColor: kGreenShadeColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: kGreenShadeColor,
        title: Text(
          "All Users",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? CircularProgressIndicator(color: kRedColor)
          : ListView.builder(
              itemCount: UserModel.allUsers.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (index == 0) SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          color: kSkyBlueShade.withOpacity(0.2),
                        ),
                        child: ListTile(
                          trailing: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child:
                                          UpdateInfoBottomSheet(index: index),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              color: kSkyBlueShade,
                              size: 30,
                            ),
                          ),
                          leading: Icon(
                            Icons.person,
                            color: kSkyBlueShade,
                            size: 35,
                          ),
                          onLongPress: () {
                            _deleteUser(UserModel.allUsers[index]['id']);
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                UserModel.allUsers[index]['username'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            " ${UserModel.allUsers[index]['password']}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Divider(color: Colors.white38),
                  ],
                );
              },
            ),
    );
  }
}
