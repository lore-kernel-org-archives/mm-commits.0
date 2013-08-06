From: akpm@linux-foundation.org
Subject: +
 smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond.patch added to -mm tree
Date: Tue, 06 Aug 2013 12:16:27 -0700
Message-ID: <52014b8b.DEVnraGbCu6V/Hts%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab3HFTQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 15:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david.daney@cavium.com

Subject: + smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond.patch added to -mm tree
To: david.daney@cavium.com
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 12:16:27 -0700


The patch titled
     Subject: smp: quit unconditionally enabling irq in on_each_cpu_mask and on_each_cpu_cond
has been added to the -mm tree.  Its filename is
     smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Daney <david.daney@cavium.com>
Subject: smp: quit unconditionally enabling irq in on_each_cpu_mask and on_each_cpu_cond

As in f21afc25f9ed (:smp.h: Use local_irq_{save,restore}() in !SMP version
of on_each_cpu()"), we don't want to enable irqs if they are not already
enabled.  There are currently no known problematical callers of these
functions, but since it is a known failure pattern, we preemptively fix
them.

Since they are not trivial functions, make them non-inline by moving them
to up.c.  This also makes it so we don't have to fix #include dependancies
for preempt_{disable,enable}.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   62 ++++++++++--------------------------------
 kernel/up.c         |   39 ++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 46 deletions(-)

diff -puN include/linux/smp.h~smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond include/linux/smp.h
--- a/include/linux/smp.h~smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond
+++ a/include/linux/smp.h
@@ -29,6 +29,22 @@ extern unsigned int total_cpus;
 int smp_call_function_single(int cpuid, smp_call_func_t func, void *info,
 			     int wait);
 
+/*
+ * Call a function on processors specified by mask, which might include
+ * the local one.
+ */
+void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
+		void *info, bool wait);
+
+/*
+ * Call a function on each processor for which the supplied function
+ * cond_func returns a positive value. This may include the local
+ * processor.
+ */
+void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
+		smp_call_func_t func, void *info, bool wait,
+		gfp_t gfp_flags);
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
@@ -101,22 +117,6 @@ static inline void call_function_init(vo
 int on_each_cpu(smp_call_func_t func, void *info, int wait);
 
 /*
- * Call a function on processors specified by mask, which might include
- * the local one.
- */
-void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
-		void *info, bool wait);
-
-/*
- * Call a function on each processor for which the supplied function
- * cond_func returns a positive value. This may include the local
- * processor.
- */
-void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
-		smp_call_func_t func, void *info, bool wait,
-		gfp_t gfp_flags);
-
-/*
  * Mark the boot cpu "online" so that it can call console drivers in
  * printk() and can access its per-cpu storage.
  */
@@ -157,36 +157,6 @@ static inline void __smp_call_function_s
 	on_each_cpu(data->func, data->info, wait);
 }
 
-/*
- * Note we still need to test the mask even for UP
- * because we actually can get an empty mask from
- * code that on SMP might call us without the local
- * CPU in the mask.
- */
-#define on_each_cpu_mask(mask, func, info, wait) \
-	do {						\
-		if (cpumask_test_cpu(0, (mask))) {	\
-			local_irq_disable();		\
-			(func)(info);			\
-			local_irq_enable();		\
-		}					\
-	} while (0)
-/*
- * Preemption is disabled here to make sure the cond_func is called under the
- * same condtions in UP and SMP.
- */
-#define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags)\
-	do {							\
-		void *__info = (info);				\
-		preempt_disable();				\
-		if ((cond_func)(0, __info)) {			\
-			local_irq_disable();			\
-			(func)(__info);				\
-			local_irq_enable();			\
-		}						\
-		preempt_enable();				\
-	} while (0)
-
 static inline void smp_send_reschedule(int cpu) { }
 #define smp_prepare_boot_cpu()			do {} while (0)
 #define smp_call_function_many(mask, func, info, wait) \
diff -puN kernel/up.c~smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond kernel/up.c
--- a/kernel/up.c~smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond
+++ a/kernel/up.c
@@ -19,3 +19,42 @@ int smp_call_function_single(int cpu, vo
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function_single);
+
+/*
+ * Note we still need to test the mask even for UP
+ * because we actually can get an empty mask from
+ * code that on SMP might call us without the local
+ * CPU in the mask.
+ */
+void on_each_cpu_mask(const struct cpumask *mask,
+		      smp_call_func_t func, void *info, bool wait)
+{
+	unsigned long flags;
+
+	if (cpumask_test_cpu(0, mask)) {
+		local_irq_save(flags);
+		func(info);
+		local_irq_restore(flags);
+	}
+}
+EXPORT_SYMBOL(on_each_cpu_mask);
+
+/*
+ * Preemption is disabled here to make sure the cond_func is called under the
+ * same condtions in UP and SMP.
+ */
+void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
+		      smp_call_func_t func, void *info, bool wait,
+		      gfp_t gfp_flags)
+{
+	unsigned long flags;
+
+	preempt_disable();
+	if (cond_func(0, info)) {
+		local_irq_save(flags);
+		func(info);
+		local_irq_restore(flags);
+	}
+	preempt_enable();
+}
+EXPORT_SYMBOL(on_each_cpu_cond);
_

Patches currently in -mm which might be from david.daney@cavium.com are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond.patch
upc-use-local_irq_saverestore-in-smp_call_function_single.patch
smph-move-smp-version-of-on_each_cpu-out-of-line.patch
linux-next.patch

