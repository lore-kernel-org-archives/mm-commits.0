From: akpm@linux-foundation.org
Subject: [folded] mm-add_to_swap_cache-does-not-return-eexist-fix.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:24:49 -0700
Message-ID: <200909212124.n8LLOnEM010686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbZIUVZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     mm-add_to_swap_cache-does-not-return-eexist-fix
has been removed from the -mm tree.  Its filename was
     mm-add_to_swap_cache-does-not-return-eexist-fix.patch

This patch was dropped because it was folded into mm-add_to_swap_cache-does-not-return-eexist.patch

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
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch

