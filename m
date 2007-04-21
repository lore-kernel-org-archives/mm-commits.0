From: akpm@linux-foundation.org
Subject: + applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:29:56 -0700
Message-ID: <200704210029.l3L0TuYn027381@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXDUAaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas@boichat.ch, khali@linux-fr.org


The patch titled
     applesmc: fix crash when activating a led trigger on the  keyboard backlight - use a workqueue
has been added to the -mm tree.  Its filename is
     applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: applesmc: fix crash when activating a led trigger on the  keyboard backlight - use a workqueue


- Cannot sleep in led->brightness_set handler, as it might be called from
  a softirq, so we use a workqueue to change the brightness (as recommended
  by Richard Purdie)

- Reduce wait_status timetout from 100ms to 2ms, as wait_status either
  takes less than 1.5 ms, or fails.

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   61 +++++++++++++++++++++++++++++--------
 1 files changed, 49 insertions(+), 12 deletions(-)

diff -puN drivers/hwmon/applesmc.c~applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue
+++ a/drivers/hwmon/applesmc.c
@@ -38,6 +38,7 @@
 #include <asm/io.h>
 #include <linux/leds.h>
 #include <linux/hwmon.h>
+#include <linux/workqueue.h>
 
 /* data port used by Apple SMC */
 #define APPLESMC_DATA_PORT	0x300
@@ -116,7 +117,7 @@ struct dmi_match_data {
 	int temperature_set;
 };
 
-static int debug = 0;
+static const int debug = 0;
 static struct platform_device *pdev;
 static s16 rest_x;
 static s16 rest_y;
@@ -141,8 +142,10 @@ static struct mutex applesmc_lock;
  */
 static unsigned int key_at_index;
 
+static struct workqueue_struct *applesmc_led_wq;
+
 /*
- * __wait_status - Wait up to 100ms for the status port to get a certain value
+ * __wait_status - Wait up to 2ms for the status port to get a certain value
  * (masked with 0x0f), returning zero if the value is obtained.  Callers must
  * hold applesmc_lock.
  */
@@ -152,9 +155,14 @@ static int __wait_status(u8 val)
 
 	val = val & APPLESMC_STATUS_MASK;
 
-	for (i = 0; i < 10000; i++) {
-		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val)
+	for (i = 0; i < 200; i++) {
+		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val) {
+			if (debug)
+				printk(KERN_DEBUG
+						"Waited %d us for status %x\n",
+						i*10, val);
 			return 0;
+		}
 		udelay(10);
 	}
 
@@ -721,17 +729,33 @@ static ssize_t applesmc_calibrate_store(
 	return count;
 }
 
-static void applesmc_backlight_set(struct led_classdev *led_cdev,
-						enum led_brightness value)
+/* Store the next backlight value to be written by the work */
+static unsigned int backlight_value;
+
+static void applesmc_backlight_set(struct work_struct *work)
 {
 	u8 buffer[2];
 
 	mutex_lock(&applesmc_lock);
-	buffer[0] = value;
+	buffer[0] = backlight_value;
 	buffer[1] = 0x00;
 	applesmc_write_key(BACKLIGHT_KEY, buffer, 2);
 	mutex_unlock(&applesmc_lock);
 }
+DECLARE_WORK(backlight_work, &applesmc_backlight_set);
+
+static void applesmc_brightness_set(struct led_classdev *led_cdev,
+						enum led_brightness value)
+{
+	int ret;
+
+	backlight_value = value;
+	ret = queue_work(applesmc_led_wq, &backlight_work);
+
+	if (debug && (!ret)) {
+		printk(KERN_DEBUG "applesmc: work was already on the queue.\n");
+	}
+}
 
 static ssize_t applesmc_key_count_show(struct device *dev,
 				struct device_attribute *attr, char *sysfsbuf)
@@ -887,7 +911,7 @@ static ssize_t applesmc_key_at_index_sto
 static struct led_classdev applesmc_backlight = {
 	.name			= "smc:kbd_backlight",
 	.default_trigger	= "nand-disk",
-	.brightness_set		= applesmc_backlight_set,
+	.brightness_set		= applesmc_brightness_set,
 };
 
 static DEVICE_ATTR(position, 0444, applesmc_position_show, NULL);
@@ -1234,25 +1258,35 @@ static int __init applesmc_init(void)
 		if (ret)
 			goto out_accelerometer;
 
+		/* Create the workqueue */
+		applesmc_led_wq = create_singlethread_workqueue("applesmc-led");
+		if (!applesmc_led_wq) {
+			ret = -ENOMEM;
+			goto out_light_sysfs;
+		}
+
 		/* register as a led device */
 		ret = led_classdev_register(&pdev->dev, &applesmc_backlight);
 		if (ret < 0)
-			goto out_light_sysfs;
+			goto out_light_wq;
 	}
 
 	hwmon_class_dev = hwmon_device_register(&pdev->dev);
 	if (IS_ERR(hwmon_class_dev)) {
 		ret = PTR_ERR(hwmon_class_dev);
-		goto out_light;
+		goto out_light_ledclass;
 	}
 
 	printk(KERN_INFO "applesmc: driver successfully loaded.\n");
 
 	return 0;
 
-out_light:
+out_light_ledclass:
 	if (applesmc_light)
 		led_classdev_unregister(&applesmc_backlight);
+out_light_wq:
+	if (applesmc_light)
+		destroy_workqueue(applesmc_led_wq);
 out_light_sysfs:
 	if (applesmc_light)
 		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_light.attr);
@@ -1280,8 +1314,11 @@ out:
 static void __exit applesmc_exit(void)
 {
 	hwmon_device_unregister(hwmon_class_dev);
-	if (applesmc_light)
+	if (applesmc_light) {
 		led_classdev_unregister(&applesmc_backlight);
+		destroy_workqueue(applesmc_led_wq);
+		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_light.attr);
+	}
 	if (applesmc_accelerometer)
 		applesmc_release_accelerometer();
 	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
_

Patches currently in -mm which might be from nicolas@boichat.ch are

git-alsa.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-hardware-monitoring-and-control-fix.patch
apple-smc-driver-standardize-and-sanitize-sysfs-tree.patch
apple-smc-driver-implement-key-enumeration.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue.patch
