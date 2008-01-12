From: akpm@linux-foundation.org
Subject: + gpiolib-pcf857x-i2c-gpio-expander-support.patch added to -mm tree
Date: Fri, 11 Jan 2008 18:22:57 -0800
Message-ID: <200801120222.m0C2Mw67009694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491AbYALCbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 21:31:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, bgardner@wabtec.com, eric.miao@marvell.com, hskinnemoen@atmel.com, khali@linux-fr.org, philipp.zabel@gmail.com, rmk@arm.linux.org.uk, sam@ravnborg.org


The patch titled
     gpiolib: pcf857x i2c gpio expander support
has been added to the -mm tree.  Its filename is
     gpiolib-pcf857x-i2c-gpio-expander-support.patch

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
Subject: gpiolib: pcf857x i2c gpio expander support
From: David Brownell <dbrownell@users.sourceforge.net>

This is a new-style I2C driver for most common 8 and 16 bit I2C based
"quasi-bidirectional" GPIO expanders: pcf8574 or pcf8575, and several
compatible models (mostly faster, supporting I2C at up to 1 MHz).

The driver exposes the GPIO signals using the platform-neutral GPIO
programming interface, so they are easily accessed by other kernel code.  The
lack of such a flexible kernel API has been a big factor in the proliferation
of board-specific drivers for these chips...  stuff that rarely makes it
upstream since it's so ugly.  This driver will let such boards use standard
calls.

Since it's a new-style driver, these devices must be configured as part of
board-specific init.  That eliminates the need for error-prone manual
configuration of module parameters, and makes compatibility with legacy
drivers (pcf8574.c, pc8575.c) for these chips easier (there's a clear
either/or disjunction).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ben Gardner <bgardner@wabtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig        |   23 ++
 drivers/gpio/Makefile       |    1 
 drivers/gpio/pcf857x.c      |  330 ++++++++++++++++++++++++++++++++++
 include/linux/i2c/pcf857x.h |   45 ++++
 4 files changed, 399 insertions(+)

diff -puN drivers/gpio/Kconfig~gpiolib-pcf857x-i2c-gpio-expander-support drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpiolib-pcf857x-i2c-gpio-expander-support
+++ a/drivers/gpio/Kconfig
@@ -27,6 +27,29 @@ config DEBUG_GPIO
 
 comment "I2C GPIO expanders:"
 
+config GPIO_PCF857X
+	tristate "PCF857x, PCA857x, and PCA967x I2C GPIO expanders"
+	depends on I2C
+	help
+	  Say yes here to provide access to most "quasi-bidirectional" I2C
+	  GPIO expanders used for additional digital outputs or inputs.
+	  Most of these parts are from NXP, though TI is a second source for
+	  some of them.  Compatible models include:
+
+	  8 bits:   pcf8574, pcf8574a, pca8574, pca8574a,
+	            pca9670, pca9672, pca9674, pca9674a
+
+	  16 bits:  pcf8575, pcf8575c, pca8575,
+	            pca9671, pca9673, pca9675
+
+	  Your board setup code will need to declare the expanders in
+	  use, and assign numbers to the GPIOs they expose.  Those GPIOs
+	  can then be used from drivers and other kernel code, just like
+	  other GPIOs, but only accessible from task contexts.
+
+	  This driver provides an in-kernel interface to those GPIOs using
+	  platform-neutral GPIO calls.
+
 comment "SPI GPIO expanders:"
 
 endmenu
diff -puN drivers/gpio/Makefile~gpiolib-pcf857x-i2c-gpio-expander-support drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpiolib-pcf857x-i2c-gpio-expander-support
+++ a/drivers/gpio/Makefile
@@ -4,3 +4,4 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpiolib.o
 
+obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
diff -puN /dev/null drivers/gpio/pcf857x.c
--- /dev/null
+++ a/drivers/gpio/pcf857x.c
@@ -0,0 +1,330 @@
+/*
+ * pcf857x - driver for pcf857x, pca857x, and pca967x I2C GPIO expanders
+ *
+ * Copyright (C) 2007 David Brownell
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/i2c/pcf857x.h>
+
+#include <asm/gpio.h>
+
+
+/*
+ * The pcf857x, pca857x, and pca967x chips only expose one read and one
+ * write register.  Writing a "one" bit (to match the reset state) lets
+ * that pin be used as an input; it's not an open-drain model, but acts
+ * a bit like one.  This is described as "quasi-bidirectional"; read the
+ * chip documentation for details.
+ *
+ * Many other I2C GPIO expander chips (like the pca953x models) have
+ * more complex register models and more conventional circuitry using
+ * push/pull drivers.  They often use the same 0x20..0x27 addresses as
+ * pcf857x parts, making the "legacy" I2C driver model problematic.
+ */
+struct pcf857x {
+	struct gpio_chip	chip;
+	struct i2c_client	*client;
+	unsigned		out;		/* software latch */
+};
+
+/*-------------------------------------------------------------------------*/
+
+/* Talk to 8-bit I/O expander */
+
+static int pcf857x_input8(struct gpio_chip *chip, unsigned offset)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+
+	gpio->out |= (1 << offset);
+	return i2c_smbus_write_byte(gpio->client, gpio->out);
+}
+
+static int pcf857x_get8(struct gpio_chip *chip, unsigned offset)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	s32		value;
+
+	value = i2c_smbus_read_byte(gpio->client);
+	return (value < 0) ? 0 : (value & (1 << offset));
+}
+
+static int pcf857x_output8(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	unsigned	bit = 1 << offset;
+
+	if (value)
+		gpio->out |= bit;
+	else
+		gpio->out &= ~bit;
+	return i2c_smbus_write_byte(gpio->client, gpio->out);
+}
+
+static void pcf857x_set8(struct gpio_chip *chip, unsigned offset, int value)
+{
+	pcf857x_output8(chip, offset, value);
+}
+
+/*-------------------------------------------------------------------------*/
+
+/* Talk to 16-bit I/O expander */
+
+static int i2c_write_le16(struct i2c_client *client, u16 word)
+{
+	u8 buf[2] = { word & 0xff, word >> 8, };
+	int status;
+
+	status = i2c_master_send(client, buf, 2);
+	return (status < 0) ? status : 0;
+}
+
+static int i2c_read_le16(struct i2c_client *client)
+{
+	u8 buf[2];
+	int status;
+
+	status = i2c_master_recv(client, buf, 2);
+	if (status < 0)
+		return status;
+	return (buf[1] << 8) | buf[0];
+}
+
+static int pcf857x_input16(struct gpio_chip *chip, unsigned offset)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+
+	gpio->out |= (1 << offset);
+	return i2c_write_le16(gpio->client, gpio->out);
+}
+
+static int pcf857x_get16(struct gpio_chip *chip, unsigned offset)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	int		value;
+
+	value = i2c_read_le16(gpio->client);
+	return (value < 0) ? 0 : (value & (1 << offset));
+}
+
+static int pcf857x_output16(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
+	unsigned	bit = 1 << offset;
+
+	if (value)
+		gpio->out |= bit;
+	else
+		gpio->out &= ~bit;
+	return i2c_write_le16(gpio->client, gpio->out);
+}
+
+static void pcf857x_set16(struct gpio_chip *chip, unsigned offset, int value)
+{
+	pcf857x_output16(chip, offset, value);
+}
+
+/*-------------------------------------------------------------------------*/
+
+static int pcf857x_probe(struct i2c_client *client)
+{
+	struct pcf857x_platform_data	*pdata;
+	struct pcf857x			*gpio;
+	int				status;
+
+	pdata = client->dev.platform_data;
+	if (!pdata)
+		return -ENODEV;
+
+	/* Allocate, initialize, and register this gpio_chip. */
+	gpio = kzalloc(sizeof *gpio, GFP_KERNEL);
+	if (!gpio)
+		return -ENOMEM;
+
+	gpio->chip.base = pdata->gpio_base;
+	gpio->chip.can_sleep = 1;
+
+	/* NOTE:  the OnSemi jlc1562b is also largely compatible with
+	 * these parts, notably for output.  It has a low-resolution
+	 * DAC instead of pin change IRQs; and its inputs can be the
+	 * result of comparators.
+	 */
+
+	/* 8574 addresses are 0x20..0x27; 8574a uses 0x38..0x3f;
+	 * 9670, 9672, 9764, and 9764a use quite a variety.
+	 *
+	 * NOTE: we don't distinguish here between *4 and *4a parts.
+	 */
+	if (strcmp(client->name, "pcf8574") == 0
+			|| strcmp(client->name, "pca8574") == 0
+			|| strcmp(client->name, "pca9670") == 0
+			|| strcmp(client->name, "pca9672") == 0
+			|| strcmp(client->name, "pca9674") == 0
+			) {
+		gpio->chip.ngpio = 8;
+		gpio->chip.direction_input = pcf857x_input8;
+		gpio->chip.get = pcf857x_get8;
+		gpio->chip.direction_output = pcf857x_output8;
+		gpio->chip.set = pcf857x_set8;
+
+		if (!i2c_check_functionality(client->adapter,
+				I2C_FUNC_SMBUS_BYTE))
+			status = -EIO;
+
+		/* fail if there's no chip present */
+		else
+			status = i2c_smbus_read_byte(client);
+
+	/* '75/'75c addresses are 0x20..0x27, just like the '74;
+	 * the '75c doesn't have a current source pulling high.
+	 * 9671, 9673, and 9765 use quite a variety of addresses.
+	 *
+	 * NOTE: we don't distinguish here between '75 and '75c parts.
+	 */
+	} else if (strcmp(client->name, "pcf8575") == 0
+			|| strcmp(client->name, "pca8575") == 0
+			|| strcmp(client->name, "pca9671") == 0
+			|| strcmp(client->name, "pca9673") == 0
+			|| strcmp(client->name, "pca9675") == 0
+			) {
+		gpio->chip.ngpio = 16;
+		gpio->chip.direction_input = pcf857x_input16;
+		gpio->chip.get = pcf857x_get16;
+		gpio->chip.direction_output = pcf857x_output16;
+		gpio->chip.set = pcf857x_set16;
+
+		if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+			status = -EIO;
+
+		/* fail if there's no chip present */
+		else
+			status = i2c_read_le16(client);
+
+	} else
+		status = -ENODEV;
+
+	if (status < 0)
+		goto fail;
+
+	gpio->chip.label = client->name;
+
+	gpio->client = client;
+	i2c_set_clientdata(client, gpio);
+
+	/* NOTE:  these chips have strange "quasi-bidirectional" I/O pins.
+	 * We can't actually know whether a pin is configured (a) as output
+	 * and driving the signal low, or (b) as input and reporting a low
+	 * value ... without knowing the last value written since the chip
+	 * came out of reset (if any).  We can't read the latched output.
+	 *
+	 * In short, the only reliable solution for setting up pin direction
+	 * is to do it explicitly.  The setup() method can do that, but it
+	 * may cause transient glitching since it can't know the last value
+	 * written (some pins may need to be driven low).
+	 *
+	 * Using pdata->n_latch avoids that trouble.  When left initialized
+	 * to zero, our software copy of the "latch" then matches the chip's
+	 * all-ones reset state.  Otherwise it flags pins to be driven low.
+	 */
+	gpio->out = ~pdata->n_latch;
+
+	status = gpiochip_add(&gpio->chip);
+	if (status < 0)
+		goto fail;
+
+	/* NOTE: these chips can issue "some pin-changed" IRQs, which we
+	 * don't yet even try to use.  Among other issues, the relevant
+	 * genirq state isn't available to modular drivers; and most irq
+	 * methods can't be called from sleeping contexts.
+	 */
+
+	dev_info(&client->dev, "gpios %d..%d on a %s%s\n",
+			gpio->chip.base,
+			gpio->chip.base + gpio->chip.ngpio - 1,
+			client->name,
+			client->irq ? " (irq ignored)" : "");
+
+	/* Let platform code set up the GPIOs and their users.
+	 * Now is the first time anyone could use them.
+	 */
+	if (pdata->setup) {
+		status = pdata->setup(client,
+				gpio->chip.base, gpio->chip.ngpio,
+				pdata->context);
+		if (status < 0)
+			dev_warn(&client->dev, "setup --> %d\n", status);
+	}
+
+	return 0;
+
+fail:
+	dev_dbg(&client->dev, "probe error %d for '%s'\n",
+			status, client->name);
+	kfree(gpio);
+	return status;
+}
+
+static int pcf857x_remove(struct i2c_client *client)
+{
+	struct pcf857x_platform_data	*pdata = client->dev.platform_data;
+	struct pcf857x			*gpio = i2c_get_clientdata(client);
+	int				status = 0;
+
+	if (pdata->teardown) {
+		status = pdata->teardown(client,
+				gpio->chip.base, gpio->chip.ngpio,
+				pdata->context);
+		if (status < 0) {
+			dev_err(&client->dev, "%s --> %d\n",
+					"teardown", status);
+			return status;
+		}
+	}
+
+	status = gpiochip_remove(&gpio->chip);
+	if (status == 0)
+		kfree(gpio);
+	else
+		dev_err(&client->dev, "%s --> %d\n", "remove", status);
+	return status;
+}
+
+static struct i2c_driver pcf857x_driver = {
+	.driver = {
+		.name	= "pcf857x",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= pcf857x_probe,
+	.remove	= pcf857x_remove,
+};
+
+static int __init pcf857x_init(void)
+{
+	return i2c_add_driver(&pcf857x_driver);
+}
+module_init(pcf857x_init);
+
+static void __exit pcf857x_exit(void)
+{
+	i2c_del_driver(&pcf857x_driver);
+}
+module_exit(pcf857x_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Brownell");
diff -puN /dev/null include/linux/i2c/pcf857x.h
--- /dev/null
+++ a/include/linux/i2c/pcf857x.h
@@ -0,0 +1,45 @@
+#ifndef __LINUX_PCF857X_H
+#define __LINUX_PCF857X_H
+
+/**
+ * struct pcf857x_platform_data - data to set up pcf857x driver
+ * @gpio_base: number of the chip's first GPIO
+ * @n_latch: optional bit-inverse of initial register value; if
+ *	you leave this initialized to zero the driver will act
+ *	like the chip was just reset
+ * @setup: optional callback issued once the GPIOs are valid
+ * @teardown: optional callback issued before the GPIOs are invalidated
+ * @context: optional parameter passed to setup() and teardown()
+ *
+ * In addition to the I2C_BOARD_INFO() state appropriate to each chip,
+ * the i2c_board_info used with the pcf875x driver must provide the
+ * chip "type" ("pcf8574", "pcf8574a", "pcf8575", "pcf8575c") and its
+ * platform_data (pointer to one of these structures) with at least
+ * the gpio_base value initialized.
+ *
+ * The @setup callback may be used with the kind of board-specific glue
+ * which hands the (now-valid) GPIOs to other drivers, or which puts
+ * devices in their initial states using these GPIOs.
+ *
+ * These GPIO chips are only "quasi-bidirectional"; read the chip specs
+ * to understand the behavior.  They don't have separate registers to
+ * record which pins are used for input or output, record which output
+ * values are driven, or provide access to input values.  That must be
+ * inferred by reading the chip's value and knowing the last value written
+ * to it.  If you leave n_latch initialized to zero, that last written
+ * value is presumed to be all ones (as if the chip were just reset).
+ */
+struct pcf857x_platform_data {
+	unsigned	gpio_base;
+	unsigned	n_latch;
+
+	int		(*setup)(struct i2c_client *client,
+					int gpio, unsigned ngpio,
+					void *context);
+	int		(*teardown)(struct i2c_client *client,
+					int gpio, unsigned ngpio,
+					void *context);
+	void		*context;
+};
+
+#endif /* __LINUX_PCF857X_H */
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

spi_bitbang-always-grab-lock-with-irqs-blocked.patch
git-arm.patch
git-input.patch
backlight-omap1-backlight-driver.patch
pcmcia-stop-updating-dev-powerpower_state.patch
at91_cf-use-generic-gpio-calls.patch
remove-obsolete-sys-devices-power-state-docs.patch
spi-core-stop-updating-dev-powerpower_state.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-avr32-at32ap-platform-support.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
