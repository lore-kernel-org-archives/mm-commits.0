From: akpm@linux-foundation.org
Subject: + xtensa-s6000-gpio-driver.patch added to -mm tree
Date: Mon, 30 Mar 2009 17:00:43 -0700
Message-ID: <200903310000.n2V00h3s031545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761240AbZCaAEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 20:04:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: os@emlix.com, chris@zankel.net, dg@emlix.com, jw@emlix.com


The patch titled
     xtensa: s6000 gpio driver
has been added to the -mm tree.  Its filename is
     xtensa-s6000-gpio-driver.patch

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
Subject: xtensa: s6000 gpio driver
From: Oskar Schirmer <os@emlix.com>

Implement the s6000 gpio controller as a chip for the generic gpio
lib.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Daniel Glockner <dg@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Kconfig                 |    4 +
 arch/xtensa/include/asm/gpio.h      |   56 ++++++++++++++++++++
 arch/xtensa/variants/s6000/Makefile |    2 
 arch/xtensa/variants/s6000/gpio.c   |   71 ++++++++++++++++++++++++++
 4 files changed, 132 insertions(+), 1 deletion(-)

diff -puN arch/xtensa/Kconfig~xtensa-s6000-gpio-driver arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~xtensa-s6000-gpio-driver
+++ a/arch/xtensa/Kconfig
@@ -39,6 +39,9 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config GENERIC_GPIO
+	def_bool y
+
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
@@ -77,6 +80,7 @@ config XTENSA_VARIANT_DC232B
 config XTENSA_VARIANT_S6000
 	bool "s6000 - Stretch software configurable processor"
 	select VARIANT_IRQ_SWITCH
+	select ARCH_REQUIRE_GPIOLIB
 endchoice
 
 config MMU
diff -puN /dev/null arch/xtensa/include/asm/gpio.h
--- /dev/null
+++ a/arch/xtensa/include/asm/gpio.h
@@ -0,0 +1,56 @@
+/*
+ * Generic GPIO API implementation for xtensa.
+ *
+ * Stolen from x86, which is derived from the generic GPIO API for powerpc:
+ *
+ * Copyright (c) 2007-2008  MontaVista Software, Inc.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _ASM_XTENSA_GPIO_H
+#define _ASM_XTENSA_GPIO_H
+
+#include <asm-generic/gpio.h>
+
+#ifdef CONFIG_GPIOLIB
+
+/*
+ * Just call gpiolib.
+ */
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
+
+/*
+ * Not implemented, yet.
+ */
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int irq_to_gpio(unsigned int irq)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_GPIOLIB */
+
+#endif /* _ASM_XTENSA_GPIO_H */
diff -puN arch/xtensa/variants/s6000/Makefile~xtensa-s6000-gpio-driver arch/xtensa/variants/s6000/Makefile
--- a/arch/xtensa/variants/s6000/Makefile~xtensa-s6000-gpio-driver
+++ a/arch/xtensa/variants/s6000/Makefile
@@ -1,3 +1,3 @@
 # s6000 Makefile
 
-obj-y		+= irq.o
+obj-y		+= irq.o gpio.o
diff -puN /dev/null arch/xtensa/variants/s6000/gpio.c
--- /dev/null
+++ a/arch/xtensa/variants/s6000/gpio.c
@@ -0,0 +1,71 @@
+/*
+ * s6000 gpio driver
+ *
+ * Copyright (c) 2009 emlix GmbH
+ * Authors:	Oskar Schirmer <os@emlix.com>
+ *		Johannes Weiner <jw@emlix.com>
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+
+#include <variant/hardware.h>
+
+#define S6_GPIO_DATA		0x000
+#define S6_GPIO_IS		0x404
+#define S6_GPIO_IBE		0x408
+#define S6_GPIO_IEV		0x40C
+#define S6_GPIO_IE		0x410
+#define S6_GPIO_RIS		0x414
+#define S6_GPIO_MIS		0x418
+#define S6_GPIO_IC		0x41C
+#define S6_GPIO_AFSEL		0x420
+#define S6_GPIO_DIR		0x800
+#define S6_GPIO_BANK(nr)	((nr) * 0x1000)
+#define S6_GPIO_MASK(nr)	(4 << (nr))
+#define S6_GPIO_OFFSET(nr) \
+		(S6_GPIO_BANK((nr) >> 3) + S6_GPIO_MASK((nr) & 7))
+
+static int direction_input(struct gpio_chip *chip, unsigned int off)
+{
+	writeb(0, S6_REG_GPIO + S6_GPIO_DIR + S6_GPIO_OFFSET(off));
+	return 0;
+}
+
+static int get(struct gpio_chip *chip, unsigned int off)
+{
+	return readb(S6_REG_GPIO + S6_GPIO_DATA + S6_GPIO_OFFSET(off));
+}
+
+static int direction_output(struct gpio_chip *chip, unsigned int off, int val)
+{
+	unsigned rel = S6_GPIO_OFFSET(off);
+	writeb(~0, S6_REG_GPIO + S6_GPIO_DIR + rel);
+	writeb(val ? ~0 : 0, S6_REG_GPIO + S6_GPIO_DATA + rel);
+	return 0;
+}
+
+static void set(struct gpio_chip *chip, unsigned int off, int val)
+{
+	writeb(val ? ~0 : 0, S6_REG_GPIO + S6_GPIO_DATA + S6_GPIO_OFFSET(off));
+}
+
+static struct gpio_chip gpiochip = {
+	.owner = THIS_MODULE,
+	.direction_input = direction_input,
+	.get = get,
+	.direction_output = direction_output,
+	.set = set,
+	.base = 0,
+	.ngpio = 24,
+	.can_sleep = 0, /* no blocking io needed */
+	.exported = 0, /* no exporting to userspace */
+};
+
+static int gpio_init(void)
+{
+	return gpiochip_add(&gpiochip);
+}
+device_initcall(gpio_init);
_

Patches currently in -mm which might be from os@emlix.com are

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-s6000-dma-engine-support.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch

