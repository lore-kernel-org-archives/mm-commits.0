From: akpm@linux-foundation.org
Subject: +
 mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
 added to -mm tree
Date: Wed, 11 Jun 2014 16:21:35 -0700
Message-ID: <5398e47f.fR/sJ7K2KCd3HDPZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbaFKXVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 19:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kirill@shutemov.name,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 16:21:35 -0700


The patch titled
     Subject: mm/pagewalk: move pmd_trans_huge_lock() from callbacks to common code
has been added to the -mm tree.  Its filename is
     mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch

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
Subject: mm/pagewalk: move pmd_trans_huge_lock() from callbacks to common code

Now all of current users of page table walker are canonicalized, i.e.
pmd_entry() handles only trans_pmd entry, and pte_entry() handles pte entry.
So we can factorize common code more.
This patch moves pmd_trans_huge_lock() in each pmd_entry() to pagewalk core.

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

 fs/proc/task_mmu.c |   67 ++++++++++++++-----------------------------
 mm/memcontrol.c    |   53 ++++++++++------------------------
 mm/pagewalk.c      |   25 +++++++++++++---
 3 files changed, 60 insertions(+), 85 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code
+++ a/fs/proc/task_mmu.c
@@ -502,14 +502,8 @@ static int smaps_pmd(pmd_t *pmd, unsigne
 			struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	spinlock_t *ptl;
-
-	if (pmd_trans_huge_lock(pmd, walk->vma, &ptl) == 1) {
-		smaps_pte((pte_t *)pmd, addr, addr + HPAGE_PMD_SIZE, walk);
-		spin_unlock(ptl);
-		mss->anonymous_thp += HPAGE_PMD_SIZE;
-	} else
-		walk->control = PTWALK_DOWN;
+	smaps_pte((pte_t *)pmd, addr, addr + HPAGE_PMD_SIZE, walk);
+	mss->anonymous_thp += HPAGE_PMD_SIZE;
 	return 0;
 }
 
@@ -1043,31 +1037,22 @@ static int pagemap_pmd(pmd_t *pmd, unsig
 	struct vm_area_struct *vma = walk->vma;
 	struct pagemapread *pm = walk->private;
 	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
-	spinlock_t *ptl;
+	int pmd_flags2;
 
-	if (!vma)
-		return err;
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		int pmd_flags2;
-
-		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(*pmd))
-			pmd_flags2 = __PM_SOFT_DIRTY;
-		else
-			pmd_flags2 = 0;
-
-		for (; addr != end; addr += PAGE_SIZE) {
-			unsigned long offset;
-
-			offset = (addr & ~PAGEMAP_WALK_MASK) >>
-					PAGE_SHIFT;
-			thp_pmd_to_pagemap_entry(&pme, pm, *pmd, offset, pmd_flags2);
-			err = add_to_pagemap(addr, &pme, pm);
-			if (err)
-				break;
-		}
-		spin_unlock(ptl);
-	} else
-		walk->control = PTWALK_DOWN;
+	if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(*pmd))
+		pmd_flags2 = __PM_SOFT_DIRTY;
+	else
+		pmd_flags2 = 0;
+
+	for (; addr != end; addr += PAGE_SIZE) {
+		unsigned long offset;
+
+		offset = (addr & ~PAGEMAP_WALK_MASK) >> PAGE_SHIFT;
+		thp_pmd_to_pagemap_entry(&pme, pm, *pmd, offset, pmd_flags2);
+		err = add_to_pagemap(addr, &pme, pm);
+		if (err)
+			break;
+	}
 	return err;
 }
 
@@ -1336,19 +1321,13 @@ static int gather_pmd_stats(pmd_t *pmd,
 {
 	struct numa_maps *md = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	spinlock_t *ptl;
+	pte_t huge_pte = *(pte_t *)pmd;
+	struct page *page;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		pte_t huge_pte = *(pte_t *)pmd;
-		struct page *page;
-
-		page = can_gather_numa_stats(huge_pte, vma, addr);
-		if (page)
-			gather_stats(page, md, pte_dirty(huge_pte),
-				     HPAGE_PMD_SIZE/PAGE_SIZE);
-		spin_unlock(ptl);
-	} else
-		walk->control = PTWALK_DOWN;
+	page = can_gather_numa_stats(huge_pte, vma, addr);
+	if (page)
+		gather_stats(page, md, pte_dirty(huge_pte),
+			     HPAGE_PMD_SIZE/PAGE_SIZE);
 	return 0;
 }
 #ifdef CONFIG_HUGETLB_PAGE
diff -puN mm/memcontrol.c~mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code mm/memcontrol.c
--- a/mm/memcontrol.c~mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code
+++ a/mm/memcontrol.c
@@ -6664,14 +6664,9 @@ static int mem_cgroup_count_precharge_pm
 					struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->vma;
