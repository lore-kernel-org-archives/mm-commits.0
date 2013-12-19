From: akpm@linux-foundation.org
Subject: [merged] mm-numa-clear-numa-hinting-information-on-mprotect.patch removed from -mm tree
Date: Thu, 19 Dec 2013 11:53:41 -0800
Message-ID: <52b34ec5.8GJyt6Vwx+suLvVt%akpm__15333.1658606932$1387482837$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3LSTxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:53:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: [merged] mm-numa-clear-numa-hinting-information-on-mprotect.patch removed from -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:53:41 -0800


The patch titled
     Subject: mm: numa: clear numa hinting information on mprotect
has been removed from the -mm tree.  Its filename was
     mm-numa-clear-numa-hinting-information-on-mprotect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: clear numa hinting information on mprotect

On a protection change it is no longer clear if the page should be still
accessible.  This patch clears the NUMA hinting fault bits on a protection
change.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 mm/mprotect.c    |    2 ++
 2 files changed, 4 insertions(+)

diff -puN mm/huge_memory.c~mm-numa-clear-numa-hinting-information-on-mprotect mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-clear-numa-hinting-information-on-mprotect
+++ a/mm/huge_memory.c
@@ -1532,6 +1532,8 @@ int change_huge_pmd(struct vm_area_struc
 		ret = 1;
 		if (!prot_numa) {
 			entry = pmdp_get_and_clear(mm, addr, pmd);
+			if (pmd_numa(entry))
+				entry = pmd_mknonnuma(entry);
 			entry = pmd_modify(entry, newprot);
 			ret = HPAGE_PMD_NR;
 			BUG_ON(pmd_write(entry));
diff -puN mm/mprotect.c~mm-numa-clear-numa-hinting-information-on-mprotect mm/mprotect.c
--- a/mm/mprotect.c~mm-numa-clear-numa-hinting-information-on-mprotect
+++ a/mm/mprotect.c
@@ -54,6 +54,8 @@ static unsigned long change_pte_range(st
 
 			if (!prot_numa) {
 				ptent = ptep_modify_prot_start(mm, addr, pte);
+				if (pte_numa(ptent))
+					ptent = pte_mknonnuma(ptent);
 				ptent = pte_modify(ptent, newprot);
 				updated = true;
 			} else {
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
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

