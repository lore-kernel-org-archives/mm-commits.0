From: akpm@linux-foundation.org
Subject: - mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:42 -0800
Message-ID: <200901072212.n07MCgo0012898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757250AbZAGWOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: try_to_free_swap replaces remove_exclusive_swap_page
has been removed from the -mm tree.  Its filename was
     mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: try_to_free_swap replaces remove_exclusive_swap_page
From: Hugh Dickins <hugh@veritas.com>

remove_exclusive_swap_page(): its problem is in living up to its name.

It doesn't matter if someone else has a reference to the page (raised
page_count); it doesn't matter if the page is mapped into userspace
(raised page_mapcount - though that hints it may be worth keeping the
swap): all that matters is that there be no more references to the swap
(and no writeback in progress).

swapoff (try_to_unuse) has been removing pages from swapcache for years,
with no concern for page count or page mapcount, and we used to have a
comment in lookup_swap_cache() recognizing that: if you go for a page of
swapcache, you'll get the right page, but it could have been removed from
swapcache by the time you get page lock.

So, give up asking for exclusivity: get rid of
remove_exclusive_swap_page(), and remove_exclusive_swap_page_ref() and
remove_exclusive_swap_page_count() which were spawned for the recent LRU
work: replace them by the simpler try_to_free_swap() which just checks
page_swapcount().

Similarly, remove the page_count limitation from free_swap_and_count(),
but assume that it's worth holding on to the swap if page is mapped and
swap nowhere near full.  Add a vm_swap_full() test in free_swap_cache()? 
It would be consistent, but I think we probably have enough for now.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   10 +----
 mm/memory.c          |    2 -
 mm/page_io.c         |    2 -
 mm/swap.c            |    3 -
 mm/swap_state.c      |    8 ++--
 mm/swapfile.c        |   70 +++++++----------------------------------
 mm/vmscan.c          |    2 -
 7 files changed, 22 insertions(+), 75 deletions(-)

