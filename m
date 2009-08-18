From: akpm@linux-foundation.org
Subject: + mm-add_to_swap_cache-does-not-return-eexist-fix.patch added to -mm tree
Date: Tue, 18 Aug 2009 15:38:05 -0700
Message-ID: <200908182238.n7IMc5OM007867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069AbZHRWih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 18:38:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp


The patch titled
     mm-add_to_swap_cache-does-not-return-eexist-fix
has been added to the -mm tree.  Its filename is
     mm-add_to_swap_cache-does-not-return-eexist-fix.patch

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
Subject: mm-add_to_swap_cache-does-not-return-eexist-fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

fix indent size.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/swap_state.c~mm-add_to_swap_cache-does-not-return-eexist-fix mm/swap_state.c
--- a/mm/swap_state.c~mm-add_to_swap_cache-does-not-return-eexist-fix
+++ a/mm/swap_state.c
@@ -92,12 +92,12 @@ static int __add_to_swap_cache(struct pa
 	spin_unlock_irq(&swapper_space.tree_lock);
 
 	if (unlikely(error)) {
-			/*
-			 * Only the context which have set SWAP_HAS_CACHE flag
-			 * would call add_to_swap_cache().
-			 * So add_to_swap_cache() doesn't returns -EEXIST.
-			 */
-			VM_BUG_ON(error == -EEXIST);
+		/*
+		 * Only the context which have set SWAP_HAS_CACHE flag
+		 * would call add_to_swap_cache().
+		 * So add_to_swap_cache() doesn't returns -EEXIST.
+		 */
+		VM_BUG_ON(error == -EEXIST);
 		set_page_private(page, 0UL);
 		ClearPageSwapCache(page);
 		page_cache_release(page);
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-add_to_swap_cache-does-not-return-eexist-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch

