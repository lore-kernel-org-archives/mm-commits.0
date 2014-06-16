From: akpm@linux-foundation.org
Subject: [nacked] mincore-apply-page-table-walker-on-do_mincore.patch
 removed from -mm tree
Date: Mon, 16 Jun 2014 16:32:46 -0700
Message-ID: <539f7e9e.XoUyPLJIX60JOmFo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaFPXcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mincore: apply page table walker on do_mincore()
has been removed from the -mm tree.  Its filename was
     mincore-apply-page-table-walker-on-do_mincore.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mincore: apply page table walker on do_mincore()

This patch makes do_mincore() use walk_page_vma(), which reduces many lines
of code by using common page table walk code.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   20 ----
 mm/mincore.c     |  198 +++++++++++++++------------------------------
 2 files changed, 68 insertions(+), 150 deletions(-)

diff -puN mm/huge_memory.c~mincore-apply-page-table-walker-on-do_mincore mm/huge_memory.c
--- a/mm/huge_memory.c~mincore-apply-page-table-walker-on-do_mincore
+++ a/mm/huge_memory.c
@@ -1379,26 +1379,6 @@ int zap_huge_pmd(struct mmu_gather *tlb,
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
@@ -19,38 +19,27 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static void mincore_hugetlb_page_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long end,
-				unsigned char *vec)
+static int mincore_hugetlb(pte_t *pte, unsigned long addr,
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
+	cond_resched();
+	walk->private += (end - addr) >> PAGE_SHIFT;
 #else
 	BUG();
 #endif
+	return err;
 }
 
 /*
@@ -94,10 +83,11 @@ static unsigned char mincore_page(struct
 	return present;
 }
 
-static void mincore_unmapped_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long end,
-				unsigned char *vec)
+static int mincore_hole(unsigned long addr, unsigned long end,
+				struct mm_walk *walk)
 {
+	struct vm_area_struct *vma = walk->vma;
+	unsigned char *vec = walk->private;
 	unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	int i;
 
@@ -111,110 +101,49 @@ static void mincore_unmapped_range(struc
 		for (i = 0; i < nr; i++)
 			vec[i] = 0;
 	}
+	walk->private += nr;
+	return 0;
 }
 
-static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, unsigned long end,
-			unsigned char *vec)
-{
-	unsigned long next;
-	spinlock_t *ptl;
-	pte_t *ptep;
-
-	ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	do {
-		pte_t pte = *ptep;
-		pgoff_t pgoff;
+static int mincore_pte(pte_t *pte, unsigned long addr, unsigned long end,
+			struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+	unsigned char *vec = walk->private;
+	pgoff_t pgoff;
+
+	if (pte_present(*pte))
+		*vec = 1;
+	else if (pte_file(*pte)) {
+		pgoff = pte_to_pgoff(*pte);
+		*vec = mincore_page(vma->vm_file->f_mapping, pgoff);
+	} else { /* pte is a swap entry */
+		swp_entry_t entry = pte_to_swp_entry(*pte);
 
-		next = addr + PAGE_SIZE;
-		if (pte_none(pte))
-			mincore_unmapped_range(vma, addr, next, vec);
-		else if (pte_present(pte))
+		if (is_migration_entry(entry)) {
+			/* migration entries are always uptodate */
 			*vec = 1;
-		else if (pte_file(pte)) {
-			pgoff = pte_to_pgoff(pte);
-			*vec = mincore_page(vma->vm_file->f_mapping, pgoff);
-		} else { /* pte is a swap entry */
-			swp_entry_t entry = pte_to_swp_entry(pte);
-
-			if (is_migration_entry(entry)) {
-				/* migration entries are always uptodate */
-				*vec = 1;
-			} else {
+		} else {
 #ifdef CONFIG_SWAP
-				pgoff = entry.val;
-				*vec = mincore_page(swap_address_space(entry),
-					pgoff);
+			pgoff = entry.val;
+			*vec = mincore_page(swap_address_space(entry),
+					    pgoff);
 #else
-				WARN_ON(1);
-				*vec = 1;
+			WARN_ON(1);
+			*vec = 1;
 #endif
-			}
-		}
-		vec++;
-	} while (ptep++, addr = next, addr != end);
-	pte_unmap_unlock(ptep - 1, ptl);
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
 		}
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
+	}
+	walk->private++;
+	return 0;
+}
+
+static int mincore_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
+			struct mm_walk *walk)
+{
+	memset(walk->private, 1, (end - addr) >> PAGE_SHIFT);
+	walk->private += (end - addr) >> PAGE_SHIFT;
+	return 0;
 }
 
 /*
@@ -226,6 +155,7 @@ static long do_mincore(unsigned long add
 {
 	struct vm_area_struct *vma;
 	unsigned long end;
+	int err;
 
 	vma = find_vma(current->mm, addr);
 	if (!vma || addr < vma->vm_start)
@@ -233,12 +163,20 @@ static long do_mincore(unsigned long add
 
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 
-	if (is_vm_hugetlb_page(vma))
-		mincore_hugetlb_page_range(vma, addr, end, vec);
+	struct mm_walk mincore_walk = {
+		.pmd_entry = mincore_pmd,
+		.pte_entry = mincore_pte,
+		.pte_hole = mincore_hole,
+		.hugetlb_entry = mincore_hugetlb,
+		.mm = vma->vm_mm,
+		.vma = vma,
+		.private = vec,
+	};
+	err = walk_page_vma(vma, &mincore_walk);
+	if (err < 0)
+		return err;
 	else
-		mincore_page_range(vma, addr, end, vec);
