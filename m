From: akpm@linux-foundation.org
Subject: [merged] watchdog-introduce-arch_touch_nmi_watchdog.patch
 removed from -mm tree
Date: Thu, 13 Jul 2017 13:42:00 -0700
Message-ID: <20170713204200.ygG1q9WTV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59404 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUmB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: babu.moger@oracle.com, benh@kernel.crashing.org, dzickus@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com, paulus@samba.org


The patch titled
     Subject: kernel/watchdog: introduce arch_touch_nmi_watchdog()
has been removed from the -mm tree.  Its filename was
     watchdog-introduce-arch_touch_nmi_watchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: kernel/watchdog: introduce arch_touch_nmi_watchdog()

For architectures that define HAVE_NMI_WATCHDOG, instead of having them
provide the complete touch_nmi_watchdog() function, just have them provide
arch_touch_nmi_watchdog().

This gives the generic code more flexibility in implementing this
function, and arch implementations don't miss out on touching the
softlockup watchdog or other generic details.

Link: http://lkml.kernel.org/r/20170616065715.18390-3-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Babu Moger <babu.moger@oracle.com>
Tested-by: Babu Moger <babu.moger@oracle.com>	[sparc]
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/nmi.h            |    2 +
 arch/blackfin/kernel/nmi.c                 |    2 -
 arch/mn10300/include/asm/nmi.h             |    2 +
 arch/mn10300/kernel/mn10300-watchdog-low.S |    8 ++---
 arch/mn10300/kernel/mn10300-watchdog.c     |    2 -
 arch/sparc/include/asm/nmi.h               |    1 
 arch/sparc/kernel/nmi.c                    |    6 +---
 include/linux/nmi.h                        |   27 +++++++++++--------
 kernel/watchdog_hld.c                      |    5 +--
 9 files changed, 31 insertions(+), 24 deletions(-)

diff -puN arch/blackfin/include/asm/nmi.h~watchdog-introduce-arch_touch_nmi_watchdog arch/blackfin/include/asm/nmi.h
--- a/arch/blackfin/include/asm/nmi.h~watchdog-introduce-arch_touch_nmi_watchdog
+++ a/arch/blackfin/include/asm/nmi.h
@@ -9,4 +9,6 @@
 
 #include <linux/nmi.h>
 
+extern void arch_touch_nmi_watchdog(void);
+
 #endif
diff -puN arch/blackfin/kernel/nmi.c~watchdog-introduce-arch_touch_nmi_watchdog arch/blackfin/kernel/nmi.c
--- a/arch/blackfin/kernel/nmi.c~watchdog-introduce-arch_touch_nmi_watchdog
+++ a/arch/blackfin/kernel/nmi.c
@@ -190,7 +190,7 @@ static int __init init_nmi_wdt(void)
 }
 device_initcall(init_nmi_wdt);
 
-void touch_nmi_watchdog(void)
+void arch_touch_nmi_watchdog(void)
 {
 	atomic_set(&nmi_touched[smp_processor_id()], 1);
 }
diff -puN arch/mn10300/include/asm/nmi.h~watchdog-introduce-arch_touch_nmi_watchdog arch/mn10300/include/asm/nmi.h
--- a/arch/mn10300/include/asm/nmi.h~watchdog-introduce-arch_touch_nmi_watchdog
+++ a/arch/mn10300/include/asm/nmi.h
@@ -11,4 +11,6 @@
 #ifndef _ASM_NMI_H
 #define _ASM_NMI_H
 
+extern void arch_touch_nmi_watchdog(void);
+
 #endif /* _ASM_NMI_H */
diff -puN arch/mn10300/kernel/mn10300-watchdog-low.S~watchdog-introduce-arch_touch_nmi_watchdog arch/mn10300/kernel/mn10300-watchdog-low.S
--- a/arch/mn10300/kernel/mn10300-watchdog-low.S~watchdog-introduce-arch_touch_nmi_watchdog
+++ a/arch/mn10300/kernel/mn10300-watchdog-low.S
@@ -50,9 +50,9 @@ watchdog_handler:
 #   we can't inline it)
 #
 ###############################################################################
-	.globl	touch_nmi_watchdog
-	.type	touch_nmi_watchdog,@function
-touch_nmi_watchdog:
+	.globl	arch_touch_nmi_watchdog
+	.type	arch_touch_nmi_watchdog,@function
+arch_touch_nmi_watchdog:
 	clr	d0
 	clr	d1
 	mov	watchdog_alert_counter, a0
@@ -63,4 +63,4 @@ touch_nmi_watchdog:
 	lne
 	ret	[],0
 
-	.size	touch_nmi_watchdog,.-touch_nmi_watchdog
+	.size	arch_touch_nmi_watchdog,.-arch_touch_nmi_watchdog
diff -puN arch/mn10300/kernel/mn10300-watchdog.c~watchdog-introduce-arch_touch_nmi_watchdog arch/mn10300/kernel/mn10300-watchdog.c
--- a/arch/mn10300/kernel/mn10300-watchdog.c~watchdog-introduce-arch_touch_nmi_watchdog
+++ a/arch/mn10300/kernel/mn10300-watchdog.c
@@ -31,7 +31,7 @@ static unsigned int watchdog;
 static unsigned int watchdog_hz = 1;
 unsigned int watchdog_alert_counter[NR_CPUS];
 
