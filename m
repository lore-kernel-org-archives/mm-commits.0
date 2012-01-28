From: akpm@linux-foundation.org
Subject: + smp-introduce-a-generic-on_each_cpu_mask-function.patch added to -mm tree
Date: Fri, 27 Jan 2012 16:15:36 -0800
Message-ID: <20120128001537.4F512A043A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:42520 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2A1APi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 19:15:38 -0500
Received: by ghrr20 with SMTP id r20so83366ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 16:15:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gilad@benyossef.com, a.p.zijlstra@chello.nl, andi@firstfloor.org, avi@redhat.com, cl@linux.com, cmetcalf@tilera.com, fweisbec@gmail.com, kosaki.motohiro@gmail.com, levinsasha928@gmail.com, linux@arm.linux.org.uk, mel@csn.ul.ie, miltonm@bga.com, mina86@mina86.org, mpm@selenic.com, penberg@kernel.org, riel@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: smp: introduce a generic on_each_cpu_mask() function
has been added to the -mm tree.  Its filename is
     smp-introduce-a-generic-on_each_cpu_mask-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: smp: introduce a generic on_each_cpu_mask() function

We have lots of infrastructure in place to partition multi-core systems
such that we have a group of CPUs that are dedicated to specific task:
cgroups, scheduler and interrupt affinity, and cpuisol= boot parameter. 
Still, kernel code will at times interrupt all CPUs in the system via IPIs
for various needs.  These IPIs are useful and cannot be avoided
altogether, but in certain cases it is possible to interrupt only specific
CPUs that have useful work to do and not the entire system.

This patch set, inspired by discussions with Peter Zijlstra and Frederic
Weisbecker when testing the nohz task patch set, is a first stab at trying
to explore doing this by locating the places where such global IPI calls
are being made and turning the global IPI into an IPI for a specific group
of CPUs.  The purpose of the patch set is to get feedback if this is the
right way to go for dealing with this issue and indeed, if the issue is
even worth dealing with at all.  Based on the feedback from this patch set
I plan to offer further patches that address similar issue in other code
paths.

This patchset creates an on_each_cpu_mask() and on_each_cpu_cond()
infrastructure API (the former derived from existing arch specific
versions in Tile and Arm) and uses them to turn several global IPI
invocation to per CPU group invocations.


This patch:

on_each_cpu_mask() calls a function on processors specified by cpumask,
which may or may not include the local processor.

You must not call this function with disabled interrupts or from a
hardware interrupt handler or from a bottom half handler.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Avi Kivity <avi@redhat.com>
Cc: Michal Nazarewicz <mina86@mina86.org>
Cc: Kosaki Motohiro <kosaki.motohiro@gmail.com>
Cc: Milton Miller <miltonm@bga.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   22 ++++++++++++++++++++++
 kernel/smp.c        |   29 +++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff -puN include/linux/smp.h~smp-introduce-a-generic-on_each_cpu_mask-function include/linux/smp.h
--- a/include/linux/smp.h~smp-introduce-a-generic-on_each_cpu_mask-function
+++ a/include/linux/smp.h
@@ -102,6 +102,13 @@ static inline void call_function_init(vo
 int on_each_cpu(smp_call_func_t func, void *info, int wait);
 
 /*
+ * Call a function on processors specified by mask, which might include
+ * the local one.
+ */
+void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
+		void *info, bool wait);
+
+/*
  * Mark the boot cpu "online" so that it can call console drivers in
  * printk() and can access its per-cpu storage.
  */
@@ -132,6 +139,21 @@ static inline int up_smp_call_function(s
 		local_irq_enable();		\
 		0;				\
 	})
+/*
+ * Note we still need to test the mask even for UP
+ * because we actually can get an empty mask from
+ * code that on SMP might call us without the local
+ * CPU in the mask.
+ */
+#define on_each_cpu_mask(mask, func, info, wait) \
+	do {						\
+		if (cpumask_test_cpu(0, (mask))) {	\
+			local_irq_disable();		\
+			(func)(info);			\
+			local_irq_enable();		\
+		}					\
+	} while (0)
+
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
diff -puN kernel/smp.c~smp-introduce-a-generic-on_each_cpu_mask-function kernel/smp.c
--- a/kernel/smp.c~smp-introduce-a-generic-on_each_cpu_mask-function
+++ a/kernel/smp.c
@@ -701,3 +701,32 @@ int on_each_cpu(void (*func) (void *info
 	return ret;
 }
 EXPORT_SYMBOL(on_each_cpu);
+
+/**
+ * on_each_cpu_mask(): Run a function on processors specified by
+ * cpumask, which may include the local processor.
+ * @mask: The set of cpus to run on (only runs on online subset).
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @wait: If true, wait (atomically) until function has completed
+ *        on other CPUs.
+ *
+ * If @wait is true, then returns once @func has returned.
+ *
+ * You must not call this function with disabled interrupts or
+ * from a hardware interrupt handler or from a bottom half handler.
+ */
+void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
+			void *info, bool wait)
+{
+	int cpu = get_cpu();
+
+	smp_call_function_many(mask, func, info, wait);
+	if (cpumask_test_cpu(cpu, mask)) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+	}
+	put_cpu();
+}
+EXPORT_SYMBOL(on_each_cpu_mask);
_
Subject: Subject: smp: introduce a generic on_each_cpu_mask() function

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
tile-move-tile-to-use-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

