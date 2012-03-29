From: akpm@linux-foundation.org
Subject: [merged] smp-add-func-to-ipi-cpus-based-on-parameter-func.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:31 -0700
Message-ID: <20120329191331.AF952A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:61032 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933689Ab2C2TNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:33 -0400
Received: by ghbz15 with SMTP id z15so303836ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, a.p.zijlstra@chello.nl, andi@firstfloor.org, avi@redhat.com, cl@linux-foundation.org, cmetcalf@tilera.com, fweisbec@gmail.com, kosaki.motohiro@gmail.com, levinsasha928@gmail.com, linux@arm.linux.org.uk, miltonm@bga.com, mina86@mina86.org, mpm@selenic.com, penberg@kernel.org, riel@redhat.com, srivatsa.bhat@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: smp: add func to IPI cpus based on parameter func
has been removed from the -mm tree.  Its filename was
     smp-add-func-to-ipi-cpus-based-on-parameter-func.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: smp: add func to IPI cpus based on parameter func

Add the on_each_cpu_cond() function that wraps on_each_cpu_mask() and
calculates the cpumask of cpus to IPI by calling a function supplied as a
parameter in order to determine whether to IPI each specific cpu.

The function works around allocation failure of cpumask variable in
CONFIG_CPUMASK_OFFSTACK=y by itereating over cpus sending an IPI a time
via smp_call_function_single().

The function is useful since it allows to seperate the specific code that
decided in each case whether to IPI a specific cpu for a specific request
from the common boilerplate code of handling creating the mask, handling
failures etc.

[akpm@linux-foundation.org: s/gfpflags/gfp_flags/]
[akpm@linux-foundation.org: avoid double-evaluation of `info' (per Michal), parenthesise evaluation of `cond_func']
[akpm@linux-foundation.org: s/CPU/CPUs, use all 80 cols in comment]
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Avi Kivity <avi@redhat.com>
Acked-by: Michal Nazarewicz <mina86@mina86.org>
Cc: Kosaki Motohiro <kosaki.motohiro@gmail.com>
Cc: Milton Miller <miltonm@bga.com>
Reviewed-by: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   24 ++++++++++++++++
 kernel/smp.c        |   61 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff -puN include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func include/linux/smp.h
--- a/include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func
+++ a/include/linux/smp.h
@@ -109,6 +109,15 @@ void on_each_cpu_mask(const struct cpuma
 		void *info, bool wait);
 
 /*
+ * Call a function on each processor for which the supplied function
+ * cond_func returns a positive value. This may include the local
+ * processor.
+ */
+void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
+		smp_call_func_t func, void *info, bool wait,
+		gfp_t gfp_flags);
+
+/*
  * Mark the boot cpu "online" so that it can call console drivers in
  * printk() and can access its per-cpu storage.
  */
@@ -153,6 +162,21 @@ static inline int up_smp_call_function(s
 			local_irq_enable();		\
 		}					\
 	} while (0)
+/*
+ * Preemption is disabled here to make sure the cond_func is called under the
+ * same condtions in UP and SMP.
+ */
+#define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags)\
+	do {							\
+		void *__info = (info);				\
+		preempt_disable();				\
+		if ((cond_func)(0, __info)) {			\
+			local_irq_disable();			\
+			(func)(__info);				\
+			local_irq_enable();			\
+		}						\
+		preempt_enable();				\
+	} while (0)
 
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
diff -puN kernel/smp.c~smp-add-func-to-ipi-cpus-based-on-parameter-func kernel/smp.c
--- a/kernel/smp.c~smp-add-func-to-ipi-cpus-based-on-parameter-func
+++ a/kernel/smp.c
@@ -730,3 +730,64 @@ void on_each_cpu_mask(const struct cpuma
 	put_cpu();
 }
 EXPORT_SYMBOL(on_each_cpu_mask);
+
+/*
+ * on_each_cpu_cond(): Call a function on each processor for which
+ * the supplied function cond_func returns true, optionally waiting
+ * for all the required CPUs to finish. This may include the local
+ * processor.
+ * @cond_func:	A callback function that is passed a cpu id and
+ *		the the info parameter. The function is called
+ *		with preemption disabled. The function should
+ *		return a blooean value indicating whether to IPI
+ *		the specified CPU.
+ * @func:	The function to run on all applicable CPUs.
+ *		This must be fast and non-blocking.
+ * @info:	An arbitrary pointer to pass to both functions.
+ * @wait:	If true, wait (atomically) until function has
+ *		completed on other CPUs.
+ * @gfp_flags:	GFP flags to use when allocating the cpumask
+ *		used internally by the function.
+ *
+ * The function might sleep if the GFP flags indicates a non
+ * atomic allocation is allowed.
+ *
+ * Preemption is disabled to protect against CPUs going offline but not online.
+ * CPUs going online during the call will not be seen or sent an IPI.
+ *
+ * You must not call this function with disabled interrupts or
+ * from a hardware interrupt handler or from a bottom half handler.
+ */
+void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
+			smp_call_func_t func, void *info, bool wait,
+			gfp_t gfp_flags)
+{
+	cpumask_var_t cpus;
+	int cpu, ret;
+
+	might_sleep_if(gfp_flags & __GFP_WAIT);
+
+	if (likely(zalloc_cpumask_var(&cpus, (gfp_flags|__GFP_NOWARN)))) {
+		preempt_disable();
+		for_each_online_cpu(cpu)
+			if (cond_func(cpu, info))
+				cpumask_set_cpu(cpu, cpus);
+		on_each_cpu_mask(cpus, func, info, wait);
+		preempt_enable();
+		free_cpumask_var(cpus);
+	} else {
+		/*
+		 * No free cpumask, bother. No matter, we'll
+		 * just have to IPI them one by one.
+		 */
+		preempt_disable();
+		for_each_online_cpu(cpu)
+			if (cond_func(cpu, info)) {
+				ret = smp_call_function_single(cpu, func,
+								info, wait);
+				WARN_ON_ONCE(!ret);
+			}
+		preempt_enable();
+	}
+}
+EXPORT_SYMBOL(on_each_cpu_cond);
_

Patches currently in -mm which might be from gilad@benyossef.com are

origin.patch

