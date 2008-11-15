From: akpm@linux-foundation.org
Subject: + vmscan-let-gfp_nofs-go-to-swap-again.patch added to -mm tree
Date: Fri, 14 Nov 2008 16:41:28 -0800
Message-ID: <200811150041.mAF0fSb9026564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbYKOAlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 19:41:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, riel@redhat.com


The patch titled
     vmscan: let GFP_NOFS go to swap again
has been added to the -mm tree.  Its filename is
     vmscan-let-gfp_nofs-go-to-swap-again.patch

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
@@ -672,6 +672,8 @@ static unsigned long shrink_page_list(st
 		 * Try to allocate it some swap space here.
 		 */
 		if (PageAnon(page) && !PageSwapCache(page)) {
+			if (!(sc->gfp_mask & __GFP_IO))
+				goto keep_locked;
 			switch (try_to_munlock(page)) {
 			case SWAP_FAIL:		/* shouldn't happen */
 			case SWAP_AGAIN:
@@ -683,6 +685,7 @@ static unsigned long shrink_page_list(st
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
sprint_symbol-use-less-stack.patch
migration-fix-writepage-error.patch
vmscan-let-gfp_nofs-go-to-swap-again.patch
dont-unlink-an-active-swapfile.patch
mm-implement-remap_pfn_range-with-apply_to_page_range.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remap_pfn_range-restore-missing-flush.patch
prio_tree-debugging-patch.patch

