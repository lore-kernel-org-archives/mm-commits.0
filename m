From: akpm@linux-foundation.org
Subject: + gpio-pca953x-handles-more-chips-i2c-fault-codes.patch added to -mm tree
Date: Sat, 06 Dec 2008 23:07:55 -0800
Message-ID: <200812070707.mB777tO6014235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbYLGHIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 02:08:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, eric.miao@marvell.com


The patch titled
     gpio: pca953x handles more chips, i2c fault codes
has been added to the -mm tree.  Its filename is
     gpio-pca953x-handles-more-chips-i2c-fault-codes.patch

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
Subject: gpio: pca953x handles more chips, i2c fault codes
From: David Brownell <dbrownell@users.sourceforge.net>

Minor updates to the pca953x GPIO expander driver: handle several more
compatible parts, and stop assuming that the I2C layer's return codes are
garbage (that's now been fixed).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.miao@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig   |    7 ++++---
 drivers/gpio/pca953x.c |   12 +++++++-----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-pca953x-handles-more-chips-i2c-fault-codes drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-pca953x-handles-more-chips-i2c-fault-codes
+++ a/drivers/gpio/Kconfig
@@ -95,7 +95,7 @@ config GPIO_MAX732X
 	  number for these GPIOs.
 
 config GPIO_PCA953X
-	tristate "PCA953x, PCA955x, and MAX7310 I/O ports"
+	tristate "PCA953x, PCA955x, TCA64xx, and MAX7310 I/O ports"
 	depends on I2C
 	help
 	  Say yes here to provide access to several register-oriented
@@ -104,9 +104,10 @@ config GPIO_PCA953X
 
 	  4 bits:	pca9536, pca9537
 
-	  8 bits:	max7310, pca9534, pca9538, pca9554, pca9557
+	  8 bits:	max7310, pca9534, pca9538, pca9554, pca9557,
+	  		tca6408
 
-	  16 bits:	pca9535, pca9539, pca9555
+	  16 bits:	pca9535, pca9539, pca9555, tca6416
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called pca953x.
diff -puN drivers/gpio/pca953x.c~gpio-pca953x-handles-more-chips-i2c-fault-codes drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-handles-more-chips-i2c-fault-codes
+++ a/drivers/gpio/pca953x.c
@@ -33,7 +33,12 @@ static const struct i2c_device_id pca953
 	{ "pca9554", 8, },
 	{ "pca9555", 16, },
 	{ "pca9557", 8, },
+
 	{ "max7310", 8, },
+	{ "pca6107", 8, },
+	{ "tca6408", 8, },
+	{ "tca6416", 16, },
+	/* NYET:  { "tca6424", 24, }, */
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pca953x_id);
@@ -47,9 +52,6 @@ struct pca953x_chip {
 	struct gpio_chip gpio_chip;
 };
 
-/* NOTE:  we can't currently rely on fault codes to come from SMBus
- * calls, so we map all errors to EIO here and return zero otherwise.
- */
 static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
 {
 	int ret;
@@ -61,7 +63,7 @@ static int pca953x_write_reg(struct pca9
 
 	if (ret < 0) {
 		dev_err(&chip->client->dev, "failed writing register\n");
-		return -EIO;
+		return ret;
 	}
 
 	return 0;
@@ -78,7 +80,7 @@ static int pca953x_read_reg(struct pca95
 
 	if (ret < 0) {
 		dev_err(&chip->client->dev, "failed reading register\n");
-		return -EIO;
+		return ret;
 	}
 
 	*val = (uint16_t)ret;
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
genirq-record-irq_level-in-irq_desc.patch
documentation-when-to-bug-and-when-to-not-bug.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
atmel_spi-clean-up-spiv1-quirk-handling.patch
spi-atmel_spi-update-chipselect-handling.patch
spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio.patch
mfd-da903x-section-fix.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
twl4030-gpio-cleanup-debounce.patch
gpio-pca953x-handles-more-chips-i2c-fault-codes.patch

