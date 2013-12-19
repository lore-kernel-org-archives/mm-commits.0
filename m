From: akpm@linux-foundation.org
Subject: [merged]
 mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration.patch removed from -mm tree
Date: Thu, 19 Dec 2013 11:53:43 -0800
Message-ID: <52b34ec7.2SdTNu6i5hBpxjDu%akpm__9615.66582923314$1387482837$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3LSTxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:53:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: [merged] mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration.patch removed from -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:53:43 -0800


The patch titled
     Subject: mm: numa: avoid unnecessary disruption of NUMA hinting during migration
has been removed from the -mm tree.  Its filename was
     mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: avoid unnecessary disruption of NUMA hinting during migration

do_huge_pmd_numa_page() handles the case where there is parallel THP
migration.  However, by the time it is checked the NUMA hinting
information has already been disrupted.  This patch adds an earlier check
with some helpers.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    9 +++++++++
 mm/huge_memory.c        |   22 ++++++++++++++++------
 mm/migrate.c            |   12 ++++++++++++
 3 files changed, 37 insertions(+), 6 deletions(-)

diff -puN include/linux/migrate.h~mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration include/linux/migrate.h
--- a/include/linux/migrate.h~mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration
+++ a/include/linux/migrate.h
@@ -90,10 +90,19 @@ static inline int migrate_huge_page_move
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
+extern bool pmd_trans_migrating(pmd_t pmd);
+extern void wait_migrate_huge_page(struct anon_vma *anon_vma, pmd_t *pmd);
 extern int migrate_misplaced_page(struct page *page,
 				  struct vm_area_struct *vma, int node);
 extern bool migrate_ratelimited(int node);
 #else
+static inline bool pmd_trans_migrating(pmd_t pmd)
+{
+	return false;
+}
+static inline void wait_migrate_huge_page(struct anon_vma *anon_vma, pmd_t *pmd)
+{
+}
 static inline int migrate_misplaced_page(struct page *page,
 					 struct vm_area_struct *vma, int node)
 {
diff -puN mm/huge_memory.c~mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration
+++ a/mm/huge_memory.c
@@ -882,6 +882,10 @@ int copy_huge_pmd(struct mm_struct *dst_
 		ret = 0;
 		goto out_unlock;
 	}
+
+	/* mmap_sem prevents this happening but warn if that changes */
+	WARN_ON(pmd_trans_migrating(pmd));
+
 	if (unlikely(pmd_trans_splitting(pmd))) {
 		/* split huge page running from under us */
 		spin_unlock(src_ptl);
@@ -1299,6 +1303,17 @@ int do_huge_pmd_numa_page(struct mm_stru
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
 
+	/*
+	 * If there are potential migrations, wait for completion and retry
+	 * without disrupting NUMA hinting information. Do not relock and
+	 * check_same as the page may no longer be mapped.
+	 */
+	if (unlikely(pmd_trans_migrating(*pmdp))) {
+		spin_unlock(ptl);
+		wait_migrate_huge_page(vma->anon_vma, pmdp);
+		goto out;
+	}
+
 	page = pmd_page(pmd);
 	BUG_ON(is_huge_zero_page(page));
 	page_nid = page_to_nid(page);
@@ -1329,12 +1344,7 @@ int do_huge_pmd_numa_page(struct mm_stru
 			goto clear_pmdnuma;
 	}
 
-	/*
-	 * If there are potential migrations, wait for completion and retry. We
-	 * do not relock and check_same as the page may no longer be mapped.
-	 * Furtermore, even if the page is currently misplaced, there is no
-	 * guarantee it is still misplaced after the migration completes.
-	 */
+	/* Migration could have started since the pmd_trans_migrating check */
 	if (!page_locked) {
 		spin_unlock(ptl);
 		wait_on_page_locked(page);
diff -puN mm/migrate.c~mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration mm/migrate.c
--- a/mm/migrate.c~mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration
+++ a/mm/migrate.c
@@ -1655,6 +1655,18 @@ int numamigrate_isolate_page(pg_data_t *
 	return 1;
 }
 
+bool pmd_trans_migrating(pmd_t pmd)
+{
+	struct page *page = pmd_page(pmd);
+	return PageLocked(page);
+}
+
+void wait_migrate_huge_page(struct anon_vma *anon_vma, pmd_t *pmd)
+{
+	struct page *page = pmd_page(*pmd);
+	wait_on_page_locked(page);
+}
+
 /*
  * Attempt to migrate a misplaced page to the specified destination
  * node. Caller is expected to have an elevated reference count on
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

