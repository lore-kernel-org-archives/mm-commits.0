From: akpm@linux-foundation.org
Subject: [nacked]
 memcg-redefine-callback-functions-for-page-table-walker.patch removed from
 -mm tree
Date: Mon, 16 Jun 2014 16:32:10 -0700
Message-ID: <539f7e7a.5sluIIa9J8DJoNZe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaFPXcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mpm@selenic.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cpw@sgi.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: memcg: redefine callback functions for page table walker
has been removed from the -mm tree.  Its filename was
     memcg-redefine-callback-functions-for-page-table-walker.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: memcg: redefine callback functions for page table walker

Move code around pte loop in mem_cgroup_count_precharge_pte_range() into
mem_cgroup_count_precharge_pte() connected to pte_entry().

We don't change the callback mem_cgroup_move_charge_pte_range() for now,
because we can't do the same replacement easily due to 'goto retry'.

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

 mm/memcontrol.c |   71 +++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 44 deletions(-)

diff -puN mm/memcontrol.c~memcg-redefine-callback-functions-for-page-table-walker mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-redefine-callback-functions-for-page-table-walker
+++ a/mm/memcontrol.c
@@ -6650,30 +6650,29 @@ static inline enum mc_target_type get_mc
 }
 #endif
 
-static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
+static int mem_cgroup_count_precharge_pte(pte_t *pte,
 					unsigned long addr, unsigned long end,
 					struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->private;
-	pte_t *pte;
+	if (get_mctgt_type(walk->vma, addr, *pte, NULL))
+		mc.precharge++;	/* increment precharge temporarily */
+	return 0;
+}
+
+static int mem_cgroup_count_precharge_pmd(pmd_t *pmd,
+					unsigned long addr, unsigned long end,
+					struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
 
 	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
 			mc.precharge += HPAGE_PMD_NR;
 		spin_unlock(ptl);
-		return 0;
+		/* don't call mem_cgroup_count_precharge_pte() */
+		walk->skip = 1;
 	}
-
-	if (pmd_trans_unstable(pmd))
-		return 0;
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE)
-		if (get_mctgt_type(vma, addr, *pte, NULL))
-			mc.precharge++;	/* increment precharge temporarily */
-	pte_unmap_unlock(pte - 1, ptl);
-	cond_resched();
-
 	return 0;
 }
 
@@ -6682,18 +6681,14 @@ static unsigned long mem_cgroup_count_pr
 	unsigned long precharge;
 	struct vm_area_struct *vma;
 
+	struct mm_walk mem_cgroup_count_precharge_walk = {
+		.pmd_entry = mem_cgroup_count_precharge_pmd,
+		.pte_entry = mem_cgroup_count_precharge_pte,
+		.mm = mm,
+	};
 	down_read(&mm->mmap_sem);
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		struct mm_walk mem_cgroup_count_precharge_walk = {
-			.pmd_entry = mem_cgroup_count_precharge_pte_range,
-			.mm = mm,
-			.private = vma,
-		};
-		if (is_vm_hugetlb_page(vma))
-			continue;
-		walk_page_range(vma->vm_start, vma->vm_end,
-					&mem_cgroup_count_precharge_walk);
-	}
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
+		walk_page_vma(vma, &mem_cgroup_count_precharge_walk);
 	up_read(&mm->mmap_sem);
 
 	precharge = mc.precharge;
@@ -6832,7 +6827,7 @@ static int mem_cgroup_move_charge_pte_ra
 				struct mm_walk *walk)
 {
 	int ret = 0;
-	struct vm_area_struct *vma = walk->private;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte;
 	spinlock_t *ptl;
 	enum mc_target_type target_type;
@@ -6933,6 +6928,10 @@ put:			/* get_mctgt_type() gets the page
 static void mem_cgroup_move_charge(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
+	struct mm_walk mem_cgroup_move_charge_walk = {
+		.pmd_entry = mem_cgroup_move_charge_pte_range,
+		.mm = mm,
+	};
 
 	lru_add_drain_all();
 retry:
@@ -6948,24 +6947,8 @@ retry:
 		cond_resched();
 		goto retry;
 	}
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		int ret;
-		struct mm_walk mem_cgroup_move_charge_walk = {
-			.pmd_entry = mem_cgroup_move_charge_pte_range,
-			.mm = mm,
-			.private = vma,
-		};
-		if (is_vm_hugetlb_page(vma))
-			continue;
-		ret = walk_page_range(vma->vm_start, vma->vm_end,
-						&mem_cgroup_move_charge_walk);
-		if (ret)
-			/*
-			 * means we have consumed all precharges and failed in
-			 * doing additional charge. Just abandon here.
-			 */
-			break;
-	}
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
+		walk_page_vma(vma, &mem_cgroup_move_charge_walk);
 	up_read(&mm->mmap_sem);
 }
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
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

