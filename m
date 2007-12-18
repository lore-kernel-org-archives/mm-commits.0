From: akpm@linux-foundation.org
Subject: + tmpfs-shuffle-add_to_swap_caches.patch added to -mm tree
Date: Tue, 18 Dec 2007 14:32:22 -0800
Message-ID: <200712182232.lBIMWMI6025337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbXLRWce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 17:32:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     tmpfs: shuffle add_to_swap_caches
has been added to the -mm tree.  Its filename is
     tmpfs-shuffle-add_to_swap_caches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-unionfs.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
swapoff-scan-ptes-preemptibly.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
tmpfs-move-swap_state-stats-update.patch
tmpfs-shuffle-add_to_swap_caches.patch
tmpfs-move-swap-swizzling-into-shmem.patch
tmpfs-allow-filepage-alongside-swappage.patch
tmpfs-allocate-on-read-when-stacked.patch
tmpfs-make-shmem_unuse-more-preemptible.patch
tmpfs-open-a-window-in-shmem_unuse_inode.patch
tmpfs-radix_tree_preloading.patch
tmpfs-fix-shmem_swaplist-races.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
mm-dont-waste-swap-on-locked-pages.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
printk-trivial-optimizations-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
prio_tree-debugging-patch.patch
