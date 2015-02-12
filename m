From: akpm@linux-foundation.org
Subject: [merged] mincore-apply-page-table-walker-on-do_mincore.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:38:45 -0800
Message-ID: <54dd0145.4a3+TB00PqSQmrvM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbbBLTiq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, daeseok.youn@gmail.com, dave.hansen@intel.com, gorcunov@openvz.org, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mincore: apply page table walker on do_mincore()
has been removed from the -mm tree.  Its filename was
     mincore-apply-page-table-walker-on-do_mincore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mincore: apply page table walker on do_mincore()

This patch makes do_mincore() use walk_page_vma(), which reduces many
lines of code by using common page table walk code.

[daeseok.youn@gmail.com: remove unneeded variable 'err']
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   20 -----
 mm/mincore.c     |  166 ++++++++++++++++-----------------------------
 2 files changed, 60 insertions(+), 126 deletions(-)

diff -puN mm/huge_memory.c~mincore-apply-page-table-walker-on-do_mincore mm/huge_memory.c
--- a/mm/huge_memory.c~mincore-apply-page-table-walker-on-do_mincore
+++ a/mm/huge_memory.c
@@ -1412,26 +1412,6 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	return ret;
 }
 
-int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, unsigned long end,
-		unsigned char *vec)
-{
-	spinlock_t *ptl;
-	int ret = 0;
-
-	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		/*
-		 * All logical pages in the range are present
-		 * if backed by a huge page.
-		 */
-		spin_unlock(ptl);
-		memset(vec, 1, (end - addr) >> PAGE_SHIFT);
-		ret = 1;
-	}
-
-	return ret;
-}
-
 int move_huge_pmd(struct vm_area_struct *vma, struct vm_area_struct *new_vma,
 		  unsigned long old_addr,
 		  unsigned long new_addr, unsigned long old_end,
diff -puN mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore mm/mincore.c
--- a/mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore
+++ a/mm/mincore.c
@@ -19,38 +19,25 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static void mincore_hugetlb_page_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long end,
-				unsigned char *vec)
+static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
+			unsigned long end, struct mm_walk *walk)
 {
 #ifdef CONFIG_HUGETLB_PAGE
-	struct hstate *h;
+	unsigned char present;
+	unsigned char *vec = walk->private;
 
-	h = hstate_vma(vma);
-	while (1) {
-		unsigned char present;
-		pte_t *ptep;
-		/*
-		 * Huge pages are always in RAM for now, but
-		 * theoretically it needs to be checked.
-		 */
-		ptep = huge_pte_offset(current->mm,
-				       addr & huge_page_mask(h));
-		present = ptep && !huge_pte_none(huge_ptep_get(ptep));
-		while (1) {
-			*vec = present;
-			vec++;
-			addr += PAGE_SIZE;
-			if (addr == end)
-				return;
-			/* check hugepage border */
-			if (!(addr & ~huge_page_mask(h)))
-				break;
-		}
-	}
+	/*
+	 * Hugepages under user process are always in RAM and never
+	 * swapped out, but theoretically it needs to be checked.
+	 */
+	present = pte && !huge_pte_none(huge_ptep_get(pte));
+	for (; addr != end; vec++, addr += PAGE_SIZE)
+		*vec = present;
+	walk->private = vec;
 #else
 	BUG();
 #endif
+	return 0;
 }
 
 /*
@@ -94,9 +81,8 @@ static unsigned char mincore_page(struct
 	return present;
 }
 
-static void mincore_unmapped_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long end,
-				unsigned char *vec)
+static int __mincore_unmapped_range(unsigned long addr, unsigned long end,
+				struct vm_area_struct *vma, unsigned char *vec)
 {
 	unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	int i;
@@ -111,23 +97,44 @@ static void mincore_unmapped_range(struc
 		for (i = 0; i < nr; i++)
 			vec[i] = 0;
 	}
+	return nr;
 }
 
-static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, unsigned long end,
-			unsigned char *vec)
+static int mincore_unmapped_range(unsigned long addr, unsigned long end,
+				   struct mm_walk *walk)
+{
+	walk->private += __mincore_unmapped_range(addr, end,
+						  walk->vma, walk->private);
+	return 0;
+}
+
+static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			struct mm_walk *walk)
 {
-	unsigned long next;
 	spinlock_t *ptl;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *ptep;
+	unsigned char *vec = walk->private;
+	int nr = (end - addr) >> PAGE_SHIFT;
+
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+		memset(vec, 1, nr);
+		spin_unlock(ptl);
+		goto out;
+	}
 
-	ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	do {
+	if (pmd_trans_unstable(pmd)) {
+		__mincore_unmapped_range(addr, end, vma, vec);
+		goto out;
+	}
+
+	ptep = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	for (; addr != end; ptep++, addr += PAGE_SIZE) {
 		pte_t pte = *ptep;
 
-		next = addr + PAGE_SIZE;
 		if (pte_none(pte))
-			mincore_unmapped_range(vma, addr, next, vec);
+			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
+						 vma, vec);
 		else if (pte_present(pte))
 			*vec = 1;
 		else { /* pte is a swap entry */
