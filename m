From: akpm@linux-foundation.org
Subject: - gpio-api-sa1100-wrapper-cleanup.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:55 -0800
Message-ID: <200702211046.l1LAktxE006505@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47038 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161213AbXBUKrz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:47:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     GPIO API: SA1100 wrapper cleanup
has been removed from the -mm tree.  Its filename was
     gpio-api-sa1100-wrapper-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: GPIO API: SA1100 wrapper cleanup
From: Philipp Zabel <philipp.zabel@gmail.com>

Based on the discussion last december (http://lkml.org/lkml/2006/12/20/241),
this patch
  - adds gpio_direction_input/output functions to
    generic.c instead of making them inline,
  - fixes comment and includes and uses inline functions
    instead of macros in gpio.h

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-sa1100/generic.c     |   30 +++++++++++++++++++++++
 include/asm-arm/arch-sa1100/gpio.h |   34 +++++++++++----------------
 2 files changed, 44 insertions(+), 20 deletions(-)

diff -puN arch/arm/mach-sa1100/generic.c~gpio-api-sa1100-wrapper-cleanup arch/arm/mach-sa1100/generic.c
--- a/arch/arm/mach-sa1100/generic.c~gpio-api-sa1100-wrapper-cleanup
+++ a/arch/arm/mach-sa1100/generic.c
@@ -138,6 +138,36 @@ unsigned long long sched_clock(void)
 	return v;
 }
 
+int gpio_direction_input(unsigned gpio)
+{
+	unsigned long flags;
+
+	if (gpio > GPIO_MAX)
+		return -EINVAL;
+
+	local_irq_save(flags);
+	GPDR &= ~GPIO_GPIO(gpio);
+	local_irq_restore(flags);
+	return 0;
+}
+
+EXPORT_SYMBOL(gpio_direction_input);
+
+int gpio_direction_output(unsigned gpio)
+{
+	unsigned long flags;
+
+	if (gpio > GPIO_MAX)
+		return -EINVAL;
+
+	local_irq_save(flags);
+	GPDR |= GPIO_GPIO(gpio);
+	local_irq_restore(flags);
+	return 0;
+}
+
+EXPORT_SYMBOL(gpio_direction_output);
+
 /*
  * Default power-off for SA1100
  */
diff -puN include/asm-arm/arch-sa1100/gpio.h~gpio-api-sa1100-wrapper-cleanup include/asm-arm/arch-sa1100/gpio.h
--- a/include/asm-arm/arch-sa1100/gpio.h~gpio-api-sa1100-wrapper-cleanup
+++ a/include/asm-arm/arch-sa1100/gpio.h
@@ -1,5 +1,5 @@
 /*
- * linux/include/asm-arm/arch-pxa/gpio.h
+ * linux/include/asm-arm/arch-sa1100/gpio.h
  *
  * SA1100 GPIO wrappers for arch-neutral GPIO calls
  *
@@ -24,11 +24,8 @@
 #ifndef __ASM_ARCH_SA1100_GPIO_H
 #define __ASM_ARCH_SA1100_GPIO_H
 
-#include <asm/arch/SA-1100.h>
-#include <asm/arch/irqs.h>
-#include <asm/arch/hardware.h>
-
-#include <asm/errno.h>
+#include <asm/hardware.h>
+#include <asm/irq.h>
 
 static inline int gpio_request(unsigned gpio, const char *label)
 {
@@ -40,26 +37,23 @@ static inline void gpio_free(unsigned gp
 	return;
 }
 
-static inline int gpio_direction_input(unsigned gpio)
+extern int gpio_direction_input(unsigned gpio);
+extern int gpio_direction_output(unsigned gpio);
+
+
+static inline int gpio_get_value(unsigned gpio)
 {
-	if (gpio > GPIO_MAX)
-		return -EINVAL;
-	GPDR = (GPDR_In << gpio) 0
+	return GPLR & GPIO_GPIO(gpio);
 }
 
-static inline int gpio_direction_output(unsigned gpio)
+static inline void gpio_set_value(unsigned gpio, int value)
 {
-	if (gpio > GPIO_MAX)
-		return -EINVAL;
-	GPDR = (GPDR_Out << gpio) 0
+	if (value)
+		GPSR = GPIO_GPIO(gpio);
+	else
+		GPCR = GPIO_GPIO(gpio);
 }
 
-#define gpio_get_value(gpio) \
-	(GPLR & GPIO_GPIO(gpio))
-
-#define gpio_set_value(gpio,value) \
-	((value) ? (GPSR = GPIO_GPIO(gpio)) : (GPCR(gpio) = GPIO_GPIO(gpio)))
-
 #include <asm-generic/gpio.h>			/* cansleep wrappers */
 
 static inline unsigned gpio_to_irq(unsigned gpio)
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are
