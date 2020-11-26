import Foundation
import Combine
import Alamofire

class ViewModel: ObservableObject {
    @Published
    var isActiveScene: ChangeScene = .signin
    @Published
    var username: String = "pavel".lowercased()
    @Published
    var email: String = "test@mail.ru"
    @Published
    var password: String = "123qwe"
    @Published
    var passwordRepit: String = "123qwe"
    @Published
    var userInformation: LogInData? = nil
    @Published
    var isAuth: Bool = false
    
    let height: Int = 24
    let weight: Int = 63
    
    func signout() {
        AF
            .request("http://gym.areas.su/signout", method: .post, parameters: ["username": self.username])
            .responseDecodable(of: LogOutData.self) {response in
                if response.value != nil {
                    self.isAuth = false
                    self.isActiveScene = .signin
                    print("Signout")
                }
                
            }
    }
    
    func signin () {
        AF
            .request("http://gym.areas.su/signin", method: .post, parameters: [
                "username": self.username,
                "password": self.password
            ])
            .responseDecodable(of: LogInData.self) { response in
                if response.value != nil {
                    if !self.password.isEmpty
                    {
                        self.isAuth = true
                        self.isActiveScene = .home
                        print(self.isActiveScene)
                        self.userInformation = response.value!
                        print("You Auth, your Token: \(self.userInformation!.notice.token)")
                    }
                }
            }
    }
    
    func signup () {
        AF
            .request("http://gym.areas.su/signup", method: .post, parameters: [
                "username": self.username,
                "email": self.email,
                "password": self.password,
                "weight": self.weight,
                "height": self.height
            ])
            .responseDecodable(of: SignUpData.self) { response in
                if case.success = response.result,
                   self.password == self.passwordRepit,
                   !self.password.isEmpty,
                   self.email.contains("@"){
                    print(response.result)
                    self.isActiveScene = .signin
                }
            }
    }
}
