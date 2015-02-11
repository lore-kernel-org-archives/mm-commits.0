From: akpm@linux-foundation.org
Subject: [folded-merged]
 mincore-apply-page-table-walker-on-do_mincore-fix.patch removed from -mm
 tree
Date: Wed, 11 Feb 2015 15:17:59 -0800
Message-ID: <54dbe327.2IWCSr6J3UkLgmHD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbbBKXSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:18:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mincore-apply-page-table-walker-on-do_mincore-fix
has been removed from the -mm tree.  Its filename was
     mincore-apply-page-table-walker-on-do_mincore-fix.patch

This patch was dropped because it was folded into mincore-apply-page-table-walker-on-do_mincore.patch

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mincore-apply-page-table-walker-on-do_mincore-fix

- removed unnecessary vma check in mincore_unmapped_range()
- introduce __mincore_unmapped_range(), this helped us avoid calling
  mincore_unmapped_range() (which cannot be inlined) repeatedly from mincor=
e_pte_range()
- simplified 'nr' calculation in mincore_pte_range(), where we use the fact=
 that
  mincore_pte_range() never fails and nr is always (end - addr) >> PAGE_SHI=
FT.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff -puN mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore-fix mm/mincore.c
--- a/mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore-fix
+++ a/mm/mincore.c
@@ -82,15 +82,13 @@ static unsigned char mincore_page(struct
 	return present;
 }
 
-static int mincore_unmapped_range(unsigned long addr, unsigned long end,
-				   struct mm_walk *walk)
+static int __mincore_unmapped_range(unsigned long addr, unsigned long end,
+				struct vm_area_struct *vma, unsigned char *vec)
 {
-	struct vm_area_struct *vma = walk->vma;
-	unsigned char *vec = walk->private;
 	unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	int i;
 
-	if (vma && vma->vm_file) {
+	if (vma->vm_file) {
 		pgoff_t pgoff;
 
 		pgoff = linear_page_index(vma, addr);
@@ -100,7 +98,14 @@ static int mincore_unmapped_range(unsign
 		for (i = 0; i < nr; i++)
 			vec[i] = 0;
 	}
-	walk->private += nr;
+	return nr;
+}
+
+static int mincore_unmapped_range(unsigned long addr, unsigned long end,
+				   struct mm_walk *walk)
+{
+	walk->private += __mincore_unmapped_range(addr, end,
+						  walk->vma, walk->private);
 	return 0;
 }
 
@@ -110,29 +115,28 @@ static int mincore_pte_range(pmd_t *pmd,
 	spinlock_t *ptl;
 	struct vm_area_struct *vma = walk->vma;
 	pte_t *ptep;
+	unsigned char *vec = walk->private;
+	int nr = (end - addr) >> PAGE_SHIFT;
 
 	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		memset(walk->private, 1, (end - addr) >> PAGE_SHIFT);
-		walk->private += (end - addr) >> PAGE_SHIFT;
+		memset(vec, 1, nr);
 		spin_unlock(ptl);
-		return 0;
+		goto out;
 	}
 
 	if (pmd_trans_unstable(pmd)) {
-		mincore_unmapped_range(addr, end, walk);
-		return 0;
+		__mincore_unmapped_range(addr, end, vma, vec);
+		goto out;
 	}
 
 	ptep = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	for (; addr != end; ptep++, addr += PAGE_SIZE) {
 		pte_t pte = *ptep;
-		unsigned char *vec = walk->private;
 
-		if (pte_none(pte)) {
-			mincore_unmapped_range(addr, addr + PAGE_SIZE, walk);
-			continue;
-		}
-		if (pte_present(pte))
+		if (pte_none(pte))
+			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
+						 vma, vec);
+		else if (pte_present(pte))
 			*vec = 1;
 		else { /* pte is a swap entry */
 			swp_entry_t entry = pte_to_swp_entry(pte);
@@ -153,9 +157,11 @@ static int mincore_pte_range(pmd_t *pmd,
 #endif
 			}
 		}
-		walk->private++;
+		vec++;
 	}
 	pte_unmap_unlock(ptep - 1, ptl);
+out:
+	walk->private += nr;
 	cond_resched();
 	return 0;
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
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
mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch

