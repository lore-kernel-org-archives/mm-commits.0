From: akpm@linux-foundation.org
Subject: + gpio-gpio-driver-for-max7301-spi-gpio-expander.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:57:52 -0700
Message-ID: <200806082357.m58NvqjJ026349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758AbYFHX6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:58:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: j.beisert@pengutronix.de, david-b@pacbell.net, g.liakhovetski@pengutronix.de


The patch titled
     gpio: gpio driver for max7301 SPI GPIO expander
has been added to the -mm tree.  Its filename is
     gpio-gpio-driver-for-max7301-spi-gpio-expander.patch

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
Subject: gpio: gpio driver for max7301 SPI GPIO expander
From: Juergen Beisert <j.beisert@pengutronix.de>

Maxim's MAX7301 is an SPI GPIO expander with 28 GPIOs. Note: MAX7301's interrupt
feature is not supported yet.

Signed-off-by: Juergen Beisert <j.beisert@pengutronix.de>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig        |    6 
 drivers/gpio/Makefile       |    1 
 drivers/gpio/max7301.c      |  333 ++++++++++++++++++++++++++++++++++
 include/linux/spi/max7301.h |    9 
 4 files changed, 349 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-gpio-driver-for-max7301-spi-gpio-expander drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-gpio-driver-for-max7301-spi-gpio-expander
+++ a/drivers/gpio/Kconfig
@@ -63,6 +63,12 @@ config GPIO_PCF857X
 
 comment "SPI GPIO expanders:"
 
+config GPIO_MAX7301
+	tristate "Maxim MAX7301 GPIO expander"
+	depends on SPI_MASTER
+	help
+	  gpio driver for Maxim MAX7301 SPI GPIO expander.
+
 config GPIO_MCP23S08
 	tristate "Microchip MCP23S08 I/O expander"
 	depends on SPI_MASTER
diff -puN drivers/gpio/Makefile~gpio-gpio-driver-for-max7301-spi-gpio-expander drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-gpio-driver-for-max7301-spi-gpio-expander
+++ a/drivers/gpio/Makefile
@@ -4,6 +4,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpiolib.o
 
+obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
diff -puN /dev/null drivers/gpio/max7301.c
--- /dev/null
+++ a/drivers/gpio/max7301.c
@@ -0,0 +1,333 @@
+/**
+ * drivers/gpio/max7301.c
+ *
+ * Copyright (C) 2006 Juergen Beisert, Pengutronix
+ * Copyright (C) 2008 Guennadi Liakhovetski, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * The Maxim's MAX7301 device is an SPI driven GPIO expander. There are
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
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/max7301.h>
+#include <linux/gpio.h>
+
+#define DRIVER_NAME "max7301"
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
+	struct spi_device *spi;
+};
+
+/**
+ * max7301_write - Write a new register content
+ * @spi: The SPI device
+ * @reg: Register offset
+ * @val: Value to write
+ *
+ * A write to the MAX7301 means one message with one transfer
+ *
+ * Returns 0 if successfull or a negative value on error
+ */
+static int max7301_write(struct spi_device *spi, unsigned int reg, unsigned int val)
+{
+	u16 word = ((reg & 0x7F) << 8) | (val & 0xFF);
+	return spi_write(spi, (const u8*)&word, sizeof(word));
+}
+
+/**
+ * max7301_read - Read back register content
+ * @spi: The SPI device
+ * @reg: Register offset
+ *
+ * A read from the MAX7301 means one message with two transfers
+ *
+ * Returns positive 8 bit value from device if successfull or a
+ * negative value on error
+ */
+static int max7301_read(struct spi_device *spi, unsigned int reg)
+{
+	int ret;
+	u16 word;
+
+	word = 0x8000 | (reg << 8);
+	if ((ret = spi_write(spi, (const u8*)&word, sizeof(word))) != 0)
+		return ret;
+	/*
+	 * FIXME: This read should write 0x0000 (=NOOP at MAX7301 side)
+	 */
+	if ((ret = spi_read(spi, (u8*)&word, sizeof(word))))
+		return ret;
+	return word;
+}
+
+static int max7301_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct max7301 *ts = container_of(chip, struct max7301, chip);
+	u8 *config;
+	int ret;
+
+	/* First 4 pins are unused in the controller */
+	offset += 4;
+
+	config = &ts->port_config[offset >> 2];
+
+	mutex_lock(&ts->lock);
+
+	/* Standard GPIO API doesn't support pull-ups, has to be extended.
+	 * Hard-coding no pollup for now. */
+	*config = (*config & ~(3 << (offset & 3))) | (1 << (offset & 3));
+
+	ret = max7301_write(ts->spi, 0x08 + (offset >> 2), *config);
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
+		return max7301_write(ts->spi, 0x20 + offset, 0x01);
+	} else {
+		ts->out_level &= ~(1 << offset);
+		return max7301_write(ts->spi, 0x20 + offset, 0x00);
+	}
+}
+
+static int max7301_direction_output(struct gpio_chip *chip, unsigned offset,
+				    int value)
+{
+	struct max7301 *ts = container_of(chip, struct max7301, chip);
+	u8 *config;
+	int ret;
+
+	/* First 4 pins are unused in the controller */
+	offset += 4;
+
+	config = &ts->port_config[offset >> 2];
+
+	mutex_lock(&ts->lock);
+
+	*config = (*config & ~(3 << (offset & 3))) | (1 << (offset & 3));
+
+	ret = __max7301_set(ts, offset, value);
+
+	if (!ret)
+		ret = max7301_write(ts->spi, 0x08 + (offset >> 2), *config);
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
+	config = (ts->port_config[offset >> 2] >> ((offset & 3) * 2)) & 3;
+
+	switch (config) {
+	case 1:
+		/* Output: return cached level */
+		level =  !!(ts->out_level & (1 << offset));
+		break;
+	case 2:
+	case 3:
+		/* Input: read out */
+		level = max7301_read(ts->spi, 0x20 + offset) & 0x01;
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
+static int __devinit max7301_probe(struct spi_device *spi)
+{
+	struct max7301 *ts;
+	struct max7301_platform_data *pdata;
+	int i, ret;
+
+	pdata = spi->dev.platform_data;
+	if (!pdata || !pdata->base)
+		return -ENODEV;
+
+	/*
+	 * bits_per_word cannot be configured in platform data
+	 */
+	spi->bits_per_word = 16;
+
+	spi->master->setup(spi);
+
+	ts = kzalloc(sizeof(struct max7301), GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+	mutex_init(&ts->lock);
+
+	dev_set_drvdata(&spi->dev, ts);
+
+	/* Power up the chip and disable IRQ output */
+	max7301_write(spi, 0x04, 0x01);
+
+	ts->spi = spi;
+
+	ts->chip.label = DRIVER_NAME,
+
+	ts->chip.direction_input = max7301_direction_input;
+	ts->chip.get = max7301_get;
+	ts->chip.direction_output = max7301_direction_output;
+	ts->chip.set = max7301_set;
+
+	ts->chip.base = pdata->base;
+	ts->chip.ngpio = PIN_NUMBER;
+	ts->chip.can_sleep = 1;
+	ts->chip.dev = &spi->dev;
+	ts->chip.owner = THIS_MODULE;
+
+	ret = gpiochip_add(&ts->chip);
+	if (ret)
+		goto exit_destroy;
+
+	/*
+	 * tristate all pins in hardware and cache the
+	 * register values for later use.
+	 */
+	for (i = 1; i < 8; i++) {
+		int j;
+		/* 0xAA means input with internal pullup disabled */
+		max7301_write(spi, 0x08 + i, 0xAA);
+		ts->port_config[i] = 0xAA;
+		for (j = 0; j < 4; j++) {
+			int idx = ts->chip.base + (i - 1) * 4 + j;
+			ret = gpio_direction_input(idx);
+			if (ret)
+				goto exit_remove;
+			gpio_free(idx);
+		}
+	}
+	return ret;
+
+exit_remove:
+	gpiochip_remove(&ts->chip);
+exit_destroy:
+	dev_set_drvdata(&spi->dev, NULL);
+	mutex_destroy(&ts->lock);
+	kfree(ts);
+	return ret;
+}
+
+static int max7301_remove(struct spi_device *spi)
+{
+	struct max7301 *ts;
+	int ret;
+
+	ts = dev_get_drvdata(&spi->dev);
+	if (ts == NULL)
+		return -ENODEV;
+
+	dev_set_drvdata(&spi->dev, NULL);
+
+	/* Power down the chip and disable IRQ output */
+	max7301_write(spi, 0x04, 0x00);
+
+	ret = gpiochip_remove(&ts->chip);
+	if (!ret) {
+		mutex_destroy(&ts->lock);
+		kfree(ts);
+	} else
+		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n", ret);
+
+	return ret;
+}
+
+static struct spi_driver max7301_driver = {
+	.driver = {
+		.name		= DRIVER_NAME,
+		.owner		= THIS_MODULE,
+	},
+	.probe		= max7301_probe,
+	.remove		= __devexit_p(max7301_remove),
+};
+
+static int __init max7301_init(void)
+{
+	return spi_register_driver(&max7301_driver);
+}
+
+static void __exit max7301_exit(void)
+{
+	spi_unregister_driver(&max7301_driver);
+}
+
+module_init(max7301_init);
+module_exit(max7301_exit);
+
+MODULE_AUTHOR("Juergen Beisert");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MAX7301 SPI based GPIO-Expander");
diff -puN /dev/null include/linux/spi/max7301.h
--- /dev/null
+++ a/include/linux/spi/max7301.h
@@ -0,0 +1,9 @@
+#ifndef LINUX_SPI_MAX7301_H
+#define LINUX_SPI_MAX7301_H
+
+struct max7301_platform_data {
+	/* number assigned to the first GPIO */
+	unsigned	base;
+};
+
+#endif
_

Patches currently in -mm which might be from j.beisert@pengutronix.de are

gpio-gpio-driver-for-max7301-spi-gpio-expander.patch

