Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0706A1A238C
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317594; cv=none; b=DsCptmtpGRuu8OdmFgwVIs3SqDSv2tGbMipFvnngBNwrbDnZgpI4aQKdz0Mrq/eoDQhccXr1yzUYPxLNWsVC+D4lfD4lrKJl+9e7UpiudNuvhIaLQby+8RhRNm9MDY5II76ak5IwTp3nr6VneT+BXJ0db4xJUEu3jGmW1akN5Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317594; c=relaxed/simple;
	bh=YUMayHsI7TByaRD6f/IA7jCuVNTlmCuumBmVy3mJ2hs=;
	h=Date:To:From:Subject:Message-Id; b=syjreFkp56euFMD034EVGlg/RvcL/ngIJvV94gzGb7p8vp4CthXXILjiX+70uTSrsdeAa8KD0AdUv2GV8eMQBCgru/EwzPtcnsTXdZDMgr+gPdOWDL0z/gnpXUOG6VMVIhETFLzH42k3p5PeRZQBVcbo1AcGKhMRtPkwCi9e4M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/HEnfjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/HEnfjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879BBC4CED0;
	Wed,  8 Jan 2025 06:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317593;
	bh=YUMayHsI7TByaRD6f/IA7jCuVNTlmCuumBmVy3mJ2hs=;
	h=Date:To:From:Subject:From;
	b=a/HEnfjYVkaf59FmgdEqdXyHRdXKeRsnbM0+hcldad/9CSvkZea8hQZ+DnBM1QUue
	 rl1EpeqG6pma8136Tf0j156xW4JTJW0tAvxwgi2UAzu8sAydemc9+p5fcniVSM+/tA
	 Ccp2CqXNXJbN4JNW4yj4n5+UXuCK+9u73w5Om0WI=
Date: Tue, 07 Jan 2025 22:26:32 -0800
To: mm-commits@vger.kernel.org,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-create-a-common-implementation-to-break-dax-layouts.patch added to mm-unstable branch
Message-Id: <20250108062633.879BBC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/dax: create a common implementation to break DAX layouts
has been added to the -mm mm-unstable branch.  Its filename is
     fs-dax-create-a-common-implementation-to-break-dax-layouts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dax-create-a-common-implementation-to-break-dax-layouts.patch

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
Subject: fs/dax: create a common implementation to break DAX layouts
Date: Tue, 7 Jan 2025 14:42:21 +1100

Prior to freeing a block file systems supporting FS DAX must check that
the associated pages are both unmapped from user-space and not undergoing
DMA or other access from eg.  get_user_pages().  This is achieved by
unmapping the file range and scanning the FS DAX page-cache to see if any
pages within the mapping have an elevated refcount.

This is done using two functions - dax_layout_busy_page_range() which
returns a page to wait for the refcount to become idle on.  Rather than
open-code this introduce a common implementation to both unmap and wait
for the page to become idle.

Link: https://lkml.kernel.org/r/e8f1302aa676169ef5a10e2e06397e78794d5bb4.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |   33 +++++++++++++++++++++++++++++++++
 fs/ext4/inode.c     |   10 +---------
 fs/fuse/dax.c       |   29 +++++------------------------
 fs/xfs/xfs_inode.c  |   23 +++++------------------
 fs/xfs/xfs_inode.h  |    2 +-
 include/linux/dax.h |   21 +++++++++++++++++++++
 mm/madvise.c        |    8 ++++----
 7 files changed, 70 insertions(+), 56 deletions(-)

--- a/fs/dax.c~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/fs/dax.c
@@ -845,6 +845,39 @@ int dax_delete_mapping_entry(struct addr
 	return ret;
 }
 
+static int wait_page_idle(struct page *page,
+			void (cb)(struct inode *),
+			struct inode *inode)
+{
+	return ___wait_var_event(page, page_ref_count(page) == 1,
+				TASK_INTERRUPTIBLE, 0, 0, cb(inode));
+}
+
+/*
+ * Unmaps the inode and waits for any DMA to complete prior to deleting the
+ * DAX mapping entries for the range.
+ */
+int dax_break_mapping(struct inode *inode, loff_t start, loff_t end,
+		void (cb)(struct inode *))
+{
+	struct page *page;
+	int error;
+
+	if (!dax_mapping(inode->i_mapping))
+		return 0;
+
+	do {
+		page = dax_layout_busy_page_range(inode->i_mapping, start, end);
+		if (!page)
+			break;
+
+		error = wait_page_idle(page, cb, inode);
+	} while (error == 0);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(dax_break_mapping);
+
 /*
  * Invalidate DAX entry if it is clean.
  */
--- a/fs/ext4/inode.c~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/fs/ext4/inode.c
@@ -3917,15 +3917,7 @@ int ext4_break_layouts(struct inode *ino
 	if (WARN_ON_ONCE(!rwsem_is_locked(&inode->i_mapping->invalidate_lock)))
 		return -EINVAL;
 
-	do {
-		page = dax_layout_busy_page(inode->i_mapping);
-		if (!page)
-			return 0;
-
-		error = dax_wait_page_idle(page, ext4_wait_dax_page, inode);
-	} while (error == 0);
-
-	return error;
+	return dax_break_mapping_inode(inode, ext4_wait_dax_page);
 }
 
 /*
--- a/fs/fuse/dax.c~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/fs/fuse/dax.c
@@ -665,38 +665,19 @@ static void fuse_wait_dax_page(struct in
 	filemap_invalidate_lock(inode->i_mapping);
 }
 
-/* Should be called with mapping->invalidate_lock held exclusively */
-static int __fuse_dax_break_layouts(struct inode *inode, bool *retry,
-				    loff_t start, loff_t end)
-{
-	struct page *page;
-
-	page = dax_layout_busy_page_range(inode->i_mapping, start, end);
-	if (!page)
-		return 0;
-
-	*retry = true;
-	return dax_wait_page_idle(page, fuse_wait_dax_page, inode);
-}
-
-/* dmap_end == 0 leads to unmapping of whole file */
+/* Should be called with mapping->invalidate_lock held exclusively.
+ * dmap_end == 0 leads to unmapping of whole file.
+ */
 int fuse_dax_break_layouts(struct inode *inode, u64 dmap_start,
 				  u64 dmap_end)
 {
-	bool	retry;
-	int	ret;
-
-	do {
-		retry = false;
-		ret = __fuse_dax_break_layouts(inode, &retry, dmap_start,
-					       dmap_end);
-	} while (ret == 0 && retry);
 	if (!dmap_end) {
 		dmap_start = 0;
 		dmap_end = LLONG_MAX;
 	}
 
-	return ret;
+	return dax_break_mapping(inode, dmap_start, dmap_end,
+				fuse_wait_dax_page);
 }
 
 ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
--- a/fs/xfs/xfs_inode.c~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/fs/xfs/xfs_inode.c
@@ -2715,21 +2715,17 @@ xfs_mmaplock_two_inodes_and_break_dax_la
 	struct xfs_inode	*ip2)
 {
 	int			error;
-	bool			retry;
 	struct page		*page;
 
 	if (ip1->i_ino > ip2->i_ino)
 		swap(ip1, ip2);
 
 again:
-	retry = false;
 	/* Lock the first inode */
 	xfs_ilock(ip1, XFS_MMAPLOCK_EXCL);
-	error = xfs_break_dax_layouts(VFS_I(ip1), &retry);
-	if (error || retry) {
+	error = xfs_break_dax_layouts(VFS_I(ip1));
+	if (error) {
 		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
-		if (error == 0 && retry)
-			goto again;
 		return error;
 	}
 
@@ -2988,19 +2984,11 @@ xfs_wait_dax_page(
 
 int
 xfs_break_dax_layouts(
-	struct inode		*inode,
-	bool			*retry)
+	struct inode		*inode)
 {
-	struct page		*page;
-
 	xfs_assert_ilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL);
 
-	page = dax_layout_busy_page(inode->i_mapping);
-	if (!page)
-		return 0;
-
-	*retry = true;
-	return dax_wait_page_idle(page, xfs_wait_dax_page, inode);
+	return dax_break_mapping_inode(inode, xfs_wait_dax_page);
 }
 
 int
@@ -3018,8 +3006,7 @@ xfs_break_layouts(
 		retry = false;
 		switch (reason) {
 		case BREAK_UNMAP:
-			error = xfs_break_dax_layouts(inode, &retry);
-			if (error || retry)
+			if (xfs_break_dax_layouts(inode))
 				break;
 			fallthrough;
 		case BREAK_WRITE:
--- a/fs/xfs/xfs_inode.h~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/fs/xfs/xfs_inode.h
@@ -593,7 +593,7 @@ xfs_itruncate_extents(
 	return xfs_itruncate_extents_flags(tpp, ip, whichfork, new_size, 0);
 }
 
-int	xfs_break_dax_layouts(struct inode *inode, bool *retry);
+int	xfs_break_dax_layouts(struct inode *inode);
 int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);
 
--- a/include/linux/dax.h~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/include/linux/dax.h
@@ -228,6 +228,20 @@ static inline void dax_read_unlock(int i
 {
 }
 #endif /* CONFIG_DAX */
+
+#if !IS_ENABLED(CONFIG_FS_DAX)
+static inline int __must_check dax_break_mapping(struct inode *inode,
+			    loff_t start, loff_t end, void (cb)(struct inode *))
+{
+	return 0;
+}
+
+static inline void dax_break_mapping_uninterruptible(struct inode *inode,
+						void (cb)(struct inode *))
+{
+}
+#endif
+
 bool dax_alive(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
@@ -251,6 +265,13 @@ vm_fault_t dax_finish_sync_fault(struct
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
+int __must_check dax_break_mapping(struct inode *inode, loff_t start,
+				loff_t end, void (cb)(struct inode *));
+static inline int __must_check dax_break_mapping_inode(struct inode *inode,
+						void (cb)(struct inode *))
+{
+	return dax_break_mapping(inode, 0, LLONG_MAX, cb);
+}
 int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 				  struct inode *dest, loff_t destoff,
 				  loff_t len, bool *is_same,
--- a/mm/madvise.c~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/mm/madvise.c
@@ -1063,7 +1063,7 @@ static int guard_install_pud_entry(pud_t
 	pud_t pudval = pudp_get(pud);
 
 	/* If huge return >0 so we abort the operation + zap. */
-	return pud_trans_huge(pudval) || pud_devmap(pudval);
+	return pud_trans_huge(pudval);
 }
 
 static int guard_install_pmd_entry(pmd_t *pmd, unsigned long addr,
@@ -1072,7 +1072,7 @@ static int guard_install_pmd_entry(pmd_t
 	pmd_t pmdval = pmdp_get(pmd);
 
 	/* If huge return >0 so we abort the operation + zap. */
-	return pmd_trans_huge(pmdval) || pmd_devmap(pmdval);
+	return pmd_trans_huge(pmdval);
 }
 
 static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
@@ -1183,7 +1183,7 @@ static int guard_remove_pud_entry(pud_t
 	pud_t pudval = pudp_get(pud);
 
 	/* If huge, cannot have guard pages present, so no-op - skip. */
-	if (pud_trans_huge(pudval) || pud_devmap(pudval))
+	if (pud_trans_huge(pudval))
 		walk->action = ACTION_CONTINUE;
 
 	return 0;
@@ -1195,7 +1195,7 @@ static int guard_remove_pmd_entry(pmd_t
 	pmd_t pmdval = pmdp_get(pmd);
 
 	/* If huge, cannot have guard pages present, so no-op - skip. */
-	if (pmd_trans_huge(pmdval) || pmd_devmap(pmdval))
+	if (pmd_trans_huge(pmdval))
 		walk->action = ACTION_CONTINUE;
 
 	return 0;
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

