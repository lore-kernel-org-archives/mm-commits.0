From: akpm@linux-foundation.org
Subject: + pagemap-use-walk-vma-instead-of-calling-find_vma.patch added to -mm tree
Date: Thu, 22 Jan 2015 15:31:18 -0800
Message-ID: <54c18846.v6Ejl516Pv3yIcoT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbbAVXbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 18:31:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: use walk->vma instead of calling find_vma()
has been added to the -mm tree.  Its filename is
     pagemap-use-walk-vma-instead-of-calling-find_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagemap-use-walk-vma-instead-of-calling-find_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagemap-use-walk-vma-instead-of-calling-find_vma.patch

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

 fs/proc/task_mmu.c |   70 ++++++++++---------------------------------
 1 file changed, 17 insertions(+), 53 deletions(-)

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
 	pte_t *pte;
 	int err = 0;
 
-	/* find the first VMA at or above 'addr' */
-	vma = find_vma(walk->mm, addr);
-	if (vma && pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		int pmd_flags2;
 
 		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(*pmd))
@@ -1081,50 +1079,19 @@ static int pagemap_pte_range(pmd_t *pmd,
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
-		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
-			pagemap_entry_t pme;
-			pte = pte_offset_map(pmd, addr);
-			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
-			pte_unmap(pte);
-			err = add_to_pagemap(addr, &pme, pm);
-			if (err)
-				return err;
-		}
-
-		if (addr == end)
-			break;
-
-		vma = find_vma(walk->mm, addr);
+	/*
+	 * We can assume that @vma always points to a valid one and @end never
+	 * goes beyond vma->vm_end.
+	 */
+	for (; addr < end; addr += PAGE_SIZE) {
+		pagemap_entry_t pme;
+
+		pte = pte_offset_map(pmd, addr);
+		pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
+		pte_unmap(pte);
+		err = add_to_pagemap(addr, &pme, pm);
+		if (err)
+			return err;
 	}
 
 	cond_resched();
@@ -1151,15 +1118,12 @@ static int pagemap_hugetlb_range(pte_t *
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
-
-	if (vma && (vma->vm_flags & VM_SOFTDIRTY))
+	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags2 = __PM_SOFT_DIRTY;
 	else
 		flags2 = 0;
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

