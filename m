From: akpm@linux-foundation.org
Subject: + mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault.patch added to -mm tree
Date: Tue, 10 Jan 2017 14:51:36 -0800
Message-ID: <58756578.C06NL3Ud6G1Jntro%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48172 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756056AbdAJWvk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 17:51:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.jiang@intel.com, david@fromorbit.com, jack@suse.cz, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: make pmd_fault() and friends be the same as fault()
has been added to the -mm tree.  Its filename is
     mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Jiang <dave.jiang@intel.com>
Subject: mm, dax: make pmd_fault() and friends be the same as fault()

Instead of passing in multiple parameters in the pmd_fault() handler,
a vmf can be passed in just like a fault() handler. This will simplify
code and remove the need for the actual pmd fault handlers to allocate a
vmf. Related functions are also modified to do the same.

Link: http://lkml.kernel.org/r/1484085142-2297-7-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/dax.c             |   16 +++++-------
 fs/dax.c                      |   42 +++++++++++++-------------------
 fs/ext4/file.c                |    9 +++---
 fs/xfs/xfs_file.c             |   10 +++----
 include/linux/dax.h           |    7 ++---
 include/linux/mm.h            |    3 --
 include/trace/events/fs_dax.h |   15 +++++------
 mm/memory.c                   |    6 +---
 8 files changed, 46 insertions(+), 62 deletions(-)

diff -puN drivers/dax/dax.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault drivers/dax/dax.c
--- a/drivers/dax/dax.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault
+++ a/drivers/dax/dax.c
@@ -473,10 +473,9 @@ static int dax_dev_fault(struct vm_area_
 }
 
 static int __dax_dev_pmd_fault(struct dax_dev *dax_dev,
-		struct vm_area_struct *vma, unsigned long addr, pmd_t *pmd,
-		unsigned int flags)
+		struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	unsigned long pmd_addr = addr & PMD_MASK;
+	unsigned long pmd_addr = vmf->address & PMD_MASK;
 	struct device *dev = &dax_dev->dev;
 	struct dax_region *dax_region;
 	phys_addr_t phys;
@@ -508,23 +507,22 @@ static int __dax_dev_pmd_fault(struct da
 
 	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
 
-	return vmf_insert_pfn_pmd(vma, addr, pmd, pfn,
-			flags & FAULT_FLAG_WRITE);
+	return vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
+			vmf->flags & FAULT_FLAG_WRITE);
 }
 
-static int dax_dev_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmd, unsigned int flags)
+static int dax_dev_pmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	int rc;
 	struct file *filp = vma->vm_file;
 	struct dax_dev *dax_dev = filp->private_data;
 
 	dev_dbg(&dax_dev->dev, "%s: %s: %s (%#lx - %#lx)\n", __func__,
-			current->comm, (flags & FAULT_FLAG_WRITE)
+			current->comm, (vmf->flags & FAULT_FLAG_WRITE)
 			? "write" : "read", vma->vm_start, vma->vm_end);
 
 	rcu_read_lock();
-	rc = __dax_dev_pmd_fault(dax_dev, vma, addr, pmd, flags);
+	rc = __dax_dev_pmd_fault(dax_dev, vma, vmf);
 	rcu_read_unlock();
 
 	return rc;
diff -puN fs/dax.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault fs/dax.c
--- a/fs/dax.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault
+++ a/fs/dax.c
@@ -1331,18 +1331,17 @@ fallback:
 	return VM_FAULT_FALLBACK;
 }
 
-int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
-		pmd_t *pmd, unsigned int flags, struct iomap_ops *ops)
+int dax_iomap_pmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+		struct iomap_ops *ops)
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
-	unsigned long pmd_addr = address & PMD_MASK;
-	bool write = flags & FAULT_FLAG_WRITE;
+	unsigned long pmd_addr = vmf->address & PMD_MASK;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned int iomap_flags = (write ? IOMAP_WRITE : 0) | IOMAP_FAULT;
 	struct inode *inode = mapping->host;
 	int result = VM_FAULT_FALLBACK;
 	struct iomap iomap = { 0 };
