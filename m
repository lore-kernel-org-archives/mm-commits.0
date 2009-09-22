From: akpm@linux-foundation.org
Subject: [merged] mm-add_to_swap_cache-does-not-return-eexist.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:24 -0700
Message-ID: <200909222041.n8MKfO5L007509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbZIVUmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: add_to_swap_cache() does not return -EEXIST
has been removed from the -mm tree.  Its filename was
     mm-add_to_swap_cache-does-not-return-eexist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add_to_swap_cache() does not return -EEXIST
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

After commit 355cfa73 ("mm: modify swap_map and add SWAP_HAS_CACHE flag"),
only the context which have set SWAP_HAS_CACHE flag by swapcache_prepare()
or get_swap_page() would call add_to_swap_cache().  So add_to_swap_cache()
doesn't return -EEXIST any more.

Even though it doesn't return -EEXIST, it's not good behavior conceptually
to call swapcache_prepare() in the -EEXIST case, because it means clearing
SWAP_HAS_CACHE flag while the entry is on swap cache.

This patch removes redundant codes and comments from callers of it, and
adds VM_BUG_ON() in error path of add_to_swap_cache() and some comments.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c      |    4 ++
 mm/swap_state.c |   73 ++++++++++++++++++++++------------------------
 2 files changed, 40 insertions(+), 37 deletions(-)

diff -puN mm/shmem.c~mm-add_to_swap_cache-does-not-return-eexist mm/shmem.c
--- a/mm/shmem.c~mm-add_to_swap_cache-does-not-return-eexist
+++ a/mm/shmem.c
@@ -1097,6 +1097,10 @@ static int shmem_writepage(struct page *
 	shmem_swp_unmap(entry);
 unlock:
 	spin_unlock(&info->lock);
+	/*
+	 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
+	 * clear SWAP_HAS_CACHE flag.
+	 */
 	swapcache_free(swap, NULL);
 redirty:
 	set_page_dirty(page);
diff -puN mm/swap_state.c~mm-add_to_swap_cache-does-not-return-eexist mm/swap_state.c
--- a/mm/swap_state.c~mm-add_to_swap_cache-does-not-return-eexist
+++ a/mm/swap_state.c
@@ -92,6 +92,12 @@ static int __add_to_swap_cache(struct pa
 	spin_unlock_irq(&swapper_space.tree_lock);
 
 	if (unlikely(error)) {
+		/*
+		 * Only the context which have set SWAP_HAS_CACHE flag
+		 * would call add_to_swap_cache().
+		 * So add_to_swap_cache() doesn't returns -EEXIST.
+		 */
+		VM_BUG_ON(error == -EEXIST);
 		set_page_private(page, 0UL);
 		ClearPageSwapCache(page);
 		page_cache_release(page);
@@ -146,38 +152,34 @@ int add_to_swap(struct page *page)
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(!PageUptodate(page));
 
-	for (;;) {
-		entry = get_swap_page();
-		if (!entry.val)
-			return 0;
+	entry = get_swap_page();
+	if (!entry.val)
+		return 0;
 
+	/*
+	 * Radix-tree node allocations from PF_MEMALLOC contexts could
+	 * completely exhaust the page allocator. __GFP_NOMEMALLOC
+	 * stops emergency reserves from being allocated.
+	 *
+	 * TODO: this could cause a theoretical memory reclaim
+	 * deadlock in the swap out path.
+	 */
+	/*
+	 * Add it to the swap cache and mark it dirty
+	 */
+	err = add_to_swap_cache(page, entry,
+			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN);
+
+	if (!err) {	/* Success */
+		SetPageDirty(page);
+		return 1;
+	} else {	/* -ENOMEM radix-tree allocation failure */
 		/*
-		 * Radix-tree node allocations from PF_MEMALLOC contexts could
-		 * completely exhaust the page allocator. __GFP_NOMEMALLOC
-		 * stops emergency reserves from being allocated.
-		 *
-		 * TODO: this could cause a theoretical memory reclaim
-		 * deadlock in the swap out path.
-		 */
-		/*
-		 * Add it to the swap cache and mark it dirty
+		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
+		 * clear SWAP_HAS_CACHE flag.
 		 */
-		err = add_to_swap_cache(page, entry,
-				__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN);
-
-		switch (err) {
-		case 0:				/* Success */
-			SetPageDirty(page);
-			return 1;
-		case -EEXIST:
-			/* Raced with "speculative" read_swap_cache_async */
-			swapcache_free(entry, NULL);
-			continue;
-		default:
-			/* -ENOMEM radix-tree allocation failure */
-			swapcache_free(entry, NULL);
-			return 0;
-		}
+		swapcache_free(entry, NULL);
+		return 0;
 	}
 }
 
@@ -318,14 +320,7 @@ struct page *read_swap_cache_async(swp_e
 			break;
 		}
 
-		/*
-		 * Associate the page with swap entry in the swap cache.
-		 * May fail (-EEXIST) if there is already a page associated
-		 * with this entry in the swap cache: added by a racing
-		 * read_swap_cache_async, or add_to_swap or shmem_writepage
-		 * re-using the just freed swap entry for an existing page.
-		 * May fail (-ENOMEM) if radix-tree node allocation failed.
-		 */
+		/* May fail (-ENOMEM) if radix-tree node allocation failed. */
 		__set_page_locked(new_page);
 		SetPageSwapBacked(new_page);
 		err = __add_to_swap_cache(new_page, entry);
@@ -341,6 +336,10 @@ struct page *read_swap_cache_async(swp_e
 		radix_tree_preload_end();
 		ClearPageSwapBacked(new_page);
 		__clear_page_locked(new_page);
+		/*
+		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
+		 * clear SWAP_HAS_CACHE flag.
+		 */
 		swapcache_free(entry, NULL);
 	} while (err != -ENOMEM);
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
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

