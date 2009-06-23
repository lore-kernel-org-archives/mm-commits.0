From: akpm@linux-foundation.org
Subject: [wrecked] xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch removed from -mm tree
Date: Tue, 23 Jun 2009 11:04:55 -0700
Message-ID: <200906231804.n5NI4tvV008897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbZFWSFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 14:05:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dg@emlix.com, chris@zankel.net, jw@emlix.com, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: allow platform and variant to initialize own irq chips
has been removed from the -mm tree.  Its filename was
     xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: allow platform and variant to initialize own irq chips
From: Daniel Glockner <dg@emlix.com>

There was already a PLATFORM_NR_IRQS define, which is now accompanied
by a VARIANT_NR_IRQS. To be able to initialize these interrupts,
init_IRQ now calls variant and platform specific hooks.

Signed-off-by: Daniel Glockner <dg@emlix.com>
Cc: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/irq.h                     |   21 ++++++++++--
 arch/xtensa/kernel/irq.c                          |    3 +
 arch/xtensa/variants/dc232b/include/variant/irq.h |    4 ++
 arch/xtensa/variants/fsf/include/variant/irq.h    |    4 ++
 4 files changed, 29 insertions(+), 3 deletions(-)

diff -puN arch/xtensa/include/asm/irq.h~xtensa-allow-platform-and-variant-to-initialize-own-irq-chips arch/xtensa/include/asm/irq.h
--- a/arch/xtensa/include/asm/irq.h~xtensa-allow-platform-and-variant-to-initialize-own-irq-chips
+++ a/arch/xtensa/include/asm/irq.h
@@ -11,21 +11,36 @@
 #ifndef _XTENSA_IRQ_H
 #define _XTENSA_IRQ_H
 
+#include <linux/init.h>
 #include <platform/hardware.h>
 #include <variant/core.h>
 
-#ifdef CONFIG_VARIANT_IRQ_SWITCH
 #include <variant/irq.h>
-#else
+#ifndef CONFIG_VARIANT_IRQ_SWITCH
 static inline void variant_irq_enable(unsigned int irq) { }
 static inline void variant_irq_disable(unsigned int irq) { }
 #endif
 
+#ifndef VARIANT_NR_IRQS
+# define VARIANT_NR_IRQS 0
+#endif
 #ifndef PLATFORM_NR_IRQS
 # define PLATFORM_NR_IRQS 0
 #endif
 #define XTENSA_NR_IRQS XCHAL_NUM_INTERRUPTS
-#define NR_IRQS (XTENSA_NR_IRQS + PLATFORM_NR_IRQS)
+#define NR_IRQS (XTENSA_NR_IRQS + VARIANT_NR_IRQS + PLATFORM_NR_IRQS)
+
+#if VARIANT_NR_IRQS == 0
+static inline void variant_init_IRQ(void) { }
+#else
+void variant_init_IRQ(void) __init;
+#endif
+
+#if PLATFORM_NR_IRQS == 0
+static inline void platform_init_IRQ(void) { }
+#else
+void platform_init_IRQ(void) __init;
+#endif
 
 static __inline__ int irq_canonicalize(int irq)
 {
diff -puN arch/xtensa/kernel/irq.c~xtensa-allow-platform-and-variant-to-initialize-own-irq-chips arch/xtensa/kernel/irq.c
--- a/arch/xtensa/kernel/irq.c~xtensa-allow-platform-and-variant-to-initialize-own-irq-chips
+++ a/arch/xtensa/kernel/irq.c
@@ -197,4 +197,7 @@ void __init init_IRQ(void)
 	}
 
 	cached_irq_mask = 0;
+
+	variant_init_IRQ();
+	platform_init_IRQ();
 }
diff -puN /dev/null arch/xtensa/variants/dc232b/include/variant/irq.h
--- /dev/null
+++ a/arch/xtensa/variants/dc232b/include/variant/irq.h
@@ -0,0 +1,4 @@
+#ifndef __XTENSA_VARIANT_IRQ_H
+#define __XTENSA_VARIANT_IRQ_H
+
+#endif
diff -puN /dev/null arch/xtensa/variants/fsf/include/variant/irq.h
--- /dev/null
+++ a/arch/xtensa/variants/fsf/include/variant/irq.h
@@ -0,0 +1,4 @@
+#ifndef __XTENSA_VARIANT_IRQ_H
+#define __XTENSA_VARIANT_IRQ_H
+
+#endif
_

Patches currently in -mm which might be from dg@emlix.com are

origin.patch
xtensa-variant-specific-code.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
xtensa-add-m41t62-rtc-to-s6105-platform.patch
xtensa-enable-m41t80-driver-in-s6105_defconfig.patch

