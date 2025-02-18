Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4435D3C1F
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739854068; cv=none; b=n8twJwFZsnBcylB67aPutfnRxugKt6Dn5kWU5RIsDHUkSYHkSeEym8ND0TpZXm26JH1/a7jTsAgrvERR+bFkHFBZgkdu2nS6rluhS/T69C+Pt0YJpt0jcmwmZQsdEyO9t2B90OAFKjE7tkErWKeS9gr5Bs+9GOZzO8RUuyVfgjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739854068; c=relaxed/simple;
	bh=4JS/lKCD7qpsZ0aOZtFeVYVBRUjgWPk3aXFcMEm+4qE=;
	h=Date:To:From:Subject:Message-Id; b=MfN+1BEcmZ5b3/WCgBC54D4tHtrx5zD8CpR+lkkyI5AG8hJeKAwOipLRhSNy5CnVceGpENoa4TC7xtGAj7Mt3MP1yg+TPoEiPrNoMkCmVcZUzLr/56UIN52BVl/TpP99T1jyBXpA0r7HedeoQ6g0L6RDir27tDztg0IGZPKISRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PjWLtw29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PjWLtw29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C31C4CEE2;
	Tue, 18 Feb 2025 04:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739854067;
	bh=4JS/lKCD7qpsZ0aOZtFeVYVBRUjgWPk3aXFcMEm+4qE=;
	h=Date:To:From:Subject:From;
	b=PjWLtw29qm3J6+/YSQaxmtfVTmO8+23JHseqEw2DdBJLQV+NH4YC7cbSGWo2V8Txr
	 3df5KwjHbhZMhtGtls/XfwNqUsWrG/tPuAKJr/3S/ITwy3ZSL0aT1fVGK7R8+3ntED
	 W+H6poRkg0HVd0TfGxFlk06psbf0J8nW4Fi4lN8Y=
Date: Mon, 17 Feb 2025 20:47:47 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch added to mm-unstable branch
Message-Id: <20250218044747.95C31C4CEE2@smtp.kernel.org>
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
Date: Tue, 18 Feb 2025 14:55:23 +1100

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

Link: https://lkml.kernel.org/r/2d3cf575bbd095084993154be2f0aa7442e5cd28.1739850794.git-series.apopple@nvidia.com
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

