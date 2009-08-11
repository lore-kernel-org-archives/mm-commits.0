From: akpm@linux-foundation.org
Subject: + mm-add_to_swap_cache-does-not-return-eexist.patch added to -mm tree
Date: Mon, 10 Aug 2009 22:33:23 -0700
Message-ID: <200908110533.n7B5XNgN027965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857AbZHKLyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: add_to_swap_cache() does not return -EEXIST
has been added to the -mm tree.  Its filename is
     mm-add_to_swap_cache-does-not-return-eexist.patch

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
@@ -96,6 +96,12 @@ int add_to_swap_cache(struct page *page,
 		radix_tree_preload_end();
 
 		if (unlikely(error)) {
+			/*
+			 * Only the context which have set SWAP_HAS_CACHE flag
+			 * would call add_to_swap_cache().
+			 * So add_to_swap_cache() doesn't returns -EEXIST.
+			 */
+			VM_BUG_ON(error == -EEXIST);
 			set_page_private(page, 0UL);
 			ClearPageSwapCache(page);
 			page_cache_release(page);
@@ -137,38 +143,34 @@ int add_to_swap(struct page *page)
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
 
@@ -298,14 +300,7 @@ struct page *read_swap_cache_async(swp_e
 		if (err)           /* swp entry is obsolete ? */
 			break;
 
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
 		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
@@ -319,6 +314,10 @@ struct page *read_swap_cache_async(swp_e
 		}
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

mm-add_to_swap_cache-does-not-return-eexist.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch

