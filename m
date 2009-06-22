From: akpm@linux-foundation.org
Subject: [merged] gpio-driver-for-primecell-pl061-gpio-controller.patch removed from -mm tree
Date: Mon, 22 Jun 2009 09:59:58 -0700
Message-ID: <200906221659.n5MGxwCf009218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbZFVRAw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:00:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baruch@tkos.co.il, david-b@pacbell.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     gpio: driver for PrimeCell PL061 GPIO controller
has been removed from the -mm tree.  Its filename was
     gpio-driver-for-primecell-pl061-gpio-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: driver for PrimeCell PL061 GPIO controller
From: Baruch Siach <baruch@tkos.co.il>

This is a driver for the ARM PrimeCell PL061 GPIO AMBA peripheral.  The
driver is implemented using the gpiolib framework.

This driver also includes support for the use of the PL061 as an interrupt
controller (secondary).

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: David Brownell <david-b@pacbell.net>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig       |    6 
 drivers/gpio/Makefile      |    1 
 drivers/gpio/pl061.c       |  341 +++++++++++++++++++++++++++++++++++
 include/linux/amba/pl061.h |   15 +
 4 files changed, 363 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-driver-for-primecell-pl061-gpio-controller drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-driver-for-primecell-pl061-gpio-controller
+++ a/drivers/gpio/Kconfig
@@ -67,6 +67,12 @@ config GPIO_SYSFS
 
 comment "Memory mapped GPIO expanders:"
 
+config GPIO_PL061
+	bool "PrimeCell PL061 GPIO support"
+	depends on ARM_AMBA
+	help
+	  Say yes here to support the PrimeCell PL061 GPIO device
+
 config GPIO_XILINX
 	bool "Xilinx GPIO support"
 	depends on PPC_OF || MICROBLAZE