-	pgoff_t max_pgoff, pgoff;
-	struct vm_fault vmf;
+	pgoff_t max_pgoff;
 	void *entry;
 	loff_t pos;
 	int error;
@@ -1352,10 +1351,10 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	 * supposed to hold locks serializing us with truncate / punch hole so
 	 * this is a reliable test.
 	 */
-	pgoff = linear_page_index(vma, pmd_addr);
+	vmf->pgoff = linear_page_index(vma, pmd_addr);
 	max_pgoff = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 
-	trace_dax_pmd_fault(inode, vma, address, flags, pgoff, max_pgoff, 0);
+	trace_dax_pmd_fault(inode, vma, vmf, max_pgoff, 0);
 
 	/* Fall back to PTEs if we're going to COW */
 	if (write && !(vma->vm_flags & VM_SHARED))
@@ -1367,13 +1366,13 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	if ((pmd_addr + PMD_SIZE) > vma->vm_end)
 		goto fallback;
 
-	if (pgoff > max_pgoff) {
+	if (vmf->pgoff > max_pgoff) {
 		result = VM_FAULT_SIGBUS;
 		goto out;
 	}
 
 	/* If the PMD would extend beyond the file size */
-	if ((pgoff | PG_PMD_COLOUR) > max_pgoff)
+	if ((vmf->pgoff | PG_PMD_COLOUR) > max_pgoff)
 		goto fallback;
 
 	/*
@@ -1381,7 +1380,7 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	 * setting up a mapping, so really we're using iomap_begin() as a way
 	 * to look up our filesystem block.
 	 */
-	pos = (loff_t)pgoff << PAGE_SHIFT;
+	pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
 	error = ops->iomap_begin(inode, pos, PMD_SIZE, iomap_flags, &iomap);
 	if (error)
 		goto fallback;
@@ -1395,25 +1394,21 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	 * the tree, for instance), it will return -EEXIST and we just fall
 	 * back to 4k entries.
 	 */
-	entry = grab_mapping_entry(mapping, pgoff, RADIX_DAX_PMD);
+	entry = grab_mapping_entry(mapping, vmf->pgoff, RADIX_DAX_PMD);
 	if (IS_ERR(entry))
 		goto finish_iomap;
 
-	vmf.pgoff = pgoff;
-	vmf.flags = flags;
-	vmf.gfp_mask = mapping_gfp_mask(mapping) | __GFP_IO;
-
 	switch (iomap.type) {
 	case IOMAP_MAPPED:
-		result = dax_pmd_insert_mapping(vma, pmd, &vmf, address,
-				&iomap, pos, write, &entry);
+		result = dax_pmd_insert_mapping(vma, vmf->pmd, vmf,
+				vmf->address, &iomap, pos, write, &entry);
 		break;
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
 		if (WARN_ON_ONCE(write))
 			goto unlock_entry;
-		result = dax_pmd_load_hole(vma, pmd, &vmf, address, &iomap,
-				&entry);
+		result = dax_pmd_load_hole(vma, vmf->pmd, vmf, vmf->address,
+				&iomap, &entry);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -1421,7 +1416,7 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	}
 
  unlock_entry:
-	put_locked_mapping_entry(mapping, pgoff, entry);
+	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
  finish_iomap:
 	if (ops->iomap_end) {
 		int copied = PMD_SIZE;
@@ -1439,12 +1434,11 @@ int dax_iomap_pmd_fault(struct vm_area_s
 	}
  fallback:
 	if (result == VM_FAULT_FALLBACK) {
-		split_huge_pmd(vma, pmd, address);
+		split_huge_pmd(vma, vmf->pmd, vmf->address);
 		count_vm_event(THP_FAULT_FALLBACK);
 	}
 out:
-	trace_dax_pmd_fault_done(inode, vma, address, flags, pgoff, max_pgoff,
-			result);
+	trace_dax_pmd_fault_done(inode, vma, vmf, max_pgoff, result);
 	return result;
 }
 EXPORT_SYMBOL_GPL(dax_iomap_pmd_fault);
