From: akpm@linux-foundation.org
Subject: + apple-smc-driver-hardware-monitoring-and-control-fix.patch added to -mm tree
Date: Mon, 09 Apr 2007 13:02:33 -0700
Message-ID: <200704092002.l39K2XXn022094@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57884 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965345AbXDIUDB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 16:03:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas@boichat.ch, benh@kernel.crashing.org, dtor@mail.ru, khali@linux-fr.org, paulus@samba.org


The patch titled
     Apple SMC driver: fix input device
has been added to the -mm tree.  Its filename is
     apple-smc-driver-hardware-monitoring-and-control-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Apple SMC driver: fix input device
From: Nicolas Boichat <nicolas@boichat.ch>

- Invert y axis on input device.
- Only activate the input device polling timer when the device is open.
- Others minor fixes asked by Dmitry Torokhov.

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff -puN drivers/hwmon/applesmc.c~apple-smc-driver-hardware-monitoring-and-control-fix drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~apple-smc-driver-hardware-monitoring-and-control-fix
+++ a/drivers/hwmon/applesmc.c
@@ -349,9 +349,22 @@ static void applesmc_calibrate(void)
 {
 	applesmc_read_motion_sensor(SENSOR_X, &rest_x);
 	applesmc_read_motion_sensor(SENSOR_Y, &rest_y);
+	rest_x = -rest_x;
 }
 
-static void applesmc_mousedev_poll(unsigned long unused)
+static int applesmc_idev_open(struct input_dev *dev)
+{
+	add_timer(&applesmc_timer);
+
+	return 0;
+}
+
+static void applesmc_idev_close(struct input_dev *dev)
+{
+	del_timer_sync(&applesmc_timer);
+}
+
+static void applesmc_idev_poll(unsigned long unused)
 {
 	s16 x, y;
 
@@ -366,6 +379,7 @@ static void applesmc_mousedev_poll(unsig
 	if (applesmc_read_motion_sensor(SENSOR_Y, &y))
 		goto out;
 
+	x = -x;
 	input_report_abs(applesmc_idev, ABS_X, x - rest_x);
 	input_report_abs(applesmc_idev, ABS_Y, y - rest_y);
 	input_sync(applesmc_idev);
@@ -739,23 +753,30 @@ static int applesmc_create_accelerometer
 
 	/* initialize the input class */
 	applesmc_idev->name = "applesmc";
+	applesmc_idev->id.bustype = BUS_HOST;
 	applesmc_idev->cdev.dev = &pdev->dev;
 	applesmc_idev->evbit[0] = BIT(EV_ABS);
+	applesmc_idev->open = applesmc_idev_open;
+	applesmc_idev->close = applesmc_idev_close;
 	input_set_abs_params(applesmc_idev, ABS_X,
 			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
 	input_set_abs_params(applesmc_idev, ABS_Y,
 			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
 
-	input_register_device(applesmc_idev);
+	ret = input_register_device(applesmc_idev);
+	if (ret)
+		goto out_idev;
 
 	/* start up our timer for the input device */
 	init_timer(&applesmc_timer);
-	applesmc_timer.function = applesmc_mousedev_poll;
+	applesmc_timer.function = applesmc_idev_poll;
 	applesmc_timer.expires = jiffies + APPLESMC_POLL_PERIOD;
-	add_timer(&applesmc_timer);
 
 	return 0;
 
+out_idev:
+	input_free_device(applesmc_idev);
+
 out:
 	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
 	return ret;
_

Patches currently in -mm which might be from nicolas@boichat.ch are

git-alsa.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-hardware-monitoring-and-control-fix.patch
