From: akpm@linux-foundation.org
Subject: + gpio-timberdale-add-timbgpio.patch added to -mm tree
Date: Tue, 09 Jun 2009 16:10:25 -0700
Message-ID: <200906092310.n59NAPXo001578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbZFIXMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 19:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors.ext@mocean-labs.com, david-b@pacbell.net


The patch titled
     gpio: timberdale: add timbgpio
has been added to the -mm tree.  Its filename is
     gpio-timberdale-add-timbgpio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpio: timberdale: add timbgpio
=46rom: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>

Supplied is a GPIO driver for the Timberdale FPGA found on the
Intel Atom board Russellville.

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig    |    6=20
 drivers/gpio/Makefile   |    1=20
 drivers/gpio/timbgpio.c |  247 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 254 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-timberdale-add-timbgpio drivers/gpi=
o/Kconfig
--- a/drivers/gpio/Kconfig~gpio-timberdale-add-timbgpio
+++ a/drivers/gpio/Kconfig
@@ -167,6 +167,12 @@ config GPIO_BT8XX
=20
 	  If unsure, say N.
=20
+config GPIO_TIMBERDALE
+	tristate "Support for timberdale GPIO"
+	depends on MFD_TIMBERDALE && GPIOLIB
+	---help---
+	Add support for GPIO usage of some pins of the timberdale FPGA.
+
 comment "SPI GPIO expanders:"
=20
 config GPIO_MAX7301
diff -puN drivers/gpio/Makefile~gpio-timberdale-add-timbgpio drivers/gp=
io/Makefile
--- a/drivers/gpio/Makefile~gpio-timberdale-add-timbgpio
+++ a/drivers/gpio/Makefile
@@ -13,5 +13,6 @@ obj-$(CONFIG_GPIO_PL061)	+=3D pl061.o
 obj-$(CONFIG_GPIO_TWL4030)	+=3D twl4030-gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+=3D xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+=3D bt8xxgpio.o
+obj-$(CONFIG_GPIO_TIMBERDALE)	+=3D timbgpio.o
 obj-$(CONFIG_GPIO_MC33880)	+=3D mc33880.o
=20
diff -puN drivers/gpio/timbgpio.c~gpio-timberdale-add-timbgpio drivers/=
gpio/timbgpio.c
--- a/drivers/gpio/timbgpio.c~gpio-timberdale-add-timbgpio
+++ a/drivers/gpio/timbgpio.c
@@ -0,0 +1,247 @@
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
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+
+#define DRIVER_NAME "timb-gpio"
+
+#define TIMB_NR_GPIOS		16
+
+#define TGPIOVAL		0
+#define TGPIODIR		0x04
+#define TGPIOINT		0x08
+#define TGPIOINT_STATUS		0x0c
+#define TGPIOINT_PENDING	0x10
+#define TGPIOINT_CLR		0x14
+#define TGPIOFLK		0x18
+#define TGPIOLVL		0x1c
+
+struct timbgpio {
+	void __iomem		*membase;
+	struct mutex		lock; /* mutual exclusion */
+	struct pci_dev		*pdev;
+	struct gpio_chip	gpio;
+};
+
+static u32 timbgpio_configure(struct gpio_chip *gpio, unsigned nr,
+						unsigned off, unsigned val)
+{
+	struct timbgpio *tgpio =3D container_of(gpio, struct timbgpio, gpio);
+
+	u32 config, oldconfig, wconfig;
+
+	mutex_lock(&tgpio->lock);
+	config =3D ioread32(tgpio->membase + off);
+	oldconfig =3D config;
+
+	if (val)
+		config |=3D (1 << nr);
+	else
+		config &=3D ~(1 << nr);
+
+	iowrite32(config, tgpio->membase + off);
+	wconfig =3D ioread32(tgpio->membase + off);
+	mutex_unlock(&tgpio->lock);
+
+	return oldconfig;
+}
+
+static int timbgpio_gpio_direction_input(struct gpio_chip *gpio, unsig=
ned nr)
+{
+	timbgpio_configure(gpio, nr, TGPIODIR, 1);
+	return 0;
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
+static irqreturn_t timbgpio_handleinterrupt(int irq, void *devid)
+{
+	struct timbgpio *tgpio =3D (struct timbgpio *)devid;
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
+	struct resource *iomem;
+
+	iomem =3D platform_get_resource(dev, IORESOURCE_MEM, 0);
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
+
+	mutex_init(&tgpio->lock);
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
+	gc->label =3D DRIVER_NAME;
+	gc->owner =3D THIS_MODULE;
+	gc->direction_input =3D timbgpio_gpio_direction_input;
+	gc->get =3D timbgpio_gpio_get;
+	gc->direction_output =3D timbgpio_gpio_direction_output;
+	gc->set =3D timbgpio_gpio_set;
+	gc->dbg_show =3D NULL;
+	gc->base =3D 0;
+	gc->ngpio =3D TIMB_NR_GPIOS;
+	gc->can_sleep =3D 0;
+
+	err =3D gpiochip_add(gc);
+	if (err)
+		goto err_chipadd;
+
+	platform_set_drvdata(dev, tgpio);
+
+	/* register interrupt */
+	irq =3D platform_get_irq(dev, 0);
+	if (irq < 0)
+		goto err_get_irq;
+
+	/* clear pending interrupts */
+	iowrite32(0xffffffff, tgpio->membase + TGPIOINT_CLR);
+	iowrite32(0x0, tgpio->membase + TGPIOINT);
+
+	/* request IRQ */
+	err =3D request_irq(irq, timbgpio_handleinterrupt, IRQF_SHARED,
+		DRIVER_NAME, tgpio);
+	if (err) {
+		printk(KERN_ERR DRIVER_NAME": Failed to request IRQ\n");
+		goto err_get_irq;
+	}
+
+	return err;
+
+err_get_irq:
+	err =3D gpiochip_remove(&tgpio->gpio);
+	if (err)
+		printk(KERN_ERR DRIVER_NAME": failed to remove gpio_chip\n");
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
+static int timbgpio_remove(struct platform_device *dev)
+{
+	int err;
+	struct timbgpio *tgpio =3D platform_get_drvdata(dev);
+	struct resource *iomem =3D platform_get_resource(dev, IORESOURCE_MEM,=
 0);
+
+	/* disable interrupts */
+	iowrite32(0x0, tgpio->membase + TGPIOINT);
+
+	free_irq(platform_get_irq(dev, 0), tgpio);
+	err =3D gpiochip_remove(&tgpio->gpio);
+	if (err)
+		printk(KERN_ERR DRIVER_NAME": failed to remove gpio_chip\n");
+
+	iounmap(tgpio->membase);
+	release_mem_region(iomem->start, resource_size(iomem));
+	kfree(tgpio);
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
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean=
-labs.com are

linux-next.patch
gpio-timberdale-add-mc33880-driver.patch
i2c-timberdale-i2c-ocores-can-add-i2c-devices-to-the-bus.patch
mfd-timberdale-add-timberdale-dma-driver.patch
v4l2-timberdale-add-timberdale-logiwin-driver.patch
v4l2-timberdale-add-timberdale-logiwin-driver-in-kconfig-and-makefile.p=
atch
mfd-timberdale-add-timberdale-driver.patch
serial-timberdale-add-timberdale-uart-driver.patch
gpio-timberdale-add-timbgpio.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
