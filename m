From: akpm@linux-foundation.org
Subject: - gpio-pca953x-i2c-handles-max7310-too.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:03:07 -0700
Message-ID: <200807070303.m67337bM004628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110AbYGGDDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:03:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpio: pca953x (i2c) handles max7310 too
has been removed from the -mm tree.  Its filename was
     gpio-pca953x-i2c-handles-max7310-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: pca953x (i2c) handles max7310 too
From: David Brownell <david-b@pacbell.net>

The pca953x driver can handle another 8-bit I/O expander, the max7310. 
This patch adds that chip to the list of supported IDs in that driver, and
expands the Kconfig helptext accordingly.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig   |   14 ++++++++++----
 drivers/gpio/pca953x.c |    2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-pca953x-i2c-handles-max7310-too drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-pca953x-i2c-handles-max7310-too
+++ a/drivers/gpio/Kconfig
@@ -28,12 +28,18 @@ config DEBUG_GPIO
 comment "I2C GPIO expanders:"
 
 config GPIO_PCA953X
-	tristate "PCA953x I/O ports"
+	tristate "PCA953x, PCA955x, and MAX7310 I/O ports"
 	depends on I2C
 	help
-	  Say yes here to support the PCA9534 (8-bit), PCA9535 (16-bit),
-	  PCA9536 (4-bit), PCA9537 (4-bit), PCA9538 (8-bit), and PCA9539
-	  (16-bit) I/O ports. These parts are made by NXP and TI.
+	  Say yes here to provide access to several register-oriented
+	  SMBus I/O expanders, made mostly by NXP or TI.  Compatible
+	  models include:
+
+	  4 bits:	pca9536, pca9537
+
+	  8 bits:	max7310, pca9534, pca9538, pca9554, pca9557
+
+	  16 bits:	pca9535, pca9539, pca9555
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called pca953x.
diff -puN drivers/gpio/pca953x.c~gpio-pca953x-i2c-handles-max7310-too drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-i2c-handles-max7310-too
+++ a/drivers/gpio/pca953x.c
@@ -33,7 +33,7 @@ static const struct i2c_device_id pca953
 	{ "pca9554", 8, },
 	{ "pca9555", 16, },
 	{ "pca9557", 8, },
-	/* REVISIT several pca955x parts should work here too */
+	{ "max7310", 8, },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pca953x_id);
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
atmel_nand-speedup-via-readwritesbw.patch
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
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-sysfs-interface-updated-update.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch

