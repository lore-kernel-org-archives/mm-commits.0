From: akpm@linux-foundation.org
Subject: + lis3-reorder-functions-to-make-forward-decl-obsolete.patch added to -mm tree
Date: Mon, 30 Mar 2009 16:26:43 -0700
Message-ID: <200903302326.n2UNQhU4022685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbZC3X3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: reorder functions to make forward decl obsolete
has been added to the -mm tree.  Its filename is
     lis3-reorder-functions-to-make-forward-decl-obsolete.patch

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
Subject: lis3: reorder functions to make forward decl obsolete
From: Daniel Mack <daniel@caiaq.de>

Move lis3lv02d_init_device() down so that the forward declaration of
lis3lv02d_add_fs() becomes unnecessary.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   64 +++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-reorder-functions-to-make-forward-decl-obsolete drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-reorder-functions-to-make-forward-decl-obsolete
+++ a/drivers/hwmon/lis3lv02d.c
@@ -59,8 +59,6 @@ struct acpi_lis3lv02d lis3_dev = {
 
 EXPORT_SYMBOL_GPL(lis3_dev);
 
-static int lis3lv02d_add_fs(struct acpi_device *device);
-
 static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
 {
 	u8 lo, hi;
@@ -377,37 +375,6 @@ void lis3lv02d_joystick_disable(void)
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
 
-/*
- * Initialise the accelerometer and the various subsystems.
- * Should be rather independant of the bus system.
- */
-int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
-{
-	mutex_init(&dev->lock);
-	lis3lv02d_add_fs(dev->device);
-	lis3lv02d_increase_use(dev);
-
-	if (lis3lv02d_joystick_enable())
-		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
-
-	printk("lis3_init_device: irq %d\n", dev->irq);
-
-	/* if we did not get an IRQ from ACPI - we have nothing more to do */
-	if (!dev->irq) {
-		printk(KERN_ERR DRIVER_NAME
-			": No IRQ in ACPI. Disabling /dev/freefall\n");
-		goto out;
-	}
-
-	printk("lis3: registering device\n");
-	if (misc_register(&lis3lv02d_misc_device))
-		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
-out:
-	lis3lv02d_decrease_use(dev);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
-
 /* Sysfs stuff */
 static ssize_t lis3lv02d_position_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -485,6 +452,37 @@ int lis3lv02d_remove_fs(void)
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 
+/*
+ * Initialise the accelerometer and the various subsystems.
+ * Should be rather independant of the bus system.
+ */
+int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
+{
+	mutex_init(&dev->lock);
+	lis3lv02d_add_fs(dev->device);
+	lis3lv02d_increase_use(dev);
+
+	if (lis3lv02d_joystick_enable())
+		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
+
+	printk("lis3_init_device: irq %d\n", dev->irq);
+
+	/* if we did not get an IRQ from ACPI - we have nothing more to do */
+	if (!dev->irq) {
+		printk(KERN_ERR DRIVER_NAME
+			": No IRQ in ACPI. Disabling /dev/freefall\n");
+		goto out;
+	}
+
+	printk("lis3: registering device\n");
+	if (misc_register(&lis3lv02d_misc_device))
+		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
+out:
+	lis3lv02d_decrease_use(dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
+
 MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer driver");
 MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
linux-next.patch
drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor.patch
drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor-fix.patch
hp_accel-add-two-more-axis-information.patch
lis3-reorder-functions-to-make-forward-decl-obsolete.patch
lis3-solve-dependency-between-core-and-acpi.patch
lis3-spi-transport-layer.patch
w1-coding-style-cleanups-in-w1_ioc.patch

