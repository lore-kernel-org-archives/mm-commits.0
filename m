Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5B81990AE
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317601; cv=none; b=jPy0r8mslxnOUYKMEMuuCnQzf8WdDZrchnyN1wcYT9Udai+pOk6EBT5IBMmCO22EAwsdS/8M5JDXw9VV76b5HK84y//1FNbNnKz8H7D3DX3EGwxX2zPl3RKbjA4GuSQYx35fxHu1V9zLiB/j8B10zZVCYoRm0oOO1QR1TJWKfx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317601; c=relaxed/simple;
	bh=zhucV8oEFdfBV+Kguq4KdU+hyJjRZv8Yd1iz5ETLqSM=;
	h=Date:To:From:Subject:Message-Id; b=igVEdDijDJUBr9ZsA7OUNi3HQc+BD++WUMH6UlViHY/oxPxAeG3+TPiY23Yc1/syXiCXU4OrBdjOC5a2ed53IbziFKUlHt2LaoRbCeW8+xF0QSbrLEgwMsHxBRHVPwNW/0R4gBozu2M5RIKOmMZjLZ91+qRnIDn/P/MOIk1x9OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cJswvkne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cJswvkne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C127C4CED0;
	Wed,  8 Jan 2025 06:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317601;
	bh=zhucV8oEFdfBV+Kguq4KdU+hyJjRZv8Yd1iz5ETLqSM=;
	h=Date:To:From:Subject:From;
	b=cJswvkne7YDPq39fMw024N//f1jGw5VUIr0wLH2dv8/RamVyetAXiALZUwgilY92w
	 9OEwky5TA6R4xVo8iS1U9C7FK1hrAuqtty0T+9dQ8YY0LXbYFz9/NasxITxo2vas5U
	 TFOqrZ4rMZRn0ljUv1GAKPF2iuzeoXy12O01Cbjc=
Date: Tue, 07 Jan 2025 22:26:40 -0800
To: mm-commits@vger.kernel.org,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch added to mm-unstable branch
Message-Id: <20250108062641.0C127C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/dax: ensure all pages are idle prior to filesystem unmount
has been added to the -mm mm-unstable branch.  Its filename is
     fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: fs/dax: ensure all pages are idle prior to filesystem unmount
Date: Tue, 7 Jan 2025 14:42:23 +1100

File systems call dax_break_mapping() prior to reallocating file system
blocks to ensure the page is not undergoing any DMA or other accesses. 
Generally this is needed when a file is truncated to ensure that if a
block is reallocated nothing is writing to it.  However filesystems
currently don't call this when an FS DAX inode is evicted.

This can cause problems when the file system is unmounted as a page can
continue to be under going DMA or other remote access after unmount.  This
means if the file system is remounted any truncate or other operation
which requires the underlying file system block to be freed will not wait
for the remote access to complete.  Therefore a busy block may be
reallocated to a new file leading to corruption.

Link: https://lkml.kernel.org/r/5eadb9096a42f993273cdd755124955665dcea26.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |   29 +++++++++++++++++++++++++++++
 fs/ext4/inode.c     |   32 ++++++++++++++------------------
 fs/xfs/xfs_inode.c  |    9 +++++++++
 fs/xfs/xfs_inode.h  |    1 +
 fs/xfs/xfs_super.c  |   18 ++++++++++++++++++
 include/linux/dax.h |    2 ++
 6 files changed, 73 insertions(+), 18 deletions(-)

--- a/fs/dax.c~fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount
+++ a/fs/dax.c
@@ -883,6 +883,14 @@ static int wait_page_idle(struct page *p
 				TASK_INTERRUPTIBLE, 0, 0, cb(inode));
 }
 
+static void wait_page_idle_uninterruptible(struct page *page,
+					void (cb)(struct inode *),
+					struct inode *inode)
+{
+	___wait_var_event(page, page_ref_count(page) == 1,
+			TASK_UNINTERRUPTIBLE, 0, 0, cb(inode));
+}
+
 /*
  * Unmaps the inode and waits for any DMA to complete prior to deleting the
  * DAX mapping entries for the range.
@@ -911,6 +919,27 @@ int dax_break_mapping(struct inode *inod
 }
 EXPORT_SYMBOL_GPL(dax_break_mapping);
 
+void dax_break_mapping_uninterruptible(struct inode *inode,
+				void (cb)(struct inode *))
+{
+	struct page *page;
+
+	if (!dax_mapping(inode->i_mapping))
+		return;
+
+	do {
+		page = dax_layout_busy_page_range(inode->i_mapping, 0,
+						LLONG_MAX);
+		if (!page)
+			break;
+
+		wait_page_idle_uninterruptible(page, cb, inode);
+	} while (true);
+
+	dax_delete_mapping_range(inode->i_mapping, 0, LLONG_MAX);
+}
+EXPORT_SYMBOL_GPL(dax_break_mapping_uninterruptible);
+
 /*
  * Invalidate DAX entry if it is clean.
  */
