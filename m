From: akpm@linux-foundation.org
Subject: - applesmc-switch-to-using-input-polldev.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:59 -0700
Message-ID: <200709160926.l8G9QxSN009223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbXIPJj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, dtor@mail.ru, khali@linux-fr.org, nicolas@boichat.ch, rlove@rlove.org, stelian@popies.net, mm-commits@vger.kernel.org


The patch titled
     applesmc: switch to using input-polldev
has been removed from the -mm tree.  Its filename was
     applesmc-switch-to-using-input-polldev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -696,6 +696,7 @@ config SENSORS_APPLESMC
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
@@ -103,7 +103,7 @@ static const char* fan_speed_keys[] = {
 #define INIT_TIMEOUT_MSECS	5000	/* wait up to 5s for device init ... */
 #define INIT_WAIT_MSECS		50	/* ... in 50ms increments */
 
-#define APPLESMC_POLL_PERIOD	(HZ/20)	/* poll for input every 1/20s */
+#define APPLESMC_POLL_INTERVAL	50	/* msecs */
 #define APPLESMC_INPUT_FUZZ	4	/* input event threshold */
 #define APPLESMC_INPUT_FLAT	4
 
@@ -125,8 +125,7 @@ static const int debug;
 static struct platform_device *pdev;
 static s16 rest_x;
 static s16 rest_y;
-static struct timer_list applesmc_timer;
-static struct input_dev *applesmc_idev;
+static struct input_polled_dev *applesmc_idev;
 static struct device *hwmon_dev;
 
 /* Indicates whether this computer has an accelerometer. */
@@ -138,7 +137,7 @@ static unsigned int applesmc_light;
 /* Indicates which temperature sensors set to use. */
 static unsigned int applesmc_temperature_set;
 
-static struct mutex applesmc_lock;
+static DEFINE_MUTEX(applesmc_lock);
 
 /*
  * Last index written to key_at_index sysfs file, and value to use for all other
@@ -455,27 +454,12 @@ static void applesmc_calibrate(void)
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
@@ -483,13 +467,11 @@ static void applesmc_idev_poll(unsigned 
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
 
@@ -821,8 +803,7 @@ static ssize_t applesmc_key_at_index_rea
 
 	if (!ret) {
 		return info[0];
-	}
-	else {
+	} else {
 		return ret;
 	}
 }
@@ -1093,6 +1074,7 @@ static int applesmc_dmi_match(struct dmi
 /* Create accelerometer ressources */
 static int applesmc_create_accelerometer(void)
 {
+	struct input_dev *idev;
 	int ret;
 
 	ret = sysfs_create_group(&pdev->dev.kobj,
@@ -1100,40 +1082,37 @@ static int applesmc_create_accelerometer
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
@@ -1146,8 +1125,8 @@ out:
 /* Release all ressources used by the accelerometer */
 static void applesmc_release_accelerometer(void)
 {
-	del_timer_sync(&applesmc_timer);
-	input_unregister_device(applesmc_idev);
+	input_unregister_polled_device(applesmc_idev);
+	input_free_polled_device(applesmc_idev);
 	sysfs_remove_group(&pdev->dev.kobj, &accelerometer_attributes_group);
 }
 
@@ -1184,8 +1163,6 @@ static int __init applesmc_init(void)
 	int count;
 	int i;
 
-	mutex_init(&applesmc_lock);
-
 	if (!dmi_check_system(applesmc_whitelist)) {
 		printk(KERN_WARNING "applesmc: supported laptop not found!\n");
 		ret = -ENODEV;
_

Patches currently in -mm which might be from dtor@insightbb.com are

git-input.patch
hdaps-switch-to-using-input-polldev.patch
driver-core-fix-deprectated-sysfs-structure-for-nested-class-devices.patch
