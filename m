From: akpm@linux-foundation.org
Subject: [merged] xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch removed from -mm tree
Date: Tue, 23 Jun 2009 11:05:35 -0700
Message-ID: <200906231805.n5NI5Z1r009618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753581AbZFWSFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 14:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dg@emlix.com, chris@zankel.net, jw@emlix.com, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: support s6000 gpio irqs and alternate function selection
has been removed from the -mm tree.  Its filename was
     xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: support s6000 gpio irqs and alternate function selection
From: Daniel Glockner <dg@emlix.com>

The patch implements an irq chip to handle interrupts via gpio.

As interrupts may be needed very early it is up to platform setup code
to initialize gpio by calling s6_setup_gpio. Its parameter is a bitmask
of those pins that should be configured for their alternative function.

Signed-off-by: Daniel Glockner <dg@emlix.com>
Cc: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/gpio.h                    |    8 ++++----
 arch/xtensa/variants/s6000/gpio.c                 |    5 +++++
 arch/xtensa/variants/s6000/include/variant/gpio.h |    1 +
 arch/xtensa/variants/s6000/include/variant/irq.h  |    1 +
 4 files changed, 11 insertions(+), 4 deletions(-)

diff -puN arch/xtensa/include/asm/gpio.h~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection arch/xtensa/include/asm/gpio.h
--- a/arch/xtensa/include/asm/gpio.h~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection
+++ a/arch/xtensa/include/asm/gpio.h
@@ -38,14 +38,14 @@ static inline int gpio_cansleep(unsigned
 	return __gpio_cansleep(gpio);
 }
 
-/*
- * Not implemented, yet.
- */
 static inline int gpio_to_irq(unsigned int gpio)
 {
-	return -ENOSYS;
+	return __gpio_to_irq(gpio);
 }
 
+/*
+ * Not implemented, yet.
+ */
 static inline int irq_to_gpio(unsigned int irq)
 {
 	return -EINVAL;
diff -puN arch/xtensa/variants/s6000/gpio.c~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection arch/xtensa/variants/s6000/gpio.c
--- a/arch/xtensa/variants/s6000/gpio.c~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection
+++ a/arch/xtensa/variants/s6000/gpio.c
@@ -4,15 +4,20 @@
  * Copyright (c) 2009 emlix GmbH
  * Authors:	Oskar Schirmer <os@emlix.com>
  *		Johannes Weiner <jw@emlix.com>
+ *		Daniel Gloeckner <dg@emlix.com>
  */
+#include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 #include <linux/gpio.h>
 
 #include <variant/hardware.h>
 
+#define IRQ_BASE XTENSA_NR_IRQS
+
 #define S6_GPIO_DATA		0x000
 #define S6_GPIO_IS		0x404
 #define S6_GPIO_IBE		0x408
diff -puN arch/xtensa/variants/s6000/include/variant/gpio.h~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection arch/xtensa/variants/s6000/include/variant/gpio.h
--- a/arch/xtensa/variants/s6000/include/variant/gpio.h~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection
+++ a/arch/xtensa/variants/s6000/include/variant/gpio.h
@@ -2,5 +2,6 @@
 #define _XTENSA_VARIANT_S6000_GPIO_H
 
 extern int s6_gpio_init(void);
+extern int __init s6_setup_gpio(u32 afsel);
 
 #endif /* _XTENSA_VARIANT_S6000_GPIO_H */
diff -puN arch/xtensa/variants/s6000/include/variant/irq.h~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection arch/xtensa/variants/s6000/include/variant/irq.h
--- a/arch/xtensa/variants/s6000/include/variant/irq.h~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection
+++ a/arch/xtensa/variants/s6000/include/variant/irq.h
@@ -2,6 +2,7 @@
 #define __XTENSA_S6000_IRQ_H
 
 #define NO_IRQ		(-1)
+#define VARIANT_NR_IRQS 8 /* GPIO interrupts */
 
 extern void variant_irq_enable(unsigned int irq);
 extern void variant_irq_disable(unsigned int irq);
_

Patches currently in -mm which might be from dg@emlix.com are

origin.patch
xtensa-variant-specific-code.patch

