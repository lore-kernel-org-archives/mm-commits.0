From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-add-hugepage-support-to-pagemap.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:54 -0800
Message-ID: <200912152154.nBFLssn0015403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934016AbZLOWTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:19:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, apw@canonical.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com, mm-c


The patch titled
     mm hugetlb: add hugepage support to pagemap
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-hugepage-support-to-pagemap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm hugetlb: add hugepage support to pagemap
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

This patch enables extraction of the pfn of a hugepage from
/proc/pid/pagemap in an architecture independent manner.

Details
-------
My test program (leak_pagemap) works as follows:
 - creat() and mmap() a file on hugetlbfs (file size is 200MB == 100 hugepages,)
 - read()/write() something on it,
 - call page-types with option -p,
 - munmap() and unlink() the file on hugetlbfs

Without my patches
------------------
$ ./leak_pagemap
             flags page-count       MB  symbolic-flags                     long-symbolic-flags
0x0000000000000000          1        0  __________________________________
0x0000000000000804          1        0  __R________M______________________ referenced,mmap
0x000000000000086c         81        0  __RU_lA____M______________________ referenced,uptodate,lru,active,mmap
0x0000000000005808          5        0  ___U_______Ma_b___________________ uptodate,mmap,anonymous,swapbacked
0x0000000000005868         12        0  ___U_lA____Ma_b___________________ uptodate,lru,active,mmap,anonymous,swapbacked
0x000000000000586c          1        0  __RU_lA____Ma_b___________________ referenced,uptodate,lru,active,mmap,anonymous,swapbacked
             total        101        0

The output of page-types don't show any hugepage.


With my patches
---------------
$ ./leak_pagemap
             flags page-count       MB  symbolic-flags                     long-symbolic-flags
0x0000000000000000          1        0  __________________________________
0x0000000000030000      51100      199  ________________TG________________ compound_tail,huge
0x0000000000028018        100        0  ___UD__________H_G________________ uptodate,dirty,compound_head,huge
0x0000000000000804          1        0  __R________M______________________ referenced,mmap
0x000000000000080c          1        0  __RU_______M______________________ referenced,uptodate,mmap
0x000000000000086c         80        0  __RU_lA____M______________________ referenced,uptodate,lru,active,mmap
0x0000000000005808          4        0  ___U_______Ma_b___________________ uptodate,mmap,anonymous,swapbacked
0x0000000000005868         12        0  ___U_lA____Ma_b___________________ uptodate,lru,active,mmap,anonymous,swapbacked
0x000000000000586c          1        0  __RU_lA____Ma_b___________________ referenced,uptodate,lru,active,mmap,anonymous,swapbacked
             total      51300      200

The output of page-types shows 51200 pages contributing to hugepages,
containing 100 head pages and 51100 tail pages as expected.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   45 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h |    3 ++
 mm/pagewalk.c      |   22 ++++++++++++++++++---
 3 files changed, 67 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-hugetlb-add-hugepage-support-to-pagemap fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-hugetlb-add-hugepage-support-to-pagemap
+++ a/fs/proc/task_mmu.c
@@ -650,6 +650,50 @@ static int pagemap_pte_range(pmd_t *pmd,
 	return err;
 }
 
+static u64 huge_pte_to_pagemap_entry(pte_t pte, int offset)
+{
+	u64 pme = 0;
+	if (pte_present(pte))
+		pme = PM_PFRAME(pte_pfn(pte) + offset)
+			| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT;
+	return pme;
+}
+
+static int pagemap_hugetlb_range(pte_t *pte, unsigned long addr,
+				 unsigned long end, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma;
+	struct pagemapread *pm = walk->private;
+	struct hstate *hs = NULL;
+	int err = 0;
+
+	vma = find_vma(walk->mm, addr);
+	if (vma)
+		hs = hstate_vma(vma);
+	for (; addr != end; addr += PAGE_SIZE) {
+		u64 pfn = PM_NOT_PRESENT;
+
+		if (vma && (addr >= vma->vm_end)) {
+			vma = find_vma(walk->mm, addr);
+			if (vma)
+				hs = hstate_vma(vma);
+		}
+
+		if (vma && (vma->vm_start <= addr) && is_vm_hugetlb_page(vma)) {
+			/* calculate pfn of the "raw" page in the hugepage. */
+			int offset = (addr & ~huge_page_mask(hs)) >> PAGE_SHIFT;
+			pfn = huge_pte_to_pagemap_entry(*pte, offset);
+		}
+		err = add_to_pagemap(addr, pfn, pm);
+		if (err)
+			return err;
+	}
+
+	cond_resched();
+
+	return err;
+}
+
 /*
  * /proc/pid/pagemap - an array mapping virtual pages to pfns
  *
@@ -742,6 +786,7 @@ static ssize_t pagemap_read(struct file 
 
 	pagemap_walk.pmd_entry = pagemap_pte_range;
 	pagemap_walk.pte_hole = pagemap_pte_hole;
+	pagemap_walk.hugetlb_entry = pagemap_hugetlb_range;
 	pagemap_walk.mm = mm;
 	pagemap_walk.private = &pm;
 
diff -puN include/linux/mm.h~mm-hugetlb-add-hugepage-support-to-pagemap include/linux/mm.h
--- a/include/linux/mm.h~mm-hugetlb-add-hugepage-support-to-pagemap
+++ a/include/linux/mm.h
@@ -770,6 +770,7 @@ unsigned long unmap_vmas(struct mmu_gath
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
  * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
  * @pte_hole: if set, called for each hole at all levels
+ * @hugetlb_entry: if set, called for each hugetlb entry
  *
  * (see walk_page_range for more details)
  */
@@ -779,6 +780,8 @@ struct mm_walk {
 	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, struct mm_walk *);
 	int (*pte_entry)(pte_t *, unsigned long, unsigned long, struct mm_walk *);
 	int (*pte_hole)(unsigned long, unsigned long, struct mm_walk *);
+	int (*hugetlb_entry)(pte_t *, unsigned long, unsigned long,
+			     struct mm_walk *);
 	struct mm_struct *mm;
 	void *private;
 };
diff -puN mm/pagewalk.c~mm-hugetlb-add-hugepage-support-to-pagemap mm/pagewalk.c
--- a/mm/pagewalk.c~mm-hugetlb-add-hugepage-support-to-pagemap
+++ a/mm/pagewalk.c
@@ -120,15 +120,31 @@ int walk_page_range(unsigned long addr, 
 	do {
 		next = pgd_addr_end(addr, end);
 
-		/* skip hugetlb vma to avoid hugepage PMD being cleared
-		 * in pmd_none_or_clear_bad(). */
+		/*
+		 * handle hugetlb vma individually because pagetable walk for
+		 * the hugetlb page is dependent on the architecture and
+		 * we can't handled it in the same manner as non-huge pages.
+		 */
 		vma = find_vma(walk->mm, addr);
+#ifdef CONFIG_HUGETLB_PAGE
 		if (vma && is_vm_hugetlb_page(vma)) {
+			pte_t *pte;
+			struct hstate *hs;
+
 			if (vma->vm_end < next)
 				next = vma->vm_end;
+			hs = hstate_vma(vma);
+			pte = huge_pte_offset(walk->mm,
+					      addr & huge_page_mask(hs));
+			if (pte && !huge_pte_none(huge_ptep_get(pte))
+			    && walk->hugetlb_entry)
+				err = walk->hugetlb_entry(pte, addr,
+							  next, walk);
+			if (err)
+				break;
 			continue;
 		}
