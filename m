From: akpm@linux-foundation.org
Subject: [merged] pagemap-use-walk-vma-instead-of-calling-find_vma.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:38:22 -0800
Message-ID: <54dd012e.OxdW7UbLoTtr8EGy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbbBLTiX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: use walk->vma instead of calling find_vma()
has been removed from the -mm tree.  Its filename was
     pagemap-use-walk-vma-instead-of-calling-find_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: pagemap: use walk->vma instead of calling find_vma()

Page table walker has the information of the current vma in mm_walk, so we
don't have to call find_vma() in each pagemap_(pte|hugetlb)_range() call
any longer.  Currently pagemap_pte_range() does vma loop itself, so this
patch reduces many lines of code.

NULL-vma check is omitted because we assume that we never run these
callbacks on any address outside vma.  And even if it were broken, NULL
pointer dereference would be detected, so we can get enough information
for debugging.

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

 fs/proc/task_mmu.c |   68 ++++++++-----------------------------------
 1 file changed, 14 insertions(+), 54 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-use-walk-vma-instead-of-calling-find_vma fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-use-walk-vma-instead-of-calling-find_vma
+++ a/fs/proc/task_mmu.c
@@ -1047,15 +1047,13 @@ static inline void thp_pmd_to_pagemap_en
 static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			     struct mm_walk *walk)
 {
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = walk->vma;
 	struct pagemapread *pm = walk->private;
 	spinlock_t *ptl;
 	pte_t *pte, *orig_pte;
 	int err = 0;
 
-	/* find the first VMA at or above 'addr' */
-	vma = find_vma(walk->mm, addr);
-	if (vma && pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		int pmd_flags2;
 
 		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(*pmd))
@@ -1081,55 +1079,20 @@ static int pagemap_pte_range(pmd_t *pmd,
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
-	while (1) {
-		/* End of address space hole, which we mark as non-present. */
-		unsigned long hole_end;
-
-		if (vma)
-			hole_end = min(end, vma->vm_start);
-		else
-			hole_end = end;
-
-		for (; addr < hole_end; addr += PAGE_SIZE) {
-			pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
-
-			err = add_to_pagemap(addr, &pme, pm);
-			if (err)
-				return err;
-		}
-
-		if (!vma || vma->vm_start >= end)
-			break;
-		/*
-		 * We can't possibly be in a hugetlb VMA. In general,
-		 * for a mm_walk with a pmd_entry and a hugetlb_entry,
-		 * the pmd_entry can only be called on addresses in a
-		 * hugetlb if the walk starts in a non-hugetlb VMA and
-		 * spans a hugepage VMA. Since pagemap_read walks are
-		 * PMD-sized and PMD-aligned, this will never be true.
-		 */
-		BUG_ON(is_vm_hugetlb_page(vma));
-
-		/* Addresses in the VMA. */
-		orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-		for (; addr < min(end, vma->vm_end); pte++, addr += PAGE_SIZE) {
-			pagemap_entry_t pme;
-
-			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
-			err = add_to_pagemap(addr, &pme, pm);
-			if (err)
-				break;
-		}
-		pte_unmap_unlock(orig_pte, ptl);
+	/*
+	 * We can assume that @vma always points to a valid one and @end never
+	 * goes beyond vma->vm_end.
+	 */
+	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	for (; addr < end; pte++, addr += PAGE_SIZE) {
+		pagemap_entry_t pme;
 
+		pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
+		err = add_to_pagemap(addr, &pme, pm);
 		if (err)
-			return err;
-
-		if (addr == end)
 			break;
-
-		vma = find_vma(walk->mm, addr);
 	}
+	pte_unmap_unlock(orig_pte, ptl);
 
 	cond_resched();
 
@@ -1155,15 +1118,12 @@ static int pagemap_hugetlb_range(pte_t *
 				 struct mm_walk *walk)
 {
 	struct pagemapread *pm = walk->private;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = walk->vma;
 	int err = 0;
 	int flags2;
 	pagemap_entry_t pme;
 
-	vma = find_vma(walk->mm, addr);
-	WARN_ON_ONCE(!vma);