@@ -150,69 +157,12 @@ static void mincore_pte_range(struct vm_
 			}
 		}
 		vec++;
-	} while (ptep++, addr = next, addr != end);
+	}
 	pte_unmap_unlock(ptep - 1, ptl);
-}
-
-static void mincore_pmd_range(struct vm_area_struct *vma, pud_t *pud,
-			unsigned long addr, unsigned long end,
-			unsigned char *vec)
-{
-	unsigned long next;
-	pmd_t *pmd;
-
-	pmd = pmd_offset(pud, addr);
-	do {
-		next = pmd_addr_end(addr, end);
-		if (pmd_trans_huge(*pmd)) {
-			if (mincore_huge_pmd(vma, pmd, addr, next, vec)) {
-				vec += (next - addr) >> PAGE_SHIFT;
-				continue;
-			}
-			/* fall through */
-		}
-		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
-			mincore_unmapped_range(vma, addr, next, vec);
-		else
-			mincore_pte_range(vma, pmd, addr, next, vec);
-		vec += (next - addr) >> PAGE_SHIFT;
-	} while (pmd++, addr = next, addr != end);
-}
-
-static void mincore_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
-			unsigned long addr, unsigned long end,
-			unsigned char *vec)
-{
-	unsigned long next;
-	pud_t *pud;
-
-	pud = pud_offset(pgd, addr);
-	do {
-		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
-			mincore_unmapped_range(vma, addr, next, vec);
-		else
-			mincore_pmd_range(vma, pud, addr, next, vec);
-		vec += (next - addr) >> PAGE_SHIFT;
-	} while (pud++, addr = next, addr != end);
-}
-
-static void mincore_page_range(struct vm_area_struct *vma,
-			unsigned long addr, unsigned long end,
-			unsigned char *vec)
-{
-	unsigned long next;
-	pgd_t *pgd;
-
-	pgd = pgd_offset(vma->vm_mm, addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			mincore_unmapped_range(vma, addr, next, vec);
-		else
-			mincore_pud_range(vma, pgd, addr, next, vec);
-		vec += (next - addr) >> PAGE_SHIFT;
-	} while (pgd++, addr = next, addr != end);
+out:
+	walk->private += nr;
+	cond_resched();
+	return 0;
 }
 
 /*
@@ -224,18 +174,22 @@ static long do_mincore(unsigned long add
 {
 	struct vm_area_struct *vma;
 	unsigned long end;
+	int err;
+	struct mm_walk mincore_walk = {
+		.pmd_entry = mincore_pte_range,
+		.pte_hole = mincore_unmapped_range,
+		.hugetlb_entry = mincore_hugetlb,
+		.private = vec,
+	};
 
 	vma = find_vma(current->mm, addr);
 	if (!vma || addr < vma->vm_start)
 		return -ENOMEM;
-
+	mincore_walk.mm = vma->vm_mm;
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
-
-	if (is_vm_hugetlb_page(vma))
-		mincore_hugetlb_page_range(vma, addr, end, vec);
-	else
-		mincore_page_range(vma, addr, end, vec);
