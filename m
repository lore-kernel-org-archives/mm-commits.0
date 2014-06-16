From: akpm@linux-foundation.org
Subject: [nacked]
 pagemap-redefine-callback-functions-for-page-table-walker.patch removed
 from -mm tree
Date: Mon, 16 Jun 2014 16:32:04 -0700
Message-ID: <539f7e74.ALp7zDAVpsXjtULU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaFPXcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mpm@selenic.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cpw@sgi.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: pagemap: redefine callback functions for page table walker
has been removed from the -mm tree.  Its filename was
     pagemap-redefine-callback-functions-for-page-table-walker.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: pagemap: redefine callback functions for page table walker

pagemap_pte_range() connected to pmd_entry() does both of pmd loop and pte
loop.  So this patch moves pte part into pagemap_pte() on pte_entry().

We remove VM_SOFTDIRTY check in pagemap_pte_range(), because in the new
page table walker we call __walk_page_range() for each vma separately, so
we never experience multiple vmas in single pgd/pud/pmd/pte loop.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   76 +++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 48 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-redefine-callback-functions-for-page-table-walker fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-redefine-callback-functions-for-page-table-walker
+++ a/fs/proc/task_mmu.c
@@ -967,19 +967,33 @@ static inline void thp_pmd_to_pagemap_en
 }
 #endif
 
-static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+static int pagemap_pte(pte_t *pte, unsigned long addr, unsigned long end,
 			     struct mm_walk *walk)
 {
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = walk->vma;
 	struct pagemapread *pm = walk->private;
-	spinlock_t *ptl;
-	pte_t *pte;
+	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
+
+	if (vma && vma->vm_start <= addr && end <= vma->vm_end) {
+		pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
+		/* unmap before userspace copy */
+		pte_unmap(pte);
+	}
+	return add_to_pagemap(addr, &pme, pm);
+}
+
+static int pagemap_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
+			     struct mm_walk *walk)
+{
 	int err = 0;
+	struct vm_area_struct *vma = walk->vma;
+	struct pagemapread *pm = walk->private;
 	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
+	spinlock_t *ptl;
 
-	/* find the first VMA at or above 'addr' */
-	vma = find_vma(walk->mm, addr);
-	if (vma && pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (!vma)
+		return err;
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		int pmd_flags2;
 
 		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(*pmd))
@@ -998,41 +1012,9 @@ static int pagemap_pte_range(pmd_t *pmd,
 				break;
 		}
 		spin_unlock(ptl);
-		return err;
-	}
-
-	if (pmd_trans_unstable(pmd))
-		return 0;
-	for (; addr != end; addr += PAGE_SIZE) {
-		int flags2;
-
-		/* check to see if we've left 'vma' behind
-		 * and need a new, higher one */
-		if (vma && (addr >= vma->vm_end)) {
-			vma = find_vma(walk->mm, addr);
-			if (vma && (vma->vm_flags & VM_SOFTDIRTY))
-				flags2 = __PM_SOFT_DIRTY;
-			else
-				flags2 = 0;
-			pme = make_pme(PM_NOT_PRESENT(pm->v2) | PM_STATUS2(pm->v2, flags2));
-		}
-
-		/* check that 'vma' actually covers this address,
-		 * and that it isn't a huge page vma */
-		if (vma && (vma->vm_start <= addr) &&
-		    !is_vm_hugetlb_page(vma)) {
-			pte = pte_offset_map(pmd, addr);
-			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
-			/* unmap before userspace copy */
-			pte_unmap(pte);
-		}
-		err = add_to_pagemap(addr, &pme, pm);
-		if (err)
-			return err;
+		/* don't call pagemap_pte() */
+		walk->skip = 1;
 	}
-
-	cond_resched();
-
 	return err;
 }
 
@@ -1055,12 +1037,11 @@ static int pagemap_hugetlb_range(pte_t *
 				 struct mm_walk *walk)
 {
 	struct pagemapread *pm = walk->private;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = walk->vma;
 	int err = 0;
 	int flags2;
 	pagemap_entry_t pme;
 
-	vma = find_vma(walk->mm, addr);
 	WARN_ON_ONCE(!vma);
 
 	if (vma && (vma->vm_flags & VM_SOFTDIRTY))
@@ -1068,6 +1049,7 @@ static int pagemap_hugetlb_range(pte_t *
 	else
 		flags2 = 0;
 
+	hmask = huge_page_mask(hstate_vma(vma));
 	for (; addr != end; addr += PAGE_SIZE) {
 		int offset = (addr & ~hmask) >> PAGE_SHIFT;
 		huge_pte_to_pagemap_entry(&pme, pm, *pte, offset, flags2);
@@ -1075,9 +1057,6 @@ static int pagemap_hugetlb_range(pte_t *
 		if (err)
 			return err;
 	}
-
-	cond_resched();
-
 	return err;
 }
 #endif /* HUGETLB_PAGE */
@@ -1144,10 +1123,11 @@ static ssize_t pagemap_read(struct file
 	if (!mm || IS_ERR(mm))
 		goto out_free;
 
-	pagemap_walk.pmd_entry = pagemap_pte_range;
+	pagemap_walk.pte_entry = pagemap_pte;
+	pagemap_walk.pmd_entry = pagemap_pmd;
 	pagemap_walk.pte_hole = pagemap_pte_hole;
 #ifdef CONFIG_HUGETLB_PAGE
-	pagemap_walk.hugetlb_entry = pagemap_hugetlb_range;
+	pagemap_walk.hugetlb_entry = pagemap_hugetlb;
 #endif
 	pagemap_walk.mm = mm;
 	pagemap_walk.private = &pm;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-pagewalkc-move-pte-null-check.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch
madvise-cleanup-swapin_walk_pmd_entry.patch
madvise-cleanup-swapin_walk_pmd_entry-fix.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
memcg-separate-mem_cgroup_move_charge_pte_range-checkpatch-fixes.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkpatch-fixes.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

