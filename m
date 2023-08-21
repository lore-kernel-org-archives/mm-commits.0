Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBF7EE4993
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 18:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjHUS5x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 14:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjHUS5w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 14:57:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9FB3590
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 11:57:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BEC76423A
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 18:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E82AC433C7;
        Mon, 21 Aug 2023 18:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692643637;
        bh=47YNND1gvc8NiQPZgRQa/GGjE/ARtb3ulnFf1EAN/DA=;
        h=Date:To:From:Subject:From;
        b=nzYXpM+BLkLMPnuK0HHKUHuc+OGEeoXacYLnk8aGdtTqLsUJB7qnaVwR1ApU+Yqtu
         4qCYxIDhNZ6o3vDfy6DTkdsWYLrQaZk8sKw9iHRS1Q8U981DIoP8H9QgsCCgsh589H
         dJbLHQ5LoYtZwt1fRdOA26d8BYu7/SJikP5EliHU=
Date:   Mon, 21 Aug 2023 11:47:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-enum-page_entry_size.patch added to mm-unstable branch
Message-Id: <20230821184717.6E82AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove enum page_entry_size
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-enum-page_entry_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-enum-page_entry_size.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove enum page_entry_size
Date: Fri, 18 Aug 2023 21:23:35 +0100

Remove the unnecessary encoding of page order into an enum and pass the
page order directly.  That lets us get rid of pe_order().

The switch constructs have to be changed to if/else constructs to prevent
GCC from warning on builds with 3-level page tables where PMD_ORDER and
PUD_ORDER have the same value.

If you are looking at this commit because your driver stopped compiling,
look at the previous commit as well and audit your driver to be sure it
doesn't depend on mmap_lock being held in its ->huge_fault method.

Link: https://lkml.kernel.org/r/20230818202335.2739663-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |   22 ++++++++--------------
 fs/dax.c             |   30 ++++++++----------------------
 fs/erofs/data.c      |    6 +++---
 fs/ext2/file.c       |    2 +-
 fs/ext4/file.c       |   11 +++++------
 fs/fuse/dax.c        |   20 +++++++++-----------
 fs/xfs/xfs_file.c    |   24 ++++++++++++------------
 fs/xfs/xfs_trace.h   |   22 ++++++++++------------
 include/linux/dax.h  |    4 ++--
 include/linux/mm.h   |   10 +---------
 mm/memory.c          |    8 ++++----
 11 files changed, 63 insertions(+), 96 deletions(-)

--- a/drivers/dax/device.c~mm-remove-enum-page_entry_size
+++ a/drivers/dax/device.c
@@ -228,32 +228,26 @@ static vm_fault_t __dev_dax_pud_fault(st
 }
 #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
-static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
-		enum page_entry_size pe_size)
+static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf, unsigned int order)
 {
 	struct file *filp = vmf->vma->vm_file;
 	vm_fault_t rc = VM_FAULT_SIGBUS;
 	int id;
 	struct dev_dax *dev_dax = filp->private_data;
 
-	dev_dbg(&dev_dax->dev, "%s: %s (%#lx - %#lx) size = %d\n", current->comm,
+	dev_dbg(&dev_dax->dev, "%s: %s (%#lx - %#lx) order:%d\n", current->comm,
 			(vmf->flags & FAULT_FLAG_WRITE) ? "write" : "read",
-			vmf->vma->vm_start, vmf->vma->vm_end, pe_size);
+			vmf->vma->vm_start, vmf->vma->vm_end, order);
 
 	id = dax_read_lock();
-	switch (pe_size) {
-	case PE_SIZE_PTE:
+	if (order == 0)
 		rc = __dev_dax_pte_fault(dev_dax, vmf);
-		break;
-	case PE_SIZE_PMD:
+	else if (order == PMD_ORDER)
 		rc = __dev_dax_pmd_fault(dev_dax, vmf);
-		break;
-	case PE_SIZE_PUD:
+	else if (order == PUD_ORDER)
 		rc = __dev_dax_pud_fault(dev_dax, vmf);
-		break;
-	default:
+	else
 		rc = VM_FAULT_SIGBUS;
-	}
 
 	dax_read_unlock(id);
 
@@ -262,7 +256,7 @@ static vm_fault_t dev_dax_huge_fault(str
 
 static vm_fault_t dev_dax_fault(struct vm_fault *vmf)
 {
-	return dev_dax_huge_fault(vmf, PE_SIZE_PTE);
+	return dev_dax_huge_fault(vmf, 0);
 }
 
 static int dev_dax_may_split(struct vm_area_struct *vma, unsigned long addr)
--- a/fs/dax.c~mm-remove-enum-page_entry_size
+++ a/fs/dax.c
@@ -30,17 +30,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/fs_dax.h>
 
-static inline unsigned int pe_order(enum page_entry_size pe_size)
-{
-	if (pe_size == PE_SIZE_PTE)
-		return PAGE_SHIFT - PAGE_SHIFT;
-	if (pe_size == PE_SIZE_PMD)
-		return PMD_SHIFT - PAGE_SHIFT;
-	if (pe_size == PE_SIZE_PUD)
-		return PUD_SHIFT - PAGE_SHIFT;
-	return ~0;
-}
-
 /* We choose 4096 entries - same as per-zone page wait tables */
 #define DAX_WAIT_TABLE_BITS 12
 #define DAX_WAIT_TABLE_ENTRIES (1 << DAX_WAIT_TABLE_BITS)
@@ -1905,7 +1894,7 @@ static vm_fault_t dax_iomap_pmd_fault(st
 /**
  * dax_iomap_fault - handle a page fault on a DAX file
  * @vmf: The description of the fault
- * @pe_size: Size of the page to fault in
+ * @order: Order of the page to fault in
  * @pfnp: PFN to insert for synchronous faults if fsync is required
  * @iomap_errp: Storage for detailed error code in case of error
  * @ops: Iomap ops passed from the file system
@@ -1915,17 +1904,15 @@ static vm_fault_t dax_iomap_pmd_fault(st
  * has done all the necessary locking for page fault to proceed
  * successfully.
  */
-vm_fault_t dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
+vm_fault_t dax_iomap_fault(struct vm_fault *vmf, unsigned int order,
 		    pfn_t *pfnp, int *iomap_errp, const struct iomap_ops *ops)
 {
-	switch (pe_size) {
-	case PE_SIZE_PTE:
+	if (order == 0)
 		return dax_iomap_pte_fault(vmf, pfnp, iomap_errp, ops);
-	case PE_SIZE_PMD:
+	else if (order == PMD_ORDER)
 		return dax_iomap_pmd_fault(vmf, pfnp, ops);
-	default:
+	else
 		return VM_FAULT_FALLBACK;
-	}
 }
 EXPORT_SYMBOL_GPL(dax_iomap_fault);
 
@@ -1976,19 +1963,18 @@ dax_insert_pfn_mkwrite(struct vm_fault *
 /**
  * dax_finish_sync_fault - finish synchronous page fault
  * @vmf: The description of the fault
- * @pe_size: Size of entry to be inserted
+ * @order: Order of entry to be inserted
  * @pfn: PFN to insert
  *
  * This function ensures that the file range touched by the page fault is
  * stored persistently on the media and handles inserting of appropriate page
  * table entry.
  */
-vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
-		enum page_entry_size pe_size, pfn_t pfn)
+vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf, unsigned int order,
+		pfn_t pfn)
 {
 	int err;
 	loff_t start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
-	unsigned int order = pe_order(pe_size);
 	size_t len = PAGE_SIZE << order;
 
 	err = vfs_fsync_range(vmf->vma->vm_file, start, start + len - 1, 1);
--- a/fs/erofs/data.c~mm-remove-enum-page_entry_size
+++ a/fs/erofs/data.c
@@ -413,14 +413,14 @@ const struct address_space_operations er
 
 #ifdef CONFIG_FS_DAX
 static vm_fault_t erofs_dax_huge_fault(struct vm_fault *vmf,
-		enum page_entry_size pe_size)
+		unsigned int order)
 {
-	return dax_iomap_fault(vmf, pe_size, NULL, NULL, &erofs_iomap_ops);
+	return dax_iomap_fault(vmf, order, NULL, NULL, &erofs_iomap_ops);
 }
 
 static vm_fault_t erofs_dax_fault(struct vm_fault *vmf)
 {
-	return erofs_dax_huge_fault(vmf, PE_SIZE_PTE);
+	return erofs_dax_huge_fault(vmf, 0);
 }
 
 static const struct vm_operations_struct erofs_dax_vm_ops = {
--- a/fs/ext2/file.c~mm-remove-enum-page_entry_size
+++ a/fs/ext2/file.c
@@ -103,7 +103,7 @@ static vm_fault_t ext2_dax_fault(struct
 	}
 	filemap_invalidate_lock_shared(inode->i_mapping);
 
-	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, NULL, &ext2_iomap_ops);
+	ret = dax_iomap_fault(vmf, 0, NULL, NULL, &ext2_iomap_ops);
 
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 	if (write)
--- a/fs/ext4/file.c~mm-remove-enum-page_entry_size
+++ a/fs/ext4/file.c
@@ -723,8 +723,7 @@ ext4_file_write_iter(struct kiocb *iocb,
 }
 
 #ifdef CONFIG_FS_DAX
-static vm_fault_t ext4_dax_huge_fault(struct vm_fault *vmf,
-		enum page_entry_size pe_size)
+static vm_fault_t ext4_dax_huge_fault(struct vm_fault *vmf, unsigned int order)
 {
 	int error = 0;
 	vm_fault_t result;
@@ -740,7 +739,7 @@ static vm_fault_t ext4_dax_huge_fault(st
 	 * read-only.
 	 *
 	 * We check for VM_SHARED rather than vmf->cow_page since the latter is
-	 * unset for pe_size != PE_SIZE_PTE (i.e. only in do_cow_fault); for
+	 * unset for order != 0 (i.e. only in do_cow_fault); for
 	 * other sizes, dax_iomap_fault will handle splitting / fallback so that
 	 * we eventually come back with a COW page.
 	 */
@@ -764,7 +763,7 @@ retry:
 	} else {
 		filemap_invalidate_lock_shared(mapping);
 	}
-	result = dax_iomap_fault(vmf, pe_size, &pfn, &error, &ext4_iomap_ops);
+	result = dax_iomap_fault(vmf, order, &pfn, &error, &ext4_iomap_ops);
 	if (write) {
 		ext4_journal_stop(handle);
 
@@ -773,7 +772,7 @@ retry:
 			goto retry;
 		/* Handling synchronous page fault? */
 		if (result & VM_FAULT_NEEDDSYNC)
-			result = dax_finish_sync_fault(vmf, pe_size, pfn);
+			result = dax_finish_sync_fault(vmf, order, pfn);
 		filemap_invalidate_unlock_shared(mapping);
 		sb_end_pagefault(sb);
 	} else {
@@ -785,7 +784,7 @@ retry:
 
 static vm_fault_t ext4_dax_fault(struct vm_fault *vmf)
 {
-	return ext4_dax_huge_fault(vmf, PE_SIZE_PTE);
+	return ext4_dax_huge_fault(vmf, 0);
 }
 
 static const struct vm_operations_struct ext4_dax_vm_ops = {
--- a/fs/fuse/dax.c~mm-remove-enum-page_entry_size
+++ a/fs/fuse/dax.c
@@ -784,8 +784,8 @@ static int fuse_dax_writepages(struct ad
 	return dax_writeback_mapping_range(mapping, fc->dax->dev, wbc);
 }
 
-static vm_fault_t __fuse_dax_fault(struct vm_fault *vmf,
-				   enum page_entry_size pe_size, bool write)
+static vm_fault_t __fuse_dax_fault(struct vm_fault *vmf, unsigned int order,
+		bool write)
 {
 	vm_fault_t ret;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
@@ -809,7 +809,7 @@ retry:
 	 * to populate page cache or access memory we are trying to free.
 	 */
 	filemap_invalidate_lock_shared(inode->i_mapping);
-	ret = dax_iomap_fault(vmf, pe_size, &pfn, &error, &fuse_iomap_ops);
+	ret = dax_iomap_fault(vmf, order, &pfn, &error, &fuse_iomap_ops);
 	if ((ret & VM_FAULT_ERROR) && error == -EAGAIN) {
 		error = 0;
 		retry = true;
@@ -818,7 +818,7 @@ retry:
 	}
 
 	if (ret & VM_FAULT_NEEDDSYNC)
-		ret = dax_finish_sync_fault(vmf, pe_size, pfn);
+		ret = dax_finish_sync_fault(vmf, order, pfn);
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 
 	if (write)
@@ -829,24 +829,22 @@ retry:
 
 static vm_fault_t fuse_dax_fault(struct vm_fault *vmf)
 {
-	return __fuse_dax_fault(vmf, PE_SIZE_PTE,
-				vmf->flags & FAULT_FLAG_WRITE);
+	return __fuse_dax_fault(vmf, 0, vmf->flags & FAULT_FLAG_WRITE);
 }
 
-static vm_fault_t fuse_dax_huge_fault(struct vm_fault *vmf,
-			       enum page_entry_size pe_size)
+static vm_fault_t fuse_dax_huge_fault(struct vm_fault *vmf, unsigned int order)
 {
-	return __fuse_dax_fault(vmf, pe_size, vmf->flags & FAULT_FLAG_WRITE);
+	return __fuse_dax_fault(vmf, order, vmf->flags & FAULT_FLAG_WRITE);
 }
 
 static vm_fault_t fuse_dax_page_mkwrite(struct vm_fault *vmf)
 {
-	return __fuse_dax_fault(vmf, PE_SIZE_PTE, true);
+	return __fuse_dax_fault(vmf, 0, true);
 }
 
 static vm_fault_t fuse_dax_pfn_mkwrite(struct vm_fault *vmf)
 {
-	return __fuse_dax_fault(vmf, PE_SIZE_PTE, true);
+	return __fuse_dax_fault(vmf, 0, true);
 }
 
 static const struct vm_operations_struct fuse_dax_vm_ops = {
--- a/fs/xfs/xfs_file.c~mm-remove-enum-page_entry_size
+++ a/fs/xfs/xfs_file.c
@@ -1287,11 +1287,11 @@ xfs_file_llseek(
 static inline vm_fault_t
 xfs_dax_fault(
 	struct vm_fault		*vmf,
-	enum page_entry_size	pe_size,
+	unsigned int		order,
 	bool			write_fault,
 	pfn_t			*pfn)
 {
-	return dax_iomap_fault(vmf, pe_size, pfn, NULL,
+	return dax_iomap_fault(vmf, order, pfn, NULL,
 			(write_fault && !vmf->cow_page) ?
 				&xfs_dax_write_iomap_ops :
 				&xfs_read_iomap_ops);
@@ -1300,7 +1300,7 @@ xfs_dax_fault(
 static inline vm_fault_t
 xfs_dax_fault(
 	struct vm_fault		*vmf,
-	enum page_entry_size	pe_size,
+	unsigned int		order,
 	bool			write_fault,
 	pfn_t			*pfn)
 {
@@ -1322,14 +1322,14 @@ xfs_dax_fault(
 static vm_fault_t
 __xfs_filemap_fault(
 	struct vm_fault		*vmf,
-	enum page_entry_size	pe_size,
+	unsigned int		order,
 	bool			write_fault)
 {
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	vm_fault_t		ret;
 
-	trace_xfs_filemap_fault(ip, pe_size, write_fault);
+	trace_xfs_filemap_fault(ip, order, write_fault);
 
 	if (write_fault) {
 		sb_start_pagefault(inode->i_sb);
@@ -1340,9 +1340,9 @@ __xfs_filemap_fault(
 		pfn_t pfn;
 
 		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-		ret = xfs_dax_fault(vmf, pe_size, write_fault, &pfn);
+		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
 		if (ret & VM_FAULT_NEEDDSYNC)
-			ret = dax_finish_sync_fault(vmf, pe_size, pfn);
+			ret = dax_finish_sync_fault(vmf, order, pfn);
 		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	} else {
 		if (write_fault) {
@@ -1373,7 +1373,7 @@ xfs_filemap_fault(
 	struct vm_fault		*vmf)
 {
 	/* DAX can shortcut the normal fault path on write faults! */
-	return __xfs_filemap_fault(vmf, PE_SIZE_PTE,
+	return __xfs_filemap_fault(vmf, 0,
 			IS_DAX(file_inode(vmf->vma->vm_file)) &&
 			xfs_is_write_fault(vmf));
 }
@@ -1381,13 +1381,13 @@ xfs_filemap_fault(
 static vm_fault_t
 xfs_filemap_huge_fault(
 	struct vm_fault		*vmf,
-	enum page_entry_size	pe_size)
+	unsigned int		order)
 {
 	if (!IS_DAX(file_inode(vmf->vma->vm_file)))
 		return VM_FAULT_FALLBACK;
 
 	/* DAX can shortcut the normal fault path on write faults! */
-	return __xfs_filemap_fault(vmf, pe_size,
+	return __xfs_filemap_fault(vmf, order,
 			xfs_is_write_fault(vmf));
 }
 
@@ -1395,7 +1395,7 @@ static vm_fault_t
 xfs_filemap_page_mkwrite(
 	struct vm_fault		*vmf)
 {
-	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
+	return __xfs_filemap_fault(vmf, 0, true);
 }
 
 /*
@@ -1408,7 +1408,7 @@ xfs_filemap_pfn_mkwrite(
 	struct vm_fault		*vmf)
 {
 
-	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
+	return __xfs_filemap_fault(vmf, 0, true);
 }
 
 static const struct vm_operations_struct xfs_file_vm_ops = {
--- a/fs/xfs/xfs_trace.h~mm-remove-enum-page_entry_size
+++ a/fs/xfs/xfs_trace.h
@@ -802,36 +802,34 @@ DEFINE_INODE_EVENT(xfs_inode_inactivatin
  * ring buffer.  Somehow this was only worth mentioning in the ftrace sample
  * code.
  */
-TRACE_DEFINE_ENUM(PE_SIZE_PTE);
-TRACE_DEFINE_ENUM(PE_SIZE_PMD);
-TRACE_DEFINE_ENUM(PE_SIZE_PUD);
+TRACE_DEFINE_ENUM(PMD_ORDER);
+TRACE_DEFINE_ENUM(PUD_ORDER);
 
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
 
 TRACE_EVENT(xfs_filemap_fault,
-	TP_PROTO(struct xfs_inode *ip, enum page_entry_size pe_size,
-		 bool write_fault),
-	TP_ARGS(ip, pe_size, write_fault),
+	TP_PROTO(struct xfs_inode *ip, unsigned int order, bool write_fault),
+	TP_ARGS(ip, order, write_fault),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
-		__field(enum page_entry_size, pe_size)
+		__field(unsigned int, order)
 		__field(bool, write_fault)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->pe_size = pe_size;
+		__entry->order = order;
 		__entry->write_fault = write_fault;
 	),
 	TP_printk("dev %d:%d ino 0x%llx %s write_fault %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __print_symbolic(__entry->pe_size,
-			{ PE_SIZE_PTE,	"PTE" },
-			{ PE_SIZE_PMD,	"PMD" },
-			{ PE_SIZE_PUD,	"PUD" }),
+		  __print_symbolic(__entry->order,
+			{ 0,		"PTE" },
+			{ PMD_ORDER,	"PMD" },
+			{ PUD_ORDER,	"PUD" }),
 		  __entry->write_fault)
 )
 
--- a/include/linux/dax.h~mm-remove-enum-page_entry_size
+++ a/include/linux/dax.h
@@ -241,10 +241,10 @@ void dax_flush(struct dax_device *dax_de
 
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);
-vm_fault_t dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
+vm_fault_t dax_iomap_fault(struct vm_fault *vmf, unsigned int order,
 		    pfn_t *pfnp, int *errp, const struct iomap_ops *ops);
 vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
-		enum page_entry_size pe_size, pfn_t pfn);
+		unsigned int order, pfn_t pfn);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
--- a/include/linux/mm.h~mm-remove-enum-page_entry_size
+++ a/include/linux/mm.h
@@ -532,13 +532,6 @@ struct vm_fault {
 					 */
 };
 
-/* page entry size for vm->huge_fault() */
-enum page_entry_size {
-	PE_SIZE_PTE = 0,
-	PE_SIZE_PMD,
-	PE_SIZE_PUD,
-};
-
 /*
  * These are the virtual MM functions - opening of an area, closing and
  * unmapping it (needed to keep files on disk up-to-date etc), pointer
@@ -562,8 +555,7 @@ struct vm_operations_struct {
 	int (*mprotect)(struct vm_area_struct *vma, unsigned long start,
 			unsigned long end, unsigned long newflags);
 	vm_fault_t (*fault)(struct vm_fault *vmf);
-	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
-			enum page_entry_size pe_size);
+	vm_fault_t (*huge_fault)(struct vm_fault *vmf, unsigned int order);
 	vm_fault_t (*map_pages)(struct vm_fault *vmf,
 			pgoff_t start_pgoff, pgoff_t end_pgoff);
 	unsigned long (*pagesize)(struct vm_area_struct * area);
--- a/mm/memory.c~mm-remove-enum-page_entry_size
+++ a/mm/memory.c
@@ -4858,7 +4858,7 @@ static inline vm_fault_t create_huge_pmd
 	if (vma_is_anonymous(vma))
 		return do_huge_pmd_anonymous_page(vmf);
 	if (vma->vm_ops->huge_fault)
-		return vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
+		return vma->vm_ops->huge_fault(vmf, PMD_ORDER);
 	return VM_FAULT_FALLBACK;
 }
 
@@ -4878,7 +4878,7 @@ static inline vm_fault_t wp_huge_pmd(str
 
 	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
 		if (vma->vm_ops->huge_fault) {
-			ret = vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
+			ret = vma->vm_ops->huge_fault(vmf, PMD_ORDER);
 			if (!(ret & VM_FAULT_FALLBACK))
 				return ret;
 		}
@@ -4899,7 +4899,7 @@ static vm_fault_t create_huge_pud(struct
 	if (vma_is_anonymous(vma))
 		return VM_FAULT_FALLBACK;
 	if (vma->vm_ops->huge_fault)
-		return vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
+		return vma->vm_ops->huge_fault(vmf, PUD_ORDER);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 	return VM_FAULT_FALLBACK;
 }
@@ -4916,7 +4916,7 @@ static vm_fault_t wp_huge_pud(struct vm_
 		goto split;
 	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
 		if (vma->vm_ops->huge_fault) {
-			ret = vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
+			ret = vma->vm_ops->huge_fault(vmf, PUD_ORDER);
 			if (!(ret & VM_FAULT_FALLBACK))
 				return ret;
 		}
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memoryc-fix-mismerge.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch
mm-allow-fault_dirty_shared_page-to-be-called-under-the-vma-lock.patch
io_uring-stop-calling-free_compound_page.patch
mm-call-free_huge_page-directly.patch
mm-convert-free_huge_page-to-free_huge_folio.patch
mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable.patch
mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch
mm-remove-free_compound_page-and-the-compound_page_dtors-array.patch
mm-remove-hugetlb_page_dtor.patch
mm-add-large_rmappable-page-flag.patch
mm-rearrange-page-flags.patch
mm-free-up-a-word-in-the-first-tail-page.patch
mm-remove-folio_test_transhuge.patch
mm-add-tail-private-fields-to-struct-folio.patch
mm-convert-split_huge_pages_pid-to-use-a-folio.patch
mm-swap-use-dedicated-entry-for-swap-in-folio.patch
mm-remove-checks-for-pte_index.patch
mm-move-pmd_order-to-pgtableh.patch
mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch
mm-remove-enum-page_entry_size.patch

