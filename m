Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5AC3C1F
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739854060; cv=none; b=HfZOpFxkgF9151rdVDCTLbF92yPAEdJH3pEkulj74lwinPAK4WQ5FpA8ZClmea081UPVVnEkB3WcF9IWiyHk81xrq+Q0Hv4spDvsrbLAQDXg8fefe1UZb7Ku/VeqCYUjKNuau/jjQfHErdegpGJyJdTqpDhFFQUM047UgEnp6EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739854060; c=relaxed/simple;
	bh=hlgafR92tUiwH6aaaahw7yzCnjTXlOXi3wtGIINM0Mc=;
	h=Date:To:From:Subject:Message-Id; b=W44vwW86YOqcDMm5rho8her1Z9SQRiUwm4Ygevuo8GgFAVXCWBpHRA+F+dksnOVUHKh5o3f0J+t7ZBXTLlrS3u06tn12Ow79ifrfNeMdzy0Z3JgXS3YKbCAVqKmvPFlmYf4Y0bwYeZ/ilbzrL5sq1hkFtDmURDGd91wXQPqhDdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EtNKht52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EtNKht52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE69EC4CEE2;
	Tue, 18 Feb 2025 04:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739854059;
	bh=hlgafR92tUiwH6aaaahw7yzCnjTXlOXi3wtGIINM0Mc=;
	h=Date:To:From:Subject:From;
	b=EtNKht529Ekz0oXhP3kzUHi3SGVDSRk+0F9elLRsrSZN/3DyMuCc4v9JbRdKOuaiA
	 rK2ogJrG7L+T3bDKvCmArmjLy+0be+vqBautVZP57sxSnJJGljkEZK8xav1Cor/yBZ
	 ZyM/3uS/atC3t4XGZPDH8yG012JZAqBak8p3KS2I=
Date: Mon, 17 Feb 2025 20:47:39 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-create-a-common-implementation-to-break-dax-layouts.patch added to mm-unstable branch
Message-Id: <20250218044739.BE69EC4CEE2@smtp.kernel.org>
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
Date: Tue, 18 Feb 2025 14:55:21 +1100

Prior to freeing a block file systems supporting FS DAX must check that
the associated pages are both unmapped from user-space and not undergoing
DMA or other access from eg.  get_user_pages().  This is achieved by
unmapping the file range and scanning the FS DAX page-cache to see if any
pages within the mapping have an elevated refcount.

This is done using two functions - dax_layout_busy_page_range() which
returns a page to wait for the refcount to become idle on.  Rather than
open-code this introduce a common implementation to both unmap and wait
for the page to become idle.

Link: https://lkml.kernel.org/r/c4d381e41fc618296cee2820403c166d80599d5c.1739850794.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |   33 +++++++++++++++++++++++++++++++++
 fs/ext4/inode.c     |   13 +------------
 fs/fuse/dax.c       |   27 +++------------------------
 fs/xfs/xfs_inode.c  |   26 +++++++-------------------
 fs/xfs/xfs_inode.h  |    2 +-
 include/linux/dax.h |   23 ++++++++++++++++++-----
 6 files changed, 63 insertions(+), 61 deletions(-)

--- a/fs/dax.c~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/fs/dax.c
@@ -846,6 +846,39 @@ int dax_delete_mapping_entry(struct addr
 	return ret;
 }
 
+static int wait_page_idle(struct page *page,
+			void (cb)(struct inode *),
+			struct inode *inode)
+{
+	return ___wait_var_event(page, dax_page_is_idle(page),
+				TASK_INTERRUPTIBLE, 0, 0, cb(inode));
+}
+
+/*
+ * Unmaps the inode and waits for any DMA to complete prior to deleting the
+ * DAX mapping entries for the range.
+ */
+int dax_break_layout(struct inode *inode, loff_t start, loff_t end,
+		void (cb)(struct inode *))
+{
+	struct page *page;
+	int error = 0;
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
+EXPORT_SYMBOL_GPL(dax_break_layout);
+
 /*
  * Invalidate DAX entry if it is clean.
  */
--- a/fs/ext4/inode.c~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/fs/ext4/inode.c
@@ -3911,21 +3911,10 @@ static void ext4_wait_dax_page(struct in
 
 int ext4_break_layouts(struct inode *inode)
 {
-	struct page *page;
-	int error;
-
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
+	return dax_break_layout_inode(inode, ext4_wait_dax_page);
 }
 
 /*
--- a/fs/fuse/dax.c~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/fs/fuse/dax.c
@@ -666,33 +666,12 @@ static void fuse_wait_dax_page(struct in
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
+/* Should be called with mapping->invalidate_lock held exclusively. */
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
-
-	return ret;
+	return dax_break_layout(inode, dmap_start, dmap_end,
+				fuse_wait_dax_page);
 }
 
 ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
--- a/fs/xfs/xfs_inode.c~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/fs/xfs/xfs_inode.c
@@ -2735,21 +2735,17 @@ xfs_mmaplock_two_inodes_and_break_dax_la
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
 
@@ -2764,7 +2760,7 @@ again:
 	 * for this nested lock case.
 	 */
 	page = dax_layout_busy_page(VFS_I(ip2)->i_mapping);
-	if (page && page_ref_count(page) != 1) {
+	if (!dax_page_is_idle(page)) {
 		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
 		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
 		goto again;
@@ -3008,19 +3004,11 @@ xfs_wait_dax_page(
 
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
+	return dax_break_layout_inode(inode, xfs_wait_dax_page);
 }
 
 int
@@ -3038,8 +3026,8 @@ xfs_break_layouts(
 		retry = false;
 		switch (reason) {
 		case BREAK_UNMAP:
-			error = xfs_break_dax_layouts(inode, &retry);
-			if (error || retry)
+			error = xfs_break_dax_layouts(inode);
+			if (error)
 				break;
 			fallthrough;
 		case BREAK_WRITE:
--- a/fs/xfs/xfs_inode.h~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/fs/xfs/xfs_inode.h
@@ -603,7 +603,7 @@ xfs_itruncate_extents(
 	return xfs_itruncate_extents_flags(tpp, ip, whichfork, new_size, 0);
 }
 
-int	xfs_break_dax_layouts(struct inode *inode, bool *retry);
+int	xfs_break_dax_layouts(struct inode *inode);
 int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);
 
--- a/include/linux/dax.h~fs-dax-create-a-common-implementation-to-break-dax-layouts
+++ a/include/linux/dax.h
@@ -207,12 +207,9 @@ int dax_zero_range(struct inode *inode,
 int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 		const struct iomap_ops *ops);
 
-static inline int dax_wait_page_idle(struct page *page,
-				void (cb)(struct inode *),
-				struct inode *inode)
+static inline bool dax_page_is_idle(struct page *page)
 {
-	return ___wait_var_event(page, page_ref_count(page) == 1,
-				TASK_INTERRUPTIBLE, 0, 0, cb(inode));
+	return page && page_ref_count(page) == 1;
 }
 
 #if IS_ENABLED(CONFIG_DAX)
@@ -228,6 +225,15 @@ static inline void dax_read_unlock(int i
 {
 }
 #endif /* CONFIG_DAX */
+
+#if !IS_ENABLED(CONFIG_FS_DAX)
+static inline int __must_check dax_break_layout(struct inode *inode,
+			    loff_t start, loff_t end, void (cb)(struct inode *))
+{
+	return 0;
+}
+#endif
+
 bool dax_alive(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
@@ -251,6 +257,13 @@ vm_fault_t dax_finish_sync_fault(struct
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
+int __must_check dax_break_layout(struct inode *inode, loff_t start,
+				loff_t end, void (cb)(struct inode *));
+static inline int __must_check dax_break_layout_inode(struct inode *inode,
+						void (cb)(struct inode *))
+{
+	return dax_break_layout(inode, 0, LLONG_MAX, cb);
+}
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
mm-rmap-add-support-for-pud-sized-mappings-to-rmap.patch
mm-huge_memory-add-vmf_insert_folio_pud.patch
mm-huge_memory-add-vmf_insert_folio_pmd.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch

