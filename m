From: akpm@linux-foundation.org
Subject: [merged] tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:16 -0700
Message-ID: <201108161848.p7GImN2x015292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730Ab1HPSyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: convert shmem_getpage_gfp to radix-swap
has been removed from the -mm tree.  Its filename was
     tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: convert shmem_getpage_gfp to radix-swap
From: Hugh Dickins <hughd@google.com>

Convert shmem_getpage_gfp(), the engine-room of shmem, to expect page or
swap entry returned from radix tree by find_lock_page().

Whereas the repetitive old method proceeded mainly under info->lock,
dropping and repeating whenever one of the conditions needed was not met,
now we can proceed without it, leaving shmem_add_to_page_cache() to check
for a race.

This way there is no need to preallocate a page, no need for an early
radix_tree_preload(), no need for mem_cgroup_shmem_charge_fallback().

Move the error unwinding down to the bottom instead of repeating it
throughout.  ENOSPC handling is a little different from before: there is
no longer any race between find_lock_page() and finding swap, but we can
arrive at ENOSPC before calling shmem_recalc_inode(), which might
occasionally discover freed space.

Be stricter to check i_size before returning.  info->lock is used for
little but alloced, swapped, i_blocks updates.  Move i_blocks updates out
from under the max_blocks check, so even an unlimited size=0 mount can
show accurate du.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  259 ++++++++++++++++++++++-----------------------------
 1 file changed, 112 insertions(+), 147 deletions(-)

diff -puN mm/shmem.c~tmpfs-convert-shmem_getpage_gfp-to-radix-swap mm/shmem.c
--- a/mm/shmem.c~tmpfs-convert-shmem_getpage_gfp-to-radix-swap
+++ a/mm/shmem.c
@@ -166,15 +166,6 @@ static struct backing_dev_info shmem_bac
 static LIST_HEAD(shmem_swaplist);
 static DEFINE_MUTEX(shmem_swaplist_mutex);
 
-static void shmem_free_blocks(struct inode *inode, long pages)
-{
-	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-	if (sbinfo->max_blocks) {
-		percpu_counter_add(&sbinfo->used_blocks, -pages);
-		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
-	}
-}
-
 static int shmem_reserve_inode(struct super_block *sb)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
@@ -219,9 +210,12 @@ static void shmem_recalc_inode(struct in
 
 	freed = info->alloced - info->swapped - inode->i_mapping->nrpages;
 	if (freed > 0) {
+		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+		if (sbinfo->max_blocks)
+			percpu_counter_add(&sbinfo->used_blocks, -freed);
 		info->alloced -= freed;
+		inode->i_blocks -= freed * BLOCKS_PER_PAGE;
 		shmem_unacct_blocks(info->flags, freed);
-		shmem_free_blocks(inode, freed);
 	}
 }
 
@@ -888,205 +882,180 @@ static int shmem_getpage_gfp(struct inod
 	struct page **pagep, enum sgp_type sgp, gfp_t gfp, int *fault_type)
 {
 	struct address_space *mapping = inode->i_mapping;
-	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_inode_info *info;
 	struct shmem_sb_info *sbinfo;
 	struct page *page;
-	struct page *prealloc_page = NULL;
 	swp_entry_t swap;
 	int error;
+	int once = 0;
 
 	if (index > (MAX_LFS_FILESIZE >> PAGE_CACHE_SHIFT))
 		return -EFBIG;
 repeat:
+	swap.val = 0;
 	page = find_lock_page(mapping, index);
-	if (page) {
+	if (radix_tree_exceptional_entry(page)) {
+		swap = radix_to_swp_entry(page);
+		page = NULL;
+	}
+
+	if (sgp != SGP_WRITE &&
+	    ((loff_t)index << PAGE_CACHE_SHIFT) >= i_size_read(inode)) {
+		error = -EINVAL;
+		goto failed;
+	}
+
+	if (page || (sgp == SGP_READ && !swap.val)) {
 		/*
 		 * Once we can get the page lock, it must be uptodate:
 		 * if there were an error in reading back from swap,
 		 * the page would not be inserted into the filecache.
 		 */
-		BUG_ON(!PageUptodate(page));
-		goto done;
+		BUG_ON(page && !PageUptodate(page));
+		*pagep = page;
+		return 0;
 	}
 
 	/*
-	 * Try to preload while we can wait, to not make a habit of
-	 * draining atomic reserves; but don't latch on to this cpu.
+	 * Fast cache lookup did not find it:
+	 * bring it back from swap or allocate.
 	 */
-	error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
-	if (error)
-		goto out;
-	radix_tree_preload_end();
-
-	if (sgp != SGP_READ && !prealloc_page) {
-		prealloc_page = shmem_alloc_page(gfp, info, index);
-		if (prealloc_page) {
-			SetPageSwapBacked(prealloc_page);
-			if (mem_cgroup_cache_charge(prealloc_page,
-					current->mm, GFP_KERNEL)) {
-				page_cache_release(prealloc_page);
-				prealloc_page = NULL;
-			}
-		}
-	}
+	info = SHMEM_I(inode);
+	sbinfo = SHMEM_SB(inode->i_sb);
 
-	spin_lock(&info->lock);
-	shmem_recalc_inode(inode);
-	swap = shmem_get_swap(info, index);
 	if (swap.val) {
 		/* Look it up and read it in.. */
 		page = lookup_swap_cache(swap);
 		if (!page) {
-			spin_unlock(&info->lock);
 			/* here we actually do the io */
 			if (fault_type)
 				*fault_type |= VM_FAULT_MAJOR;
 			page = shmem_swapin(swap, gfp, info, index);
 			if (!page) {
-				swp_entry_t nswap = shmem_get_swap(info, index);
-				if (nswap.val == swap.val) {
-					error = -ENOMEM;
-					goto out;
-				}
-				goto repeat;
+				error = -ENOMEM;
+				goto failed;
 			}
-			wait_on_page_locked(page);
-			page_cache_release(page);
-			goto repeat;
 		}
 
 		/* We have to do this with page locked to prevent races */
-		if (!trylock_page(page)) {
-			spin_unlock(&info->lock);
-			wait_on_page_locked(page);
-			page_cache_release(page);
-			goto repeat;
-		}
-		if (PageWriteback(page)) {
-			spin_unlock(&info->lock);
-			wait_on_page_writeback(page);
-			unlock_page(page);
-			page_cache_release(page);
-			goto repeat;
-		}
+		lock_page(page);
 		if (!PageUptodate(page)) {
-			spin_unlock(&info->lock);
-			unlock_page(page);
-			page_cache_release(page);
 			error = -EIO;
-			goto out;
+			goto failed;
 		}
+		wait_on_page_writeback(page);
 
-		error = add_to_page_cache_locked(page, mapping,
-						 index, GFP_NOWAIT);
-		if (error) {
-			spin_unlock(&info->lock);
-			if (error == -ENOMEM) {
-				/*
-				 * reclaim from proper memory cgroup and
-				 * call memcg's OOM if needed.
-				 */
-				error = mem_cgroup_shmem_charge_fallback(
-						page, current->mm, gfp);
-				if (error) {
-					unlock_page(page);
-					page_cache_release(page);
-					goto out;
-				}
-			}
-			unlock_page(page);
-			page_cache_release(page);
-			goto repeat;
+		/* Someone may have already done it for us */
+		if (page->mapping) {
+			if (page->mapping == mapping &&
+			    page->index == index)
+				goto done;
+			error = -EEXIST;
+			goto failed;
 		}
 
-		delete_from_swap_cache(page);
-		shmem_put_swap(info, index, (swp_entry_t){0});
+		error = shmem_add_to_page_cache(page, mapping, index,
+					gfp, swp_to_radix_entry(swap));
+		if (error)
+			goto failed;
+
+		spin_lock(&info->lock);
 		info->swapped--;
+		shmem_recalc_inode(inode);
 		spin_unlock(&info->lock);
+
+		delete_from_swap_cache(page);
 		set_page_dirty(page);
 		swap_free(swap);
 
-	} else if (sgp == SGP_READ) {
-		page = find_get_page(mapping, index);
-		if (page && !trylock_page(page)) {
-			spin_unlock(&info->lock);
-			wait_on_page_locked(page);
-			page_cache_release(page);
-			goto repeat;
+	} else {
+		if (shmem_acct_block(info->flags)) {
+			error = -ENOSPC;
+			goto failed;
 		}
-		spin_unlock(&info->lock);
-
-	} else if (prealloc_page) {
-		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
 			if (percpu_counter_compare(&sbinfo->used_blocks,
-						sbinfo->max_blocks) >= 0 ||
-			    shmem_acct_block(info->flags))
-				goto nospace;
+						sbinfo->max_blocks) >= 0) {
+				error = -ENOSPC;
+				goto unacct;
+			}
 			percpu_counter_inc(&sbinfo->used_blocks);
-			inode->i_blocks += BLOCKS_PER_PAGE;
-		} else if (shmem_acct_block(info->flags))
-			goto nospace;
-
-		page = prealloc_page;
-		prealloc_page = NULL;
-
-		swap = shmem_get_swap(info, index);
-		if (swap.val)
-			mem_cgroup_uncharge_cache_page(page);
-		else
-			error = add_to_page_cache_lru(page, mapping,
-						index, GFP_NOWAIT);
-		/*
-		 * At add_to_page_cache_lru() failure,
-		 * uncharge will be done automatically.
-		 */
-		if (swap.val || error) {
-			shmem_unacct_blocks(info->flags, 1);
-			shmem_free_blocks(inode, 1);
-			spin_unlock(&info->lock);
-			page_cache_release(page);
-			goto repeat;
 		}
 
+		page = shmem_alloc_page(gfp, info, index);
+		if (!page) {
+			error = -ENOMEM;
+			goto decused;
+		}
+
+		SetPageSwapBacked(page);
+		__set_page_locked(page);
+		error = shmem_add_to_page_cache(page, mapping, index,
+								gfp, NULL);
+		if (error)
+			goto decused;
+		lru_cache_add_anon(page);
+
+		spin_lock(&info->lock);
 		info->alloced++;
+		inode->i_blocks += BLOCKS_PER_PAGE;
+		shmem_recalc_inode(inode);
 		spin_unlock(&info->lock);
+
 		clear_highpage(page);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 		if (sgp == SGP_DIRTY)
 			set_page_dirty(page);
-
-	} else {
-		spin_unlock(&info->lock);
-		error = -ENOMEM;
-		goto out;
 	}
 done:
-	*pagep = page;
-	error = 0;
-out:
-	if (prealloc_page) {
-		mem_cgroup_uncharge_cache_page(prealloc_page);
-		page_cache_release(prealloc_page);
+	/* Perhaps the file has been truncated since we checked */
+	if (sgp != SGP_WRITE &&
+	    ((loff_t)index << PAGE_CACHE_SHIFT) >= i_size_read(inode)) {
+		error = -EINVAL;
+		goto trunc;
 	}
-	return error;
+	*pagep = page;
+	return 0;
 
-nospace:
 	/*
-	 * Perhaps the page was brought in from swap between find_lock_page
-	 * and taking info->lock?  We allow for that at add_to_page_cache_lru,
-	 * but must also avoid reporting a spurious ENOSPC while working on a
-	 * full tmpfs.
+	 * Error recovery.
 	 */
-	page = find_get_page(mapping, index);
+trunc:
+	ClearPageDirty(page);
+	delete_from_page_cache(page);
+	spin_lock(&info->lock);
+	info->alloced--;
+	inode->i_blocks -= BLOCKS_PER_PAGE;
 	spin_unlock(&info->lock);
+decused:
+	if (sbinfo->max_blocks)
+		percpu_counter_add(&sbinfo->used_blocks, -1);
+unacct:
+	shmem_unacct_blocks(info->flags, 1);
+failed:
+	if (swap.val && error != -EINVAL) {
+		struct page *test = find_get_page(mapping, index);
+		if (test && !radix_tree_exceptional_entry(test))
+			page_cache_release(test);
+		/* Have another try if the entry has changed */
+		if (test != swp_to_radix_entry(swap))
+			error = -EEXIST;
+	}
 	if (page) {
+		unlock_page(page);
 		page_cache_release(page);
+	}
+	if (error == -ENOSPC && !once++) {
+		info = SHMEM_I(inode);
+		spin_lock(&info->lock);
+		shmem_recalc_inode(inode);
+		spin_unlock(&info->lock);
 		goto repeat;
 	}
-	error = -ENOSPC;
-	goto out;
+	if (error == -EEXIST)
+		goto repeat;
+	return error;
 }
 
 static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
@@ -1095,9 +1064,6 @@ static int shmem_fault(struct vm_area_st
 	int error;
 	int ret = VM_FAULT_LOCKED;
 
-	if (((loff_t)vmf->pgoff << PAGE_CACHE_SHIFT) >= i_size_read(inode))
-		return VM_FAULT_SIGBUS;
