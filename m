From: akpm@linux-foundation.org
Subject: [to-be-updated] gpio-add-timbgpio.patch removed from -mm tree
Date: Thu, 04 Jun 2009 17:19:37 -0700
Message-ID: <200906050039.n550dQck008176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbZFEAj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 20:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors.ext@mocean-labs.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpio: add timbgpio
has been removed from the -mm tree.  Its filename was
     gpio-add-timbgpio.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: add timbgpio
From: Richard Rojfors <richard.rojfors.ext@mocean-labs.com>

A GPIO driver for the Timberdale FPGA found on the Intel Atom board
Russellville.

Signed-off-by: Richard Rojfors <richard.rojfors.ext@mocean-labs.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig    |    6 
 drivers/gpio/Makefile   |    2 
 drivers/gpio/timbgpio.c |  275 ++++++++++++++++++++++++++++++++++++++
 drivers/gpio/timbgpio.h |   48 ++++++
 4 files changed, 330 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/Kconfig~gpio-add-timbgpio drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-add-timbgpio
+++ a/drivers/gpio/Kconfig
@@ -167,6 +167,12 @@ config GPIO_BT8XX
 
 	  If unsure, say N.
 
+config GPIO_TIMBERDALE
+	tristate "Support for timberdale GPIO"
+	depends on MFD_TIMBERDALE && GPIOLIB
+	---help---
+	Add support for GPIO usage of some pins of the timberdale FPGA.
+
 comment "SPI GPIO expanders:"
 
 config GPIO_MAX7301
diff -puN drivers/gpio/Makefile~gpio-add-timbgpio drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-add-timbgpio
+++ a/drivers/gpio/Makefile
@@ -10,8 +10,8 @@ obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
+obj-$(CONFIG_GPIO_TIMBERDALE)	+= timbgpio.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
 obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
-
diff -puN /dev/null drivers/gpio/timbgpio.c
--- /dev/null
+++ a/drivers/gpio/timbgpio.c
@@ -0,0 +1,275 @@
+/*
+ * timbgpio.c timberdale FPGA GPIO driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+/* Supports:
+ * Timberdale FPGA GPIO
+ */
+
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+
+#include "timbgpio.h"
+
+static u32 timbgpio_configure(struct gpio_chip *gpio, unsigned nr,
+						unsigned off, unsigned val)
+{
+	struct timbgpio *tgpio = container_of(gpio, struct timbgpio, gpio);
+
+	u32 config, oldconfig, wconfig;
+
+	mutex_lock(&tgpio->lock);
+	config = ioread32(tgpio->membase + off);
+	oldconfig = config;
+
+	if (val)
+		config |= (1 << nr);
+	else
+		config &= ~(1 << nr);
+
+	iowrite32(config, tgpio->membase + off);
+	wconfig = ioread32(tgpio->membase + off);
+	mutex_unlock(&tgpio->lock);
+
+	return oldconfig;
+}
+
+static int timbgpio_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
+{
+	timbgpio_configure(gpio, nr, TGPIODIR, 1);
+	return 0;
+}
+
+static int timbgpio_gpio_get(struct gpio_chip *gpio, unsigned nr)
+{
+	struct timbgpio *tgpio = container_of(gpio, struct timbgpio, gpio);
+	u32 value;
+
+	value = ioread32(tgpio->membase + TGPIOVAL);
+	return (value & (1 << nr)) ? 1 : 0;
+}
+
+static int timbgpio_gpio_direction_output(struct gpio_chip *gpio,
+						unsigned nr, int val)
+{
+	timbgpio_configure(gpio, nr, TGPIODIR, 0);
+	return 0;
+}
+
+
+
+static void timbgpio_gpio_set(struct gpio_chip *gpio,
+				unsigned nr, int val)
+{
+	timbgpio_configure(gpio, nr, TGPIOVAL, val);
+}
+
+/*
+ * Function to control flank or level triggered GPIO pin
+ * @nr - pin
+ * @ val - 1: flank, 0: level
+ *
+ */
+static void timbgpio_gpio_flnk_lvl_ctrl(struct gpio_chip *gpio,
+						unsigned nr, int val)
+{
+	timbgpio_configure(gpio, nr, TGPIOFLK, val);
+}
+EXPORT_SYMBOL(timbgpio_gpio_flnk_lvl_ctrl);
+
+/*
+ * Enable or disable interrupt
+ *
+ */
+static void timbgpio_gpio_int_ctrl(struct gpio_chip *gpio,
+					unsigned nr, int val)
+{
+	timbgpio_configure(gpio, nr, TGPIOINT, val);
+}
+EXPORT_SYMBOL(timbgpio_gpio_int_ctrl);
+
+/*
+ * @val - 1: Asserted high or on positive flank, 0: Asserted low or on negative flank
+ *
+ */
+static void timbgpio_gpio_lvl_ctrl(struct gpio_chip *gpio,
+					unsigned nr, int val)
+{
+	timbgpio_configure(gpio, nr, TGPIOLVL, val);
+}
+EXPORT_SYMBOL(timbgpio_gpio_lvl_ctrl);
+
+static void timbgpio_gpio_int_clr(struct gpio_chip *gpio,
+					unsigned nr, int val)
+{
+	timbgpio_configure(gpio, nr, TGPIOINT_CLR, val);
+}
+EXPORT_SYMBOL(timbgpio_gpio_int_clr);
+
+
+static irqreturn_t timbgpio_handleinterrupt(int irq, void *devid)
+{
+	struct timbgpio *tgpio = (struct timbgpio *)devid;
+
+	iowrite32(0xffffffff, tgpio->membase + TGPIOINT_CLR);
+
+	return IRQ_HANDLED;
+}
+
+static int timbgpio_probe(struct platform_device *dev)
+{
+	int err, irq;
+	struct gpio_chip *gc;
+	struct timbgpio *tgpio;
+	struct resource *iomem, *rscr;
+
+	iomem = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!iomem) {
+		err = -EINVAL;
+		goto err_mem;
+	}
+
+	tgpio = kzalloc(sizeof(*tgpio), GFP_KERNEL);
+	if (!tgpio) {
+		err = -EINVAL;
+		goto err_mem;
+	}
+
+	mutex_init(&tgpio->lock);
+
+	rscr = &tgpio->rscr;
+	rscr->name = "timb-gpio";
+	rscr->start = iomem->start;
+	rscr->end = iomem->end;
+	rscr->flags = IORESOURCE_MEM;
+
+	err = request_resource(iomem, rscr);
+	if (err)
+		goto err_request;
+
+	tgpio->membase = ioremap(rscr->start, resource_size(rscr));
+	if (!tgpio->membase) {
+		err = -ENOMEM;
+		goto err_ioremap;
+	}
+
+	gc = &tgpio->gpio;
+
+	gc->label = "timbgpio";
+	gc->owner = THIS_MODULE;
+	gc->direction_input = timbgpio_gpio_direction_input;
+	gc->get = timbgpio_gpio_get;
+	gc->direction_output = timbgpio_gpio_direction_output;
+	gc->set = timbgpio_gpio_set;
+	gc->dbg_show = NULL;
+	gc->base = 0;
+	gc->ngpio = TIMB_NR_GPIOS;
+	gc->can_sleep = 0;
+
+	err = gpiochip_add(gc);
+	if (err)
+		goto err_chipadd;
+
+	platform_set_drvdata(dev, tgpio);
+
+	/* register interrupt */
+	irq = platform_get_irq(dev, 0);
+	if (irq < 0)
+		goto err_get_irq;
+
+	/* clear pending interrupts */
+	iowrite32(0xffffffff, tgpio->membase + TGPIOINT_CLR);
+	iowrite32(0x0, tgpio->membase + TGPIOINT);
+
+	/* request IRQ */
+	err = request_irq(irq, timbgpio_handleinterrupt, IRQF_SHARED,
+			  "timb-gpio", tgpio);
+	if (err) {
+		printk(KERN_ERR "timbgpio: Failed to request IRQ\n");
+		goto err_get_irq;
+	}
+
+	return err;
+
+err_get_irq:
+	err = gpiochip_remove(&tgpio->gpio);
+	if (err)
+		printk(KERN_ERR "timbgpio: failed to remove gpio_chip\n");
+err_chipadd:
+	iounmap(tgpio->membase);
+err_ioremap:
+	release_resource(&tgpio->rscr);
+err_request:
+	kfree(tgpio);
+err_mem:
+	printk(KERN_ERR "timberdale: Failed to register GPIOs: %d\n", err);
+
+	return err;
+}
+
+static int timbgpio_remove(struct platform_device *dev)
+{
+	int err;
+	struct timbgpio *tgpio = platform_get_drvdata(dev);
+
+	/* disable interrupts */
+	iowrite32(0x0, tgpio->membase + TGPIOINT);
+
+	free_irq(platform_get_irq(dev, 0), tgpio);
+	err = gpiochip_remove(&tgpio->gpio);
+	if (err)
+		printk(KERN_ERR "timbgpio: failed to remove gpio_chip\n");
+
+	iounmap(tgpio->membase);
+	release_resource(&tgpio->rscr);
+	kfree(tgpio);
+
+	return 0;
+}
+
+static struct platform_driver timbgpio_platform_driver = {
+	.driver = {
+		.name	= "timb-gpio",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= timbgpio_probe,
+	.remove		= timbgpio_remove,
+};
+
+/*--------------------------------------------------------------------------*/
+
+static int __init timbgpio_init(void)
+{
+	return platform_driver_register(&timbgpio_platform_driver);
+}
+
+static void __exit timbgpio_exit(void)
+{
+	platform_driver_unregister(&timbgpio_platform_driver);
+}
+
+module_init(timbgpio_init);
+module_exit(timbgpio_exit);
+
+MODULE_DESCRIPTION("Timberdale GPIO driver");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Mocean Laboratories");
+MODULE_ALIAS("platform:timb-gpio");
+
diff -puN /dev/null drivers/gpio/timbgpio.h
--- /dev/null
+++ a/drivers/gpio/timbgpio.h
@@ -0,0 +1,48 @@
+/*
+ * timbgpio.h timberdale FPGA GPIO driver defines
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+/* Supports:
+ * Timberdale FPGA GPIO
+ */
+
+#ifndef _TIMBGPIO_H_
+#define _TIMBGPIO_H_
+
+#include <linux/mutex.h>
+#include <linux/gpio.h>
+
+#define TIMB_NR_GPIOS 16
+
+#define TGPIOVAL 	0
+#define TGPIODIR 	0x04
+#define TGPIOINT 	0x08
+#define TGPIOINT_STATUS	0x0c
+#define TGPIOINT_PENDING 0x10
+#define TGPIOINT_CLR	0x14
+#define TGPIOFLK 	0x18
+#define TGPIOLVL 	0x1c
+
+struct timbgpio {
+	void __iomem		*membase;
+	struct resource		rscr;
+	struct mutex		lock; /* mutual exclusion */
+	struct pci_dev		*pdev;
+	struct gpio_chip	gpio;
+};
+
+#endif
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean-labs.com are

gpio-add-timbgpio.patch

