From: akpm@linux-foundation.org
Subject: - gpio-api-pxa-wrapper-cleanup.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:32 -0800
Message-ID: <200702211046.l1LAkWQ1006478@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47022 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161192AbXBUKrm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:47:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, dbrownell@users.sourceforge.net, nico@cam.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     GPIO API: PXA wrapper cleanup
has been removed from the -mm tree.  Its filename was
     gpio-api-pxa-wrapper-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: GPIO API: PXA wrapper cleanup
From: Philipp Zabel <philipp.zabel@gmail.com>

Based on the discussion last december (http://lkml.org/lkml/2006/12/20/242),
this patch:

  - moves the PXA_LAST_GPIO check into pxa_gpio_mode
  - fixes comment and includes in gpio.h
  - replaces the gpio_set/get_value macros with inline
    functions and adds a non-inline version to avoid
    code explosion when gpio is not a constant.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Nicolas Pitre <nico@cam.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/generic.c         |   28 ++++++++++++++++-
 include/asm-arm/arch-pxa/gpio.h     |   42 +++++++++++++++-----------
 include/asm-arm/arch-pxa/hardware.h |   12 ++++++-
 3 files changed, 63 insertions(+), 19 deletions(-)

diff -puN arch/arm/mach-pxa/generic.c~gpio-api-pxa-wrapper-cleanup arch/arm/mach-pxa/generic.c
--- a/arch/arm/mach-pxa/generic.c~gpio-api-pxa-wrapper-cleanup
+++ a/arch/arm/mach-pxa/generic.c
@@ -36,6 +36,7 @@
 #include <asm/mach/map.h>
 
 #include <asm/arch/pxa-regs.h>
+#include <asm/arch/gpio.h>
 #include <asm/arch/udc.h>
 #include <asm/arch/pxafb.h>
 #include <asm/arch/mmc.h>
@@ -106,13 +107,16 @@ unsigned long long sched_clock(void)
  * Handy function to set GPIO alternate functions
  */
 
-void pxa_gpio_mode(int gpio_mode)
+int pxa_gpio_mode(int gpio_mode)
 {
 	unsigned long flags;
 	int gpio = gpio_mode & GPIO_MD_MASK_NR;
 	int fn = (gpio_mode & GPIO_MD_MASK_FN) >> 8;
 	int gafr;
 
+	if (gpio > PXA_LAST_GPIO)
+		return -EINVAL;
+
 	local_irq_save(flags);
 	if (gpio_mode & GPIO_DFLT_LOW)
 		GPCR(gpio) = GPIO_bit(gpio);
@@ -125,11 +129,33 @@ void pxa_gpio_mode(int gpio_mode)
 	gafr = GAFR(gpio) & ~(0x3 << (((gpio) & 0xf)*2));
 	GAFR(gpio) = gafr |  (fn  << (((gpio) & 0xf)*2));
 	local_irq_restore(flags);
+
+	return 0;
 }
 
 EXPORT_SYMBOL(pxa_gpio_mode);
 
 /*
+ * Return GPIO level
+ */
+int pxa_gpio_get_value(unsigned gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+EXPORT_SYMBOL(pxa_gpio_get_value);
+
+/*
+ * Set output GPIO level
+ */
+void pxa_gpio_set_value(unsigned gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+EXPORT_SYMBOL(pxa_gpio_set_value);
+
+/*
  * Routine to safely enable or disable a clock in the CKEN
  */
 void pxa_set_cken(int clock, int enable)
diff -puN include/asm-arm/arch-pxa/gpio.h~gpio-api-pxa-wrapper-cleanup include/asm-arm/arch-pxa/gpio.h
--- a/include/asm-arm/arch-pxa/gpio.h~gpio-api-pxa-wrapper-cleanup
+++ a/include/asm-arm/arch-pxa/gpio.h
@@ -25,10 +25,8 @@
 #define __ASM_ARCH_PXA_GPIO_H
 
 #include <asm/arch/pxa-regs.h>
-#include <asm/arch/irqs.h>
-#include <asm/arch/hardware.h>
-
-#include <asm/errno.h>
+#include <asm/irq.h>
+#include <asm/hardware.h>
 
 static inline int gpio_request(unsigned gpio, const char *label)
 {
@@ -42,26 +40,36 @@ static inline void gpio_free(unsigned gp
 
 static inline int gpio_direction_input(unsigned gpio)
 {
-	if (gpio > PXA_LAST_GPIO)
-		return -EINVAL;
-	pxa_gpio_mode(gpio | GPIO_IN);
+	return pxa_gpio_mode(gpio | GPIO_IN);
 }
 
 static inline int gpio_direction_output(unsigned gpio)
 {
-	if (gpio > PXA_LAST_GPIO)
-		return -EINVAL;
-	pxa_gpio_mode(gpio | GPIO_OUT);
+	return pxa_gpio_mode(gpio | GPIO_OUT);
+}
+
+static inline int __gpio_get_value(unsigned gpio)
+{
+	return GPLR(gpio) & GPIO_bit(gpio);
 }
 
-/* REVISIT these macros are correct, but suffer code explosion
- * for non-constant parameters.  Provide out-line versions too.
- */
-#define gpio_get_value(gpio) \
-	(GPLR(gpio) & GPIO_bit(gpio))
+#define gpio_get_value(gpio)			\
+	(__builtin_constant_p(gpio) ?		\
+	 __gpio_get_value(gpio) :		\
+	 pxa_gpio_get_value(gpio))
+
+static inline void __gpio_set_value(unsigned gpio, int value)
+{
+	if (value)
+		GPSR(gpio) = GPIO_bit(gpio);
+	else
+		GPCR(gpio) = GPIO_bit(gpio);
+}
 
-#define gpio_set_value(gpio,value) \
-	((value) ? (GPSR(gpio) = GPIO_bit(gpio)):(GPCR(gpio) = GPIO_bit(gpio)))
+#define gpio_set_value(gpio,value)		\
+	(__builtin_constant_p(gpio) ?		\
+	 __gpio_set_value(gpio, value) :	\
+	 pxa_gpio_set_value(gpio, value))
 
 #include <asm-generic/gpio.h>			/* cansleep wrappers */
 
diff -puN include/asm-arm/arch-pxa/hardware.h~gpio-api-pxa-wrapper-cleanup include/asm-arm/arch-pxa/hardware.h
--- a/include/asm-arm/arch-pxa/hardware.h~gpio-api-pxa-wrapper-cleanup
+++ a/include/asm-arm/arch-pxa/hardware.h
@@ -65,7 +65,17 @@
 /*
  * Handy routine to set GPIO alternate functions
  */
-extern void pxa_gpio_mode( int gpio_mode );
+extern int pxa_gpio_mode( int gpio_mode );
+
+/*
+ * Return GPIO level, nonzero means high, zero is low
+ */
+extern int pxa_gpio_get_value(unsigned gpio);
+
+/*
+ * Set output GPIO level
+ */
+extern void pxa_gpio_set_value(unsigned gpio, int value);
 
 /*
  * Routine to enable or disable CKEN
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are
