From: akpm@linux-foundation.org
Subject: [merged] kernel-clean-up-use_generic_smp_helpers.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:04:07 -0800
Message-ID: <201101132006.p0DK6mTc029775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933646Ab1AMUUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, a.p.zijlstra@chello.nl, dhowells@redhat.com, hpa@zytor.com, mingo@elte.hu, randy.dunlap@oracle.com, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel: clean up USE_GENERIC_SMP_HELPERS
has been removed from the -mm tree.  Its filename was
     kernel-clean-up-use_generic_smp_helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel: clean up USE_GENERIC_SMP_HELPERS
From: Amerigo Wang <amwang@redhat.com>

For arch which needs USE_GENERIC_SMP_HELPERS, it has to select
USE_GENERIC_SMP_HELPERS, rather than leaving a choice to user, since they
don't provide their own implementions.

Also, move on_each_cpu() to kernel/smp.c, it is strange to put it in
kernel/softirq.c.

For arch which doesn't use USE_GENERIC_SMP_HELPERS, e.g.  blackfin, only
on_each_cpu() is compiled.

Signed-off-by: Amerigo Wang <amwang@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/Kconfig |    6 +-----
 arch/x86/Kconfig     |    5 +----
 kernel/Makefile      |    2 +-
 kernel/smp.c         |   20 ++++++++++++++++++++
 kernel/softirq.c     |   19 -------------------
 5 files changed, 23 insertions(+), 29 deletions(-)

diff -puN arch/mn10300/Kconfig~kernel-clean-up-use_generic_smp_helpers arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~kernel-clean-up-use_generic_smp_helpers
+++ a/arch/mn10300/Kconfig
@@ -203,6 +203,7 @@ endmenu
 config SMP
 	bool "Symmetric multi-processing support"
 	default y
+	select USE_GENERIC_SMP_HELPERS
 	depends on MN10300_PROC_MN2WS0038 || MN10300_PROC_MN2WS0050
 	---help---
 	  This enables support for systems with more than one CPU. If you have
@@ -226,11 +227,6 @@ config NR_CPUS
 	depends on SMP
 	default "2"
 
-config USE_GENERIC_SMP_HELPERS
-	bool
-	depends on SMP
-	default y
-
 source "kernel/Kconfig.preempt"
 
 config MN10300_CURRENT_IN_E2
diff -puN arch/x86/Kconfig~kernel-clean-up-use_generic_smp_helpers arch/x86/Kconfig
--- a/arch/x86/Kconfig~kernel-clean-up-use_generic_smp_helpers
+++ a/arch/x86/Kconfig
@@ -65,6 +65,7 @@ config X86
 	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
+	select USE_GENERIC_SMP_HELPERS if SMP
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
@@ -203,10 +204,6 @@ config HAVE_INTEL_TXT
 	def_bool y
 	depends on EXPERIMENTAL && DMAR && ACPI
 
-config USE_GENERIC_SMP_HELPERS
-	def_bool y
-	depends on SMP
-
 config X86_32_SMP
 	def_bool y
 	depends on X86_32 && SMP
diff -puN kernel/Makefile~kernel-clean-up-use_generic_smp_helpers kernel/Makefile
--- a/kernel/Makefile~kernel-clean-up-use_generic_smp_helpers
+++ a/kernel/Makefile
@@ -43,7 +43,7 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
-obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
+obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
diff -puN kernel/smp.c~kernel-clean-up-use_generic_smp_helpers kernel/smp.c
--- a/kernel/smp.c~kernel-clean-up-use_generic_smp_helpers
+++ a/kernel/smp.c
@@ -13,6 +13,7 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 
+#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 static struct {
 	struct list_head	queue;
 	raw_spinlock_t		lock;
@@ -529,3 +530,22 @@ void ipi_call_unlock_irq(void)
 {
 	raw_spin_unlock_irq(&call_function.lock);
 }
+#endif /* USE_GENERIC_SMP_HELPERS */
+
+/*
+ * Call a function on all processors
+ */
+int on_each_cpu(void (*func) (void *info), void *info, int wait)
+{
+	int ret = 0;
+
+	preempt_disable();
+	ret = smp_call_function(func, info, wait);
+	local_irq_disable();
+	func(info);
+	local_irq_enable();
+	preempt_enable();
+	return ret;
+}
+EXPORT_SYMBOL(on_each_cpu);
+
diff -puN kernel/softirq.c~kernel-clean-up-use_generic_smp_helpers kernel/softirq.c
--- a/kernel/softirq.c~kernel-clean-up-use_generic_smp_helpers
+++ a/kernel/softirq.c
@@ -885,25 +885,6 @@ static __init int spawn_ksoftirqd(void)
 }
 early_initcall(spawn_ksoftirqd);
 
-#ifdef CONFIG_SMP
-/*
- * Call a function on all processors
- */
-int on_each_cpu(void (*func) (void *info), void *info, int wait)
-{
-	int ret = 0;
-
-	preempt_disable();
-	ret = smp_call_function(func, info, wait);
-	local_irq_disable();
-	func(info);
-	local_irq_enable();
-	preempt_enable();
-	return ret;
-}
-EXPORT_SYMBOL(on_each_cpu);
-#endif
