From: akpm@linux-foundation.org
Subject: + gpio-pcf857x-add-lock-and-handle-more-chips.patch added to -mm tree
Date: Sun, 13 Jul 2008 14:39:04 -0700
Message-ID: <200807132139.m6DLd4C0007903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbYGMVjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 17:39:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net


The patch titled
     gpio: pcf857x: add lock and handle more chips
has been added to the -mm tree.  Its filename is
     gpio-pcf857x-add-lock-and-handle-more-chips.patch

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
Subject: gpio: pcf857x: add lock and handle more chips
From: David Brownell <dbrownell@users.sourceforge.net>

Two small updates to the pcf857x driver: (a) the max732[89] chips are also
second sources for the pcf8574/a, and (b) add a mutex to prevent trashing
the cached state.  Adding the lock is effectively a bugfix, although it
seems unlikely that anyone would have run into the issue it protects
against.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig   |    5 +++--
 drivers/gpio/pcf857x.c |   33 +++++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 6 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-pcf857x-add-lock-and-handle-more-chips drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-pcf857x-add-lock-and-handle-more-chips
+++ a/drivers/gpio/Kconfig
@@ -45,7 +45,7 @@ config GPIO_PCA953X
 	  will be called pca953x.
 
 config GPIO_PCF857X
-	tristate "PCF857x, PCA857x, and PCA967x I2C GPIO expanders"
+	tristate "PCF857x, PCA{85,96}7x, and MAX732[89] I2C GPIO expanders"
 	depends on I2C
 	help
 	  Say yes here to provide access to most "quasi-bidirectional" I2C
@@ -54,7 +54,8 @@ config GPIO_PCF857X
 	  some of them.  Compatible models include:
 
 	  8 bits:   pcf8574, pcf8574a, pca8574, pca8574a,
-	            pca9670, pca9672, pca9674, pca9674a
+	            pca9670, pca9672, pca9674, pca9674a,
+	  	    max7328, max7329
 
 	  16 bits:  pcf8575, pcf8575c, pca8575,
 	            pca9671, pca9673, pca9675
diff -puN drivers/gpio/pcf857x.c~gpio-pcf857x-add-lock-and-handle-more-chips drivers/gpio/pcf857x.c
--- a/drivers/gpio/pcf857x.c~gpio-pcf857x-add-lock-and-handle-more-chips
+++ a/drivers/gpio/pcf857x.c
@@ -37,6 +37,8 @@ static const struct i2c_device_id pcf857
 	{ "pca9671", 16 },
 	{ "pca9673", 16 },
 	{ "pca9675", 16 },
+	{ "max7328", 8 },
+	{ "max7329", 8 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pcf857x_id);
@@ -56,6 +58,7 @@ MODULE_DEVICE_TABLE(i2c, pcf857x_id);
 struct pcf857x {
 	struct gpio_chip	chip;
 	struct i2c_client	*client;
+	struct mutex		lock;		/* protect 'out' */
 	unsigned		out;		/* software latch */
 };
 
@@ -66,9 +69,14 @@ struct pcf857x {
 static int pcf857x_input8(struct gpio_chip *chip, unsigned offset)
 {
 	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	int		status;
 
+	mutex_lock(&gpio->lock);
 	gpio->out |= (1 << offset);
-	return i2c_smbus_write_byte(gpio->client, gpio->out);
+	status = i2c_smbus_write_byte(gpio->client, gpio->out);
+	mutex_unlock(&gpio->lock);
+
+	return status;
 }
 
 static int pcf857x_get8(struct gpio_chip *chip, unsigned offset)
@@ -84,12 +92,17 @@ static int pcf857x_output8(struct gpio_c
 {
 	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
 	unsigned	bit = 1 << offset;
+	int		status;
 
+	mutex_lock(&gpio->lock);
 	if (value)
 		gpio->out |= bit;
 	else
 		gpio->out &= ~bit;
-	return i2c_smbus_write_byte(gpio->client, gpio->out);
+	status = i2c_smbus_write_byte(gpio->client, gpio->out);
+	mutex_unlock(&gpio->lock);
+
+	return status;
 }
 
 static void pcf857x_set8(struct gpio_chip *chip, unsigned offset, int value)
@@ -124,9 +137,14 @@ static int i2c_read_le16(struct i2c_clie
 static int pcf857x_input16(struct gpio_chip *chip, unsigned offset)
 {
 	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	int		status;
 
+	mutex_lock(&gpio->lock);
 	gpio->out |= (1 << offset);
-	return i2c_write_le16(gpio->client, gpio->out);
+	status = i2c_write_le16(gpio->client, gpio->out);
+	mutex_unlock(&gpio->lock);
+
+	return status;
 }
 
 static int pcf857x_get16(struct gpio_chip *chip, unsigned offset)
@@ -142,12 +160,17 @@ static int pcf857x_output16(struct gpio_
 {
 	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
 	unsigned	bit = 1 << offset;
+	int		status;
 
+	mutex_lock(&gpio->lock);
 	if (value)
 		gpio->out |= bit;
 	else
 		gpio->out &= ~bit;
-	return i2c_write_le16(gpio->client, gpio->out);
+	status = i2c_write_le16(gpio->client, gpio->out);
+	mutex_unlock(&gpio->lock);
+
+	return status;
 }
 
 static void pcf857x_set16(struct gpio_chip *chip, unsigned offset, int value)
@@ -173,6 +196,8 @@ static int pcf857x_probe(struct i2c_clie
 	if (!gpio)
 		return -ENOMEM;
 
+	mutex_init(&gpio->lock);
+
 	gpio->chip.base = pdata->gpio_base;
 	gpio->chip.can_sleep = 1;
 	gpio->chip.owner = THIS_MODULE;
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

gpio-pcf857x-add-lock-and-handle-more-chips.patch
linux-next.patch
add-have_clk-to-kconfig-for-driver-dependencies.patch
drivers-input-touchscreen-ads7846c-optimize-order-of-calculating-rt-in-ads7846_rx.patch
atmel_nand-speedup-via-readwritesbw.patch
mtd-atmel_nand-can-be-modular.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
pm-boot-time-suspend-selftest-update.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
spi-spi_mpc83xx-clockrate-fixes.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
spi-kconfig-simplifications.patch
spi-make-spi_board_infomodalias-a-char-array.patch
spidev-bkl-removal.patch
spi-au1550_spi-proper-platform-device.patch
spi-au1550_spi-improve-pio-transfer-mode.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
rtc-remove-bkl-for-ioctl.patch
rtc-ds1305-ds1306-driver.patch
rtc-ds1305-ds1306-driver-fix.patch
rtc-bcd-codeshrink.patch
rtc-rtc-omap-footprint-shrinkage.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-check-spi_setup-return-code-cleanup.patch
gpio-sysfs-interface-updated.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch

