From: akpm@linux-foundation.org
Subject: + mm-numa-call-mmu-notifiers-on-thp-migration.patch added to -mm
 tree
Date: Tue, 10 Dec 2013 14:20:18 -0800
Message-ID: <52a793a2.xFjKT31+pJ0ivRow%akpm__15145.5542458736$1386714031$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3LJWUT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 17:20:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: + mm-numa-call-mmu-notifiers-on-thp-migration.patch added to -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 14:20:18 -0800


The patch titled
     Subject: mm: numa: call MMU notifiers on THP migration
has been added to the -mm tree.  Its filename is
     mm-numa-call-mmu-notifiers-on-thp-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-call-mmu-notifiers-on-thp-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-call-mmu-notifiers-on-thp-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: call MMU notifiers on THP migration

MMU notifiers must be called on THP page migration or secondary MMUs will
get very confused.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN mm/migrate.c~mm-numa-call-mmu-notifiers-on-thp-migration mm/migrate.c
--- a/mm/migrate.c~mm-numa-call-mmu-notifiers-on-thp-migration
+++ a/mm/migrate.c
@@ -36,6 +36,7 @@
 #include <linux/hugetlb_cgroup.h>
 #include <linux/gfp.h>
 #include <linux/balloon_compaction.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/tlbflush.h>
 
@@ -1721,12 +1722,13 @@ int migrate_misplaced_transhuge_page(str
 				struct page *page, int node)
 {
 	spinlock_t *ptl;
-	unsigned long haddr = address & HPAGE_PMD_MASK;
 	pg_data_t *pgdat = NODE_DATA(node);
 	int isolated = 0;
 	struct page *new_page = NULL;
 	struct mem_cgroup *memcg = NULL;
 	int page_lru = page_is_file_cache(page);
+	unsigned long mmun_start = address & HPAGE_PMD_MASK;
+	unsigned long mmun_end = mmun_start + HPAGE_PMD_SIZE;
 	pmd_t orig_entry;
 
 	/*
@@ -1761,10 +1763,12 @@ int migrate_misplaced_transhuge_page(str
 	WARN_ON(PageLRU(new_page));
 
 	/* Recheck the target PMD */
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_same(*pmd, entry) || page_count(page) != 2)) {
 fail_putback:
 		spin_unlock(ptl);
+		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
 		/* Reverse changes made by migrate_page_copy() */
 		if (TestClearPageActive(new_page))
@@ -1805,15 +1809,16 @@ fail_putback:
 	 * The SetPageUptodate on the new page and page_add_new_anon_rmap
 	 * guarantee the copy is visible before the pagetable update.
 	 */
-	flush_cache_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
-	page_add_new_anon_rmap(new_page, vma, haddr);
-	pmdp_clear_flush(vma, haddr, pmd);
-	set_pmd_at(mm, haddr, pmd, entry);
+	flush_cache_range(vma, mmun_start, mmun_end);
+	page_add_new_anon_rmap(new_page, vma, mmun_start);
+	pmdp_clear_flush(vma, mmun_start, pmd);
+	set_pmd_at(mm, mmun_start, pmd, entry);
+	flush_tlb_range(vma, mmun_start, mmun_end);
 	update_mmu_cache_pmd(vma, address, &entry);
 
 	if (page_count(page) != 2) {
-		set_pmd_at(mm, haddr, pmd, orig_entry);
-		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
+		set_pmd_at(mm, mmun_start, pmd, orig_entry);
+		flush_tlb_range(vma, mmun_start, mmun_end);
 		update_mmu_cache_pmd(vma, address, &entry);
 		page_remove_rmap(new_page);
 		goto fail_putback;
@@ -1828,6 +1833,7 @@ fail_putback:
 	 */
 	mem_cgroup_end_migration(memcg, page, new_page, true);
 	spin_unlock(ptl);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
 	unlock_page(new_page);
 	unlock_page(page);
@@ -1848,7 +1854,7 @@ out_dropref:
 	ptl = pmd_lock(mm, pmd);
 	if (pmd_same(*pmd, entry)) {
 		entry = pmd_mknonnuma(entry);
-		set_pmd_at(mm, haddr, pmd, entry);
+		set_pmd_at(mm, mmun_start, pmd, entry);
 		update_mmu_cache_pmd(vma, address, &entry);
 	}
 	spin_unlock(ptl);
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
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
mm-numa-defer-tlb-flush-for-thp-migration-as-long-as-possible.patch
mm-numa-make-numa-migrate-related-functions-static.patch
mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch
mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting.patch
mm-numa-do-not-automatically-migrate-ksm-pages.patch
sched-add-tracepoints-related-to-numa-task-migration.patch
linux-next.patch

