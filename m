From: akpm@linux-foundation.org
Subject: + gpio-amd-cs5535-cs5536-gpio-driver.patch added to -mm tree
Date: Mon, 01 Jun 2009 17:03:00 -0700
Message-ID: <200906020003.n520307Y006454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754221AbZFBADc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 20:03:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Tobias_Mueller@twam.info, david-b@pacbell.net, dilinger@debian.org, jordan@cosmicpenguin.net, katzj@redhat.com, tiwai@suse.de


The patch titled
     gpio: AMD CS5535/CS5536 GPIO driver
has been added to the -mm tree.  Its filename is
     gpio-amd-cs5535-cs5536-gpio-driver.patch

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
Subject: gpio: AMD CS5535/CS5536 GPIO driver
From: Tobias Mueller <Tobias_Mueller@twam.info>

A GPIO driver for AMD Geode Companion Device CS5535/CS5536 using the GPIO
framework as a replacement for old cs5535-gpio driver.

Signed-off-by: Tobias Mueller <Tobias_Mueller@twam.info>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jeremy Katz <katzj@redhat.com>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig       |    8 
 drivers/gpio/Makefile      |    1 
 drivers/gpio/gpio_cs5535.c |  342 +++++++++++++++++++++++++++++++++++
 3 files changed, 351 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-amd-cs5535-cs5536-gpio-driver drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-amd-cs5535-cs5536-gpio-driver
+++ a/drivers/gpio/Kconfig
@@ -67,6 +67,14 @@ config GPIO_SYSFS
 
 comment "Memory mapped GPIO expanders:"
 
+config GPIO_CS5535
+	tristate "AMD CS5535/CS5536 (Geode Companion Device)"
+	depends on !CONFIG_CS5535_GPIO && X86 && EXPERIMENTAL
+	default N
+	help
+	  Say yes here to support GPIO pins of AMD CS5535/CS5536
+          (Geode Companion Device)
+
 config GPIO_XILINX
 	bool "Xilinx GPIO support"
 	depends on PPC_OF || MICROBLAZE
diff -puN drivers/gpio/Makefile~gpio-amd-cs5535-cs5536-gpio-driver drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-amd-cs5535-cs5536-gpio-driver
+++ a/drivers/gpio/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
+obj-$(CONFIG_GPIO_CS5535)	+= gpio_cs5535.o
diff -puN /dev/null drivers/gpio/gpio_cs5535.c
--- /dev/null
+++ a/drivers/gpio/gpio_cs5535.c
@@ -0,0 +1,342 @@
+/*
+    CS5535/CS5536 GPIO driver
+
+    Copyright (C) 2009 Tobias Mueller <Tobias_Mueller@twam.info>
+
+
+    Derived from the the cs5535_gpio (char) driver:
+
+    Copyright (c) 2005 Ben Gardner <bgardner@wabtec.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/gpio.h>
+
+#define GPIO_CS5535_NAME	"gpio_cs5535"
+#define GPIO_CS5535_SIZE	256		/* size of I/O area */
+#define GPIO_CS5535_LBAR_GPIO	0x5140000C	/* p. 385 of datasheet */
+#define GPIO_CS5535_OUT_VAL	0x00		/* output value */
+#define GPIO_CS5535_OUT_EN	0x04		/* output enable */
+#define GPIO_CS5535_OD_EN	0x08		/* open-drain enable */
+#define GPIO_CS5535_OUT_AUX1	0x10		/* output aux 1 select */
+#define GPIO_CS5535_OUT_AUX2	0x14		/* output aux 2 select */
+#define GPIO_CS5535_OUT_PU_EN	0x18		/* pull-up enable */
+#define GPIO_CS5535_OUT_PD_EN	0x1C		/* poll-down eable */
+#define GPIO_CS5535_IN_EN	0x20		/* input enable */
+#define GPIO_CS5535_READ_BACK	0x30		/* read back */
+#define GPIO_CS5535_IN_AUX1	0x34		/* input aux 1 select */
+
+/**
+* Some GPIO pins
+*  31-29,23 : reserved (always mask out)
+*  28       : Power Button
+*  26       : PME#
+*  22-16    : LPC
+*  14,15    : SMBus
+*  9,8      : UART1
+*  7        : PCI INTB
+*  3,4      : UART2/DDC
+*  2        : IDE_IRQ0
+*  1        : AC_BEEP
+*  0        : PCI INTA
+*
+* If a mask was not specified, be conservative and only allow:
+*  1,2,5,6,10-13,24,25,27
+*/
+
+#ifndef GPIO_CS5535_DEF_MASK
+#define GPIO_CS5535_DEF_MASK	0x0B003C66
+#endif
+
+static struct pci_device_id gpio_cs5535_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_NS,  PCI_DEVICE_ID_NS_CS5535_ISA) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
+	{ } /* NULL entry */
+};
+
+/* pin names */
+static char *gpio_cs5535_names[] = {
+	"GPIO0", "GPIO1", "GPIO2", "GPIO3",
+	"GPIO4", "GPIO5", "GPIO6", "GPIO7",
+	"GPIO8", "GPIO9", "GPIO10", "GPIO11",
+	"GPIO12", "GPIO13", "GPIO14", "GPIO15",
+	"GPIO16", "GPIO17", "GPIO18", "GPIO19",
+	"GPIO20", "GPIO21", "GPIO22", NULL,
+	"GPIO24", "GPIO25", "GPIO26", "GPIO27",
+	"GPIO28", NULL, NULL, NULL,
+};
+
+struct gpio_cs5535 {
+	struct pci_dev *pdev;
+	struct gpio_chip gpio;
+};
+
+/* base address of gpio I/O*/
+static u32 iobase;
+
+static int gpiobase;
+module_param_named(gpiobase, gpiobase, int, 0444);
+MODULE_PARM_DESC(gpiobase, "The GPIO number base. -1 means dynamic");
+
+static ulong mask;
+module_param_named(mask, mask, ulong, 0444);
+MODULE_PARM_DESC(mask, "GPIO channel mask.");
+
+/* gets the regiter offset for the GPIO bank.
+ *      low (0-15) stats at 0x00, high (16-31) starts at 0x80 */
+static inline u32 gpio_cs5535_lowhigh_base(int offset)
+{
+	return (offset & 0x10) << 3;
+}
+
+/* optional hook for chip-specific activation, such as
+ *      enabling module power and clock; may sleep */
+static int gpio_cs5535_request(struct gpio_chip *chip, unsigned offset)
+{
+	u32 on, off;
+
+	on = 1 << (offset & 0x0F);
+	off = on << 16;
+
+	/* check if this pin is available */
+	if ((mask & (1 << offset)) == 0) {
+		printk(KERN_INFO GPIO_CS5535_NAME
+		       ": pin %u is not available\n", offset);
+		return -EINVAL;
+	}
+
+	/* disable output aux 1 & 2 on this pin */
+	outl(off, iobase+gpio_cs5535_lowhigh_base(offset)
+	     +GPIO_CS5535_OUT_AUX1);
+	outl(off, iobase+gpio_cs5535_lowhigh_base(offset)
+	     +GPIO_CS5535_OUT_AUX2);
+
+	/* disable input aux 1 on this pin */
+	outl(off, iobase+gpio_cs5535_lowhigh_base(offset)
+	     +GPIO_CS5535_IN_AUX1);
+
+	/* disable output */
+	outl(off, iobase+gpio_cs5535_lowhigh_base(offset)
+	     +GPIO_CS5535_OUT_EN);
+
+	/* enable input */
+	outl(on, iobase+gpio_cs5535_lowhigh_base(offset)
+	     +GPIO_CS5535_IN_EN);
+
+	return 0;
+}
+
+/* configures signal "offset" as input, or returns error */
+static int gpio_cs5535_direction_input(struct gpio_chip *chip,
+				       unsigned offset)
+{
+	u32 on, off;
+
+	on = 1 << (offset & 0x0F);
+	off = on << 16;
+
+	/* disable output */
+	outl(off, iobase+gpio_cs5535_lowhigh_base(offset)
+	     +GPIO_CS5535_OUT_EN);
+
+	/* enable input */
+	outl(on, iobase+gpio_cs5535_lowhigh_base(offset)
+	     +GPIO_CS5535_IN_EN);
+
+	return 0;
+}
+
+/* returns value for signal "offset"; for output signals this
+ *      returns either the value actually sensed, or zero */
+static int gpio_cs5535_get(struct gpio_chip *chip, unsigned offset)
+{
+	u32 bit;
+
+	bit = 1 << (offset & 0x0F);
+
+	return inl(iobase+gpio_cs5535_lowhigh_base(offset)
+		   +GPIO_CS5535_READ_BACK) & bit;
+}
+
+/* configures signal "offset" as output, or returns error */
+static int gpio_cs5535_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	u32 on, off;
+
+	on = 1 << (offset & 0x0F);
+	off = on << 16;
+
+	/* disable input */
+	outl(off, iobase+gpio_cs5535_lowhigh_base(offset)
+	     +GPIO_CS5535_IN_EN);
+
+	/* set value */
+	outl(value ? on : off, iobase+gpio_cs5535_lowhigh_base(offset)
+	     +GPIO_CS5535_OUT_VAL);
+
+	/* enable output */
+	outl(on, iobase+gpio_cs5535_lowhigh_base(offset)
+	    +GPIO_CS5535_OUT_EN);
+
+	return 0;
+}
+
+/* assigns output value for signal "offset" */
+static void gpio_cs5535_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	u32 on, off;
+
+	on = 1 << (offset & 0x0F);
+	off = on << 16;
+
+	/* set value */
+	outl(value ? on : off, iobase+gpio_cs5535_lowhigh_base(offset)
+	     +GPIO_CS5535_OUT_VAL);
+}
+
+/* setups gpio_chip object */
+static void gpio_cs5535_setup(struct gpio_cs5535 *cs5535)
+{
+	struct gpio_chip *c = &cs5535->gpio;
+
+	c->label = dev_name(&cs5535->pdev->dev);
+	c->owner = THIS_MODULE;
+	c->request = gpio_cs5535_request;
+	c->direction_input = gpio_cs5535_direction_input;
+	c->get = gpio_cs5535_get;
+	c->direction_output = gpio_cs5535_direction_output;
+	c->set = gpio_cs5535_set;
+	c->dbg_show = NULL;
+	c->base = gpiobase;
+	c->ngpio = 32;
+	c->can_sleep = 0;
+	c->names = gpio_cs5535_names;
+}
+
+static int gpio_cs5535_probe(struct pci_dev *pdev,
+			     const struct pci_device_id *pciid)
+{
+	struct gpio_cs5535 *cs5535;
+	u32 low, hi;
+	u32 mask_orig = mask;
+	int err;
+
+	cs5535 = kzalloc(sizeof(*cs5535), GFP_KERNEL);
+	if (!cs5535)
+		return -ENOMEM;
+
+	cs5535->pdev = pdev;
+
+	pci_set_drvdata(pdev, cs5535);
+
+	/* Grab the GPIO I/O range */
+	rdmsr(GPIO_CS5535_LBAR_GPIO, low, hi);
+
+	/* Check the mask and whether GPIO is enabled (sanity check) */
+	if (hi != 0x0000f001) {
+		printk(KERN_WARNING GPIO_CS5535_NAME
+		       ": GPIO not enabled\n");
+		err = -ENODEV;
+		goto err_release_mem;
+	}
+
+	iobase = low & 0x000ff00;
+
+	if (!request_region(iobase, GPIO_CS5535_SIZE, GPIO_CS5535_NAME)) {
+		printk(KERN_ERR GPIO_CS5535_NAME
+		       ": Can't allocate I/O for GPIO\n");
+		err = -ENODEV;
+		goto err_release_mem;
+	}
+
+	if (mask != 0)
+		mask &= 0x1F7FFFFF; /* mask out reserved */
+	else
+		mask = GPIO_CS5535_DEF_MASK;
+
+	/* do not allow pin 28, Power Button, as there's special handling
+	 * in the PMC needed. (note 12, p. 48) */
+	mask &= ~(1 << 28);
+
+	if (mask_orig != mask)
+		printk(KERN_INFO GPIO_CS5535_NAME
+		       ": mask changed from 0x%08lX to 0x%08lX\n",
+		       mask_orig, mask);
+
+	gpio_cs5535_setup(cs5535);
+
+	err = gpiochip_add(&cs5535->gpio);
+	if (err) {
+		printk(KERN_ERR GPIO_CS5535_NAME
+		       ": Failed to register GPIOs\n");
+		goto err_release_mem;
+	}
+
+	return 0;
+
+err_release_mem:
+	pci_set_drvdata(pdev, NULL);
+	kfree(cs5535);
+
+	return err;
+}
+
+static void gpio_cs5535_remove(struct pci_dev *pdev)
+{
+	struct gpio_cs5535 *cs5535 = pci_get_drvdata(pdev);
+	int status = 0;
+
+	status = gpiochip_remove(&cs5535->gpio);
+
+	if (status == 0) {
+		pci_set_drvdata(pdev, NULL);
+		release_region(iobase, GPIO_CS5535_SIZE);
+		kfree(cs5535);
+	} else {
+		dev_err(&pdev->dev, "%s --> %d\n", "remove", status);
+	}
+}
+
+#define gpio_cs5535_suspend NULL
+#define gpio_cs5535_resume NULL
+
+static struct pci_driver gpio_cs5535_driver = {
+	.name           = "gpio_cs5535",
+	.id_table       = gpio_cs5535_pci_tbl,
+	.probe          = gpio_cs5535_probe,
+	.remove         = gpio_cs5535_remove,
+	.suspend        = gpio_cs5535_suspend,
+	.resume         = gpio_cs5535_resume,
+};
+
+static int __init gpio_cs5535_init(void)
+{
+	return pci_register_driver(&gpio_cs5535_driver);
+}
+module_init(gpio_cs5535_init)
+
+static void __exit gpio_cs5535_exit(void)
+{
+	pci_unregister_driver(&gpio_cs5535_driver);
+}
+module_exit(gpio_cs5535_exit);
+
+MODULE_AUTHOR("Tobias Mueller <Tobias_Mueller@twam.info>");
+MODULE_DESCRIPTION("AMD CS5535/CS5536 GPIO driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from Tobias_Mueller@twam.info are

leds-alix-leds2-fixed-for-award-bios.patch
gpio-amd-cs5535-cs5536-gpio-driver.patch

