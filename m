From: akpm@linux-foundation.org
Subject: + arm-pxa-gpiolib-support.patch added to -mm tree
Date: Mon, 26 Nov 2007 23:46:00 -0800
Message-ID: <200711270746.lAR7k0Fd001228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbXK0Hqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 02:46:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.zabel@gmail.com, dbrownell@users.sourceforge.net, nico@cam.org, rmk+kernel@arm.linux.org.uk


The patch titled
     arm: PXA gpiolib support
has been added to the -mm tree.  Its filename is
     arm-pxa-gpiolib-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arm: PXA gpiolib support
From: Philipp Zabel <philipp.zabel@gmail.com>

Add gpiolib support for the PXA architecture:

  - move all GPIO API functions from generic.c into gpio.c
  - convert the gpio_get/set_value macros into inline functions

This makes it easier to hook up GPIOs provided by external chips like ASICs
and CPLDs, provides real support for gpio_request(), and enables the
/sys/kernel/debug/gpio file.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Nicolas Pitre <nico@cam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                    |    1 
 arch/arm/mach-pxa/Makefile          |    2 
 arch/arm/mach-pxa/generic.c         |   93 ------------
 arch/arm/mach-pxa/generic.h         |    1 
 arch/arm/mach-pxa/gpio.c            |  197 ++++++++++++++++++++++++++
 arch/arm/mach-pxa/irq.c             |    2 
 include/asm-arm/arch-pxa/gpio.h     |   48 ++----
 include/asm-arm/arch-pxa/pxa-regs.h |   13 +
 8 files changed, 235 insertions(+), 122 deletions(-)

diff -puN arch/arm/Kconfig~arm-pxa-gpiolib-support arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-pxa-gpiolib-support
+++ a/arch/arm/Kconfig
@@ -346,6 +346,7 @@ config ARCH_PXA
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
+	select GPIO_LIB
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
diff -puN arch/arm/mach-pxa/generic.c~arm-pxa-gpiolib-support arch/arm/mach-pxa/generic.c
--- a/arch/arm/mach-pxa/generic.c~arm-pxa-gpiolib-support
+++ a/arch/arm/mach-pxa/generic.c
@@ -32,7 +32,6 @@
 #include <asm/mach/map.h>
 
 #include <asm/arch/pxa-regs.h>
-#include <asm/arch/gpio.h>
 #include <asm/arch/udc.h>
 #include <asm/arch/pxafb.h>
 #include <asm/arch/mmc.h>
