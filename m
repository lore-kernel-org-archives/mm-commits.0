From: akpm@linux-foundation.org
Subject: [merged] mm-tidy-vmtruncate_range-and-related-functions.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:21 -0700
Message-ID: <201107260752.p6Q7qO7m003124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752900Ab1GZHwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: tidy vmtruncate_range and related functions
has been removed from the -mm tree.  Its filename was
     mm-tidy-vmtruncate_range-and-related-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: tidy vmtruncate_range and related functions
From: Hugh Dickins <hughd@google.com>

Use consistent variable names in truncate_pagecache(), truncate_setsize(),
vmtruncate() and vmtruncate_range().

unmap_mapping_range() and vmtruncate_range() have mismatched interfaces:
don't change either, but make the vmtruncates more precise about what they
expect unmap_mapping_range() to do.

vmtruncate_range() is currently called only with page-aligned start and
end+1: can handle unaligned start, but unaligned end+1 would hit BUG_ON in
truncate_inode_pages_range() (lacks partial clearing of the end page).

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff -puN mm/truncate.c~mm-tidy-vmtruncate_range-and-related-functions mm/truncate.c
--- a/mm/truncate.c~mm-tidy-vmtruncate_range-and-related-functions
+++ a/mm/truncate.c
@@ -531,8 +531,8 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
 /**
  * truncate_pagecache - unmap and remove pagecache that has been truncated
  * @inode: inode
- * @old: old file offset
- * @new: new file offset
+ * @oldsize: old file size
+ * @newsize: new file size
  *
  * inode's new i_size must already be written before truncate_pagecache
  * is called.
@@ -544,9 +544,10 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
  * situations such as writepage being called for a page that has already
  * had its underlying blocks deallocated.
  */
-void truncate_pagecache(struct inode *inode, loff_t old, loff_t new)
+void truncate_pagecache(struct inode *inode, loff_t oldsize, loff_t newsize)
 {
 	struct address_space *mapping = inode->i_mapping;
+	loff_t holebegin = round_up(newsize, PAGE_SIZE);
 
 	/*
 	 * unmap_mapping_range is called twice, first simply for
@@ -557,9 +558,9 @@ void truncate_pagecache(struct inode *in
 	 * truncate_inode_pages finishes, hence the second
 	 * unmap_mapping_range call must be made for correctness.
 	 */
-	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
-	truncate_inode_pages(mapping, new);
-	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
+	unmap_mapping_range(mapping, holebegin, 0, 1);
+	truncate_inode_pages(mapping, newsize);
+	unmap_mapping_range(mapping, holebegin, 0, 1);
 }
 EXPORT_SYMBOL(truncate_pagecache);
 
@@ -589,29 +590,31 @@ EXPORT_SYMBOL(truncate_setsize);
 /**
  * vmtruncate - unmap mappings "freed" by truncate() syscall
  * @inode: inode of the file used
- * @offset: file offset to start truncating
+ * @newsize: file offset to start truncating
  *
  * This function is deprecated and truncate_setsize or truncate_pagecache
  * should be used instead, together with filesystem specific block truncation.
  */
-int vmtruncate(struct inode *inode, loff_t offset)
+int vmtruncate(struct inode *inode, loff_t newsize)
 {
 	int error;
 
-	error = inode_newsize_ok(inode, offset);
+	error = inode_newsize_ok(inode, newsize);
 	if (error)
 		return error;
 
-	truncate_setsize(inode, offset);
+	truncate_setsize(inode, newsize);
 	if (inode->i_op->truncate)
 		inode->i_op->truncate(inode);
 	return 0;
 }
 EXPORT_SYMBOL(vmtruncate);
 
-int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end)
+int vmtruncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 {
 	struct address_space *mapping = inode->i_mapping;
+	loff_t holebegin = round_up(lstart, PAGE_SIZE);
+	loff_t holelen = 1 + lend - holebegin;
 
 	/*
 	 * If the underlying filesystem is not going to provide
@@ -623,10 +626,10 @@ int vmtruncate_range(struct inode *inode
 
 	mutex_lock(&inode->i_mutex);
 	inode_dio_wait(inode);
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
-	inode->i_op->truncate_range(inode, offset, end);
+	unmap_mapping_range(mapping, holebegin, holelen, 1);
+	inode->i_op->truncate_range(inode, lstart, lend);
 	/* unmap again to remove racily COWed private pages */
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
+	unmap_mapping_range(mapping, holebegin, holelen, 1);
 	mutex_unlock(&inode->i_mutex);
 
 	return 0;
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

