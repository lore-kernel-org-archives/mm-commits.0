From: akpm@linux-foundation.org
Subject: + gpio-adding-new-xilinx-driver.patch added to -mm tree
Date: Wed, 29 Oct 2008 23:53:44 -0700
Message-ID: <200810300653.m9U6ri3B006821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbYJ3Gx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 02:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john.linn@xilinx.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, kirans@xilinx.com, paulus@samba.org


The patch titled
     GPIO: add new Xilinx driver for powerpc
has been added to the -mm tree.  Its filename is
     gpio-adding-new-xilinx-driver.patch

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
Subject: GPIO: add new Xilinx driver for powerpc
From: John Linn <john.linn@xilinx.com>

This driver supports the Xilinx XPS GPIO IP core which has the typical
GPIO features.

Signed-off-by: Kiran Sutariya <kirans@xilinx.com>
Signed-off-by: John Linn <john.linn@xilinx.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig       |    8 +
 drivers/gpio/Makefile      |    1 
 drivers/gpio/xilinx_gpio.c |  240 +++++++++++++++++++++++++++++++++++
 3 files changed, 249 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-adding-new-xilinx-driver drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-adding-new-xilinx-driver
+++ a/drivers/gpio/Kconfig
@@ -65,6 +65,14 @@ config GPIO_SYSFS
 
 # put expanders in the right section, in alphabetical order
 
+comment "Memory mapped GPIO expanders:"
+
+config GPIO_XILINX
+	bool "Xilinx GPIO support"
+	depends on OF
+	help
+	  Say yes here to support the Xilinx FPGA GPIO device
+
 comment "I2C GPIO expanders:"
 
 config GPIO_MAX732X
diff -puN drivers/gpio/Makefile~gpio-adding-new-xilinx-driver drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-adding-new-xilinx-driver
+++ a/drivers/gpio/Makefile
@@ -10,4 +10,5 @@ obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
+obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
diff -puN /dev/null drivers/gpio/xilinx_gpio.c
--- /dev/null
+++ a/drivers/gpio/xilinx_gpio.c
@@ -0,0 +1,240 @@
+/*
+ * Xilinx gpio driver
+ *
+ * Copyright 2008 Xilinx, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+
+/* Register Offset Definitions */
+#define XGPIO_DATA_OFFSET   (0x0)	/* Data register  */
+#define XGPIO_TRI_OFFSET    (0x4)	/* I/O direction register  */
+
+struct xgpio_instance {
+	struct of_mm_gpio_chip mmchip;
+	u32 gpio_state;		/* GPIO state shadow register */
+	u32 gpio_dir;		/* GPIO direction shadow register */
+	spinlock_t gpio_lock;	/* Lock used for synchronization */
+};
+
+/**
+ * xgpio_get - Read the specified signal of the GPIO device.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ *
+ * This function reads the specified signal of the GPIO device. It returns 0 if
+ * the signal clear, 1 if signal is set or negative value on error.
+ */
+static int xgpio_get(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+
+	return (in_be32(mm_gc->regs + XGPIO_DATA_OFFSET) >> gpio) & 1;
+}
+
+/**
+ * xgpio_set - Write the specified signal of the GPIO device.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ * @val:    Value to be written to specified signal.
+ *
+ * This function writes the specified value in to the specified signal of the
+ * GPIO device.
+ */
+static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	unsigned long flags;
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);
+
+	spin_lock_irqsave(&chip->gpio_lock, flags);
+
+	/* Write to GPIO signal and set its direction to output */
+	if (val)
+		chip->gpio_state |= 1 << gpio;
+	else
+		chip->gpio_state &= ~(1 << gpio);
+	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+
+	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+}
+
+/**
+ * xgpio_dir_in - Set the direction of the specified GPIO signal as input.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ *
+ * This function sets the direction of specified GPIO signal as input.
+ * It returns 0 if direction of GPIO signals is set as input otherwise it
+ * returns negative error value.
+ */
+static int xgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	unsigned long flags;
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);
+
+	spin_lock_irqsave(&chip->gpio_lock, flags);
+
+	/* Set the GPIO bit in shadow register and set direction as input */
+	chip->gpio_dir |= (1 << gpio);
+	out_be32(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+
+	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+
+	return 0;
+}
+
+/**
+ * xgpio_dir_out - Set the direction of the specified GPIO signal as output.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ * @val:    Value to be written to specified signal.
+ *
+ * This function sets the direction of specified GPIO signal as output. If all
+ * GPIO signals of GPIO chip is configured as input then it returns
+ * error otherwise it returns 0.
+ */
+static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	unsigned long flags;
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);
+
+	spin_lock_irqsave(&chip->gpio_lock, flags);
+
+	/* Write state of GPIO signal */
+	if (val)
+		chip->gpio_state |= 1 << gpio;
+	else
+		chip->gpio_state &= ~(1 << gpio);
+	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+
+	/* Clear the GPIO bit in shadow register and set direction as output */
+	chip->gpio_dir &= (~(1 << gpio));
+	out_be32(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+
+	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+
+	return 0;
+}
+
+/**
+ * xgpio_of_probe - Probe method for the GPIO device.
+ * @of_dev: pointer to OF device structure.
+ * @match:  pointer to the structure used for matching a device.
+ *
+ * This function probes the GPIO device in the device tree. It initializes the
+ * driver data structure. It returns 0, if the driver is bound to the GPIO
+ * device, or a negative value if there is an error.
+ */
+static int __devinit xgpio_of_probe(struct of_device *ofdev,
+				    const struct of_device_id *match)
+{
+	struct xgpio_instance *chip;
+	struct of_gpio_chip *ofchip;
+	int status = 0;
+	const u32 *tree_info;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+	ofchip = &chip->mmchip.of_gc;
+
+	/* Update GPIO state shadow register with default value */
+	tree_info = of_get_property(ofdev->node, "xlnx,dout-default", NULL);
+	if (tree_info)
+		chip->gpio_state = *tree_info;
+
+	/* Update GPIO direction shadow register with default value */
+	chip->gpio_dir = 0xFFFFFFFF; /* By default, all pins are inputs */
+	tree_info = of_get_property(ofdev->node, "xlnx,tri-default", NULL);
+	if (tree_info)
+		chip->gpio_dir = *tree_info;
+
+	/* Check device node and parent device node for device width */
+	ofchip->gc.ngpio = 32; /* By default assume full GPIO controller */
+	tree_info = of_get_property(ofdev->node, "xlnx,gpio-width", NULL);
+	if (!tree_info)
+		tree_info = of_get_property(ofdev->node->parent,
+					    "xlnx,gpio-width", NULL);
+	if (tree_info)
+		ofchip->gc.ngpio = *tree_info;
+
+	spin_lock_init(&chip->gpio_lock);
+
+	ofchip->gpio_cells = 2;
+	ofchip->gc.direction_input = xgpio_dir_in;
+	ofchip->gc.direction_output = xgpio_dir_out;
+	ofchip->gc.get = xgpio_get;
+	ofchip->gc.set = xgpio_set;
+
+	/* Call the OF gpio helper to setup and register the GPIO device */
+	status = of_mm_gpiochip_add(ofdev->node, &chip->mmchip);
+	if (status) {
+		kfree(chip);
+		dev_err(&ofdev->dev, "Error in probe function error value %d\n",
+			status);
+		return status;
+	}
+
+	/* Finally, write the initial state to the device */
+	out_be32(chip->mmchip.regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+	out_be32(chip->mmchip.regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+
+	dev_info(&ofdev->dev, "registered Xilinx GPIO controller\n");
+	return 0;
+}
+
+/**
+ * xgpio_of_remove - Remove method for the GPIO device.
+ * @of_dev: pointer to OF device structure.
+ *
+ * This function returns a negative error as we cannot unregister GPIO chips.
+ */
+static int __devexit xgpio_of_remove(struct of_device *ofdev)
+{
+	return -EBUSY;
+}
+
+static struct of_device_id xgpio_of_match[] __devinitdata = {
+	{ .compatible = "xlnx,xps-gpio-1.00.a", },
+	{ /* end of list */ },
+};
+
+MODULE_DEVICE_TABLE(of, xgpio_of_match);
+
+static struct of_platform_driver xgpio_of_driver = {
+	.name = "xilinx_gpio",
+	.match_table = xgpio_of_match,
+	.probe = xgpio_of_probe,
+	.remove = __devexit_p(xgpio_of_remove),
+};
+
+static int __init xgpio_init(void)
+{
+	return of_register_platform_driver(&xgpio_of_driver);
+}
+
+/* Make sure we get initialized before anyone else tries to use us */
+subsys_initcall(xgpio_init);
+/* No exit call at the moment as we cannot unregister of GPIO chips */
+
+MODULE_AUTHOR("Xilinx, Inc.");
+MODULE_DESCRIPTION("Xilinx GPIO driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from john.linn@xilinx.com are

linux-next.patch
gpio-adding-new-xilinx-driver.patch