@@ -73,97 +72,6 @@ unsigned int get_memclk_frequency_10khz(
 EXPORT_SYMBOL(get_memclk_frequency_10khz);
 
 /*
- * Handy function to set GPIO alternate functions
- */
-int pxa_last_gpio;
-
-int pxa_gpio_mode(int gpio_mode)
-{
-	unsigned long flags;
-	int gpio = gpio_mode & GPIO_MD_MASK_NR;
-	int fn = (gpio_mode & GPIO_MD_MASK_FN) >> 8;
-	int gafr;
-
-	if (gpio > pxa_last_gpio)
-		return -EINVAL;
-
-	local_irq_save(flags);
-	if (gpio_mode & GPIO_DFLT_LOW)
-		GPCR(gpio) = GPIO_bit(gpio);
-	else if (gpio_mode & GPIO_DFLT_HIGH)
-		GPSR(gpio) = GPIO_bit(gpio);
-	if (gpio_mode & GPIO_MD_MASK_DIR)
-		GPDR(gpio) |= GPIO_bit(gpio);
-	else
-		GPDR(gpio) &= ~GPIO_bit(gpio);
-	gafr = GAFR(gpio) & ~(0x3 << (((gpio) & 0xf)*2));
-	GAFR(gpio) = gafr |  (fn  << (((gpio) & 0xf)*2));
-	local_irq_restore(flags);
-
-	return 0;
-}
-
-EXPORT_SYMBOL(pxa_gpio_mode);
-
-int gpio_direction_input(unsigned gpio)
-{
-	unsigned long flags;
-	u32 mask;
-
-	if (gpio > pxa_last_gpio)
-		return -EINVAL;
-
-	mask = GPIO_bit(gpio);
-	local_irq_save(flags);
-	GPDR(gpio) &= ~mask;
-	local_irq_restore(flags);
-
-	return 0;
-}
-EXPORT_SYMBOL(gpio_direction_input);
-
-int gpio_direction_output(unsigned gpio, int value)
-{
-	unsigned long flags;
-	u32 mask;
-
-	if (gpio > pxa_last_gpio)
-		return -EINVAL;
-
-	mask = GPIO_bit(gpio);
-	local_irq_save(flags);
-	if (value)
-		GPSR(gpio) = mask;
-	else
-		GPCR(gpio) = mask;
-	GPDR(gpio) |= mask;
-	local_irq_restore(flags);
-
-	return 0;
-}
-EXPORT_SYMBOL(gpio_direction_output);
-
-/*
- * Return GPIO level
- */
-int pxa_gpio_get_value(unsigned gpio)
-{
-	return __gpio_get_value(gpio);
-}
-
-EXPORT_SYMBOL(pxa_gpio_get_value);
-
-/*
- * Set output GPIO level
- */
-void pxa_gpio_set_value(unsigned gpio, int value)
-{
-	__gpio_set_value(gpio, value);
-}
-
-EXPORT_SYMBOL(pxa_gpio_set_value);
-
-/*
  * Routine to safely enable or disable a clock in the CKEN
  */
 void __pxa_set_cken(int clock, int enable)
@@ -178,7 +86,6 @@ void __pxa_set_cken(int clock, int enabl
 
 	local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL(__pxa_set_cken);
 
 /*
diff -puN arch/arm/mach-pxa/generic.h~arm-pxa-gpiolib-support arch/arm/mach-pxa/generic.h
--- a/arch/arm/mach-pxa/generic.h~arm-pxa-gpiolib-support
+++ a/arch/arm/mach-pxa/generic.h
@@ -16,6 +16,7 @@ extern void __init pxa_init_irq_low(void
 extern void __init pxa_init_irq_high(void);
 extern void __init pxa_init_irq_gpio(int gpio_nr);
 extern void __init pxa_init_irq_set_wake(int (*set_wake)(unsigned int, unsigned int));
+extern void __init pxa_init_gpio(int gpio_nr);
 extern void __init pxa25x_init_irq(void);
 extern void __init pxa27x_init_irq(void);
 extern void __init pxa3xx_init_irq(void);
diff -puN /dev/null arch/arm/mach-pxa/gpio.c
--- /dev/null
+++ a/arch/arm/mach-pxa/gpio.c
@@ -0,0 +1,197 @@
+/*
+ *  linux/arch/arm/mach-pxa/gpio.c
+ *
+ *  Generic PXA GPIO handling
+ *
+ *  Author:	Nicolas Pitre
+ *  Created:	Jun 15, 2001
+ *  Copyright:	MontaVista Software Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+
+#include <asm/gpio.h>
+#include <asm/hardware.h>
+#include <asm/io.h>
+#include <asm/arch/pxa-regs.h>
+
+#include "generic.h"
+
+
+struct pxa_gpio_chip {
+	struct gpio_chip chip;
+	void __iomem     *regbase;
+};
+
+int pxa_last_gpio;
+
+/*
+ * Configure pins for GPIO or other functions
+ */
+int pxa_gpio_mode(int gpio_mode)
+{
+	unsigned long flags;
+	int gpio = gpio_mode & GPIO_MD_MASK_NR;
+	int fn = (gpio_mode & GPIO_MD_MASK_FN) >> 8;
+	int gafr;
+
+	if (gpio > pxa_last_gpio)
+		return -EINVAL;
+
+	local_irq_save(flags);
+	if (gpio_mode & GPIO_DFLT_LOW)
+		GPCR(gpio) = GPIO_bit(gpio);
+	else if (gpio_mode & GPIO_DFLT_HIGH)
+		GPSR(gpio) = GPIO_bit(gpio);
+	if (gpio_mode & GPIO_MD_MASK_DIR)
+		GPDR(gpio) |= GPIO_bit(gpio);
+	else
+		GPDR(gpio) &= ~GPIO_bit(gpio);
+	gafr = GAFR(gpio) & ~(0x3 << (((gpio) & 0xf)*2));
+	GAFR(gpio) = gafr |  (fn  << (((gpio) & 0xf)*2));
+	local_irq_restore(flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(pxa_gpio_mode);
+
+static int pxa_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned long        flags;
+	u32                  mask = 1 << offset;
+	u32                  value;
+	struct pxa_gpio_chip *pxa;
+	void __iomem         *gpdr;
+
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+	gpdr = pxa->regbase + GPDR_OFFSET;
+	local_irq_save(flags);
+	value = __raw_readl(gpdr);
+	value &= ~mask;
+	__raw_writel(value, gpdr);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+static int pxa_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	unsigned long        flags;
+	u32                  mask = 1 << offset;
+	u32                  tmp;
+	struct pxa_gpio_chip *pxa;
+	void __iomem         *gpdr;
+
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+	__raw_writel(mask,
+			pxa->regbase + (value ? GPSR_OFFSET : GPCR_OFFSET));
+	gpdr = pxa->regbase + GPDR_OFFSET;
+	local_irq_save(flags);
+	tmp = __raw_readl(gpdr);
+	tmp |= mask;
+	__raw_writel(tmp, gpdr);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+/*
+ * Return GPIO level
+ */
+static int pxa_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	u32                  mask = 1 << offset;
+	struct pxa_gpio_chip *pxa;
+
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+	return __raw_readl(pxa->regbase + GPLR_OFFSET) & mask;
+}
+
+/*
+ * Set output GPIO level
+ */
+static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	u32                  mask = 1 << offset;
+	struct pxa_gpio_chip *pxa;
+
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+
+	if (value)
+		__raw_writel(mask, pxa->regbase + GPSR_OFFSET);
+	else
+		__raw_writel(mask, pxa->regbase + GPCR_OFFSET);
+}
+
+struct pxa_gpio_chip pxa_gpio_chip[] = {
+	[0] = {
+		.regbase = GPIO0_BASE,
+		.chip = {
+			.label            = "gpio-0",
+			.direction_input  = pxa_gpio_direction_input,
+			.direction_output = pxa_gpio_direction_output,
+			.get              = pxa_gpio_get,
+			.set              = pxa_gpio_set,
+			.base             = 0,
+			.ngpio            = 32,
+		},
+	},
+	[1] = {
+		.regbase = GPIO1_BASE,
+		.chip = {
+			.label            = "gpio-1",
+			.direction_input  = pxa_gpio_direction_input,
+			.direction_output = pxa_gpio_direction_output,
+			.get              = pxa_gpio_get,
+			.set              = pxa_gpio_set,
+			.base             = 32,
+			.ngpio            = 32,
+		},
+	},
+	[2] = {
+		.regbase = GPIO2_BASE,
+		.chip = {
+			.label            = "gpio-2",
+			.direction_input  = pxa_gpio_direction_input,
+			.direction_output = pxa_gpio_direction_output,
+			.get              = pxa_gpio_get,
+			.set              = pxa_gpio_set,
+			.base             = 64,
+			.ngpio            = 32, /* 21 for PXA25x */
+		},
+	},
+#if defined(CONFIG_PXA27x) || defined(CONFIG_PXA3xx)
+	[3] = {
+		.regbase = GPIO3_BASE,
+		.chip = {
+			.label            = "gpio-3",
+			.direction_input  = pxa_gpio_direction_input,
+			.direction_output = pxa_gpio_direction_output,
+			.get              = pxa_gpio_get,
+			.set              = pxa_gpio_set,
+			.base             = 96,
+			.ngpio            = 32,
+		},
+	},
+#endif
+};
+
+void __init pxa_init_gpio(int gpio_nr)
+{
+	int i;
+
+	/* add a GPIO chip for each register bank.
+	 * the last PXA25x register only contains 21 GPIOs
+	 */
+	for (i = 0; i < gpio_nr; i += 32) {
+		if (i+32 > gpio_nr)
+			pxa_gpio_chip[i/32].chip.ngpio = gpio_nr - i;
+		gpiochip_add(&pxa_gpio_chip[i/32].chip);
+	}
+}
diff -puN arch/arm/mach-pxa/irq.c~arm-pxa-gpiolib-support arch/arm/mach-pxa/irq.c
--- a/arch/arm/mach-pxa/irq.c~arm-pxa-gpiolib-support
+++ a/arch/arm/mach-pxa/irq.c
@@ -310,6 +310,8 @@ void __init pxa_init_irq_gpio(int gpio_n
 	/* Install handler for GPIO>=2 edge detect interrupts */
 	set_irq_chip(IRQ_GPIO_2_x, &pxa_internal_chip_low);
 	set_irq_chained_handler(IRQ_GPIO_2_x, pxa_gpio_demux_handler);
+
+	pxa_init_gpio(gpio_nr);
 }
 
 void __init pxa_init_irq_set_wake(int (*set_wake)(unsigned int, unsigned int))
diff -puN arch/arm/mach-pxa/Makefile~arm-pxa-gpiolib-support arch/arm/mach-pxa/Makefile
--- a/arch/arm/mach-pxa/Makefile~arm-pxa-gpiolib-support
+++ a/arch/arm/mach-pxa/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Common support (must be linked before board specific support)
-obj-y				+= clock.o generic.o irq.o dma.o time.o
+obj-y				+= clock.o generic.o gpio.o irq.o dma.o time.o
 obj-$(CONFIG_PXA25x)		+= pxa25x.o
 obj-$(CONFIG_PXA27x)		+= pxa27x.o
 obj-$(CONFIG_PXA3xx)		+= pxa3xx.o mfp.o
diff -puN include/asm-arm/arch-pxa/gpio.h~arm-pxa-gpiolib-support include/asm-arm/arch-pxa/gpio.h
--- a/include/asm-arm/arch-pxa/gpio.h~arm-pxa-gpiolib-support
+++ a/include/asm-arm/arch-pxa/gpio.h
@@ -28,43 +28,35 @@
 #include <asm/irq.h>
 #include <asm/hardware.h>
 
-static inline int gpio_request(unsigned gpio, const char *label)
-{
-	return 0;
-}
+#include <asm-generic/gpio.h>
 
-static inline void gpio_free(unsigned gpio)
-{
-	return;
-}
 
-extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio, int value);
+/* NOTE: some PXAs have fewer on-chip GPIOs (like PXA255, with 85).
+ * Those cases currently cause holes in the GPIO number space.
+ */
+#define NR_BUILTIN_GPIO 128
 
-static inline int __gpio_get_value(unsigned gpio)
+static inline int gpio_get_value(unsigned gpio)
 {
-	return GPLR(gpio) & GPIO_bit(gpio);
+	if (__builtin_constant_p(gpio) && (gpio < NR_BUILTIN_GPIO))
+		return GPLR(gpio) & GPIO_bit(gpio);
+	else
+		return __gpio_get_value(gpio);
 }
 
-#define gpio_get_value(gpio)			\
-	(__builtin_constant_p(gpio) ?		\
-	 __gpio_get_value(gpio) :		\
-	 pxa_gpio_get_value(gpio))
-
-static inline void __gpio_set_value(unsigned gpio, int value)
+static inline void gpio_set_value(unsigned gpio, int value)
 {
-	if (value)
-		GPSR(gpio) = GPIO_bit(gpio);
-	else
-		GPCR(gpio) = GPIO_bit(gpio);
+	if (__builtin_constant_p(gpio) && (gpio < NR_BUILTIN_GPIO)) {
+		if (value)
+			GPSR(gpio) = GPIO_bit(gpio);
+		else
+			GPCR(gpio) = GPIO_bit(gpio);
+	} else {
+		__gpio_set_value(gpio, value);
+	}
 }
 
-#define gpio_set_value(gpio,value)		\
-	(__builtin_constant_p(gpio) ?		\
-	 __gpio_set_value(gpio, value) :	\
-	 pxa_gpio_set_value(gpio, value))
-
-#include <asm-generic/gpio.h>			/* cansleep wrappers */
+#define gpio_cansleep __gpio_cansleep
 
 #define gpio_to_irq(gpio)	IRQ_GPIO(gpio)
 #define irq_to_gpio(irq)	IRQ_TO_GPIO(irq)
diff -puN include/asm-arm/arch-pxa/pxa-regs.h~arm-pxa-gpiolib-support include/asm-arm/arch-pxa/pxa-regs.h
--- a/include/asm-arm/arch-pxa/pxa-regs.h~arm-pxa-gpiolib-support
+++ a/include/asm-arm/arch-pxa/pxa-regs.h
@@ -1128,6 +1128,19 @@
  * General Purpose I/O
  */
 
+#define GPIO0_BASE	((void __iomem *)io_p2v(0x40E00000))
+#define GPIO1_BASE	((void __iomem *)io_p2v(0x40E00004))
+#define GPIO2_BASE	((void __iomem *)io_p2v(0x40E00008))
+#define GPIO3_BASE	((void __iomem *)io_p2v(0x40E00100))
+
+#define GPLR_OFFSET	0x00
+#define GPDR_OFFSET	0x0C
+#define GPSR_OFFSET	0x18
+#define GPCR_OFFSET	0x24
+#define GRER_OFFSET	0x30
+#define GFER_OFFSET	0x3C
+#define GEDR_OFFSET	0x48
+
 #define GPLR0		__REG(0x40E00000)  /* GPIO Pin-Level Register GPIO<31:0> */
 #define GPLR1		__REG(0x40E00004)  /* GPIO Pin-Level Register GPIO<63:32> */
 #define GPLR2		__REG(0x40E00008)  /* GPIO Pin-Level Register GPIO<80:64> */
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

git-arm.patch
arm-pxa-gpiolib-support.patch
