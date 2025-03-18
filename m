Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171651B0414
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274489; cv=none; b=p5kpqKTHEnIU2HDZh1iQHAlmw6E/v7gfopRp5ZISJVnhIU5CIu+q3lz7ZwiBcVfBUSyDMcrgLBOF4hdm5UrMO+P1tPRTQBLsh4pCEPttmUOO70GQFU75YumGe67D447GQjJsIb7OAUyWPizU0wStr/SL3yj9J66iC3JItVxBE6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274489; c=relaxed/simple;
	bh=n3FCbCBvgkS18/hY2GxG6WYqF6mVEqPKyi2qFdG+F58=;
	h=Date:To:From:Subject:Message-Id; b=t5nVTHCHvUMWGwg1O4c/2znz0dYUwJlAW0AXXTgwYkn71iv9kAsjr9sbLDQeyy0q1OECULVCUchU3aReg5grlXeAPO2Bp/dSEQgmSpY3Mk1/b7Iccb2c4hBOAPMr00AfjDTaeypr/LbI5Hiw8b2XzQgHhwZSF6Sz7iZwLwvQx50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sTAEZRUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sTAEZRUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D727BC4CEDD;
	Tue, 18 Mar 2025 05:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274489;
	bh=n3FCbCBvgkS18/hY2GxG6WYqF6mVEqPKyi2qFdG+F58=;
	h=Date:To:From:Subject:From;
	b=sTAEZRUKo/lYxcBTy05XPPhIwFosz9GoSgZdWY1Vs7EgOuNBkGA3KQXByU8o8Bu8S
	 MW+SiZC4AjdHDN8AjVQH/FcYLPGTv6/GO0zB7zJBiSP87uibYEQB7NP/SezVoFCAfI
	 Lr1/FBaXxkPqSZB/cVQgpfrmCgL7wCiKXCeVMfgM=
Date: Mon, 17 Mar 2025 22:08:08 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch removed from -mm tree
Message-Id: <20250318050808.D727BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/dax: ensure all pages are idle prior to filesystem unmount
has been removed from the -mm tree.  Its filename was
     fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: fs/dax: ensure all pages are idle prior to filesystem unmount
Date: Fri, 28 Feb 2025 14:31:02 +1100

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

Link: https://lkml.kernel.org/r/2d3cf575bbd095084993154be2f0aa7442e5cd28.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Wiliams <dan.j.williams@intel.com>
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
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael "Camp Drill Sergeant" Ellerman <mpe@ellerman.id.au>
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

 fs/dax.c            |   27 +++++++++++++++++++++++++++
 fs/ext4/inode.c     |    2 ++
 fs/xfs/xfs_super.c  |   12 ++++++++++++
 include/linux/dax.h |    5 +++++
 4 files changed, 46 insertions(+)

--- a/fs/dax.c~fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount
+++ a/fs/dax.c
@@ -884,6 +884,13 @@ static int wait_page_idle(struct page *p
 				TASK_INTERRUPTIBLE, 0, 0, cb(inode));
 }
 
+static void wait_page_idle_uninterruptible(struct page *page,
+					struct inode *inode)
+{
+	___wait_var_event(page, dax_page_is_idle(page),
+			TASK_UNINTERRUPTIBLE, 0, 0, schedule());
+}
+
 /*
  * Unmaps the inode and waits for any DMA to complete prior to deleting the
  * DAX mapping entries for the range.
@@ -919,6 +926,26 @@ int dax_break_layout(struct inode *inode
 }
 EXPORT_SYMBOL_GPL(dax_break_layout);
 
+void dax_break_layout_final(struct inode *inode)
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
+		wait_page_idle_uninterruptible(page, inode);
+	} while (true);
+
+	dax_delete_mapping_range(inode->i_mapping, 0, LLONG_MAX);
+}
+EXPORT_SYMBOL_GPL(dax_break_layout_final);
+
 /*
  * Invalidate DAX entry if it is clean.
  */
--- a/fs/ext4/inode.c~fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount
+++ a/fs/ext4/inode.c
@@ -181,6 +181,8 @@ void ext4_evict_inode(struct inode *inod
 
 	trace_ext4_evict_inode(inode);
 
+	dax_break_layout_final(inode);
+
 	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
 		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
--- a/fs/xfs/xfs_super.c~fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount
+++ a/fs/xfs/xfs_super.c
@@ -751,6 +751,17 @@ xfs_fs_drop_inode(
 	return generic_drop_inode(inode);
 }
 
+STATIC void
+xfs_fs_evict_inode(
+	struct inode		*inode)
+{
+	if (IS_DAX(inode))
+		dax_break_layout_final(inode);
+
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
+}
+
 static void
 xfs_mount_free(
 	struct xfs_mount	*mp)
@@ -1215,6 +1226,7 @@ static const struct super_operations xfs
 	.destroy_inode		= xfs_fs_destroy_inode,
 	.dirty_inode		= xfs_fs_dirty_inode,
 	.drop_inode		= xfs_fs_drop_inode,
+	.evict_inode		= xfs_fs_evict_inode,
 	.put_super		= xfs_fs_put_super,
 	.sync_fs		= xfs_fs_sync_fs,
 	.freeze_fs		= xfs_fs_freeze,
--- a/include/linux/dax.h~fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount
+++ a/include/linux/dax.h
@@ -232,6 +232,10 @@ static inline int __must_check dax_break
 {
 	return 0;
 }
+
+static inline void dax_break_layout_final(struct inode *inode)
+{
+}
 #endif
 
 bool dax_alive(struct dax_device *dax_dev);
@@ -266,6 +270,7 @@ static inline int __must_check dax_break
 {
 	return dax_break_layout(inode, 0, LLONG_MAX, cb);
 }
+void dax_break_layout_final(struct inode *inode);
 int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 				  struct inode *dest, loff_t destoff,
 				  loff_t len, bool *is_same,
_

Patches currently in -mm which might be from apopple@nvidia.com are


