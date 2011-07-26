From: akpm@linux-foundation.org
Subject: [merged] tmpfs-simplify-unuse-and-writepage.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:53 -0700
Message-ID: <201107260752.p6Q7quFG003181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115Ab1GZHx0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, ezk@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     tmpfs: simplify unuse and writepage
has been removed from the -mm tree.  Its filename was
     tmpfs-simplify-unuse-and-writepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
slub-partly-fix-freeze-in-__slab_free.patch
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
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
panic-panic=-1-for-immediate-reboot.patch
panic-vt-do-not-force-oops-output-when-panic_timeout-0.patch
prio_tree-debugging-patch.patch

