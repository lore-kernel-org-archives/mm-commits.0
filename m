From: akpm@linux-foundation.org
Subject: [patch 032/124] mm: replace FAULT_FLAG_SIZE with parameter to
 huge_fault
Date: Fri, 24 Feb 2017 14:57:08 -0800
Message-ID: <58b0ba44.wffWJNyIsy5eAxe7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37990 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbdBXW5K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:57:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dave.jiang@intel.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, hpa@zytor.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mingo@elte.hu, nilesh.choudhury@oracle.com, ross.zwisler@linux.intel.com, tglx@linutronix.de, vbabka@suse.cz

From: Dave Jiang <dave.jiang@intel.com>
Subject: mm: replace FAULT_FLAG_SIZE with parameter to huge_fault

Since the introduction of FAULT_FLAG_SIZE to the vm_fault flag, it has
been somewhat painful with getting the flags set and removed at the
correct locations.  More than one kernel oops was introduced due to
difficulties of getting the placement correctly.

Remove the flag values and introduce an input parameter to huge_fault that
indicates the size of the page entry.  This makes the code easier to trace
and should avoid the issues we see with the fault flags where removal of
the flag was necessary in the fallback paths.

Link: http://lkml.kernel.org/r/148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Nilesh Choudhury <nilesh.choudhury@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/dax.c   |   18 ++++++++++++------
 fs/dax.c            |    9 +++++----
 fs/ext2/file.c      |    2 +-
 fs/ext4/file.c      |   12 +++++++++---
 fs/xfs/xfs_file.c   |    9 +++++----
 include/linux/dax.h |    3 ++-
 include/linux/mm.h  |   14 ++++++++------
 mm/memory.c         |   17 ++++-------------
 8 files changed, 46 insertions(+), 38 deletions(-)

diff -puN drivers/dax/dax.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault drivers/dax/dax.c
--- a/drivers/dax/dax.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault
+++ a/drivers/dax/dax.c
@@ -538,7 +538,8 @@ static int __dax_dev_pud_fault(struct da
 }
 #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
