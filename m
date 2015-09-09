From: akpm@linux-foundation.org
Subject: [merged] dax-dont-use-set_huge_zero_page.patch removed from -mm
 tree
Date: Wed, 09 Sep 2015 12:43:31 -0700
Message-ID: <55f08be3.BC/hiLuRV9/rQcY1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbbIITnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: don't use set_huge_zero_page()
has been removed from the -mm tree.  Its filename was
     dax-dont-use-set_huge_zero_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: dax: don't use set_huge_zero_page()

This is another place where DAX assumed that pgtable_t was a pointer. 
Open code the important parts of set_huge_zero_page() in DAX and make
set_huge_zero_page() static again.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                |   18 ++++++++++++------
 include/linux/huge_mm.h |    3 ---
 mm/huge_memory.c        |    2 +-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff -puN fs/dax.c~dax-dont-use-set_huge_zero_page fs/dax.c
--- a/fs/dax.c~dax-dont-use-set_huge_zero_page
+++ a/fs/dax.c
@@ -572,18 +572,24 @@ int __dax_pmd_fault(struct vm_area_struc
 		unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
 
 	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
-		bool set;
 		spinlock_t *ptl;
-		struct mm_struct *mm = vma->vm_mm;
+		pmd_t entry;
 		struct page *zero_page = get_huge_zero_page();
+
 		if (unlikely(!zero_page))
 			goto fallback;
 
-		ptl = pmd_lock(mm, pmd);
-		set = set_huge_zero_page(NULL, mm, vma, pmd_addr, pmd,
-								zero_page);
-		spin_unlock(ptl);
+		ptl = pmd_lock(vma->vm_mm, pmd);
+		if (!pmd_none(*pmd)) {
+			spin_unlock(ptl);
+			goto fallback;
+		}
+
+		entry = mk_pmd(zero_page, vma->vm_page_prot);
+		entry = pmd_mkhuge(entry);
+		set_pmd_at(vma->vm_mm, pmd_addr, pmd, entry);
 		result = VM_FAULT_NOPAGE;
+		spin_unlock(ptl);
 	} else {
 		sector = bh.b_blocknr << (blkbits - 9);
 		length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
diff -puN include/linux/huge_mm.h~dax-dont-use-set_huge_zero_page include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~dax-dont-use-set_huge_zero_page
+++ a/include/linux/huge_mm.h
@@ -163,9 +163,6 @@ static inline bool is_huge_zero_pmd(pmd_
 }
 
 struct page *get_huge_zero_page(void);
-bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long haddr,
-		pmd_t *pmd, struct page *zero_page);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
diff -puN mm/huge_memory.c~dax-dont-use-set_huge_zero_page mm/huge_memory.c
--- a/mm/huge_memory.c~dax-dont-use-set_huge_zero_page
+++ a/mm/huge_memory.c
@@ -790,7 +790,7 @@ static inline gfp_t alloc_hugepage_gfpma
 }
 
 /* Caller must hold page table lock. */
-bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
 		struct page *zero_page)
 {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-mark-most-vm_operations_struct-const.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

