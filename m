From: akpm@linux-foundation.org
Subject: [merged]
 mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:05:08 -0700
Message-ID: <55ef2354.vIG5FVQ6L/rdaa13%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbbIHSFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, dave.hansen@intel.com, mhocko@suse.com, mingo@kernel.org, riel@redhat.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: send one IPI per CPU to TLB flush all entries after unmapping pages
has been removed from the -mm tree.  Its filename was
     mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: send one IPI per CPU to TLB flush all entries after unmapping pages

An IPI is sent to flush remote TLBs when a page is unmapped that was
potentially accesssed by other CPUs.  There are many circumstances where
this happens but the obvious one is kswapd reclaiming pages belonging to a
running process as kswapd and the task are likely running on separate
CPUs.

On small machines, this is not a significant problem but as machine gets
larger with more cores and more memory, the cost of these IPIs can be
high.  This patch uses a simple structure that tracks CPUs that
potentially have TLB entries for pages being unmapped.  When the unmapping
is complete, the full TLB is flushed on the assumption that a refill cost
is lower than flushing individual entries.

Architectures wishing to do this must give the following guarantee.

	If a clean page is unmapped and not immediately flushed, the
	architecture must guarantee that a write to that linear address
	from a CPU with a cached TLB entry will trap a page fault.

This is essentially what the kernel already depends on but the window is
much larger with this patch applied and is worth highlighting.  The
architecture should consider whether the cost of the full TLB flush is
higher than sending an IPI to flush each individual entry.  An additional
architecture helper called flush_tlb_local is required.  It's a trivial
wrapper with some accounting in the x86 case.

The impact of this patch depends on the workload as measuring any benefit
requires both mapped pages co-located on the LRU and memory pressure.  The
case with the biggest impact is multiple processes reading mapped pages
taken from the vm-scalability test suite.  The test case uses NR_CPU
readers of mapped files that consume 10*RAM.

Linear mapped reader on a 4-node machine with 64G RAM and 48 CPUs

                                           4.2.0-rc1          4.2.0-rc1
                                             vanilla       flushfull-v7
Ops lru-file-mmap-read-elapsed      159.62 (  0.00%)   120.68 ( 24.40%)
Ops lru-file-mmap-read-time_range    30.59 (  0.00%)     2.80 ( 90.85%)
Ops lru-file-mmap-read-time_stddv     6.70 (  0.00%)     0.64 ( 90.38%)

           4.2.0-rc1    4.2.0-rc1
             vanilla flushfull-v7
User          581.00       611.43
System       5804.93      4111.76
Elapsed       161.03       122.12

This is showing that the readers completed 24.40% faster with 29% less
system CPU time.  From vmstats, it is known that the vanilla kernel was
interrupted roughly 900K times per second during the steady phase of the
test and the patched kernel was interrupts 180K times per second.

The impact is lower on a single socket machine.

                                           4.2.0-rc1          4.2.0-rc1
                                             vanilla       flushfull-v7
Ops lru-file-mmap-read-elapsed       25.33 (  0.00%)    20.38 ( 19.54%)
Ops lru-file-mmap-read-time_range     0.91 (  0.00%)     1.44 (-58.24%)
Ops lru-file-mmap-read-time_stddv     0.28 (  0.00%)     0.47 (-65.34%)

           4.2.0-rc1    4.2.0-rc1
             vanilla flushfull-v7
User           58.09        57.64
System        111.82        76.56
Elapsed        27.29        22.55

It's still a noticeable improvement with vmstat showing interrupts went
from roughly 500K per second to 45K per second.

The patch will have no impact on workloads with no memory pressure or have
relatively few mapped pages.  It will have an unpredictable impact on the
workload running on the CPU being flushed as it'll depend on how many TLB
entries need to be refilled and how long that takes.  Worst case, the TLB
will be completely cleared of active entries when the target PFNs were not
resident at all.

[sasha.levin@oracle.com: trace tlb flush after disabling preemption in try_to_unmap_flush]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                |    1 
 arch/x86/include/asm/tlbflush.h |    6 +
 include/linux/rmap.h            |    3 
 include/linux/sched.h           |   16 ++++
 init/Kconfig                    |   10 ++
 mm/internal.h                   |   11 +++
 mm/rmap.c                       |  104 +++++++++++++++++++++++++++++-
 mm/vmscan.c                     |   23 ++++++
 8 files changed, 172 insertions(+), 2 deletions(-)

