From: akpm@linux-foundation.org
Subject: + tmpfs-open-a-window-in-shmem_unuse_inode.patch added to -mm tree
Date: Tue, 18 Dec 2007 14:34:14 -0800
Message-ID: <200712182234.lBIMYENB025483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbXLRWeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 17:34:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     tmpfs: open a window in shmem_unuse_inode
has been added to the -mm tree.  Its filename is
     tmpfs-open-a-window-in-shmem_unuse_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tmpfs: open a window in shmem_unuse_inode
From: Hugh Dickins <hugh@veritas.com>

There are a couple of reasons (patches follow) why it would be good to open a
window for sleep in shmem_unuse_inode, between its search for a matching swap
entry, and its handling of the entry found.

shmem_unuse_inode must then use igrab to hold the inode against deletion in
that window, and its corresponding iput might result in deletion: so it had
better unlock_page before the iput, and might as well release the page too.

Nor is there any need to hold on to shmem_swaplist_mutex once we know we'll
leave the loop.  So this unwinding moves from try_to_unuse and shmem_unuse
into shmem_unuse_inode, in the case when it finds a match.

Let try_to_unuse break on error in the shmem_unuse case, as it does in the
unuse_mm case: though at this point in the series, no error to break on.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c    |   57 +++++++++++++++++++++++++++++-------------------
 mm/swapfile.c |   23 ++++++++-----------
 2 files changed, 45 insertions(+), 35 deletions(-)

diff -puN mm/shmem.c~tmpfs-open-a-window-in-shmem_unuse_inode mm/shmem.c
--- a/mm/shmem.c~tmpfs-open-a-window-in-shmem_unuse_inode
+++ a/mm/shmem.c
@@ -838,10 +838,8 @@ static int shmem_unuse_inode(struct shme
 	if (size > SHMEM_NR_DIRECT)
 		size = SHMEM_NR_DIRECT;
 	offset = shmem_find_swp(entry, ptr, ptr+size);
-	if (offset >= 0) {
-		shmem_swp_balance_unmap();
+	if (offset >= 0)
 		goto found;
-	}
 	if (!info->i_indirect)
 		goto lost2;
 
@@ -879,11 +877,11 @@ static int shmem_unuse_inode(struct shme
 			if (size > ENTRIES_PER_PAGE)
 				size = ENTRIES_PER_PAGE;
 			offset = shmem_find_swp(entry, ptr, ptr+size);
+			shmem_swp_unmap(ptr);
 			if (offset >= 0) {
 				shmem_dir_unmap(dir);
 				goto found;
 			}
-			shmem_swp_unmap(ptr);
 		}
 	}
 lost1:
@@ -893,10 +891,25 @@ lost2:
 	return 0;
 found:
 	idx += offset;
-	inode = &info->vfs_inode;
-	error = add_to_page_cache(page, inode->i_mapping, idx, GFP_ATOMIC);
+	inode = igrab(&info->vfs_inode);
+	spin_unlock(&info->lock);
+
+	/* move head to start search for next from here */
+	list_move_tail(&shmem_swaplist, &info->swaplist);
+	mutex_unlock(&shmem_swaplist_mutex);
+
+	error = 1;
+	if (!inode)
+		goto out;
+
+	spin_lock(&info->lock);
+	ptr = shmem_swp_entry(info, idx, NULL);
+	if (ptr && ptr->val == entry.val)
+		error = add_to_page_cache(page, inode->i_mapping,
+						idx, GFP_ATOMIC);
 	if (error == -EEXIST) {
 		struct page *filepage = find_get_page(inode->i_mapping, idx);
+		error = 1;
 		if (filepage) {
 			/*
 			 * There might be a more uptodate page coming down
@@ -911,16 +924,18 @@ found:
 		delete_from_swap_cache(page);
 		set_page_dirty(page);
 		info->flags |= SHMEM_PAGEIN;
-		shmem_swp_set(info, ptr + offset, 0);
+		shmem_swp_set(info, ptr, 0);
+		swap_free(entry);
+		error = 1;	/* not an error, but entry was found */
 	}
-	shmem_swp_unmap(ptr);
+	if (ptr)
+		shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
-	/*
-	 * Decrement swap count even when the entry is left behind:
-	 * try_to_unuse will skip over mms, then reincrement count.
-	 */
-	swap_free(entry);
-	return 1;
+out:
+	unlock_page(page);
+	page_cache_release(page);
+	iput(inode);		/* allows for NULL */
+	return error;
 }
 
 /*
@@ -935,18 +950,16 @@ int shmem_unuse(swp_entry_t entry, struc
 	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(p, next, &shmem_swaplist) {
 		info = list_entry(p, struct shmem_inode_info, swaplist);
-		if (!info->swapped)
+		if (info->swapped)
+			found = shmem_unuse_inode(info, entry, page);
+		else
 			list_del_init(&info->swaplist);
-		else if (shmem_unuse_inode(info, entry, page)) {
-			/* move head to start search for next from here */
-			list_move_tail(&shmem_swaplist, &info->swaplist);
-			found = 1;
-			break;
-		}
 		cond_resched();
+		if (found)
+			goto out;
 	}
 	mutex_unlock(&shmem_swaplist_mutex);
-	return found;
+out:	return found;	/* 0 or 1 or -ENOMEM */
 }
 
 /*
diff -puN mm/swapfile.c~tmpfs-open-a-window-in-shmem_unuse_inode mm/swapfile.c
--- a/mm/swapfile.c~tmpfs-open-a-window-in-shmem_unuse_inode
+++ a/mm/swapfile.c
@@ -814,7 +814,7 @@ static int try_to_unuse(unsigned int typ
 			atomic_inc(&new_start_mm->mm_users);
 			atomic_inc(&prev_mm->mm_users);
 			spin_lock(&mmlist_lock);
-			while (*swap_map > 1 && !retval &&
+			while (*swap_map > 1 && !retval && !shmem &&
 					(p = p->next) != &start_mm->mmlist) {
 				mm = list_entry(p, struct mm_struct, mmlist);
 				if (!atomic_inc_not_zero(&mm->mm_users))
@@ -846,6 +846,13 @@ static int try_to_unuse(unsigned int typ
 			mmput(start_mm);
 			start_mm = new_start_mm;
 		}
+		if (shmem) {
+			/* page has already been unlocked and released */
+			if (shmem > 0)
+				continue;
+			retval = shmem;
+			break;
+		}
 		if (retval) {
 			unlock_page(page);
 			page_cache_release(page);
@@ -884,12 +891,6 @@ static int try_to_unuse(unsigned int typ
 		 * read from disk into another page.  Splitting into two
 		 * pages would be incorrect if swap supported "shared
 		 * private" pages, but they are handled by tmpfs files.
-		 *
-		 * Note shmem_unuse already deleted a swappage from
-		 * the swap cache, unless the move to filepage failed:
-		 * in which case it left swappage in cache, lowered its
-		 * swap count to pass quickly through the loops above,
-		 * and now we must reincrement count to try again later.
 		 */
 		if ((*swap_map > 1) && PageDirty(page) && PageSwapCache(page)) {
 			struct writeback_control wbc = {
@@ -900,12 +901,8 @@ static int try_to_unuse(unsigned int typ
 			lock_page(page);
 			wait_on_page_writeback(page);
 		}
-		if (PageSwapCache(page)) {
-			if (shmem)
-				swap_duplicate(entry);
-			else
-				delete_from_swap_cache(page);
-		}
+		if (PageSwapCache(page))
+			delete_from_swap_cache(page);
 
 		/*
 		 * So we could skip searching mms once swap count went
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