diff -puN drivers/gpio/Makefile~gpio-driver-for-primecell-pl061-gpio-controller drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-driver-for-primecell-pl061-gpio-controller
+++ a/drivers/gpio/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
+obj-$(CONFIG_GPIO_PL061)	+= pl061.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
diff -puN /dev/null drivers/gpio/pl061.c
--- /dev/null
+++ a/drivers/gpio/pl061.c
@@ -0,0 +1,341 @@
+/*
+ *  linux/drivers/gpio/pl061.c
+ *
+ *  Copyright (C) 2008, 2009 Provigent Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Driver for the ARM PrimeCell(tm) General Purpose Input/Output (PL061)
+ *
+ * Data sheet: ARM DDI 0190B, September 2000
+ */
+#include <linux/spinlock.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/irq.h>
+#include <linux/bitops.h>
+#include <linux/workqueue.h>
+#include <linux/gpio.h>
+#include <linux/device.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/pl061.h>
+
+#define GPIODIR 0x400
+#define GPIOIS  0x404
+#define GPIOIBE 0x408
+#define GPIOIEV 0x40C
+#define GPIOIE  0x410
+#define GPIORIS 0x414
+#define GPIOMIS 0x418
+#define GPIOIC  0x41C
+
+#define PL061_GPIO_NR	8
+
+struct pl061_gpio {
+	/* We use a list of pl061_gpio structs for each trigger IRQ in the main
+	 * interrupts controller of the system. We need this to support systems
+	 * in which more that one PL061s are connected to the same IRQ. The ISR
+	 * interates through this list to find the source of the interrupt.
+	 */
+	struct list_head	list;
+
+	/* Each of the two spinlocks protects a different set of hardware
+	 * regiters and data structurs. This decouples the code of the IRQ from
+	 * the GPIO code. This also makes the case of a GPIO routine call from
+	 * the IRQ code simpler.
+	 */
+	spinlock_t		lock;		/* GPIO registers */
+	spinlock_t		irq_lock;	/* IRQ registers */
+
+	void __iomem		*base;
+	unsigned		irq_base;
+	struct gpio_chip	gc;
+};
+
+static int pl061_direction_input(struct gpio_chip *gc, unsigned offset)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+	unsigned long flags;
+	unsigned char gpiodir;
+
+	if (offset >= gc->ngpio)
+		return -EINVAL;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	gpiodir = readb(chip->base + GPIODIR);
+	gpiodir &= ~(1 << offset);
+	writeb(gpiodir, chip->base + GPIODIR);
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return 0;
+}
+
+static int pl061_direction_output(struct gpio_chip *gc, unsigned offset,
+		int value)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+	unsigned long flags;
+	unsigned char gpiodir;
+
+	if (offset >= gc->ngpio)
+		return -EINVAL;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	writeb(!!value << offset, chip->base + (1 << (offset + 2)));
+	gpiodir = readb(chip->base + GPIODIR);
+	gpiodir |= 1 << offset;
+	writeb(gpiodir, chip->base + GPIODIR);
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return 0;
+}
+
+static int pl061_get_value(struct gpio_chip *gc, unsigned offset)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+
+	return !!readb(chip->base + (1 << (offset + 2)));
+}
+
+static void pl061_set_value(struct gpio_chip *gc, unsigned offset, int value)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+
+	writeb(!!value << offset, chip->base + (1 << (offset + 2)));
+}
+
+/*
+ * PL061 GPIO IRQ
+ */
+static void pl061_irq_disable(unsigned irq)
+{
+	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	int offset = irq - chip->irq_base;
+	unsigned long flags;
+	u8 gpioie;
+
+	spin_lock_irqsave(&chip->irq_lock, flags);
+	gpioie = readb(chip->base + GPIOIE);
+	gpioie &= ~(1 << offset);
+	writeb(gpioie, chip->base + GPIOIE);
+	spin_unlock_irqrestore(&chip->irq_lock, flags);
+}
+
+static void pl061_irq_enable(unsigned irq)
+{
+	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	int offset = irq - chip->irq_base;
+	unsigned long flags;
+	u8 gpioie;
+
+	spin_lock_irqsave(&chip->irq_lock, flags);
+	gpioie = readb(chip->base + GPIOIE);
+	gpioie |= 1 << offset;
+	writeb(gpioie, chip->base + GPIOIE);
+	spin_unlock_irqrestore(&chip->irq_lock, flags);
+}
+
+static int pl061_irq_type(unsigned irq, unsigned trigger)
+{
+	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	int offset = irq - chip->irq_base;
+	unsigned long flags;
+	u8 gpiois, gpioibe, gpioiev;
+
+	if (offset < 0 || offset > PL061_GPIO_NR)
+		return -EINVAL;
+
+	spin_lock_irqsave(&chip->irq_lock, flags);
+
+	gpioiev = readb(chip->base + GPIOIEV);
+
+	gpiois = readb(chip->base + GPIOIS);
+	if (trigger & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
+		gpiois |= 1 << offset;
+		if (trigger & IRQ_TYPE_LEVEL_HIGH)
+			gpioiev |= 1 << offset;
+		else
+			gpioiev &= ~(1 << offset);
+	} else
+		gpiois &= ~(1 << offset);
+	writeb(gpiois, chip->base + GPIOIS);
+
+	gpioibe = readb(chip->base + GPIOIBE);
+	if ((trigger & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH)
+		gpioibe |= 1 << offset;
+	else {
+		gpioibe &= ~(1 << offset);
+		if (trigger & IRQ_TYPE_EDGE_RISING)
+			gpioiev |= 1 << offset;
+		else
+			gpioiev &= ~(1 << offset);
+	}
+	writeb(gpioibe, chip->base + GPIOIBE);
+
+	writeb(gpioiev, chip->base + GPIOIEV);
+
+	spin_unlock_irqrestore(&chip->irq_lock, flags);
+
+	return 0;
+}
+
+static struct irq_chip pl061_irqchip = {
+	.name		= "GPIO",
+	.enable		= pl061_irq_enable,
+	.disable	= pl061_irq_disable,
+	.set_type	= pl061_irq_type,
+};
+
+static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	struct list_head *chip_list = get_irq_chip_data(irq);
+	struct list_head *ptr;
+	struct pl061_gpio *chip;
+
+	desc->chip->ack(irq);
+	list_for_each(ptr, chip_list) {
+		unsigned long pending;
+		int gpio;
+
+		chip = list_entry(ptr, struct pl061_gpio, list);
+		pending = readb(chip->base + GPIOMIS);
+		writeb(pending, chip->base + GPIOIC);
+
+		if (pending == 0)
+			continue;
+
+		for_each_bit(gpio, &pending, PL061_GPIO_NR)
+			generic_handle_irq(gpio_to_irq(gpio));
+	}
+	desc->chip->unmask(irq);
+}
+
+static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
+{
+	struct pl061_platform_data *pdata;
+	struct pl061_gpio *chip;
+	struct list_head *chip_list;
+	int ret, irq, i;
+	static unsigned long init_irq[BITS_TO_LONGS(NR_IRQS)];
+
+	pdata = dev->dev.platform_data;
+	if (pdata == NULL)
+		return -ENODEV;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (chip == NULL)
+		return -ENOMEM;
+
+	if (!request_mem_region(dev->res.start,
+				resource_size(&dev->res), "pl061")) {
+		ret = -EBUSY;
+		goto free_mem;
+	}
+
+	chip->base = ioremap(dev->res.start, resource_size(&dev->res));
+	if (chip->base == NULL) {
+		ret = -ENOMEM;
+		goto release_region;
+	}
+
+	spin_lock_init(&chip->lock);
+	spin_lock_init(&chip->irq_lock);
+	INIT_LIST_HEAD(&chip->list);
+
+	chip->gc.direction_input = pl061_direction_input;
+	chip->gc.direction_output = pl061_direction_output;
+	chip->gc.get = pl061_get_value;
+	chip->gc.set = pl061_set_value;
+	chip->gc.base = pdata->gpio_base;
+	chip->gc.ngpio = PL061_GPIO_NR;
+	chip->gc.label = dev_name(&dev->dev);
+	chip->gc.dev = &dev->dev;
+	chip->gc.owner = THIS_MODULE;
+
+	chip->irq_base = pdata->irq_base;
+
+	ret = gpiochip_add(&chip->gc);
+	if (ret)
+		goto iounmap;
+
+	/*
+	 * irq_chip support
+	 */
+
+	if (chip->irq_base == (unsigned) -1)
+		return 0;
+
+	writeb(0, chip->base + GPIOIE); /* disable irqs */
+	irq = dev->irq[0];
+	if (irq < 0) {
+		ret = -ENODEV;
+		goto iounmap;
+	}
+	set_irq_chained_handler(irq, pl061_irq_handler);
+	if (!test_and_set_bit(irq, init_irq)) { /* list initialized? */
+		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
+		if (chip_list == NULL) {
+			ret = -ENOMEM;
+			goto iounmap;
+		}
+		INIT_LIST_HEAD(chip_list);
+		set_irq_chip_data(irq, chip_list);
+	} else
+		chip_list = get_irq_chip_data(irq);
+	list_add(&chip->list, chip_list);
+
+	for (i = 0; i < PL061_GPIO_NR; i++) {
+		if (pdata->directions & (1 << i))
+			pl061_direction_output(&chip->gc, i,
+					pdata->values & (1 << i));
+		else
+			pl061_direction_input(&chip->gc, i);
+
+		set_irq_chip(i+chip->irq_base, &pl061_irqchip);
+		set_irq_handler(i+chip->irq_base, handle_simple_irq);
+		set_irq_flags(i+chip->irq_base, IRQF_VALID);
+		set_irq_chip_data(i+chip->irq_base, chip);
+	}
+
+	return 0;
+
+iounmap:
+	iounmap(chip->base);
+release_region:
+	release_mem_region(dev->res.start, resource_size(&dev->res));
+free_mem:
+	kfree(chip);
+
+	return ret;
+}
+
+static struct amba_id pl061_ids[] __initdata = {
+	{
+		.id	= 0x00041061,
+		.mask	= 0x000fffff,
+	},
+	{ 0, 0 },
+};
+
+static struct amba_driver pl061_gpio_driver = {
+	.drv = {
+		.name	= "pl061_gpio",
+	},
+	.id_table	= pl061_ids,
+	.probe		= pl061_probe,
+};
+
+static int __init pl061_gpio_init(void)
+{
+	return amba_driver_register(&pl061_gpio_driver);
+}
+subsys_initcall(pl061_gpio_init);
+
+MODULE_AUTHOR("Baruch Siach <baruch@tkos.co.il>");
+MODULE_DESCRIPTION("PL061 GPIO driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/amba/pl061.h
--- /dev/null
+++ a/include/linux/amba/pl061.h
@@ -0,0 +1,15 @@
+/* platform data for the PL061 GPIO driver */
+
+struct pl061_platform_data {
+	/* number of the first GPIO */
+	unsigned	gpio_base;
+
+	/* number of the first IRQ.
+	 * If the IRQ functionality in not desired this must be set to
+	 * (unsigned) -1.
+	 */
+	unsigned	irq_base;
+
+	u8		directions;	/* startup directions, 1: out, 0: in */
+	u8		values;		/* startup values */
+};
_

Patches currently in -mm which might be from baruch@tkos.co.il are

origin.patch

