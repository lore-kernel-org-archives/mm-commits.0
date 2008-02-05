From: akpm@linux-foundation.org
Subject: - tmpfs-move-swap-swizzling-into-shmem.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:29 -0800
Message-ID: <200802052230.m15MUA1K012043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932194AbYBEWm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: move swap swizzling into shmem
has been removed from the -mm tree.  Its filename was
     tmpfs-move-swap-swizzling-into-shmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
