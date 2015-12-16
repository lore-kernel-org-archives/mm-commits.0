From: akpm@linux-foundation.org
Subject: + dax-provide-diagnostics-for-pmd-mapping-failures.patch added to -mm tree
Date: Tue, 15 Dec 2015 16:17:22 -0800
Message-ID: <5670ad92.xJrMvSsM7o4lmT/m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbbLPARX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:17:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: provide diagnostics for pmd mapping failures
has been added to the -mm tree.  Its filename is
     dax-provide-diagnostics-for-pmd-mapping-failures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-provide-diagnostics-for-pmd-mapping-failures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-provide-diagnostics-for-pmd-mapping-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dax: provide diagnostics for pmd mapping failures

There is a wide gamut of conditions that can trigger the dax pmd path to
fallback to pte mappings.  Ideally we'd have a syscall interface to
determine mapping characteristics after the fact.  In the meantime provide
debug messages.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   57 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 9 deletions(-)

diff -puN fs/dax.c~dax-provide-diagnostics-for-pmd-mapping-failures fs/dax.c
--- a/fs/dax.c~dax-provide-diagnostics-for-pmd-mapping-failures
+++ a/fs/dax.c
@@ -557,6 +557,14 @@ EXPORT_SYMBOL_GPL(dax_fault);
  */
 #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
 
+static void dax_pmd_dbg(struct block_device *bdev, unsigned long address,
+		const char *reason)
+{
+	pr_debug("%s%s dax_pmd: %s addr: %lx fallback: %s\n", bdev
+			? dev_name(part_to_dev(bdev->bd_part)) : "", bdev
+			? ": " : "", current->comm, address, reason);
+}
+
 int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		pmd_t *pmd, unsigned int flags, get_block_t get_block,
 		dax_iodone_t complete_unwritten)
@@ -568,7 +576,7 @@ int __dax_pmd_fault(struct vm_area_struc
 	unsigned blkbits = inode->i_blkbits;
 	unsigned long pmd_addr = address & PMD_MASK;
 	bool write = flags & FAULT_FLAG_WRITE;
-	struct block_device *bdev;
+	struct block_device *bdev = NULL;
 	pgoff_t size, pgoff;
 	sector_t block;
 	int result = 0;
@@ -580,21 +588,29 @@ int __dax_pmd_fault(struct vm_area_struc
 	/* Fall back to PTEs if we're going to COW */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		split_huge_pmd(vma, pmd, address);
+		dax_pmd_dbg(bdev, address, "cow write");
 		return VM_FAULT_FALLBACK;
 	}
 	/* If the PMD would extend outside the VMA */
-	if (pmd_addr < vma->vm_start)
+	if (pmd_addr < vma->vm_start) {
+		dax_pmd_dbg(bdev, address, "vma start unaligned");
 		return VM_FAULT_FALLBACK;
-	if ((pmd_addr + PMD_SIZE) > vma->vm_end)
+	}
+	if ((pmd_addr + PMD_SIZE) > vma->vm_end) {
+		dax_pmd_dbg(bdev, address, "vma end unaligned");
 		return VM_FAULT_FALLBACK;
+	}
 
 	pgoff = linear_page_index(vma, pmd_addr);
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (pgoff >= size)
 		return VM_FAULT_SIGBUS;
 	/* If the PMD would cover blocks out of the file */
-	if ((pgoff | PG_PMD_COLOUR) >= size)
+	if ((pgoff | PG_PMD_COLOUR) >= size) {
+		dax_pmd_dbg(bdev, address,
+				"offset + huge page size > file size");
 		return VM_FAULT_FALLBACK;
+	}
 
 	memset(&bh, 0, sizeof(bh));
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
@@ -610,8 +626,10 @@ int __dax_pmd_fault(struct vm_area_struc
 	 * just fall back to PTEs.  Calling get_block 512 times in a loop
 	 * would be silly.
 	 */
-	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
+	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE) {
+		dax_pmd_dbg(bdev, address, "block allocation size invalid");
 		goto fallback;
+	}
 
 	/*
 	 * If we allocated new storage, make sure no process has any
@@ -634,23 +652,33 @@ int __dax_pmd_fault(struct vm_area_struc
 		result = VM_FAULT_SIGBUS;
 		goto out;
 	}
-	if ((pgoff | PG_PMD_COLOUR) >= size)
+	if ((pgoff | PG_PMD_COLOUR) >= size) {
+		dax_pmd_dbg(bdev, address, "pgoff unaligned");
 		goto fallback;
+	}
 
 	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
 		struct page *zero_page = get_huge_zero_page();
 
-		if (unlikely(!zero_page))
+		if (unlikely(!zero_page)) {
+			dax_pmd_dbg(bdev, address, "no zero page");
 			goto fallback;
+		}
 
 		ptl = pmd_lock(vma->vm_mm, pmd);
 		if (!pmd_none(*pmd)) {
 			spin_unlock(ptl);
+			dax_pmd_dbg(bdev, address, "pmd already present");
 			goto fallback;
 		}
 
+		dev_dbg(part_to_dev(bdev->bd_part),
+				"%s: %s addr: %lx pfn: <zero> sect: %llx\n",
+				__func__, current->comm, address,
+				(unsigned long long) to_sector(&bh, inode));
+
 		entry = mk_pmd(zero_page, vma->vm_page_prot);
 		entry = pmd_mkhuge(entry);
 		set_pmd_at(vma->vm_mm, pmd_addr, pmd, entry);
@@ -667,8 +695,13 @@ int __dax_pmd_fault(struct vm_area_struc
 			result = VM_FAULT_SIGBUS;
 			goto out;
 		}
-		if (length < PMD_SIZE
-				|| (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR)) {
+		if (length < PMD_SIZE) {
+			dax_pmd_dbg(bdev, address, "dax-length too small");
+			dax_unmap_atomic(bdev, &dax);
+			goto fallback;
+		}
+		if (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR) {
+			dax_pmd_dbg(bdev, address, "pfn unaligned");
 			dax_unmap_atomic(bdev, &dax);
 			goto fallback;
 		}
@@ -679,6 +712,7 @@ int __dax_pmd_fault(struct vm_area_struc
 		 */
 		if (pfn_t_has_page(dax.pfn)) {
 			dax_unmap_atomic(bdev, &dax);
+			dax_pmd_dbg(bdev, address, "pfn not in memmap");
 			goto fallback;
 		}
 
@@ -691,6 +725,11 @@ int __dax_pmd_fault(struct vm_area_struc
 		}
 		dax_unmap_atomic(bdev, &dax);
 
+		dev_dbg(part_to_dev(bdev->bd_part),
+				"%s: %s addr: %lx pfn: %lx sect: %llx\n",
+				__func__, current->comm, address,
+				pfn_t_to_pfn(dax.pfn),
+				(unsigned long long) dax.sector);
 		result |= vmf_insert_pfn_pmd(vma, address, pmd,
 				dax.pfn, write);
 	}
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

scatterlist-fix-sg_phys-masking.patch
pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

