From: akpm@linux-foundation.org
Subject: - hdaps-switch-to-using-input-polldev.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:14 -0700
Message-ID: <200710150917.l9F9HEY1027258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758639AbXJOJSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, dtor@mail.ru, khali@linux-fr.org, multinymous@gmail.com, nicolas@boichat.ch, rlove@rlove.org, stelian@popies.net, mm-commits@vger.kernel.org


The patch titled
     hdaps: switch to using input-polldev
has been removed from the -mm tree.  Its filename was
     hdaps-switch-to-using-input-polldev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hdaps: switch to using input-polldev
From: Dmitry Torokhov <dtor@insightbb.com>

Switch to using input-polldev skeleton instead of implementing polling loop
by itself.  This also fixes problem with trylock on a mutex in atomic
context.

(akpm: needs runtime testing by the cc'ed, please)

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Stelian Pop <stelian@popies.net>
Cc: Robert Love <rlove@rlove.org>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: "Shem Multinymous" <multinymous@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig |    1 
 drivers/hwmon/hdaps.c |   55 +++++++++++++++++-----------------------
 2 files changed, 25 insertions(+), 31 deletions(-)

diff -puN drivers/hwmon/Kconfig~hdaps-switch-to-using-input-polldev drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~hdaps-switch-to-using-input-polldev
+++ a/drivers/hwmon/Kconfig
@@ -675,6 +675,7 @@ config SENSORS_W83627EHF
 config SENSORS_HDAPS
 	tristate "IBM Hard Drive Active Protection System (hdaps)"
 	depends on INPUT && X86
+	select INPUT_POLLDEV
 	default n
 	help
 	  This driver provides support for the IBM Hard Drive Active Protection
diff -puN drivers/hwmon/hdaps.c~hdaps-switch-to-using-input-polldev drivers/hwmon/hdaps.c
--- a/drivers/hwmon/hdaps.c~hdaps-switch-to-using-input-polldev
+++ a/drivers/hwmon/hdaps.c
@@ -28,7 +28,7 @@
 
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/input.h>
+#include <linux/input-polldev.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
@@ -61,13 +61,12 @@
 #define INIT_TIMEOUT_MSECS	4000	/* wait up to 4s for device init ... */
 #define INIT_WAIT_MSECS		200	/* ... in 200ms increments */
 
-#define HDAPS_POLL_PERIOD	(HZ/20)	/* poll for input every 1/20s */
+#define HDAPS_POLL_INTERVAL	50	/* poll for input every 1/20s (50 ms)*/
 #define HDAPS_INPUT_FUZZ	4	/* input event threshold */
 #define HDAPS_INPUT_FLAT	4
 
-static struct timer_list hdaps_timer;
 static struct platform_device *pdev;
-static struct input_dev *hdaps_idev;
+static struct input_polled_dev *hdaps_idev;
 static unsigned int hdaps_invert;
 static u8 km_activity;
 static int rest_x;
@@ -323,24 +322,19 @@ static void hdaps_calibrate(void)
 	__hdaps_read_pair(HDAPS_PORT_XPOS, HDAPS_PORT_YPOS, &rest_x, &rest_y);
 }
 
-static void hdaps_mousedev_poll(unsigned long unused)
+static void hdaps_mousedev_poll(struct input_polled_dev *dev)
 {
+	struct input_dev *input_dev = dev->input;
 	int x, y;
 
-	/* Cannot sleep.  Try nonblockingly.  If we fail, try again later. */
-	if (mutex_trylock(&hdaps_mtx)) {
-		mod_timer(&hdaps_timer,jiffies + HDAPS_POLL_PERIOD);
-		return;
-	}
+	mutex_lock(&hdaps_mtx);
 
 	if (__hdaps_read_pair(HDAPS_PORT_XPOS, HDAPS_PORT_YPOS, &x, &y))
 		goto out;
 
-	input_report_abs(hdaps_idev, ABS_X, x - rest_x);
-	input_report_abs(hdaps_idev, ABS_Y, y - rest_y);
-	input_sync(hdaps_idev);
-
-	mod_timer(&hdaps_timer, jiffies + HDAPS_POLL_PERIOD);
+	input_report_abs(input_dev, ABS_X, x - rest_x);
+	input_report_abs(input_dev, ABS_Y, y - rest_y);
+	input_sync(input_dev);
 
 out:
 	mutex_unlock(&hdaps_mtx);
@@ -536,6 +530,7 @@ static struct dmi_system_id __initdata h
 
 static int __init hdaps_init(void)
 {
+	struct input_dev *idev;
 	int ret;
 
 	if (!dmi_check_system(hdaps_whitelist)) {
@@ -563,39 +558,37 @@ static int __init hdaps_init(void)
 	if (ret)
 		goto out_device;
 
-	hdaps_idev = input_allocate_device();
+	hdaps_idev = input_allocate_polled_device();
 	if (!hdaps_idev) {
 		ret = -ENOMEM;
 		goto out_group;
 	}
 
+	hdaps_idev->poll = hdaps_mousedev_poll;
+	hdaps_idev->poll_interval = HDAPS_POLL_INTERVAL;
+
 	/* initial calibrate for the input device */
 	hdaps_calibrate();
 
 	/* initialize the input class */
-	hdaps_idev->name = "hdaps";
-	hdaps_idev->dev.parent = &pdev->dev;
-	hdaps_idev->evbit[0] = BIT(EV_ABS);
-	input_set_abs_params(hdaps_idev, ABS_X,
+	idev = hdaps_idev->input;
+	idev->name = "hdaps";
+	idev->dev.parent = &pdev->dev;
+	idev->evbit[0] = BIT(EV_ABS);
+	input_set_abs_params(idev, ABS_X,
 			-256, 256, HDAPS_INPUT_FUZZ, HDAPS_INPUT_FLAT);
-	input_set_abs_params(hdaps_idev, ABS_Y,
+	input_set_abs_params(idev, ABS_Y,
 			-256, 256, HDAPS_INPUT_FUZZ, HDAPS_INPUT_FLAT);
 
-	ret = input_register_device(hdaps_idev);
+	ret = input_register_polled_device(hdaps_idev);
 	if (ret)
 		goto out_idev;
 
-	/* start up our timer for the input device */
-	init_timer(&hdaps_timer);
-	hdaps_timer.function = hdaps_mousedev_poll;
-	hdaps_timer.expires = jiffies + HDAPS_POLL_PERIOD;
-	add_timer(&hdaps_timer);
-
 	printk(KERN_INFO "hdaps: driver successfully loaded.\n");
 	return 0;
 
 out_idev:
-	input_free_device(hdaps_idev);
+	input_free_polled_device(hdaps_idev);
 out_group:
 	sysfs_remove_group(&pdev->dev.kobj, &hdaps_attribute_group);
 out_device:
@@ -611,8 +604,8 @@ out:
 
 static void __exit hdaps_exit(void)
 {
-	del_timer_sync(&hdaps_timer);
-	input_unregister_device(hdaps_idev);
+	input_unregister_polled_device(hdaps_idev);
+	input_free_polled_device(hdaps_idev);
 	sysfs_remove_group(&pdev->dev.kobj, &hdaps_attribute_group);
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&hdaps_driver);
_

Patches currently in -mm which might be from dtor@insightbb.com are

git-input.patch
