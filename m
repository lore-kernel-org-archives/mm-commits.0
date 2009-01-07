From: akpm@linux-foundation.org
Subject: - badpage-simplify-page_alloc-flag-checkclear.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:56 -0800
Message-ID: <200901072213.n07MDuXt013907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757264AbZAGWOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     badpage: simplify page_alloc flag check+clear
has been removed from the -mm tree.  Its filename was
     badpage-simplify-page_alloc-flag-checkclear.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: badpage: simplify page_alloc flag check+clear
From: Hugh Dickins <hugh@veritas.com>

Simplify the PAGE_FLAGS checking and clearing when freeing and allocating
a page: check the same flags as before when freeing, clear ALL the flags
(unless PageReserved) when freeing, check ALL flags off when allocating.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   25 ++++++++-----------------
 mm/page_alloc.c            |   19 ++++++-------------
 2 files changed, 14 insertions(+), 30 deletions(-)

diff -puN include/linux/page-flags.h~badpage-simplify-page_alloc-flag-checkclear include/linux/page-flags.h
--- a/include/linux/page-flags.h~badpage-simplify-page_alloc-flag-checkclear
+++ a/include/linux/page-flags.h
@@ -373,31 +373,22 @@ static inline void __ClearPageTail(struc
 #define __PG_MLOCKED		0
 #endif
 
-#define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
-			 1 << PG_buddy | 1 << PG_writeback | \
-			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
-			 __PG_UNEVICTABLE | __PG_MLOCKED)
-
-/*
- * Flags checked in bad_page().  Pages on the free list should not have
- * these flags set.  It they are, there is a problem.
- */
-#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | \
-		1 << PG_reclaim | 1 << PG_dirty | 1 << PG_swapbacked)
-
 /*
  * Flags checked when a page is freed.  Pages being freed should not have
  * these flags set.  It they are, there is a problem.
  */
-#define PAGE_FLAGS_CHECK_AT_FREE (PAGE_FLAGS | 1 << PG_reserved)
+#define PAGE_FLAGS_CHECK_AT_FREE \
+	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
+	 1 << PG_buddy | 1 << PG_writeback | 1 << PG_reserved | \
+	 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
+	 __PG_UNEVICTABLE | __PG_MLOCKED)
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
- * Pages being prepped should not have these flags set.  It they are, there
- * is a problem.
+ * Pages being prepped should not have any flags set.  It they are set,
+ * there has been a kernel bug or struct page corruption.
  */
-#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | \
-		1 << PG_reserved | 1 << PG_dirty | 1 << PG_swapbacked)
+#define PAGE_FLAGS_CHECK_AT_PREP	((1 << NR_PAGEFLAGS) - 1)
 
 #endif /* !__GENERATING_BOUNDS_H */
 #endif	/* PAGE_FLAGS_H */
diff -puN mm/page_alloc.c~badpage-simplify-page_alloc-flag-checkclear mm/page_alloc.c
--- a/mm/page_alloc.c~badpage-simplify-page_alloc-flag-checkclear
+++ a/mm/page_alloc.c
@@ -231,7 +231,6 @@ static void bad_page(struct page *page)
 	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
 		KERN_EMERG "Backtrace:\n");
 	dump_stack();
-	page->flags &= ~PAGE_FLAGS_CLEAR_WHEN_BAD;
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
 	page->mapping = NULL;
@@ -468,16 +467,16 @@ static inline int free_pages_check(struc
 		(page_count(page) != 0)  |
 		(page->flags & PAGE_FLAGS_CHECK_AT_FREE)))
 		bad_page(page);
-	if (PageDirty(page))
-		__ClearPageDirty(page);
-	if (PageSwapBacked(page))
-		__ClearPageSwapBacked(page);
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
 	 * to do more, for when the ZERO_PAGE count wraps negative.
 	 */
-	return PageReserved(page);
+	if (PageReserved(page))
+		return 1;
+	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
+		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	return 0;
 }
 
 /*
@@ -621,13 +620,7 @@ static int prep_new_page(struct page *pa
 	if (PageReserved(page))
 		return 1;
 
-	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_reclaim |
-			1 << PG_referenced | 1 << PG_arch_1 |
-			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk
-#ifdef CONFIG_UNEVICTABLE_LRU
-			| 1 << PG_mlocked
-#endif
-			);
+	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	set_page_private(page, 0);
 	set_page_refcounted(page);
 
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