diff -puN fs/ext4/file.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault fs/ext4/file.c
--- a/fs/ext4/file.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault
+++ a/fs/ext4/file.c
@@ -275,21 +275,20 @@ static int ext4_dax_fault(struct vm_area
 	return result;
 }
 
-static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
-						pmd_t *pmd, unsigned int flags)
+static int
+ext4_dax_pmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	int result;
 	struct inode *inode = file_inode(vma->vm_file);
 	struct super_block *sb = inode->i_sb;
-	bool write = flags & FAULT_FLAG_WRITE;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
 
 	if (write) {
 		sb_start_pagefault(sb);
 		file_update_time(vma->vm_file);
 	}
 	down_read(&EXT4_I(inode)->i_mmap_sem);
-	result = dax_iomap_pmd_fault(vma, addr, pmd, flags,
-				     &ext4_iomap_ops);
+	result = dax_iomap_pmd_fault(vma, vmf, &ext4_iomap_ops);
 	up_read(&EXT4_I(inode)->i_mmap_sem);
 	if (write)
 		sb_end_pagefault(sb);
diff -puN fs/xfs/xfs_file.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault
+++ a/fs/xfs/xfs_file.c
@@ -1432,9 +1432,7 @@ xfs_filemap_fault(
 STATIC int
 xfs_filemap_pmd_fault(
 	struct vm_area_struct	*vma,
-	unsigned long		addr,
-	pmd_t			*pmd,
-	unsigned int		flags)
+	struct vm_fault		*vmf)
 {
 	struct inode		*inode = file_inode(vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -1445,16 +1443,16 @@ xfs_filemap_pmd_fault(
 
 	trace_xfs_filemap_pmd_fault(ip);
 
-	if (flags & FAULT_FLAG_WRITE) {
+	if (vmf->flags & FAULT_FLAG_WRITE) {
 		sb_start_pagefault(inode->i_sb);
 		file_update_time(vma->vm_file);
 	}
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	ret = dax_iomap_pmd_fault(vma, addr, pmd, flags, &xfs_iomap_ops);
+	ret = dax_iomap_pmd_fault(vma, vmf, &xfs_iomap_ops);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
-	if (flags & FAULT_FLAG_WRITE)
+	if (vmf->flags & FAULT_FLAG_WRITE)
 		sb_end_pagefault(inode->i_sb);
 
 	return ret;
diff -puN include/linux/dax.h~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault include/linux/dax.h
--- a/include/linux/dax.h~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault
+++ a/include/linux/dax.h
@@ -71,16 +71,15 @@ static inline unsigned int dax_radix_ord
 		return PMD_SHIFT - PAGE_SHIFT;
 	return 0;
 }
-int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
-		pmd_t *pmd, unsigned int flags, struct iomap_ops *ops);
+int dax_iomap_pmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+		struct iomap_ops *ops);
 #else
 static inline unsigned int dax_radix_order(void *entry)
 {
 	return 0;
 }
 static inline int dax_iomap_pmd_fault(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags,
-		struct iomap_ops *ops)
+		struct vm_fault *vmf, struct iomap_ops *ops)
 {
 	return VM_FAULT_FALLBACK;
 }
diff -puN include/linux/mm.h~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault include/linux/mm.h
--- a/include/linux/mm.h~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault
+++ a/include/linux/mm.h
@@ -347,8 +347,7 @@ struct vm_operations_struct {
 	void (*close)(struct vm_area_struct * area);
 	int (*mremap)(struct vm_area_struct * area);
 	int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf);
