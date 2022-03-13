//
//  ViewController.swift
//  App20220313GoogleSignin
//
//  Created by grace on 2022/3/13.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {
    @IBOutlet weak var GoogleSigninStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                let theEmail = user.email ?? ""
                print("已登入成功\(theEmail)")
                self.GoogleSigninStatus.text = "您好,\(theEmail)"
            } else {
                print("登出狀態")
                self.GoogleSigninStatus.text = "您已登出"
            }
        }
    }

    @IBAction func signinGoogleAction(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { result, error in
                if error != nil {
                    print(error?.localizedDescription ?? "" as Any)
                }
            }
        }
    }
    
    @IBAction func signoutGoogleAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }catch{
            print(error.localizedDescription)
        }
    }
}