--- a/fs/ext4/inode.c~fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount
+++ a/fs/ext4/inode.c
@@ -163,6 +163,18 @@ int ext4_inode_is_fast_symlink(struct in
 	       (inode->i_size < EXT4_N_BLOCKS * 4);
 }
 
+static void ext4_wait_dax_page(struct inode *inode)
+{
+	filemap_invalidate_unlock(inode->i_mapping);
+	schedule();
+	filemap_invalidate_lock(inode->i_mapping);
+}
+
+int ext4_break_layouts(struct inode *inode)
+{
+	return dax_break_mapping_inode(inode, ext4_wait_dax_page);
+}
+
 /*
  * Called at the last iput() if i_nlink is zero.
  */
@@ -181,6 +193,8 @@ void ext4_evict_inode(struct inode *inod
 
 	trace_ext4_evict_inode(inode);
 
+	dax_break_mapping_uninterruptible(inode, ext4_wait_dax_page);
+
 	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
 		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
@@ -3902,24 +3916,6 @@ int ext4_update_disksize_before_punch(st
 	return ret;
 }
 
-static void ext4_wait_dax_page(struct inode *inode)
-{
-	filemap_invalidate_unlock(inode->i_mapping);
-	schedule();
-	filemap_invalidate_lock(inode->i_mapping);
-}
-
-int ext4_break_layouts(struct inode *inode)
-{
-	struct page *page;
-	int error;
-
-	if (WARN_ON_ONCE(!rwsem_is_locked(&inode->i_mapping->invalidate_lock)))
-		return -EINVAL;
-
-	return dax_break_mapping_inode(inode, ext4_wait_dax_page);
-}
-
 /*
  * ext4_punch_hole: punches a hole in a file by releasing the blocks
  * associated with the given offset and length
--- a/fs/xfs/xfs_inode.c~fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount
+++ a/fs/xfs/xfs_inode.c
@@ -2997,6 +2997,15 @@ xfs_break_dax_layouts(
 	return dax_break_mapping_inode(inode, xfs_wait_dax_page);
 }
 
+void
+xfs_break_dax_layouts_uninterruptible(
+	struct inode		*inode)
+{
+	xfs_assert_ilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL);
+
+	dax_break_mapping_uninterruptible(inode, xfs_wait_dax_page);
+}
+
 int
 xfs_break_layouts(
 	struct inode		*inode,
--- a/fs/xfs/xfs_inode.h~fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount
+++ a/fs/xfs/xfs_inode.h
@@ -594,6 +594,7 @@ xfs_itruncate_extents(
 }
 
 int	xfs_break_dax_layouts(struct inode *inode);
+void xfs_break_dax_layouts_uninterruptible(struct inode *inode);
 int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);
 
--- a/fs/xfs/xfs_super.c~fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount
+++ a/fs/xfs/xfs_super.c
@@ -751,6 +751,23 @@ xfs_fs_drop_inode(
 	return generic_drop_inode(inode);
 }
 
+STATIC void
+xfs_fs_evict_inode(
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+
+	if (IS_DAX(inode)) {
+		xfs_ilock(ip, iolock);
+		xfs_break_dax_layouts_uninterruptible(inode);
+		xfs_iunlock(ip, iolock);
+	}
+
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
+}
+
 static void
 xfs_mount_free(
 	struct xfs_mount	*mp)
@@ -1189,6 +1206,7 @@ static const struct super_operations xfs
 	.destroy_inode		= xfs_fs_destroy_inode,
 	.dirty_inode		= xfs_fs_dirty_inode,
 	.drop_inode		= xfs_fs_drop_inode,
+	.evict_inode		= xfs_fs_evict_inode,
 	.put_super		= xfs_fs_put_super,
 	.sync_fs		= xfs_fs_sync_fs,
 	.freeze_fs		= xfs_fs_freeze,
--- a/include/linux/dax.h~fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount
+++ a/include/linux/dax.h
@@ -274,6 +274,8 @@ static inline int __must_check dax_break
 {
 	return dax_break_mapping(inode, 0, LLONG_MAX, cb);
 }
+void dax_break_mapping_uninterruptible(struct inode *inode,
+				void (cb)(struct inode *));
 int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 				  struct inode *dest, loff_t destoff,
 				  loff_t len, bool *is_same,
_

Patches currently in -mm which might be from apopple@nvidia.com are

fuse-fix-dax-truncate-punch_hole-fault-path.patch
fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch
fs-dax-dont-skip-locked-entries-when-scanning-entries.patch
fs-dax-refactor-wait-for-dax-idle-page.patch
fs-dax-create-a-common-implementation-to-break-dax-layouts.patch
fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch
fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch
fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch
mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch
mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch
mm-allow-compound-zone-device-pages.patch
mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch
mm-memory-add-vmf_insert_page_mkwrite.patch
rmap-add-support-for-pud-sized-mappings-to-rmap.patch
huge_memory-add-vmf_insert_folio_pud.patch
huge_memory-add-vmf_insert_folio_pmd.patch
memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch
mm-mlock-skip-zone_device-pmds-during-mlock.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch
mm-remove-pxx_devmap-callers.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
revert-riscv-mm-add-support-for-zone_device.patch