-	int (*pmd_fault)(struct vm_area_struct *, unsigned long address,
-						pmd_t *, unsigned int flags);
+	int (*pmd_fault)(struct vm_area_struct *vma, struct vm_fault *vmf);
 	void (*map_pages)(struct vm_fault *vmf,
 			pgoff_t start_pgoff, pgoff_t end_pgoff);
 
diff -puN include/trace/events/fs_dax.h~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault include/trace/events/fs_dax.h
--- a/include/trace/events/fs_dax.h~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault
+++ a/include/trace/events/fs_dax.h
@@ -8,9 +8,8 @@
 
 DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 	TP_PROTO(struct inode *inode, struct vm_area_struct *vma,
-		unsigned long address, unsigned int flags, pgoff_t pgoff,
-		pgoff_t max_pgoff, int result),
-	TP_ARGS(inode, vma, address, flags, pgoff, max_pgoff, result),
+		struct vm_fault *vmf, pgoff_t max_pgoff, int result),
+	TP_ARGS(inode, vma, vmf, max_pgoff, result),
 	TP_STRUCT__entry(
 		__field(unsigned long, ino)
 		__field(unsigned long, vm_start)
@@ -29,9 +28,9 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 		__entry->vm_start = vma->vm_start;
 		__entry->vm_end = vma->vm_end;
 		__entry->vm_flags = vma->vm_flags;
-		__entry->address = address;
-		__entry->flags = flags;
-		__entry->pgoff = pgoff;
+		__entry->address = vmf->address;
+		__entry->flags = vmf->flags;
+		__entry->pgoff = vmf->pgoff;
 		__entry->max_pgoff = max_pgoff;
 		__entry->result = result;
 	),
@@ -54,9 +53,9 @@ DECLARE_EVENT_CLASS(dax_pmd_fault_class,
 #define DEFINE_PMD_FAULT_EVENT(name) \
 DEFINE_EVENT(dax_pmd_fault_class, name, \
 	TP_PROTO(struct inode *inode, struct vm_area_struct *vma, \
-		unsigned long address, unsigned int flags, pgoff_t pgoff, \
+		struct vm_fault *vmf, \
 		pgoff_t max_pgoff, int result), \
-	TP_ARGS(inode, vma, address, flags, pgoff, max_pgoff, result))
+	TP_ARGS(inode, vma, vmf, max_pgoff, result))
 
 DEFINE_PMD_FAULT_EVENT(dax_pmd_fault);
 DEFINE_PMD_FAULT_EVENT(dax_pmd_fault_done);
diff -puN mm/memory.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault mm/memory.c
--- a/mm/memory.c~mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault
+++ a/mm/memory.c
@@ -3475,8 +3475,7 @@ static int create_huge_pmd(struct vm_fau
 	if (vma_is_anonymous(vma))
 		return do_huge_pmd_anonymous_page(vmf);
 	if (vma->vm_ops->pmd_fault)
-		return vma->vm_ops->pmd_fault(vma, vmf->address, vmf->pmd,
-				vmf->flags);
+		return vma->vm_ops->pmd_fault(vma, vmf);
 	return VM_FAULT_FALLBACK;
 }
 
@@ -3485,8 +3484,7 @@ static int wp_huge_pmd(struct vm_fault *
 	if (vma_is_anonymous(vmf->vma))
 		return do_huge_pmd_wp_page(vmf, orig_pmd);
 	if (vmf->vma->vm_ops->pmd_fault)
-		return vmf->vma->vm_ops->pmd_fault(vmf->vma, vmf->address,
-						   vmf->pmd, vmf->flags);
+		return vmf->vma->vm_ops->pmd_fault(vmf->vma, vmf);
 
 	/* COW handled on pte level: split pmd */
 	VM_BUG_ON_VMA(vmf->vma->vm_flags & VM_SHARED, vmf->vma);
_

Patches currently in -mm which might be from dave.jiang@intel.com are

mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault.patch
mm-dax-move-pmd_fault-to-take-only-vmf-parameter.patch

