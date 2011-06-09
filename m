From: akpm@linux-foundation.org
Subject: + mm-tidy-vmtruncate_range-and-related-functions.patch added to -mm tree
Date: Thu, 09 Jun 2011 15:42:40 -0700
Message-ID: <201106092242.p59Mge2T005061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756904Ab1FIWnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 18:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com


The patch titled
     mm: tidy vmtruncate_range and related functions
has been added to the -mm tree.  Its filename is
     mm-tidy-vmtruncate_range-and-related-functions.patch

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
@@ -526,8 +526,8 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
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
@@ -539,9 +539,10 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
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
@@ -552,9 +553,9 @@ void truncate_pagecache(struct inode *in
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
 
@@ -584,29 +585,31 @@ EXPORT_SYMBOL(truncate_setsize);
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
@@ -618,10 +621,10 @@ int vmtruncate_range(struct inode *inode
 
 	mutex_lock(&inode->i_mutex);
 	down_write(&inode->i_alloc_sem);
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
-	inode->i_op->truncate_range(inode, offset, end);
+	unmap_mapping_range(mapping, holebegin, holelen, 1);
+	inode->i_op->truncate_range(inode, lstart, lend);
 	/* unmap again to remove racily COWed private pages */
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
+	unmap_mapping_range(mapping, holebegin, holelen, 1);
 	up_write(&inode->i_alloc_sem);
 	mutex_unlock(&inode->i_mutex);
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-wrong-kunmap_atomic-pointer.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
linux-next.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
prio_tree-debugging-patch.patch

