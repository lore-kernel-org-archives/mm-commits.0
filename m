From: akpm@linux-foundation.org
Subject: - x86-add-support-for-the-rdc-r-321x-soc.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:13:31 -0800
Message-ID: <200711091913.lA9JDVYu028036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755299AbXKITRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:17:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian.fainelli@telecomint.eu, david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: add support for the RDC R-321x SoC
has been removed from the -mm tree.  Its filename was
     x86-add-support-for-the-rdc-r-321x-soc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: add support for the RDC R-321x SoC
From: Florian Fainelli <florian.fainelli@telecomint.eu>

Add support for the RDC R-321x system-on-chip, also known as R-861x-(G).  It
uses the generic GPIO API and has support for the on-chip hardware watchdog.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig.i386                       |   13 
 arch/x86/Makefile_32                        |    5 
 arch/x86/mach-rdc321x/Makefile              |    5 
 arch/x86/mach-rdc321x/gpio.c                |   91 +++++
 arch/x86/mach-rdc321x/platform.c            |   68 ++++
 arch/x86/mach-rdc321x/wdt.c                 |  275 ++++++++++++++++++
 include/asm-x86/mach-rdc321x/gpio.h         |   56 +++
 include/asm-x86/mach-rdc321x/rdc321x_defs.h |    6 
 include/asm-x86/timex.h                     |    2 
 9 files changed, 520 insertions(+), 1 deletion(-)

diff -puN arch/x86/Kconfig.i386~x86-add-support-for-the-rdc-r-321x-soc arch/x86/Kconfig.i386
--- a/arch/x86/Kconfig.i386~x86-add-support-for-the-rdc-r-321x-soc
+++ a/arch/x86/Kconfig.i386
@@ -171,6 +171,17 @@ config X86_NUMAQ
 	  You will need a new lynxer.elf file to flash your firmware with - send
 	  email to <Martin.Bligh@us.ibm.com>.
 
+config X86_RDC321X
+	bool "RDC R-321x SoC"
+	select M486
+	select X86_REBOOTFIXUPS
+	select GENERIC_GPIO
+	select LEDS_GPIO
+	help
+	  This option is needed for RDC R-321x system-on-chip, also known
+	  as R-8610-(G).
+	  If you don't have one of these chips, you should say N here.
+
 config X86_SUMMIT
 	bool "Summit/EXA (IBM x440)"
 	depends on SMP
@@ -476,7 +487,7 @@ config X86_REBOOTFIXUPS
 	  system.
 
 	  Currently, the only fixup is for the Geode machines using
-	  CS5530A and CS5536 chipsets.
+	  CS5530A and CS5536 chipsets and the RDC R-321x SoC.
 
 	  Say Y if you want to enable the fixup. Currently, it's safe to
 	  enable this option even if you don't need it.
diff -puN arch/x86/Makefile_32~x86-add-support-for-the-rdc-r-321x-soc arch/x86/Makefile_32
--- a/arch/x86/Makefile_32~x86-add-support-for-the-rdc-r-321x-soc
+++ a/arch/x86/Makefile_32
@@ -81,6 +81,11 @@ mcore-$(CONFIG_X86_NUMAQ)	:= arch/x86/ma
 mflags-$(CONFIG_X86_BIGSMP)	:= -Iinclude/asm-x86/mach-bigsmp
 mcore-$(CONFIG_X86_BIGSMP)	:= arch/x86/mach-default
 
+# RDC R-321x subarch support
+mflags-$(CONFIG_X86_RDC321X)	:= -Iinclude/asm-x86/mach-rdc321x
+mcore-$(CONFIG_X86_RDC321X)	:= arch/x86/mach-default
+core-$(CONFIG_X86_RDC321X)	+= arch/x86/mach-rdc321x/
+
 #Summit subarch support
 mflags-$(CONFIG_X86_SUMMIT) := -Iinclude/asm-x86/mach-summit
 mcore-$(CONFIG_X86_SUMMIT)  := arch/x86/mach-default
diff -puN /dev/null arch/x86/mach-rdc321x/Makefile
--- /dev/null
+++ a/arch/x86/mach-rdc321x/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the RDC321x specific parts of the kernel
+#
+obj-$(CONFIG_X86_RDC321X)        := gpio.o platform.o wdt.o
+
diff -puN /dev/null arch/x86/mach-rdc321x/gpio.c
--- /dev/null
+++ a/arch/x86/mach-rdc321x/gpio.c
@@ -0,0 +1,91 @@
+/*
+ *  Copyright (C) 2007, OpenWrt.org, Florian Fainelli <florian@openwrt.org>
+ *  	RDC321x architecture specific GPIO support
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/autoconf.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+
+#include <asm/mach-rdc321x/rdc321x_defs.h>
+
+static inline int rdc_gpio_is_valid(unsigned gpio)
+{
+	return (gpio <= RDC_MAX_GPIO);
+}
+
+static unsigned int rdc_gpio_read(unsigned gpio)
+{
+	unsigned int val;
+
+	val = 0x80000000 | (7 << 11) | ((gpio&0x20?0x84:0x48));
+	outl(val, RDC3210_CFGREG_ADDR);
+	udelay(10);
+	val = inl(RDC3210_CFGREG_DATA);
+	val |= (0x1 << (gpio & 0x1F));
+	outl(val, RDC3210_CFGREG_DATA);
+	udelay(10);
+	val = 0x80000000 | (7 << 11) | ((gpio&0x20?0x88:0x4C));
+	outl(val, RDC3210_CFGREG_ADDR);
+	udelay(10);
+	val = inl(RDC3210_CFGREG_DATA);
+
+	return val;
+}
+
+static void rdc_gpio_write(unsigned int val)
+{
+	if (val) {
+		outl(val, RDC3210_CFGREG_DATA);
+		udelay(10);
+	}
+}
+
+int rdc_gpio_get_value(unsigned gpio)
+{
+	if (rdc_gpio_is_valid(gpio))
+		return (int)rdc_gpio_read(gpio);
+	else
+		return -EINVAL;
+}
+EXPORT_SYMBOL(rdc_gpio_get_value);
+
+void rdc_gpio_set_value(unsigned gpio, int value)
+{
+	unsigned int val;
+
+	if (!rdc_gpio_is_valid(gpio))
+		return;
+
+	val = rdc_gpio_read(gpio);
+
+	if (value)
+		val &= ~(0x1 << (gpio & 0x1F));
+	else
+		val |= (0x1 << (gpio & 0x1F));
+
+	rdc_gpio_write(val);
+}
+EXPORT_SYMBOL(rdc_gpio_set_value);
+
+int rdc_gpio_direction_input(unsigned gpio)
+{
+	return 0;
+}
+EXPORT_SYMBOL(rdc_gpio_direction_input);
+
+int rdc_gpio_direction_output(unsigned gpio, int value)
+{
+	return 0;
+}
+EXPORT_SYMBOL(rdc_gpio_direction_output);
+
+
diff -puN /dev/null arch/x86/mach-rdc321x/platform.c
--- /dev/null
+++ a/arch/x86/mach-rdc321x/platform.c
@@ -0,0 +1,68 @@
+/*
+ *  Generic RDC321x platform devices
+ *
+ *  Copyright (C) 2007 Florian Fainelli <florian@openwrt.org>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the
+ *  Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
+ *  Boston, MA  02110-1301, USA.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <linux/leds.h>
+
+#include <asm/gpio.h>
+
+/* LEDS */
+static struct gpio_led default_leds[] = {
+	{ .name = "rdc:dmz", .gpio = 1, },
+};
+
+static struct gpio_led_platform_data rdc321x_led_data = {
+	.num_leds = ARRAY_SIZE(default_leds),
+	.leds = default_leds,
+};
+
+static struct platform_device rdc321x_leds = {
+	.name = "leds-gpio",
+	.id = -1,
+	.dev = {
+		.platform_data = &rdc321x_led_data,
+	}
+};
+
+/* Watchdog */
+static struct platform_device rdc321x_wdt = {
+	.name = "rdc321x-wdt",
+	.id = -1,
+	.num_resources = 0,
+};
+
+static struct platform_device *rdc321x_devs[] = {
+	&rdc321x_leds,
+	&rdc321x_wdt
+};
+
+static int __init rdc_board_setup(void)
+{
+	return platform_add_devices(rdc321x_devs, ARRAY_SIZE(rdc321x_devs));
+}
+
+arch_initcall(rdc_board_setup);
diff -puN /dev/null arch/x86/mach-rdc321x/wdt.c
--- /dev/null
+++ a/arch/x86/mach-rdc321x/wdt.c
@@ -0,0 +1,275 @@
+/*
+ * RDC321x watchdog driver
+ *
+ * Copyright (C) 2007 Florian Fainelli <florian@openwrt.org>
+ *
+ * This driver is highly inspired from the cpu5_wdt driver
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
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/timer.h>
+#include <linux/completion.h>
+#include <linux/jiffies.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <asm/mach-rdc321x/rdc321x_defs.h>
+
+#define RDC_WDT_MASK	0x80000000 /* Mask */
+#define RDC_WDT_EN	0x00800000 /* Enable bit */
+#define RDC_WDT_WTI	0x00200000 /* Generate CPU reset/NMI/WDT on timeout */
+#define RDC_WDT_RST	0x00100000 /* Reset bit */
+#define RDC_WDT_WIF	0x00040000 /* WDT IRQ Flag */
+#define RDC_WDT_IRT	0x00000100 /* IRQ Routing table */
+#define RDC_WDT_CNT	0x00000001 /* WDT count */
+
+#define RDC_CLS_TMR	0x80003844 /* Clear timer */
+
+#define RDC_WDT_INTERVAL	(HZ/10+1)
+
+int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static int ticks = 1000;
+
+/* some device data */
+
+static struct {
+	struct completion stop;
+	volatile int running;
+	struct timer_list timer;
+	volatile int queue;
+	int default_ticks;
+	unsigned long inuse;
+} rdc321x_wdt_device;
+
+/* generic helper functions */
+
+static void rdc321x_wdt_trigger(unsigned long unused)
+{
+	if (rdc321x_wdt_device.running)
+		ticks--;
+
+	/* keep watchdog alive */
+	outl(RDC_WDT_EN|inl(RDC3210_CFGREG_DATA), RDC3210_CFGREG_DATA);
+
+	/* requeue?? */
+	if (rdc321x_wdt_device.queue && ticks)
+		mod_timer(&rdc321x_wdt_device.timer,
+				jiffies + RDC_WDT_INTERVAL);
+	else {
+		/* ticks doesn't matter anyway */
+		complete(&rdc321x_wdt_device.stop);
+	}
+
+}
+
+static void rdc321x_wdt_reset(void)
+{
+	ticks = rdc321x_wdt_device.default_ticks;
+}
+
+static void rdc321x_wdt_start(void)
+{
+	if (!rdc321x_wdt_device.queue) {
+		rdc321x_wdt_device.queue = 1;
+
+		/* Clear the timer */
+		outl(RDC_CLS_TMR, RDC3210_CFGREG_ADDR);
+
+		/* Enable watchdog and set the timeout to 81.92 us */
+		outl(RDC_WDT_EN|RDC_WDT_CNT, RDC3210_CFGREG_DATA);
+
+		mod_timer(&rdc321x_wdt_device.timer,
+				jiffies + RDC_WDT_INTERVAL);
+	}
+
+	/* if process dies, counter is not decremented */
+	rdc321x_wdt_device.running++;
+}
+
+static int rdc321x_wdt_stop(void)
+{
+	if (rdc321x_wdt_device.running)
+		rdc321x_wdt_device.running = 0;
+
+	ticks = rdc321x_wdt_device.default_ticks;
+
+	return -EIO;
+}
+
+/* filesystem operations */
+
+static int rdc321x_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &rdc321x_wdt_device.inuse))
+		return -EBUSY;
+
+	return nonseekable_open(inode, file);
+}
+
+static int rdc321x_wdt_release(struct inode *inode, struct file *file)
+{
+	clear_bit(0, &rdc321x_wdt_device.inuse);
+	return 0;
+}
+
+static int rdc321x_wdt_ioctl(struct inode *inode, struct file *file,
+				unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	unsigned int value;
+	static struct watchdog_info ident = {
+		.options = WDIOF_CARDRESET,
+		.identity = "RDC321x WDT",
+	};
+
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		rdc321x_wdt_reset();
+		break;
+	case WDIOC_GETSTATUS:
+		/* Read the value from the DATA register */
+		value = inl(RDC3210_CFGREG_DATA);
+		if (copy_to_user(argp, &value, sizeof(int)))
+			return -EFAULT;
+		break;
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+	case WDIOC_SETOPTIONS:
+		if (copy_from_user(&value, argp, sizeof(int)))
+			return -EFAULT;
+		switch (value) {
+		case WDIOS_ENABLECARD:
+			rdc321x_wdt_start();
+			break;
+		case WDIOS_DISABLECARD:
+			return rdc321x_wdt_stop();
+		default:
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -ENOTTY;
+	}
+	return 0;
+}
+
+static ssize_t rdc321x_wdt_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	if (!count)
+		return -EIO;
+
+	rdc321x_wdt_reset();
+
+	return count;
+}
+
+static const struct file_operations rdc321x_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.ioctl		= rdc321x_wdt_ioctl,
+	.open		= rdc321x_wdt_open,
+	.write		= rdc321x_wdt_write,
+	.release	= rdc321x_wdt_release,
+};
+
+static struct miscdevice rdc321x_wdt_misc = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &rdc321x_wdt_fops,
+};
+
+static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
+{
+	int err;
+
+	err = misc_register(&rdc321x_wdt_misc);
+	if (err < 0) {
+		printk(KERN_ERR PFX "watchdog misc_register failed\n");
+		return err;
+	}
+
+	/* Reset the watchdog */
+	outl(RDC_WDT_RST, RDC3210_CFGREG_DATA);
+
+	init_completion(&rdc321x_wdt_device.stop);
+	rdc321x_wdt_device.queue = 0;
+
+	clear_bit(0, &rdc321x_wdt_device.inuse);
+
+	setup_timer(&rdc321x_wdt_device.timer, rdc321x_wdt_trigger, 0);
+
+	rdc321x_wdt_device.default_ticks = ticks;
+
+	printk(KERN_INFO PFX "watchdog init success\n");
+
+	return 0;
+}
+
+static int rdc321x_wdt_remove(struct platform_device *pdev)
+{
+	if (rdc321x_wdt_device.queue) {
+		rdc321x_wdt_device.queue = 0;
+		wait_for_completion(&rdc321x_wdt_device.stop);
+	}
+
+	misc_deregister(&rdc321x_wdt_misc);
+
+	return 0;
+}
+
+static struct platform_driver rdc321x_wdt_driver = {
+	.probe = rdc321x_wdt_probe,
+	.remove = rdc321x_wdt_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "rdc321x-wdt",
+	},
+};
+
+static int __init rdc321x_wdt_init(void)
+{
+	return platform_driver_register(&rdc321x_wdt_driver);
+}
+
+static void __exit rdc321x_wdt_exit(void)
+{
+	platform_driver_unregister(&rdc321x_wdt_driver);
+}
+
+module_init(rdc321x_wdt_init);
+module_exit(rdc321x_wdt_exit);
+
+MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
+MODULE_DESCRIPTION("RDC321x watchdog driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff -puN /dev/null include/asm-x86/mach-rdc321x/gpio.h
--- /dev/null
+++ a/include/asm-x86/mach-rdc321x/gpio.h
@@ -0,0 +1,56 @@
+#ifndef _RDC321X_GPIO_H
+#define _RDC321X_GPIO_H
+
+extern int rdc_gpio_get_value(unsigned gpio);
+extern void rdc_gpio_set_value(unsigned gpio, int value);
+extern int rdc_gpio_direction_input(unsigned gpio);
+extern int rdc_gpio_direction_output(unsigned gpio, int value);
+
+
+/* Wrappers for the arch-neutral GPIO API */
+
+static inline int gpio_request(unsigned gpio, const char *label)
+{
+	/* Not yet implemented */
+	return 0;
+}
+
+static inline void gpio_free(unsigned gpio)
+{
+	/* Not yet implemented */
+}
+
+static inline int gpio_direction_input(unsigned gpio)
+{
+	return rdc_gpio_direction_input(gpio);
+}
+
+static inline int gpio_direction_output(unsigned gpio, int value)
+{
+	return rdc_gpio_direction_output(gpio, value);
+}
+
+static inline int gpio_get_value(unsigned gpio)
+{
+	return rdc_gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	rdc_gpio_set_value(gpio, value);
+}
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return gpio;
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	return irq;
+}
+
+/* For cansleep */
+#include <asm-generic/gpio.h>
+
+#endif /* _RDC321X_GPIO_H_ */
diff -puN /dev/null include/asm-x86/mach-rdc321x/rdc321x_defs.h
--- /dev/null
+++ a/include/asm-x86/mach-rdc321x/rdc321x_defs.h
@@ -0,0 +1,6 @@
+#define PFX	"rdc321x: "
+
+/* General purpose configuration and data registers */
+#define RDC3210_CFGREG_ADDR     0x0CF8
+#define RDC3210_CFGREG_DATA     0x0CFC
+#define RDC_MAX_GPIO		0x3A
diff -puN include/asm-x86/timex.h~x86-add-support-for-the-rdc-r-321x-soc include/asm-x86/timex.h
--- a/include/asm-x86/timex.h~x86-add-support-for-the-rdc-r-321x-soc
+++ a/include/asm-x86/timex.h
@@ -7,6 +7,8 @@
 
 #ifdef CONFIG_X86_ELAN
 #  define PIT_TICK_RATE 1189200 /* AMD Elan has different frequency! */
+#elif defined(CONFIG_X86_RDC321X)
+#  define PIT_TICK_RATE 1041667 /* Underlying HZ for R8610 */
 #else
 #  define PIT_TICK_RATE 1193182 /* Underlying HZ */
 #endif
_

Patches currently in -mm which might be from florian.fainelli@telecomint.eu are

git-x86.patch
