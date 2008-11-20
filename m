From: akpm@linux-foundation.org
Subject: - vmscan-let-gfp_nofs-go-to-swap-again.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:07 -0800
Message-ID: <200811202043.mAKKh7ql007304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755570AbYKTUoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:44:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: let GFP_NOFS go to swap again
has been removed from the -mm tree.  Its filename was
     vmscan-let-gfp_nofs-go-to-swap-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: let GFP_NOFS go to swap again
From: Hugh Dickins <hugh@veritas.com>

In the past, GFP_NOFS (but of course not GFP_NOIO) was allowed to reclaim
by writing to swap.  That got partially broken in 2.6.23, when may_enter_fs
initialization was moved up before the allocation of swap, so its
PageSwapCache test was failing the first time around,

Fix it by setting may_enter_fs when add_to_swap() succeeds with
__GFP_IO.  In fact, check __GFP_IO before calling add_to_swap():
allocating swap we're not ready to use just increases disk seeking.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/vmscan.c~vmscan-let-gfp_nofs-go-to-swap-again mm/vmscan.c
--- a/mm/vmscan.c~vmscan-let-gfp_nofs-go-to-swap-again
+++ a/mm/vmscan.c
@@ -623,6 +623,8 @@ static unsigned long shrink_page_list(st
 		 * Try to allocate it some swap space here.
 		 */
 		if (PageAnon(page) && !PageSwapCache(page)) {
+			if (!(sc->gfp_mask & __GFP_IO))
+				goto keep_locked;
 			switch (try_to_munlock(page)) {
 			case SWAP_FAIL:		/* shouldn't happen */
 			case SWAP_AGAIN:
@@ -634,6 +636,7 @@ static unsigned long shrink_page_list(st
 			}
 			if (!add_to_swap(page, GFP_ATOMIC))
 				goto activate_locked;
+			may_enter_fs = 1;
 		}
 #endif /* CONFIG_SWAP */
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch

