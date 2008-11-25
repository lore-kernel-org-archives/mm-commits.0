From: akpm@linux-foundation.org
Subject: + mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:15:47 -0800
Message-ID: <200811252215.mAPMFl1C005829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbYKYWQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:16:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     mm: try_to_free_swap replaces remove_exclusive_swap_page
has been added to the -mm tree.  Its filename is
     mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch

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
@@ -308,8 +308,7 @@ extern sector_t map_swap_page(struct swa
 extern sector_t swapdev_block(int, pgoff_t);
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
 extern int reuse_swap_page(struct page *);
-extern int remove_exclusive_swap_page(struct page *);
-extern int remove_exclusive_swap_page_ref(struct page *);
+extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
 /* linux/mm/thrash.c */
@@ -391,12 +390,7 @@ static inline void delete_from_swap_cach
 
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
@@ -2374,7 +2374,7 @@ static int do_swap_page(struct mm_struct
 
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
@@ -467,8 +467,7 @@ void pagevec_swap_free(struct pagevec *p
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
@@ -805,7 +805,7 @@ cull_mlocked:
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (PageSwapCache(page) && vm_swap_full())
-			remove_exclusive_swap_page_ref(page);
+			try_to_free_swap(page);
 		VM_BUG_ON(PageActive(page));
 		SetPageActive(page);
 keep_locked:
_

Patches currently in -mm which might be from hugh@veritas.com are

linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
prio_tree-debugging-patch.patch

