From: akpm@linux-foundation.org
Subject: + revert-usb-usb-remove-info-macro-from-usbh.patch added to -mm tree
Date: Thu, 09 Oct 2008 17:16:39 -0700
Message-ID: <200810100031.m9A0V4sF013810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbYJJAbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 20:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com


The patch titled
     revert usb-usb-remove-info-macro-from-usbh
has been added to the -mm tree.  Its filename is
     revert-usb-usb-remove-info-macro-from-usbh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert usb-usb-remove-info-macro-from-usbh
From: Andrew Morton <akpm@linux-foundation.org>

I have neither the time nor the inclination to repair all the bustage from
this.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-core.c                     |    3 
 drivers/hid/usbhid/usbkbd.c                       |    9 
 drivers/hid/usbhid/usbmouse.c                     |    3 
 drivers/input/joystick/xpad.c                     |    2 
 drivers/input/misc/ati_remote.c                   |    6 
 drivers/input/misc/yealink.c                      |    3 
 drivers/input/tablet/acecad.c                     |    3 
 drivers/input/tablet/aiptek.c                     |   13 
 drivers/input/tablet/gtco.c                       |    4 
 drivers/input/tablet/kbtab.c                      |    3 
 drivers/input/tablet/wacom_sys.c                  |    3 
 drivers/media/radio/dsbr100.c                     |    3 
 drivers/media/video/dabusb.c                      |    3 
 drivers/media/video/ov511.c                       |  105 +++----
 drivers/media/video/ov511.h                       |    3 
 drivers/media/video/pvrusb2/pvrusb2-main.c        |    8 
 drivers/media/video/se401.c                       |   37 +-
 drivers/media/video/stv680.c                      |    6 
 drivers/media/video/usbvideo/ibmcam.c             |   78 ++---
 drivers/media/video/usbvideo/konicawc.c           |   17 -
 drivers/media/video/usbvideo/quickcam_messenger.c |    3 
 drivers/media/video/usbvideo/ultracam.c           |   29 --
 drivers/media/video/usbvideo/usbvideo.c           |  163 ++++--------
 drivers/media/video/usbvision/usbvision-core.c    |    3 
 drivers/media/video/usbvision/usbvision-i2c.c     |    3 
 drivers/media/video/usbvision/usbvision-video.c   |    3 
 drivers/media/video/zr364xx.c                     |   43 +--
 drivers/mtd/nand/alauda.c                         |    4 
 drivers/net/irda/kingsun-sir.c                    |    3 
 drivers/net/irda/ks959-sir.c                      |    3 
 drivers/net/irda/ksdazzle-sir.c                   |    3 
 drivers/net/irda/stir4200.c                       |    8 
 drivers/net/usb/catc.c                            |    3 
 drivers/net/usb/kaweth.c                          |   19 -
 drivers/net/usb/rtl8150.c                         |   15 -
 drivers/usb/class/cdc-acm.c                       |    3 
 drivers/usb/host/r8a66597-hcd.c                   |   13 
 drivers/usb/image/mdc800.c                        |    7 
 drivers/usb/misc/adutux.c                         |    5 
 drivers/usb/misc/cytherm.c                        |    3 
 drivers/usb/misc/emi26.c                          |    4 
 drivers/usb/misc/emi62.c                          |    4 
 drivers/usb/misc/idmouse.c                        |    5 
 drivers/usb/misc/legousbtower.c                   |   23 -
 drivers/usb/misc/rio500.c                         |   11 
 drivers/usb/misc/trancevibrator.c                 |    3 
 drivers/usb/misc/usblcd.c                         |   11 
 drivers/usb/misc/uss720.c                         |   12 
 drivers/usb/serial/belkin_sa.c                    |    5 
 drivers/usb/serial/cp2101.c                       |    3 
 drivers/usb/serial/cyberjack.c                    |    5 
 drivers/usb/serial/cypress_m8.c                   |    3 
 drivers/usb/serial/digi_acceleport.c              |    3 
 drivers/usb/serial/empeg.c                        |    3 
 drivers/usb/serial/ftdi_sio.c                     |   11 
 drivers/usb/serial/garmin_gps.c                   |    3 
 drivers/usb/serial/hp4x.c                         |    3 
 drivers/usb/serial/io_edgeport.c                  |    3 
 drivers/usb/serial/io_ti.c                        |    3 
 drivers/usb/serial/ipaq.c                         |    3 
 drivers/usb/serial/ipw.c                          |    3 
 drivers/usb/serial/ir-usb.c                       |    3 
 drivers/usb/serial/iuu_phoenix.c                  |    3 
 drivers/usb/serial/keyspan.c                      |    3 
 drivers/usb/serial/keyspan_pda.c                  |    3 
 drivers/usb/serial/kl5kusb105.c                   |   14 -
 drivers/usb/serial/kobil_sct.c                    |    4 
 drivers/usb/serial/mct_u232.c                     |    3 
 drivers/usb/serial/mos7720.c                      |    3 
 drivers/usb/serial/mos7840.c                      |    3 
 drivers/usb/serial/omninet.c                      |    3 
 drivers/usb/serial/option.c                       |    3 
 drivers/usb/serial/pl2303.c                       |    2 
 drivers/usb/serial/safe_serial.c                  |   13 
 drivers/usb/serial/sierra.c                       |    3 
 drivers/usb/serial/spcp8x5.c                      |    3 
 drivers/usb/serial/ti_usb_3410_5052.c             |    3 
 drivers/usb/serial/usb-serial.c                   |    7 
 drivers/usb/serial/visor.c                        |   15 -
 drivers/usb/serial/whiteheat.c                    |    8 
 include/linux/usb.h                               |    2 
 81 files changed, 345 insertions(+), 528 deletions(-)

diff -puN drivers/hid/usbhid/hid-core.c~revert-usb-usb-remove-info-macro-from-usbh drivers/hid/usbhid/hid-core.c
--- a/drivers/hid/usbhid/hid-core.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/hid/usbhid/hid-core.c
@@ -1112,8 +1112,7 @@ static int __init hid_init(void)
 	retval = usb_register(&hid_driver);
 	if (retval)
 		goto usb_register_fail;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 
 	return 0;
 usb_register_fail:
diff -puN drivers/hid/usbhid/usbkbd.c~revert-usb-usb-remove-info-macro-from-usbh drivers/hid/usbhid/usbkbd.c
--- a/drivers/hid/usbhid/usbkbd.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/hid/usbhid/usbkbd.c
@@ -105,16 +105,14 @@ static void usb_kbd_irq(struct urb *urb)
 			if (usb_kbd_keycode[kbd->old[i]])
 				input_report_key(kbd->dev, usb_kbd_keycode[kbd->old[i]], 0);
 			else
-				dev_info(&urb->dev->dev,
-					 "Unknown key (scancode %#x) released.\n", kbd->old[i]);
+				info("Unknown key (scancode %#x) released.", kbd->old[i]);
 		}
 
 		if (kbd->new[i] > 3 && memscan(kbd->old + 2, kbd->new[i], 6) == kbd->old + 8) {
 			if (usb_kbd_keycode[kbd->new[i]])
 				input_report_key(kbd->dev, usb_kbd_keycode[kbd->new[i]], 1);
 			else
-				dev_info(&urb->dev->dev,
-					 "Unknown key (scancode %#x) released.\n", kbd->new[i]);
+				info("Unknown key (scancode %#x) pressed.", kbd->new[i]);
 		}
 	}
 
@@ -355,8 +353,7 @@ static int __init usb_kbd_init(void)
 {
 	int result = usb_register(&usb_kbd_driver);
 	if (result == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		info(DRIVER_VERSION ":" DRIVER_DESC);
 	return result;
 }
 
diff -puN drivers/hid/usbhid/usbmouse.c~revert-usb-usb-remove-info-macro-from-usbh drivers/hid/usbhid/usbmouse.c
--- a/drivers/hid/usbhid/usbmouse.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/hid/usbhid/usbmouse.c
@@ -245,8 +245,7 @@ static int __init usb_mouse_init(void)
 {
 	int retval = usb_register(&usb_mouse_driver);
 	if (retval == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		info(DRIVER_VERSION ":" DRIVER_DESC);
 	return retval;
 }
 
diff -puN drivers/input/joystick/xpad.c~revert-usb-usb-remove-info-macro-from-usbh drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/input/joystick/xpad.c
@@ -911,7 +911,7 @@ static int __init usb_xpad_init(void)
 {
 	int result = usb_register(&xpad_driver);
 	if (result == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "\n");
+		info(DRIVER_DESC);
 	return result;
 }
 
diff -puN drivers/input/misc/ati_remote.c~revert-usb-usb-remove-info-macro-from-usbh drivers/input/misc/ati_remote.c
--- a/drivers/input/misc/ati_remote.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/input/misc/ati_remote.c
@@ -834,11 +834,9 @@ static int __init ati_remote_init(void)
 
 	result = usb_register(&ati_remote_driver);
 	if (result)
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": usb_register error #%d\n", result);
+		err("usb_register error #%d\n", result);
 	else
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		info("Registered USB driver " DRIVER_DESC " v. " DRIVER_VERSION);
 
 	return result;
 }
diff -puN drivers/input/misc/yealink.c~revert-usb-usb-remove-info-macro-from-usbh drivers/input/misc/yealink.c
--- a/drivers/input/misc/yealink.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/input/misc/yealink.c
@@ -999,8 +999,7 @@ static int __init yealink_dev_init(void)
 {
 	int ret = usb_register(&yealink_driver);
 	if (ret == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		info(DRIVER_DESC ":" DRIVER_VERSION);
 	return ret;
 }
 
diff -puN drivers/input/tablet/acecad.c~revert-usb-usb-remove-info-macro-from-usbh drivers/input/tablet/acecad.c
--- a/drivers/input/tablet/acecad.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/input/tablet/acecad.c
@@ -280,8 +280,7 @@ static int __init usb_acecad_init(void)
 {
 	int result = usb_register(&usb_acecad_driver);
 	if (result == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		info(DRIVER_VERSION ":" DRIVER_DESC);
 	return result;
 }
 
diff -puN drivers/input/tablet/aiptek.c~revert-usb-usb-remove-info-macro-from-usbh drivers/input/tablet/aiptek.c
--- a/drivers/input/tablet/aiptek.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/input/tablet/aiptek.c
@@ -1844,9 +1844,8 @@ aiptek_probe(struct usb_interface *intf,
 		aiptek->curSetting.programmableDelay = speeds[i];
 		(void)aiptek_program_tablet(aiptek);
 		if (aiptek->inputdev->absmax[ABS_X] > 0) {
-			dev_info(&intf->dev,
-				 "Aiptek using %d ms programming speed\n",
-				 aiptek->curSetting.programmableDelay);
+			info("input: Aiptek using %d ms programming speed\n",
+			     aiptek->curSetting.programmableDelay);
 			break;
 		}
 	}
@@ -1854,8 +1853,7 @@ aiptek_probe(struct usb_interface *intf,
 	/* Murphy says that some day someone will have a tablet that fails the
 	   above test. That's you, Frederic Rodrigo */
 	if (i == ARRAY_SIZE(speeds)) {
-		dev_info(&intf->dev,
-			 "Aiptek tried all speeds, no sane response\n");
+		info("input: Aiptek tried all speeds, no sane response");
 		goto fail2;
 	}
 
@@ -1927,9 +1925,8 @@ static int __init aiptek_init(void)
 {
 	int result = usb_register(&aiptek_driver);
 	if (result == 0) {
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_AUTHOR "\n");
+		info(DRIVER_VERSION ": " DRIVER_AUTHOR);
+		info(DRIVER_DESC);
 	}
 	return result;
 }
diff -puN drivers/input/tablet/gtco.c~revert-usb-usb-remove-info-macro-from-usbh drivers/input/tablet/gtco.c
--- a/drivers/input/tablet/gtco.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/input/tablet/gtco.c
@@ -2,7 +2,7 @@
 
 GTCO digitizer USB driver
 
-Use the err() and dbg() macros from usb.h for system logging
+Use the err(), dbg() and info() macros from usb.h for system logging
 
 TO CHECK:  Is pressure done right on report 5?
 
@@ -1010,7 +1010,7 @@ static void gtco_disconnect(struct usb_i
 		kfree(gtco);
 	}
 
-	dev_info(&interface->dev, "gtco driver disconnected\n");
+	info("gtco driver disconnected");
 }
 
 /*   STANDARD MODULE LOAD ROUTINES  */
diff -puN drivers/input/tablet/kbtab.c~revert-usb-usb-remove-info-macro-from-usbh drivers/input/tablet/kbtab.c
--- a/drivers/input/tablet/kbtab.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/input/tablet/kbtab.c
@@ -215,8 +215,7 @@ static int __init kbtab_init(void)
 	retval = usb_register(&kbtab_driver);
 	if (retval)
 		goto out;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 out:
 	return retval;
 }
diff -puN drivers/input/tablet/wacom_sys.c~revert-usb-usb-remove-info-macro-from-usbh drivers/input/tablet/wacom_sys.c
--- a/drivers/input/tablet/wacom_sys.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/input/tablet/wacom_sys.c
@@ -385,8 +385,7 @@ static int __init wacom_init(void)
 	wacom_driver.id_table = get_device_table();
 	result = usb_register(&wacom_driver);
 	if (result == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		info(DRIVER_VERSION ":" DRIVER_DESC);
 	return result;
 }
 
