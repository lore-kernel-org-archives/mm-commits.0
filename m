From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:21:19 -0700
Message-ID: <538f9bdf.ci3SJsgHikas0ekR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaFDWVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, steven@uplinklabs.net, srikar@linux.vnet.ibm.com, riel@redhat.com, peterz@infradead.org, mingo@kernel.org, hpa@zytor.com, gorcunov@gmail.com, fengguang.wu@intel.com, david.vrabel@citrix.com, dave.hansen@intel.com, aarcange@redhat.com, mgorman@suse.de

Subject: [folded-merged] x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch removed from -mm tree
To: mgorman@suse.de,aarcange@redhat.com,dave.hansen@intel.com,david.vrabel@citrix.com,fengguang.wu@intel.com,gorcunov@gmail.com,hpa@zytor.com,mingo@kernel.org,peterz@infradead.org,riel@redhat.com,srikar@linux.vnet.ibm.com,steven@uplinklabs.net,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:21:19 -0700


The patch titled
     Subject: x86: define _PAGE_NUMA by reusing software bits on the PMD and PTE levels -fix 2
has been removed from the -mm tree.  Its filename was
     x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch

This patch was dropped because it was folded into x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: x86: define _PAGE_NUMA by reusing software bits on the PMD and PTE levels -fix 2

powerpc has NUMA_BALANCING and non-NUMA_BALANCING versions of pte_present
and I missed that when testing cross-compiling.  This patch replaces
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Anvin <hpa@zytor.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Noonan <steven@uplinklabs.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h |    1 +
 arch/x86/include/asm/pgtable.h     |    1 +
 include/asm-generic/pgtable.h      |    4 ++++
 3 files changed, 6 insertions(+)

diff -puN arch/powerpc/include/asm/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2 arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -44,6 +44,7 @@ static inline int pte_present(pte_t pte)
 	return pte_val(pte) & (_PAGE_PRESENT | _PAGE_NUMA);
 }
 
+#define pte_present_nonuma pte_present_nonuma
 static inline int pte_present_nonuma(pte_t pte)
 {
 	return pte_val(pte) & (_PAGE_PRESENT);
diff -puN arch/x86/include/asm/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2 arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2
+++ a/arch/x86/include/asm/pgtable.h
@@ -453,6 +453,7 @@ static inline int pte_present(pte_t a)
 			       _PAGE_NUMA);
 }
 
+#define pte_present_nonuma pte_present_nonuma
 static inline int pte_present_nonuma(pte_t a)
 {
 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
diff -puN include/asm-generic/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2 include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2
+++ a/include/asm-generic/pgtable.h
@@ -233,6 +233,10 @@ static inline int pmd_same(pmd_t pmd_a,
 # define pte_accessible(mm, pte)	((void)(pte), 1)
 #endif
 
+#ifndef pte_present_nonuma
+#define pte_present_nonuma(pte) pte_present(pte)
+#endif
+
 #ifndef flush_tlb_fix_spurious_fault
 #define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
 #endif
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-fix.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-x86-pgtable-drop-unneeded-preprocessor-ifdef.patch
mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active.patch
mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref-fix.patch
mm-avoid-unnecessary-atomic-operations-during-end_page_writeback.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
fs-superblock-unregister-sb-shrinker-before-kill_sb.patch
fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch
mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch
mm-nominate-faultaround-area-in-bytes-rather-then-page-order.patch

