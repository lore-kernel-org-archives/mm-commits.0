From: akpm@linux-foundation.org
Subject: + mm-try_to_unuse-check-removing-right-swap.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:15:50 -0800
Message-ID: <200811252215.mAPMFogp005834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbYKYWQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:16:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     mm: try_to_unuse check removing right swap
has been added to the -mm tree.  Its filename is
     mm-try_to_unuse-check-removing-right-swap.patch

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
Subject: mm: try_to_unuse check removing right swap
From: Hugh Dickins <hugh@veritas.com>

There's a possible race in try_to_unuse() which Nick Piggin led me to two
years ago.  Where it does lock_page() after read_swap_cache_async(), what
if another task removed that page from swapcache just before we locked it?

It would sail though the (*swap_map > 1) tests doing nothing (because it
could not have been removed from swapcache before its swap references were
gone), until it reaches the delete_from_swap_cache(page) near the bottom.

Now imagine that this page has been allocated to swap on a different swap
area while we dropped page lock (perhaps at the top, perhaps in unuse_mm):
we could wrongly remove from swap cache before the page has been written
to swap, so a subsequent do_swap_page() would read in stale data from
swap.

I think this case could not happen before: remove_exclusive_swap_page()
refused while page count was raised.  But now with reuse_swap_page() and
try_to_free_swap() removing from swap cache without minding page count, I
think it could happen - the previous patch argued that it was safe because
try_to_unuse() already ignored page count, but overlooked that it might be
breaking the assumptions in try_to_unuse() itself.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-try_to_unuse-check-removing-right-swap mm/swapfile.c
--- a/mm/swapfile.c~mm-try_to_unuse-check-removing-right-swap
+++ a/mm/swapfile.c
@@ -889,7 +889,16 @@ static int try_to_unuse(unsigned int typ
 			lock_page(page);
 			wait_on_page_writeback(page);
 		}
-		if (PageSwapCache(page))
+
+		/*
+		 * It is conceivable that a racing task removed this page from
+		 * swap cache just before we acquired the page lock at the top,
+		 * or while we dropped it in unuse_mm().  The page might even
+		 * be back in swap cache on another swap area: that we must not
+		 * delete, since it may not have been written out to swap yet.
+		 */
+		if (PageSwapCache(page) &&
+		    likely(page_private(page) == entry.val))
 			delete_from_swap_cache(page);
 
 		/*
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

