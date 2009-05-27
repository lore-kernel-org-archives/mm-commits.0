From: akpm@linux-foundation.org
Subject: + lis3-remove-automatic-shutdown-of-the-device.patch added to -mm tree
Date: Tue, 26 May 2009 19:22:26 -0700
Message-ID: <200905270222.n4R2MQKf030844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467AbZE0CWc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 22:22:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: remove automatic shutdown of the device
has been added to the -mm tree.  Its filename is
     lis3-remove-automatic-shutdown-of-the-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3: remove automatic shutdown of the device
From: Eric Piel <eric.piel@tremplin-utc.net>

After measurement on my laptop, it seems that turning off the device does
not bring any energy saving (within 0.1W precision).  So let's keep the
device always on.  It simplifies the code, and it avoids the problem of
reading a wrong value sometimes just after turning the device on.

Moreover, since commit ef2cfc790bf5f0ff189b01eabc0f4feb5e8524df had been
too zealous, the device was actually never turned off anyway.  This patch
also restores the damages done by this commit concerning the
initialisation/poweroff.

Also do more clean up with the usage of the lis3_dev global variable.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c  |   10 ----
 drivers/hwmon/lis3lv02d.c |   90 ++++++++++++------------------------
 drivers/hwmon/lis3lv02d.h |    5 --
 3 files changed, 33 insertions(+), 72 deletions(-)

diff -puN drivers/hwmon/hp_accel.c~lis3-remove-automatic-shutdown-of-the-device drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3-remove-automatic-shutdown-of-the-device
+++ a/drivers/hwmon/hp_accel.c
@@ -324,7 +324,7 @@ static int lis3lv02d_remove(struct acpi_
 	flush_work(&hpled_led.work);
 	led_classdev_unregister(&hpled_led.led_classdev);
 
-	return lis3lv02d_remove_fs();
+	return lis3lv02d_remove_fs(&lis3_dev);
 }
 
 
