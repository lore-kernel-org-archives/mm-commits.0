From: akpm@linux-foundation.org
Subject: + tmpfs-simplify-unuse-and-writepage.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:39:40 -0700
Message-ID: <201106172339.p5HNdeWl008232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757478Ab1FQXjo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:39:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, ezk@fsl.cs.sunysb.edu


The patch titled
     tmpfs: simplify unuse and writepage
has been added to the -mm tree.  Its filename is
     tmpfs-simplify-unuse-and-writepage.patch

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
Subject: tmpfs: simplify unuse and writepage
From: Hugh Dickins <hughd@google.com>

shmem_unuse_inode() and shmem_writepage() contain a little code to cope
with pages inserted independently into the filecache, probably by a
filesystem stacked on top of tmpfs, then fed to its ->readpage() or
->writepage().

Unionfs was indeed experimenting with working in that way three years ago,
but I find no current examples: nowadays the stacking filesystems use vfs
interfaces to the lower filesystem.

It's now illegal: remove most of that code, adding some WARN_ON_ONCEs.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   50 ++++++++++++++++----------------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

diff -puN mm/shmem.c~tmpfs-simplify-unuse-and-writepage mm/shmem.c
--- a/mm/shmem.c~tmpfs-simplify-unuse-and-writepage
+++ a/mm/shmem.c
@@ -972,20 +972,7 @@ found:
 	error = add_to_page_cache_locked(page, mapping, idx, GFP_NOWAIT);
 	/* which does mem_cgroup_uncharge_cache_page on error */
 
-	if (error == -EEXIST) {
-		struct page *filepage = find_get_page(mapping, idx);
-		error = 1;
-		if (filepage) {
-			/*
-			 * There might be a more uptodate page coming down
-			 * from a stacked writepage: forget our swappage if so.
-			 */
-			if (PageUptodate(filepage))
-				error = 0;
-			page_cache_release(filepage);
-		}
-	}
-	if (!error) {
+	if (error != -ENOMEM) {
 		delete_from_swap_cache(page);
 		set_page_dirty(page);
 		info->flags |= SHMEM_PAGEIN;
@@ -1072,16 +1059,17 @@ static int shmem_writepage(struct page *
 	/*
 	 * shmem_backing_dev_info's capabilities prevent regular writeback or
 	 * sync from ever calling shmem_writepage; but a stacking filesystem
-	 * may use the ->writepage of its underlying filesystem, in which case
+	 * might use ->writepage of its underlying filesystem, in which case
 	 * tmpfs should write out to swap only in response to memory pressure,
-	 * and not for the writeback threads or sync.  However, in those cases,
-	 * we do still want to check if there's a redundant swappage to be
-	 * discarded.
+	 * and not for the writeback threads or sync.
 	 */
-	if (wbc->for_reclaim)
-		swap = get_swap_page();
-	else
-		swap.val = 0;
+	if (!wbc->for_reclaim) {
+		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
+		goto redirty;
+	}
+	swap = get_swap_page();
+	if (!swap.val)
+		goto redirty;
 
 	/*
 	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
@@ -1092,15 +1080,12 @@ static int shmem_writepage(struct page *
 	 * we've taken the spinlock, because shmem_unuse_inode() will
 	 * prune a !swapped inode from the swaplist under both locks.
 	 */
-	if (swap.val) {
-		mutex_lock(&shmem_swaplist_mutex);
-		if (list_empty(&info->swaplist))
-			list_add_tail(&info->swaplist, &shmem_swaplist);
-	}
+	mutex_lock(&shmem_swaplist_mutex);
+	if (list_empty(&info->swaplist))
+		list_add_tail(&info->swaplist, &shmem_swaplist);
 
 	spin_lock(&info->lock);
-	if (swap.val)
-		mutex_unlock(&shmem_swaplist_mutex);
+	mutex_unlock(&shmem_swaplist_mutex);
 
 	if (index >= info->next_index) {
 		BUG_ON(!(info->flags & SHMEM_TRUNCATE));
@@ -1108,16 +1093,13 @@ static int shmem_writepage(struct page *
 	}
 	entry = shmem_swp_entry(info, index, NULL);
 	if (entry->val) {
-		/*
-		 * The more uptodate page coming down from a stacked
-		 * writepage should replace our old swappage.
-		 */
+		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
 		free_swap_and_cache(*entry);
 		shmem_swp_set(info, entry, 0);
 	}
 	shmem_recalc_inode(inode);
 
-	if (swap.val && add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
+	if (add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
 		delete_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
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

