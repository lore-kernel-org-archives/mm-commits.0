From: akpm@linux-foundation.org
Subject: - tmpfs-shuffle-add_to_swap_caches.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:27 -0800
Message-ID: <200802052230.m15MU8YS012038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932263AbYBEWnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     tmpfs: shuffle add_to_swap_caches
has been removed from the -mm tree.  Its filename was
     tmpfs-shuffle-add_to_swap_caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: shuffle add_to_swap_caches
From: Hugh Dickins <hugh@veritas.com>

add_to_swap_cache doesn't amount to much: merge it into its sole caller
read_swap_cache_async.  But we'll be needing to call __add_to_swap_cache from
shmem.c, so promote it to the new add_to_swap_cache.  Both were static, so
there's no interface confusion to worry about.

And lose that inappropriate "Anon pages are already on the LRU" comment in the
merging: they're not already on the LRU, as Nick Piggin noticed.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
No-problems-with: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   53 ++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

diff -puN mm/swap_state.c~tmpfs-shuffle-add_to_swap_caches mm/swap_state.c
--- a/mm/swap_state.c~tmpfs-shuffle-add_to_swap_caches
+++ a/mm/swap_state.c
@@ -64,10 +64,10 @@ void show_swap_cache_info(void)
 }
 
 /*
- * __add_to_swap_cache resembles add_to_page_cache on swapper_space,
+ * add_to_swap_cache resembles add_to_page_cache on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
-static int __add_to_swap_cache(struct page *page, swp_entry_t entry,
+static int add_to_swap_cache(struct page *page, swp_entry_t entry,
 			       gfp_t gfp_mask)
 {
 	int error;
@@ -94,28 +94,6 @@ static int __add_to_swap_cache(struct pa
 	return error;
 }
 
-static int add_to_swap_cache(struct page *page, swp_entry_t entry,
-				gfp_t gfp_mask)
-{
-	int error;
-
-	BUG_ON(PageLocked(page));
-	if (!swap_duplicate(entry))
-		return -ENOENT;
-
-	SetPageLocked(page);
-	error = __add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL);
-	/*
-	 * Anon pages are already on the LRU, we don't run lru_cache_add here.
-	 */
-	if (error) {
-		ClearPageLocked(page);
-		swap_free(entry);
-		return error;
-	}
-	return 0;
-}
-
 /*
  * This must be called only on pages that have
  * been verified to be in the swap cache.
@@ -165,7 +143,7 @@ int add_to_swap(struct page * page, gfp_
 		/*
 		 * Add it to the swap cache and mark it dirty
 		 */
-		err = __add_to_swap_cache(page, entry,
+		err = add_to_swap_cache(page, entry,
 				gfp_mask|__GFP_NOMEMALLOC|__GFP_NOWARN);
 
 		switch (err) {
@@ -210,7 +188,7 @@ void delete_from_swap_cache(struct page 
  */
 int move_to_swap_cache(struct page *page, swp_entry_t entry)
 {
-	int err = __add_to_swap_cache(page, entry, GFP_ATOMIC);
+	int err = add_to_swap_cache(page, entry, GFP_ATOMIC);
 	if (!err) {
 		remove_from_page_cache(page);
 		page_cache_release(page);	/* pagecache ref */
@@ -335,16 +313,21 @@ struct page *read_swap_cache_async(swp_e
 		}
 
 		/*
+		 * Swap entry may have been freed since our caller observed it.
+		 */
+		if (!swap_duplicate(entry))
+			break;
+
+		/*
 		 * Associate the page with swap entry in the swap cache.
-		 * May fail (-ENOENT) if swap entry has been freed since
-		 * our caller observed it.  May fail (-EEXIST) if there
-		 * is already a page associated with this entry in the
-		 * swap cache: added by a racing read_swap_cache_async,
-		 * or by try_to_swap_out (or shmem_writepage) re-using
-		 * the just freed swap entry for an existing page.
+		 * May fail (-EEXIST) if there is already a page associated
+		 * with this entry in the swap cache: added by a racing
+		 * read_swap_cache_async, or add_to_swap or shmem_writepage
+		 * re-using the just freed swap entry for an existing page.
 		 * May fail (-ENOMEM) if radix-tree node allocation failed.
 		 */
-		err = add_to_swap_cache(new_page, entry, gfp_mask);
+		SetPageLocked(new_page);
+		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
 		if (!err) {
 			/*
 			 * Initiate read into locked page and return.
@@ -353,7 +336,9 @@ struct page *read_swap_cache_async(swp_e
 			swap_readpage(NULL, new_page);
 			return new_page;
 		}
-	} while (err != -ENOENT && err != -ENOMEM);
+		ClearPageLocked(new_page);
+		swap_free(entry);
+	} while (err != -ENOMEM);
 
 	if (new_page)
 		page_cache_release(new_page);
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
prio_tree-debugging-patch.patch
