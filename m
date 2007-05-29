From: akpm@linux-foundation.org
Subject: + applesmc-switch-to-using-input-polldev.patch added to -mm tree
Date: Tue, 29 May 2007 13:18:23 -0700
Message-ID: <200705292018.l4TKINvl010540@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbXE2UTi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:19:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@insightbb.com, dtor@mail.ru, khali@linux-fr.org, nicolas@boichat.ch, rlove@rlove.org, stelian@popies.net


The patch titled
     applesmc: switch to using input-polldev
has been added to the -mm tree.  Its filename is
     applesmc-switch-to-using-input-polldev.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: applesmc: switch to using input-polldev
From: Dmitry Torokhov <dtor@insightbb.com>

Switch to using input-polldev skeleton instead of implementing polling loop by
itself.  This also fixes problem with trylock on a mutex in atomic context.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Stelian Pop <stelian@popies.net>
Cc: Robert Love <rlove@rlove.org>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig    |    1 
 drivers/hwmon/applesmc.c |   83 +++++++++++++------------------------
 2 files changed, 31 insertions(+), 53 deletions(-)

diff -puN drivers/hwmon/Kconfig~applesmc-switch-to-using-input-polldev drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~applesmc-switch-to-using-input-polldev
+++ a/drivers/hwmon/Kconfig
@@ -634,6 +634,7 @@ config SENSORS_APPLESMC
 	depends on INPUT && X86
 	select NEW_LEDS
 	select LEDS_CLASS
+	select INPUT_POLLDEV
 	default n
 	help
 	  This driver provides support for the Apple System Management
diff -puN drivers/hwmon/applesmc.c~applesmc-switch-to-using-input-polldev drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-switch-to-using-input-polldev
+++ a/drivers/hwmon/applesmc.c
@@ -28,7 +28,7 @@
 
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/input.h>
+#include <linux/input-polldev.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/timer.h>
@@ -59,9 +59,9 @@
 
 #define LIGHT_SENSOR_LEFT_KEY	"ALV0" /* r-o {alv (6 bytes) */
 #define LIGHT_SENSOR_RIGHT_KEY	"ALV1" /* r-o {alv (6 bytes) */
-#define BACKLIGHT_KEY 		"LKSB" /* w-o {lkb (2 bytes) */
+#define BACKLIGHT_KEY		"LKSB" /* w-o {lkb (2 bytes) */
 
-#define CLAMSHELL_KEY 		"MSLD" /* r-o ui8 (unused) */
+#define CLAMSHELL_KEY		"MSLD" /* r-o ui8 (unused) */
 
 #define MOTION_SENSOR_X_KEY	"MO_X" /* r-o sp78 (2 bytes) */
 #define MOTION_SENSOR_Y_KEY	"MO_Y" /* r-o sp78 (2 bytes) */
@@ -99,7 +99,7 @@ static const char* fan_speed_keys[] = {
 #define INIT_TIMEOUT_MSECS	5000	/* wait up to 5s for device init ... */
 #define INIT_WAIT_MSECS		50	/* ... in 50ms increments */
 
-#define APPLESMC_POLL_PERIOD	(HZ/20)	/* poll for input every 1/20s */
+#define APPLESMC_POLL_INTERVAL	50	/* msecs */
 #define APPLESMC_INPUT_FUZZ	4	/* input event threshold */
 #define APPLESMC_INPUT_FLAT	4
 
@@ -121,8 +121,7 @@ static const int debug;
 static struct platform_device *pdev;
 static s16 rest_x;
 static s16 rest_y;
-static struct timer_list applesmc_timer;
-static struct input_dev *applesmc_idev;
+static struct input_polled_dev *applesmc_idev;
 static struct class_device *hwmon_class_dev;
 
 /* Indicates whether this computer has an accelerometer. */
@@ -134,7 +133,7 @@ static unsigned int applesmc_light;
 /* Indicates which temperature sensors set to use. */
 static unsigned int applesmc_temperature_set;
 
-static struct mutex applesmc_lock;
+static DEFINE_MUTEX(applesmc_lock);
 
 /*
  * Last index written to key_at_index sysfs file, and value to use for all other
@@ -451,27 +450,12 @@ static void applesmc_calibrate(void)
 	rest_x = -rest_x;
 }
 
-static int applesmc_idev_open(struct input_dev *dev)
-{
-	add_timer(&applesmc_timer);
-
-	return 0;
-}
-
-static void applesmc_idev_close(struct input_dev *dev)
-{
-	del_timer_sync(&applesmc_timer);
-}
-
-static void applesmc_idev_poll(unsigned long unused)
+static void applesmc_idev_poll(struct input_polled_dev *dev)
 {
+	struct input_dev *idev = dev->input;
 	s16 x, y;
 
-	/* Cannot sleep.  Try nonblockingly.  If we fail, try again later. */
-	if (!mutex_trylock(&applesmc_lock)) {
-		mod_timer(&applesmc_timer, jiffies + APPLESMC_POLL_PERIOD);
-		return;
-	}
+	mutex_lock(&applesmc_lock);
 
 	if (applesmc_read_motion_sensor(SENSOR_X, &x))
 		goto out;
@@ -479,13 +463,11 @@ static void applesmc_idev_poll(unsigned 
 		goto out;
 
 	x = -x;
-	input_report_abs(applesmc_idev, ABS_X, x - rest_x);
-	input_report_abs(applesmc_idev, ABS_Y, y - rest_y);
-	input_sync(applesmc_idev);
+	input_report_abs(idev, ABS_X, x - rest_x);
+	input_report_abs(idev, ABS_Y, y - rest_y);
+	input_sync(idev);
 
 out:
-	mod_timer(&applesmc_timer, jiffies + APPLESMC_POLL_PERIOD);
-
 	mutex_unlock(&applesmc_lock);
 }
 
@@ -817,8 +799,7 @@ static ssize_t applesmc_key_at_index_rea
 
 	if (!ret) {
 		return info[0];
-	}
-	else {
+	} else {
 		return ret;
 	}
 }
@@ -1089,6 +1070,7 @@ static int applesmc_dmi_match(struct dmi
 /* Create accelerometer ressources */
 static int applesmc_create_accelerometer(void)
 {
+	struct input_dev *idev;
 	int ret;
 
 	ret = sysfs_create_group(&pdev->dev.kobj,
@@ -1096,40 +1078,37 @@ static int applesmc_create_accelerometer
 	if (ret)
 		goto out;
 
-	applesmc_idev = input_allocate_device();
+	applesmc_idev = input_allocate_polled_device();
 	if (!applesmc_idev) {
 		ret = -ENOMEM;
 		goto out_sysfs;
 	}
 
+	applesmc_idev->poll = applesmc_idev_poll;
+	applesmc_idev->poll_interval = APPLESMC_POLL_INTERVAL;
+
 	/* initial calibrate for the input device */
 	applesmc_calibrate();
 
-	/* initialize the input class */
-	applesmc_idev->name = "applesmc";
-	applesmc_idev->id.bustype = BUS_HOST;
-	applesmc_idev->dev.parent = &pdev->dev;
-	applesmc_idev->evbit[0] = BIT(EV_ABS);
-	applesmc_idev->open = applesmc_idev_open;
-	applesmc_idev->close = applesmc_idev_close;
-	input_set_abs_params(applesmc_idev, ABS_X,
+	/* initialize the input device */
+	idev = applesmc_idev->input;
+	idev->name = "applesmc";
+	idev->id.bustype = BUS_HOST;
+	idev->dev.parent = &pdev->dev;
+	idev->evbit[0] = BIT(EV_ABS);
+	input_set_abs_params(idev, ABS_X,
 			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
-	input_set_abs_params(applesmc_idev, ABS_Y,
+	input_set_abs_params(idev, ABS_Y,
 			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
 
-	ret = input_register_device(applesmc_idev);
+	ret = input_register_polled_device(applesmc_idev);
 	if (ret)
 		goto out_idev;
 
-	/* start up our timer for the input device */
-	init_timer(&applesmc_timer);
-	applesmc_timer.function = applesmc_idev_poll;
-	applesmc_timer.expires = jiffies + APPLESMC_POLL_PERIOD;
-
 	return 0;
 
 out_idev:
-	input_free_device(applesmc_idev);
+	input_free_polled_device(applesmc_idev);
 
 out_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &accelerometer_attributes_group);
@@ -1142,8 +1121,8 @@ out:
 /* Release all ressources used by the accelerometer */
 static void applesmc_release_accelerometer(void)
 {
-	del_timer_sync(&applesmc_timer);
-	input_unregister_device(applesmc_idev);
+	input_unregister_polled_device(applesmc_idev);
+	input_free_polled_device(applesmc_idev);
 	sysfs_remove_group(&pdev->dev.kobj, &accelerometer_attributes_group);
 }
 
@@ -1180,8 +1159,6 @@ static int __init applesmc_init(void)
 	int count;
 	int i;
 
-	mutex_init(&applesmc_lock);
-
 	if (!dmi_check_system(applesmc_whitelist)) {
 		printk(KERN_WARNING "applesmc: supported laptop not found!\n");
 		ret = -ENODEV;
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