-EXPORT_SYMBOL(touch_nmi_watchdog);
+EXPORT_SYMBOL(arch_touch_nmi_watchdog);
 
 /*
  * the best way to detect whether a CPU has a 'hard lockup' problem
diff -puN arch/sparc/include/asm/nmi.h~watchdog-introduce-arch_touch_nmi_watchdog arch/sparc/include/asm/nmi.h
--- a/arch/sparc/include/asm/nmi.h~watchdog-introduce-arch_touch_nmi_watchdog
+++ a/arch/sparc/include/asm/nmi.h
@@ -7,6 +7,7 @@ void nmi_adjust_hz(unsigned int new_hz);
 
 extern atomic_t nmi_active;
 
+void arch_touch_nmi_watchdog(void);
 void start_nmi_watchdog(void *unused);
 void stop_nmi_watchdog(void *unused);
 
diff -puN arch/sparc/kernel/nmi.c~watchdog-introduce-arch_touch_nmi_watchdog arch/sparc/kernel/nmi.c
--- a/arch/sparc/kernel/nmi.c~watchdog-introduce-arch_touch_nmi_watchdog
+++ a/arch/sparc/kernel/nmi.c
@@ -51,7 +51,7 @@ static DEFINE_PER_CPU(unsigned int, last
 static DEFINE_PER_CPU(long, alert_counter);
 static DEFINE_PER_CPU(int, nmi_touch);
 
-void touch_nmi_watchdog(void)
+void arch_touch_nmi_watchdog(void)
 {
 	if (atomic_read(&nmi_active)) {
 		int cpu;
@@ -61,10 +61,8 @@ void touch_nmi_watchdog(void)
 				per_cpu(nmi_touch, cpu) = 1;
 		}
 	}
-
-	touch_softlockup_watchdog();
 }
-EXPORT_SYMBOL(touch_nmi_watchdog);
+EXPORT_SYMBOL(arch_touch_nmi_watchdog);
 
 static void die_nmi(const char *str, struct pt_regs *regs, int do_panic)
 {
diff -puN include/linux/nmi.h~watchdog-introduce-arch_touch_nmi_watchdog include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-introduce-arch_touch_nmi_watchdog
+++ a/include/linux/nmi.h
@@ -6,6 +6,9 @@
 
 #include <linux/sched.h>
 #include <asm/irq.h>
+#if defined(CONFIG_HAVE_NMI_WATCHDOG)
+#include <asm/nmi.h>
+#endif
 
 #ifdef CONFIG_LOCKUP_DETECTOR
 extern void touch_softlockup_watchdog_sched(void);
@@ -58,6 +61,18 @@ static inline void reset_hung_task_detec
 #define NMI_WATCHDOG_ENABLED      (1 << NMI_WATCHDOG_ENABLED_BIT)
 #define SOFT_WATCHDOG_ENABLED     (1 << SOFT_WATCHDOG_ENABLED_BIT)
 
+#if defined(CONFIG_HARDLOCKUP_DETECTOR)
+extern void hardlockup_detector_disable(void);
+#else
+static inline void hardlockup_detector_disable(void) {}
+#endif
+
+#if defined(CONFIG_HARDLOCKUP_DETECTOR) || defined(CONFIG_HAVE_NMI_WATCHDOG)
+extern void arch_touch_nmi_watchdog(void);
+#else
+static inline void arch_touch_nmi_watchdog(void) {}
+#endif
+
 /**
  * touch_nmi_watchdog - restart NMI watchdog timeout.
  * 
@@ -65,21 +80,11 @@ static inline void reset_hung_task_detec
  * may be used to reset the timeout - for code which intentionally
  * disables interrupts for a long time. This call is stateless.
  */
-#if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
-#include <asm/nmi.h>
-extern void touch_nmi_watchdog(void);
-#else
 static inline void touch_nmi_watchdog(void)
 {
+	arch_touch_nmi_watchdog();
 	touch_softlockup_watchdog();
 }
-#endif
-
-#if defined(CONFIG_HARDLOCKUP_DETECTOR)
-extern void hardlockup_detector_disable(void);
-#else
-static inline void hardlockup_detector_disable(void) {}
-#endif
 
 /*
  * Create trigger_all_cpu_backtrace() out of the arch-provided
diff -puN kernel/watchdog_hld.c~watchdog-introduce-arch_touch_nmi_watchdog kernel/watchdog_hld.c
--- a/kernel/watchdog_hld.c~watchdog-introduce-arch_touch_nmi_watchdog
+++ a/kernel/watchdog_hld.c
@@ -56,7 +56,7 @@ static int __init hardlockup_panic_setup
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
 
-void touch_nmi_watchdog(void)
+void arch_touch_nmi_watchdog(void)
 {
 	/*
 	 * Using __raw here because some code paths have
@@ -66,9 +66,8 @@ void touch_nmi_watchdog(void)
 	 * going off.
 	 */
 	raw_cpu_write(watchdog_nmi_touch, true);
-	touch_softlockup_watchdog();
 }
-EXPORT_SYMBOL(touch_nmi_watchdog);
+EXPORT_SYMBOL(arch_touch_nmi_watchdog);
 
 static struct perf_event_attr wd_hw_attr = {
 	.type		= PERF_TYPE_HARDWARE,
_

Patches currently in -mm which might be from npiggin@gmail.com are


