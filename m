From: akpm@linux-foundation.org
Subject: - use-the-new-percpu-interface-for-shared-data-version-4.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:44 -0700
Message-ID: <200707192001.l6JK1iQx019564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760422AbXGSUdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fenghua.yu@intel.com, ak@suse.de, clameter@sgi.com, rusty@rustcorp.com.au, suresh.b.siddha@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     use the new percpu interface for shared data
has been removed from the -mm tree.  Its filename was
     use-the-new-percpu-interface-for-shared-data-version-4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use the new percpu interface for shared data
From: Fenghua Yu <fenghua.yu@intel.com>

Currently most of the per cpu data, which is accessed by different cpus,
has a ____cacheline_aligned_in_smp attribute.  Move all this data to the
new per cpu shared data section: .data.percpu.shared_aligned.

This will seperate the percpu data which is referenced frequently by other
cpus from the local only percpu data.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/init_task.c   |    2 +-
 arch/i386/kernel/irq.c         |    2 +-
 arch/ia64/kernel/smp.c         |    2 +-
 arch/x86_64/kernel/init_task.c |    2 +-
 kernel/sched.c                 |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/init_task.c~use-the-new-percpu-interface-for-shared-data-version-4 arch/i386/kernel/init_task.c
--- a/arch/i386/kernel/init_task.c~use-the-new-percpu-interface-for-shared-data-version-4
+++ a/arch/i386/kernel/init_task.c
@@ -42,5 +42,5 @@ EXPORT_SYMBOL(init_task);
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's.
  */ 
-DEFINE_PER_CPU(struct tss_struct, init_tss) ____cacheline_internodealigned_in_smp = INIT_TSS;
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
 
diff -puN arch/i386/kernel/irq.c~use-the-new-percpu-interface-for-shared-data-version-4 arch/i386/kernel/irq.c
--- a/arch/i386/kernel/irq.c~use-the-new-percpu-interface-for-shared-data-version-4
+++ a/arch/i386/kernel/irq.c
@@ -21,7 +21,7 @@
 #include <asm/apic.h>
 #include <asm/uaccess.h>
 
-DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
+DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
diff -puN arch/ia64/kernel/smp.c~use-the-new-percpu-interface-for-shared-data-version-4 arch/ia64/kernel/smp.c
--- a/arch/ia64/kernel/smp.c~use-the-new-percpu-interface-for-shared-data-version-4
+++ a/arch/ia64/kernel/smp.c
@@ -82,7 +82,7 @@ static volatile struct call_data_struct 
 #define IPI_KDUMP_CPU_STOP	3
 
 /* This needs to be cacheline aligned because it is written to by *other* CPUs.  */
-static DEFINE_PER_CPU(u64, ipi_operation) ____cacheline_aligned;
+static DEFINE_PER_CPU_SHARED_ALIGNED(u64, ipi_operation);
 
 extern void cpu_halt (void);
 
diff -puN arch/x86_64/kernel/init_task.c~use-the-new-percpu-interface-for-shared-data-version-4 arch/x86_64/kernel/init_task.c
--- a/arch/x86_64/kernel/init_task.c~use-the-new-percpu-interface-for-shared-data-version-4
+++ a/arch/x86_64/kernel/init_task.c
@@ -44,7 +44,7 @@ EXPORT_SYMBOL(init_task);
  * section. Since TSS's are completely CPU-local, we want them
  * on exact cacheline boundaries, to eliminate cacheline ping-pong.
  */ 
-DEFINE_PER_CPU(struct tss_struct, init_tss) ____cacheline_internodealigned_in_smp = INIT_TSS;
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
 
 /* Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
diff -puN kernel/sched.c~use-the-new-percpu-interface-for-shared-data-version-4 kernel/sched.c
--- a/kernel/sched.c~use-the-new-percpu-interface-for-shared-data-version-4
+++ a/kernel/sched.c
@@ -301,7 +301,7 @@ struct rq {
 	struct lock_class_key rq_lock_key;
 };
 
-static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 static DEFINE_MUTEX(sched_hotcpu_mutex);
 
 static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
_

Patches currently in -mm which might be from fenghua.yu@intel.com are

origin.patch
