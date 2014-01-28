From: akpm@linux-foundation.org
Subject: [merged] x86-mm-account-for-tlb-flushes-only-when-debugging.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:10:05 -0800
Message-ID: <52e8008d.w9xT6JrgZ7EfP4KL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbaA1TKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:10:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@kernel.org, hughd@google.com, hpa@zytor.com, davidlohr@hp.com, alex.shi@linaro.org, mgorman@suse.de

Subject: [merged] x86-mm-account-for-tlb-flushes-only-when-debugging.patch removed from -mm tree
To: mgorman@suse.de,alex.shi@linaro.org,davidlohr@hp.com,hpa@zytor.com,hughd@google.com,mingo@kernel.org,riel@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:10:05 -0800


The patch titled
     Subject: x86: mm: account for TLB flushes only when debugging
has been removed from the -mm tree.  Its filename was
     x86-mm-account-for-tlb-flushes-only-when-debugging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: x86: mm: account for TLB flushes only when debugging

Bisection between 3.11 and 3.12 fingered commit 9824cf97 (mm: vmstats: tlb
flush counters).  The counters are undeniably useful but how often do we
really need to debug TLB flush related issues?  It does not justify taking
the penalty everywhere so make it a debugging option.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H Peter Anvin <hpa@zytor.com>
Tested-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlbflush.h    |    6 +++---
 arch/x86/kernel/cpu/mtrr/generic.c |    4 ++--
 arch/x86/mm/tlb.c                  |   14 +++++++-------
 include/linux/vm_event_item.h      |    4 +++-
 include/linux/vmstat.h             |    8 ++++++++
 mm/vmstat.c                        |    4 +++-
 6 files changed, 26 insertions(+), 14 deletions(-)

diff -puN arch/x86/include/asm/tlbflush.h~x86-mm-account-for-tlb-flushes-only-when-debugging arch/x86/include/asm/tlbflush.h
--- a/arch/x86/include/asm/tlbflush.h~x86-mm-account-for-tlb-flushes-only-when-debugging
+++ a/arch/x86/include/asm/tlbflush.h
@@ -62,7 +62,7 @@ static inline void __flush_tlb_all(void)
 
 static inline void __flush_tlb_one(unsigned long addr)
 {
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ONE);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ONE);
 	__flush_tlb_single(addr);
 }
 
@@ -93,13 +93,13 @@ static inline void __flush_tlb_one(unsig
  */
 static inline void __flush_tlb_up(void)
 {
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	__flush_tlb();
 }
 
 static inline void flush_tlb_all(void)
 {
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	__flush_tlb_all();
 }
 
diff -puN arch/x86/kernel/cpu/mtrr/generic.c~x86-mm-account-for-tlb-flushes-only-when-debugging arch/x86/kernel/cpu/mtrr/generic.c
--- a/arch/x86/kernel/cpu/mtrr/generic.c~x86-mm-account-for-tlb-flushes-only-when-debugging
+++ a/arch/x86/kernel/cpu/mtrr/generic.c
@@ -683,7 +683,7 @@ static void prepare_set(void) __acquires
 	}
 
 	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	__flush_tlb();
 
 	/* Save MTRR state */
@@ -697,7 +697,7 @@ static void prepare_set(void) __acquires
 static void post_set(void) __releases(set_atomicity_lock)
 {
 	/* Flush TLBs (no need to flush caches - they are disabled) */
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	__flush_tlb();
 
 	/* Intel (P6) standard MTRRs */
diff -puN arch/x86/mm/tlb.c~x86-mm-account-for-tlb-flushes-only-when-debugging arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-mm-account-for-tlb-flushes-only-when-debugging
+++ a/arch/x86/mm/tlb.c
@@ -103,7 +103,7 @@ static void flush_tlb_func(void *info)
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
 
-	count_vm_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
+	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
 		if (f->flush_end == TLB_FLUSH_ALL)
 			local_flush_tlb();
@@ -131,7 +131,7 @@ void native_flush_tlb_others(const struc
 	info.flush_start = start;
 	info.flush_end = end;
 
-	count_vm_event(NR_TLB_REMOTE_FLUSH);
+	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH);
 	if (is_uv_system()) {
 		unsigned int cpu;
 
@@ -151,7 +151,7 @@ void flush_tlb_current_task(void)
 
 	preempt_disable();
 
-	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	local_flush_tlb();
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
@@ -215,7 +215,7 @@ void flush_tlb_mm_range(struct mm_struct
 
 	/* tlb_flushall_shift is on balance point, details in commit log */
 	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift) {
-		count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+		count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
 	} else {
 		if (has_large_page(mm, start, end)) {
@@ -224,7 +224,7 @@ void flush_tlb_mm_range(struct mm_struct
 		}
 		/* flush range by one by one 'invlpg' */
 		for (addr = start; addr < end;	addr += PAGE_SIZE) {
-			count_vm_event(NR_TLB_LOCAL_FLUSH_ONE);
+			count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ONE);
 			__flush_tlb_single(addr);
 		}
 
@@ -262,7 +262,7 @@ void flush_tlb_page(struct vm_area_struc
 
 static void do_flush_tlb_all(void *info)
 {
-	count_vm_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
+	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	__flush_tlb_all();
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
 		leave_mm(smp_processor_id());
@@ -270,7 +270,7 @@ static void do_flush_tlb_all(void *info)
 
 void flush_tlb_all(void)
 {
-	count_vm_event(NR_TLB_REMOTE_FLUSH);
+	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH);
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
diff -puN include/linux/vm_event_item.h~x86-mm-account-for-tlb-flushes-only-when-debugging include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~x86-mm-account-for-tlb-flushes-only-when-debugging
+++ a/include/linux/vm_event_item.h
@@ -71,12 +71,14 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_ZERO_PAGE_ALLOC,
 		THP_ZERO_PAGE_ALLOC_FAILED,
 #endif
+#ifdef CONFIG_DEBUG_TLBFLUSH
 #ifdef CONFIG_SMP
 		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
 		NR_TLB_REMOTE_FLUSH_RECEIVED,/* cpu received ipi for flush */
-#endif
+#endif /* CONFIG_SMP */
 		NR_TLB_LOCAL_FLUSH_ALL,
 		NR_TLB_LOCAL_FLUSH_ONE,
+#endif /* CONFIG_DEBUG_TLBFLUSH */
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN include/linux/vmstat.h~x86-mm-account-for-tlb-flushes-only-when-debugging include/linux/vmstat.h
--- a/include/linux/vmstat.h~x86-mm-account-for-tlb-flushes-only-when-debugging
+++ a/include/linux/vmstat.h
@@ -83,6 +83,14 @@ static inline void vm_events_fold_cpu(in
 #define count_vm_numa_events(x, y) do { (void)(y); } while (0)
 #endif /* CONFIG_NUMA_BALANCING */
 
+#ifdef CONFIG_DEBUG_TLBFLUSH
+#define count_vm_tlb_event(x)	   count_vm_event(x)
+#define count_vm_tlb_events(x, y)  count_vm_events(x, y)
+#else
+#define count_vm_tlb_event(x)     do {} while (0)
+#define count_vm_tlb_events(x, y) do { (void)(y); } while (0)
+#endif
+
 #define __count_zone_vm_events(item, zone, delta) \
 		__count_vm_events(item##_NORMAL - ZONE_NORMAL + \
 		zone_idx(zone), delta)
diff -puN mm/vmstat.c~x86-mm-account-for-tlb-flushes-only-when-debugging mm/vmstat.c
--- a/mm/vmstat.c~x86-mm-account-for-tlb-flushes-only-when-debugging
+++ a/mm/vmstat.c
@@ -851,12 +851,14 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc",
 	"thp_zero_page_alloc_failed",
 #endif
+#ifdef CONFIG_DEBUG_TLBFLUSH
 #ifdef CONFIG_SMP
 	"nr_tlb_remote_flush",
 	"nr_tlb_remote_flush_received",
-#endif
+#endif /* CONFIG_SMP */
 	"nr_tlb_local_flush_all",
 	"nr_tlb_local_flush_one",
+#endif /* CONFIG_DEBUG_TLBFLUSH */
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch
mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch
mm-numa-initialse-numa-balancing-after-jump-label-initialisation.patch
mm-mempolicyc-convert-to-pr_foo.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

