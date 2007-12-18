From: akpm@linux-foundation.org
Subject: + tmpfs-allow-filepage-alongside-swappage.patch added to -mm tree
Date: Tue, 18 Dec 2007 14:33:14 -0800
Message-ID: <200712182233.lBIMXEqj025433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbXLRWdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 17:33:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     tmpfs: allow filepage alongside swappage
has been added to the -mm tree.  Its filename is
     tmpfs-allow-filepage-alongside-swappage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tmpfs: allow filepage alongside swappage
From: Hugh Dickins <hugh@veritas.com>

tmpfs has long allowed for a fresh filepage to be created in pagecache, just
before shmem_getpage gets the chance to match it up with the swappage which
already belongs to that offset.  But unionfs_writepage now does a
find_or_create_page, divorced from shmem_getpage, which leaves conflicting
filepage and swappage outstanding indefinitely, when unionfs is over tmpfs.

Therefore shmem_writepage (where a page is swizzled from file to swap) must
now be on the lookout for existing swap, ready to free it in favour of the
more uptodate filepage, instead of BUGging on that clash.  And when the
add_to_page_cache fails in shmem_unuse_inode, it must defer to an uptodate
filepage, otherwise swapoff would hang.  Whereas when add_to_page_cache fails
in shmem_getpage, it should retry in the same way it already does.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   69 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 25 deletions(-)

diff -puN mm/shmem.c~tmpfs-allow-filepage-alongside-swappage mm/shmem.c
--- a/mm/shmem.c~tmpfs-allow-filepage-alongside-swappage
+++ a/mm/shmem.c
@@ -827,6 +827,7 @@ static int shmem_unuse_inode(struct shme
 	struct page *subdir;
 	swp_entry_t *ptr;
 	int offset;
+	int error;
 
 	idx = 0;
 	ptr = info->i_direct;
@@ -884,7 +885,20 @@ lost2:
 found:
 	idx += offset;
 	inode = &info->vfs_inode;
-	if (add_to_page_cache(page, inode->i_mapping, idx, GFP_ATOMIC) == 0) {
+	error = add_to_page_cache(page, inode->i_mapping, idx, GFP_ATOMIC);
+	if (error == -EEXIST) {
+		struct page *filepage = find_get_page(inode->i_mapping, idx);
+		if (filepage) {
+			/*
+			 * There might be a more uptodate page coming down
+			 * from a stacked writepage: forget our swappage if so.
+			 */
+			if (PageUptodate(filepage))
+				error = 0;
+			page_cache_release(filepage);
+		}
+	}
+	if (!error) {
 		delete_from_swap_cache(page);
 		set_page_dirty(page);
 		info->flags |= SHMEM_PAGEIN;
@@ -937,44 +951,45 @@ static int shmem_writepage(struct page *
 	struct inode *inode;
 
 	BUG_ON(!PageLocked(page));
-	/*
-	 * shmem_backing_dev_info's capabilities prevent regular writeback or
-	 * sync from ever calling shmem_writepage; but a stacking filesystem
-	 * may use the ->writepage of its underlying filesystem, in which case
-	 * we want to do nothing when that underlying filesystem is tmpfs
-	 * (writing out to swap is useful as a response to memory pressure, but
-	 * of no use to stabilize the data) - just redirty the page, unlock it
-	 * and claim success in this case.  AOP_WRITEPAGE_ACTIVATE, and the
-	 * page_mapped check below, must be avoided unless we're in reclaim.
-	 */
-	if (!wbc->for_reclaim) {
-		set_page_dirty(page);
-		unlock_page(page);
-		return 0;
-	}
-	BUG_ON(page_mapped(page));
-
 	mapping = page->mapping;
 	index = page->index;
 	inode = mapping->host;
 	info = SHMEM_I(inode);
 	if (info->flags & VM_LOCKED)
 		goto redirty;
-	swap = get_swap_page();
-	if (!swap.val)
+	if (!total_swap_pages)
 		goto redirty;
 
+	/*
+	 * shmem_backing_dev_info's capabilities prevent regular writeback or
+	 * sync from ever calling shmem_writepage; but a stacking filesystem
+	 * may use the ->writepage of its underlying filesystem, in which case
+	 * tmpfs should write out to swap only in response to memory pressure,
+	 * and not for pdflush or sync.  However, in those cases, we do still
+	 * want to check if there's a redundant swappage to be discarded.
+	 */
+	if (wbc->for_reclaim)
+		swap = get_swap_page();
+	else
+		swap.val = 0;
+
 	spin_lock(&info->lock);
-	shmem_recalc_inode(inode);
 	if (index >= info->next_index) {
 		BUG_ON(!(info->flags & SHMEM_TRUNCATE));
 		goto unlock;
 	}
 	entry = shmem_swp_entry(info, index, NULL);
-	BUG_ON(!entry);
-	BUG_ON(entry->val);
+	if (entry->val) {
+		/*
+		 * The more uptodate page coming down from a stacked
+		 * writepage should replace our old swappage.
+		 */
+		free_swap_and_cache(*entry);
+		shmem_swp_set(info, entry, 0);
+	}
+	shmem_recalc_inode(inode);
 
-	if (add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
+	if (swap.val && add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
 		remove_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
@@ -986,6 +1001,7 @@ static int shmem_writepage(struct page *
 			spin_unlock(&shmem_swaplist_lock);
 		}
 		swap_duplicate(swap);
+		BUG_ON(page_mapped(page));
 		page_cache_release(page);	/* pagecache ref */
 		set_page_dirty(page);
 		unlock_page(page);
@@ -998,7 +1014,10 @@ unlock:
 	swap_free(swap);
 redirty:
 	set_page_dirty(page);
-	return AOP_WRITEPAGE_ACTIVATE;	/* Return with the page locked */
+	if (wbc->for_reclaim)
+		return AOP_WRITEPAGE_ACTIVATE;	/* Return with page locked */
+	unlock_page(page);
+	return 0;
 }
 
 #ifdef CONFIG_NUMA
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
