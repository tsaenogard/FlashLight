//
//  ViewController.swift
//  FlashLight
//
//  Created by Xcode on 2017/5/1.
//  Copyright © 2017年 wtfcompany. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var label: UILabel!
    var _switch: UISwitch!
    var slider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.label = UILabel()
        self.label.text = "燈光控制器"
        self.label.textColor = UIColor.darkGray
        self.label.textAlignment = .center
        self.label.font = UIFont.systemFont(ofSize: 40)
        self.view.addSubview(self.label)
        
        self._switch = UISwitch()
        self._switch.isOn = false
        self._switch.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
        self.view.addSubview(self._switch)
        
        self.slider = UISlider()
        self.slider.minimumValue = 0.0
        self.slider.maximumValue = 1.0
        self.slider.value = 0.5
        self.slider.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
        self.view.addSubview(self.slider)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let frameW = UIScreen.main.bounds.width
        let gap:CGFloat = 10
        
        let labelW: CGFloat = 205
        let labelX = (frameW - labelW) / 2
        self.label.frame = CGRect(x: labelX, y: 200, width: labelW, height: 50)
        
        let switchX = (frameW - self._switch.frame.width) / 2
        let switchY = self.label.frame.maxY + gap
        self._switch.frame.origin = CGPoint(x: switchX, y: switchY)
        
        let sliderX = frameW / 4
        let sliderY = self._switch.frame.maxY + gap * 3
        let sliderW = frameW / 2
        self.slider.frame = CGRect(x: sliderX, y: sliderY, width: sliderW, height: 30)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - selector
    
    func switchAction(_ sender: UISwitch) {
        guard let flashlight = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            print("裝置不支援")
            return
        }
        if flashlight.hasFlash && flashlight.hasTorch /*能否一直亮*/ {
            
            do {
                try flashlight.lockForConfiguration()
                flashlight.torchMode = sender.isOn ? .on : .off
                flashlight.unlockForConfiguration()
            } catch {
                print("配置失敗")
            }
            
            
        }else {
            print("裝置不支援")
        }
    }
    var sliderValue: Float = 0.5
    func sliderAction(_ sender: UISlider) {
        if !self._switch.isOn {
            sender.value = self.sliderValue
            return
        }
        if sender.value == 0.0 { return }
        
        guard let flashlight = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            print("裝置不支援")
            return
        }
        if flashlight.hasFlash && flashlight.hasTorch /*能否一直亮*/ {
            
            do {
                try flashlight.lockForConfiguration()
                try
                    flashlight.setTorchModeOnWithLevel(sender.value)
                flashlight.unlockForConfiguration()
            } catch {
                print("配置失敗")
            }
            
            
        }else {
            print("裝置不支援")
        }

    }

}

