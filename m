From: akpm@linux-foundation.org
Subject: + ams-switch-to-using-input-polldev.patch added to -mm tree
Date: Tue, 29 May 2007 13:18:25 -0700
Message-ID: <200705292018.l4TKIP5f010543@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbXE2UTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@insightbb.com, dtor@mail.ru, khali@linux-fr.org, nicolas@boichat.ch, rlove@rlove.org, stelian@popies.net


The patch titled
     ams: switch to using input-polldev
has been added to the -mm tree.  Its filename is
     ams-switch-to-using-input-polldev.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ams: switch to using input-polldev
From: Dmitry Torokhov <dtor@insightbb.com>

Switch to using input-polldev skeleton instead of implementing polling loop by
itself.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Stelian Pop <stelian@popies.net>
Cc: Robert Love <rlove@rlove.org>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig         |    1 
 drivers/hwmon/ams/ams-input.c |   82 +++++++++++++-------------------
 drivers/hwmon/ams/ams.h       |    5 -
 3 files changed, 38 insertions(+), 50 deletions(-)

diff -puN drivers/hwmon/Kconfig~ams-switch-to-using-input-polldev drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~ams-switch-to-using-input-polldev
+++ a/drivers/hwmon/Kconfig
@@ -131,6 +131,7 @@ config SENSORS_K8TEMP
 config SENSORS_AMS
 	tristate "Apple Motion Sensor driver"
 	depends on PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) || (ADB_PMU && !I2C) || I2C) && EXPERIMENTAL
+	select INPUT_POLLDEV
 	help
 	  Support for the motion sensor included in PowerBooks. Includes
 	  implementations for PMU and I2C.
diff -puN drivers/hwmon/ams/ams-input.c~ams-switch-to-using-input-polldev drivers/hwmon/ams/ams-input.c
--- a/drivers/hwmon/ams/ams-input.c~ams-switch-to-using-input-polldev
+++ a/drivers/hwmon/ams/ams-input.c
@@ -27,47 +27,32 @@ static unsigned int invert;
 module_param(invert, bool, 0644);
 MODULE_PARM_DESC(invert, "Invert input data on X and Y axis");
 
-static int ams_input_kthread(void *data)
+static void ams_idev_poll(struct input_polled_dev *dev)
 {
+	struct input_dev *idev = dev->input;
 	s8 x, y, z;
 
-	while (!kthread_should_stop()) {
-		mutex_lock(&ams_info.lock);
-
-		ams_sensors(&x, &y, &z);
-
-		x -= ams_info.xcalib;
-		y -= ams_info.ycalib;
-		z -= ams_info.zcalib;
-
-		input_report_abs(ams_info.idev, ABS_X, invert ? -x : x);
-		input_report_abs(ams_info.idev, ABS_Y, invert ? -y : y);
-		input_report_abs(ams_info.idev, ABS_Z, z);
-
-		input_sync(ams_info.idev);
-
-		mutex_unlock(&ams_info.lock);
+	mutex_lock(&ams_info.lock);
 
-		msleep(25);
-	}
+	ams_sensors(&x, &y, &z);
 
-	return 0;
-}
+	x -= ams_info.xcalib;
+	y -= ams_info.ycalib;
+	z -= ams_info.zcalib;
+
+	input_report_abs(idev, ABS_X, invert ? -x : x);
+	input_report_abs(idev, ABS_Y, invert ? -y : y);
+	input_report_abs(idev, ABS_Z, z);
 
-static int ams_input_open(struct input_dev *dev)
-{
-	ams_info.kthread = kthread_run(ams_input_kthread, NULL, "kams");
-	return IS_ERR(ams_info.kthread) ? PTR_ERR(ams_info.kthread) : 0;
-}
+	input_sync(idev);
 
