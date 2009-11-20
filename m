From: akpm@linux-foundation.org
Subject: + gpio-add-driver-for-max7300-i2c-gpio-extender.patch added to -mm tree
Date: Fri, 20 Nov 2009 15:34:39 -0800
Message-ID: <200911202334.nAKNYd89016121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054AbZKTXfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 18:35:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, j.beisert@pengutronix.de, khali@linux-fr.org


The patch titled
     gpio: add driver for MAX7300 I2C GPIO extender
has been added to the -mm tree.  Its filename is
     gpio-add-driver-for-max7300-i2c-gpio-extender.patch

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
Subject: gpio: add driver for MAX7300 I2C GPIO extender
From: Wolfram Sang <w.sang@pengutronix.de>

Add the MAX7300-I2C variant to the MAX7301-SPI version.  They share most
parts of the driver (i.e.  the logic) and the read/write-register
functions get encapsulated.  It is thus possible to use both variants
simultaneously.  (This is the outcome of an experiment how to combine I2C
and SPI into one driver.)

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Juergen Beisert <j.beisert@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig   |   27 ++-
 drivers/gpio/max7301.c |  307 +++++++++++++++++++++++++--------------
 2 files changed, 225 insertions(+), 109 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-add-driver-for-max7300-i2c-gpio-extender drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-add-driver-for-max7300-i2c-gpio-extender
+++ a/drivers/gpio/Kconfig
@@ -65,6 +65,27 @@ config GPIO_SYSFS
 
 # put expanders in the right section, in alphabetical order
 
+comment "GPIO expanders for multiple busses"
+
+config GPIO_MAX7301
+	tristate "Maxim MAX730x GPIO expander"
+	depends on I2C || SPI_MASTER
+	help
+	  GPIO driver for Maxim MAX7300/7301 GPIO expanders.
+	  Also select which bus you want to use.
+
+if GPIO_MAX7301
+config GPIO_MAX7301_I2C
+	bool "I2C support (for MAX7300)"
+	depends on I2C
+	default y
+
+config GPIO_MAX7301_SPI
+	bool "SPI support (for MAX7301)"
+	depends on SPI_MASTER
+	default y
+endif
+
 comment "Memory mapped GPIO expanders:"
 
 config GPIO_PL061
@@ -214,12 +235,6 @@ config GPIO_TIMBERDALE
 
 comment "SPI GPIO expanders:"
 
-config GPIO_MAX7301
-	tristate "Maxim MAX7301 GPIO expander"
-	depends on SPI_MASTER
-	help
-	  gpio driver for Maxim MAX7301 SPI GPIO expander.
-
 config GPIO_MCP23S08
 	tristate "Microchip MCP23S08 I/O expander"
 	depends on SPI_MASTER
diff -puN drivers/gpio/max7301.c~gpio-add-driver-for-max7300-i2c-gpio-extender drivers/gpio/max7301.c
--- a/drivers/gpio/max7301.c~gpio-add-driver-for-max7300-i2c-gpio-extender
+++ a/drivers/gpio/max7301.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2006 Juergen Beisert, Pengutronix
  * Copyright (C) 2008 Guennadi Liakhovetski, Pengutronix
+ * Copyright (C) 2009 Wolfram Sang, Pengutronix
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -34,12 +35,11 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
+#include <linux/i2c.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/max7301.h>
 #include <linux/gpio.h>
 
-#define DRIVER_NAME "max7301"
-
 /*
  * Pin configurations, see MAX7301 datasheet page 6
  */
@@ -50,7 +50,6 @@
 
 #define PIN_NUMBER 28
 
-
 /*
  * Some registers must be read back to modify.
  * To save time we cache them here in memory
@@ -60,62 +59,21 @@ struct max7301 {
 	u8		port_config[8];	/* field 0 is unused */
 	u32		out_level;	/* cached output levels */
 	struct gpio_chip chip;
-	struct spi_device *spi;
+	struct device *dev;
+	int (*write)(struct device *dev, unsigned int reg, unsigned int val);
+	int (*read)(struct device *dev, unsigned int reg);
 };
 
-/**
- * max7301_write - Write a new register content
- * @spi: The SPI device
- * @reg: Register offset
- * @val: Value to write
- *
- * A write to the MAX7301 means one message with one transfer
- *
- * Returns 0 if successful or a negative value on error
- */
-static int max7301_write(struct spi_device *spi, unsigned int reg, unsigned int val)
-{
-	u16 word = ((reg & 0x7F) << 8) | (val & 0xFF);
-	return spi_write(spi, (const u8 *)&word, sizeof(word));
-}
-
-/**
- * max7301_read - Read back register content
- * @spi: The SPI device
- * @reg: Register offset
- *
- * A read from the MAX7301 means two transfers; here, one message each
- *
- * Returns positive 8 bit value from device if successful or a
- * negative value on error
- */
-static int max7301_read(struct spi_device *spi, unsigned int reg)
-{
-	int ret;
-	u16 word;
-
-	word = 0x8000 | (reg << 8);
-	ret = spi_write(spi, (const u8 *)&word, sizeof(word));
-	if (ret)
-		return ret;
-	/*
-	 * This relies on the fact, that a transfer with NULL tx_buf shifts out
-	 * zero bytes (=NOOP for MAX7301)
-	 */
-	ret = spi_read(spi, (u8 *)&word, sizeof(word));
-	if (ret)
-		return ret;
-	return word & 0xff;
-}
-
 static int max7301_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	struct max7301 *ts = container_of(chip, struct max7301, chip);
 	u8 *config;
+	u8 offset_bits;
 	int ret;
 
 	/* First 4 pins are unused in the controller */
 	offset += 4;
+	offset_bits = (offset & 3) << 1;
 
 	config = &ts->port_config[offset >> 2];
 
@@ -123,9 +81,10 @@ static int max7301_direction_input(struc
 
 	/* Standard GPIO API doesn't support pull-ups, has to be extended.
 	 * Hard-coding no pollup for now. */
-	*config = (*config & ~(3 << (offset & 3))) | (1 << (offset & 3));
+	*config = (*config & ~(PIN_CONFIG_MASK << offset_bits))
+			   | (PIN_CONFIG_IN_WO_PULLUP << offset_bits);
 
-	ret = max7301_write(ts->spi, 0x08 + (offset >> 2), *config);
+	ret = ts->write(ts->dev, 0x08 + (offset >> 2), *config);
 
 	mutex_unlock(&ts->lock);
 
@@ -136,10 +95,10 @@ static int __max7301_set(struct max7301 
 {
 	if (value) {
 		ts->out_level |= 1 << offset;
-		return max7301_write(ts->spi, 0x20 + offset, 0x01);
+		return ts->write(ts->dev, 0x20 + offset, 0x01);
 	} else {
 		ts->out_level &= ~(1 << offset);
-		return max7301_write(ts->spi, 0x20 + offset, 0x00);
+		return ts->write(ts->dev, 0x20 + offset, 0x00);
 	}
 }
 
@@ -148,21 +107,24 @@ static int max7301_direction_output(stru
 {
 	struct max7301 *ts = container_of(chip, struct max7301, chip);
 	u8 *config;
+	u8 offset_bits;
 	int ret;
 
 	/* First 4 pins are unused in the controller */
 	offset += 4;
+	offset_bits = (offset & 3) << 1;
 
 	config = &ts->port_config[offset >> 2];
 
 	mutex_lock(&ts->lock);
 
-	*config = (*config & ~(3 << (offset & 3))) | (1 << (offset & 3));
+	*config = (*config & ~(PIN_CONFIG_MASK << offset_bits))
+			   | (PIN_CONFIG_OUT << offset_bits);
 
 	ret = __max7301_set(ts, offset, value);
 
 	if (!ret)
-		ret = max7301_write(ts->spi, 0x08 + (offset >> 2), *config);
+		ret = ts->write(ts->dev, 0x08 + (offset >> 2), *config);
 
 	mutex_unlock(&ts->lock);
 
@@ -179,17 +141,18 @@ static int max7301_get(struct gpio_chip 
 
 	mutex_lock(&ts->lock);
 
-	config = (ts->port_config[offset >> 2] >> ((offset & 3) * 2)) & 3;
+	config = (ts->port_config[offset >> 2] >> ((offset & 3) << 1))
+			& PIN_CONFIG_MASK;
 
 	switch (config) {
-	case 1:
+	case PIN_CONFIG_OUT:
 		/* Output: return cached level */
 		level =  !!(ts->out_level & (1 << offset));
 		break;
-	case 2:
-	case 3:
+	case PIN_CONFIG_IN_WO_PULLUP:
+	case PIN_CONFIG_IN_PULLUP:
 		/* Input: read out */
-		level = max7301_read(ts->spi, 0x20 + offset) & 0x01;
+		level = ts->read(ts->dev, 0x20 + offset) & 0x01;
 	}
 	mutex_unlock(&ts->lock);
 
@@ -210,41 +173,25 @@ static void max7301_set(struct gpio_chip
 	mutex_unlock(&ts->lock);
 }
 
-static int __devinit max7301_probe(struct spi_device *spi)
+static int __devinit __max7301_probe(struct max7301 *ts)
 {
-	struct max7301 *ts;
+	struct device *dev = ts->dev;
 	struct max7301_platform_data *pdata;
 	int i, ret;
 
-	pdata = spi->dev.platform_data;
+	pdata = dev->platform_data;
 	if (!pdata || !pdata->base) {
-		dev_dbg(&spi->dev, "incorrect or missing platform data\n");
+		dev_err(dev, "incorrect or missing platform data\n");
 		return -EINVAL;
 	}
 
-	/*
-	 * bits_per_word cannot be configured in platform data
-	 */
-	spi->bits_per_word = 16;
-
-	ret = spi_setup(spi);
-	if (ret < 0)
-		return ret;
-
-	ts = kzalloc(sizeof(struct max7301), GFP_KERNEL);
-	if (!ts)
-		return -ENOMEM;
-
 	mutex_init(&ts->lock);
-
-	dev_set_drvdata(&spi->dev, ts);
+	dev_set_drvdata(dev, ts);
 
 	/* Power up the chip and disable IRQ output */
-	max7301_write(spi, 0x04, 0x01);
-
-	ts->spi = spi;
+	ts->write(dev, 0x04, 0x01);
 
-	ts->chip.label = DRIVER_NAME,
+	ts->chip.label = dev->driver->name;
 
 	ts->chip.direction_input = max7301_direction_input;
 	ts->chip.get = max7301_get;
@@ -254,7 +201,7 @@ static int __devinit max7301_probe(struc
 	ts->chip.base = pdata->base;
 	ts->chip.ngpio = PIN_NUMBER;
 	ts->chip.can_sleep = 1;
-	ts->chip.dev = &spi->dev;
+	ts->chip.dev = dev;
 	ts->chip.owner = THIS_MODULE;
 
 	/*
@@ -264,7 +211,7 @@ static int __devinit max7301_probe(struc
 	for (i = 1; i < 8; i++) {
 		int j;
 		/* 0xAA means input with internal pullup disabled */
-		max7301_write(spi, 0x08 + i, 0xAA);
+		ts->write(dev, 0x08 + i, 0xAA);
 		ts->port_config[i] = 0xAA;
 		for (j = 0; j < 4; j++) {
 			int offset = (i - 1) * 4 + j;
@@ -281,49 +228,203 @@ static int __devinit max7301_probe(struc
 	return ret;
 
 exit_destroy:
-	dev_set_drvdata(&spi->dev, NULL);
+	dev_set_drvdata(dev, NULL);
 	mutex_destroy(&ts->lock);
-	kfree(ts);
 	return ret;
 }
 
-static int __devexit max7301_remove(struct spi_device *spi)
+static int __devexit __max7301_remove(struct device *dev)
 {
-	struct max7301 *ts;
+	struct max7301 *ts = dev_get_drvdata(dev);
 	int ret;
 
-	ts = dev_get_drvdata(&spi->dev);
 	if (ts == NULL)
 		return -ENODEV;
 
-	dev_set_drvdata(&spi->dev, NULL);
+	dev_set_drvdata(dev, NULL);
 
 	/* Power down the chip and disable IRQ output */
-	max7301_write(spi, 0x04, 0x00);
+	ts->write(dev, 0x04, 0x00);
 
 	ret = gpiochip_remove(&ts->chip);
 	if (!ret) {
 		mutex_destroy(&ts->lock);
 		kfree(ts);
 	} else
-		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n",
-			ret);
+		dev_err(dev, "Failed to remove GPIO controller: %d\n", ret);
+
+	return ret;
+}
+
+#ifdef CONFIG_GPIO_MAX7301_SPI
+
+/* A write to the MAX7301 means one message with one transfer */
+static int max7301_spi_write(struct device *dev, unsigned int reg,
+				unsigned int val)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	u16 word = ((reg & 0x7F) << 8) | (val & 0xFF);
+
+	return spi_write(spi, (const u8 *)&word, sizeof(word));
+}
+
+/* A read from the MAX7301 means two transfers; here, one message each */
+
+static int max7301_spi_read(struct device *dev, unsigned int reg)
+{
+	int ret;
+	u16 word;
+	struct spi_device *spi = to_spi_device(dev);
+
+	word = 0x8000 | (reg << 8);
+	ret = spi_write(spi, (const u8 *)&word, sizeof(word));
+	if (ret)
+		return ret;
+	/*
+	 * This relies on the fact, that a transfer with NULL tx_buf shifts out
+	 * zero bytes (=NOOP for MAX7301)
+	 */
+	ret = spi_read(spi, (u8 *)&word, sizeof(word));
+	if (ret)
+		return ret;
+	return word & 0xff;
+}
+
+static int __devinit max7301_probe(struct spi_device *spi)
+{
+	struct max7301 *ts;
+	int ret;
+
+	/* bits_per_word cannot be configured in platform data */
+	spi->bits_per_word = 16;
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
+	ts = kzalloc(sizeof(struct max7301), GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+	ts->read = max7301_spi_read;
+	ts->write = max7301_spi_write;
+	ts->dev = &spi->dev;
 
+	ret = __max7301_probe(ts);
+	if (ret)
+		kfree(ts);
 	return ret;
 }
 
+static int __devexit max7301_remove(struct spi_device *spi)
+{
+	return __max7301_remove(&spi->dev);
+}
+
+static const struct spi_device_id max7301_id[] = {
+	{ "max7301", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, max7301_id);
+
 static struct spi_driver max7301_driver = {
 	.driver = {
-		.name		= DRIVER_NAME,
-		.owner		= THIS_MODULE,
+		.name = "max7301",
+		.owner = THIS_MODULE,
+	},
+	.probe = max7301_probe,
+	.remove = __devexit_p(max7301_remove),
+	.id_table = max7301_id,
+};
+
+#define max7301_add_driver(drv) spi_register_driver(drv)
+#define max7301_del_driver(drv) spi_unregister_driver(drv)
+#else
+#define max7301_add_driver(drv) (0)
+#define max7301_del_driver(drv) do { } while (0)
+#endif /* CONFIG_GPIO_MAX7301_SPI */
+
+#ifdef CONFIG_GPIO_MAX7301_I2C
+
+static int max7301_i2c_write(struct device *dev, unsigned int reg,
+				unsigned int val)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	return i2c_smbus_write_byte_data(client, reg, val);
+}
+
+static int max7301_i2c_read(struct device *dev, unsigned int reg)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static int __devinit max7300_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct max7301 *ts;
+	int ret;
+
+	if (!i2c_check_functionality(client->adapter,
+			I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	ts = kzalloc(sizeof(struct max7301), GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+	ts->read = max7301_i2c_read;
+	ts->write = max7301_i2c_write;
+	ts->dev = &client->dev;
+
+	ret = __max7301_probe(ts);
+	if (ret)
+		kfree(ts);
+	return ret;
+}
+
+static int __devexit max7300_remove(struct i2c_client *client)
+{
+	return __max7301_remove(&client->dev);
+}
+
+static const struct i2c_device_id max7300_id[] = {
+	{ "max7300", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max7300_id);
+
+static struct i2c_driver max7300_driver = {
+	.driver = {
+		.name = "max7300",
+		.owner = THIS_MODULE,
 	},
-	.probe		= max7301_probe,
-	.remove		= __devexit_p(max7301_remove),
+	.probe = max7300_probe,
+	.remove = __devexit_p(max7300_remove),
+	.id_table = max7300_id,
 };
 
+#define max7300_add_driver(drv) i2c_add_driver(drv)
+#define max7300_del_driver(drv) i2c_del_driver(drv)
+#else
+#define max7300_add_driver(drv) (0)
+#define max7300_del_driver(drv) do { } while (0)
+#endif /* CONFIG_GPIO_MAX7301_I2C */
+
 static int __init max7301_init(void)
 {
-	return spi_register_driver(&max7301_driver);
+	int ret;
+
+	ret = max7300_add_driver(&max7300_driver);
+	if (ret)
+		return ret;
+
+	ret = max7301_add_driver(&max7301_driver);
+	if (ret)
+		max7300_del_driver(&max7300_driver);
+
+	return ret;
 }
 /* register after spi postcore initcall and before
  * subsys initcalls that may rely on these GPIOs
@@ -332,11 +433,11 @@ subsys_initcall(max7301_init);
 
 static void __exit max7301_exit(void)
 {
-	spi_unregister_driver(&max7301_driver);
+	max7300_del_driver(&max7300_driver);
+	max7301_del_driver(&max7301_driver);
 }
 module_exit(max7301_exit);
 
-MODULE_AUTHOR("Juergen Beisert");
+MODULE_AUTHOR("Juergen Beisert, Wolfram Sang");
 MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("MAX7301 SPI based GPIO-Expander");
-MODULE_ALIAS("spi:" DRIVER_NAME);
+MODULE_DESCRIPTION("MAX7300/1 based GPIO-Expander");
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
checkpatch-fix-false-positive-on-__initconst.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch

