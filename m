From: akpm@linux-foundation.org
Subject: + gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch added to -mm tree
Date: Sat, 12 Jul 2008 00:00:04 -0700
Message-ID: <200807120700.m6C704eN025411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbYGLHAb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Jul 2008 03:00:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, mb@bu3sch.de, sfr@canb.auug.org.au


The patch titled
     gpio: linux-next fixes for sysfs support
has been added to the -mm tree.  Its filename is
     gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch

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
rtc-fm3130-fix-chip-naming.patch
rtc-pcf8563-add-chip-id.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
atmel_nand-speedup-via-readwritesbw.patch
atmel_pwm-set-up-only-one-pwm-clock-when-allocating-a-clock.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
rtc-remove-bkl-for-ioctl.patch
rtc-add-support-for-st-m41t94-spi-rtc.patch
rtc-ds1305-ds1306-driver.patch
rtc-ds1305-ds1306-driver-fix.patch
rtc-bcd-codeshrink.patch
rtc-rtc-omap-footprint-shrinkage.patch
rtc-convert-the-pcf8583-driver-to-the-new-i2c-style-framework-with-device_ids.patch
rtc-marvell-soc-rtc-driver.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch

