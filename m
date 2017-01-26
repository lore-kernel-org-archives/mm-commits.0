From: akpm@linux-foundation.org
Subject: + mmfsdax-change-pmd_fault-to-huge_fault.patch added to -mm tree
Date: Thu, 26 Jan 2017 14:36:53 -0800
Message-ID: <588a7a05.Z/VyYvGR4656dARj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752067AbdAZWiJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2017 17:38:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.jiang@intel.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, hpa@zytor.com, jack@suse.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mingo@elte.hu, nilesh.choudhury@oracle.com, ross.zwisler@linux.intel.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,fs,dax: change ->pmd_fault to ->huge_fault
has been added to the -mm tree.  Its filename is
     mmfsdax-change-pmd_fault-to-huge_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmfsdax-change-pmd_fault-to-huge_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmfsdax-change-pmd_fault-to-huge_fault.patch

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
Subject: mm,fs,dax: change ->pmd_fault to ->huge_fault

Patch series "1G transparent hugepage support for device dax", v2.

The following series implements support for 1G trasparent hugepage on x86
for device dax.  The bulk of the code was written by Mathew Wilcox a while
back supporting transparent 1G hugepage for fs DAX.  I have forward ported
the relevant bits to 4.10-rc.  The current submission has only the
necessary code to support device DAX.

Comments from Dan Williams: So the motivation and intended user of this
functionality mirrors the motivation and users of 1GB page support in
hugetlbfs.  Given expected capacities of persistent memory devices an
in-memory database may want to reduce tlb pressure beyond what they can
already achieve with 2MB mappings of a device-dax file.  We have customer
feedback to that effect as Willy mentioned in his previous version of
these patches [1].

[1]: https://lkml.org/lkml/2016/1/31/52


Comments from Nilesh @ Oracle:

There are applications which have a process model; and if you assume
10,000 processes attempting to mmap all the 6TB memory available on a
server; we are looking at the following:

processes         : 10,000
memory            :    6TB
pte @ 4k page size: 8 bytes / 4K of memory * #processes = 6TB / 4k * 8 * 10000 = 1.5GB * 80000 = 120,000GB
pmd @ 2M page size: 120,000 / 512 = ~240GB
pud @ 1G page size: 240GB / 512 = ~480MB

As you can see with 2M pages, this system will use up an exorbitant amount
of DRAM to hold the page tables; but the 1G pages finally brings it down
to a reasonable level.  Memory sizes will keep increasing; so this number
will keep increasing.

An argument can be made to convert the applications from process model to
thread model, but in the real world that may not be always practical. 
Hopefully this helps explain the use case where this is valuable.


This patch (of 3):

In preparation for adding the ability to handle PUD pages, convert
vm_operations_struct.pmd_fault to vm_operations_struct.huge_fault.  The
vm_fault structure is extended to include a union of the different page
table pointers that may be needed, and three flag bits are reserved to
indicate which type of pointer is in the union.

Link: http://lkml.kernel.org/r/148545058784.17912.6353162518188733642.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Nilesh Choudhury <nilesh.choudhury@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/dax.c   |   34 ++++++++++++---------------------
 fs/dax.c            |   43 +++++++++++++++++++++++++++++-------------
 fs/ext2/file.c      |    2 -
 fs/ext4/file.c      |    6 ++---
 fs/xfs/xfs_file.c   |   10 ++++-----
 fs/xfs/xfs_trace.h  |    2 -
 include/linux/dax.h |    6 -----
 include/linux/mm.h  |   10 ++++++++-
 mm/memory.c         |   14 +++++++------
 9 files changed, 70 insertions(+), 57 deletions(-)

diff -puN drivers/dax/dax.c~mmfsdax-change-pmd_fault-to-huge_fault drivers/dax/dax.c
--- a/drivers/dax/dax.c~mmfsdax-change-pmd_fault-to-huge_fault
+++ a/drivers/dax/dax.c
@@ -419,7 +419,7 @@ static phys_addr_t pgoff_to_phys(struct
 	return -1;
 }
 
-static int __dax_dev_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
+static int __dax_dev_pte_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 {
 	struct device *dev = &dax_dev->dev;
 	struct dax_region *dax_region;
@@ -455,23 +455,6 @@ static int __dax_dev_fault(struct dax_de
 	return VM_FAULT_NOPAGE;
 }
 
-static int dax_dev_fault(struct vm_fault *vmf)
-{
-	struct vm_area_struct *vma = vmf->vma;
-	int rc;
-	struct file *filp = vma->vm_file;
-	struct dax_dev *dax_dev = filp->private_data;
-
-	dev_dbg(&dax_dev->dev, "%s: %s: %s (%#lx - %#lx)\n", __func__,
-			current->comm, (vmf->flags & FAULT_FLAG_WRITE)
-			? "write" : "read", vma->vm_start, vma->vm_end);
-	rcu_read_lock();
-	rc = __dax_dev_fault(dax_dev, vmf);
-	rcu_read_unlock();
-
-	return rc;
-}
-
 static int __dax_dev_pmd_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 {
 	unsigned long pmd_addr = vmf->address & PMD_MASK;
@@ -510,7 +493,7 @@ static int __dax_dev_pmd_fault(struct da
 			vmf->flags & FAULT_FLAG_WRITE);
 }
 
-static int dax_dev_pmd_fault(struct vm_fault *vmf)
+static int dax_dev_fault(struct vm_fault *vmf)
 {
 	int rc;
 	struct file *filp = vmf->vma->vm_file;
@@ -522,7 +505,16 @@ static int dax_dev_pmd_fault(struct vm_f
 			vmf->vma->vm_start, vmf->vma->vm_end);
 
 	rcu_read_lock();
-	rc = __dax_dev_pmd_fault(dax_dev, vmf);
+	switch (vmf->flags & FAULT_FLAG_SIZE_MASK) {
+	case FAULT_FLAG_SIZE_PTE:
+		rc = __dax_dev_pte_fault(dax_dev, vmf);
+		break;
+	case FAULT_FLAG_SIZE_PMD:
+		rc = __dax_dev_pmd_fault(dax_dev, vmf);
+		break;
+	default:
+		return VM_FAULT_FALLBACK;
+	}
 	rcu_read_unlock();
 
 	return rc;
@@ -530,7 +522,7 @@ static int dax_dev_pmd_fault(struct vm_f
 
 static const struct vm_operations_struct dax_dev_vm_ops = {
 	.fault = dax_dev_fault,
-	.pmd_fault = dax_dev_pmd_fault,
+	.huge_fault = dax_dev_fault,
 };
 
 static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
diff -puN fs/dax.c~mmfsdax-change-pmd_fault-to-huge_fault fs/dax.c
--- a/fs/dax.c~mmfsdax-change-pmd_fault-to-huge_fault
+++ a/fs/dax.c
@@ -1109,16 +1109,7 @@ static int dax_fault_return(int error)
 	return VM_FAULT_SIGBUS;
 }
 
-/**
- * dax_iomap_fault - handle a page fault on a DAX file
- * @vmf: The description of the fault
- * @ops: iomap ops passed from the file system
- *
- * When a page fault occurs, filesystems may call this helper in their fault
- * or mkwrite handler for DAX files. Assumes the caller has done all the
- * necessary locking for the page fault to proceed successfully.
- */
-int dax_iomap_fault(struct vm_fault *vmf, struct iomap_ops *ops)
+static int dax_iomap_pte_fault(struct vm_fault *vmf, struct iomap_ops *ops)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
@@ -1235,7 +1226,6 @@ int dax_iomap_fault(struct vm_fault *vmf
 	}
 	return vmf_ret;
 }
-EXPORT_SYMBOL_GPL(dax_iomap_fault);
 
 #ifdef CONFIG_FS_DAX_PMD
 /*
@@ -1326,7 +1316,7 @@ fallback:
 	return VM_FAULT_FALLBACK;
 }
 
-int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
+static int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct address_space *mapping = vma->vm_file->f_mapping;
@@ -1434,5 +1424,32 @@ out:
 	trace_dax_pmd_fault_done(inode, vmf, max_pgoff, result);
 	return result;
 }
-EXPORT_SYMBOL_GPL(dax_iomap_pmd_fault);
+#else
+static int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
+{
+	return VM_FAULT_FALLBACK;
+}
 #endif /* CONFIG_FS_DAX_PMD */
+
+/**
+ * dax_iomap_fault - handle a page fault on a DAX file
+ * @vmf: The description of the fault
+ * @ops: iomap ops passed from the file system
+ *
+ * When a page fault occurs, filesystems may call this helper in
+ * their fault handler for DAX files. dax_iomap_fault() assumes the caller
+ * has done all the necessary locking for page fault to proceed
+ * successfully.
+ */
+int dax_iomap_fault(struct vm_fault *vmf, struct iomap_ops *ops)
+{
+	switch (vmf->flags & FAULT_FLAG_SIZE_MASK) {
+	case FAULT_FLAG_SIZE_PTE:
+		return dax_iomap_pte_fault(vmf, ops);
+	case FAULT_FLAG_SIZE_PMD:
+		return dax_iomap_pmd_fault(vmf, ops);
+	default:
+		return VM_FAULT_FALLBACK;
+	}
+}
+EXPORT_SYMBOL_GPL(dax_iomap_fault);
diff -puN fs/ext2/file.c~mmfsdax-change-pmd_fault-to-huge_fault fs/ext2/file.c
--- a/fs/ext2/file.c~mmfsdax-change-pmd_fault-to-huge_fault
+++ a/fs/ext2/file.c
@@ -133,7 +133,7 @@ static int ext2_dax_pfn_mkwrite(struct v
 static const struct vm_operations_struct ext2_dax_vm_ops = {
 	.fault		= ext2_dax_fault,
 	/*
-	 * .pmd_fault is not supported for DAX because allocation in ext2
+	 * .huge_fault is not supported for DAX because allocation in ext2
 	 * cannot be reliably aligned to huge page sizes and so pmd faults
 	 * will always fail and fail back to regular faults.
 	 */
diff -puN fs/ext4/file.c~mmfsdax-change-pmd_fault-to-huge_fault fs/ext4/file.c
--- a/fs/ext4/file.c~mmfsdax-change-pmd_fault-to-huge_fault
+++ a/fs/ext4/file.c
@@ -276,7 +276,7 @@ static int ext4_dax_fault(struct vm_faul
 }
 
 static int
-ext4_dax_pmd_fault(struct vm_fault *vmf)
+ext4_dax_huge_fault(struct vm_fault *vmf)
 {
 	int result;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
@@ -288,7 +288,7 @@ ext4_dax_pmd_fault(struct vm_fault *vmf)
 		file_update_time(vmf->vma->vm_file);
 	}
 	down_read(&EXT4_I(inode)->i_mmap_sem);
-	result = dax_iomap_pmd_fault(vmf, &ext4_iomap_ops);
+	result = dax_iomap_fault(vmf, &ext4_iomap_ops);
 	up_read(&EXT4_I(inode)->i_mmap_sem);
 	if (write)
 		sb_end_pagefault(sb);
@@ -328,7 +328,7 @@ static int ext4_dax_pfn_mkwrite(struct v
 
 static const struct vm_operations_struct ext4_dax_vm_ops = {
 	.fault		= ext4_dax_fault,
-	.pmd_fault	= ext4_dax_pmd_fault,
+	.huge_fault	= ext4_dax_fault,
 	.page_mkwrite	= ext4_dax_fault,
 	.pfn_mkwrite	= ext4_dax_pfn_mkwrite,
 };
diff -puN fs/xfs/xfs_file.c~mmfsdax-change-pmd_fault-to-huge_fault fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~mmfsdax-change-pmd_fault-to-huge_fault
+++ a/fs/xfs/xfs_file.c
@@ -1423,12 +1423,12 @@ xfs_filemap_fault(
 /*
  * Similar to xfs_filemap_fault(), the DAX fault path can call into here on
  * both read and write faults. Hence we need to handle both cases. There is no
- * ->pmd_mkwrite callout for huge pages, so we have a single function here to
+ * ->huge_mkwrite callout for huge pages, so we have a single function here to
  * handle both cases here. @flags carries the information on the type of fault
  * occuring.
  */
 STATIC int
-xfs_filemap_pmd_fault(
+xfs_filemap_huge_fault(
 	struct vm_fault		*vmf)
 {
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
@@ -1438,7 +1438,7 @@ xfs_filemap_pmd_fault(
 	if (!IS_DAX(inode))
 		return VM_FAULT_FALLBACK;
 
-	trace_xfs_filemap_pmd_fault(ip);
+	trace_xfs_filemap_huge_fault(ip);
 
 	if (vmf->flags & FAULT_FLAG_WRITE) {
 		sb_start_pagefault(inode->i_sb);
@@ -1446,7 +1446,7 @@ xfs_filemap_pmd_fault(
 	}
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	ret = dax_iomap_pmd_fault(vmf, &xfs_iomap_ops);
+	ret = dax_iomap_fault(vmf, &xfs_iomap_ops);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (vmf->flags & FAULT_FLAG_WRITE)
@@ -1491,7 +1491,7 @@ xfs_filemap_pfn_mkwrite(
 
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= xfs_filemap_fault,
-	.pmd_fault	= xfs_filemap_pmd_fault,
+	.huge_fault	= xfs_filemap_huge_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= xfs_filemap_page_mkwrite,
 	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
diff -puN fs/xfs/xfs_trace.h~mmfsdax-change-pmd_fault-to-huge_fault fs/xfs/xfs_trace.h
--- a/fs/xfs/xfs_trace.h~mmfsdax-change-pmd_fault-to-huge_fault
+++ a/fs/xfs/xfs_trace.h
@@ -687,7 +687,7 @@ DEFINE_INODE_EVENT(xfs_inode_clear_cowbl
 DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
 
 DEFINE_INODE_EVENT(xfs_filemap_fault);
-DEFINE_INODE_EVENT(xfs_filemap_pmd_fault);
+DEFINE_INODE_EVENT(xfs_filemap_huge_fault);
 DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
 DEFINE_INODE_EVENT(xfs_filemap_pfn_mkwrite);
 
diff -puN include/linux/dax.h~mmfsdax-change-pmd_fault-to-huge_fault include/linux/dax.h
--- a/include/linux/dax.h~mmfsdax-change-pmd_fault-to-huge_fault
+++ a/include/linux/dax.h
@@ -70,17 +70,11 @@ static inline unsigned int dax_radix_ord
 		return PMD_SHIFT - PAGE_SHIFT;
 	return 0;
 }
-int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops);
 #else
 static inline unsigned int dax_radix_order(void *entry)
 {
 	return 0;
 }
-static inline int dax_iomap_pmd_fault(struct vm_fault *vmf,
-		struct iomap_ops *ops)
-{
-	return VM_FAULT_FALLBACK;
-}
 #endif
 int dax_pfn_mkwrite(struct vm_fault *vmf);
 
diff -puN include/linux/mm.h~mmfsdax-change-pmd_fault-to-huge_fault include/linux/mm.h
--- a/include/linux/mm.h~mmfsdax-change-pmd_fault-to-huge_fault
+++ a/include/linux/mm.h
@@ -281,6 +281,11 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_REMOTE	0x80	/* faulting for non current tsk/mm */
 #define FAULT_FLAG_INSTRUCTION  0x100	/* The fault was during an instruction fetch */
 
+#define FAULT_FLAG_SIZE_MASK	0x700	/* Support up to 8-level page tables */
+#define FAULT_FLAG_SIZE_PTE	0x000	/* First level (eg 4k) */
+#define FAULT_FLAG_SIZE_PMD	0x100	/* Second level (eg 2MB) */
+#define FAULT_FLAG_SIZE_PUD	0x200	/* Third level (eg 1GB) */
+
 #define FAULT_FLAG_TRACE \
 	{ FAULT_FLAG_WRITE,		"WRITE" }, \
 	{ FAULT_FLAG_MKWRITE,		"MKWRITE" }, \
@@ -310,6 +315,9 @@ struct vm_fault {
 	unsigned long address;		/* Faulting virtual address */
 	pmd_t *pmd;			/* Pointer to pmd entry matching
 					 * the 'address' */
+	pud_t *pud;			/* Pointer to pud entry matching
+					 * the 'address'
+					 */
 	pte_t orig_pte;			/* Value of PTE at the time of fault */
 
 	struct page *cow_page;		/* Page handler may use for COW fault */
@@ -347,7 +355,7 @@ struct vm_operations_struct {
 	void (*close)(struct vm_area_struct * area);
 	int (*mremap)(struct vm_area_struct * area);
 	int (*fault)(struct vm_fault *vmf);
-	int (*pmd_fault)(struct vm_fault *vmf);
+	int (*huge_fault)(struct vm_fault *vmf);
 	void (*map_pages)(struct vm_fault *vmf,
 			pgoff_t start_pgoff, pgoff_t end_pgoff);
 
diff -puN mm/memory.c~mmfsdax-change-pmd_fault-to-huge_fault mm/memory.c
--- a/mm/memory.c~mmfsdax-change-pmd_fault-to-huge_fault
+++ a/mm/memory.c
@@ -3466,8 +3466,8 @@ static int create_huge_pmd(struct vm_fau
 {
 	if (vma_is_anonymous(vmf->vma))
 		return do_huge_pmd_anonymous_page(vmf);
-	if (vmf->vma->vm_ops->pmd_fault)
-		return vmf->vma->vm_ops->pmd_fault(vmf);
+	if (vmf->vma->vm_ops->huge_fault)
+		return vmf->vma->vm_ops->huge_fault(vmf);
 	return VM_FAULT_FALLBACK;
 }
 
@@ -3475,8 +3475,8 @@ static int wp_huge_pmd(struct vm_fault *
 {
 	if (vma_is_anonymous(vmf->vma))
 		return do_huge_pmd_wp_page(vmf, orig_pmd);
-	if (vmf->vma->vm_ops->pmd_fault)
-		return vmf->vma->vm_ops->pmd_fault(vmf);
+	if (vmf->vma->vm_ops->huge_fault)
+		return vmf->vma->vm_ops->huge_fault(vmf);
 
 	/* COW handled on pte level: split pmd */
 	VM_BUG_ON_VMA(vmf->vma->vm_flags & VM_SHARED, vmf->vma);
@@ -3606,6 +3606,7 @@ static int __handle_mm_fault(struct vm_a
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
 	pud_t *pud;
+	int ret;
 
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
@@ -3615,15 +3616,16 @@ static int __handle_mm_fault(struct vm_a
 	if (!vmf.pmd)
 		return VM_FAULT_OOM;
 	if (pmd_none(*vmf.pmd) && transparent_hugepage_enabled(vma)) {
-		int ret = create_huge_pmd(&vmf);
+		vmf.flags |= FAULT_FLAG_SIZE_PMD;
+		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
 	} else {
 		pmd_t orig_pmd = *vmf.pmd;
-		int ret;
 
 		barrier();
 		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
+			vmf.flags |= FAULT_FLAG_SIZE_PMD;
 			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
 				return do_huge_pmd_numa_page(&vmf, orig_pmd);
 
_

Patches currently in -mm which might be from dave.jiang@intel.com are

mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault.patch
mm-dax-make-pmd_fault-and-friends-to-be-the-same-as-fault-v7.patch
mm-dax-move-pmd_fault-to-take-only-vmf-parameter.patch
mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
dax-support-for-transparent-pud-pages-for-device-dax.patch

