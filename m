From: akpm@linux-foundation.org
Subject: + mm-move-vmtruncate_range-to-truncatec.patch added to -mm tree
Date: Thu, 09 Jun 2011 15:42:19 -0700
Message-ID: <201106092242.p59MgJ6G005017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756904Ab1FIWnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 18:43:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hch@infradead.org


The patch titled
     mm: move vmtruncate_range to truncate.c
has been added to the -mm tree.  Its filename is
     mm-move-vmtruncate_range-to-truncatec.patch

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
Subject: mm: move vmtruncate_range to truncate.c
From: Hugh Dickins <hughd@google.com>

You would expect to find vmtruncate_range() next to vmtruncate() in
mm/truncate.c: move it there.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |   24 ------------------------
 mm/truncate.c |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

diff -puN mm/memory.c~mm-move-vmtruncate_range-to-truncatec mm/memory.c
--- a/mm/memory.c~mm-move-vmtruncate_range-to-truncatec
+++ a/mm/memory.c
@@ -2798,30 +2798,6 @@ void unmap_mapping_range(struct address_
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end)
-{
-	struct address_space *mapping = inode->i_mapping;
-
-	/*
-	 * If the underlying filesystem is not going to provide
-	 * a way to truncate a range of blocks (punch a hole) -
-	 * we should return failure right now.
-	 */
-	if (!inode->i_op->truncate_range)
-		return -ENOSYS;
-
-	mutex_lock(&inode->i_mutex);
-	down_write(&inode->i_alloc_sem);
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
-	truncate_inode_pages_range(mapping, offset, end);
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
-	inode->i_op->truncate_range(inode, offset, end);
-	up_write(&inode->i_alloc_sem);
-	mutex_unlock(&inode->i_mutex);
-
-	return 0;
-}
-
 /*
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
diff -puN mm/truncate.c~mm-move-vmtruncate_range-to-truncatec mm/truncate.c
--- a/mm/truncate.c~mm-move-vmtruncate_range-to-truncatec
+++ a/mm/truncate.c
@@ -603,3 +603,27 @@ int vmtruncate(struct inode *inode, loff
 	return 0;
 }
 EXPORT_SYMBOL(vmtruncate);
+
+int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end)
+{
+	struct address_space *mapping = inode->i_mapping;
+
+	/*
+	 * If the underlying filesystem is not going to provide
+	 * a way to truncate a range of blocks (punch a hole) -
+	 * we should return failure right now.
+	 */
+	if (!inode->i_op->truncate_range)
+		return -ENOSYS;
+
+	mutex_lock(&inode->i_mutex);
+	down_write(&inode->i_alloc_sem);
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
+	truncate_inode_pages_range(mapping, offset, end);
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
+	inode->i_op->truncate_range(inode, offset, end);
+	up_write(&inode->i_alloc_sem);
+	mutex_unlock(&inode->i_mutex);
+
+	return 0;
+}
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

