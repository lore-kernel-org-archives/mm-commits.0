From: akpm@linux-foundation.org
Subject: + gpio-api-s3c2410-wrapper-cleanup-2.patch added to -mm tree
Date: Fri, 16 Feb 2007 13:25:28 -0800
Message-ID: <200702162125.l1GLPS5p010258@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36740 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946263AbXBPVZn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 16:25:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.zabel@gmail.com, dbrownell@users.sourceforge.net


The patch titled
     GPIO API: S3C2410 wrapper cleanup
has been added to the -mm tree.  Its filename is
     gpio-api-s3c2410-wrapper-cleanup-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: GPIO API: S3C2410 wrapper cleanup
From: Philipp Zabel <philipp.zabel@gmail.com>

this one adds an #include <asm/arch/regs-gpio.h>.
Tested by Roman Moravcik on s3c2440.

Based on the discussion last december
(http://lkml.org/lkml/2006/12/20/243), this patch
 - fixes comment and includes in gpio.h
 - adds the gpio_to_irq definition for S3C2400
 - includes asm/arch/regs-gpio.h for pin direction
   definitions

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/arch-s3c2410/gpio.h |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff -puN include/asm-arm/arch-s3c2410/gpio.h~gpio-api-s3c2410-wrapper-cleanup-2 include/asm-arm/arch-s3c2410/gpio.h
--- a/include/asm-arm/arch-s3c2410/gpio.h~gpio-api-s3c2410-wrapper-cleanup-2
+++ a/include/asm-arm/arch-s3c2410/gpio.h
@@ -1,7 +1,7 @@
 /*
- * linux/include/asm-arm/arch-pxa/gpio.h
+ * linux/include/asm-arm/arch-s3c2410/gpio.h
  *
- * S3C2400 GPIO wrappers for arch-neutral GPIO calls
+ * S3C2410 GPIO wrappers for arch-neutral GPIO calls
  *
  * Written by Philipp Zabel <philipp.zabel@gmail.com>
  *
@@ -21,14 +21,12 @@
  *
  */
 
-#ifndef __ASM_ARCH_PXA_GPIO_H
-#define __ASM_ARCH_PXA_GPIO_H
+#ifndef __ASM_ARCH_S3C2410_GPIO_H
+#define __ASM_ARCH_S3C2410_GPIO_H
 
-#include <asm/arch/pxa-regs.h>
-#include <asm/arch/irqs.h>
-#include <asm/arch/hardware.h>
-
-#include <asm/errno.h>
+#include <asm/irq.h>
+#include <asm/hardware.h>
+#include <asm/arch/regs-gpio.h>
 
 static inline int gpio_request(unsigned gpio, const char *label)
 {
@@ -57,8 +55,11 @@ static inline int gpio_direction_output(
 
 #include <asm-generic/gpio.h>			/* cansleep wrappers */
 
-/* FIXME or maybe s3c2400_gpio_getirq() ... */
+#ifdef CONFIG_CPU_S3C2400
+#define gpio_to_irq(gpio)		s3c2400_gpio_getirq(gpio)
+#else
 #define gpio_to_irq(gpio)		s3c2410_gpio_getirq(gpio)
+#endif
 
 /* FIXME implement irq_to_gpio() */
 
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

origin.patch
gpio-api-pxa-wrapper-cleanup.patch
gpio-api-s3c2410-wrapper-cleanup-2.patch
