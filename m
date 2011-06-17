From: akpm@linux-foundation.org
Subject: + tmpfs-convert-shmem_writepage-and-enable-swap.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:40:05 -0700
Message-ID: <201106172340.p5HNe5Te008323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759588Ab1FQXkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:40:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, riel@redhat.com


The patch titled
     tmpfs: convert shmem_writepage and enable swap
has been added to the -mm tree.  Its filename is
     tmpfs-convert-shmem_writepage-and-enable-swap.patch

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
Subject: tmpfs: convert shmem_writepage and enable swap
From: Hugh Dickins <hughd@google.com>

Convert shmem_writepage() to use shmem_delete_from_page_cache() to use
shmem_radix_tree_replace() to substitute swap entry for page pointer
atomically in the radix tree.

As with shmem_add_to_page_cache(), it's not entirely satisfactory to be
copying such code from delete_from_swap_cache, but again judged easier to
sell than making its other callers go through the extras.

Remove the toy implementation's shmem_put_swap() and shmem_get_swap(), now
unreferenced, and the hack to disable swap: it's now good to go.

The way things have worked out, info->lock no longer helps to guard the
shmem_swaplist: we increment swapped under shmem_swaplist_mutex only. 
That global mutex exclusion between shmem_writepage() and shmem_unuse() is
not pretty, and we ought to find another way; but it's been forced on us
by recent race discoveries, not a consequence of this patchset.

And what has become of the WARN_ON_ONCE(1) free_swap_and_cache() if a swap
entry was found already present?  That's no longer possible, the (unknown)
one inserting this page into filecache would hit the swap entry occupying
that slot.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   88 +++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 51 deletions(-)

diff -puN mm/shmem.c~tmpfs-convert-shmem_writepage-and-enable-swap mm/shmem.c
--- a/mm/shmem.c~tmpfs-convert-shmem_writepage-and-enable-swap
+++ a/mm/shmem.c
@@ -6,7 +6,8 @@
  *		 2000-2001 Christoph Rohland
  *		 2000-2001 SAP AG
  *		 2002 Red Hat Inc.
- * Copyright (C) 2002-2005 Hugh Dickins.
+ * Copyright (C) 2002-2011 Hugh Dickins.
+ * Copyright (C) 2011 Google Inc.
  * Copyright (C) 2002-2005 VERITAS Software Corporation.
  * Copyright (C) 2004 Andi Kleen, SuSE Labs
  *
@@ -219,19 +220,6 @@ static void shmem_recalc_inode(struct in
 	}
 }
 
-static void shmem_put_swap(struct shmem_inode_info *info, pgoff_t index,
-			   swp_entry_t swap)
-{
-	if (index < SHMEM_NR_DIRECT)
-		info->i_direct[index] = swap;
-}
-
-static swp_entry_t shmem_get_swap(struct shmem_inode_info *info, pgoff_t index)
-{
-	return (index < SHMEM_NR_DIRECT) ?
-		info->i_direct[index] : (swp_entry_t){0};
-}
-
 /*
  * Replace item expected in radix tree by a new item, while holding tree lock.
  */
@@ -300,6 +288,25 @@ static int shmem_add_to_page_cache(struc
 }
 
 /*
+ * Like delete_from_page_cache, but substitutes swap for page.
+ */
+static void shmem_delete_from_page_cache(struct page *page, void *radswap)
+{
+	struct address_space *mapping = page->mapping;
+	int error;
+
+	spin_lock_irq(&mapping->tree_lock);
+	error = shmem_radix_tree_replace(mapping, page->index, page, radswap);
+	page->mapping = NULL;
+	mapping->nrpages--;
+	__dec_zone_page_state(page, NR_FILE_PAGES);
+	__dec_zone_page_state(page, NR_SHMEM);
+	spin_unlock_irq(&mapping->tree_lock);
+	page_cache_release(page);
+	BUG_ON(error);
+}
+
+/*
  * Like find_get_pages, but collecting swap entries as well as pages.
  */
 static unsigned shmem_find_get_pages_and_swap(struct address_space *mapping,
@@ -664,14 +671,10 @@ int shmem_unuse(swp_entry_t swap, struct
 	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(this, next, &shmem_swaplist) {
 		info = list_entry(this, struct shmem_inode_info, swaplist);
-		if (!info->swapped) {
-			spin_lock(&info->lock);
-			if (!info->swapped)
-				list_del_init(&info->swaplist);
-			spin_unlock(&info->lock);
-		}
 		if (info->swapped)
 			found = shmem_unuse_inode(info, swap, page);
+		else
+			list_del_init(&info->swaplist);
 		cond_resched();
 		if (found)
 			break;
@@ -694,10 +697,10 @@ out:
 static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct shmem_inode_info *info;
-	swp_entry_t swap, oswap;
 	struct address_space *mapping;
-	pgoff_t index;
 	struct inode *inode;
+	swp_entry_t swap;
+	pgoff_t index;
 
 	BUG_ON(!PageLocked(page));
 	mapping = page->mapping;
@@ -720,55 +723,38 @@ static int shmem_writepage(struct page *
 		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
 		goto redirty;
 	}
-
-	/*
-	 * Disable even the toy swapping implementation, while we convert
-	 * functions one by one to having swap entries in the radix tree.
-	 */
-	if (index < ULONG_MAX)
-		goto redirty;
-
 	swap = get_swap_page();
 	if (!swap.val)
 		goto redirty;
 
 	/*
 	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
-	 * if it's not already there.  Do it now because we cannot take
-	 * mutex while holding spinlock, and must do so before the page
-	 * is moved to swap cache, when its pagelock no longer protects
+	 * if it's not already there.  Do it now before the page is
+	 * moved to swap cache, when its pagelock no longer protects
 	 * the inode from eviction.  But don't unlock the mutex until
-	 * we've taken the spinlock, because shmem_unuse_inode() will
-	 * prune a !swapped inode from the swaplist under both locks.
+	 * we've incremented swapped, because shmem_unuse_inode() will
+	 * prune a !swapped inode from the swaplist under this mutex.
 	 */
 	mutex_lock(&shmem_swaplist_mutex);
 	if (list_empty(&info->swaplist))
 		list_add_tail(&info->swaplist, &shmem_swaplist);
 
-	spin_lock(&info->lock);
-	mutex_unlock(&shmem_swaplist_mutex);
-
-	oswap = shmem_get_swap(info, index);
-	if (oswap.val) {
-		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
-		free_swap_and_cache(oswap);
-		shmem_put_swap(info, index, (swp_entry_t){0});
-		info->swapped--;
-	}
-	shmem_recalc_inode(inode);
-
 	if (add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
-		delete_from_page_cache(page);
-		shmem_put_swap(info, index, swap);
-		info->swapped++;
 		swap_shmem_alloc(swap);
+		shmem_delete_from_page_cache(page, swp_to_radix_entry(swap));
+
+		spin_lock(&info->lock);
+		info->swapped++;
+		shmem_recalc_inode(inode);
 		spin_unlock(&info->lock);
+
+		mutex_unlock(&shmem_swaplist_mutex);
 		BUG_ON(page_mapped(page));
 		swap_writepage(page, wbc);
 		return 0;
 	}
 
-	spin_unlock(&info->lock);
+	mutex_unlock(&shmem_swaplist_mutex);
 	swapcache_free(swap, NULL);
 redirty:
 	set_page_dirty(page);
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

