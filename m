From: akpm@linux-foundation.org
Subject: + tmpfs-simplify-filepage-swappage.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:39:38 -0700
Message-ID: <201106172339.p5HNdckn008229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757478Ab1FQXjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:39:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com


The patch titled
     tmpfs: simplify filepage/swappage
has been added to the -mm tree.  Its filename is
     tmpfs-simplify-filepage-swappage.patch

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
Subject: tmpfs: simplify filepage/swappage
From: Hugh Dickins <hughd@google.com>

We can now simplify shmem_getpage_gfp(): there is no longer a dilemma of
filepage passed in via shmem_readpage(), then swappage found, which must
then be copied over to it.

Although at first it's tempting to replace the **pagep arg by returning
struct page *, that makes a mess of IS_ERR_OR_NULL(page)s in all the
callers, so leave as is.

Insert BUG_ON(!PageUptodate) when we find and lock page: some of the
complication came from uninitialized pages inserted into filecache prior
to readpage; but now we're in control, and only release pagelock on
filecache once it's uptodate (if an error occurs in reading back from
swap, the page remains in swapcache, never moved to filecache).

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  237 +++++++++++++++++++++++----------------------------
 1 file changed, 108 insertions(+), 129 deletions(-)

diff -puN mm/shmem.c~tmpfs-simplify-filepage-swappage mm/shmem.c
--- a/mm/shmem.c~tmpfs-simplify-filepage-swappage
+++ a/mm/shmem.c
@@ -1246,41 +1246,47 @@ static int shmem_getpage_gfp(struct inod
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo;
-	struct page *filepage;
-	struct page *swappage;
+	struct page *page;
 	struct page *prealloc_page = NULL;
 	swp_entry_t *entry;
 	swp_entry_t swap;
 	int error;
+	int ret;
 
 	if (idx >= SHMEM_MAX_INDEX)
 		return -EFBIG;
 repeat:
-	filepage = find_lock_page(mapping, idx);
-	if (filepage && PageUptodate(filepage))
-		goto done;
-	if (!filepage) {
+	page = find_lock_page(mapping, idx);
+	if (page) {
 		/*
-		 * Try to preload while we can wait, to not make a habit of
-		 * draining atomic reserves; but don't latch on to this cpu.
+		 * Once we can get the page lock, it must be uptodate:
+		 * if there were an error in reading back from swap,
+		 * the page would not be inserted into the filecache.
 		 */
-		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
-		if (error)
-			goto failed;
-		radix_tree_preload_end();
-		if (sgp != SGP_READ && !prealloc_page) {
-			prealloc_page = shmem_alloc_page(gfp, info, idx);
-			if (prealloc_page) {
-				SetPageSwapBacked(prealloc_page);
-				if (mem_cgroup_cache_charge(prealloc_page,
-						current->mm, GFP_KERNEL)) {
-					page_cache_release(prealloc_page);
-					prealloc_page = NULL;
-				}
+		BUG_ON(!PageUptodate(page));
+		goto done;
+	}
+
+	/*
+	 * Try to preload while we can wait, to not make a habit of
+	 * draining atomic reserves; but don't latch on to this cpu.
+	 */
+	error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
+	if (error)
+		goto out;
+	radix_tree_preload_end();
+
+	if (sgp != SGP_READ && !prealloc_page) {
+		prealloc_page = shmem_alloc_page(gfp, info, idx);
+		if (prealloc_page) {
+			SetPageSwapBacked(prealloc_page);
+			if (mem_cgroup_cache_charge(prealloc_page,
+					current->mm, GFP_KERNEL)) {
+				page_cache_release(prealloc_page);
+				prealloc_page = NULL;
 			}
 		}
 	}
-	error = 0;
 
 	spin_lock(&info->lock);
 	shmem_recalc_inode(inode);
@@ -1288,21 +1294,21 @@ repeat:
 	if (IS_ERR(entry)) {
 		spin_unlock(&info->lock);
 		error = PTR_ERR(entry);
-		goto failed;
+		goto out;
 	}
 	swap = *entry;
 
 	if (swap.val) {
 		/* Look it up and read it in.. */
-		swappage = lookup_swap_cache(swap);
-		if (!swappage) {
+		page = lookup_swap_cache(swap);
+		if (!page) {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			/* here we actually do the io */
 			if (fault_type)
 				*fault_type |= VM_FAULT_MAJOR;
-			swappage = shmem_swapin(swap, gfp, info, idx);
-			if (!swappage) {
+			page = shmem_swapin(swap, gfp, info, idx);
+			if (!page) {
 				spin_lock(&info->lock);
 				entry = shmem_swp_alloc(info, idx, sgp, gfp);
 				if (IS_ERR(entry))
@@ -1314,62 +1320,42 @@ repeat:
 				}
 				spin_unlock(&info->lock);
 				if (error)
-					goto failed;
+					goto out;
 				goto repeat;
 			}
-			wait_on_page_locked(swappage);
-			page_cache_release(swappage);
+			wait_on_page_locked(page);
+			page_cache_release(page);
 			goto repeat;
 		}
 
 		/* We have to do this with page locked to prevent races */
-		if (!trylock_page(swappage)) {
+		if (!trylock_page(page)) {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
-			wait_on_page_locked(swappage);
-			page_cache_release(swappage);
+			wait_on_page_locked(page);
+			page_cache_release(page);
 			goto repeat;
 		}
-		if (PageWriteback(swappage)) {
+		if (PageWriteback(page)) {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
-			wait_on_page_writeback(swappage);
-			unlock_page(swappage);
-			page_cache_release(swappage);
+			wait_on_page_writeback(page);
+			unlock_page(page);
+			page_cache_release(page);
 			goto repeat;
 		}
-		if (!PageUptodate(swappage)) {
+		if (!PageUptodate(page)) {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
-			unlock_page(swappage);
-			page_cache_release(swappage);
+			unlock_page(page);
+			page_cache_release(page);
 			error = -EIO;
-			goto failed;
+			goto out;
 		}
 
-		if (filepage) {
-			shmem_swp_set(info, entry, 0);
-			shmem_swp_unmap(entry);
-			delete_from_swap_cache(swappage);
-			spin_unlock(&info->lock);
-			copy_highpage(filepage, swappage);
-			unlock_page(swappage);
-			page_cache_release(swappage);
-			flush_dcache_page(filepage);
-			SetPageUptodate(filepage);
-			set_page_dirty(filepage);
-			swap_free(swap);
-		} else if (!(error = add_to_page_cache_locked(swappage, mapping,
-					idx, GFP_NOWAIT))) {
-			info->flags |= SHMEM_PAGEIN;
-			shmem_swp_set(info, entry, 0);
-			shmem_swp_unmap(entry);
-			delete_from_swap_cache(swappage);
-			spin_unlock(&info->lock);
-			filepage = swappage;
-			set_page_dirty(filepage);
-			swap_free(swap);
-		} else {
+		error = add_to_page_cache_locked(page, mapping,
+						 idx, GFP_NOWAIT);
+		if (error) {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			if (error == -ENOMEM) {
@@ -1378,28 +1364,33 @@ repeat:
 				 * call memcg's OOM if needed.
 				 */
 				error = mem_cgroup_shmem_charge_fallback(
-								swappage,
-								current->mm,
-								gfp);
+						page, current->mm, gfp);
 				if (error) {
-					unlock_page(swappage);
-					page_cache_release(swappage);
-					goto failed;
+					unlock_page(page);
+					page_cache_release(page);
+					goto out;
 				}
 			}
-			unlock_page(swappage);
-			page_cache_release(swappage);
+			unlock_page(page);
+			page_cache_release(page);
 			goto repeat;
 		}
-	} else if (sgp == SGP_READ && !filepage) {
+
+		info->flags |= SHMEM_PAGEIN;
+		shmem_swp_set(info, entry, 0);
 		shmem_swp_unmap(entry);
-		filepage = find_get_page(mapping, idx);
-		if (filepage &&
-		    (!PageUptodate(filepage) || !trylock_page(filepage))) {
+		delete_from_swap_cache(page);
+		spin_unlock(&info->lock);
+		set_page_dirty(page);
+		swap_free(swap);
+
+	} else if (sgp == SGP_READ) {
+		shmem_swp_unmap(entry);
+		page = find_get_page(mapping, idx);
+		if (page && !trylock_page(page)) {
 			spin_unlock(&info->lock);
-			wait_on_page_locked(filepage);
-			page_cache_release(filepage);
-			filepage = NULL;
+			wait_on_page_locked(page);
+			page_cache_release(page);
 			goto repeat;
 		}
 		spin_unlock(&info->lock);
@@ -1417,56 +1408,52 @@ repeat:
 		} else if (shmem_acct_block(info->flags))
 			goto nospace;
 
-		if (!filepage) {
-			int ret;
+		page = prealloc_page;
+		prealloc_page = NULL;
 
-			filepage = prealloc_page;
-			prealloc_page = NULL;
-
-			entry = shmem_swp_alloc(info, idx, sgp, gfp);
-			if (IS_ERR(entry))
-				error = PTR_ERR(entry);
-			else {
-				swap = *entry;
-				shmem_swp_unmap(entry);
-			}
-			ret = error || swap.val;
-			if (ret)
-				mem_cgroup_uncharge_cache_page(filepage);
-			else
-				ret = add_to_page_cache_lru(filepage, mapping,
+		entry = shmem_swp_alloc(info, idx, sgp, gfp);
+		if (IS_ERR(entry))
+			error = PTR_ERR(entry);
+		else {
+			swap = *entry;
+			shmem_swp_unmap(entry);
+		}
+		ret = error || swap.val;
+		if (ret)
+			mem_cgroup_uncharge_cache_page(page);
+		else
+			ret = add_to_page_cache_lru(page, mapping,
 						idx, GFP_NOWAIT);
-			/*
-			 * At add_to_page_cache_lru() failure, uncharge will
-			 * be done automatically.
-			 */
-			if (ret) {
-				shmem_unacct_blocks(info->flags, 1);
-				shmem_free_blocks(inode, 1);
-				spin_unlock(&info->lock);
-				page_cache_release(filepage);
-				filepage = NULL;
-				if (error)
-					goto failed;
-				goto repeat;
-			}
-			info->flags |= SHMEM_PAGEIN;
+		/*
+		 * At add_to_page_cache_lru() failure,
+		 * uncharge will be done automatically.
+		 */
+		if (ret) {
+			shmem_unacct_blocks(info->flags, 1);
+			shmem_free_blocks(inode, 1);
+			spin_unlock(&info->lock);
+			page_cache_release(page);
+			if (error)
+				goto out;
+			goto repeat;
 		}
 
+		info->flags |= SHMEM_PAGEIN;
 		info->alloced++;
 		spin_unlock(&info->lock);
-		clear_highpage(filepage);
-		flush_dcache_page(filepage);
-		SetPageUptodate(filepage);
+		clear_highpage(page);
+		flush_dcache_page(page);
+		SetPageUptodate(page);
 		if (sgp == SGP_DIRTY)
-			set_page_dirty(filepage);
+			set_page_dirty(page);
+
 	} else {
 		spin_unlock(&info->lock);
 		error = -ENOMEM;
 		goto out;
 	}
 done:
-	*pagep = filepage;
+	*pagep = page;
 	error = 0;
 out:
 	if (prealloc_page) {
@@ -1482,21 +1469,13 @@ nospace:
 	 * but must also avoid reporting a spurious ENOSPC while working on a
 	 * full tmpfs.
 	 */
-	if (!filepage) {
-		struct page *page = find_get_page(mapping, idx);
-		if (page) {
-			spin_unlock(&info->lock);
-			page_cache_release(page);
-			goto repeat;
-		}
-	}
+	page = find_get_page(mapping, idx);
 	spin_unlock(&info->lock);
-	error = -ENOSPC;
-failed:
-	if (filepage) {
-		unlock_page(filepage);
-		page_cache_release(filepage);
+	if (page) {
+		page_cache_release(page);
+		goto repeat;
 	}
+	error = -ENOSPC;
 	goto out;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
drm-i915-more-struct_mutex-locking-fix.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
linux-next.patch
tmpfs-clone-shmem_file_splice_read.patch
tmpfs-refine-shmem_file_splice_read.patch
tmpfs-pass-gfp-to-shmem_getpage_gfp.patch
tmpfs-remove_shmem_readpage.patch
tmpfs-simplify-prealloc_page.patch
tmpfs-simplify-filepage-swappage.patch
tmpfs-simplify-unuse-and-writepage.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
prio_tree-debugging-patch.patch

