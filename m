From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix.patch removed from -mm tree
Date: Wed, 18 Dec 2013 17:05:45 -0800
Message-ID: <52b24669.qZfilhcVGjIKWcvJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3LSBFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Dec 2013 20:05:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, athorlton@sgi.com, mgorman@suse.de

Subject: [folded-merged] mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix.patch removed from -mm tree
To: mgorman@suse.de,athorlton@sgi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 18 Dec 2013 17:05:45 -0800


The patch titled
     Subject: mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix.patch

This patch was dropped because it was folded into mm-fix-tlb-flush-race-between-migration-and-change_protection_range.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix

The following build error was reported by the 0-day build checker.

>> arch/arm/mm/context.c:51:18: error: 'tlb_flush_pending' redeclared as different kind of symbol
   include/linux/mm_types.h:477:91: note: previous definition of 'tlb_flush_pending' was here

This patch renames tlb_flush_pending to
mm_tlb_flush_pending. This is a fix for the -mm patch
mm-fix-tlb-flush-race-between-migration-and-change_protection_range.patch

Note that when slotted into place that it will cause a conflict with
mm-numa-defer-tlb-flush-for-thp-migration-as-long-as-possible.patch . The
resolution is to delete the call from huge_memory.c and make sure the
tlb_flush_pending call in mm/migrate.c is renamed appropriately.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alex Thorlton <athorlton@sgi.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    2 +-
 include/linux/mm_types.h       |    4 ++--
 mm/huge_memory.c               |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix
+++ a/arch/x86/include/asm/pgtable.h
@@ -458,7 +458,7 @@ static inline bool pte_accessible(struct
 		return true;
 
 	if ((pte_flags(a) & (_PAGE_PROTNONE | _PAGE_NUMA)) &&
-			tlb_flush_pending(mm))
+			mm_tlb_flush_pending(mm))
 		return true;
 
 	return false;
diff -puN include/linux/mm_types.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix
+++ a/include/linux/mm_types.h
@@ -474,7 +474,7 @@ static inline cpumask_t *mm_cpumask(stru
  * The barriers below prevent the compiler from re-ordering the instructions
  * around the memory barriers that are already present in the code.
  */
-static inline bool tlb_flush_pending(struct mm_struct *mm)
+static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
 {
 	barrier();
 	return mm->tlb_flush_pending;
@@ -491,7 +491,7 @@ static inline void clear_tlb_flush_pendi
 	mm->tlb_flush_pending = false;
 }
 #else
-static inline bool tlb_flush_pending(struct mm_struct *mm)
+static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
 {
 	return false;
 }
diff -puN mm/huge_memory.c~mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix
+++ a/mm/huge_memory.c
@@ -1380,7 +1380,7 @@ int do_huge_pmd_numa_page(struct mm_stru
 	 * The page_table_lock above provides a memory barrier
 	 * with change_protection_range.
 	 */
-	if (tlb_flush_pending(mm))
+	if (mm_tlb_flush_pending(mm))
 		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
 
 	/*
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-numa-serialise-parallel-get_user_page-against-thp-migration.patch
mm-numa-call-mmu-notifiers-on-thp-migration.patch
mm-clear-pmd_numa-before-invalidating.patch
mm-numa-do-not-clear-pmd-during-pte-update-scan.patch
mm-numa-do-not-clear-pte-for-pte_numa-update.patch
mm-numa-ensure-anon_vma-is-locked-to-prevent-parallel-thp-splits.patch
mm-numa-avoid-unnecessary-work-on-the-failure-path.patch
sched-numa-skip-inaccessible-vmas.patch
mm-numa-clear-numa-hinting-information-on-mprotect.patch
mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration.patch
mm-fix-tlb-flush-race-between-migration-and-change_protection_range.patch
mm-numa-guarantee-that-tlb_flush_pending-updates-are-visible-before-page-table-updates.patch
mm-numa-defer-tlb-flush-for-thp-migration-as-long-as-possible.patch
mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch
mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed.patch
mm-compaction-respect-ignore_skip_hint-in-update_pageblock_skip.patch
mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address.patch
mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered.patch
mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch
mm-thp-turn-compound_head-into-bug_onpagetail-in-get_huge_page_tail.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-numa-make-numa-migrate-related-functions-static.patch
mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch
mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting.patch
mm-numa-do-not-automatically-migrate-ksm-pages.patch
sched-add-tracepoints-related-to-numa-task-migration.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-compaction-trace-compaction-begin-and-end.patch
mm-compaction-encapsulate-defer-reset-logic.patch
mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch
mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch
mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch
mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-remove-bug_on-from-mlock_vma_page.patch
linux-next.patch
mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