diff -puN include/linux/swap.h~mm-try_to_free_swap-replaces-remove_exclusive_swap_page include/linux/swap.h
--- a/include/linux/swap.h~mm-try_to_free_swap-replaces-remove_exclusive_swap_page
+++ a/include/linux/swap.h
@@ -305,8 +305,7 @@ extern sector_t map_swap_page(struct swa
 extern sector_t swapdev_block(int, pgoff_t);
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
 extern int reuse_swap_page(struct page *);
-extern int remove_exclusive_swap_page(struct page *);
-extern int remove_exclusive_swap_page_ref(struct page *);
+extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
 /* linux/mm/thrash.c */
@@ -388,12 +387,7 @@ static inline void delete_from_swap_cach
 
 #define reuse_swap_page(page)	(page_mapcount(page) == 1)
 
-static inline int remove_exclusive_swap_page(struct page *p)
-{
-	return 0;
-}
-
-static inline int remove_exclusive_swap_page_ref(struct page *page)
+static inline int try_to_free_swap(struct page *page)
 {
 	return 0;
 }
diff -puN mm/memory.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page mm/memory.c
--- a/mm/memory.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page
+++ a/mm/memory.c
@@ -2403,7 +2403,7 @@ static int do_swap_page(struct mm_struct
 
 	swap_free(entry);
 	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
-		remove_exclusive_swap_page(page);
+		try_to_free_swap(page);
 	unlock_page(page);
 
 	if (write_access) {
diff -puN mm/page_io.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page mm/page_io.c
--- a/mm/page_io.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page
+++ a/mm/page_io.c
@@ -98,7 +98,7 @@ int swap_writepage(struct page *page, st
 	struct bio *bio;
 	int ret = 0, rw = WRITE;
 
-	if (remove_exclusive_swap_page(page)) {
+	if (try_to_free_swap(page)) {
 		unlock_page(page);
 		goto out;
 	}
diff -puN mm/swap.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page mm/swap.c
--- a/mm/swap.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page
+++ a/mm/swap.c
@@ -454,8 +454,7 @@ void pagevec_swap_free(struct pagevec *p
 		struct page *page = pvec->pages[i];
 
 		if (PageSwapCache(page) && trylock_page(page)) {
-			if (PageSwapCache(page))
-				remove_exclusive_swap_page_ref(page);
+			try_to_free_swap(page);
 			unlock_page(page);
 		}
 	}
diff -puN mm/swap_state.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page mm/swap_state.c
--- a/mm/swap_state.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page
+++ a/mm/swap_state.c
@@ -195,14 +195,14 @@ void delete_from_swap_cache(struct page 
  * If we are the only user, then try to free up the swap cache. 
  * 
  * Its ok to check for PageSwapCache without the page lock
- * here because we are going to recheck again inside 
- * exclusive_swap_page() _with_ the lock. 
+ * here because we are going to recheck again inside
+ * try_to_free_swap() _with_ the lock.
  * 					- Marcelo
  */
 static inline void free_swap_cache(struct page *page)
 {
-	if (PageSwapCache(page) && trylock_page(page)) {
-		remove_exclusive_swap_page(page);
+	if (PageSwapCache(page) && !page_mapped(page) && trylock_page(page)) {
+		try_to_free_swap(page);
 		unlock_page(page);
 	}
 }
diff -puN mm/swapfile.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page mm/swapfile.c
--- a/mm/swapfile.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page
+++ a/mm/swapfile.c
@@ -348,68 +348,23 @@ int reuse_swap_page(struct page *page)
 }
 
 /*
- * Work out if there are any other processes sharing this
- * swap cache page. Free it if you can. Return success.
+ * If swap is getting full, or if there are no more mappings of this page,
+ * then try_to_free_swap is called to free its swap space.
  */
-static int remove_exclusive_swap_page_count(struct page *page, int count)
+int try_to_free_swap(struct page *page)
 {
-	int retval;
-	struct swap_info_struct * p;
-	swp_entry_t entry;
-
 	VM_BUG_ON(!PageLocked(page));
 
 	if (!PageSwapCache(page))
 		return 0;
 	if (PageWriteback(page))
 		return 0;
-	if (page_count(page) != count) /* us + cache + ptes */
-		return 0;
-
-	entry.val = page_private(page);
-	p = swap_info_get(entry);
-	if (!p)
+	if (page_swapcount(page))
 		return 0;
 
-	/* Is the only swap cache user the cache itself? */
-	retval = 0;
-	if (p->swap_map[swp_offset(entry)] == 1) {
-		/* Recheck the page count with the swapcache lock held.. */
-		spin_lock_irq(&swapper_space.tree_lock);
-		if ((page_count(page) == count) && !PageWriteback(page)) {
-			__delete_from_swap_cache(page);
-			SetPageDirty(page);
-			retval = 1;
-		}
-		spin_unlock_irq(&swapper_space.tree_lock);
-	}
-	spin_unlock(&swap_lock);
-
-	if (retval) {
-		swap_free(entry);
-		page_cache_release(page);
-	}
-
-	return retval;
-}
-
-/*
- * Most of the time the page should have two references: one for the
- * process and one for the swap cache.
- */
-int remove_exclusive_swap_page(struct page *page)
-{
-	return remove_exclusive_swap_page_count(page, 2);
-}
-
-/*
- * The pageout code holds an extra reference to the page.  That raises
- * the reference count to test for to 2 for a page that is only in the
- * swap cache plus 1 for each process that maps the page.
- */
-int remove_exclusive_swap_page_ref(struct page *page)
-{
-	return remove_exclusive_swap_page_count(page, 2 + page_mapcount(page));
+	delete_from_swap_cache(page);
+	SetPageDirty(page);
+	return 1;
 }
 
 /*
@@ -436,13 +391,12 @@ void free_swap_and_cache(swp_entry_t ent
 		spin_unlock(&swap_lock);
 	}
 	if (page) {
-		int one_user;
-
-		one_user = (page_count(page) == 2);
-		/* Only cache user (+us), or swap space full? Free it! */
-		/* Also recheck PageSwapCache after page is locked (above) */
+		/*
+		 * Not mapped elsewhere, or swap space full? Free it!
+		 * Also recheck PageSwapCache now page is locked (above).
+		 */
 		if (PageSwapCache(page) && !PageWriteback(page) &&
-					(one_user || vm_swap_full())) {
+				(!page_mapped(page) || vm_swap_full())) {
 			delete_from_swap_cache(page);
 			SetPageDirty(page);
 		}
diff -puN mm/vmscan.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page mm/vmscan.c
--- a/mm/vmscan.c~mm-try_to_free_swap-replaces-remove_exclusive_swap_page
+++ a/mm/vmscan.c
@@ -759,7 +759,7 @@ cull_mlocked:
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (PageSwapCache(page) && vm_swap_full())
-			remove_exclusive_swap_page_ref(page);
+			try_to_free_swap(page);
 		VM_BUG_ON(PageActive(page));
 		SetPageActive(page);
 		pgactivate++;
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

