From: akpm@linux-foundation.org
Subject: [merged] gpio-add-gpio-driver-for-the-timberdale-fpga.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:19 -0800
Message-ID: <200912162035.nBGKZJ9B013091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935412AbZLPUgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors@mocean-labs.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpio: add GPIO driver for the Timberdale FPGA
has been removed from the -mm tree.  Its filename was
     gpio-add-gpio-driver-for-the-timberdale-fpga.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpio: add GPIO driver for the Timberdale FPGA
=46rom: Richard R=F6jfors <richard.rojfors@mocean-labs.com>

A GPIO driver for the Timberdale FPGA found on the Intel Atom board
Russellville.

The GPIO driver also has an IRQ-chip to support interrupts on the pins.

Signed-off-by: Richard R=F6jfors <richard.rojfors@mocean-labs.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig      |    6=20
 drivers/gpio/Makefile     |    1=20
 drivers/gpio/timbgpio.c   |  342 ++++++++++++++++++++++++++++++++++++
 include/linux/timb_gpio.h |   37 +++
 4 files changed, 386 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-add-gpio-driver-for-the-timberdale-=
fpga drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-add-gpio-driver-for-the-timberdale-fpga
+++ a/drivers/gpio/Kconfig
@@ -206,6 +206,12 @@ config GPIO_LANGWELL
 	help
 	  Say Y here to support Intel Moorestown platform GPIO.
=20
+config GPIO_TIMBERDALE
+	bool "Support for timberdale GPIO IP"
+	depends on MFD_TIMBERDALE && GPIOLIB && HAS_IOMEM
+	---help---
+	Add support for the GPIO IP in the timberdale FPGA.
+
 comment "SPI GPIO expanders:"
=20
 config GPIO_MAX7301
diff -puN drivers/gpio/Makefile~gpio-add-gpio-driver-for-the-timberdale=
-fpga drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-add-gpio-driver-for-the-timberdale-fpg=
a
+++ a/drivers/gpio/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_GPIO_MCP23S08)	+=3D mcp23s08.
 obj-$(CONFIG_GPIO_PCA953X)	+=3D pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+=3D pcf857x.o
 obj-$(CONFIG_GPIO_PL061)	+=3D pl061.o
+obj-$(CONFIG_GPIO_TIMBERDALE)	+=3D timbgpio.o
 obj-$(CONFIG_GPIO_TWL4030)	+=3D twl4030-gpio.o
 obj-$(CONFIG_GPIO_UCB1400)	+=3D ucb1400_gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+=3D xilinx_gpio.o