diff -puN arch/x86/Kconfig~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages
+++ a/arch/x86/Kconfig
@@ -41,6 +41,7 @@ config X86
 	select ARCH_USE_CMPXCHG_LOCKREF		if X86_64
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
+	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH if SMP
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_IPC_PARSE_VERSION	if X86_32
diff -puN arch/x86/include/asm/tlbflush.h~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages arch/x86/include/asm/tlbflush.h
--- a/arch/x86/include/asm/tlbflush.h~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages
+++ a/arch/x86/include/asm/tlbflush.h
@@ -261,6 +261,12 @@ static inline void reset_lazy_tlbstate(v
 
 #endif	/* SMP */
 
+/* Not inlined due to inc_irq_stat not being defined yet */
+#define flush_tlb_local() {		\
+	inc_irq_stat(irq_tlb_count);	\
+	local_flush_tlb();		\
+}
+
 #ifndef CONFIG_PARAVIRT
 #define flush_tlb_others(mask, mm, start, end)	\
 	native_flush_tlb_others(mask, mm, start, end)
diff -puN include/linux/rmap.h~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages include/linux/rmap.h
--- a/include/linux/rmap.h~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages
+++ a/include/linux/rmap.h
@@ -89,6 +89,9 @@ enum ttu_flags {
 	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
 	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
 	TTU_IGNORE_HWPOISON = (1 << 10),/* corrupted page is recoverable */
+	TTU_BATCH_FLUSH = (1 << 11),	/* Batch TLB flushes where possible
+					 * and caller guarantees they will
+					 * do a final flush if necessary */
 };
 
 #ifdef CONFIG_MMU
diff -puN include/linux/sched.h~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages include/linux/sched.h
--- a/include/linux/sched.h~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages
+++ a/include/linux/sched.h
@@ -1344,6 +1344,18 @@ enum perf_event_task_context {
 	perf_nr_task_contexts,
 };
 
