From: akpm@linux-foundation.org
Subject: [merged] dax-provide-diagnostics-for-pmd-mapping-failures.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:52 -0800
Message-ID: <569e9900.kU2+pVwuLeXEBgns%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: provide diagnostics for pmd mapping failures
has been removed from the -mm tree.  Its filename was
     dax-provide-diagnostics-for-pmd-mapping-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dax: provide diagnostics for pmd mapping failures

There is a wide gamut of conditions that can trigger the dax pmd path to
fallback to pte mappings.  Ideally we'd have a syscall interface to
determine mapping characteristics after the fact.  In the meantime provide
debug messages.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 8 deletions(-)

diff -puN fs/dax.c~dax-provide-diagnostics-for-pmd-mapping-failures fs/dax.c
--- a/fs/dax.c~dax-provide-diagnostics-for-pmd-mapping-failures
+++ a/fs/dax.c
@@ -558,6 +558,24 @@ EXPORT_SYMBOL_GPL(dax_fault);
  */
 #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
 
+static void __dax_dbg(struct buffer_head *bh, unsigned long address,
+		const char *reason, const char *fn)
+{
+	if (bh) {
+		char bname[BDEVNAME_SIZE];
+		bdevname(bh->b_bdev, bname);
+		pr_debug("%s: %s addr: %lx dev %s state %lx start %lld "
+			"length %zd fallback: %s\n", fn, current->comm,
+			address, bname, bh->b_state, (u64)bh->b_blocknr,
+			bh->b_size, reason);
+	} else {
+		pr_debug("%s: %s addr: %lx fallback: %s\n", fn,
+			current->comm, address, reason);
+	}
+}
+
+#define dax_pmd_dbg(bh, address, reason)	__dax_dbg(bh, address, reason, "dax_pmd")
+
 int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		pmd_t *pmd, unsigned int flags, get_block_t get_block,
 		dax_iodone_t complete_unwritten)
@@ -581,21 +599,29 @@ int __dax_pmd_fault(struct vm_area_struc
 	/* Fall back to PTEs if we're going to COW */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		split_huge_pmd(vma, pmd, address);
+		dax_pmd_dbg(NULL, address, "cow write");
 		return VM_FAULT_FALLBACK;
 	}
 	/* If the PMD would extend outside the VMA */
-	if (pmd_addr < vma->vm_start)
+	if (pmd_addr < vma->vm_start) {
+		dax_pmd_dbg(NULL, address, "vma start unaligned");
 		return VM_FAULT_FALLBACK;
-	if ((pmd_addr + PMD_SIZE) > vma->vm_end)
+	}
+	if ((pmd_addr + PMD_SIZE) > vma->vm_end) {
+		dax_pmd_dbg(NULL, address, "vma end unaligned");
 		return VM_FAULT_FALLBACK;
+	}
 
 	pgoff = linear_page_index(vma, pmd_addr);
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (pgoff >= size)
 		return VM_FAULT_SIGBUS;
 	/* If the PMD would cover blocks out of the file */
-	if ((pgoff | PG_PMD_COLOUR) >= size)
+	if ((pgoff | PG_PMD_COLOUR) >= size) {
+		dax_pmd_dbg(NULL, address,
+				"offset + huge page size > file size");
 		return VM_FAULT_FALLBACK;
+	}
 
 	memset(&bh, 0, sizeof(bh));
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
@@ -611,8 +637,10 @@ int __dax_pmd_fault(struct vm_area_struc
 	 * just fall back to PTEs.  Calling get_block 512 times in a loop
 	 * would be silly.
 	 */
-	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
+	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE) {
+		dax_pmd_dbg(&bh, address, "allocated block too small");
 		goto fallback;
+	}
 
 	/*
 	 * If we allocated new storage, make sure no process has any
@@ -635,23 +663,33 @@ int __dax_pmd_fault(struct vm_area_struc
 		result = VM_FAULT_SIGBUS;
 		goto out;
 	}
-	if ((pgoff | PG_PMD_COLOUR) >= size)
+	if ((pgoff | PG_PMD_COLOUR) >= size) {
+		dax_pmd_dbg(&bh, address, "pgoff unaligned");
 		goto fallback;
+	}
 
 	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
 		struct page *zero_page = get_huge_zero_page();
 
-		if (unlikely(!zero_page))
+		if (unlikely(!zero_page)) {
+			dax_pmd_dbg(&bh, address, "no zero page");
 			goto fallback;
+		}
 
 		ptl = pmd_lock(vma->vm_mm, pmd);
 		if (!pmd_none(*pmd)) {
 			spin_unlock(ptl);
+			dax_pmd_dbg(&bh, address, "pmd already present");
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
@@ -668,8 +706,13 @@ int __dax_pmd_fault(struct vm_area_struc
 			result = VM_FAULT_SIGBUS;
 			goto out;
 		}
-		if (length < PMD_SIZE
-				|| (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR)) {
+		if (length < PMD_SIZE) {
+			dax_pmd_dbg(&bh, address, "dax-length too small");
+			dax_unmap_atomic(bdev, &dax);
+			goto fallback;
+		}
+		if (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR) {
+			dax_pmd_dbg(&bh, address, "pfn unaligned");
 			dax_unmap_atomic(bdev, &dax);
 			goto fallback;
 		}
@@ -680,6 +723,7 @@ int __dax_pmd_fault(struct vm_area_struc
 		 */
 		if (pfn_t_has_page(dax.pfn)) {
 			dax_unmap_atomic(bdev, &dax);
+			dax_pmd_dbg(&bh, address, "pfn not in memmap");
 			goto fallback;
 		}
 
@@ -692,6 +736,11 @@ int __dax_pmd_fault(struct vm_area_struc
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

dax-add-support-for-fsync-sync-v6-fix.patch