diff -puN /dev/null drivers/gpio/timbgpio.c
--- /dev/null
+++ a/drivers/gpio/timbgpio.c
@@ -0,0 +1,342 @@
+/*
+ * timbgpio.c timberdale FPGA GPIO driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
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
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/timb_gpio.h>
+#include <linux/interrupt.h>
+
+#define DRIVER_NAME "timb-gpio"
+
+#define TGPIOVAL	0x00
+#define TGPIODIR	0x04
+#define TGPIO_IER	0x08
+#define TGPIO_ISR	0x0c
+#define TGPIO_IPR	0x10
+#define TGPIO_ICR	0x14
+#define TGPIO_FLR	0x18
+#define TGPIO_LVR	0x1c
+
+struct timbgpio {
+	void __iomem		*membase;
+	spinlock_t		lock; /* mutual exclusion */
+	struct gpio_chip	gpio;
+	int			irq_base;
+};
+
+static int timbgpio_update_bit(struct gpio_chip *gpio, unsigned index,
+	unsigned offset, bool enabled)
+{
+	struct timbgpio *tgpio =3D container_of(gpio, struct timbgpio, gpio);
+	u32 reg;
+
+	spin_lock(&tgpio->lock);
+	reg =3D ioread32(tgpio->membase + offset);
+
+	if (enabled)
+		reg |=3D (1 << index);
+	else
+		reg &=3D ~(1 << index);
+
+	iowrite32(reg, tgpio->membase + offset);
+	spin_unlock(&tgpio->lock);
+
+	return 0;
+}
+
+static int timbgpio_gpio_direction_input(struct gpio_chip *gpio, unsig=
ned nr)
+{
+	return timbgpio_update_bit(gpio, nr, TGPIODIR, true);
+}
+
+static int timbgpio_gpio_get(struct gpio_chip *gpio, unsigned nr)
+{
+	struct timbgpio *tgpio =3D container_of(gpio, struct timbgpio, gpio);
+	u32 value;
+
+	value =3D ioread32(tgpio->membase + TGPIOVAL);
+	return (value & (1 << nr)) ? 1 : 0;
+}
+
+static int timbgpio_gpio_direction_output(struct gpio_chip *gpio,
+						unsigned nr, int val)
+{
+	return timbgpio_update_bit(gpio, nr, TGPIODIR, false);
+}
+
+static void timbgpio_gpio_set(struct gpio_chip *gpio,
+				unsigned nr, int val)
+{
+	timbgpio_update_bit(gpio, nr, TGPIOVAL, val !=3D 0);
+}
+
+static int timbgpio_to_irq(struct gpio_chip *gpio, unsigned offset)
+{
+	struct timbgpio *tgpio =3D container_of(gpio, struct timbgpio, gpio);
+
+	if (tgpio->irq_base <=3D 0)
+		return -EINVAL;
+
+	return tgpio->irq_base + offset;
+}
+
+/*
+ * GPIO IRQ
+ */
+static void timbgpio_irq_disable(unsigned irq)
+{
+	struct timbgpio *tgpio =3D get_irq_chip_data(irq);
+	int offset =3D irq - tgpio->irq_base;
+
+	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 0);
+}
+
+static void timbgpio_irq_enable(unsigned irq)
+{
+	struct timbgpio *tgpio =3D get_irq_chip_data(irq);
+	int offset =3D irq - tgpio->irq_base;
+
+	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 1);
+}
+
+static int timbgpio_irq_type(unsigned irq, unsigned trigger)
+{
+	struct timbgpio *tgpio =3D get_irq_chip_data(irq);
+	int offset =3D irq - tgpio->irq_base;
+	unsigned long flags;
+	u32 lvr, flr;
+
+	if (offset < 0 || offset > tgpio->gpio.ngpio)
+		return -EINVAL;
+
+	spin_lock_irqsave(&tgpio->lock, flags);
+
+	lvr =3D ioread32(tgpio->membase + TGPIO_LVR);
+	flr =3D ioread32(tgpio->membase + TGPIO_FLR);
+
+	if (trigger & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
+		flr &=3D ~(1 << offset);
+		if (trigger & IRQ_TYPE_LEVEL_HIGH)
+			lvr |=3D 1 << offset;
+		else
+			lvr &=3D ~(1 << offset);
+	}
+
+	if ((trigger & IRQ_TYPE_EDGE_BOTH) =3D=3D IRQ_TYPE_EDGE_BOTH)
+		return -EINVAL;
+	else {
+		flr |=3D 1 << offset;
+		/* opposite compared to the datasheet, but it mirrors the
+		 * reality
+		 */
+		if (trigger & IRQ_TYPE_EDGE_FALLING)
+			lvr |=3D 1 << offset;
+		else
+			lvr &=3D ~(1 << offset);
+	}
+
+	iowrite32(lvr, tgpio->membase + TGPIO_LVR);
+	iowrite32(flr, tgpio->membase + TGPIO_FLR);
+	iowrite32(1 << offset, tgpio->membase + TGPIO_ICR);
+	spin_unlock_irqrestore(&tgpio->lock, flags);
+
+	return 0;
+}
+
+static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
+{
+	struct timbgpio *tgpio =3D get_irq_data(irq);
+	unsigned long ipr;
+	int offset;
+
+	desc->chip->ack(irq);
+	ipr =3D ioread32(tgpio->membase + TGPIO_IPR);
+	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
+
+	for_each_bit(offset, &ipr, tgpio->gpio.ngpio)
+		generic_handle_irq(timbgpio_to_irq(&tgpio->gpio, offset));
+}
+
+static struct irq_chip timbgpio_irqchip =3D {
+	.name		=3D "GPIO",
+	.enable		=3D timbgpio_irq_enable,
+	.disable	=3D timbgpio_irq_disable,
+	.set_type	=3D timbgpio_irq_type,
+};
+
+static int __devinit timbgpio_probe(struct platform_device *pdev)
+{
+	int err, i;
+	struct gpio_chip *gc;
+	struct timbgpio *tgpio;
+	struct resource *iomem;
+	struct timbgpio_platform_data *pdata =3D pdev->dev.platform_data;
+	int irq =3D platform_get_irq(pdev, 0);
+
+	if (!pdata || pdata->nr_pins > 32) {
+		err =3D -EINVAL;
+		goto err_mem;
+	}
+
+	iomem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iomem) {
+		err =3D -EINVAL;
+		goto err_mem;
+	}
+
+	tgpio =3D kzalloc(sizeof(*tgpio), GFP_KERNEL);
+	if (!tgpio) {
+		err =3D -EINVAL;
+		goto err_mem;
+	}
+	tgpio->irq_base =3D pdata->irq_base;
+
+	spin_lock_init(&tgpio->lock);
+
+	if (!request_mem_region(iomem->start, resource_size(iomem),
+		DRIVER_NAME)) {
+		err =3D -EBUSY;
+		goto err_request;
+	}
+
+	tgpio->membase =3D ioremap(iomem->start, resource_size(iomem));
+	if (!tgpio->membase) {
+		err =3D -ENOMEM;
+		goto err_ioremap;
+	}
+
+	gc =3D &tgpio->gpio;
+
+	gc->label =3D dev_name(&pdev->dev);
+	gc->owner =3D THIS_MODULE;
+	gc->dev =3D &pdev->dev;
+	gc->direction_input =3D timbgpio_gpio_direction_input;
+	gc->get =3D timbgpio_gpio_get;
+	gc->direction_output =3D timbgpio_gpio_direction_output;
+	gc->set =3D timbgpio_gpio_set;
+	gc->to_irq =3D (irq >=3D 0 && tgpio->irq_base > 0) ? timbgpio_to_irq =
: NULL;
+	gc->dbg_show =3D NULL;
+	gc->base =3D pdata->gpio_base;
+	gc->ngpio =3D pdata->nr_pins;
+	gc->can_sleep =3D 0;
+
+	err =3D gpiochip_add(gc);
+	if (err)
+		goto err_chipadd;
+
+	platform_set_drvdata(pdev, tgpio);
+
+	/* make sure to disable interrupts */
+	iowrite32(0x0, tgpio->membase + TGPIO_IER);
+
+	if (irq < 0 || tgpio->irq_base <=3D 0)
+		return 0;
+
+	for (i =3D 0; i < pdata->nr_pins; i++) {
+		set_irq_chip_and_handler_name(tgpio->irq_base + i,
+			&timbgpio_irqchip, handle_simple_irq, "mux");
+		set_irq_chip_data(tgpio->irq_base + i, tgpio);
+#ifdef CONFIG_ARM
+		set_irq_flags(tgpio->irq_base + i, IRQF_VALID | IRQF_PROBE);
+#endif
+	}
+
+	set_irq_data(irq, tgpio);
+	set_irq_chained_handler(irq, timbgpio_irq);
+
+	return 0;
+
+err_chipadd:
+	iounmap(tgpio->membase);
+err_ioremap:
+	release_mem_region(iomem->start, resource_size(iomem));
+err_request:
+	kfree(tgpio);
+err_mem:
+	printk(KERN_ERR DRIVER_NAME": Failed to register GPIOs: %d\n", err);
+
+	return err;
+}
+
+static int __devexit timbgpio_remove(struct platform_device *pdev)
+{
+	int err;
+	struct timbgpio_platform_data *pdata =3D pdev->dev.platform_data;
+	struct timbgpio *tgpio =3D platform_get_drvdata(pdev);
+	struct resource *iomem =3D platform_get_resource(pdev, IORESOURCE_MEM=
, 0);
+	int irq =3D platform_get_irq(pdev, 0);
+
+	if (irq >=3D 0 && tgpio->irq_base > 0) {
+		int i;
+		for (i =3D 0; i < pdata->nr_pins; i++) {
+			set_irq_chip(tgpio->irq_base + i, NULL);
+			set_irq_chip_data(tgpio->irq_base + i, NULL);
+		}
+
+		set_irq_handler(irq, NULL);
+		set_irq_data(irq, NULL);
+	}
+
+	err =3D gpiochip_remove(&tgpio->gpio);
+	if (err)
+		printk(KERN_ERR DRIVER_NAME": failed to remove gpio_chip\n");
+
+	iounmap(tgpio->membase);
+	release_mem_region(iomem->start, resource_size(iomem));
+	kfree(tgpio);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver timbgpio_platform_driver =3D {
+	.driver =3D {
+		.name	=3D DRIVER_NAME,
+		.owner	=3D THIS_MODULE,
+	},
+	.probe		=3D timbgpio_probe,
+	.remove		=3D timbgpio_remove,
+};
+
+/*--------------------------------------------------------------------=
------*/
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
+MODULE_ALIAS("platform:"DRIVER_NAME);
+
diff -puN /dev/null include/linux/timb_gpio.h
--- /dev/null
+++ a/include/linux/timb_gpio.h
@@ -0,0 +1,37 @@
+/*
+ * timb_gpio.h timberdale FPGA GPIO driver, platform data definition
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
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
+#ifndef _LINUX_TIMB_GPIO_H
+#define _LINUX_TIMB_GPIO_H
+
+/**
+ * struct timbgpio_platform_data - Platform data of the Timberdale GPI=
O driver
+ * @gpio_base		The number of the first GPIO pin, set to -1 for
+ *			dynamic number allocation.
+ * @nr_pins		Number of pins that is supported by the hardware (1-32)
+ * @irq_base		If IRQ is supported by the hardware, this is the base
+ *			number of IRQ:s. One IRQ per pin will be used. Set to
+ *			-1 if IRQ:s is not supported.
+ */
+struct timbgpio_platform_data {
+	int gpio_base;
+	int nr_pins;
+	int irq_base;
+};
+
+#endif
_

Patches currently in -mm which might be from richard.rojfors@mocean-lab=
s.com are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
