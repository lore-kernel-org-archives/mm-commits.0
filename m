From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-hugetlbfs-introduce-pagesize-to-vm_operations_struct.patch removed from
 -mm tree
Date: Tue, 12 Dec 2017 13:34:28 -0800
Message-ID: <5a304b64.u8NDmpUAnt8a3gcu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752522AbdLLVe3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Dec 2017 16:34:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, benh@kernel.crashing.org, jane.chu@oracle.com, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlbfs: introduce ->pagesize() to vm_operations_struct
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-introduce-pagesize-to-vm_operations_struct.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, hugetlbfs: introduce ->pagesize() to vm_operations_struct

When device-dax is operating in huge-page mode we want it to behave like
hugetlbfs and report the MMU page mapping size that is being enforced by
the vma.  Similar to 31383c6865a5 ("mm, hugetlbfs: introduce ->split() to
vm_operations_struct") it would be messy to teach vma_mmu_pagesize() about
device-dax page mapping sizes in the same (hstate) way that hugetlbfs
communicates this attribute.  Instead, these patches introduce a new
->pagesize() vm operation.

Link: http://lkml.kernel.org/r/151270385525.21215.16828596212056611775.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Jane Chu <jane.chu@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    5 ----
 include/linux/hugetlb.h       |   30 ++++++++++++++++++++-----
 include/linux/mm.h            |    1 
 mm/hugetlb.c                  |   38 ++++++--------------------------
 4 files changed, 34 insertions(+), 40 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~mm-hugetlbfs-introduce-pagesize-to-vm_operations_struct arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-hugetlbfs-introduce-pagesize-to-vm_operations_struct
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -568,10 +568,7 @@ unsigned long vma_mmu_pagesize(struct vm
 	if (!radix_enabled())
 		return 1UL << mmu_psize_to_shift(psize);
 #endif
-	if (!is_vm_hugetlb_page(vma))
-		return PAGE_SIZE;
-
-	return huge_page_size(hstate_vma(vma));
+	return vma_kernel_pagesize(vma);
 }
 
 static inline bool is_power_of_4(unsigned long x)
diff -puN include/linux/hugetlb.h~mm-hugetlbfs-introduce-pagesize-to-vm_operations_struct include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlbfs-introduce-pagesize-to-vm_operations_struct
+++ a/include/linux/hugetlb.h
@@ -253,6 +253,30 @@ enum {
 	HUGETLB_ANONHUGE_INODE  = 2,
 };
 
+/*
+ * Return the size of the pages allocated when backing a VMA. In the majority
+ * cases this will be same size as used by the page table entries.
+ */
+static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->pagesize)
+		return vma->vm_ops->pagesize(vma);
+	return PAGE_SIZE;
+}
+
+/*
+ * Return the page size being used by the MMU to back a VMA. In the majority
+ * of cases, the page size used by the kernel matches the MMU size. On
+ * architectures where it differs, an architecture-specific version of this
+ * function is required.
+ */
+#ifndef vma_mmu_pagesize
+static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
+{
+	return vma_kernel_pagesize(vma);
+}
+#endif
+
 #ifdef CONFIG_HUGETLBFS
 struct hugetlbfs_sb_info {
 	long	max_inodes;   /* inodes allowed */
@@ -394,10 +418,6 @@ static inline unsigned long huge_page_si
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
-extern unsigned long vma_kernel_pagesize(struct vm_area_struct *vma);
-
-extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
-
 static inline unsigned long huge_page_mask(struct hstate *h)
 {
 	return h->mask;
@@ -532,8 +552,6 @@ struct hstate {};
 #define page_hstate(page) NULL
 #define huge_page_size(h) PAGE_SIZE
 #define huge_page_mask(h) PAGE_MASK
-#define vma_kernel_pagesize(v) PAGE_SIZE
-#define vma_mmu_pagesize(v) PAGE_SIZE
 #define huge_page_order(h) 0
 #define huge_page_shift(h) PAGE_SHIFT
 static inline bool hstate_is_gigantic(struct hstate *h)
diff -puN include/linux/mm.h~mm-hugetlbfs-introduce-pagesize-to-vm_operations_struct include/linux/mm.h
--- a/include/linux/mm.h~mm-hugetlbfs-introduce-pagesize-to-vm_operations_struct
+++ a/include/linux/mm.h
@@ -383,6 +383,7 @@ struct vm_operations_struct {
 	int (*huge_fault)(struct vm_fault *vmf, enum page_entry_size pe_size);
 	void (*map_pages)(struct vm_fault *vmf,
 			pgoff_t start_pgoff, pgoff_t end_pgoff);
+	unsigned long (*pagesize)(struct vm_area_struct * area);
 
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
diff -puN mm/hugetlb.c~mm-hugetlbfs-introduce-pagesize-to-vm_operations_struct mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbfs-introduce-pagesize-to-vm_operations_struct
+++ a/mm/hugetlb.c
@@ -630,36 +630,6 @@ pgoff_t linear_hugepage_index(struct vm_
 EXPORT_SYMBOL_GPL(linear_hugepage_index);
 
 /*
- * Return the size of the pages allocated when backing a VMA. In the majority
- * cases this will be same size as used by the page table entries.
- */
-unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
-{
-	struct hstate *hstate;
-
-	if (!is_vm_hugetlb_page(vma))
-		return PAGE_SIZE;
-
-	hstate = hstate_vma(vma);
-
-	return 1UL << huge_page_shift(hstate);
-}
-EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
-
-/*
- * Return the page size being used by the MMU to back a VMA. In the majority
- * of cases, the page size used by the kernel matches the MMU size. On
- * architectures where it differs, an architecture-specific version of this
- * function is required.
- */
-#ifndef vma_mmu_pagesize
-unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
-{
-	return vma_kernel_pagesize(vma);
-}
-#endif
-
-/*
  * Flags for MAP_PRIVATE reservations.  These are stored in the bottom
  * bits of the reservation map pointer, which are always clear due to
  * alignment.
@@ -3142,6 +3112,13 @@ static int hugetlb_vm_op_split(struct vm
 	return 0;
 }
 
+static unsigned long hugetlb_vm_op_pagesize(struct vm_area_struct *vma)
+{
+	struct hstate *hstate = hstate_vma(vma);
+
+	return 1UL << huge_page_shift(hstate);
+}
+
 /*
  * We cannot handle pagefaults against hugetlb pages at all.  They cause
  * handle_mm_fault() to try to instantiate regular-sized pages in the
@@ -3159,6 +3136,7 @@ const struct vm_operations_struct hugetl
 	.open = hugetlb_vm_op_open,
 	.close = hugetlb_vm_op_close,
 	.split = hugetlb_vm_op_split,
+	.pagesize = hugetlb_vm_op_pagesize,
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct page *page,
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

device-dax-implement-pagesize-for-smaps-to-report-mmupagesize.patch