+/* Track pages that require TLB flushes */
+struct tlbflush_unmap_batch {
+	/*
+	 * Each bit set is a CPU that potentially has a TLB entry for one of
+	 * the PFNs being flushed. See set_tlb_ubc_flush_pending().
+	 */
+	struct cpumask cpumask;
+
+	/* True if any bit in cpumask is set */
+	bool flush_required;
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1700,6 +1712,10 @@ struct task_struct {
 	unsigned long numa_pages_migrated;
 #endif /* CONFIG_NUMA_BALANCING */
 
+#ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
+	struct tlbflush_unmap_batch tlb_ubc;
+#endif
+
 	struct rcu_head rcu;
 
 	/*
diff -puN init/Kconfig~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages init/Kconfig
--- a/init/Kconfig~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages
+++ a/init/Kconfig
@@ -883,6 +883,16 @@ config ARCH_SUPPORTS_NUMA_BALANCING
 	bool
 
 #
+# For architectures that prefer to flush all TLBs after a number of pages
+# are unmapped instead of sending one IPI per page to flush. The architecture
+# must provide guarantees on what happens if a clean TLB cache entry is
+# written after the unmap. Details are in mm/rmap.c near the check for
+# should_defer_flush. The architecture should also consider if the full flush
+# and the refill costs are offset by the savings of sending fewer IPIs.
+config ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
+	bool
+
+#
 # For architectures that know their GCC __int128 support is sound
 #
 config ARCH_SUPPORTS_INT128
diff -puN mm/internal.h~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages mm/internal.h
--- a/mm/internal.h~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages
+++ a/mm/internal.h
@@ -426,4 +426,15 @@ unsigned long reclaim_clean_pages_from_l
 #define ALLOC_CMA		0x80 /* allow allocations from CMA areas */
 #define ALLOC_FAIR		0x100 /* fair zone allocation */
 
+enum ttu_flags;
+struct tlbflush_unmap_batch;
+
+#ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
+void try_to_unmap_flush(void);
+#else
+static inline void try_to_unmap_flush(void)
+{
+}
+
+#endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
 #endif	/* __MM_INTERNAL_H */
diff -puN mm/rmap.c~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages mm/rmap.c
--- a/mm/rmap.c~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages
+++ a/mm/rmap.c
@@ -62,6 +62,8 @@
 
 #include <asm/tlbflush.h>
 
+#include <trace/events/tlb.h>
+
 #include "internal.h"
 
 static struct kmem_cache *anon_vma_cachep;
@@ -583,6 +585,89 @@ vma_address(struct page *page, struct vm
 	return address;
 }
 
+#ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
+static void percpu_flush_tlb_batch_pages(void *data)
+{
+	/*
+	 * All TLB entries are flushed on the assumption that it is
+	 * cheaper to flush all TLBs and let them be refilled than
+	 * flushing individual PFNs. Note that we do not track mm's
+	 * to flush as that might simply be multiple full TLB flushes
+	 * for no gain.
+	 */
+	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
+	flush_tlb_local();
+}
+
+/*
+ * Flush TLB entries for recently unmapped pages from remote CPUs. It is
+ * important if a PTE was dirty when it was unmapped that it's flushed
+ * before any IO is initiated on the page to prevent lost writes. Similarly,
+ * it must be flushed before freeing to prevent data leakage.
+ */
+void try_to_unmap_flush(void)
+{
+	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
+	int cpu;
+
+	if (!tlb_ubc->flush_required)
+		return;
+
+	cpu = get_cpu();
+
+	trace_tlb_flush(TLB_REMOTE_SHOOTDOWN, -1UL);
+
+	if (cpumask_test_cpu(cpu, &tlb_ubc->cpumask))
+		percpu_flush_tlb_batch_pages(&tlb_ubc->cpumask);
+
+	if (cpumask_any_but(&tlb_ubc->cpumask, cpu) < nr_cpu_ids) {
+		smp_call_function_many(&tlb_ubc->cpumask,
+			percpu_flush_tlb_batch_pages, (void *)tlb_ubc, true);
+	}
+	cpumask_clear(&tlb_ubc->cpumask);
+	tlb_ubc->flush_required = false;
+	put_cpu();
+}
+
+static void set_tlb_ubc_flush_pending(struct mm_struct *mm,
+		struct page *page)
+{
+	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
+
+	cpumask_or(&tlb_ubc->cpumask, &tlb_ubc->cpumask, mm_cpumask(mm));
+	tlb_ubc->flush_required = true;
+}
+
+/*
+ * Returns true if the TLB flush should be deferred to the end of a batch of
+ * unmap operations to reduce IPIs.
+ */
+static bool should_defer_flush(struct mm_struct *mm, enum ttu_flags flags)
+{
+	bool should_defer = false;
+
+	if (!(flags & TTU_BATCH_FLUSH))
+		return false;
+
+	/* If remote CPUs need to be flushed then defer batch the flush */
+	if (cpumask_any_but(mm_cpumask(mm), get_cpu()) < nr_cpu_ids)
+		should_defer = true;
+	put_cpu();
+
+	return should_defer;
+}
+#else
+static void set_tlb_ubc_flush_pending(struct mm_struct *mm,
+		struct page *page)
+{
+}
+
+static bool should_defer_flush(struct mm_struct *mm, enum ttu_flags flags)
+{
+	return false;
+}
+#endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
+
 /*
  * At what user virtual address is page expected in vma?
  * Caller should check the page is actually part of the vma.
@@ -1220,7 +1305,24 @@ static int try_to_unmap_one(struct page
 
 	/* Nuke the page table entry. */
 	flush_cache_page(vma, address, page_to_pfn(page));
-	pteval = ptep_clear_flush(vma, address, pte);
+	if (should_defer_flush(mm, flags)) {
+		/*
+		 * We clear the PTE but do not flush so potentially a remote
+		 * CPU could still be writing to the page. If the entry was
+		 * previously clean then the architecture must guarantee that
+		 * a clear->dirty transition on a cached TLB entry is written
+		 * through and traps if the PTE is unmapped.
+		 */
+		pteval = ptep_get_and_clear(mm, address, pte);
+
+		/* Potentially writable TLBs must be flushed before IO */
+		if (pte_dirty(pteval))
+			flush_tlb_page(vma, address);
+		else
+			set_tlb_ubc_flush_pending(mm, page);
+	} else {
+		pteval = ptep_clear_flush(vma, address, pte);
+	}
 
 	/* Move the dirty bit to the physical page now the pte is gone. */
 	if (pte_dirty(pteval))
diff -puN mm/vmscan.c~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages mm/vmscan.c
--- a/mm/vmscan.c~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages
+++ a/mm/vmscan.c
@@ -1057,7 +1057,8 @@ static unsigned long shrink_page_list(st
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page) && mapping) {
-			switch (try_to_unmap(page, ttu_flags)) {
+			switch (try_to_unmap(page,
+					ttu_flags|TTU_BATCH_FLUSH)) {
 			case SWAP_FAIL:
 				goto activate_locked;
 			case SWAP_AGAIN:
@@ -1208,6 +1209,7 @@ keep:
 	}
 
 	mem_cgroup_uncharge_list(&free_pages);
+	try_to_unmap_flush();
 	free_hot_cold_page_list(&free_pages, true);
 
 	list_splice(&ret_pages, page_list);
@@ -2151,6 +2153,23 @@ out:
 	}
 }
 
+#ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
+static void init_tlb_ubc(void)
+{
+	/*
+	 * This deliberately does not clear the cpumask as it's expensive
+	 * and unnecessary. If there happens to be data in there then the
+	 * first SWAP_CLUSTER_MAX pages will send an unnecessary IPI and
+	 * then will be cleared.
+	 */
+	current->tlb_ubc.flush_required = false;
+}
+#else
+static inline void init_tlb_ubc(void)
+{
+}
+#endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
+
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
@@ -2185,6 +2204,8 @@ static void shrink_lruvec(struct lruvec
 	scan_adjusted = (global_reclaim(sc) && !current_is_kswapd() &&
 			 sc->priority == DEF_PRIORITY);
 
+	init_tlb_ubc();
+
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch

