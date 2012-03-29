From: akpm@linux-foundation.org
Subject: [merged] smp-introduce-a-generic-on_each_cpu_mask-function.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:28 -0700
Message-ID: <20120329191328.E78DAA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:53794 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933746Ab2C2TNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:30 -0400
Received: by ggnd2 with SMTP id d2so301772ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, a.p.zijlstra@chello.nl, andi@firstfloor.org, avi@redhat.com, cl@linux.com, cmetcalf@tilera.com, fweisbec@gmail.com, kosaki.motohiro@gmail.com, levinsasha928@gmail.com, linux@arm.linux.org.uk, mel@csn.ul.ie, miltonm@bga.com, mina86@mina86.org, mpm@selenic.com, penberg@kernel.org, riel@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: smp: introduce a generic on_each_cpu_mask() function
has been removed from the -mm tree.  Its filename was
     smp-introduce-a-generic-on_each_cpu_mask-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

This patch creates an on_each_cpu_mask() and on_each_cpu_cond()
infrastructure API (the former derived from existing arch specific
versions in Tile and Arm) and uses them to turn several global IPI
invocation to per CPU group invocations.


Core kernel:

on_each_cpu_mask() calls a function on processors specified by cpumask,
which may or may not include the local processor.

You must not call this function with disabled interrupts or from a
hardware interrupt handler or from a bottom half handler.

arch/arm:

Note that the generic version is a little different then the Arm one:

1. It has the mask as first parameter
2. It calls the function on the calling CPU with interrupts disabled,
   but this should be OK since the function is called on the other CPUs
   with interrupts disabled anyway.

arch/tile:

The API is the same as the tile private one, but the generic version
also calls the function on the with interrupts disabled in UP case

This is OK since the function is called on the other CPUs
with interrupts disabled.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
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
Acked-by: Michal Nazarewicz <mina86@mina86.org>
Cc: Kosaki Motohiro <kosaki.motohiro@gmail.com>
Cc: Milton Miller <miltonm@bga.com>
Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/smp_tlb.c   |   20 +++++---------------
 arch/tile/include/asm/smp.h |    7 -------
 arch/tile/kernel/smp.c      |   19 -------------------
 include/linux/smp.h         |   22 ++++++++++++++++++++++
 kernel/smp.c                |   29 +++++++++++++++++++++++++++++
 5 files changed, 56 insertions(+), 41 deletions(-)

diff -puN arch/arm/kernel/smp_tlb.c~smp-introduce-a-generic-on_each_cpu_mask-function arch/arm/kernel/smp_tlb.c
--- a/arch/arm/kernel/smp_tlb.c~smp-introduce-a-generic-on_each_cpu_mask-function
+++ a/arch/arm/kernel/smp_tlb.c
@@ -13,18 +13,6 @@
 #include <asm/smp_plat.h>
 #include <asm/tlbflush.h>
 
-static void on_each_cpu_mask(void (*func)(void *), void *info, int wait,
-	const struct cpumask *mask)
-{
-	preempt_disable();
-
-	smp_call_function_many(mask, func, info, wait);
-	if (cpumask_test_cpu(smp_processor_id(), mask))
-		func(info);
-
-	preempt_enable();
-}
-
 /**********************************************************************/
 
 /*
@@ -87,7 +75,7 @@ void flush_tlb_all(void)
 void flush_tlb_mm(struct mm_struct *mm)
 {
 	if (tlb_ops_need_broadcast())
-		on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, mm_cpumask(mm));
+		on_each_cpu_mask(mm_cpumask(mm), ipi_flush_tlb_mm, mm, 1);
 	else
 		local_flush_tlb_mm(mm);
 }
@@ -98,7 +86,8 @@ void flush_tlb_page(struct vm_area_struc
 		struct tlb_args ta;
 		ta.ta_vma = vma;
 		ta.ta_start = uaddr;
-		on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, mm_cpumask(vma->vm_mm));
+		on_each_cpu_mask(mm_cpumask(vma->vm_mm), ipi_flush_tlb_page,
+					&ta, 1);
 	} else
 		local_flush_tlb_page(vma, uaddr);
 }
@@ -121,7 +110,8 @@ void flush_tlb_range(struct vm_area_stru
 		ta.ta_vma = vma;
 		ta.ta_start = start;
 		ta.ta_end = end;
-		on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, mm_cpumask(vma->vm_mm));
+		on_each_cpu_mask(mm_cpumask(vma->vm_mm), ipi_flush_tlb_range,
+					&ta, 1);
 	} else
 		local_flush_tlb_range(vma, start, end);
 }
diff -puN arch/tile/include/asm/smp.h~smp-introduce-a-generic-on_each_cpu_mask-function arch/tile/include/asm/smp.h
--- a/arch/tile/include/asm/smp.h~smp-introduce-a-generic-on_each_cpu_mask-function
+++ a/arch/tile/include/asm/smp.h
@@ -43,10 +43,6 @@ void evaluate_message(int tag);
 /* Boot a secondary cpu */
 void online_secondary(void);
 
-/* Call a function on a specified set of CPUs (may include this one). */
-extern void on_each_cpu_mask(const struct cpumask *mask,
-			     void (*func)(void *), void *info, bool wait);
-
 /* Topology of the supervisor tile grid, and coordinates of boot processor */
 extern HV_Topology smp_topology;
 
@@ -91,9 +87,6 @@ void print_disabled_cpus(void);
 
 #else /* !CONFIG_SMP */
 
-#define on_each_cpu_mask(mask, func, info, wait)		\
-  do { if (cpumask_test_cpu(0, (mask))) func(info); } while (0)
-
 #define smp_master_cpu		0
 #define smp_height		1
 #define smp_width		1
diff -puN arch/tile/kernel/smp.c~smp-introduce-a-generic-on_each_cpu_mask-function arch/tile/kernel/smp.c
--- a/arch/tile/kernel/smp.c~smp-introduce-a-generic-on_each_cpu_mask-function
+++ a/arch/tile/kernel/smp.c
@@ -87,25 +87,6 @@ void send_IPI_allbutself(int tag)
 	send_IPI_many(&mask, tag);
 }
 
-
-/*
- * Provide smp_call_function_mask, but also run function locally
- * if specified in the mask.
- */
-void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
-		      void *info, bool wait)
-{
-	int cpu = get_cpu();
-	smp_call_function_many(mask, func, info, wait);
-	if (cpumask_test_cpu(cpu, mask)) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-	}
-	put_cpu();
-}
-
-
 /*
  * Functions related to starting/stopping cpus.
  */
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

Patches currently in -mm which might be from gilad@benyossef.com are

origin.patch

