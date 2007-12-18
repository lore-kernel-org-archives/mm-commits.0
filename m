From: akpm@linux-foundation.org
Subject: + tmpfs-move-swap-swizzling-into-shmem.patch added to -mm tree
Date: Tue, 18 Dec 2007 14:32:53 -0800
Message-ID: <200712182232.lBIMWr92025345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbXLRWc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 17:32:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     tmpfs: move swap swizzling into shmem
has been added to the -mm tree.  Its filename is
     tmpfs-move-swap-swizzling-into-shmem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tmpfs: move swap swizzling into shmem
From: Hugh Dickins <hugh@veritas.com>

move_to_swap_cache and move_from_swap_cache functions (which swizzle a page
between tmpfs page cache and swap cache, to avoid page copying) are only used
by shmem.c; and our subsequent fix for unionfs needs different treatments in
the two instances of move_from_swap_cache.  Move them from swap_state.c into
their callsites shmem_writepage, shmem_unuse_inode and shmem_getpage, making
add_to_swap_cache externally visible.

shmem.c likes to say set_page_dirty where swap_state.c liked to say
SetPageDirty: respect that diversity, which __set_page_dirty_no_writeback
makes moot (and implies we should lose that "shift page from clean_pages to
dirty_pages list" comment: it's on neither).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   15 ++++-----------
 mm/shmem.c           |   16 ++++++++++++----
 mm/swap_state.c      |   35 +----------------------------------
 3 files changed, 17 insertions(+), 49 deletions(-)

diff -puN include/linux/swap.h~tmpfs-move-swap-swizzling-into-shmem include/linux/swap.h
--- a/include/linux/swap.h~tmpfs-move-swap-swizzling-into-shmem
+++ a/include/linux/swap.h
@@ -220,11 +220,9 @@ extern struct address_space swapper_spac
 #define total_swapcache_pages  swapper_space.nrpages
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *, gfp_t);
+extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
 extern void __delete_from_swap_cache(struct page *);
 extern void delete_from_swap_cache(struct page *);
-extern int move_to_swap_cache(struct page *, swp_entry_t);
-extern int move_from_swap_cache(struct page *, unsigned long,
-		struct address_space *);
 extern void free_page_and_swap_cache(struct page *);
 extern void free_pages_and_swap_cache(struct page **, int);
 extern struct page *lookup_swap_cache(swp_entry_t);
@@ -319,15 +317,10 @@ static inline struct page *lookup_swap_c
 
 #define can_share_swap_page(p)			(page_mapcount(p) == 1)
 
-static inline int move_to_swap_cache(struct page *page, swp_entry_t entry)
+static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
+							gfp_t gfp_mask)
 {
-	return 1;
-}
-
-static inline int move_from_swap_cache(struct page *page, unsigned long index,
-					struct address_space *mapping)
-{
-	return 1;
+	return -1;
 }
 
 static inline void __delete_from_swap_cache(struct page *page)
diff -puN mm/shmem.c~tmpfs-move-swap-swizzling-into-shmem mm/shmem.c
--- a/mm/shmem.c~tmpfs-move-swap-swizzling-into-shmem
+++ a/mm/shmem.c
@@ -884,7 +884,9 @@ lost2:
 found:
 	idx += offset;
 	inode = &info->vfs_inode;
-	if (move_from_swap_cache(page, idx, inode->i_mapping) == 0) {
+	if (add_to_page_cache(page, inode->i_mapping, idx, GFP_ATOMIC) == 0) {
+		delete_from_swap_cache(page);
+		set_page_dirty(page);
 		info->flags |= SHMEM_PAGEIN;
 		shmem_swp_set(info, ptr + offset, 0);
 	}
@@ -972,7 +974,8 @@ static int shmem_writepage(struct page *
 	BUG_ON(!entry);
 	BUG_ON(entry->val);
 
-	if (move_to_swap_cache(page, swap) == 0) {
+	if (add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
+		remove_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
 		spin_unlock(&info->lock);
@@ -982,6 +985,9 @@ static int shmem_writepage(struct page *
 			list_move_tail(&info->swaplist, &shmem_swaplist);
 			spin_unlock(&shmem_swaplist_lock);
 		}
+		swap_duplicate(swap);
+		page_cache_release(page);	/* pagecache ref */
+		set_page_dirty(page);
 		unlock_page(page);
 		return 0;
 	}
@@ -1217,13 +1223,15 @@ repeat:
 			SetPageUptodate(filepage);
 			set_page_dirty(filepage);
 			swap_free(swap);
-		} else if (!(error = move_from_swap_cache(
-				swappage, idx, mapping))) {
+		} else if (!(error = add_to_page_cache(
+				swappage, mapping, idx, GFP_ATOMIC))) {
 			info->flags |= SHMEM_PAGEIN;
 			shmem_swp_set(info, entry, 0);
 			shmem_swp_unmap(entry);
+			delete_from_swap_cache(swappage);
 			spin_unlock(&info->lock);
 			filepage = swappage;
+			set_page_dirty(filepage);
 			swap_free(swap);
 		} else {
 			shmem_swp_unmap(entry);
diff -puN mm/swap_state.c~tmpfs-move-swap-swizzling-into-shmem mm/swap_state.c
--- a/mm/swap_state.c~tmpfs-move-swap-swizzling-into-shmem
+++ a/mm/swap_state.c
@@ -67,8 +67,7 @@ void show_swap_cache_info(void)
  * add_to_swap_cache resembles add_to_page_cache on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
-static int add_to_swap_cache(struct page *page, swp_entry_t entry,
-			       gfp_t gfp_mask)
+int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
 {
 	int error;
 
@@ -183,38 +182,6 @@ void delete_from_swap_cache(struct page 
 	page_cache_release(page);
 }
 
-/*
- * Strange swizzling function only for use by shmem_writepage
- */
-int move_to_swap_cache(struct page *page, swp_entry_t entry)
-{
-	int err = add_to_swap_cache(page, entry, GFP_ATOMIC);
-	if (!err) {
-		remove_from_page_cache(page);
-		page_cache_release(page);	/* pagecache ref */
-		if (!swap_duplicate(entry))
-			BUG();
-		SetPageDirty(page);
-	}
-	return err;
-}
-
-/*
- * Strange swizzling function for shmem_getpage (and shmem_unuse)
- */
-int move_from_swap_cache(struct page *page, unsigned long index,
-		struct address_space *mapping)
-{
-	int err = add_to_page_cache(page, mapping, index, GFP_ATOMIC);
-	if (!err) {
-		delete_from_swap_cache(page);
-		/* shift page from clean_pages to dirty_pages list */
-		ClearPageDirty(page);
-		set_page_dirty(page);
-	}
-	return err;
-}
-
 /* 
  * If we are the only user, then try to free up the swap cache. 
  * 
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
