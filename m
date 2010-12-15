From: akpm@linux-foundation.org
Subject: + thp-fix-anon-memory-statistics-with-transparent-hugepages.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:58:11 -0800
Message-ID: <201012152358.oBFNwBjR013685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755927Ab0LOX6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:58:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, aarcange@redhat.com


The patch titled
     thp: fix anon memory statistics with transparent hugepages
has been added to the -mm tree.  Its filename is
     thp-fix-anon-memory-statistics-with-transparent-hugepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: fix anon memory statistics with transparent hugepages
From: Rik van Riel <riel@redhat.com>

Count each transparent hugepage as HPAGE_PMD_NR pages in the LRU
statistics, so the Active(anon) and Inactive(anon) statistics in
/proc/meminfo are correct.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h   |    8 ++++++++
 include/linux/mm_inline.h |    8 +++++---
 mm/huge_memory.c          |   10 ++++++++++
 mm/memcontrol.c           |    2 +-
 mm/vmscan.c               |   11 ++++++-----
 5 files changed, 30 insertions(+), 9 deletions(-)

diff -puN include/linux/huge_mm.h~thp-fix-anon-memory-statistics-with-transparent-hugepages include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-fix-anon-memory-statistics-with-transparent-hugepages
+++ a/include/linux/huge_mm.h
@@ -117,11 +117,19 @@ static inline void vma_adjust_trans_huge
 		return;
 	__vma_adjust_trans_huge(vma, start, end, adjust_next);
 }
+static inline int hpage_nr_pages(struct page *page)
+{
+	if (unlikely(PageTransHuge(page)))
+		return HPAGE_PMD_NR;
+	return 1;
+}
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUG(); 0; })
 #define HPAGE_PMD_SIZE ({ BUG(); 0; })
 
+#define hpage_nr_pages(x) 1
+
 #define transparent_hugepage_enabled(__vma) 0
 
 #define transparent_hugepage_flags 0UL
diff -puN include/linux/mm_inline.h~thp-fix-anon-memory-statistics-with-transparent-hugepages include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~thp-fix-anon-memory-statistics-with-transparent-hugepages
+++ a/include/linux/mm_inline.h
@@ -1,6 +1,8 @@
 #ifndef LINUX_MM_INLINE_H
 #define LINUX_MM_INLINE_H
 
+#include <linux/huge_mm.h>
+
 /**
  * page_is_file_cache - should the page be on a file LRU or anon LRU?
  * @page: the page to test
@@ -24,7 +26,7 @@ __add_page_to_lru_list(struct zone *zone
 		       struct list_head *head)
 {
 	list_add(&page->lru, head);
-	__inc_zone_state(zone, NR_LRU_BASE + l);
+	__mod_zone_page_state(zone, NR_LRU_BASE + l, hpage_nr_pages(page));
 	mem_cgroup_add_lru_list(page, l);
 }
 
@@ -38,7 +40,7 @@ static inline void
 del_page_from_lru_list(struct zone *zone, struct page *page, enum lru_list l)
 {
 	list_del(&page->lru);
-	__dec_zone_state(zone, NR_LRU_BASE + l);
+	__mod_zone_page_state(zone, NR_LRU_BASE + l, -hpage_nr_pages(page));
 	mem_cgroup_del_lru_list(page, l);
 }
 
@@ -73,7 +75,7 @@ del_page_from_lru(struct zone *zone, str
 			l += LRU_ACTIVE;
 		}
 	}
-	__dec_zone_state(zone, NR_LRU_BASE + l);
+	__mod_zone_page_state(zone, NR_LRU_BASE + l, -hpage_nr_pages(page));
 	mem_cgroup_del_lru_list(page, l);
 }
 
diff -puN mm/huge_memory.c~thp-fix-anon-memory-statistics-with-transparent-hugepages mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-anon-memory-statistics-with-transparent-hugepages
+++ a/mm/huge_memory.c
@@ -1143,6 +1143,7 @@ static void __split_huge_page_refcount(s
 	int i;
 	unsigned long head_index = page->index;
 	struct zone *zone = page_zone(page);
+	int zonestat;
 
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
 	spin_lock_irq(&zone->lru_lock);
@@ -1207,6 +1208,15 @@ static void __split_huge_page_refcount(s
 	__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
 	__mod_zone_page_state(zone, NR_ANON_PAGES, HPAGE_PMD_NR);
 
+	/*
+	 * A hugepage counts for HPAGE_PMD_NR pages on the LRU statistics,
+	 * so adjust those appropriately if this page is on the LRU.
+	 */
+	if (PageLRU(page)) {
+		zonestat = NR_LRU_BASE + page_lru(page);
+		__mod_zone_page_state(zone, zonestat, -(HPAGE_PMD_NR-1));
+	}
+
 	ClearPageCompound(page);
 	compound_unlock(page);
 	spin_unlock_irq(&zone->lru_lock);
diff -puN mm/memcontrol.c~thp-fix-anon-memory-statistics-with-transparent-hugepages mm/memcontrol.c
--- a/mm/memcontrol.c~thp-fix-anon-memory-statistics-with-transparent-hugepages
+++ a/mm/memcontrol.c
@@ -1091,7 +1091,7 @@ unsigned long mem_cgroup_isolate_pages(u
 		case 0:
 			list_move(&page->lru, dst);
 			mem_cgroup_del_lru(page);
-			nr_taken++;
+			nr_taken += hpage_nr_pages(page);
 			break;
 		case -EBUSY:
 			/* we don't affect global LRU but rotate in our LRU */
diff -puN mm/vmscan.c~thp-fix-anon-memory-statistics-with-transparent-hugepages mm/vmscan.c
--- a/mm/vmscan.c~thp-fix-anon-memory-statistics-with-transparent-hugepages
+++ a/mm/vmscan.c
@@ -1045,7 +1045,7 @@ static unsigned long isolate_lru_pages(u
 		case 0:
 			list_move(&page->lru, dst);
 			mem_cgroup_del_lru(page);
-			nr_taken++;
+			nr_taken += hpage_nr_pages(page);
 			break;
 
 		case -EBUSY:
@@ -1103,7 +1103,7 @@ static unsigned long isolate_lru_pages(u
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
 				mem_cgroup_del_lru(cursor_page);
-				nr_taken++;
+				nr_taken += hpage_nr_pages(page);
 				nr_lumpy_taken++;
 				if (PageDirty(cursor_page))
 					nr_lumpy_dirty++;
@@ -1158,14 +1158,15 @@ static unsigned long clear_active_flags(
 	struct page *page;
 
 	list_for_each_entry(page, page_list, lru) {
+		int numpages = hpage_nr_pages(page);
 		lru = page_lru_base_type(page);
 		if (PageActive(page)) {
 			lru += LRU_ACTIVE;
 			ClearPageActive(page);
-			nr_active++;
+			nr_active += numpages;
 		}
 		if (count)
-			count[lru]++;
+			count[lru] += numpages;
 	}
 
 	return nr_active;
@@ -1483,7 +1484,7 @@ static void move_active_pages_to_lru(str
 
 		list_move(&page->lru, &zone->lru[lru].list);
 		mem_cgroup_add_lru_list(page, lru);
-		pgmoved++;
+		pgmoved += hpage_nr_pages(page);
 
 		if (!pagevec_add(&pvec, page) || list_empty(list)) {
 			spin_unlock_irq(&zone->lru_lock);
_

Patches currently in -mm which might be from riel@redhat.com are

linux-next.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch
mm-clear-pageerror-bit-in-msync-fsync.patch
do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mm-remove-likely-from-mapping_unevictable.patch
mm-remove-unlikely-from-page_mapping.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-mm-define-madv_hugepage.patch
thp-compound_lock.patch
thp-alter-compound-get_page-put_page.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-transparent-hugepage-core.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-madvisemadv_hugepage.patch
thp-pmd_trans_huge-migrate-bugcheck.patch
thp-memcg-compound.patch
thp-memcg-huge-memory.patch
thp-transparent-hugepage-vmstat.patch
thp-khugepaged.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
thp-fix-anon-memory-statistics-with-transparent-hugepages.patch
thp-scale-nr_rotated-to-balance-memory-pressure.patch
thp-transparent-hugepage-sysfs-meminfo.patch

