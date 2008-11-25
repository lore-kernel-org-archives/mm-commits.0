From: akpm@linux-foundation.org
Subject: + mm-remove-gfp_mask-from-add_to_swap.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:15:55 -0800
Message-ID: <200811252215.mAPMFuF8005887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbYKYW0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:26:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     mm: remove gfp_mask from add_to_swap
has been added to the -mm tree.  Its filename is
     mm-remove-gfp_mask-from-add_to_swap.patch

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
Subject: mm: remove gfp_mask from add_to_swap
From: Hugh Dickins <hugh@veritas.com>

Remove gfp_mask argument from add_to_swap(): it's misleading because its
only caller, shrink_page_list(), is not atomic at that point; and in due
course (implementing discard) we'll sometimes want to allocate some memory
with GFP_NOIO (as is used in swap_writepage) when allocating swap.

No change to the gfp_mask passed down to add_to_swap_cache(): still use
__GFP_HIGH without __GFP_WAIT (with nomemalloc and nowarn as before):
though it's not obvious if that's the best combination to ask for here.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/swap_state.c      |    4 ++--
 mm/vmscan.c          |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/swap.h~mm-remove-gfp_mask-from-add_to_swap include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-gfp_mask-from-add_to_swap
+++ a/include/linux/swap.h
@@ -281,7 +281,7 @@ extern void end_swap_bio_read(struct bio
 extern struct address_space swapper_space;
 #define total_swapcache_pages  swapper_space.nrpages
 extern void show_swap_cache_info(void);
-extern int add_to_swap(struct page *, gfp_t);
+extern int add_to_swap(struct page *);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
 extern void __delete_from_swap_cache(struct page *);
 extern void delete_from_swap_cache(struct page *);
diff -puN mm/swap_state.c~mm-remove-gfp_mask-from-add_to_swap mm/swap_state.c
--- a/mm/swap_state.c~mm-remove-gfp_mask-from-add_to_swap
+++ a/mm/swap_state.c
@@ -128,7 +128,7 @@ void __delete_from_swap_cache(struct pag
  * Allocate swap space for the page and add the page to the
  * swap cache.  Caller needs to hold the page lock. 
  */
-int add_to_swap(struct page * page, gfp_t gfp_mask)
+int add_to_swap(struct page *page)
 {
 	swp_entry_t entry;
 	int err;
@@ -153,7 +153,7 @@ int add_to_swap(struct page * page, gfp_
 		 * Add it to the swap cache and mark it dirty
 		 */
 		err = add_to_swap_cache(page, entry,
-				gfp_mask|__GFP_NOMEMALLOC|__GFP_NOWARN);
+				__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN);
 
 		switch (err) {
 		case 0:				/* Success */
diff -puN mm/vmscan.c~mm-remove-gfp_mask-from-add_to_swap mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-gfp_mask-from-add_to_swap
+++ a/mm/vmscan.c
@@ -673,7 +673,7 @@ static unsigned long shrink_page_list(st
 		if (PageAnon(page) && !PageSwapCache(page)) {
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
-			if (!add_to_swap(page, GFP_ATOMIC))
+			if (!add_to_swap(page))
 				goto activate_locked;
 			may_enter_fs = 1;
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