-static void ams_input_close(struct input_dev *dev)
-{
-	kthread_stop(ams_info.kthread);
+	mutex_unlock(&ams_info.lock);
 }
 
 /* Call with ams_info.lock held! */
 static void ams_input_enable(void)
 {
+	struct input_dev *input;
 	s8 x, y, z;
 
 	if (ams_info.idev)
@@ -78,27 +63,29 @@ static void ams_input_enable(void)
 	ams_info.ycalib = y;
 	ams_info.zcalib = z;
 
-	ams_info.idev = input_allocate_device();
+	ams_info.idev = input_allocate_polled_device();
 	if (!ams_info.idev)
 		return;
 
-	ams_info.idev->name = "Apple Motion Sensor";
-	ams_info.idev->id.bustype = ams_info.bustype;
-	ams_info.idev->id.vendor = 0;
-	ams_info.idev->open = ams_input_open;
-	ams_info.idev->close = ams_input_close;
-	ams_info.idev->dev.parent = &ams_info.of_dev->dev;
-
-	input_set_abs_params(ams_info.idev, ABS_X, -50, 50, 3, 0);
-	input_set_abs_params(ams_info.idev, ABS_Y, -50, 50, 3, 0);
-	input_set_abs_params(ams_info.idev, ABS_Z, -50, 50, 3, 0);
-
-	set_bit(EV_ABS, ams_info.idev->evbit);
-	set_bit(EV_KEY, ams_info.idev->evbit);
-	set_bit(BTN_TOUCH, ams_info.idev->keybit);
+	ams_info.idev->poll = ams_idev_poll;
+	ams_info.idev->poll_interval = 25;
+
+	input = ams_info.idev->input;
+	input->name = "Apple Motion Sensor";
+	input->id.bustype = ams_info.bustype;
+	input->id.vendor = 0;
+	input->dev.parent = &ams_info.of_dev->dev;
+
+	input_set_abs_params(input, ABS_X, -50, 50, 3, 0);
+	input_set_abs_params(input, ABS_Y, -50, 50, 3, 0);
+	input_set_abs_params(input, ABS_Z, -50, 50, 3, 0);
+
+	set_bit(EV_ABS, input->evbit);
+	set_bit(EV_KEY, input->evbit);
+	set_bit(BTN_TOUCH, input->keybit);
 
-	if (input_register_device(ams_info.idev)) {
-		input_free_device(ams_info.idev);
+	if (input_register_polled_device(ams_info.idev)) {
+		input_free_polled_device(ams_info.idev);
 		ams_info.idev = NULL;
 		return;
 	}
@@ -108,7 +95,8 @@ static void ams_input_enable(void)
 static void ams_input_disable(void)
 {
 	if (ams_info.idev) {
-		input_unregister_device(ams_info.idev);
+		input_unregister_polled_device(ams_info.idev);
+		input_free_polled_device(ams_info.idev);
 		ams_info.idev = NULL;
 	}
 }
diff -puN drivers/hwmon/ams/ams.h~ams-switch-to-using-input-polldev drivers/hwmon/ams/ams.h
--- a/drivers/hwmon/ams/ams.h~ams-switch-to-using-input-polldev
+++ a/drivers/hwmon/ams/ams.h
@@ -1,5 +1,5 @@
 #include <linux/i2c.h>
-#include <linux/input.h>
+#include <linux/input-polldev.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -52,8 +52,7 @@ struct ams {
 #endif
 
 	/* Joystick emulation */
-	struct task_struct *kthread;
-	struct input_dev *idev;
+	struct input_polled_dev *idev;
 	__u16 bustype;
 
 	/* calibrated null values */
_

Patches currently in -mm which might be from dtor@insightbb.com are

git-dvb.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch
git-input.patch
input-reduce-raciness-when-input-handlers-disconnect.patch
input-convert-from-class-devices-to-standard-devices.patch
ibmasm-whitespace-cleanup.patch
ibmasm-dont-use-extern-in-function-declarations.patch
ibmasm-miscellaneous-fixes.patch
ibmasm-must-depend-on-config_input.patch