diff -puN drivers/media/radio/dsbr100.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/radio/dsbr100.c
--- a/drivers/media/radio/dsbr100.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/radio/dsbr100.c
@@ -513,8 +513,7 @@ static int usb_dsbr100_probe(struct usb_
 static int __init dsbr100_init(void)
 {
 	int retval = usb_register(&usb_dsbr100_driver);
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 	return retval;
 }
 
diff -puN drivers/media/video/dabusb.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/dabusb.c
--- a/drivers/media/video/dabusb.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/dabusb.c
@@ -866,8 +866,7 @@ static int __init dabusb_init (void)
 
 	dbg("dabusb_init: driver registered");
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 
 out:
 	return retval;
diff -puN drivers/media/video/ov511.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/ov511.c
--- a/drivers/media/video/ov511.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/ov511.c
@@ -974,14 +974,14 @@ dump_i2c_range(struct usb_ov511 *ov, int
 
 	for (i = reg1; i <= regn; i++) {
 		rc = i2c_r(ov, i);
-		dev_info(&ov->dev->dev, "Sensor[0x%02X] = 0x%02X\n", i, rc);
+		info("Sensor[0x%02X] = 0x%02X", i, rc);
 	}
 }
 
 static void
 dump_i2c_regs(struct usb_ov511 *ov)
 {
-	dev_info(&ov->dev->dev, "I2C REGS\n");
+	info("I2C REGS");
 	dump_i2c_range(ov, 0x00, 0x7C);
 }
 
@@ -992,28 +992,28 @@ dump_reg_range(struct usb_ov511 *ov, int
 
 	for (i = reg1; i <= regn; i++) {
 		rc = reg_r(ov, i);
-		dev_info(&ov->dev->dev, "OV511[0x%02X] = 0x%02X\n", i, rc);
+		info("OV511[0x%02X] = 0x%02X", i, rc);
 	}
 }
 
 static void
 ov511_dump_regs(struct usb_ov511 *ov)
 {
-	dev_info(&ov->dev->dev, "CAMERA INTERFACE REGS\n");
+	info("CAMERA INTERFACE REGS");
 	dump_reg_range(ov, 0x10, 0x1f);
-	dev_info(&ov->dev->dev, "DRAM INTERFACE REGS\n");
+	info("DRAM INTERFACE REGS");
 	dump_reg_range(ov, 0x20, 0x23);
-	dev_info(&ov->dev->dev, "ISO FIFO REGS\n");
+	info("ISO FIFO REGS");
 	dump_reg_range(ov, 0x30, 0x31);
-	dev_info(&ov->dev->dev, "PIO REGS\n");
+	info("PIO REGS");
 	dump_reg_range(ov, 0x38, 0x39);
 	dump_reg_range(ov, 0x3e, 0x3e);
-	dev_info(&ov->dev->dev, "I2C REGS\n");
+	info("I2C REGS");
 	dump_reg_range(ov, 0x40, 0x49);
-	dev_info(&ov->dev->dev, "SYSTEM CONTROL REGS\n");
+	info("SYSTEM CONTROL REGS");
 	dump_reg_range(ov, 0x50, 0x55);
 	dump_reg_range(ov, 0x5e, 0x5f);
-	dev_info(&ov->dev->dev, "OmniCE REGS\n");
+	info("OmniCE REGS");
 	dump_reg_range(ov, 0x70, 0x79);
 	/* NOTE: Quantization tables are not readable. You will get the value
 	 * in reg. 0x79 for every table register */
@@ -1025,25 +1025,25 @@ ov511_dump_regs(struct usb_ov511 *ov)
 static void
 ov518_dump_regs(struct usb_ov511 *ov)
 {
-	dev_info(&ov->dev->dev, "VIDEO MODE REGS\n");
+	info("VIDEO MODE REGS");
 	dump_reg_range(ov, 0x20, 0x2f);
-	dev_info(&ov->dev->dev, "DATA PUMP AND SNAPSHOT REGS\n");
+	info("DATA PUMP AND SNAPSHOT REGS");
 	dump_reg_range(ov, 0x30, 0x3f);
-	dev_info(&ov->dev->dev, "I2C REGS\n");
+	info("I2C REGS");
 	dump_reg_range(ov, 0x40, 0x4f);
-	dev_info(&ov->dev->dev, "SYSTEM CONTROL AND VENDOR REGS\n");
+	info("SYSTEM CONTROL AND VENDOR REGS");
 	dump_reg_range(ov, 0x50, 0x5f);
-	dev_info(&ov->dev->dev, "60 - 6F\n");
+	info("60 - 6F");
 	dump_reg_range(ov, 0x60, 0x6f);
-	dev_info(&ov->dev->dev, "70 - 7F\n");
+	info("70 - 7F");
 	dump_reg_range(ov, 0x70, 0x7f);
-	dev_info(&ov->dev->dev, "Y QUANTIZATION TABLE\n");
+	info("Y QUANTIZATION TABLE");
 	dump_reg_range(ov, 0x80, 0x8f);
-	dev_info(&ov->dev->dev, "UV QUANTIZATION TABLE\n");
+	info("UV QUANTIZATION TABLE");
 	dump_reg_range(ov, 0x90, 0x9f);
-	dev_info(&ov->dev->dev, "A0 - BF\n");
+	info("A0 - BF");
 	dump_reg_range(ov, 0xa0, 0xbf);
-	dev_info(&ov->dev->dev, "CBR\n");
+	info("CBR");
 	dump_reg_range(ov, 0xc0, 0xcf);
 }
 #endif
@@ -3208,10 +3208,9 @@ ov511_move_data(struct usb_ov511 *ov, un
 	 */
 
 	if (printph) {
-		dev_info(&ov->dev->dev,
-			 "ph(%3d): %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x\n",
-			 pnum, in[0], in[1], in[2], in[3], in[4], in[5], in[6],
-			 in[7], in[8], in[9], in[10], in[11]);
+		info("ph(%3d): %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x",
+		     pnum, in[0], in[1], in[2], in[3], in[4], in[5], in[6],
+		     in[7], in[8], in[9], in[10], in[11]);
 	}
 
 	/* Check for SOF/EOF packet */
@@ -3370,10 +3369,8 @@ ov518_move_data(struct usb_ov511 *ov, un
 	 * the definitive SOF/EOF format */
 	if ((!(in[0] | in[1] | in[2] | in[3] | in[5])) && in[6]) {
 		if (printph) {
-			dev_info(&ov->dev->dev,
-				 "ph: %2x %2x %2x %2x %2x %2x %2x %2x\n",
-				 in[0], in[1], in[2], in[3], in[4], in[5],
-				 in[6], in[7]);
+			info("ph: %2x %2x %2x %2x %2x %2x %2x %2x", in[0],
+			     in[1], in[2], in[3], in[4], in[5], in[6], in[7]);
 		}
 
 		if (frame->scanstate == STATE_LINES) {
@@ -3652,16 +3649,14 @@ ov51x_init_isoc(struct usb_ov511 *ov)
 		if (packetsize == -1) {
 			ov518_set_packet_size(ov, 640);
 		} else {
-			dev_info(&ov->dev->dev, "Forcing packet size to %d\n",
-				 packetsize);
+			info("Forcing packet size to %d", packetsize);
 			ov518_set_packet_size(ov, packetsize);
 		}
 	} else {
 		if (packetsize == -1) {
 			ov511_set_packet_size(ov, size);
 		} else {
-			dev_info(&ov->dev->dev, "Forcing packet size to %d\n",
-				 packetsize);
+			info("Forcing packet size to %d", packetsize);
 			ov511_set_packet_size(ov, packetsize);
 		}
 	}
@@ -4129,7 +4124,7 @@ ov51x_v4l1_ioctl_internal(struct inode *
 			return -EIO;
 
 		if (force_palette && p->palette != force_palette) {
-			dev_info(&ov->dev->dev, "Palette rejected (%s)\n",
+			info("Palette rejected (%s)",
 			     symbolic(v4l1_plist, p->palette));
 			return -EINVAL;
 		}
@@ -4857,27 +4852,26 @@ ov7xx0_configure(struct usb_ov511 *ov)
 		err("Error detecting sensor type");
 		return -1;
 	} else if ((rc & 3) == 3) {
-		dev_info(&ov->dev->dev, "Sensor is an OV7610\n");
+		info("Sensor is an OV7610");
 		ov->sensor = SEN_OV7610;
 	} else if ((rc & 3) == 1) {
 		/* I don't know what's different about the 76BE yet. */
 		if (i2c_r(ov, 0x15) & 1)
-			dev_info(&ov->dev->dev, "Sensor is an OV7620AE\n");
+			info("Sensor is an OV7620AE");
 		else
-			dev_info(&ov->dev->dev, "Sensor is an OV76BE\n");
+			info("Sensor is an OV76BE");
 
 		/* OV511+ will return all zero isoc data unless we
 		 * configure the sensor as a 7620. Someone needs to
 		 * find the exact reg. setting that causes this. */
 		if (ov->bridge == BRG_OV511PLUS) {
-			dev_info(&ov->dev->dev,
-				 "Enabling 511+/7620AE workaround\n");
+			info("Enabling 511+/7620AE workaround");
 			ov->sensor = SEN_OV7620;
 		} else {
 			ov->sensor = SEN_OV76BE;
 		}
 	} else if ((rc & 3) == 0) {
-		dev_info(&ov->dev->dev, "Sensor is an OV7620\n");
+		info("Sensor is an OV7620");
 		ov->sensor = SEN_OV7620;
 	} else {
 		err("Unknown image sensor version: %d", rc & 3);
@@ -5033,16 +5027,16 @@ ov6xx0_configure(struct usb_ov511 *ov)
 
 	if ((rc & 3) == 0) {
 		ov->sensor = SEN_OV6630;
-		dev_info(&ov->dev->dev, "Sensor is an OV6630\n");
+		info("Sensor is an OV6630");
 	} else if ((rc & 3) == 1) {
 		ov->sensor = SEN_OV6620;
-		dev_info(&ov->dev->dev, "Sensor is an OV6620\n");
+		info("Sensor is an OV6620");
 	} else if ((rc & 3) == 2) {
 		ov->sensor = SEN_OV6630;
-		dev_info(&ov->dev->dev, "Sensor is an OV6630AE\n");
+		info("Sensor is an OV6630AE");
 	} else if ((rc & 3) == 3) {
 		ov->sensor = SEN_OV6630;
-		dev_info(&ov->dev->dev, "Sensor is an OV6630AF\n");
+		info("Sensor is an OV6630AF");
 	}
 
 	/* Set sensor-specific vars */
@@ -5097,10 +5091,10 @@ ks0127_configure(struct usb_ov511 *ov)
 			err("Error detecting sensor type");
 			return -1;
 		} else if ((rc & 0x0f) == 0) {
-			dev_info(&ov->dev->dev, "Sensor is a KS0127\n");
+			info("Sensor is a KS0127");
 			ov->sensor = SEN_KS0127;
 		} else if ((rc & 0x0f) == 9) {
-			dev_info(&ov->dev->dev, "Sensor is a KS0127B Rev. A\n");
+			info("Sensor is a KS0127B Rev. A");
 			ov->sensor = SEN_KS0127B;
 		}
 	} else {
@@ -5209,8 +5203,7 @@ saa7111a_configure(struct usb_ov511 *ov)
 		err("Error detecting sensor version");
 		return -1;
 	} else {
-		dev_info(&ov->dev->dev,
-			 "Sensor is an SAA7111A (version 0x%x)\n", rc);
+		info("Sensor is an SAA7111A (version 0x%x)", rc);
 		ov->sensor = SEN_SAA7111A;
 	}
 
@@ -5273,7 +5266,7 @@ ov511_configure(struct usb_ov511 *ov)
 
 	PDEBUG (1, "CustomID = %d", ov->customid);
 	ov->desc = symbolic(camlist, ov->customid);
-	dev_info(&ov->dev->dev, "model: %s\n", ov->desc);
+	info("model: %s", ov->desc);
 
 	if (0 == strcmp(ov->desc, NOT_DEFINED_STR)) {
 		err("Camera type (%d) not recognized", ov->customid);
@@ -5437,8 +5430,7 @@ ov518_configure(struct usb_ov511 *ov)
 	PDEBUG(4, "");
 
 	/* First 5 bits of custom ID reg are a revision ID on OV518 */
-	dev_info(&ov->dev->dev, "Device revision %d\n",
-		 0x1F & reg_r(ov, R511_SYS_CUST_ID));
+	info("Device revision %d", 0x1F & reg_r(ov, R511_SYS_CUST_ID));
 
 	/* Give it the default description */
 	ov->desc = symbolic(camlist, 0);
@@ -5786,8 +5778,7 @@ ov51x_probe(struct usb_interface *intf, 
 		goto error;
 	}
 
-	dev_info(&intf->dev, "USB %s video device found\n",
-		 symbolic(brglist, ov->bridge));
+	info("USB %s video device found", symbolic(brglist, ov->bridge));
 
 	init_waitqueue_head(&ov->wq);
 
@@ -5868,8 +5859,8 @@ ov51x_probe(struct usb_interface *intf, 
 		goto error;
 	}
 
-	dev_info(&intf->dev, "Device at %s registered to minor %d\n",
-		 ov->usb_path, ov->vdev->minor);
+	info("Device at %s registered to minor %d", ov->usb_path,
+	     ov->vdev->minor);
 
 	usb_set_intfdata(intf, ov);
 	if (ov_create_sysfs(ov->vdev)) {
@@ -5972,8 +5963,7 @@ usb_ov511_init(void)
 	if (retval)
 		goto out;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION " : " DRIVER_DESC);
 
 out:
 	return retval;
@@ -5983,7 +5973,8 @@ static void __exit
 usb_ov511_exit(void)
 {
 	usb_deregister(&ov511_driver);
-	printk(KERN_INFO KBUILD_MODNAME ": driver deregistered\n");
+	info("driver deregistered");
+
 }
 
 module_init(usb_ov511_init);
diff -puN drivers/media/video/ov511.h~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/ov511.h
--- a/drivers/media/video/ov511.h~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/ov511.h
@@ -12,8 +12,7 @@
 
 #ifdef OV511_DEBUG
 	#define PDEBUG(level, fmt, args...) \
-		if (debug >= (level))	\
-			printk(KERN_INFO KBUILD_MODNAME "[%s:%d] \n" fmt, \
+		if (debug >= (level)) info("[%s:%d] " fmt, \
 		__func__, __LINE__ , ## args)
 #else
 	#define PDEBUG(level, fmt, args...) do {} while(0)
diff -puN drivers/media/video/pvrusb2/pvrusb2-main.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/pvrusb2/pvrusb2-main.c
--- a/drivers/media/video/pvrusb2/pvrusb2-main.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/pvrusb2/pvrusb2-main.c
@@ -137,11 +137,9 @@ static int __init pvr_init(void)
 	ret = usb_register(&pvr_driver);
 
 	if (ret == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
-	if (pvrusb2_debug)
-		printk(KERN_INFO KBUILD_MODNAME ": Debug mask is %d (0x%x)\n",
-		       pvrusb2_debug,pvrusb2_debug);
+		info(DRIVER_DESC " : " DRIVER_VERSION);
+	if (pvrusb2_debug) info("Debug mask is %d (0x%x)",
+				pvrusb2_debug,pvrusb2_debug);
 
 	pvr2_trace(PVR2_TRACE_INIT,"pvr_init complete");
 
diff -puN drivers/media/video/se401.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/se401.c
--- a/drivers/media/video/se401.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/se401.c
@@ -288,7 +288,7 @@ static void se401_button_irq(struct urb 
 	int status;
 
 	if (!se401->dev) {
-		dev_info(&urb->dev->dev, "device vapourished\n");
+		info("ohoh: device vapourished");
 		return;
 	}
 
@@ -328,7 +328,7 @@ static void se401_video_irq(struct urb *
 		return;
 
 	if (!se401->dev) {
-		dev_info(&urb->dev->dev, "device vapourished\n");
+		info ("ohoh: device vapourished");
 		return;
 	}
 
@@ -375,7 +375,7 @@ static void se401_video_irq(struct urb *
 	urb->status=0;
 	urb->dev=se401->dev;
 	if(usb_submit_urb(urb, GFP_KERNEL))
-		dev_info(&urb->dev->dev, "urb burned down\n");
+		info("urb burned down");
 	return;
 }
 
@@ -860,8 +860,7 @@ static int se401_newframe(struct usb_se4
 		);
 		if (se401->nullpackets > SE401_MAX_NULLPACKETS) {
 			se401->nullpackets=0;
-			dev_info(&se401->dev->dev,
-				 "too many null length packets, restarting capture\n");
+			info("to many null length packets, restarting capture");
 			se401_stop_stream(se401);
 			se401_start_stream(se401);
 		} else {
@@ -881,8 +880,7 @@ static int se401_newframe(struct usb_se4
 				se401->scratch_use=0;
 			if (errors > SE401_MAX_ERRORS) {
 				errors=0;
-				dev_info(&se401->dev->dev,
-					 "too many errors, restarting capture\n");
+				info("to much errors, restarting capture");
 				se401_stop_stream(se401);
 				se401_start_stream(se401);
 			}
@@ -915,7 +913,7 @@ static void usb_se401_remove_disconnecte
 		usb_kill_urb(se401->inturb);
 		usb_free_urb(se401->inturb);
 	}
-	dev_info(&se401->dev->dev, "%s disconnected", se401->camera_name);
+	info("%s disconnected", se401->camera_name);
 
 	/* Free the memory */
 	kfree(se401->width);
@@ -962,8 +960,8 @@ static int se401_close(struct inode *ino
 
 	rvfree(se401->fbuf, se401->maxframesize * SE401_NUMFRAMES);
 	if (se401->removed) {
-		dev_info(&se401->dev->dev, "device unregistered\n");
 		usb_se401_remove_disconnected(se401);
+		info("device unregistered");
 	} else {
 		for (i=0; i<SE401_NUMFRAMES; i++)
 			se401->frame[i].grabstate=FRAME_UNUSED;
@@ -1278,7 +1276,7 @@ static int se401_init(struct usb_se401 *
 	for (i=0; i<se401->sizes; i++) {
 		sprintf(temp, "%s %dx%d", temp, se401->width[i], se401->height[i]);
 	}
-	dev_info(&se401->dev->dev, "%s\n", temp);
+	info("%s", temp);
 	se401->maxframesize=se401->width[se401->sizes-1]*se401->height[se401->sizes-1]*3;
 
 	rc=se401_sndctrl(0, se401, SE401_REQ_GET_WIDTH, 0, cp, sizeof(cp));
@@ -1312,8 +1310,7 @@ static int se401_init(struct usb_se401 *
 	if (button) {
 		se401->inturb=usb_alloc_urb(0, GFP_KERNEL);
 		if (!se401->inturb) {
-			dev_info(&se401->dev->dev,
-				 "Allocation of inturb failed\n");
+			info("Allocation of inturb failed");
 			return 1;
 		}
 		usb_fill_int_urb(se401->inturb, se401->dev,
@@ -1324,7 +1321,7 @@ static int se401_init(struct usb_se401 *
 		    8
 		);
 		if (usb_submit_urb(se401->inturb, GFP_KERNEL)) {
-			dev_info(&se401->dev->dev, "int urb burned down\n");
+			info("int urb burned down");
 			return 1;
 		}
 	} else
@@ -1381,7 +1378,7 @@ static int se401_probe(struct usb_interf
 		return -ENODEV;
 
 	/* We found one */
-	dev_info(&intf->dev, "SE401 camera found: %s\n", camera_name);
+	info("SE401 camera found: %s", camera_name);
 
 	if ((se401 = kzalloc(sizeof(*se401), GFP_KERNEL)) == NULL) {
 		err("couldn't kmalloc se401 struct");
@@ -1392,8 +1389,7 @@ static int se401_probe(struct usb_interf
 	se401->iface = interface->bInterfaceNumber;
 	se401->camera_name = camera_name;
 
-	dev_info(&intf->dev, "firmware version: %02x\n",
-		 le16_to_cpu(dev->descriptor.bcdDevice) & 255);
+	info("firmware version: %02x", le16_to_cpu(dev->descriptor.bcdDevice) & 255);
 
 	if (se401_init(se401, button)) {
 		kfree(se401);
@@ -1411,8 +1407,7 @@ static int se401_probe(struct usb_interf
 		err("video_register_device failed");
 		return -EIO;
 	}
-	dev_info(&intf->dev, "registered new video device: video%d\n",
-		 se401->vdev.minor);
+	info("registered new video device: video%d", se401->vdev.minor);
 
 	usb_set_intfdata (intf, se401);
 	return 0;
@@ -1456,10 +1451,10 @@ static struct usb_driver se401_driver = 
 
 static int __init usb_se401_init(void)
 {
-	printk(KERN_INFO "SE401 usb camera driver version %s registering\n", version);
+	info("SE401 usb camera driver version %s registering", version);
 	if (flickerless)
 		if (flickerless!=50 && flickerless!=60) {
-			printk(KERN_ERR "Invallid flickerless value, use 0, 50 or 60.\n");
+			info("Invallid flickerless value, use 0, 50 or 60.");
 			return -1;
 	}
 	return usb_register(&se401_driver);
@@ -1468,7 +1463,7 @@ static int __init usb_se401_init(void)
 static void __exit usb_se401_exit(void)
 {
 	usb_deregister(&se401_driver);
-	printk(KERN_INFO "SE401 driver deregistered\frame");
+	info("SE401 driver deregistered");
 }
 
 module_init(usb_se401_init);
diff -puN drivers/media/video/stv680.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/stv680.c
--- a/drivers/media/video/stv680.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/stv680.c
@@ -84,8 +84,7 @@ static unsigned int debug;
 #define PDEBUG(level, fmt, args...) \
 	do { \
 	if (debug >= level)	\
-		printk(KERN_INFO KBUILD_MODNAME " [%s:%d] \n" fmt,	\
-			__func__, __LINE__ , ## args);	\
+		info("[%s:%d] " fmt, __func__, __LINE__ , ## args);	\
 	} while (0)
 
 
@@ -1553,8 +1552,7 @@ static int __init usb_stv680_init (void)
 	}
 	PDEBUG (0, "STV(i): usb camera driver version %s registering", DRIVER_VERSION);
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 }
 
diff -puN drivers/media/video/usbvideo/ibmcam.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/usbvideo/ibmcam.c
--- a/drivers/media/video/usbvideo/ibmcam.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/usbvideo/ibmcam.c
@@ -258,9 +258,7 @@ static enum ParseState ibmcam_find_heade
 			    (RING_QUEUE_PEEK(&uvd->dp, 2) == 0x00))
 			{
 #if 0				/* This code helps to detect new frame markers */
-				dev_info(&uvd->dev->dev,
-					 "Header sig: 00 FF 00 %02X\n",
-					 RING_QUEUE_PEEK(&uvd->dp, 3));
+				info("Header sig: 00 FF 00 %02X", RING_QUEUE_PEEK(&uvd->dp, 3));
 #endif
 				frame->header = RING_QUEUE_PEEK(&uvd->dp, 3);
 				if ((frame->header == HDRSIG_MODEL1_128x96) ||
@@ -268,8 +266,7 @@ static enum ParseState ibmcam_find_heade
 				    (frame->header == HDRSIG_MODEL1_352x288))
 				{
 #if 0
-					dev_info(&uvd->dev->dev,
-						 "Header found.\n");
+					info("Header found.");
 #endif
 					RING_QUEUE_DEQUEUE_BYTES(&uvd->dp, marker_len);
 					icam->has_hdr = 1;
@@ -298,7 +295,7 @@ case IBMCAM_MODEL_4:
 			    (RING_QUEUE_PEEK(&uvd->dp, 1) == 0xFF))
 			{
 #if 0
-				dev_info(&uvd->dev->dev, "Header found.\n");
+				info("Header found.");
 #endif
 				RING_QUEUE_DEQUEUE_BYTES(&uvd->dp, marker_len);
 				icam->has_hdr = 1;
@@ -341,7 +338,7 @@ case IBMCAM_MODEL_4:
 				byte4 = RING_QUEUE_PEEK(&uvd->dp, 3);
 				frame->header = (byte3 << 8) | byte4;
 #if 0
-				dev_info(&uvd->dev->dev, "Header found.\n");
+				info("Header found.");
 #endif
 				RING_QUEUE_DEQUEUE_BYTES(&uvd->dp, marker_len);
 				icam->has_hdr = 1;
@@ -357,8 +354,7 @@ case IBMCAM_MODEL_4:
 	}
 	if (!icam->has_hdr) {
 		if (uvd->debug > 2)
-			dev_info(&uvd->dev->dev,
-				 "Skipping frame, no header\n");
+			info("Skipping frame, no header");
 		return scan_EndParse;
 	}
 
@@ -885,9 +881,7 @@ static enum ParseState ibmcam_model3_par
 	 */
 	if ((frame->curline + 1) >= data_h) {
 		if (uvd->debug >= 3)
-			dev_info(&uvd->dev->dev,
-				 "Reached line %d. (frame is done)\n",
-				 frame->curline);
+			info("Reached line %d. (frame is done)", frame->curline);
 		return scan_NextFrame;
 	}
 
@@ -960,9 +954,8 @@ static enum ParseState ibmcam_model3_par
 
 	if (frame->curline >= VIDEOSIZE_Y(frame->request)) {
 		if (uvd->debug >= 3) {
-			dev_info(&uvd->dev->dev,
-				 "All requested lines (%ld.) done.\n",
-				 VIDEOSIZE_Y(frame->request));
+			info("All requested lines (%ld.) done.",
+			     VIDEOSIZE_Y(frame->request));
 		}
 		return scan_NextFrame;
 	} else
@@ -1007,9 +1000,7 @@ static enum ParseState ibmcam_model4_128
 	 */
 	if ((frame->curline + 1) >= data_h) {
 		if (uvd->debug >= 3)
-			dev_info(&uvd->dev->dev,
-				 "Reached line %d. (frame is done)\n",
-				 frame->curline);
+			info("Reached line %d. (frame is done)", frame->curline);
 		return scan_NextFrame;
 	}
 
@@ -1058,9 +1049,8 @@ static enum ParseState ibmcam_model4_128
 
 	if (frame->curline >= VIDEOSIZE_Y(frame->request)) {
 		if (uvd->debug >= 3) {
-			dev_info(&uvd->dev->dev,
-				 "All requested lines (%ld.) done.\n",
-				 VIDEOSIZE_Y(frame->request));
+			info("All requested lines (%ld.) done.",
+			     VIDEOSIZE_Y(frame->request));
 		}
 		return scan_NextFrame;
 	} else
@@ -1181,11 +1171,10 @@ static int ibmcam_veio(
 			sizeof(cp),
 			1000);
 #if 0
-		dev_info(&uvd->dev->dev,
-			 "USB => %02x%02x%02x%02x%02x%02x%02x%02x "
-			 "(req=$%02x val=$%04x ind=$%04x)\n",
-			 cp[0],cp[1],cp[2],cp[3],cp[4],cp[5],cp[6],cp[7],
-			 req, value, index);
+		info("USB => %02x%02x%02x%02x%02x%02x%02x%02x "
+		       "(req=$%02x val=$%04x ind=$%04x)",
+		       cp[0],cp[1],cp[2],cp[3],cp[4],cp[5],cp[6],cp[7],
+		       req, value, index);
 #endif
 	} else {
 		i = usb_control_msg(
@@ -1460,9 +1449,10 @@ static void ibmcam_adjust_contrast(struc
  */
 static void ibmcam_change_lighting_conditions(struct uvd *uvd)
 {
+	static const char proc[] = "ibmcam_change_lighting_conditions";
+
 	if (debug > 0)
-		dev_info(&uvd->dev->dev,
-			 "%s: Set lighting to %hu.\n", __func__, lighting);
+		info("%s: Set lighting to %hu.", proc, lighting);
 
 	switch (IBMCAM_T(uvd)->camera_model) {
 	case IBMCAM_MODEL_1:
@@ -1505,6 +1495,8 @@ static void ibmcam_change_lighting_condi
  */
 static void ibmcam_set_sharpness(struct uvd *uvd)
 {
+	static const char proc[] = "ibmcam_set_sharpness";
+
 	switch (IBMCAM_T(uvd)->camera_model) {
 	case IBMCAM_MODEL_1:
 	{
@@ -1513,8 +1505,7 @@ static void ibmcam_set_sharpness(struct 
 
 		RESTRICT_TO_RANGE(sharpness, SHARPNESS_MIN, SHARPNESS_MAX);
 		if (debug > 0)
-			dev_info(&uvd->dev->dev, "%s: Set sharpness to %hu.\n",
-				 __func__, sharpness);
+			info("%s: Set sharpness to %hu.", proc, sharpness);
 
 		sv = sa[sharpness - SHARPNESS_MIN];
 		for (i=0; i < 2; i++) {
@@ -1573,11 +1564,11 @@ static void ibmcam_set_sharpness(struct 
  */
 static void ibmcam_set_brightness(struct uvd *uvd)
 {
+	static const char proc[] = "ibmcam_set_brightness";
 	static const unsigned short n = 1;
 
 	if (debug > 0)
-		dev_info(&uvd->dev->dev, "%s: Set brightness to %hu.\n",
-			 __func__, uvd->vpic.brightness);
+		info("%s: Set brightness to %hu.", proc, uvd->vpic.brightness);
 
 	switch (IBMCAM_T(uvd)->camera_model) {
 	case IBMCAM_MODEL_1:
@@ -2124,8 +2115,7 @@ static void ibmcam_model2_setup_after_vi
 			break;
 		}
 		if (uvd->debug > 0)
-			dev_info(&uvd->dev->dev, "Framerate (hardware): %hd.\n",
-				 hw_fps);
+			info("Framerate (hardware): %hd.", hw_fps);
 		RESTRICT_TO_RANGE(hw_fps, 0, 31);
 		ibmcam_model2_Packet1(uvd, mod2_set_framerate, hw_fps);
 	}
@@ -3497,7 +3487,7 @@ static void ibmcam_model3_setup_after_vi
 	/* 01.01.08 - Added for RCA video in support -LO */
 	if(init_model3_input) {
 		if (debug > 0)
-			dev_info(&uvd->dev->dev, "Setting input to RCA.\n");
+			info("Setting input to RCA.");
 		for (i=0; i < ARRAY_SIZE(initData); i++) {
 			ibmcam_veio(uvd, initData[i].req, initData[i].value, initData[i].index);
 		}
@@ -3695,7 +3685,7 @@ static int ibmcam_probe(struct usb_inter
 	unsigned char video_ep = 0;
 
 	if (debug >= 1)
-		dev_info(&uvd->dev->dev, "ibmcam_probe(%p,%u.)\n", intf, ifnum);
+		info("ibmcam_probe(%p,%u.)", intf, ifnum);
 
 	/* We don't handle multi-config cameras */
 	if (dev->descriptor.bNumConfigurations != 1)
@@ -3746,16 +3736,14 @@ static int ibmcam_probe(struct usb_inter
 			brand = "IBM PC Camera"; /* a.k.a. Xirlink C-It */
 			break;
 		}
-		dev_info(&uvd->dev->dev,
-			 "%s USB camera found (model %d, rev. 0x%04x)\n",
-			 brand, model, le16_to_cpu(dev->descriptor.bcdDevice));
+		info("%s USB camera found (model %d, rev. 0x%04x)",
+		     brand, model, le16_to_cpu(dev->descriptor.bcdDevice));
 	} while (0);
 
 	/* Validate found interface: must have one ISO endpoint */
 	nas = intf->num_altsetting;
 	if (debug > 0)
-		dev_info(&uvd->dev->dev, "Number of alternate settings=%d.\n",
-			 nas);
+		info("Number of alternate settings=%d.", nas);
 	if (nas < 2) {
 		err("Too few alternate settings for this camera!");
 		return -ENODEV;
@@ -3799,9 +3787,7 @@ static int ibmcam_probe(struct usb_inter
 				actInterface = i;
 				maxPS = le16_to_cpu(endpoint->wMaxPacketSize);
 				if (debug > 0)
-					dev_info(&uvd->dev->dev,
-						 "Active setting=%d. "
-						 "maxPS=%d.\n", i, maxPS);
+					info("Active setting=%d. maxPS=%d.", i, maxPS);
 			} else
 				err("More than one active alt. setting! Ignoring #%d.", i);
 		}
@@ -3840,7 +3826,7 @@ static int ibmcam_probe(struct usb_inter
 			RESTRICT_TO_RANGE(framerate, 0, 5);
 			break;
 		default:
-			dev_info(&uvd->dev->dev, "IBM camera: using 320x240\n");
+			info("IBM camera: using 320x240");
 			size = SIZE_320x240;
 			/* No break here */
 		case SIZE_320x240:
@@ -3869,7 +3855,7 @@ static int ibmcam_probe(struct usb_inter
 			canvasY = 120;
 			break;
 		default:
-			dev_info(&uvd->dev->dev, "IBM NetCamera: using 176x144\n");
+			info("IBM NetCamera: using 176x144");
 			size = SIZE_176x144;
 			/* No break here */
 		case SIZE_176x144:
diff -puN drivers/media/video/usbvideo/konicawc.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/usbvideo/konicawc.c
--- a/drivers/media/video/usbvideo/konicawc.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/usbvideo/konicawc.c
@@ -339,8 +339,7 @@ static int konicawc_compress_iso(struct 
 		}
 
 		if((sts > 0x01) && (sts < 0x80)) {
-			dev_info(&uvd->dev->dev, "unknown status %2.2x\n",
-				 sts);
+			info("unknown status %2.2x", sts);
 			bad++;
 			continue;
 		}
@@ -571,12 +570,8 @@ static void konicawc_process_isoc(struct
 					fdrops = (0x80 + curframe - cam->lastframe) & 0x7F;
 					fdrops--;
 					if(fdrops) {
-						dev_info(&uvd->dev->dev,
-							 "Dropped %d frames "
-							 "(%d -> %d)\n",
-							 fdrops,
-							 cam->lastframe,
-							 curframe);
+						info("Dropped %d frames (%d -> %d)", fdrops,
+						     cam->lastframe, curframe);
 					}
 				}
 				cam->lastframe = curframe;
@@ -791,8 +786,7 @@ static int konicawc_probe(struct usb_int
 	if (dev->descriptor.bNumConfigurations != 1)
 		return -ENODEV;
 
-	dev_info(&intf->dev, "Konica Webcam (rev. 0x%04x)\n",
-		 le16_to_cpu(dev->descriptor.bcdDevice));
+	info("Konica Webcam (rev. 0x%04x)", le16_to_cpu(dev->descriptor.bcdDevice));
 	RESTRICT_TO_RANGE(speed, 0, MAX_SPEED);
 
 	/* Validate found interface: must have one ISO endpoint */
@@ -933,8 +927,7 @@ static struct usb_device_id id_table[] =
 static int __init konicawc_init(void)
 {
 	struct usbvideo_cb cbTbl;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	memset(&cbTbl, 0, sizeof(cbTbl));
 	cbTbl.probe = konicawc_probe;
 	cbTbl.setupOnOpen = konicawc_setup_on_open;
diff -puN drivers/media/video/usbvideo/quickcam_messenger.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/usbvideo/quickcam_messenger.c
--- a/drivers/media/video/usbvideo/quickcam_messenger.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -1082,8 +1082,7 @@ static struct usbvideo_cb qcm_driver = {
 
 static int __init qcm_init(void)
 {
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 
 	return usbvideo_register(
 		&cams,
diff -puN drivers/media/video/usbvideo/ultracam.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/usbvideo/ultracam.c
--- a/drivers/media/video/usbvideo/ultracam.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/usbvideo/ultracam.c
@@ -156,11 +156,10 @@ static int ultracam_veio(
 			sizeof(cp),
 			1000);
 #if 1
-		dev_info(&uvd->dev->dev,
-			 "USB => %02x%02x%02x%02x%02x%02x%02x%02x "
-			 "(req=$%02x val=$%04x ind=$%04x)\n",
-			 cp[0],cp[1],cp[2],cp[3],cp[4],cp[5],cp[6],cp[7],
-			 req, value, index);
+		info("USB => %02x%02x%02x%02x%02x%02x%02x%02x "
+		       "(req=$%02x val=$%04x ind=$%04x)",
+		       cp[0],cp[1],cp[2],cp[3],cp[4],cp[5],cp[6],cp[7],
+		       req, value, index);
 #endif
 	} else {
 		i = usb_control_msg(
@@ -518,20 +517,19 @@ static int ultracam_probe(struct usb_int
 	unsigned char video_ep = 0;
 
 	if (debug >= 1)
-		dev_info(&intf->dev, "ultracam_probe\n");
+		info("ultracam_probe(%p)", intf);
 
 	/* We don't handle multi-config cameras */
 	if (dev->descriptor.bNumConfigurations != 1)
 		return -ENODEV;
 
-	dev_info(&intf->dev, "IBM Ultra camera found (rev. 0x%04x)\n",
-		 le16_to_cpu(dev->descriptor.bcdDevice));
+	info("IBM Ultra camera found (rev. 0x%04x)",
+		le16_to_cpu(dev->descriptor.bcdDevice));
 
 	/* Validate found interface: must have one ISO endpoint */
 	nas = intf->num_altsetting;
 	if (debug > 0)
-		dev_info(&intf->dev, "Number of alternate settings=%d.\n",
-			 nas);
+		info("Number of alternate settings=%d.", nas);
 	if (nas < 8) {
 		err("Too few alternate settings for this camera!");
 		return -ENODEV;
@@ -578,9 +576,7 @@ static int ultracam_probe(struct usb_int
 				actInterface = i;
 				maxPS = le16_to_cpu(endpoint->wMaxPacketSize);
 				if (debug > 0)
-					dev_info(&intf->dev,
-						 "Active setting=%d. "
-						 "maxPS=%d.\n", i, maxPS);
+					info("Active setting=%d. maxPS=%d.", i, maxPS);
 			} else {
 				/* Got another active alt. setting */
 				if (maxPS < le16_to_cpu(endpoint->wMaxPacketSize)) {
@@ -588,11 +584,8 @@ static int ultracam_probe(struct usb_int
 					actInterface = i;
 					maxPS = le16_to_cpu(endpoint->wMaxPacketSize);
 					if (debug > 0) {
-						dev_info(&intf->dev,
-							 "Even better ctive "
-							 "setting=%d. "
-							 "maxPS=%d.\n",
-							 i, maxPS);
+						info("Even better ctive setting=%d. maxPS=%d.",
+						     i, maxPS);
 					}
 				}
 			}
diff -puN drivers/media/video/usbvideo/usbvideo.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/usbvideo/usbvideo.c
--- a/drivers/media/video/usbvideo/usbvideo.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/usbvideo/usbvideo.c
@@ -468,9 +468,8 @@ static void usbvideo_ReportStatistics(co
 			percent = (100 * goodPackets) / allPackets;
 		else
 			percent = goodPackets / (allPackets / 100);
-		dev_info(&uvd->dev->dev,
-			 "Packet Statistics: Total=%lu. Empty=%lu. Usage=%lu%%\n",
-			 allPackets, badPackets, percent);
+		info("Packet Statistics: Total=%lu. Empty=%lu. Usage=%lu%%",
+		     allPackets, badPackets, percent);
 		if (uvd->iso_packet_len > 0) {
 			unsigned long allBytes, xferBytes;
 			char multiplier = ' ';
@@ -498,9 +497,8 @@ static void usbvideo_ReportStatistics(co
 					}
 				}
 			}
-			dev_info(&uvd->dev->dev,
-				 "Transfer Statistics: Transferred=%lu%cB Usage=%lu%%\n",
-				 xferBytes, multiplier, percent);
+			info("Transfer Statistics: Transferred=%lu%cB Usage=%lu%%",
+			     xferBytes, multiplier, percent);
 		}
 	}
 }
@@ -547,7 +545,7 @@ void usbvideo_TestPattern(struct uvd *uv
 	{	/* For debugging purposes only */
 		char tmp[20];
 		usbvideo_VideosizeToString(tmp, sizeof(tmp), frame->request);
-		dev_info(&uvd->dev->dev, "testpattern: frame=%s\n", tmp);
+		info("testpattern: frame=%s", tmp);
 	}
 #endif
 	/* Form every scan line */
@@ -856,7 +854,7 @@ static void usbvideo_Disconnect(struct u
 
 	usbvideo_ClientIncModCount(uvd);
 	if (uvd->debug > 0)
-		dev_info(&intf->dev, "%s(%p.)\n", __func__, intf);
+		info("%s(%p.)", __func__, intf);
 
 	mutex_lock(&uvd->lock);
 	uvd->remove_pending = 1; /* Now all ISO data will be ignored */
@@ -872,15 +870,14 @@ static void usbvideo_Disconnect(struct u
 
 	video_unregister_device(&uvd->vdev);
 	if (uvd->debug > 0)
-		dev_info(&intf->dev, "%s: Video unregistered.\n", __func__);
+		info("%s: Video unregistered.", __func__);
 
 	if (uvd->user)
-		dev_info(&intf->dev, "%s: In use, disconnect pending.\n",
-			 __func__);
+		info("%s: In use, disconnect pending.", __func__);
 	else
 		usbvideo_CameraRelease(uvd);
 	mutex_unlock(&uvd->lock);
-	dev_info(&intf->dev, "USB camera disconnected.\n");
+	info("USB camera disconnected.");
 
 	usbvideo_ClientDecModCount(uvd);
 }
@@ -1018,17 +1015,14 @@ int usbvideo_RegisterVideoDevice(struct 
 		return -EINVAL;
 	}
 	if (uvd->video_endp == 0) {
-		dev_info(&uvd->dev->dev,
-			 "%s: No video endpoint specified; data pump disabled.\n",
-			 __func__);
+		info("%s: No video endpoint specified; data pump disabled.", __func__);
 	}
 	if (uvd->paletteBits == 0) {
 		err("%s: No palettes specified!", __func__);
 		return -EINVAL;
 	}
 	if (uvd->defaultPalette == 0) {
-		dev_info(&uvd->dev->dev, "%s: No default palette!\n",
-			 __func__);
+		info("%s: No default palette!", __func__);
 	}
 
 	uvd->max_frame_size = VIDEOSIZE_X(uvd->canvas) *
@@ -1037,10 +1031,8 @@ int usbvideo_RegisterVideoDevice(struct 
 	usbvideo_VideosizeToString(tmp2, sizeof(tmp2), uvd->canvas);
 
 	if (uvd->debug > 0) {
-		dev_info(&uvd->dev->dev,
-			 "%s: iface=%d. endpoint=$%02x paletteBits=$%08lx\n",
-			 __func__, uvd->iface, uvd->video_endp,
-			 uvd->paletteBits);
+		info("%s: iface=%d. endpoint=$%02x paletteBits=$%08lx",
+		     __func__, uvd->iface, uvd->video_endp, uvd->paletteBits);
 	}
 	if (uvd->dev == NULL) {
 		err("%s: uvd->dev == NULL", __func__);
@@ -1053,13 +1045,12 @@ int usbvideo_RegisterVideoDevice(struct 
 		return -EPIPE;
 	}
 	if (uvd->debug > 1) {
-		dev_info(&uvd->dev->dev,
-			 "%s: video_register_device() successful\n", __func__);
+		info("%s: video_register_device() successful", __func__);
 	}
 
-	dev_info(&uvd->dev->dev, "%s on /dev/video%d: canvas=%s videosize=%s\n",
-		 (uvd->handle != NULL) ? uvd->handle->drvName : "???",
-		 uvd->vdev.minor, tmp2, tmp1);
+	info("%s on /dev/video%d: canvas=%s videosize=%s",
+	     (uvd->handle != NULL) ? uvd->handle->drvName : "???",
+	     uvd->vdev.minor, tmp2, tmp1);
 
 	usb_get_dev(uvd->dev);
 	return 0;
@@ -1121,7 +1112,7 @@ static int usbvideo_v4l_open(struct inod
 	int i, errCode = 0;
 
 	if (uvd->debug > 1)
-		dev_info(&uvd->dev->dev, "%s($%p)\n", __func__, dev);
+		info("%s($%p)", __func__, dev);
 
 	if (0 < usbvideo_ClientIncModCount(uvd))
 		return -ENODEV;
@@ -1188,25 +1179,19 @@ static int usbvideo_v4l_open(struct inod
 		if (errCode == 0) {
 			if (VALID_CALLBACK(uvd, setupOnOpen)) {
 				if (uvd->debug > 1)
-					dev_info(&uvd->dev->dev,
-						 "%s: setupOnOpen callback\n",
-						 __func__);
+					info("%s: setupOnOpen callback", __func__);
 				errCode = GET_CALLBACK(uvd, setupOnOpen)(uvd);
 				if (errCode < 0) {
 					err("%s: setupOnOpen callback failed (%d.).",
 					    __func__, errCode);
 				} else if (uvd->debug > 1) {
-					dev_info(&uvd->dev->dev,
-						 "%s: setupOnOpen callback successful\n",
-						 __func__);
+					info("%s: setupOnOpen callback successful", __func__);
 				}
 			}
 			if (errCode == 0) {
 				uvd->settingsAdjusted = 0;
 				if (uvd->debug > 1)
-					dev_info(&uvd->dev->dev,
-						 "%s: Open succeeded.\n",
-						 __func__);
+					info("%s: Open succeeded.", __func__);
 				uvd->user++;
 				file->private_data = uvd;
 			}
@@ -1216,8 +1201,7 @@ static int usbvideo_v4l_open(struct inod
 	if (errCode != 0)
 		usbvideo_ClientDecModCount(uvd);
 	if (uvd->debug > 0)
-		dev_info(&uvd->dev->dev, "%s: Returning %d.\n", __func__,
-			 errCode);
+		info("%s: Returning %d.", __func__, errCode);
 	return errCode;
 }
 
@@ -1240,7 +1224,7 @@ static int usbvideo_v4l_close(struct ino
 	int i;
 
 	if (uvd->debug > 1)
-		dev_info(&uvd->dev->dev, "%s($%p)\n", __func__, dev);
+		info("%s($%p)", __func__, dev);
 
 	mutex_lock(&uvd->lock);
 	GET_CALLBACK(uvd, stopDataPump)(uvd);
@@ -1260,15 +1244,14 @@ static int usbvideo_v4l_close(struct ino
 	uvd->user--;
 	if (uvd->remove_pending) {
 		if (uvd->debug > 0)
-			dev_info(&uvd->dev->dev, "%s: Final disconnect.\n",
-				 __func__);
+			info("usbvideo_v4l_close: Final disconnect.");
 		usbvideo_CameraRelease(uvd);
 	}
 	mutex_unlock(&uvd->lock);
 	usbvideo_ClientDecModCount(uvd);
 
 	if (uvd->debug > 1)
-		dev_info(&uvd->dev->dev, "%s: Completed.\n", __func__);
+		info("%s: Completed.", __func__);
 	file->private_data = NULL;
 	return 0;
 }
@@ -1382,9 +1365,8 @@ static int usbvideo_v4l_do_ioctl(struct 
 			struct video_mmap *vm = arg;
 
 			if (uvd->debug >= 1) {
-				dev_info(&uvd->dev->dev,
-					 "VIDIOCMCAPTURE: frame=%d. size=%dx%d, format=%d.\n",
-					 vm->frame, vm->width, vm->height, vm->format);
+				info("VIDIOCMCAPTURE: frame=%d. size=%dx%d, format=%d.",
+				     vm->frame, vm->width, vm->height, vm->format);
 			}
 			/*
 			 * Check if the requested size is supported. If the requestor
@@ -1402,24 +1384,18 @@ static int usbvideo_v4l_do_ioctl(struct 
 			if ((vm->width > VIDEOSIZE_X(uvd->canvas)) ||
 			    (vm->height > VIDEOSIZE_Y(uvd->canvas))) {
 				if (uvd->debug > 0) {
-					dev_info(&uvd->dev->dev,
-						 "VIDIOCMCAPTURE: Size=%dx%d "
-						 "too large; allowed only up "
-						 "to %ldx%ld\n", vm->width,
-						 vm->height,
-						 VIDEOSIZE_X(uvd->canvas),
-						 VIDEOSIZE_Y(uvd->canvas));
+					info("VIDIOCMCAPTURE: Size=%dx%d too large; "
+					     "allowed only up to %ldx%ld", vm->width, vm->height,
+					     VIDEOSIZE_X(uvd->canvas), VIDEOSIZE_Y(uvd->canvas));
 				}
 				return -EINVAL;
 			}
 			/* Check if the palette is supported */
 			if (((1L << vm->format) & uvd->paletteBits) == 0) {
 				if (uvd->debug > 0) {
-					dev_info(&uvd->dev->dev,
-						 "VIDIOCMCAPTURE: format=%d. "
-						 "not supported "
-						 "(paletteBits=$%08lx)\n",
-						 vm->format, uvd->paletteBits);
+					info("VIDIOCMCAPTURE: format=%d. not supported"
+					     " (paletteBits=$%08lx)",
+					     vm->format, uvd->paletteBits);
 				}
 				return -EINVAL;
 			}
@@ -1447,9 +1423,7 @@ static int usbvideo_v4l_do_ioctl(struct 
 				return -EINVAL;
 
 			if (uvd->debug >= 1)
-				dev_info(&uvd->dev->dev,
-					 "VIDIOCSYNC: syncing to frame %d.\n",
-					 *frameNum);
+				info("VIDIOCSYNC: syncing to frame %d.", *frameNum);
 			if (uvd->flags & FLAGS_NO_DECODING)
 				ret = usbvideo_GetFrame(uvd, *frameNum);
 			else if (VALID_CALLBACK(uvd, getFrame)) {
@@ -1531,9 +1505,7 @@ static ssize_t usbvideo_v4l_read(struct 
 		return -EFAULT;
 
 	if (uvd->debug >= 1)
-		dev_info(&uvd->dev->dev,
-			 "%s: %Zd. bytes, noblock=%d.\n",
-			 __func__, count, noblock);
+		info("%s: %Zd. bytes, noblock=%d.", __func__, count, noblock);
 
 	mutex_lock(&uvd->lock);
 
@@ -1714,21 +1686,18 @@ static void usbvideo_IsocIrq(struct urb 
 		return;
 #if 0
 	if (urb->actual_length > 0) {
-		dev_info(&uvd->dev->dev,
-			 "urb=$%p status=%d. errcount=%d. length=%d.\n",
-			 urb, urb->status, urb->error_count,
-			 urb->actual_length);
+		info("urb=$%p status=%d. errcount=%d. length=%d.",
+		     urb, urb->status, urb->error_count, urb->actual_length);
 	} else {
 		static int c = 0;
 		if (c++ % 100 == 0)
-			dev_info(&uvd->dev->dev, "No Isoc data\n");
+			info("No Isoc data");
 	}
 #endif
 
 	if (!uvd->streaming) {
 		if (uvd->debug >= 1)
-			dev_info(&uvd->dev->dev,
-				 "Not streaming, but interrupt!\n");
+			info("Not streaming, but interrupt!");
 		return;
 	}
 
@@ -1773,7 +1742,7 @@ static int usbvideo_StartDataPump(struct
 	int i, errFlag;
 
 	if (uvd->debug > 1)
-		dev_info(&uvd->dev->dev, "%s($%p)\n", __func__, uvd);
+		info("%s($%p)", __func__, uvd);
 
 	if (!CAMERA_IS_OPERATIONAL(uvd)) {
 		err("%s: Camera is not operational", __func__);
@@ -1821,9 +1790,7 @@ static int usbvideo_StartDataPump(struct
 
 	uvd->streaming = 1;
 	if (uvd->debug > 1)
-		dev_info(&uvd->dev->dev,
-			 "%s: streaming=1 video_endp=$%02x\n", __func__,
-			 uvd->video_endp);
+		info("%s: streaming=1 video_endp=$%02x", __func__, uvd->video_endp);
 	return 0;
 }
 
@@ -1845,14 +1812,14 @@ static void usbvideo_StopDataPump(struct
 		return;
 
 	if (uvd->debug > 1)
-		dev_info(&uvd->dev->dev, "%s($%p)\n", __func__, uvd);
+		info("%s($%p)", __func__, uvd);
 
 	/* Unschedule all of the iso td's */
 	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
 		usb_kill_urb(uvd->sbuf[i].urb);
 	}
 	if (uvd->debug > 1)
-		dev_info(&uvd->dev->dev, "%s: streaming=0\n", __func__);
+		info("%s: streaming=0", __func__);
 	uvd->streaming = 0;
 
 	if (!uvd->remove_pending) {
@@ -1884,8 +1851,7 @@ static int usbvideo_NewFrame(struct uvd 
 	int n;
 
 	if (uvd->debug > 1)
-		dev_info(&uvd->dev->dev, "usbvideo_NewFrame($%p,%d.)\n", uvd,
-			 framenum);
+		info("usbvideo_NewFrame($%p,%d.)", uvd, framenum);
 
 	/* If we're not grabbing a frame right now and the other frame is */
 	/*  ready to be grabbed into, then use it instead */
@@ -1990,14 +1956,12 @@ static int usbvideo_GetFrame(struct uvd 
 	struct usbvideo_frame *frame = &uvd->frame[frameNum];
 
 	if (uvd->debug >= 2)
-		dev_info(&uvd->dev->dev, "%s($%p,%d.)\n", __func__, uvd,
-			 frameNum);
+		info("%s($%p,%d.)", __func__, uvd, frameNum);
 
 	switch (frame->frameState) {
 	case FrameState_Unused:
 		if (uvd->debug >= 2)
-			dev_info(&uvd->dev->dev, "%s: FrameState_Unused\n",
-				 __func__);
+			info("%s: FrameState_Unused", __func__);
 		return -EINVAL;
 	case FrameState_Ready:
 	case FrameState_Grabbing:
@@ -2007,9 +1971,7 @@ static int usbvideo_GetFrame(struct uvd 
 	redo:
 		if (!CAMERA_IS_OPERATIONAL(uvd)) {
 			if (uvd->debug >= 2)
-				dev_info(&uvd->dev->dev,
-					 "%s: Camera is not operational (1)\n",
-					 __func__);
+				info("%s: Camera is not operational (1)", __func__);
 			return -EIO;
 		}
 		ntries = 0;
@@ -2018,33 +1980,24 @@ static int usbvideo_GetFrame(struct uvd 
 			signalPending = signal_pending(current);
 			if (!CAMERA_IS_OPERATIONAL(uvd)) {
 				if (uvd->debug >= 2)
-					dev_info(&uvd->dev->dev,
-						 "%s: Camera is not "
-						 "operational (2)\n", __func__);
+					info("%s: Camera is not operational (2)", __func__);
 				return -EIO;
 			}
 			assert(uvd->fbuf != NULL);
 			if (signalPending) {
 				if (uvd->debug >= 2)
-					dev_info(&uvd->dev->dev,
-					"%s: Signal=$%08x\n", __func__,
-					signalPending);
+					info("%s: Signal=$%08x", __func__, signalPending);
 				if (uvd->flags & FLAGS_RETRY_VIDIOCSYNC) {
 					usbvideo_TestPattern(uvd, 1, 0);
 					uvd->curframe = -1;
 					uvd->stats.frame_num++;
 					if (uvd->debug >= 2)
-						dev_info(&uvd->dev->dev,
-							 "%s: Forced test "
-							 "pattern screen\n",
-							 __func__);
+						info("%s: Forced test pattern screen", __func__);
 					return 0;
 				} else {
 					/* Standard answer: Interrupted! */
 					if (uvd->debug >= 2)
-						dev_info(&uvd->dev->dev,
-							 "%s: Interrupted!\n",
-							 __func__);
+						info("%s: Interrupted!", __func__);
 					return -EINTR;
 				}
 			} else {
@@ -2058,10 +2011,8 @@ static int usbvideo_GetFrame(struct uvd 
 			}
 		} while (frame->frameState == FrameState_Grabbing);
 		if (uvd->debug >= 2) {
-			dev_info(&uvd->dev->dev,
-				 "%s: Grabbing done; state=%d. (%lu. bytes)\n",
-				 __func__, frame->frameState,
-				 frame->seqRead_Length);
+			info("%s: Grabbing done; state=%d. (%lu. bytes)",
+			     __func__, frame->frameState, frame->seqRead_Length);
 		}
 		if (frame->frameState == FrameState_Error) {
 			int ret = usbvideo_NewFrame(uvd, frameNum);
@@ -2098,9 +2049,7 @@ static int usbvideo_GetFrame(struct uvd 
 		}
 		frame->frameState = FrameState_Done_Hold;
 		if (uvd->debug >= 2)
-			dev_info(&uvd->dev->dev,
-				 "%s: Entered FrameState_Done_Hold state.\n",
-				 __func__);
+			info("%s: Entered FrameState_Done_Hold state.", __func__);
 		return 0;
 
 	case FrameState_Done_Hold:
@@ -2111,9 +2060,7 @@ static int usbvideo_GetFrame(struct uvd 
 		 * it will be released back into the wild to roam freely.
 		 */
 		if (uvd->debug >= 2)
-			dev_info(&uvd->dev->dev,
-				 "%s: FrameState_Done_Hold state.\n",
-				 __func__);
+			info("%s: FrameState_Done_Hold state.", __func__);
 		return 0;
 	}
 
diff -puN drivers/media/video/usbvision/usbvision-core.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/usbvision/usbvision-core.c
--- a/drivers/media/video/usbvision/usbvision-core.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/usbvision/usbvision-core.c
@@ -84,8 +84,7 @@ MODULE_PARM_DESC(adjust_Y_Offset, "adjus
 #ifdef USBVISION_DEBUG
 	#define PDEBUG(level, fmt, args...) { \
 		if (core_debug & (level)) \
-			printk(KERN_INFO KBUILD_MODNAME ":[%s:%d] " fmt, \
-				__func__, __LINE__ , ## args); \
+			info("[%s:%d] " fmt, __func__, __LINE__ , ## args); \
 	}
 #else
 	#define PDEBUG(level, fmt, args...) do {} while(0)
diff -puN drivers/media/video/usbvision/usbvision-i2c.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/usbvision/usbvision-i2c.c
--- a/drivers/media/video/usbvision/usbvision-i2c.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/usbvision/usbvision-i2c.c
@@ -47,8 +47,7 @@ MODULE_PARM_DESC(i2c_debug, "enable debu
 
 #define PDEBUG(level, fmt, args...) { \
 		if (i2c_debug & (level)) \
-			printk(KERN_INFO KBUILD_MODNAME ":[%s:%d] " fmt, \
-				__func__, __LINE__ , ## args); \
+			info("[%s:%d] " fmt, __func__, __LINE__ , ## args); \
 	}
 
 static int usbvision_i2c_write(struct usb_usbvision *usbvision, unsigned char addr, char *buf,
diff -puN drivers/media/video/usbvision/usbvision-video.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/usbvision/usbvision-video.c
--- a/drivers/media/video/usbvision/usbvision-video.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/usbvision/usbvision-video.c
@@ -98,8 +98,7 @@ USBVISION_DRIVER_VERSION_PATCHLEVEL)
 #ifdef USBVISION_DEBUG
 	#define PDEBUG(level, fmt, args...) { \
 		if (video_debug & (level)) \
-			printk(KERN_INFO KBUILD_MODNAME ":[%s:%d] " fmt, \
-				__func__, __LINE__ , ## args); \
+			info("[%s:%d] " fmt, __func__, __LINE__ , ## args); \
 	}
 #else
 	#define PDEBUG(level, fmt, args...) do {} while(0)
diff -puN drivers/media/video/zr364xx.c~revert-usb-usb-remove-info-macro-from-usbh drivers/media/video/zr364xx.c
--- a/drivers/media/video/zr364xx.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/media/video/zr364xx.c
@@ -52,7 +52,7 @@
 
 
 /* Debug macro */
-#define DBG(x...) if (debug) printk(KERN_INFO KBUILD_MODNAME x)
+#define DBG(x...) if (debug) info(x)
 
 
 /* Init methods, need to find nicer names for these
@@ -128,7 +128,7 @@ static int send_control_msg(struct usb_d
 
 	unsigned char *transfer_buffer = kmalloc(size, GFP_KERNEL);
 	if (!transfer_buffer) {
-		dev_err(&udev->dev, "kmalloc(%d) failed\n", size);
+		info("kmalloc(%d) failed", size);
 		return -ENOMEM;
 	}
 
@@ -144,8 +144,7 @@ static int send_control_msg(struct usb_d
 	kfree(transfer_buffer);
 
 	if (status < 0)
-		dev_err(&udev->dev,
-			"Failed sending control message, error %d.\n", status);
+		info("Failed sending control message, error %d.", status);
 
 	return status;
 }
@@ -305,11 +304,11 @@ static int read_frame(struct zr364xx_cam
 		DBG("buffer : %d %d", cam->buffer[0], cam->buffer[1]);
 		DBG("bulk : n=%d size=%d", n, actual_length);
 		if (n < 0) {
-			dev_err(&cam->udev->dev, "error reading bulk msg\n");
+			info("error reading bulk msg");
 			return 0;
 		}
 		if (actual_length < 0 || actual_length > BUFFER_SIZE) {
-			dev_err(&cam->udev->dev, "wrong number of bytes\n");
+			info("wrong number of bytes");
 			return 0;
 		}
 
@@ -809,14 +808,13 @@ static int zr364xx_probe(struct usb_inte
 
 	DBG("probing...");
 
-	dev_info(&intf->dev, DRIVER_DESC " compatible webcam plugged\n");
-	dev_info(&intf->dev, "model %04x:%04x detected\n",
-		 le16_to_cpu(udev->descriptor.idVendor),
-		 le16_to_cpu(udev->descriptor.idProduct));
+	info(DRIVER_DESC " compatible webcam plugged");
+	info("model %04x:%04x detected", udev->descriptor.idVendor,
+	     udev->descriptor.idProduct);
 
 	cam = kzalloc(sizeof(struct zr364xx_camera), GFP_KERNEL);
 	if (cam == NULL) {
-		dev_err(&udev->dev, "cam: out of memory !\n");
+		info("cam: out of memory !");
 		return -ENOMEM;
 	}
 	/* save the init method used by this camera */
@@ -824,7 +822,7 @@ static int zr364xx_probe(struct usb_inte
 
 	cam->vdev = video_device_alloc();
 	if (cam->vdev == NULL) {
-		dev_err(&udev->dev, "cam->vdev: out of memory !\n");
+		info("cam->vdev: out of memory !");
 		kfree(cam);
 		return -ENOMEM;
 	}
@@ -836,7 +834,7 @@ static int zr364xx_probe(struct usb_inte
 	cam->udev = udev;
 
 	if ((cam->buffer = kmalloc(BUFFER_SIZE, GFP_KERNEL)) == NULL) {
-		dev_info(&udev->dev, "cam->buffer: out of memory !\n");
+		info("cam->buffer: out of memory !");
 		video_device_release(cam->vdev);
 		kfree(cam);
 		return -ENODEV;
@@ -844,17 +842,17 @@ static int zr364xx_probe(struct usb_inte
 
 	switch (mode) {
 	case 1:
-		dev_info(&udev->dev, "160x120 mode selected\n");
+		info("160x120 mode selected");
 		cam->width = 160;
 		cam->height = 120;
 		break;
 	case 2:
-		dev_info(&udev->dev, "640x480 mode selected\n");
+		info("640x480 mode selected");
 		cam->width = 640;
 		cam->height = 480;
 		break;
 	default:
-		dev_info(&udev->dev, "320x240 mode selected\n");
+		info("320x240 mode selected");
 		cam->width = 320;
 		cam->height = 240;
 		break;
@@ -874,7 +872,7 @@ static int zr364xx_probe(struct usb_inte
 
 	err = video_register_device(cam->vdev, VFL_TYPE_GRABBER, -1);
 	if (err) {
-		dev_err(&udev->dev, "video_register_device failed\n");
+		info("video_register_device failed");
 		video_device_release(cam->vdev);
 		kfree(cam->buffer);
 		kfree(cam);
@@ -883,8 +881,7 @@ static int zr364xx_probe(struct usb_inte
 
 	usb_set_intfdata(intf, cam);
 
-	dev_info(&udev->dev, DRIVER_DESC " controlling video device %d\n",
-		 cam->vdev->minor);
+	info(DRIVER_DESC " controlling video device %d", cam->vdev->minor);
 	return 0;
 }
 
@@ -894,7 +891,7 @@ static void zr364xx_disconnect(struct us
 	struct zr364xx_camera *cam = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
 	dev_set_drvdata(&intf->dev, NULL);
-	dev_info(&intf->dev, DRIVER_DESC " webcam unplugged\n");
+	info(DRIVER_DESC " webcam unplugged");
 	if (cam->vdev)
 		video_unregister_device(cam->vdev);
 	cam->vdev = NULL;
@@ -923,16 +920,16 @@ static int __init zr364xx_init(void)
 	int retval;
 	retval = usb_register(&zr364xx_driver);
 	if (retval)
-		printk(KERN_ERR KBUILD_MODNAME ": usb_register failed!\n");
+		info("usb_register failed!");
 	else
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "\n");
+		info(DRIVER_DESC " module loaded");
 	return retval;
 }
 
 
 static void __exit zr364xx_exit(void)
 {
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC " module unloaded\n");
+	info(DRIVER_DESC " module unloaded");
 	usb_deregister(&zr364xx_driver);
 }
 
diff -puN drivers/mtd/nand/alauda.c~revert-usb-usb-remove-info-macro-from-usbh drivers/mtd/nand/alauda.c
--- a/drivers/mtd/nand/alauda.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/mtd/nand/alauda.c
@@ -691,7 +691,7 @@ static int alauda_probe(struct usb_inter
 	al[0].port = ALAUDA_PORT_XD;
 	al[1].port = ALAUDA_PORT_SM;
 
-	dev_info(&interface->dev, "alauda probed\n");
+	info("alauda probed");
 	alauda_check_media(al);
 	alauda_check_media(al+1);
 
@@ -716,7 +716,7 @@ static void alauda_disconnect(struct usb
 	if (al)
 		kref_put(&al->kref, alauda_delete);
 
-	dev_info(&interface->dev, "alauda gone");
+	info("alauda gone");
 }
 
 static struct usb_driver alauda_driver = {
diff -puN drivers/net/irda/kingsun-sir.c~revert-usb-usb-remove-info-macro-from-usbh drivers/net/irda/kingsun-sir.c
--- a/drivers/net/irda/kingsun-sir.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/net/irda/kingsun-sir.c
@@ -540,8 +540,7 @@ static int kingsun_probe(struct usb_inte
 	if (ret != 0)
 		goto free_mem;
 
-	dev_info(&net->dev, "IrDA: Registered KingSun/DonShine device %s\n",
-		 net->name);
+	info("IrDA: Registered KingSun/DonShine device %s", net->name);
 
 	usb_set_intfdata(intf, kingsun);
 
diff -puN drivers/net/irda/ks959-sir.c~revert-usb-usb-remove-info-macro-from-usbh drivers/net/irda/ks959-sir.c
--- a/drivers/net/irda/ks959-sir.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/net/irda/ks959-sir.c
@@ -801,8 +801,7 @@ static int ks959_probe(struct usb_interf
 	if (ret != 0)
 		goto free_mem;
 
-	dev_info(&net->dev, "IrDA: Registered KingSun KS-959 device %s\n",
-		 net->name);
+	info("IrDA: Registered KingSun KS-959 device %s", net->name);
 
 	usb_set_intfdata(intf, kingsun);
 
diff -puN drivers/net/irda/ksdazzle-sir.c~revert-usb-usb-remove-info-macro-from-usbh drivers/net/irda/ksdazzle-sir.c
--- a/drivers/net/irda/ksdazzle-sir.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/net/irda/ksdazzle-sir.c
@@ -705,8 +705,7 @@ static int ksdazzle_probe(struct usb_int
 	if (ret != 0)
 		goto free_mem;
 
-	dev_info(&net->dev, "IrDA: Registered KingSun/Dazzle device %s\n",
-		 net->name);
+	info("IrDA: Registered KingSun/Dazzle device %s", net->name);
 
 	usb_set_intfdata(intf, kingsun);
 
diff -puN drivers/net/irda/stir4200.c~revert-usb-usb-remove-info-macro-from-usbh drivers/net/irda/stir4200.c
--- a/drivers/net/irda/stir4200.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/net/irda/stir4200.c
@@ -783,9 +783,8 @@ static int stir_transmit_thread(void *ar
 
 			if (unlikely(receive_start(stir))) {
 				if (net_ratelimit())
-					dev_info(&dev->dev,
-						 "%s: receive usb submit failed\n",
-						 stir->netdev->name);
+					info("%s: receive usb submit failed",
+					     stir->netdev->name);
 				stir->receiving = 0;
 				msleep(10);
 				continue;
@@ -1074,8 +1073,7 @@ static int stir_probe(struct usb_interfa
 	if (ret != 0)
 		goto err_out2;
 
-	dev_info(&intf->dev, "IrDA: Registered SigmaTel device %s\n",
-		 net->name);
+	info("IrDA: Registered SigmaTel device %s", net->name);
 
 	usb_set_intfdata(intf, stir);
 
diff -puN drivers/net/usb/catc.c~revert-usb-usb-remove-info-macro-from-usbh drivers/net/usb/catc.c
--- a/drivers/net/usb/catc.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/net/usb/catc.c
@@ -954,8 +954,7 @@ static int __init catc_init(void)
 {
 	int result = usb_register(&catc_driver);
 	if (result == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		info(DRIVER_VERSION " " DRIVER_DESC);
 	return result;
 }
 
diff -puN drivers/net/usb/kaweth.c~revert-usb-usb-remove-info-macro-from-usbh drivers/net/usb/kaweth.c
--- a/drivers/net/usb/kaweth.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/net/usb/kaweth.c
@@ -1016,10 +1016,10 @@ static int kaweth_probe(
 	 */
 
 	if (le16_to_cpu(dev->descriptor.bcdDevice) >> 8) {
-		dev_info(&intf->dev, "Firmware present in device.\n");
+		info("Firmware present in device.");
 	} else {
 		/* Download the firmware */
-		dev_info(&intf->dev, "Downloading firmware...\n");
+		info("Downloading firmware...");
 		kaweth->firmware_buf = (__u8 *)__get_free_page(GFP_KERNEL);
 		if ((result = kaweth_download_firmware(kaweth,
 						      "kaweth/new_code.bin",
@@ -1061,7 +1061,7 @@ static int kaweth_probe(
 		}
 
 		/* Device will now disappear for a moment...  */
-		dev_info(&intf->dev, "Firmware loaded.  I'll be back...\n");
+		info("Firmware loaded.  I'll be back...");
 err_fw:
 		free_page((unsigned long)kaweth->firmware_buf);
 		free_netdev(netdev);
@@ -1075,10 +1075,10 @@ err_fw:
 		goto err_free_netdev;
 	}
 
-	dev_info(&intf->dev, "Statistics collection: %x\n", kaweth->configuration.statistics_mask);
-	dev_info(&intf->dev, "Multicast filter limit: %x\n", kaweth->configuration.max_multicast_filters & ((1 << 15) - 1));
-	dev_info(&intf->dev, "MTU: %d\n", le16_to_cpu(kaweth->configuration.segment_size));
-	dev_info(&intf->dev, "Read MAC address %2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x\n",
+	info("Statistics collection: %x", kaweth->configuration.statistics_mask);
+	info("Multicast filter limit: %x", kaweth->configuration.max_multicast_filters & ((1 << 15) - 1));
+	info("MTU: %d", le16_to_cpu(kaweth->configuration.segment_size));
+	info("Read MAC address %2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x",
 		 (int)kaweth->configuration.hw_addr[0],
 		 (int)kaweth->configuration.hw_addr[1],
 		 (int)kaweth->configuration.hw_addr[2],
@@ -1174,8 +1174,7 @@ err_fw:
 		goto err_intfdata;
 	}
 
-	dev_info(&intf->dev, "kaweth interface created at %s\n",
-		 kaweth->net->name);
+	info("kaweth interface created at %s", kaweth->net->name);
 
 	dbg("Kaweth probe returning.");
 
@@ -1206,7 +1205,7 @@ static void kaweth_disconnect(struct usb
 	struct kaweth_device *kaweth = usb_get_intfdata(intf);
 	struct net_device *netdev;
 
-	dev_info(&intf->dev, "Unregistering\n");
+	info("Unregistering");
 
 	usb_set_intfdata(intf, NULL);
 	if (!kaweth) {
diff -puN drivers/net/usb/rtl8150.c~revert-usb-usb-remove-info-macro-from-usbh drivers/net/usb/rtl8150.c
--- a/drivers/net/usb/rtl8150.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/net/usb/rtl8150.c
@@ -538,8 +538,7 @@ static void write_bulk_callback(struct u
 	if (!netif_device_present(dev->netdev))
 		return;
 	if (urb->status)
-		dev_info(&urb->dev->dev, "%s: Tx status %d\n",
-			 dev->netdev->name, urb->status);
+		info("%s: Tx status %d", dev->netdev->name, urb->status);
 	dev->netdev->trans_start = jiffies;
 	netif_wake_queue(dev->netdev);
 }
@@ -562,8 +561,7 @@ static void intr_callback(struct urb *ur
 		return;
 	/* -EPIPE:  should clear the halt */
 	default:
-		dev_info(&urb->dev->dev, "%s: intr status %d\n",
-			 dev->netdev->name, urb->status);
+		info("%s: intr status %d", dev->netdev->name, urb->status);
 		goto resubmit;
 	}
 
@@ -712,12 +710,12 @@ static void rtl8150_set_multicast(struct
 	netif_stop_queue(netdev);
 	if (netdev->flags & IFF_PROMISC) {
 		dev->rx_creg |= cpu_to_le16(0x0001);
-		dev_info(&netdev->dev, "%s: promiscuous mode\n", netdev->name);
+		info("%s: promiscuous mode", netdev->name);
 	} else if (netdev->mc_count ||
 		   (netdev->flags & IFF_ALLMULTI)) {
 		dev->rx_creg &= cpu_to_le16(0xfffe);
 		dev->rx_creg |= cpu_to_le16(0x0002);
-		dev_info(&netdev->dev, "%s: allmulti set\n", netdev->name);
+		info("%s: allmulti set", netdev->name);
 	} else {
 		/* ~RX_MULTICAST, ~RX_PROMISCUOUS */
 		dev->rx_creg &= cpu_to_le16(0x00fc);
@@ -949,7 +947,7 @@ static int rtl8150_probe(struct usb_inte
 		goto out2;
 	}
 
-	dev_info(&intf->dev, "%s: rtl8150 is detected\n", netdev->name);
+	info("%s: rtl8150 is detected", netdev->name);
 
 	return 0;
 
@@ -986,8 +984,7 @@ static void rtl8150_disconnect(struct us
 
 static int __init usb_rtl8150_init(void)
 {
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return usb_register(&rtl8150_driver);
 }
 
diff -puN drivers/usb/class/cdc-acm.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/class/cdc-acm.c
@@ -1454,8 +1454,7 @@ static int __init acm_init(void)
 		return retval;
 	}
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 
 	return 0;
 }
diff -puN drivers/usb/host/r8a66597-hcd.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/host/r8a66597-hcd.c
--- a/drivers/usb/host/r8a66597-hcd.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/host/r8a66597-hcd.c
@@ -760,12 +760,10 @@ static void enable_r8a66597_pipe_dma(str
 			if ((r8a66597->dma_map & (1 << i)) != 0)
 				continue;
 
-			dev_info(&dev->udev->dev,
-				 "address %d, EndpointAddress 0x%02x use "
-				 "DMA FIFO\n", usb_pipedevice(urb->pipe),
-				 info->dir_in ?
-				 	USB_ENDPOINT_DIR_MASK + info->epnum
-					: info->epnum);
+			info("address %d, EndpointAddress 0x%02x use DMA FIFO",
+			     usb_pipedevice(urb->pipe),
+			     info->dir_in ? USB_ENDPOINT_DIR_MASK + info->epnum
+					    : info->epnum);
 
 			r8a66597->dma_map |= 1 << i;
 			dev->dma_map |= 1 << i;
@@ -2389,8 +2387,7 @@ static int __init r8a66597_init(void)
 	if (usb_disabled())
 		return -ENODEV;
 
-	printk(KERN_INFO KBUILD_MODNAME ": driver %s, %s\n", hcd_name,
-	       DRIVER_VERSION);
+	info("driver %s, %s", hcd_name, DRIVER_VERSION);
 	return platform_driver_register(&r8a66597_driver);
 }
 module_init(r8a66597_init);
diff -puN drivers/usb/image/mdc800.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/image/mdc800.c
--- a/drivers/usb/image/mdc800.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/image/mdc800.c
@@ -489,7 +489,7 @@ static int mdc800_usb_probe (struct usb_
 	}
 
 
-	dev_info(&intf->dev, "Found Mustek MDC800 on USB.\n");
+	info ("Found Mustek MDC800 on USB.");
 
 	mutex_lock(&mdc800->io_lock);
 
@@ -571,7 +571,7 @@ static void mdc800_usb_disconnect (struc
 		mdc800->dev = NULL;
 		usb_set_intfdata(intf, NULL);
 	}
-	dev_info(&intf->dev, "Mustek MDC800 disconnected from USB.\n");
+	info ("Mustek MDC800 disconnected from USB.");
 }
 
 
@@ -1020,8 +1020,7 @@ static int __init usb_mdc800_init (void)
 	if (retval)
 		goto cleanup_on_fail;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info (DRIVER_VERSION ":" DRIVER_DESC);
 
 	return 0;
 
diff -puN drivers/usb/misc/adutux.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/misc/adutux.c
--- a/drivers/usb/misc/adutux.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/misc/adutux.c
@@ -895,9 +895,8 @@ static int __init adu_init(void)
 		goto exit;
 	}
 
-	printk(KERN_INFO "adutux " DRIVER_DESC " " DRIVER_VERSION "\n");
-	printk(KERN_INFO "adutux is an experimental driver. "
-	       "Use at your own risk\n");
+	info("adutux " DRIVER_DESC " " DRIVER_VERSION);
+	info("adutux is an experimental driver. Use at your own risk");
 
 exit:
 	dbg(2," %s : leave, return value %d", __func__, result);
diff -puN drivers/usb/misc/cytherm.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/misc/cytherm.c
--- a/drivers/usb/misc/cytherm.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/misc/cytherm.c
@@ -428,8 +428,7 @@ static int __init usb_cytherm_init(void)
 		return result;
 	}
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 	return 0;
 }
 
diff -puN drivers/usb/misc/emi26.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/misc/emi26.c
--- a/drivers/usb/misc/emi26.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/misc/emi26.c
@@ -64,7 +64,7 @@ static int emi26_writememory (struct usb
 static int emi26_set_reset (struct usb_device *dev, unsigned char reset_bit)
 {
 	int response;
-	dev_info(&dev->dev, "%s - %d\n", __func__, reset_bit);
+	info("%s - %d", __func__, reset_bit);
 	/* printk(KERN_DEBUG "%s - %d", __func__, reset_bit); */
 	response = emi26_writememory (dev, CPUCS_REG, &reset_bit, 1, 0xa0);
 	if (response < 0) {
@@ -254,7 +254,7 @@ static int emi26_probe(struct usb_interf
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
 
-	dev_info(&intf->dev, "%s start\n", __func__);
+	info("%s start", __func__);
 
 	emi26_load_firmware(dev);
 
diff -puN drivers/usb/misc/emi62.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/misc/emi62.c
--- a/drivers/usb/misc/emi62.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/misc/emi62.c
@@ -73,7 +73,7 @@ static int emi62_writememory(struct usb_
 static int emi62_set_reset (struct usb_device *dev, unsigned char reset_bit)
 {
 	int response;
-	dev_info(&dev->dev, "%s - %d\n", __func__, reset_bit);
+	info("%s - %d", __func__, reset_bit);
 	
 	response = emi62_writememory (dev, CPUCS_REG, &reset_bit, 1, 0xa0);
 	if (response < 0) {
@@ -271,7 +271,7 @@ static int emi62_probe(struct usb_interf
 	struct usb_device *dev = interface_to_usbdev(intf);
 	dev_dbg(&intf->dev, "emi62_probe\n");
 
-	dev_info(&intf->dev, "%s start\n", __func__);
+	info("%s start", __func__);
 
 	emi62_load_firmware(dev);
 
diff -puN drivers/usb/misc/idmouse.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/misc/idmouse.c
--- a/drivers/usb/misc/idmouse.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/misc/idmouse.c
@@ -403,15 +403,14 @@ static void idmouse_disconnect(struct us
 		mutex_unlock(&dev->lock);
 	}
 
-	dev_info(&interface->dev, "disconnected\n");
+	info("%s disconnected", DRIVER_DESC);
 }
 
 static int __init usb_idmouse_init(void)
 {
 	int result;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 
 	/* register this driver with the USB subsystem */
 	result = usb_register(&idmouse_driver);
diff -puN drivers/usb/misc/legousbtower.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/misc/legousbtower.c
--- a/drivers/usb/misc/legousbtower.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/misc/legousbtower.c
@@ -851,8 +851,9 @@ static int tower_probe (struct usb_inter
 
 	dbg(2, "%s: enter", __func__);
 
-	if (udev == NULL)
-		dev_info(&interface->dev, "udev is NULL.\n");
+	if (udev == NULL) {
+		info ("udev is NULL.");
+	}
 
 	/* allocate memory for our device state and initialize it */
 
@@ -953,9 +954,7 @@ static int tower_probe (struct usb_inter
 	dev->minor = interface->minor;
 
 	/* let the user know what node this device is now attached to */
-	dev_info(&interface->dev, "LEGO USB Tower #%d now attached to major "
-		 "%d minor %d\n", (dev->minor - LEGO_USB_TOWER_MINOR_BASE),
-		 USB_MAJOR, dev->minor);
+	info ("LEGO USB Tower #%d now attached to major %d minor %d", (dev->minor - LEGO_USB_TOWER_MINOR_BASE), USB_MAJOR, dev->minor);
 
 	/* get the firmware version and log it */
 	result = usb_control_msg (udev,
@@ -972,10 +971,10 @@ static int tower_probe (struct usb_inter
 		retval = result;
 		goto error;
 	}
-	dev_info(&interface->dev, "LEGO USB Tower firmware version is %d.%d "
-		 "build %d\n", get_version_reply.major,
-		 get_version_reply.minor,
-		 le16_to_cpu(get_version_reply.build_no));
+	info("LEGO USB Tower firmware version is %d.%d build %d",
+	     get_version_reply.major,
+	     get_version_reply.minor,
+	     le16_to_cpu(get_version_reply.build_no));
 
 
 exit:
@@ -1022,8 +1021,7 @@ static void tower_disconnect (struct usb
 		mutex_unlock(&dev->lock);
 	}
 
-	dev_info(&interface->dev, "LEGO USB Tower #%d now disconnected\n",
-		 (minor - LEGO_USB_TOWER_MINOR_BASE));
+	info("LEGO USB Tower #%d now disconnected", (minor - LEGO_USB_TOWER_MINOR_BASE));
 
 	dbg(2, "%s: leave", __func__);
 }
@@ -1048,8 +1046,7 @@ static int __init lego_usb_tower_init(vo
 		goto exit;
 	}
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 
 exit:
 	dbg(2, "%s: leave, return value %d", __func__, retval);
diff -puN drivers/usb/misc/rio500.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/misc/rio500.c
--- a/drivers/usb/misc/rio500.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/misc/rio500.c
@@ -89,7 +89,7 @@ static int open_rio(struct inode *inode,
 
 	mutex_unlock(&(rio->lock));
 
-	dev_info(&rio->rio_dev->dev, "Rio opened.\n");
+	info("Rio opened.");
 
 	return 0;
 }
@@ -100,7 +100,7 @@ static int close_rio(struct inode *inode
 
 	rio->isopen = 0;
 
-	dev_info(&rio->rio_dev->dev, "Rio closed.\n");
+	info("Rio closed.");
 	return 0;
 }
 
@@ -451,7 +451,7 @@ static int probe_rio(struct usb_interfac
 	struct rio_usb_data *rio = &rio_instance;
 	int retval;
 
-	dev_info(&intf->dev, "USB Rio found at address %d\n", dev->devnum);
+	info("USB Rio found at address %d", dev->devnum);
 
 	retval = usb_register_dev(intf, &usb_rio_class);
 	if (retval) {
@@ -503,7 +503,7 @@ static void disconnect_rio(struct usb_in
 		kfree(rio->ibuf);
 		kfree(rio->obuf);
 
-		dev_info(&intf->dev, "USB Rio disconnected.\n");
+		info("USB Rio disconnected.");
 
 		rio->present = 0;
 		mutex_unlock(&(rio->lock));
@@ -531,8 +531,7 @@ static int __init usb_rio_init(void)
 	if (retval)
 		goto out;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 
 out:
 	return retval;
diff -puN drivers/usb/misc/trancevibrator.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/misc/trancevibrator.c
--- a/drivers/usb/misc/trancevibrator.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/misc/trancevibrator.c
@@ -144,8 +144,7 @@ static int __init tv_init(void)
 		return retval;
 	}
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 	return 0;
 }
 
diff -puN drivers/usb/misc/usblcd.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/misc/usblcd.c
--- a/drivers/usb/misc/usblcd.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/misc/usblcd.c
@@ -359,13 +359,12 @@ static int lcd_probe(struct usb_interfac
 
 	i = le16_to_cpu(dev->udev->descriptor.bcdDevice);
 
-	dev_info(&interface->dev, "USBLCD Version %1d%1d.%1d%1d found "
-		 "at address %d\n", (i & 0xF000)>>12, (i & 0xF00)>>8,
-		 (i & 0xF0)>>4,(i & 0xF), dev->udev->devnum);
+	info("USBLCD Version %1d%1d.%1d%1d found at address %d",
+		(i & 0xF000)>>12,(i & 0xF00)>>8,(i & 0xF0)>>4,(i & 0xF),
+		dev->udev->devnum);
 
 	/* let the user know what node this device is now attached to */
-	dev_info(&interface->dev, "USB LCD device now attached to USBLCD-%d\n",
-		 interface->minor);
+	info("USB LCD device now attached to USBLCD-%d", interface->minor);
 	return 0;
 
 error:
@@ -414,7 +413,7 @@ static void lcd_disconnect(struct usb_in
 	/* decrement our usage count */
 	kref_put(&dev->kref, lcd_delete);
 
-	dev_info(&interface->dev, "USB LCD #%d now disconnected\n", minor);
+	info("USB LCD #%d now disconnected", minor);
 }
 
 static struct usb_driver lcd_driver = {
diff -puN drivers/usb/misc/uss720.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/misc/uss720.c
--- a/drivers/usb/misc/uss720.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/misc/uss720.c
@@ -801,14 +801,10 @@ static int __init uss720_init(void)
 	if (retval)
 		goto out;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
-	printk(KERN_INFO KBUILD_MODNAME ": NOTE: this is a special purpose "
-	       "driver to allow nonstandard\n");
-	printk(KERN_INFO KBUILD_MODNAME ": protocols (eg. bitbang) over "
-	       "USS720 usb to parallel cables\n");
-	printk(KERN_INFO KBUILD_MODNAME ": If you just want to connect to a "
-	       "printer, use usblp instead\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
+	info("NOTE: this is a special purpose driver to allow nonstandard");
+	info("protocols (eg. bitbang) over USS720 usb to parallel cables");
+	info("If you just want to connect to a printer, use usblp instead");
 out:
 	return retval;
 }
diff -puN drivers/usb/serial/belkin_sa.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/belkin_sa.c
--- a/drivers/usb/serial/belkin_sa.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/belkin_sa.c
@@ -187,7 +187,7 @@ static int belkin_sa_startup(struct usb_
 	/* see comments at top of file */
 	priv->bad_flow_control =
 		(le16_to_cpu(dev->descriptor.bcdDevice) <= 0x0206) ? 1 : 0;
-	dev_info(&dev->dev, "bcdDevice: %04x, bfc: %d\n",
+	info("bcdDevice: %04x, bfc: %d",
 					le16_to_cpu(dev->descriptor.bcdDevice),
 					priv->bad_flow_control);
 
@@ -576,8 +576,7 @@ static int __init belkin_sa_init(void)
 	retval = usb_register(&belkin_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&belkin_device);
diff -puN drivers/usb/serial/cp2101.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/cp2101.c
--- a/drivers/usb/serial/cp2101.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/cp2101.c
@@ -753,8 +753,7 @@ static int __init cp2101_init(void)
 	}
 
 	/* Success */
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 }
 
diff -puN drivers/usb/serial/cyberjack.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/cyberjack.c
--- a/drivers/usb/serial/cyberjack.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/cyberjack.c
@@ -503,9 +503,8 @@ static int __init cyberjack_init(void)
 	if (retval)
 		goto failed_usb_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION " "
-	       DRIVER_AUTHOR "\n");
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "\n");
+	info(DRIVER_VERSION " " DRIVER_AUTHOR);
+	info(DRIVER_DESC);
 
 	return 0;
 failed_usb_register:
diff -puN drivers/usb/serial/cypress_m8.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/cypress_m8.c
--- a/drivers/usb/serial/cypress_m8.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/cypress_m8.c
@@ -1659,8 +1659,7 @@ static int __init cypress_init(void)
 	if (retval)
 		goto failed_usb_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 
 failed_usb_register:
diff -puN drivers/usb/serial/digi_acceleport.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/digi_acceleport.c
--- a/drivers/usb/serial/digi_acceleport.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/digi_acceleport.c
@@ -1862,8 +1862,7 @@ static int __init digi_init(void)
 	retval = usb_register(&digi_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&digi_acceleport_4_device);
diff -puN drivers/usb/serial/empeg.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/empeg.c
--- a/drivers/usb/serial/empeg.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/empeg.c
@@ -519,8 +519,7 @@ static int __init empeg_init(void)
 	if (retval)
 		goto failed_usb_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 
 	return 0;
 failed_usb_register:
diff -puN drivers/usb/serial/ftdi_sio.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -1155,7 +1155,7 @@ static void ftdi_determine_type(struct u
 		/* Assume its an FT232R  */
 		priv->chip_type = FT232RL;
 	}
-	dev_info(&udev->dev, "Detected %s\n", ftdi_chip_name[priv->chip_type]);
+	info("Detected %s", ftdi_chip_name[priv->chip_type]);
 }
 
 
@@ -1411,8 +1411,7 @@ static int ftdi_jtag_probe(struct usb_se
 	dbg("%s", __func__);
 
 	if (interface == udev->actconfig->interface[0]) {
-		dev_info(&udev->dev,
-			 "Ignoring serial port reserved for JTAG\n");
+		info("Ignoring serial port reserved for JTAG");
 		return -ENODEV;
 	}
 
@@ -1430,8 +1429,7 @@ static int ftdi_mtxorb_hack_setup(struct
 
 	if (ep->enabled && ep_desc->wMaxPacketSize == 0) {
 		ep_desc->wMaxPacketSize = cpu_to_le16(0x40);
-		dev_info(&serial->dev->dev,
-			 "Fixing invalid wMaxPacketSize on read pipe\n");
+		info("Fixing invalid wMaxPacketSize on read pipe");
 	}
 
 	return 0;
@@ -2440,8 +2438,7 @@ static int __init ftdi_init(void)
 	if (retval)
 		goto failed_usb_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&ftdi_sio_device);
diff -puN drivers/usb/serial/garmin_gps.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/garmin_gps.c
--- a/drivers/usb/serial/garmin_gps.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/garmin_gps.c
@@ -1584,8 +1584,7 @@ static int __init garmin_init(void)
 	retval = usb_register(&garmin_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 
 	return 0;
 failed_usb_register:
diff -puN drivers/usb/serial/hp4x.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/hp4x.c
--- a/drivers/usb/serial/hp4x.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/hp4x.c
@@ -63,8 +63,7 @@ static int __init hp49gp_init(void)
 	retval = usb_register(&hp49gp_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&hp49gp_device);
diff -puN drivers/usb/serial/io_edgeport.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/io_edgeport.c
--- a/drivers/usb/serial/io_edgeport.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/io_edgeport.c
@@ -3240,8 +3240,7 @@ static int __init edgeport_init(void)
 	if (retval)
 		goto failed_usb_register;
 	atomic_set(&CmdUrbs, 0);
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 
 failed_usb_register:
diff -puN drivers/usb/serial/io_ti.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/io_ti.c
@@ -2966,8 +2966,7 @@ static int __init edgeport_init(void)
 	retval = usb_register(&io_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&edgeport_2port_device);
diff -puN drivers/usb/serial/ipaq.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/ipaq.c
--- a/drivers/usb/serial/ipaq.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/ipaq.c
@@ -978,6 +978,7 @@ static int __init ipaq_init(void)
 	retval = usb_serial_register(&ipaq_device);
 	if (retval)
 		goto failed_usb_serial_register;
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	if (vendor) {
 		ipaq_id_table[0].idVendor = vendor;
 		ipaq_id_table[0].idProduct = product;
@@ -986,8 +987,6 @@ static int __init ipaq_init(void)
 	if (retval)
 		goto failed_usb_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&ipaq_device);
diff -puN drivers/usb/serial/ipw.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/ipw.c
--- a/drivers/usb/serial/ipw.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/ipw.c
@@ -484,8 +484,7 @@ static int usb_ipw_init(void)
 		usb_serial_deregister(&ipw_device);
 		return retval;
 	}
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 }
 
diff -puN drivers/usb/serial/ir-usb.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/ir-usb.c
--- a/drivers/usb/serial/ir-usb.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/ir-usb.c
@@ -601,8 +601,7 @@ static int __init ir_init(void)
 	if (retval)
 		goto failed_usb_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 
 	return 0;
 
diff -puN drivers/usb/serial/iuu_phoenix.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/iuu_phoenix.c
--- a/drivers/usb/serial/iuu_phoenix.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/iuu_phoenix.c
@@ -1184,8 +1184,7 @@ static int __init iuu_init(void)
 	retval = usb_register(&iuu_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&iuu_device);
diff -puN drivers/usb/serial/keyspan.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/keyspan.c
--- a/drivers/usb/serial/keyspan.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/keyspan.c
@@ -217,8 +217,7 @@ static int __init keyspan_init(void)
 	if (retval)
 		goto failed_usb_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 
 	return 0;
 failed_usb_register:
diff -puN drivers/usb/serial/keyspan_pda.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/keyspan_pda.c
--- a/drivers/usb/serial/keyspan_pda.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/keyspan_pda.c
@@ -873,8 +873,7 @@ static int __init keyspan_pda_init(void)
 	retval = usb_register(&keyspan_pda_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 failed_usb_register:
 #ifdef XIRCOM
diff -puN drivers/usb/serial/kl5kusb105.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/kl5kusb105.c
--- a/drivers/usb/serial/kl5kusb105.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/kl5kusb105.c
@@ -215,7 +215,7 @@ static int klsi_105_get_line_state(struc
 	__u8 status_buf[KLSI_STATUSBUF_LEN] = { -1, -1};
 	__u16 status;
 
-	dev_info(&port->serial->dev->dev, "sending SIO Poll request\n");
+	info("%s - sending SIO Poll request", __func__);
 	rc = usb_control_msg(port->serial->dev,
 			     usb_rcvctrlpipe(port->serial->dev, 0),
 			     KL5KUSB105A_SIO_POLL,
@@ -231,8 +231,8 @@ static int klsi_105_get_line_state(struc
 	else {
 		status = get_unaligned_le16(status_buf);
 
-		dev_info(&port->serial->dev->dev, "read status %x %x",
-			 status_buf[0], status_buf[1]);
+		info("%s - read status %x %x", __func__,
+		     status_buf[0], status_buf[1]);
 
 		*line_state_p = klsi_105_status2linestate(status);
 	}
@@ -479,9 +479,8 @@ static void klsi_105_close(struct tty_st
 	/* FIXME */
 	/* wgg - do I need this? I think so. */
 	usb_kill_urb(port->interrupt_in_urb);
-	dev_info(&port->serial->dev->dev,
-		 "port stats: %ld bytes in, %ld bytes out\n",
-		 priv->bytes_in, priv->bytes_out);
+	info("kl5kusb105 port stats: %ld bytes in, %ld bytes out",
+					priv->bytes_in, priv->bytes_out);
 } /* klsi_105_close */
 
 
@@ -971,8 +970,7 @@ static int __init klsi_105_init(void)
 	if (retval)
 		goto failed_usb_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&kl5kusb105d_device);
diff -puN drivers/usb/serial/kobil_sct.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/kobil_sct.c
--- a/drivers/usb/serial/kobil_sct.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/kobil_sct.c
@@ -743,8 +743,8 @@ static int __init kobil_init(void)
 	if (retval)
 		goto failed_usb_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION " " DRIVER_AUTHOR);
+	info(DRIVER_DESC);
 
 	return 0;
 failed_usb_register:
diff -puN drivers/usb/serial/mct_u232.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/mct_u232.c
--- a/drivers/usb/serial/mct_u232.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/mct_u232.c
@@ -824,8 +824,7 @@ static int __init mct_u232_init(void)
 	retval = usb_register(&mct_u232_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&mct_u232_device);
diff -puN drivers/usb/serial/mos7720.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/mos7720.c
--- a/drivers/usb/serial/mos7720.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/mos7720.c
@@ -1616,8 +1616,7 @@ static int __init moschip7720_init(void)
 	if (retval)
 		goto failed_port_device_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 
 	/* Register with the usb */
 	retval = usb_register(&usb_driver);
diff -puN drivers/usb/serial/mos7840.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/mos7840.c
--- a/drivers/usb/serial/mos7840.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/mos7840.c
@@ -2744,8 +2744,7 @@ static int __init moschip7840_init(void)
 		goto failed_port_device_register;
 
 	dbg("%s\n", "Entring...");
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 
 	/* Register with the usb */
 	retval = usb_register(&io_driver);
diff -puN drivers/usb/serial/omninet.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/omninet.c
--- a/drivers/usb/serial/omninet.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/omninet.c
@@ -365,8 +365,7 @@ static int __init omninet_init(void)
 	retval = usb_register(&omninet_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION ":" DRIVER_DESC);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&zyxel_omninet_device);
diff -puN drivers/usb/serial/option.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/option.c
@@ -411,8 +411,7 @@ static int __init option_init(void)
 	if (retval)
 		goto failed_driver_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC ": " DRIVER_VERSION);
 
 	return 0;
 
diff -puN drivers/usb/serial/pl2303.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/pl2303.c
@@ -1158,7 +1158,7 @@ static int __init pl2303_init(void)
 	retval = usb_register(&pl2303_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "\n");
+	info(DRIVER_DESC);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&pl2303_device);
diff -puN drivers/usb/serial/safe_serial.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/safe_serial.c
--- a/drivers/usb/serial/safe_serial.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/safe_serial.c
@@ -248,8 +248,8 @@ static void safe_read_bulk_callback(stru
 		if (!fcs) {
 			int actual_length = data[length - 2] >> 2;
 			if (actual_length <= (length - 2)) {
-				dev_info(&urb->dev->dev, "%s - actual: %d\n",
-					 __func__, actual_length);
+				info("%s - actual: %d", __func__,
+							actual_length);
 				tty_insert_flip_string(port->port.tty,
 							data, actual_length);
 				tty_flip_buffer_push(port->port.tty);
@@ -428,13 +428,14 @@ static int __init safe_init(void)
 {
 	int i, retval;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_VERSION " " DRIVER_AUTHOR);
+	info(DRIVER_DESC);
+	info("vendor: %x product: %x safe: %d padded: %d\n",
+					vendor, product, safe, padded);
 
 	/* if we have vendor / product parameters patch them into id list */
 	if (vendor || product) {
-		printk(KERN_INFO KBUILD_MODNAME ": vendor: %x product: %x\n",
-		       vendor, product);
+		info("vendor: %x product: %x\n", vendor, product);
 
 		for (i = 0; i < ARRAY_SIZE(id_table); i++) {
 			if (!id_table[i].idVendor && !id_table[i].idProduct) {
diff -puN drivers/usb/serial/sierra.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/sierra.c
@@ -748,8 +748,7 @@ static int __init sierra_init(void)
 	if (retval)
 		goto failed_driver_register;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC ": " DRIVER_VERSION);
 
 	return 0;
 
diff -puN drivers/usb/serial/spcp8x5.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/spcp8x5.c
--- a/drivers/usb/serial/spcp8x5.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/spcp8x5.c
@@ -1054,8 +1054,7 @@ static int __init spcp8x5_init(void)
 	retval = usb_register(&spcp8x5_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&spcp8x5_device);
diff -puN drivers/usb/serial/ti_usb_3410_5052.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -382,8 +382,7 @@ static int __init ti_init(void)
 	if (ret)
 		goto failed_usb;
 
-	printk(KERN_INFO KBUILD_MODNAME ": " TI_DRIVER_VERSION ":"
-	       TI_DRIVER_DESC "\n");
+	info(TI_DRIVER_DESC " " TI_DRIVER_VERSION);
 
 	return 0;
 
diff -puN drivers/usb/serial/usb-serial.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/usb-serial.c
@@ -1158,7 +1158,7 @@ static int __init usb_serial_init(void)
 		goto exit_generic;
 	}
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "\n");
+	info(DRIVER_DESC);
 
 	return result;
 
@@ -1236,7 +1236,7 @@ int usb_serial_register(struct usb_seria
 		       "driver %s\n", retval, driver->description);
 		list_del(&driver->driver_list);
 	} else
-		printk(KERN_INFO "USB Serial support registered for %s\n",
+		info("USB Serial support registered for %s",
 						driver->description);
 
 	return retval;
@@ -1247,8 +1247,7 @@ EXPORT_SYMBOL_GPL(usb_serial_register);
 void usb_serial_deregister(struct usb_serial_driver *device)
 {
 	/* must be called with BKL held */
-	printk(KERN_INFO "USB Serial deregistering driver %s\n",
-	       device->description);
+	info("USB Serial deregistering driver %s", device->description);
 	list_del(&device->driver_list);
 	usb_serial_bus_deregister(device);
 }
diff -puN drivers/usb/serial/visor.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/visor.c
--- a/drivers/usb/serial/visor.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/visor.c
@@ -967,14 +967,11 @@ static int __init visor_init(void)
 				break;
 			}
 		}
-		printk(KERN_INFO KBUILD_MODNAME
-		       ": Untested USB device specified at time of module insertion\n");
-		printk(KERN_INFO KBUILD_MODNAME
-		       ": Warning: This is not guaranteed to work\n");
-		printk(KERN_INFO KBUILD_MODNAME
-		       ": Using a newer kernel is preferred to this method\n");
-		printk(KERN_INFO KBUILD_MODNAME
-		       ": Adding Palm OS protocol 4.x support for unknown device: 0x%x/0x%x\n",
+		info(
+		  "Untested USB device specified at time of module insertion");
+		info("Warning: This is not guaranteed to work");
+		info("Using a newer kernel is preferred to this method");
+		info("Adding Palm OS protocol 4.x support for unknown device: 0x%x/0x%x",
 			vendor, product);
 	}
 	retval = usb_serial_register(&handspring_device);
@@ -989,7 +986,7 @@ static int __init visor_init(void)
 	retval = usb_register(&visor_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "\n");
+	info(DRIVER_DESC);
 
 	return 0;
 failed_usb_register:
diff -puN drivers/usb/serial/whiteheat.c~revert-usb-usb-remove-info-macro-from-usbh drivers/usb/serial/whiteheat.c
--- a/drivers/usb/serial/whiteheat.c~revert-usb-usb-remove-info-macro-from-usbh
+++ a/drivers/usb/serial/whiteheat.c
@@ -460,9 +460,8 @@ static int whiteheat_attach(struct usb_s
 
 	hw_info = (struct whiteheat_hw_info *)&result[1];
 
-	dev_info(&serial->dev->dev, "%s: Driver %s: Firmware v%d.%02d\n",
-		 serial->type->description, DRIVER_VERSION,
-		 hw_info->sw_major_rev, hw_info->sw_minor_rev);
+	info("%s: Driver %s: Firmware v%d.%02d", serial->type->description,
+	     DRIVER_VERSION, hw_info->sw_major_rev, hw_info->sw_minor_rev);
 
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
@@ -1576,8 +1575,7 @@ static int __init whiteheat_init(void)
 	retval = usb_register(&whiteheat_driver);
 	if (retval)
 		goto failed_usb_register;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	info(DRIVER_DESC " " DRIVER_VERSION);
 	return 0;
 failed_usb_register:
 	usb_serial_deregister(&whiteheat_device);
diff -puN include/linux/usb.h~revert-usb-usb-remove-info-macro-from-usbh include/linux/usb.h
--- a/include/linux/usb.h~revert-usb-usb-remove-info-macro-from-usbh
+++ a/include/linux/usb.h
@@ -1720,6 +1720,8 @@ extern void usb_unregister_notify(struct
 
 #define err(format, arg...) printk(KERN_ERR KBUILD_MODNAME ": " \
 	format "\n" , ## arg)
+#define info(format, arg...) printk(KERN_INFO KBUILD_MODNAME ": " \
+	format "\n" , ## arg)
 
 #endif  /* __KERNEL__ */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-remove-the-might_sleep-from-lock_page.patch
git-tip.patch
markers-make-marker_synchronize_unregister-a-macro.patch
git-powerpc.patch
git-sparc.patch
git-xtensa.patch
git-pci.patch
git-hid.patch
git-v4l-dvb.patch
git-v4l-dvb-git-rejects.patch
git-nfs.patch
git-nfsd.patch
git-dlm.patch
git-scsi.patch
git-tests-fixup.patch
git-ext4.patch
git-ext4-vs-git-ocfs2.patch
git-async_tx.patch
git-net.patch
git-net-conflicts.patch
git-mtd.patch
git-vfs-vs-git-ext4.patch
git-sound.patch
git-sound-vs-git-arm.patch
git-input.patch
git-block.patch
git-block-reject-fix.patch
git-pcmcia-git-rejects.patch
git-battery.patch
git-battery-rejects.patch
git-slab-versus-git-tip.patch
git-md-rejects.patch
git-mfd.patch
git-drm.patch
revert-usb-usb-remove-info-macro-from-usbh.patch
revert-usb-usb-remove-warn-macro-from-usbh.patch
usb-usb-remove-warn-macro-from-usbh-vs-git-hid-fix.patch
usb-usb-remove-info-macro-from-usbh-more-borkage.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver.patch
misdn-misc-timerdev-fixes-fix.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-vmallocc-revert-git-tip-change.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
revert-mm-vmallocc-revert-git-tip-change.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
make-taint-bit-reliable-v3-fix.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
serial-make-uart_ports-ioport-unsigned-long-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
tpm-addition-of-pnp_remove-checkpatch-fixes.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