-	spinlock_t *ptl;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
-			mc.precharge += HPAGE_PMD_NR;
-		spin_unlock(ptl);
-	} else
-		skip->control = PTWALK_DOWN;
+	if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
+		mc.precharge += HPAGE_PMD_NR;
 	return 0;
 }
 
@@ -6892,38 +6887,22 @@ static int mem_cgroup_move_charge_pmd(pm
 	struct page *page;
 	struct page_cgroup *pc;
 
-	/*
-	 * We don't take compound_lock() here but no race with splitting thp
-	 * happens because:
-	 *  - if pmd_trans_huge_lock() returns 1, the relevant thp is not
-	 *    under splitting, which means there's no concurrent thp split,
-	 *  - if another thread runs into split_huge_page() just after we
-	 *    entered this if-block, the thread must wait for page table lock
-	 *    to be unlocked in __split_huge_page_splitting(), where the main
-	 *    part of thp split is not executed yet.
-	 */
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		if (mc.precharge < HPAGE_PMD_NR) {
-			spin_unlock(ptl);
-			return 0;
-		}
-		target_type = get_mctgt_type_thp(vma, addr, *pmd, &target);
-		if (target_type == MC_TARGET_PAGE) {
-			page = target.page;
-			if (!isolate_lru_page(page)) {
-				pc = lookup_page_cgroup(page);
-				if (!mem_cgroup_move_account(page, HPAGE_PMD_NR,
-							pc, mc.from, mc.to)) {
-					mc.precharge -= HPAGE_PMD_NR;
-					mc.moved_charge += HPAGE_PMD_NR;
-				}
-				putback_lru_page(page);
+	if (mc.precharge < HPAGE_PMD_NR)
+		return 0;
+	target_type = get_mctgt_type_thp(vma, addr, *pmd, &target);
+	if (target_type == MC_TARGET_PAGE) {
+		page = target.page;
+		if (!isolate_lru_page(page)) {
+			pc = lookup_page_cgroup(page);
+			if (!mem_cgroup_move_account(page, HPAGE_PMD_NR,
+						     pc, mc.from, mc.to)) {
+				mc.precharge -= HPAGE_PMD_NR;
+				mc.moved_charge += HPAGE_PMD_NR;
 			}
-			put_page(page);
+			putback_lru_page(page);
 		}
-		spin_unlock(ptl);
-	} else
-		walk->control = PTWALK_DOWN;
+		put_page(page);
+	}
 	return 0;
 }
 
diff -puN mm/pagewalk.c~mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code mm/pagewalk.c
--- a/mm/pagewalk.c~mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code
+++ a/mm/pagewalk.c
@@ -61,6 +61,7 @@ static int walk_pmd_range(pud_t *pud, un
 	pmd_t *pmd;
 	unsigned long next;
 	int err = 0;
+	spinlock_t *ptl;
 
 	pmd = pmd_offset(pud, addr);
 	do {
@@ -75,8 +76,22 @@ again:
 			continue;
 		}
 
+		/*
+		 * We don't take compound_lock() here but no race with splitting
+		 * thp happens because:
+		 *  - if pmd_trans_huge_lock() returns 1, the relevant thp is
+		 *    not under splitting, which means there's no concurrent
+		 *    thp split,
+		 *  - if another thread runs into split_huge_page() just after
+		 *    we entered this if-block, the thread must wait for page
+		 *    table lock to be unlocked in __split_huge_page_splitting(),
+		 *    where the main part of thp split is not executed yet.
+		 */
 		if (walk->pmd_entry) {
-			err = walk->pmd_entry(pmd, addr, next, walk);
+			if (pmd_trans_huge_lock(pmd, walk->vma, &ptl) == 1) {
+				err = walk->pmd_entry(pmd, addr, next, walk);
+				spin_unlock(ptl);
+			}
 			if (err)
 				break;
 			switch (get_reset_walk_control(walk)) {
@@ -286,9 +301,11 @@ static int __walk_page_range(unsigned lo
  * outside a vma. If you want to access to some caller-specific data from
  * callbacks, @walk->private should be helpful.
  *
- * The callers should hold @walk->mm->mmap_sem. Note that the lower level
- * iterators can take page table lock in lowest level iteration and/or
- * in split_huge_page_pmd().
+ * Locking:
+ *   Callers of walk_page_range() and walk_page_vma() should hold
+ *   @walk->mm->mmap_sem, because these function traverse vma list and/or
+ *   access to vma's data. And page table lock is held during running
+ *   pmd_entry() and pte_entry().
  */
 int walk_page_range(unsigned long start, unsigned long end,
 		    struct mm_walk *walk)
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
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
madvise-cleanup-swapin_walk_pmd_entry.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

