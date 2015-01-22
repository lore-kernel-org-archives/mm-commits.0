From: akpm@linux-foundation.org
Subject: + mincore-apply-page-table-walker-on-do_mincore.patch added to
 -mm tree
Date: Thu, 22 Jan 2015 15:31:32 -0800
Message-ID: <54c18854.kqmFBuN8jggLE+R5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbbAVXbd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 18:31:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mincore: apply page table walker on do_mincore()
has been added to the -mm tree.  Its filename is
     mincore-apply-page-table-walker-on-do_mincore.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mincore-apply-page-table-walker-on-do_mincore.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mincore-apply-page-table-walker-on-do_mincore.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mincore: apply page table walker on do_mincore()

This patch makes do_mincore() use walk_page_vma(), which reduces many
lines of code by using common page table walk code.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   20 -----
 mm/mincore.c     |  169 +++++++++++++++------------------------------
 2 files changed, 59 insertions(+), 130 deletions(-)

diff -puN mm/huge_memory.c~mincore-apply-page-table-walker-on-do_mincore mm/huge_memory.c
--- a/mm/huge_memory.c~mincore-apply-page-table-walker-on-do_mincore
+++ a/mm/huge_memory.c
@@ -1415,26 +1415,6 @@ int zap_huge_pmd(struct mmu_gather *tlb,
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
@@ -19,38 +19,26 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static void mincore_hugetlb_page_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long end,
-				unsigned char *vec)
+static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
+			unsigned long end, struct mm_walk *walk)
 {
+	int err = 0;
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
+	return err;
 }
 
 /*
@@ -94,14 +82,15 @@ static unsigned char mincore_page(struct
 	return present;
 }
 
-static void mincore_unmapped_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long end,
-				unsigned char *vec)
+static int mincore_unmapped_range(unsigned long addr, unsigned long end,
+				   struct mm_walk *walk)
 {
+	struct vm_area_struct *vma = walk->vma;
+	unsigned char *vec = walk->private;
 	unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	int i;
 
-	if (vma->vm_file) {
+	if (vma && vma->vm_file) {
 		pgoff_t pgoff;
 
 		pgoff = linear_page_index(vma, addr);
@@ -111,24 +100,39 @@ static void mincore_unmapped_range(struc
 		for (i = 0; i < nr; i++)
 			vec[i] = 0;
 	}
+	walk->private += nr;
+	return 0;
 }
 
-static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, unsigned long end,
-			unsigned char *vec)
+static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			struct mm_walk *walk)
 {
-	unsigned long next;
 	spinlock_t *ptl;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *ptep;
 
-	ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	do {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+		memset(walk->private, 1, (end - addr) >> PAGE_SHIFT);
+		walk->private += (end - addr) >> PAGE_SHIFT;
+		spin_unlock(ptl);
+		return 0;
+	}
+
+	if (pmd_trans_unstable(pmd)) {
+		mincore_unmapped_range(addr, end, walk);
+		return 0;
+	}
+
+	ptep = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	for (; addr != end; ptep++, addr += PAGE_SIZE) {
 		pte_t pte = *ptep;
+		unsigned char *vec = walk->private;
 
-		next = addr + PAGE_SIZE;
-		if (pte_none(pte))
-			mincore_unmapped_range(vma, addr, next, vec);
-		else if (pte_present(pte))
+		if (pte_none(pte)) {
+			mincore_unmapped_range(addr, addr + PAGE_SIZE, walk);
+			continue;
+		}
+		if (pte_present(pte))
 			*vec = 1;
 		else { /* pte is a swap entry */
 			swp_entry_t entry = pte_to_swp_entry(pte);
@@ -149,70 +153,11 @@ static void mincore_pte_range(struct vm_
 #endif
 			}
 		}
-		vec++;
-	} while (ptep++, addr = next, addr != end);
+		walk->private++;
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
+	cond_resched();
+	return 0;
 }
 
 /*
@@ -224,18 +169,22 @@ static long do_mincore(unsigned long add
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
-
+	err = walk_page_range(addr, end, &mincore_walk);
+	if (err < 0)
+		return err;
 	return (end - addr) >> PAGE_SHIFT;
 }
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
pagewalk-improve-vma-handling.patch
pagewalk-add-walk_page_vma.patch
smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch
pagemap-use-walk-vma-instead-of-calling-find_vma.patch
numa_maps-fix-typo-in-gather_hugetbl_stats.patch
numa_maps-remove-numa_maps-vma.patch
memcg-cleanup-preparation-for-page-table-walk.patch
arch-powerpc-mm-subpage-protc-use-walk-vma-and-walk_page_vma.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