@@ -338,13 +338,7 @@ static int lis3lv02d_suspend(struct acpi
 
 static int lis3lv02d_resume(struct acpi_device *device)
 {
-	/* put back the device in the right state (ACPI might turn it on) */
-	mutex_lock(&lis3_dev.lock);
-	if (lis3_dev.usage > 0)
-		lis3lv02d_poweron(&lis3_dev);
-	else
-		lis3lv02d_poweroff(&lis3_dev);
-	mutex_unlock(&lis3_dev.lock);
+	lis3lv02d_poweron(&lis3_dev);
 	return 0;
 }
 #else
diff -puN drivers/hwmon/lis3lv02d.c~lis3-remove-automatic-shutdown-of-the-device drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-remove-automatic-shutdown-of-the-device
+++ a/drivers/hwmon/lis3lv02d.c
@@ -105,56 +105,39 @@ static void lis3lv02d_get_xyz(struct lis
 {
 	int position[3];
 
-	position[0] = lis3_dev.read_data(lis3, OUTX);
-	position[1] = lis3_dev.read_data(lis3, OUTY);
-	position[2] = lis3_dev.read_data(lis3, OUTZ);
-
-	*x = lis3lv02d_get_axis(lis3_dev.ac.x, position);
-	*y = lis3lv02d_get_axis(lis3_dev.ac.y, position);
-	*z = lis3lv02d_get_axis(lis3_dev.ac.z, position);
+	position[0] = lis3->read_data(lis3, OUTX);
+	position[1] = lis3->read_data(lis3, OUTY);
+	position[2] = lis3->read_data(lis3, OUTZ);
+
+	*x = lis3lv02d_get_axis(lis3->ac.x, position);
+	*y = lis3lv02d_get_axis(lis3->ac.y, position);
+	*z = lis3lv02d_get_axis(lis3->ac.z, position);
 }
 
 void lis3lv02d_poweroff(struct lis3lv02d *lis3)
 {
-	lis3_dev.is_on = 0;
+	/* disable X,Y,Z axis and power down */
+	lis3->write(lis3, CTRL_REG1, 0x00);
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
 
 void lis3lv02d_poweron(struct lis3lv02d *lis3)
 {
-	lis3_dev.is_on = 1;
-	lis3_dev.init(lis3);
-}
-EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
+	u8 reg;
 
-/*
- * To be called before starting to use the device. It makes sure that the
- * device will always be on until a call to lis3lv02d_decrease_use(). Not to be
- * used from interrupt context.
- */
-static void lis3lv02d_increase_use(struct lis3lv02d *dev)
-{
-	mutex_lock(&dev->lock);
-	dev->usage++;
-	if (dev->usage == 1) {
-		if (!dev->is_on)
-			lis3lv02d_poweron(dev);
-	}
-	mutex_unlock(&dev->lock);
-}
+	lis3->init(lis3);
 
-/*
- * To be called whenever a usage of the device is stopped.
- * It will make sure to turn off the device when there is not usage.
- */
-static void lis3lv02d_decrease_use(struct lis3lv02d *dev)
-{
-	mutex_lock(&dev->lock);
-	dev->usage--;
-	if (dev->usage == 0)
-		lis3lv02d_poweroff(dev);
-	mutex_unlock(&dev->lock);
+	/*
+	 * Common configuration
+	 * BDU: LSB and MSB values are not updated until both have been read.
+	 *      So the value read will always be correct.
+	 */
+	lis3->read(lis3, CTRL_REG2, &reg);
+	reg |= CTRL2_BDU;
+	lis3->write(lis3, CTRL_REG2, reg);
 }
+EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
+
 
 static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 {
@@ -198,14 +181,12 @@ static int lis3lv02d_misc_open(struct in
 		printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", lis3_dev.irq);
 		return -EBUSY;
 	}
-	lis3lv02d_increase_use(&lis3_dev);
 	return 0;
 }
 
 static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
 {
 	fasync_helper(-1, file, 0, &lis3_dev.async_queue);
-	lis3lv02d_decrease_use(&lis3_dev);
 	free_irq(lis3_dev.irq, &lis3_dev);
 	clear_bit(0, &lis3_dev.misc_opened); /* release the device */
 	return 0;
@@ -314,10 +295,8 @@ static int lis3lv02d_joystick_kthread(vo
 
 static int lis3lv02d_joystick_open(struct input_dev *input)
 {
-	lis3lv02d_increase_use(&lis3_dev);
 	lis3_dev.kthread = kthread_run(lis3lv02d_joystick_kthread, NULL, "klis3lv02d");
 	if (IS_ERR(lis3_dev.kthread)) {
-		lis3lv02d_decrease_use(&lis3_dev);
 		return PTR_ERR(lis3_dev.kthread);
 	}
 
@@ -327,7 +306,6 @@ static int lis3lv02d_joystick_open(struc
 static void lis3lv02d_joystick_close(struct input_dev *input)
 {
 	kthread_stop(lis3_dev.kthread);
-	lis3lv02d_decrease_use(&lis3_dev);
 }
 
 static inline void lis3lv02d_calibrate_joystick(void)
@@ -390,9 +368,7 @@ static ssize_t lis3lv02d_position_show(s
 {
 	int x, y, z;
 
-	lis3lv02d_increase_use(&lis3_dev);
 	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
-	lis3lv02d_decrease_use(&lis3_dev);
 	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
 }
 
@@ -406,9 +382,7 @@ static ssize_t lis3lv02d_calibrate_store
 				struct device_attribute *attr,
 				const char *buf, size_t count)
 {
-	lis3lv02d_increase_use(&lis3_dev);
 	lis3lv02d_calibrate_joystick();
-	lis3lv02d_decrease_use(&lis3_dev);
 	return count;
 }
 
@@ -420,9 +394,7 @@ static ssize_t lis3lv02d_rate_show(struc
 	u8 ctrl;
 	int val;
 
-	lis3lv02d_increase_use(&lis3_dev);
 	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
-	lis3lv02d_decrease_use(&lis3_dev);
 	val = (ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4;
 	return sprintf(buf, "%d\n", lis3lv02dl_df_val[val]);
 }
@@ -446,17 +418,17 @@ static struct attribute_group lis3lv02d_
 
 static int lis3lv02d_add_fs(struct lis3lv02d *lis3)
 {
-	lis3_dev.pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
-	if (IS_ERR(lis3_dev.pdev))
-		return PTR_ERR(lis3_dev.pdev);
+	lis3->pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
+	if (IS_ERR(lis3->pdev))
+		return PTR_ERR(lis3->pdev);
 
-	return sysfs_create_group(&lis3_dev.pdev->dev.kobj, &lis3lv02d_attribute_group);
+	return sysfs_create_group(&lis3->pdev->dev.kobj, &lis3lv02d_attribute_group);
 }
 
-int lis3lv02d_remove_fs(void)
+int lis3lv02d_remove_fs(struct lis3lv02d *lis3)
 {
-	sysfs_remove_group(&lis3_dev.pdev->dev.kobj, &lis3lv02d_attribute_group);
-	platform_device_unregister(lis3_dev.pdev);
+	sysfs_remove_group(&lis3->pdev->dev.kobj, &lis3lv02d_attribute_group);
+	platform_device_unregister(lis3->pdev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
@@ -482,13 +454,12 @@ int lis3lv02d_init_device(struct lis3lv0
 		break;
 	default:
 		printk(KERN_ERR DRIVER_NAME
-			": unknown sensor type 0x%X\n", lis3_dev.whoami);
+			": unknown sensor type 0x%X\n", dev->whoami);
 		return -EINVAL;
 	}
 
-	mutex_init(&dev->lock);
 	lis3lv02d_add_fs(dev);
-	lis3lv02d_increase_use(dev);
+	lis3lv02d_poweron(dev);
 
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
@@ -503,7 +474,6 @@ int lis3lv02d_init_device(struct lis3lv0
 	if (misc_register(&lis3lv02d_misc_device))
 		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
 out:
-	lis3lv02d_decrease_use(dev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
diff -puN drivers/hwmon/lis3lv02d.h~lis3-remove-automatic-shutdown-of-the-device drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-remove-automatic-shutdown-of-the-device
+++ a/drivers/hwmon/lis3lv02d.h
@@ -171,14 +171,11 @@ struct lis3lv02d {
 
 	struct input_dev	*idev;     /* input device */
 	struct task_struct	*kthread;  /* kthread for input */
-	struct mutex            lock;
 	struct platform_device	*pdev;     /* platform device */
 	atomic_t		count;     /* interrupt count after last read */
 	int			xcalib;    /* calibrated null value for x */
 	int			ycalib;    /* calibrated null value for y */
 	int			zcalib;    /* calibrated null value for z */
-	unsigned char		is_on;     /* whether the device is on or off */
-	unsigned char		usage;     /* usage counter */
 	struct axis_conversion	ac;        /* hw -> logical axis */
 
 	u32			irq;       /* IRQ number */
@@ -192,6 +189,6 @@ int lis3lv02d_joystick_enable(void);
 void lis3lv02d_joystick_disable(void);
 void lis3lv02d_poweroff(struct lis3lv02d *lis3);
 void lis3lv02d_poweron(struct lis3lv02d *lis3);
-int lis3lv02d_remove_fs(void);
+int lis3lv02d_remove_fs(struct lis3lv02d *lis3);
 
 extern struct lis3lv02d lis3_dev;
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

linux-next.patch
lis3-fix-misc-device-unregistering-and-printk.patch
lis3-remove-automatic-shutdown-of-the-device.patch
lis3-use-input_polled_device.patch
lis3-add-three-new-laptop-models.patch

