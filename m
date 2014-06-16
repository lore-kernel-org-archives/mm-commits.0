From: akpm@linux-foundation.org
Subject: [nacked]
 clear_refs-redefine-callback-functions-for-page-table-walker.patch removed
 from -mm tree
Date: Mon, 16 Jun 2014 16:32:02 -0700
Message-ID: <539f7e72.lIcEZyPKhJhyslLn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaFPXcD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mpm@selenic.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cpw@sgi.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: clear_refs: redefine callback functions for page table walker
has been removed from the -mm tree.  Its filename was
     clear_refs-redefine-callback-functions-for-page-table-walker.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: clear_refs: redefine callback functions for page table walker

Currently clear_refs_pte_range() is connected to pmd_entry() to split thps
if found.  But now this work can be done in core page table walker code. 
So we have no reason to keep this callback on pmd_entry().  This patch
moves pte handling code on pte_entry() callback.

clear_refs_write() has some prechecks about if we really walk over a given
vma.  It's fine to let them done by test_walk() callback, so let's define
it.

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

 fs/proc/task_mmu.c |   93 +++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 55 deletions(-)

diff -puN fs/proc/task_mmu.c~clear_refs-redefine-callback-functions-for-page-table-walker fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~clear_refs-redefine-callback-functions-for-page-table-walker
+++ a/fs/proc/task_mmu.c
@@ -705,7 +705,6 @@ enum clear_refs_types {
 };
 
 struct clear_refs_private {
-	struct vm_area_struct *vma;
 	enum clear_refs_types type;
 };
 
@@ -734,41 +733,48 @@ static inline void clear_soft_dirty(stru
 #endif
 }
 
-static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
+static int clear_refs_pte(pte_t *pte, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
 	struct clear_refs_private *cp = walk->private;
-	struct vm_area_struct *vma = cp->vma;
-	pte_t *pte, ptent;
-	spinlock_t *ptl;
+	struct vm_area_struct *vma = walk->vma;
 	struct page *page;
 
-	split_huge_page_pmd(vma, addr, pmd);
-	if (pmd_trans_unstable(pmd))
+	if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
+		clear_soft_dirty(vma, addr, pte);
+		return 0;
+	}
+	if (!pte_present(*pte))
 		return 0;
+	page = vm_normal_page(vma, addr, *pte);
+	if (!page)
+		return 0;
+	/* Clear accessed and referenced bits. */
+	ptep_test_and_clear_young(vma, addr, pte);
+	ClearPageReferenced(page);
+	return 0;
+}
 
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE) {
-		ptent = *pte;
-
-		if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
-			clear_soft_dirty(vma, addr, pte);
-			continue;
-		}
-
-		if (!pte_present(ptent))
-			continue;
-
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page)
-			continue;
-
-		/* Clear accessed and referenced bits. */
-		ptep_test_and_clear_young(vma, addr, pte);
-		ClearPageReferenced(page);
+static int clear_refs_test_walk(unsigned long start, unsigned long end,
+				struct mm_walk *walk)
+{
+	struct clear_refs_private *cp = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+
+	/*
+	 * Writing 1 to /proc/pid/clear_refs affects all pages.
+	 * Writing 2 to /proc/pid/clear_refs only affects anonymous pages.
+	 * Writing 3 to /proc/pid/clear_refs only affects file mapped pages.
+	 * Writing 4 to /proc/pid/clear_refs affects all pages.
+	 */
+	if (cp->type == CLEAR_REFS_ANON && vma->vm_file)
+		walk->skip = 1;
+	if (cp->type == CLEAR_REFS_MAPPED && !vma->vm_file)
+		walk->skip = 1;
+	if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
+		if (vma->vm_flags & VM_SOFTDIRTY)
+			vma->vm_flags &= ~VM_SOFTDIRTY;
 	}
-	pte_unmap_unlock(pte - 1, ptl);
-	cond_resched();
 	return 0;
 }
 
@@ -811,39 +817,16 @@ static ssize_t clear_refs_write(struct f
 			.type = type,
 		};
 		struct mm_walk clear_refs_walk = {
-			.pmd_entry = clear_refs_pte_range,
+			.pte_entry = clear_refs_pte,
+			.test_walk = clear_refs_test_walk,
 			.mm = mm,
 			.private = &cp,
 		};
 		down_read(&mm->mmap_sem);
 		if (type == CLEAR_REFS_SOFT_DIRTY)
 			mmu_notifier_invalidate_range_start(mm, 0, -1);
-		for (vma = mm->mmap; vma; vma = vma->vm_next) {
-			cp.vma = vma;
-			if (is_vm_hugetlb_page(vma))
-				continue;
-			/*
-			 * Writing 1 to /proc/pid/clear_refs affects all pages.
-			 *
-			 * Writing 2 to /proc/pid/clear_refs only affects
-			 * Anonymous pages.
-			 *
-			 * Writing 3 to /proc/pid/clear_refs only affects file
-			 * mapped pages.
-			 *
-			 * Writing 4 to /proc/pid/clear_refs affects all pages.
-			 */
-			if (type == CLEAR_REFS_ANON && vma->vm_file)
-				continue;
-			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
-				continue;
-			if (type == CLEAR_REFS_SOFT_DIRTY) {
-				if (vma->vm_flags & VM_SOFTDIRTY)
-					vma->vm_flags &= ~VM_SOFTDIRTY;
-			}
-			walk_page_range(vma->vm_start, vma->vm_end,
-					&clear_refs_walk);
-		}
+		for (vma = mm->mmap; vma; vma = vma->vm_next)
+			walk_page_vma(vma, &clear_refs_walk);
 		if (type == CLEAR_REFS_SOFT_DIRTY)
 			mmu_notifier_invalidate_range_end(mm, 0, -1);
 		flush_tlb_mm(mm);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
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

