From: akpm@linux-foundation.org
Subject: - mm-add_active_or_unevictable-into-rmap.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:19 -0800
Message-ID: <200901072212.n07MCJae012533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001AbZAGWMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, Lee.Schermerhorn@hp.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: add_active_or_unevictable into rmap
has been removed from the -mm tree.  Its filename was
     mm-add_active_or_unevictable-into-rmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add_active_or_unevictable into rmap
From: Hugh Dickins <hugh@veritas.com>

lru_cache_add_active_or_unevictable() and page_add_new_anon_rmap() always
appear together.  Save some symbol table space and some jumping around by
removing lru_cache_add_active_or_unevictable(), folding its code into
page_add_new_anon_rmap(): like how we add file pages to lru just after
adding them to page cache.

Remove the nearby "TODO: is this safe?" comments (yes, it is safe), and
change page_add_new_anon_rmap()'s address BUG_ON to VM_BUG_ON as
originally intended.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 --
 mm/memory.c          |    6 ------
 mm/rmap.c            |    7 ++++++-
 mm/swap.c            |   19 -------------------
 4 files changed, 6 insertions(+), 28 deletions(-)

diff -puN include/linux/swap.h~mm-add_active_or_unevictable-into-rmap include/linux/swap.h
--- a/include/linux/swap.h~mm-add_active_or_unevictable-into-rmap
+++ a/include/linux/swap.h
@@ -174,8 +174,6 @@ extern unsigned int nr_free_pagecache_pa
 /* linux/mm/swap.c */
 extern void __lru_cache_add(struct page *, enum lru_list lru);
 extern void lru_cache_add_lru(struct page *, enum lru_list lru);
-extern void lru_cache_add_active_or_unevictable(struct page *,
-					struct vm_area_struct *);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
diff -puN mm/memory.c~mm-add_active_or_unevictable-into-rmap mm/memory.c
--- a/mm/memory.c~mm-add_active_or_unevictable-into-rmap
+++ a/mm/memory.c
@@ -1949,10 +1949,7 @@ gotten:
 		 */
 		ptep_clear_flush_notify(vma, address, page_table);
 		SetPageSwapBacked(new_page);
-		lru_cache_add_active_or_unevictable(new_page, vma);
 		page_add_new_anon_rmap(new_page, vma, address);
-
-//TODO:  is this safe?  do_anonymous_page() does it this way.
 		set_pte_at(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
 		if (old_page) {
@@ -2448,7 +2445,6 @@ static int do_anonymous_page(struct mm_s
 		goto release;
 	inc_mm_counter(mm, anon_rss);
 	SetPageSwapBacked(page);
-	lru_cache_add_active_or_unevictable(page, vma);
 	page_add_new_anon_rmap(page, vma, address);
 	set_pte_at(mm, address, page_table, entry);
 
@@ -2597,7 +2593,6 @@ static int __do_fault(struct mm_struct *
 		if (anon) {
 			inc_mm_counter(mm, anon_rss);
 			SetPageSwapBacked(page);
-			lru_cache_add_active_or_unevictable(page, vma);
 			page_add_new_anon_rmap(page, vma, address);
 		} else {
 			inc_mm_counter(mm, file_rss);
@@ -2607,7 +2602,6 @@ static int __do_fault(struct mm_struct *
 				get_page(dirty_page);
 			}
 		}
-//TODO:  is this safe?  do_anonymous_page() does it this way.
 		set_pte_at(mm, address, page_table, entry);
 
 		/* no need to invalidate: a not-present page won't be cached */
diff -puN mm/rmap.c~mm-add_active_or_unevictable-into-rmap mm/rmap.c
--- a/mm/rmap.c~mm-add_active_or_unevictable-into-rmap
+++ a/mm/rmap.c
@@ -47,6 +47,7 @@
 #include <linux/rmap.h>
 #include <linux/rcupdate.h>
 #include <linux/module.h>
+#include <linux/mm_inline.h>
 #include <linux/kallsyms.h>
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
@@ -671,9 +672,13 @@ void page_add_anon_rmap(struct page *pag
 void page_add_new_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
 {
-	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
+	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	atomic_set(&page->_mapcount, 0); /* elevate count by 1 (starts at -1) */
 	__page_set_anon_rmap(page, vma, address);
+	if (page_evictable(page, vma))
+		lru_cache_add_lru(page, LRU_ACTIVE + page_is_file_cache(page));
+	else
+		add_page_to_unevictable_list(page);
 }
 
 /**
diff -puN mm/swap.c~mm-add_active_or_unevictable-into-rmap mm/swap.c
--- a/mm/swap.c~mm-add_active_or_unevictable-into-rmap
+++ a/mm/swap.c
@@ -246,25 +246,6 @@ void add_page_to_unevictable_list(struct
 	spin_unlock_irq(&zone->lru_lock);
 }
 
-/**
- * lru_cache_add_active_or_unevictable
- * @page:  the page to be added to LRU
- * @vma:   vma in which page is mapped for determining reclaimability
- *
- * place @page on active or unevictable LRU list, depending on
- * page_evictable().  Note that if the page is not evictable,
- * it goes directly back onto it's zone's unevictable list.  It does
- * NOT use a per cpu pagevec.
- */
-void lru_cache_add_active_or_unevictable(struct page *page,
-					struct vm_area_struct *vma)
-{
-	if (page_evictable(page, vma))
-		lru_cache_add_lru(page, LRU_ACTIVE + page_is_file_cache(page));
-	else
-		add_page_to_unevictable_list(page);
-}
-
 /*
  * Drain pages out of the cpu's pagevecs.
  * Either "cpu" is the current CPU, and preemption has already been
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