-static int dax_dev_fault(struct vm_fault *vmf)
+static int dax_dev_huge_fault(struct vm_fault *vmf,
+		enum page_entry_size pe_size)
 {
 	int rc;
 	struct file *filp = vmf->vma->vm_file;
@@ -550,14 +551,14 @@ static int dax_dev_fault(struct vm_fault
 			vmf->vma->vm_start, vmf->vma->vm_end);
 
 	rcu_read_lock();
-	switch (vmf->flags & FAULT_FLAG_SIZE_MASK) {
-	case FAULT_FLAG_SIZE_PTE:
+	switch (pe_size) {
+	case PE_SIZE_PTE:
 		rc = __dax_dev_pte_fault(dax_dev, vmf);
 		break;
-	case FAULT_FLAG_SIZE_PMD:
+	case PE_SIZE_PMD:
 		rc = __dax_dev_pmd_fault(dax_dev, vmf);
 		break;
-	case FAULT_FLAG_SIZE_PUD:
+	case PE_SIZE_PUD:
 		rc = __dax_dev_pud_fault(dax_dev, vmf);
 		break;
 	default:
@@ -568,9 +569,14 @@ static int dax_dev_fault(struct vm_fault
 	return rc;
 }
 
+static int dax_dev_fault(struct vm_fault *vmf)
+{
+	return dax_dev_huge_fault(vmf, PE_SIZE_PTE);
+}
+
 static const struct vm_operations_struct dax_dev_vm_ops = {
 	.fault = dax_dev_fault,
-	.huge_fault = dax_dev_fault,
+	.huge_fault = dax_dev_huge_fault,
 };
 
 static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
diff -puN fs/dax.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault fs/dax.c
--- a/fs/dax.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault
+++ a/fs/dax.c
@@ -1452,12 +1452,13 @@ static int dax_iomap_pmd_fault(struct vm
  * has done all the necessary locking for page fault to proceed
  * successfully.
  */
-int dax_iomap_fault(struct vm_fault *vmf, const struct iomap_ops *ops)
+int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
+		    const struct iomap_ops *ops)
 {
-	switch (vmf->flags & FAULT_FLAG_SIZE_MASK) {
-	case FAULT_FLAG_SIZE_PTE:
+	switch (pe_size) {
+	case PE_SIZE_PTE:
 		return dax_iomap_pte_fault(vmf, ops);
-	case FAULT_FLAG_SIZE_PMD:
+	case PE_SIZE_PMD:
 		return dax_iomap_pmd_fault(vmf, ops);
 	default:
 		return VM_FAULT_FALLBACK;
diff -puN fs/ext2/file.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault fs/ext2/file.c
--- a/fs/ext2/file.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault
+++ a/fs/ext2/file.c
@@ -99,7 +99,7 @@ static int ext2_dax_fault(struct vm_faul
 	}
 	down_read(&ei->dax_sem);
 
-	ret = dax_iomap_fault(vmf, &ext2_iomap_ops);
+	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &ext2_iomap_ops);
 
 	up_read(&ei->dax_sem);
 	if (vmf->flags & FAULT_FLAG_WRITE)
diff -puN fs/ext4/file.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault fs/ext4/file.c
--- a/fs/ext4/file.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault
+++ a/fs/ext4/file.c
@@ -253,7 +253,8 @@ out:
 }
 
 #ifdef CONFIG_FS_DAX
-static int ext4_dax_fault(struct vm_fault *vmf)
+static int ext4_dax_huge_fault(struct vm_fault *vmf,
+		enum page_entry_size pe_size)
 {
 	int result;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
@@ -265,7 +266,7 @@ static int ext4_dax_fault(struct vm_faul
 		file_update_time(vmf->vma->vm_file);
 	}
 	down_read(&EXT4_I(inode)->i_mmap_sem);
-	result = dax_iomap_fault(vmf, &ext4_iomap_ops);
+	result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops);
 	up_read(&EXT4_I(inode)->i_mmap_sem);
 	if (write)
 		sb_end_pagefault(sb);
@@ -273,6 +274,11 @@ static int ext4_dax_fault(struct vm_faul
 	return result;
 }
 
+static int ext4_dax_fault(struct vm_fault *vmf)
+{
+	return ext4_dax_huge_fault(vmf, PE_SIZE_PTE);
+}
+
 /*
  * Handle write fault for VM_MIXEDMAP mappings. Similarly to ext4_dax_fault()
  * handler we check for races agaist truncate. Note that since we cycle through
@@ -305,7 +311,7 @@ static int ext4_dax_pfn_mkwrite(struct v
 
 static const struct vm_operations_struct ext4_dax_vm_ops = {
 	.fault		= ext4_dax_fault,
-	.huge_fault	= ext4_dax_fault,
+	.huge_fault	= ext4_dax_huge_fault,
 	.page_mkwrite	= ext4_dax_fault,
 	.pfn_mkwrite	= ext4_dax_pfn_mkwrite,
 };
diff -puN fs/xfs/xfs_file.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault
+++ a/fs/xfs/xfs_file.c
@@ -1391,7 +1391,7 @@ xfs_filemap_page_mkwrite(
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (IS_DAX(inode)) {
-		ret = dax_iomap_fault(vmf, &xfs_iomap_ops);
+		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops);
 	} else {
 		ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
 		ret = block_page_mkwrite_return(ret);
@@ -1418,7 +1418,7 @@ xfs_filemap_fault(
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	if (IS_DAX(inode))
-		ret = dax_iomap_fault(vmf, &xfs_iomap_ops);
+		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops);
 	else
 		ret = filemap_fault(vmf);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
@@ -1435,7 +1435,8 @@ xfs_filemap_fault(
  */
 STATIC int
 xfs_filemap_huge_fault(
-	struct vm_fault		*vmf)
+	struct vm_fault		*vmf,
+	enum page_entry_size	pe_size)
 {
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -1452,7 +1453,7 @@ xfs_filemap_huge_fault(
 	}
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	ret = dax_iomap_fault(vmf, &xfs_iomap_ops);
+	ret = dax_iomap_fault(vmf, pe_size, &xfs_iomap_ops);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (vmf->flags & FAULT_FLAG_WRITE)
diff -puN include/linux/dax.h~mm-replace-fault_flag_size-with-parameter-to-huge_fault include/linux/dax.h
--- a/include/linux/dax.h~mm-replace-fault_flag_size-with-parameter-to-huge_fault
+++ a/include/linux/dax.h
@@ -38,7 +38,8 @@ static inline void *dax_radix_locked_ent
 
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);
-int dax_iomap_fault(struct vm_fault *vmf, const struct iomap_ops *ops);
+int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
+		    const struct iomap_ops *ops);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
diff -puN include/linux/mm.h~mm-replace-fault_flag_size-with-parameter-to-huge_fault include/linux/mm.h
--- a/include/linux/mm.h~mm-replace-fault_flag_size-with-parameter-to-huge_fault
+++ a/include/linux/mm.h
@@ -285,11 +285,6 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_REMOTE	0x80	/* faulting for non current tsk/mm */
 #define FAULT_FLAG_INSTRUCTION  0x100	/* The fault was during an instruction fetch */
 
-#define FAULT_FLAG_SIZE_MASK	0x7000	/* Support up to 8-level page tables */
-#define FAULT_FLAG_SIZE_PTE	0x0000	/* First level (eg 4k) */
-#define FAULT_FLAG_SIZE_PMD	0x1000	/* Second level (eg 2MB) */
-#define FAULT_FLAG_SIZE_PUD	0x2000	/* Third level (eg 1GB) */
-
 #define FAULT_FLAG_TRACE \
 	{ FAULT_FLAG_WRITE,		"WRITE" }, \
 	{ FAULT_FLAG_MKWRITE,		"MKWRITE" }, \
@@ -349,6 +344,13 @@ struct vm_fault {
 					 */
 };
 
+/* page entry size for vm->huge_fault() */
+enum page_entry_size {
+	PE_SIZE_PTE = 0,
+	PE_SIZE_PMD,
+	PE_SIZE_PUD,
+};
+
 /*
  * These are the virtual MM functions - opening of an area, closing and
  * unmapping it (needed to keep files on disk up-to-date etc), pointer
@@ -359,7 +361,7 @@ struct vm_operations_struct {
 	void (*close)(struct vm_area_struct * area);
 	int (*mremap)(struct vm_area_struct * area);
 	int (*fault)(struct vm_fault *vmf);
-	int (*huge_fault)(struct vm_fault *vmf);
+	int (*huge_fault)(struct vm_fault *vmf, enum page_entry_size pe_size);
 	void (*map_pages)(struct vm_fault *vmf,
 			pgoff_t start_pgoff, pgoff_t end_pgoff);
 
diff -puN mm/memory.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault mm/memory.c
--- a/mm/memory.c~mm-replace-fault_flag_size-with-parameter-to-huge_fault
+++ a/mm/memory.c
@@ -3489,7 +3489,7 @@ static int create_huge_pmd(struct vm_fau
 	if (vma_is_anonymous(vmf->vma))
 		return do_huge_pmd_anonymous_page(vmf);
 	if (vmf->vma->vm_ops->huge_fault)
-		return vmf->vma->vm_ops->huge_fault(vmf);
+		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
 	return VM_FAULT_FALLBACK;
 }
 
@@ -3498,7 +3498,7 @@ static int wp_huge_pmd(struct vm_fault *
 	if (vma_is_anonymous(vmf->vma))
 		return do_huge_pmd_wp_page(vmf, orig_pmd);
 	if (vmf->vma->vm_ops->huge_fault)
-		return vmf->vma->vm_ops->huge_fault(vmf);
+		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
 
 	/* COW handled on pte level: split pmd */
 	VM_BUG_ON_VMA(vmf->vma->vm_flags & VM_SHARED, vmf->vma);
@@ -3519,7 +3519,7 @@ static int create_huge_pud(struct vm_fau
 	if (vma_is_anonymous(vmf->vma))
 		return VM_FAULT_FALLBACK;
 	if (vmf->vma->vm_ops->huge_fault)
-		return vmf->vma->vm_ops->huge_fault(vmf);
+		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 	return VM_FAULT_FALLBACK;
 }
@@ -3531,7 +3531,7 @@ static int wp_huge_pud(struct vm_fault *
 	if (vma_is_anonymous(vmf->vma))
 		return VM_FAULT_FALLBACK;
 	if (vmf->vma->vm_ops->huge_fault)
-		return vmf->vma->vm_ops->huge_fault(vmf);
+		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 	return VM_FAULT_FALLBACK;
 }
@@ -3659,7 +3659,6 @@ static int __handle_mm_fault(struct vm_a
 	if (!vmf.pud)
 		return VM_FAULT_OOM;
 	if (pud_none(*vmf.pud) && transparent_hugepage_enabled(vma)) {
-		vmf.flags |= FAULT_FLAG_SIZE_PUD;
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -3670,8 +3669,6 @@ static int __handle_mm_fault(struct vm_a
 		if (pud_trans_huge(orig_pud) || pud_devmap(orig_pud)) {
 			unsigned int dirty = flags & FAULT_FLAG_WRITE;
 
-			vmf.flags |= FAULT_FLAG_SIZE_PUD;
-
 			/* NUMA case for anonymous PUDs would go here */
 
 			if (dirty && !pud_write(orig_pud)) {
@@ -3689,18 +3686,14 @@ static int __handle_mm_fault(struct vm_a
 	if (!vmf.pmd)
 		return VM_FAULT_OOM;
 	if (pmd_none(*vmf.pmd) && transparent_hugepage_enabled(vma)) {
-		vmf.flags |= FAULT_FLAG_SIZE_PMD;
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
-		/* fall through path, remove PMD flag */
-		vmf.flags &= ~FAULT_FLAG_SIZE_PMD;
 	} else {
 		pmd_t orig_pmd = *vmf.pmd;
 
 		barrier();
 		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
-			vmf.flags |= FAULT_FLAG_SIZE_PMD;
 			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
 				return do_huge_pmd_numa_page(&vmf, orig_pmd);
 
@@ -3709,8 +3702,6 @@ static int __handle_mm_fault(struct vm_a
 				ret = wp_huge_pmd(&vmf, orig_pmd);
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
-				/* fall through path, remove PUD flag */
-				vmf.flags &= ~FAULT_FLAG_SIZE_PUD;
 			} else {
 				huge_pmd_set_accessed(&vmf, orig_pmd);
 				return 0;
_
