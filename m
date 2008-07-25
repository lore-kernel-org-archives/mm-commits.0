From: akpm@linux-foundation.org
Subject: - gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:13:53 -0700
Message-ID: <200807250013.m6P0DrbR013521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbYGYAOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:14:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mb@bu3sch.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     gpio: linux-next fixes for sysfs support
has been removed from the -mm tree.  Its filename was
     gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch

This patch was dropped because it was folded into gpio-sysfs-interface-updated.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: linux-next fixes for sysfs support
From: David Brownell <david-b@pacbell.net>

Cope with some backwards-incompatible driver model API changes
now in the linux-next tree:

 - device_create() is going away, even for drivers using it safely,
   in favor of device_create_drvdata().
 - class->devices is gone, but testing class->p serves the same
   purpose (non-null when class is usable with driver model calls).
 - class_find_device() needs a new argument #2 (NULL)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support
+++ a/drivers/gpio/gpiolib.c
@@ -429,7 +429,7 @@ int gpio_export(unsigned gpio, bool dire
 	int			status = -EINVAL;
 
 	/* can't export until sysfs is available ... */
-	if (!gpio_class.devices.next) {
+	if (!gpio_class.p) {
 		pr_debug("%s: called too early!\n", __func__);
 		return -ENOENT;
 	}
@@ -453,10 +453,9 @@ int gpio_export(unsigned gpio, bool dire
 	if (status == 0) {
 		struct device	*dev;
 
-		dev = device_create(&gpio_class, desc->chip->dev, 0,
-				"gpio%d", gpio);
+		dev = device_create_drvdata(&gpio_class, desc->chip->dev, 0,
+				desc, "gpio%d", gpio);
 		if (dev) {
-			dev_set_drvdata(dev, desc);
 			if (direction_may_change)
 				status = sysfs_create_group(&dev->kobj,
 						&gpio_attr_group);
@@ -506,7 +505,7 @@ void gpio_unexport(unsigned gpio)
 	if (test_bit(FLAG_EXPORT, &desc->flags)) {
 		struct device	*dev = NULL;
 
-		dev = class_find_device(&gpio_class, desc, match_export);
+		dev = class_find_device(&gpio_class, NULL, desc, match_export);
 		if (dev) {
 			clear_bit(FLAG_EXPORT, &desc->flags);
 			put_device(dev);
@@ -533,15 +532,14 @@ static int gpiochip_export(struct gpio_c
 	 * export this later, in gpiolib_sysfs_init() ... here we just
 	 * verify that _some_ field of gpio_class got initialized.
 	 */
-	if (!gpio_class.devices.next)
+	if (!gpio_class.p)
 		return 0;
 
 	/* use chip->base for the ID; it's already known to be unique */
 	mutex_lock(&sysfs_lock);
-	dev = device_create(&gpio_class, chip->dev, 0,
+	dev = device_create_drvdata(&gpio_class, chip->dev, 0, chip,
 			"gpiochip%d", chip->base);
 	if (dev) {
-		dev_set_drvdata(dev, chip);
 		status = sysfs_create_group(&dev->kobj,
 				&gpiochip_attr_group);
 	} else
@@ -572,7 +570,7 @@ static void gpiochip_unexport(struct gpi
 	struct device		*dev;
 
 	mutex_lock(&sysfs_lock);
-	dev = class_find_device(&gpio_class, chip, match_export);
+	dev = class_find_device(&gpio_class, NULL, chip, match_export);
 	if (dev) {
 		put_device(dev);
 		device_unregister(dev);
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
gpio-sysfs-interface-updated.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch

