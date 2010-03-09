From: akpm@linux-foundation.org
Subject: [merged] gpio-add-driver-for-max7300-i2c-gpio-extender.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:06 -0800
Message-ID: <201003091911.o29JB6Ic031643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902Ab0CITM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:12:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, j.beisert@pengutronix.de, khali@linux-fr.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     gpio: add driver for MAX7300 I2C GPIO extender
has been removed from the -mm tree.  Its filename was
     gpio-add-driver-for-max7300-i2c-gpio-extender.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: add driver for MAX7300 I2C GPIO extender
From: Wolfram Sang <w.sang@pengutronix.de>

Add the MAX7300-I2C variant of the MAX7301-SPI version.  Both chips share
the same core logic, so the generic part of the in-kernel SPI-driver is
refactored into a generic part.  The I2C and SPI specific funtions are
then wrapped into seperate drivers picking up the generic part.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Juergen Beisert <j.beisert@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig        |   13 +
 drivers/gpio/Makefile       |    2 
 drivers/gpio/max7300.c      |   94 ++++++++++
 drivers/gpio/max7301.c      |  293 +++-------------------------------
 drivers/gpio/max730x.c      |  244 ++++++++++++++++++++++++++++
 include/linux/spi/max7301.h |   18 ++
 6 files changed, 404 insertions(+), 260 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-add-driver-for-max7300-i2c-gpio-extender drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-add-driver-for-max7300-i2c-gpio-extender
+++ a/drivers/gpio/Kconfig
@@ -65,6 +65,9 @@ config GPIO_SYSFS
 
 # put expanders in the right section, in alphabetical order
 
+config GPIO_MAX730X
+	tristate
+
 comment "Memory mapped GPIO expanders:"
 
 config GPIO_PL061
@@ -87,6 +90,13 @@ config GPIO_VR41XX
 
 comment "I2C GPIO expanders:"
 
+config GPIO_MAX7300
+	tristate "Maxim MAX7300 GPIO expander"
+	depends on I2C
+	select GPIO_MAX730X
+	help
+	  GPIO driver for Maxim MAX7301 I2C-based GPIO expander.
+
 config GPIO_MAX732X
 	tristate "MAX7319, MAX7320-7327 I2C Port Expanders"
 	depends on I2C
@@ -226,8 +236,9 @@ comment "SPI GPIO expanders:"
 config GPIO_MAX7301
 	tristate "Maxim MAX7301 GPIO expander"
 	depends on SPI_MASTER
+	select GPIO_MAX730X
 	help
-	  gpio driver for Maxim MAX7301 SPI GPIO expander.
+	  GPIO driver for Maxim MAX7301 SPI-based GPIO expander.
 
 config GPIO_MCP23S08
 	tristate "Microchip MCP23S08 I/O expander"
diff -puN drivers/gpio/Makefile~gpio-add-driver-for-max7300-i2c-gpio-extender drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-add-driver-for-max7300-i2c-gpio-extender
+++ a/drivers/gpio/Makefile
@@ -7,6 +7,8 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
+obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
+obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
 obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
diff -puN /dev/null drivers/gpio/max7300.c
--- /dev/null
+++ a/drivers/gpio/max7300.c
@@ -0,0 +1,94 @@
+/*
+ * drivers/gpio/max7300.c
+ *
+ * Copyright (C) 2009 Wolfram Sang, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Check max730x.c for further details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/i2c.h>
+#include <linux/spi/max7301.h>
+
+static int max7300_i2c_write(struct device *dev, unsigned int reg,
+				unsigned int val)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	return i2c_smbus_write_byte_data(client, reg, val);
+}
+
+static int max7300_i2c_read(struct device *dev, unsigned int reg)
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
+	ts->read = max7300_i2c_read;
+	ts->write = max7300_i2c_write;
+	ts->dev = &client->dev;
+
+	ret = __max730x_probe(ts);
+	if (ret)
+		kfree(ts);
+	return ret;
+}
+
+static int __devexit max7300_remove(struct i2c_client *client)
+{
+	return __max730x_remove(&client->dev);
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
+	},
+	.probe = max7300_probe,
+	.remove = __devexit_p(max7300_remove),
+	.id_table = max7300_id,
+};
+
+static int __init max7300_init(void)
+{
+	return i2c_add_driver(&max7300_driver);
+}
+subsys_initcall(max7300_init);
+
+static void __exit max7300_exit(void)
+{
+	i2c_del_driver(&max7300_driver);
+}
+module_exit(max7300_exit);
+
+MODULE_AUTHOR("Wolfram Sang");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MAX7300 GPIO-Expander");
diff -puN drivers/gpio/max7301.c~gpio-add-driver-for-max7300-i2c-gpio-extender drivers/gpio/max7301.c
--- a/drivers/gpio/max7301.c~gpio-add-driver-for-max7300-i2c-gpio-extender
+++ a/drivers/gpio/max7301.c
@@ -1,98 +1,41 @@
-/**
+/*
  * drivers/gpio/max7301.c
  *
  * Copyright (C) 2006 Juergen Beisert, Pengutronix
  * Copyright (C) 2008 Guennadi Liakhovetski, Pengutronix
+ * Copyright (C) 2009 Wolfram Sang, Pengutronix
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * The Maxim's MAX7301 device is an SPI driven GPIO expander. There are
- * 28 GPIOs. 8 of them can trigger an interrupt. See datasheet for more
- * details
- * Note:
- * - DIN must be stable at the rising edge of clock.
- * - when writing:
- *   - always clock in 16 clocks at once
- *   - at DIN: D15 first, D0 last
- *   - D0..D7 = databyte, D8..D14 = commandbyte
- *   - D15 = low -> write command
- * - when reading
- *   - always clock in 16 clocks at once
- *   - at DIN: D15 first, D0 last
- *   - D0..D7 = dummy, D8..D14 = register address
- *   - D15 = high -> read command
- *   - raise CS and assert it again
- *   - always clock in 16 clocks at once
- *   - at DOUT: D15 first, D0 last
- *   - D0..D7 contains the data from the first cycle
- *
- * The driver exports a standard gpiochip interface
+ * Check max730x.c for further details.
  */
 
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/max7301.h>
-#include <linux/gpio.h>
-
-#define DRIVER_NAME "max7301"
-
-/*
- * Pin configurations, see MAX7301 datasheet page 6
- */
-#define PIN_CONFIG_MASK 0x03
-#define PIN_CONFIG_IN_PULLUP 0x03
-#define PIN_CONFIG_IN_WO_PULLUP 0x02
-#define PIN_CONFIG_OUT 0x01
-
-#define PIN_NUMBER 28
-
-
-/*
- * Some registers must be read back to modify.
- * To save time we cache them here in memory
- */
-struct max7301 {
-	struct mutex	lock;
-	u8		port_config[8];	/* field 0 is unused */
-	u32		out_level;	/* cached output levels */
-	struct gpio_chip chip;
-	struct spi_device *spi;
-};
 
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
+/* A write to the MAX7301 means one message with one transfer */
+static int max7301_spi_write(struct device *dev, unsigned int reg,
+				unsigned int val)
 {
+	struct spi_device *spi = to_spi_device(dev);
 	u16 word = ((reg & 0x7F) << 8) | (val & 0xFF);
+
 	return spi_write(spi, (const u8 *)&word, sizeof(word));
 }
 
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
+/* A read from the MAX7301 means two transfers; here, one message each */
+
+static int max7301_spi_read(struct device *dev, unsigned int reg)
 {
 	int ret;
 	u16 word;
+	struct spi_device *spi = to_spi_device(dev);
 
 	word = 0x8000 | (reg << 8);
 	ret = spi_write(spi, (const u8 *)&word, sizeof(word));
@@ -108,125 +51,13 @@ static int max7301_read(struct spi_devic
 	return word & 0xff;
 }
 
-static int max7301_direction_input(struct gpio_chip *chip, unsigned offset)
-{
-	struct max7301 *ts = container_of(chip, struct max7301, chip);
-	u8 *config;
-	int ret;
-
-	/* First 4 pins are unused in the controller */
-	offset += 4;
-
-	config = &ts->port_config[offset >> 2];
-
-	mutex_lock(&ts->lock);
-
-	/* Standard GPIO API doesn't support pull-ups, has to be extended.
-	 * Hard-coding no pollup for now. */
-	*config = (*config & ~(3 << (offset & 3))) | (1 << (offset & 3));
-
-	ret = max7301_write(ts->spi, 0x08 + (offset >> 2), *config);
-
-	mutex_unlock(&ts->lock);
-
-	return ret;
-}
-
-static int __max7301_set(struct max7301 *ts, unsigned offset, int value)
-{
-	if (value) {
-		ts->out_level |= 1 << offset;
-		return max7301_write(ts->spi, 0x20 + offset, 0x01);
-	} else {
-		ts->out_level &= ~(1 << offset);
-		return max7301_write(ts->spi, 0x20 + offset, 0x00);
-	}
-}
-
-static int max7301_direction_output(struct gpio_chip *chip, unsigned offset,
-				    int value)
-{
-	struct max7301 *ts = container_of(chip, struct max7301, chip);
-	u8 *config;
-	int ret;
-
-	/* First 4 pins are unused in the controller */
-	offset += 4;
-
-	config = &ts->port_config[offset >> 2];
-
-	mutex_lock(&ts->lock);
-
-	*config = (*config & ~(3 << (offset & 3))) | (1 << (offset & 3));
-
-	ret = __max7301_set(ts, offset, value);
-
-	if (!ret)
-		ret = max7301_write(ts->spi, 0x08 + (offset >> 2), *config);
-
-	mutex_unlock(&ts->lock);
-
-	return ret;
-}
-
-static int max7301_get(struct gpio_chip *chip, unsigned offset)
-{
-	struct max7301 *ts = container_of(chip, struct max7301, chip);
-	int config, level = -EINVAL;
-
-	/* First 4 pins are unused in the controller */
-	offset += 4;
-
-	mutex_lock(&ts->lock);
-
-	config = (ts->port_config[offset >> 2] >> ((offset & 3) * 2)) & 3;
-
-	switch (config) {
-	case 1:
-		/* Output: return cached level */
-		level =  !!(ts->out_level & (1 << offset));
-		break;
-	case 2:
-	case 3:
-		/* Input: read out */
-		level = max7301_read(ts->spi, 0x20 + offset) & 0x01;
-	}
-	mutex_unlock(&ts->lock);
-
-	return level;
-}
-
-static void max7301_set(struct gpio_chip *chip, unsigned offset, int value)
-{
-	struct max7301 *ts = container_of(chip, struct max7301, chip);
-
-	/* First 4 pins are unused in the controller */
-	offset += 4;
-
-	mutex_lock(&ts->lock);
-
-	__max7301_set(ts, offset, value);
-
-	mutex_unlock(&ts->lock);
-}
-
 static int __devinit max7301_probe(struct spi_device *spi)
 {
 	struct max7301 *ts;
-	struct max7301_platform_data *pdata;
-	int i, ret;
-
-	pdata = spi->dev.platform_data;
-	if (!pdata || !pdata->base) {
-		dev_dbg(&spi->dev, "incorrect or missing platform data\n");
-		return -EINVAL;
-	}
+	int ret;
 
-	/*
-	 * bits_per_word cannot be configured in platform data
-	 */
+	/* bits_per_word cannot be configured in platform data */
 	spi->bits_per_word = 16;
-
 	ret = spi_setup(spi);
 	if (ret < 0)
 		return ret;
@@ -235,90 +66,35 @@ static int __devinit max7301_probe(struc
 	if (!ts)
 		return -ENOMEM;
 
-	mutex_init(&ts->lock);
-
-	dev_set_drvdata(&spi->dev, ts);
-
-	/* Power up the chip and disable IRQ output */
-	max7301_write(spi, 0x04, 0x01);
-
-	ts->spi = spi;
-
-	ts->chip.label = DRIVER_NAME,
-
-	ts->chip.direction_input = max7301_direction_input;
-	ts->chip.get = max7301_get;
-	ts->chip.direction_output = max7301_direction_output;
-	ts->chip.set = max7301_set;
+	ts->read = max7301_spi_read;
+	ts->write = max7301_spi_write;
+	ts->dev = &spi->dev;
 
-	ts->chip.base = pdata->base;
-	ts->chip.ngpio = PIN_NUMBER;
-	ts->chip.can_sleep = 1;
-	ts->chip.dev = &spi->dev;
-	ts->chip.owner = THIS_MODULE;
-
-	/*
-	 * tristate all pins in hardware and cache the
-	 * register values for later use.
-	 */
-	for (i = 1; i < 8; i++) {
-		int j;
-		/* 0xAA means input with internal pullup disabled */
-		max7301_write(spi, 0x08 + i, 0xAA);
-		ts->port_config[i] = 0xAA;
-		for (j = 0; j < 4; j++) {
-			int offset = (i - 1) * 4 + j;
-			ret = max7301_direction_input(&ts->chip, offset);
-			if (ret)
-				goto exit_destroy;
-		}
-	}
-
-	ret = gpiochip_add(&ts->chip);
+	ret = __max730x_probe(ts);
 	if (ret)
-		goto exit_destroy;
-
-	return ret;
-
-exit_destroy:
-	dev_set_drvdata(&spi->dev, NULL);
-	mutex_destroy(&ts->lock);
-	kfree(ts);
+		kfree(ts);
 	return ret;
 }
 
 static int __devexit max7301_remove(struct spi_device *spi)
 {
-	struct max7301 *ts;
-	int ret;
-
-	ts = dev_get_drvdata(&spi->dev);
-	if (ts == NULL)
-		return -ENODEV;
-
-	dev_set_drvdata(&spi->dev, NULL);
-
-	/* Power down the chip and disable IRQ output */
-	max7301_write(spi, 0x04, 0x00);
-
-	ret = gpiochip_remove(&ts->chip);
-	if (!ret) {
-		mutex_destroy(&ts->lock);
-		kfree(ts);
-	} else
-		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n",
-			ret);
-
-	return ret;
+	return __max730x_remove(&spi->dev);
 }
 
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
 	},
-	.probe		= max7301_probe,
-	.remove		= __devexit_p(max7301_remove),
+	.probe = max7301_probe,
+	.remove = __devexit_p(max7301_remove),
+	.id_table = max7301_id,
 };
 
 static int __init max7301_init(void)
@@ -336,7 +112,6 @@ static void __exit max7301_exit(void)
 }
 module_exit(max7301_exit);
 
-MODULE_AUTHOR("Juergen Beisert");
+MODULE_AUTHOR("Juergen Beisert, Wolfram Sang");
 MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("MAX7301 SPI based GPIO-Expander");
-MODULE_ALIAS("spi:" DRIVER_NAME);
+MODULE_DESCRIPTION("MAX7301 GPIO-Expander");
diff -puN /dev/null drivers/gpio/max730x.c
--- /dev/null
+++ a/drivers/gpio/max730x.c
@@ -0,0 +1,244 @@
+/**
+ * drivers/gpio/max7301.c
+ *
+ * Copyright (C) 2006 Juergen Beisert, Pengutronix
+ * Copyright (C) 2008 Guennadi Liakhovetski, Pengutronix
+ * Copyright (C) 2009 Wolfram Sang, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * The Maxim MAX7300/1 device is an I2C/SPI driven GPIO expander. There are
+ * 28 GPIOs. 8 of them can trigger an interrupt. See datasheet for more
+ * details
+ * Note:
+ * - DIN must be stable at the rising edge of clock.
+ * - when writing:
+ *   - always clock in 16 clocks at once
+ *   - at DIN: D15 first, D0 last
+ *   - D0..D7 = databyte, D8..D14 = commandbyte
+ *   - D15 = low -> write command
+ * - when reading
+ *   - always clock in 16 clocks at once
+ *   - at DIN: D15 first, D0 last
+ *   - D0..D7 = dummy, D8..D14 = register address
+ *   - D15 = high -> read command
+ *   - raise CS and assert it again
+ *   - always clock in 16 clocks at once
+ *   - at DOUT: D15 first, D0 last
+ *   - D0..D7 contains the data from the first cycle
+ *
+ * The driver exports a standard gpiochip interface
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/spi/max7301.h>
+#include <linux/gpio.h>
+
+/*
+ * Pin configurations, see MAX7301 datasheet page 6
+ */
+#define PIN_CONFIG_MASK 0x03
+#define PIN_CONFIG_IN_PULLUP 0x03
+#define PIN_CONFIG_IN_WO_PULLUP 0x02
+#define PIN_CONFIG_OUT 0x01
+
+#define PIN_NUMBER 28
+
+static int max7301_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct max7301 *ts = container_of(chip, struct max7301, chip);
+	u8 *config;
+	u8 offset_bits;
+	int ret;
+
+	/* First 4 pins are unused in the controller */
+	offset += 4;
+	offset_bits = (offset & 3) << 1;
+
+	config = &ts->port_config[offset >> 2];
+
+	mutex_lock(&ts->lock);
+
+	/* Standard GPIO API doesn't support pull-ups, has to be extended.
+	 * Hard-coding no pollup for now. */
+	*config = (*config & ~(PIN_CONFIG_MASK << offset_bits))
+			   | (PIN_CONFIG_IN_WO_PULLUP << offset_bits);
+
+	ret = ts->write(ts->dev, 0x08 + (offset >> 2), *config);
+
+	mutex_unlock(&ts->lock);
+
+	return ret;
+}
+
+static int __max7301_set(struct max7301 *ts, unsigned offset, int value)
+{
+	if (value) {
+		ts->out_level |= 1 << offset;
+		return ts->write(ts->dev, 0x20 + offset, 0x01);
+	} else {
+		ts->out_level &= ~(1 << offset);
+		return ts->write(ts->dev, 0x20 + offset, 0x00);
+	}
+}
+
+static int max7301_direction_output(struct gpio_chip *chip, unsigned offset,
+				    int value)
+{
+	struct max7301 *ts = container_of(chip, struct max7301, chip);
+	u8 *config;
+	u8 offset_bits;
+	int ret;
+
+	/* First 4 pins are unused in the controller */
+	offset += 4;
+	offset_bits = (offset & 3) << 1;
+
+	config = &ts->port_config[offset >> 2];
+
+	mutex_lock(&ts->lock);
+
+	*config = (*config & ~(PIN_CONFIG_MASK << offset_bits))
+			   | (PIN_CONFIG_OUT << offset_bits);
+
+	ret = __max7301_set(ts, offset, value);
+
+	if (!ret)
+		ret = ts->write(ts->dev, 0x08 + (offset >> 2), *config);
+
+	mutex_unlock(&ts->lock);
+
+	return ret;
+}
+
+static int max7301_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct max7301 *ts = container_of(chip, struct max7301, chip);
+	int config, level = -EINVAL;
+
+	/* First 4 pins are unused in the controller */
+	offset += 4;
+
+	mutex_lock(&ts->lock);
+
+	config = (ts->port_config[offset >> 2] >> ((offset & 3) << 1))
+			& PIN_CONFIG_MASK;
+
+	switch (config) {
+	case PIN_CONFIG_OUT:
+		/* Output: return cached level */
+		level =  !!(ts->out_level & (1 << offset));
+		break;
+	case PIN_CONFIG_IN_WO_PULLUP:
+	case PIN_CONFIG_IN_PULLUP:
+		/* Input: read out */
+		level = ts->read(ts->dev, 0x20 + offset) & 0x01;
+	}
+	mutex_unlock(&ts->lock);
+
+	return level;
+}
+
+static void max7301_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct max7301 *ts = container_of(chip, struct max7301, chip);
+
+	/* First 4 pins are unused in the controller */
+	offset += 4;
+
+	mutex_lock(&ts->lock);
+
+	__max7301_set(ts, offset, value);
+
+	mutex_unlock(&ts->lock);
+}
+
+int __devinit __max730x_probe(struct max7301 *ts)
+{
+	struct device *dev = ts->dev;
+	struct max7301_platform_data *pdata;
+	int i, ret;
+
+	pdata = dev->platform_data;
+	if (!pdata || !pdata->base) {
+		dev_err(dev, "incorrect or missing platform data\n");
+		return -EINVAL;
+	}
+
+	mutex_init(&ts->lock);
+	dev_set_drvdata(dev, ts);
+
+	/* Power up the chip and disable IRQ output */
+	ts->write(dev, 0x04, 0x01);
+
+	ts->chip.label = dev->driver->name;
+
+	ts->chip.direction_input = max7301_direction_input;
+	ts->chip.get = max7301_get;
+	ts->chip.direction_output = max7301_direction_output;
+	ts->chip.set = max7301_set;
+
+	ts->chip.base = pdata->base;
+	ts->chip.ngpio = PIN_NUMBER;
+	ts->chip.can_sleep = 1;
+	ts->chip.dev = dev;
+	ts->chip.owner = THIS_MODULE;
+
+	/*
+	 * tristate all pins in hardware and cache the
+	 * register values for later use.
+	 */
+	for (i = 1; i < 8; i++) {
+		int j;
+		/* 0xAA means input with internal pullup disabled */
+		ts->write(dev, 0x08 + i, 0xAA);
+		ts->port_config[i] = 0xAA;
+		for (j = 0; j < 4; j++) {
+			int offset = (i - 1) * 4 + j;
+			ret = max7301_direction_input(&ts->chip, offset);
+			if (ret)
+				goto exit_destroy;
+		}
+	}
+
+	ret = gpiochip_add(&ts->chip);
+	if (ret)
+		goto exit_destroy;
+
+	return ret;
+
+exit_destroy:
+	dev_set_drvdata(dev, NULL);
+	mutex_destroy(&ts->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__max730x_probe);
+
+int __devexit __max730x_remove(struct device *dev)
+{
+	struct max7301 *ts = dev_get_drvdata(dev);
+	int ret;
+
+	if (ts == NULL)
+		return -ENODEV;
+
+	dev_set_drvdata(dev, NULL);
+
+	/* Power down the chip and disable IRQ output */
+	ts->write(dev, 0x04, 0x00);
+
+	ret = gpiochip_remove(&ts->chip);
+	if (!ret) {
+		mutex_destroy(&ts->lock);
+		kfree(ts);
+	} else
+		dev_err(dev, "Failed to remove GPIO controller: %d\n", ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__max730x_remove);
diff -puN include/linux/spi/max7301.h~gpio-add-driver-for-max7300-i2c-gpio-extender include/linux/spi/max7301.h
--- a/include/linux/spi/max7301.h~gpio-add-driver-for-max7300-i2c-gpio-extender
+++ a/include/linux/spi/max7301.h
@@ -1,9 +1,27 @@
 #ifndef LINUX_SPI_MAX7301_H
 #define LINUX_SPI_MAX7301_H
 
+#include <linux/gpio.h>
+
+/*
+ * Some registers must be read back to modify.
+ * To save time we cache them here in memory
+ */
+struct max7301 {
+	struct mutex	lock;
+	u8		port_config[8];	/* field 0 is unused */
+	u32		out_level;	/* cached output levels */
+	struct gpio_chip chip;
+	struct device *dev;
+	int (*write)(struct device *dev, unsigned int reg, unsigned int val);
+	int (*read)(struct device *dev, unsigned int reg);
+};
+
 struct max7301_platform_data {
 	/* number assigned to the first GPIO */
 	unsigned	base;
 };
 
+extern int __max730x_remove(struct device *dev);
+extern int __max730x_probe(struct max7301 *ts);
 #endif
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch

