From: akpm@linux-foundation.org
Subject: - mm-reuse_swap_page-replaces-can_share_swap_page.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:39 -0800
Message-ID: <200901072212.n07MCdrV012815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757743AbZAGWOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: reuse_swap_page replaces can_share_swap_page
has been removed from the -mm tree.  Its filename was
     mm-reuse_swap_page-replaces-can_share_swap_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: reuse_swap_page replaces can_share_swap_page
From: Hugh Dickins <hugh@veritas.com>

A good place to free up old swap is where do_wp_page(), or do_swap_page(),
is about to redirty the page: the data on disk is then stale and won't be
read again; and if we do decide to write the page out later, using the
previous swap location makes an unnecessary disk seek very likely.

So give can_share_swap_page() the side-effect of delete_from_swap_cache()
when it safely can.  And can_share_swap_page() was always a misleading
name, the more so if it has a side-effect: rename it reuse_swap_page().

Irrelevant cleanup nearby: remove swap_token_default_timeout definition
from swap.h: it's used nowhere.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++----
 mm/memory.c          |    4 ++--
 mm/swapfile.c        |   15 +++++++++++----
 3 files changed, 15 insertions(+), 10 deletions(-)

diff -puN include/linux/swap.h~mm-reuse_swap_page-replaces-can_share_swap_page include/linux/swap.h
--- a/include/linux/swap.h~mm-reuse_swap_page-replaces-can_share_swap_page
+++ a/include/linux/swap.h
@@ -304,7 +304,7 @@ extern unsigned int count_swap_pages(int
 extern sector_t map_swap_page(struct swap_info_struct *, pgoff_t);
 extern sector_t swapdev_block(int, pgoff_t);
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
-extern int can_share_swap_page(struct page *);
+extern int reuse_swap_page(struct page *);
 extern int remove_exclusive_swap_page(struct page *);
 extern int remove_exclusive_swap_page_ref(struct page *);
 struct backing_dev_info;
@@ -372,8 +372,6 @@ static inline struct page *lookup_swap_c
 	return NULL;
 }
 
-#define can_share_swap_page(p)			(page_mapcount(p) == 1)
-
 static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
 							gfp_t gfp_mask)
 {
@@ -388,7 +386,7 @@ static inline void delete_from_swap_cach
 {
 }
 
-#define swap_token_default_timeout		0
+#define reuse_swap_page(page)	(page_mapcount(page) == 1)
 
 static inline int remove_exclusive_swap_page(struct page *p)
 {
diff -puN mm/memory.c~mm-reuse_swap_page-replaces-can_share_swap_page mm/memory.c
--- a/mm/memory.c~mm-reuse_swap_page-replaces-can_share_swap_page
+++ a/mm/memory.c
@@ -1861,7 +1861,7 @@ static int do_wp_page(struct mm_struct *
 			}
 			page_cache_release(old_page);
 		}
-		reuse = can_share_swap_page(old_page);
+		reuse = reuse_swap_page(old_page);
 		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
@@ -2392,7 +2392,7 @@ static int do_swap_page(struct mm_struct
 
 	inc_mm_counter(mm, anon_rss);
 	pte = mk_pte(page, vma->vm_page_prot);
-	if (write_access && can_share_swap_page(page)) {
+	if (write_access && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		write_access = 0;
 	}
diff -puN mm/swapfile.c~mm-reuse_swap_page-replaces-can_share_swap_page mm/swapfile.c
--- a/mm/swapfile.c~mm-reuse_swap_page-replaces-can_share_swap_page
+++ a/mm/swapfile.c
@@ -326,17 +326,24 @@ static inline int page_swapcount(struct 
 }
 
 /*
- * We can use this swap cache entry directly
- * if there are no other references to it.
+ * We can write to an anon page without COW if there are no other references
+ * to it.  And as a side-effect, free up its swap: because the old content
+ * on disk will never be read, and seeking back there to write new content
+ * later would only waste time away from clustering.
  */
-int can_share_swap_page(struct page *page)
+int reuse_swap_page(struct page *page)
 {
 	int count;
 
 	VM_BUG_ON(!PageLocked(page));
 	count = page_mapcount(page);
-	if (count <= 1 && PageSwapCache(page))
+	if (count <= 1 && PageSwapCache(page)) {
 		count += page_swapcount(page);
+		if (count == 1 && !PageWriteback(page)) {
+			delete_from_swap_cache(page);
+			SetPageDirty(page);
+		}
+	}
 	return count == 1;
 }
 
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

