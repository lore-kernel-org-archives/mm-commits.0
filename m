From: akpm@linux-foundation.org
Subject: + mm-reuse_swap_page-replaces-can_share_swap_page.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:15:44 -0800
Message-ID: <200811252215.mAPMFjmU005752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbYKYWQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:16:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     mm: reuse_swap_page replaces can_share_swap_page
has been added to the -mm tree.  Its filename is
     mm-reuse_swap_page-replaces-can_share_swap_page.patch

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
@@ -307,7 +307,7 @@ extern unsigned int count_swap_pages(int
 extern sector_t map_swap_page(struct swap_info_struct *, pgoff_t);
 extern sector_t swapdev_block(int, pgoff_t);
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
-extern int can_share_swap_page(struct page *);
+extern int reuse_swap_page(struct page *);
 extern int remove_exclusive_swap_page(struct page *);
 extern int remove_exclusive_swap_page_ref(struct page *);
 struct backing_dev_info;
@@ -375,8 +375,6 @@ static inline struct page *lookup_swap_c
 	return NULL;
 }
 
-#define can_share_swap_page(p)			(page_mapcount(p) == 1)
-
 static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
 							gfp_t gfp_mask)
 {
@@ -391,7 +389,7 @@ static inline void delete_from_swap_cach
 {
 }
 
-#define swap_token_default_timeout		0
+#define reuse_swap_page(page)	(page_mapcount(page) == 1)
 
 static inline int remove_exclusive_swap_page(struct page *p)
 {
diff -puN mm/memory.c~mm-reuse_swap_page-replaces-can_share_swap_page mm/memory.c
--- a/mm/memory.c~mm-reuse_swap_page-replaces-can_share_swap_page
+++ a/mm/memory.c
@@ -1832,7 +1832,7 @@ static int do_wp_page(struct mm_struct *
 			}
 			page_cache_release(old_page);
 		}
-		reuse = can_share_swap_page(old_page);
+		reuse = reuse_swap_page(old_page);
 		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
@@ -2363,7 +2363,7 @@ static int do_swap_page(struct mm_struct
 
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

