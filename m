From: akpm@linux-foundation.org
Subject: - call-percpu-smp-cacheline-algin-interface.patch removed from -mm tree
Date: Tue, 15 May 2007 16:40:28 -0700
Message-ID: <200705152343.l4FNhY5N021128@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53986 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758391AbXEOXql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 19:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fenghua.yu@intel.com, clameter@sgi.com, kiran@scalex86.org, linux-arch@vger.kernel.org, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     Call percpu smp cacheline algin interface
has been removed from the -mm tree.  Its filename was
     call-percpu-smp-cacheline-algin-interface.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Call percpu smp cacheline algin interface
From: Fenghua Yu <fenghua.yu@intel.com>

Call percpu smp cacheline align interface.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/init_task.c   |    2 +-
 arch/i386/kernel/irq.c         |    2 +-
 arch/ia64/kernel/smp.c         |    2 +-
 arch/x86_64/kernel/init_task.c |    2 +-
 kernel/sched.c                 |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/init_task.c~call-percpu-smp-cacheline-algin-interface arch/i386/kernel/init_task.c
--- a/arch/i386/kernel/init_task.c~call-percpu-smp-cacheline-algin-interface
+++ a/arch/i386/kernel/init_task.c
@@ -42,5 +42,5 @@ EXPORT_SYMBOL(init_task);
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's.
  */ 
-DEFINE_PER_CPU(struct tss_struct, init_tss) ____cacheline_internodealigned_in_smp = INIT_TSS;
+DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
 
diff -puN arch/i386/kernel/irq.c~call-percpu-smp-cacheline-algin-interface arch/i386/kernel/irq.c
--- a/arch/i386/kernel/irq.c~call-percpu-smp-cacheline-algin-interface
+++ a/arch/i386/kernel/irq.c
@@ -21,7 +21,7 @@
 #include <asm/apic.h>
 #include <asm/uaccess.h>
 
-DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
+DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
diff -puN arch/ia64/kernel/smp.c~call-percpu-smp-cacheline-algin-interface arch/ia64/kernel/smp.c
--- a/arch/ia64/kernel/smp.c~call-percpu-smp-cacheline-algin-interface
+++ a/arch/ia64/kernel/smp.c
@@ -82,7 +82,7 @@ static volatile struct call_data_struct 
 #define IPI_KDUMP_CPU_STOP	3
 
 /* This needs to be cacheline aligned because it is written to by *other* CPUs.  */
-static DEFINE_PER_CPU(u64, ipi_operation) ____cacheline_aligned;
+static DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(u64, ipi_operation);
 
 extern void cpu_halt (void);
 
diff -puN arch/x86_64/kernel/init_task.c~call-percpu-smp-cacheline-algin-interface arch/x86_64/kernel/init_task.c
--- a/arch/x86_64/kernel/init_task.c~call-percpu-smp-cacheline-algin-interface
+++ a/arch/x86_64/kernel/init_task.c
@@ -44,7 +44,7 @@ EXPORT_SYMBOL(init_task);
  * section. Since TSS's are completely CPU-local, we want them
  * on exact cacheline boundaries, to eliminate cacheline ping-pong.
  */ 
-DEFINE_PER_CPU(struct tss_struct, init_tss) ____cacheline_internodealigned_in_smp = INIT_TSS;
+DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
 
 /* Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
diff -puN kernel/sched.c~call-percpu-smp-cacheline-algin-interface kernel/sched.c
--- a/kernel/sched.c~call-percpu-smp-cacheline-algin-interface
+++ a/kernel/sched.c
@@ -304,7 +304,7 @@ struct rq {
 	struct lock_class_key rq_lock_key;
 };
 
-static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(struct rq, runqueues);
 static DEFINE_MUTEX(sched_hotcpu_mutex);
 
 static inline int cpu_of(struct rq *rq)
_

Patches currently in -mm which might be from fenghua.yu@intel.com are

call-percpu-smp-cacheline-algin-interface.patch
