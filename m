From: akpm@linux-foundation.org
Subject: + gpio-add-new-altera-pio-driver.patch added to -mm tree
Date: Wed, 26 Jan 2011 14:37:09 -0800
Message-ID: <201101262237.p0QMb95f008734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754164Ab1AZWhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 17:37:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas@wytron.com.tw


The patch titled
     gpio: add new Altera PIO driver
has been added to the -mm tree.  Its filename is
     gpio-add-new-altera-pio-driver.patch

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
Subject: gpio: add new Altera PIO driver
From: Thomas Chou <thomas@wytron.com.tw>

This driver supports the Altera PIO core.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig       |    6 
 drivers/gpio/Makefile      |    1 
 drivers/gpio/altera_gpio.c |  233 +++++++++++++++++++++++++++++++++++
 3 files changed, 240 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-add-new-altera-pio-driver drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-add-new-altera-pio-driver
+++ a/drivers/gpio/Kconfig
@@ -70,6 +70,12 @@ config GPIO_MAX730X
 
 comment "Memory mapped GPIO expanders:"
 
+config GPIO_ALTERA
+	bool "Altera GPIO"
+	depends on OF
+	help
+	  Say yes here to support the Altera PIO device
+
 config GPIO_BASIC_MMIO
 	tristate "Basic memory-mapped GPIO controllers support"
 	help
diff -puN drivers/gpio/Makefile~gpio-add-new-altera-pio-driver drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-add-new-altera-pio-driver
+++ a/drivers/gpio/Makefile
@@ -8,6 +8,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
+obj-$(CONFIG_GPIO_ALTERA)	+= altera_gpio.o
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
diff -puN /dev/null drivers/gpio/altera_gpio.c
--- /dev/null
+++ a/drivers/gpio/altera_gpio.c
@@ -0,0 +1,233 @@
+/*
+ * Altera GPIO driver
+ *
+ * Copyright (C) 2011 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * Based on Xilinx gpio driver, which is
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
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+
+#define DRV_NAME "altera_gpio"
+
+/* Register Offset Definitions */
+#define ALTERA_GPIO_DATA_OFFSET   0x0	/* Data register  */
+#define ALTERA_GPIO_DIR_OFFSET    0x4	/* I/O direction register  */
+
+struct altera_gpio_instance {
+	struct of_mm_gpio_chip mmchip;
+	u32 gpio_state;		/* GPIO state shadow register */
+	u32 gpio_dir;		/* GPIO direction shadow register */
+	spinlock_t gpio_lock;	/* Lock used for synchronization */
+};
+
+/*
+ * altera_gpio_get - Read the specified signal of the GPIO device.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ *
+ * This function reads the specified signal of the GPIO device. It returns 0 if
+ * the signal clear, 1 if signal is set or negative value on error.
+ */
+static int altera_gpio_get(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+
+	return (readl(mm_gc->regs + ALTERA_GPIO_DATA_OFFSET) >> gpio) & 1;
+}
+
+/*
+ * altera_gpio_set - Write the specified signal of the GPIO device.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ * @val:    Value to be written to specified signal.
+ *
+ * This function writes the specified value in to the specified signal of the
+ * GPIO device.
+ */
+static void altera_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	unsigned long flags;
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct altera_gpio_instance *chip =
+	    container_of(mm_gc, struct altera_gpio_instance, mmchip);
+
+	spin_lock_irqsave(&chip->gpio_lock, flags);
+
+	/* Write to shadow register and output */
+	if (val)
+		chip->gpio_state |= 1 << gpio;
+	else
+		chip->gpio_state &= ~(1 << gpio);
+	writel(chip->gpio_state, mm_gc->regs + ALTERA_GPIO_DATA_OFFSET);
+
+	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+}
+
+/*
+ * altera_gpio_dir_in - Set the direction of the specified GPIO signal as input.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ *
+ * This function sets the direction of specified GPIO signal as input.
+ * It returns 0 if direction of GPIO signals is set as input otherwise it
+ * returns negative error value.
+ */
+static int altera_gpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	unsigned long flags;
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct altera_gpio_instance *chip =
+	    container_of(mm_gc, struct altera_gpio_instance, mmchip);
+
+	spin_lock_irqsave(&chip->gpio_lock, flags);
+
+	/* Clear the GPIO bit in shadow register and set direction as input */
+	chip->gpio_dir &= ~(1 << gpio);
+	writel(chip->gpio_dir, mm_gc->regs + ALTERA_GPIO_DIR_OFFSET);
+
+	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+
+	return 0;
+}
+
+/*
+ * altera_gpio_dir_out - Set the direction of the specified GPIO as output.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ * @val:    Value to be written to specified signal.
+ *
+ * This function sets the direction of specified GPIO signal as output. If all
+ * GPIO signals of GPIO chip is configured as input then it returns
+ * error otherwise it returns 0.
+ */
+static int altera_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	unsigned long flags;
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct altera_gpio_instance *chip =
+	    container_of(mm_gc, struct altera_gpio_instance, mmchip);
+
+	spin_lock_irqsave(&chip->gpio_lock, flags);
+
+	/* Write state of GPIO signal */
+	if (val)
+		chip->gpio_state |= 1 << gpio;
+	else
+		chip->gpio_state &= ~(1 << gpio);
+	writel(chip->gpio_state, mm_gc->regs + ALTERA_GPIO_DATA_OFFSET);
+
+	/* Set the GPIO bit in shadow register and set direction as output */
+	chip->gpio_dir |= (1 << gpio);
+	writel(chip->gpio_dir, mm_gc->regs + ALTERA_GPIO_DIR_OFFSET);
+
+	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+
+	return 0;
+}
+
+/*
+ * altera_gpio_save_regs - Set initial values of GPIO pins
+ * @mm_gc: pointer to memory mapped GPIO chip structure
+ */
+static void altera_gpio_save_regs(struct of_mm_gpio_chip *mm_gc)
+{
+	struct altera_gpio_instance *chip =
+	    container_of(mm_gc, struct altera_gpio_instance, mmchip);
+
+	writel(chip->gpio_state, mm_gc->regs + ALTERA_GPIO_DATA_OFFSET);
+	writel(chip->gpio_dir, mm_gc->regs + ALTERA_GPIO_DIR_OFFSET);
+}
+
+/*
+ * altera_gpio_of_probe - Probe method for the GPIO device.
+ * @np: pointer to device tree node
+ *
+ * This function probes the GPIO device in the device tree. It initializes the
+ * driver data structure. It returns 0, if the driver is bound to the GPIO
+ * device, or a negative value if there is an error.
+ */
+static int __devinit altera_gpio_of_probe(struct device_node *np)
+{
+	struct altera_gpio_instance *chip;
+	int status = 0;
+	const u32 *tree_info;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	/* Update GPIO state shadow register with default value */
+	tree_info = of_get_property(np, "resetvalue", NULL);
+	if (tree_info)
+		chip->gpio_state = be32_to_cpup(tree_info);
+
+	/* Update GPIO direction shadow register with default value */
+	chip->gpio_dir = 0; /* By default, all pins are inputs */
+
+	/* Check device node for device width */
+	chip->mmchip.gc.ngpio = 32; /* By default assume full GPIO controller */
+	tree_info = of_get_property(np, "width", NULL);
+	if (tree_info)
+		chip->mmchip.gc.ngpio = be32_to_cpup(tree_info);
+
+	spin_lock_init(&chip->gpio_lock);
+
+	chip->mmchip.gc.direction_input = altera_gpio_dir_in;
+	chip->mmchip.gc.direction_output = altera_gpio_dir_out;
+	chip->mmchip.gc.get = altera_gpio_get;
+	chip->mmchip.gc.set = altera_gpio_set;
+
+	chip->mmchip.save_regs = altera_gpio_save_regs;
+
+	/* Call the OF gpio helper to setup and register the GPIO device */
+	status = of_mm_gpiochip_add(np, &chip->mmchip);
+	if (status) {
+		kfree(chip);
+		pr_err("%s: error in probe function with status %d\n",
+		       np->full_name, status);
+		return status;
+	}
+	pr_info(DRV_NAME ": %s: registered\n", np->full_name);
+	return 0;
+}
+
+static struct of_device_id altera_gpio_of_match[] __devinitdata = {
+	{ .compatible = "altr,pio-1.0", },
+	{},
+};
+
+static int __init altera_gpio_init(void)
+{
+	struct device_node *np;
+
+	for_each_matching_node(np, altera_gpio_of_match)
+		altera_gpio_of_probe(np);
+
+	return 0;
+}
+
+/* Make sure we get initialized before anyone else tries to use us */
+subsys_initcall(altera_gpio_init);
+/* No exit call at the moment as we cannot unregister of GPIO chips */
+
+MODULE_DESCRIPTION("Altera GPIO driver");
+MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
_

Patches currently in -mm which might be from thomas@wytron.com.tw are

gpio-add-new-altera-pio-driver.patch

