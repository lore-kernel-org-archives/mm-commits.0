From: akpm@linux-foundation.org
Subject: + smaps-redefine-callback-functions-for-page-table-walker.patch
 added to -mm tree
Date: Mon, 10 Feb 2014 14:42:12 -0800
Message-ID: <52f955c4.ejcqAKrb+I4AZvRf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbaBJWmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:42:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mpm@selenic.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cpw@sgi.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: + smaps-redefine-callback-functions-for-page-table-walker.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,cpw@sgi.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,mpm@selenic.com,riel@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:42:12 -0800


The patch titled
     Subject: smaps: redefine callback functions for page table walker
has been added to the -mm tree.  Its filename is
     smaps-redefine-callback-functions-for-page-table-walker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smaps-redefine-callback-functions-for-page-table-walker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smaps-redefine-callback-functions-for-page-table-walker.patch

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
Subject: smaps: redefine callback functions for page table walker

smaps_pte_range() connected to pmd_entry() does both of pmd loop and pte
loop.  So this patch moves pte part into smaps_pte() on pte_entry() as
expected by the name.

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

 fs/proc/task_mmu.c |   47 +++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-redefine-callback-functions-for-page-table-walker fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-redefine-callback-functions-for-page-table-walker
+++ a/fs/proc/task_mmu.c
@@ -423,7 +423,6 @@ const struct file_operations proc_tid_ma
 
 #ifdef CONFIG_PROC_PAGE_MONITOR
 struct mem_size_stats {
-	struct vm_area_struct *vma;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -437,15 +436,16 @@ struct mem_size_stats {
 	u64 pss;
 };
 
-
-static void smaps_pte_entry(pte_t ptent, unsigned long addr,
-		unsigned long ptent_size, struct mm_walk *walk)
+static int smaps_pte(pte_t *pte, unsigned long addr, unsigned long end,
+			struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	pgoff_t pgoff = linear_page_index(vma, addr);
 	struct page *page = NULL;
 	int mapcount;
+	pte_t ptent = *pte;
+	unsigned long ptent_size = end - addr;
 
 	if (pte_present(ptent)) {
 		page = vm_normal_page(vma, addr, ptent);
@@ -462,7 +462,7 @@ static void smaps_pte_entry(pte_t ptent,
 	}
 
 	if (!page)
-		return;
+		return 0;
 
 	if (PageAnon(page))
 		mss->anonymous += ptent_size;
@@ -488,35 +488,22 @@ static void smaps_pte_entry(pte_t ptent,
 			mss->private_clean += ptent_size;
 		mss->pss += (ptent_size << PSS_SHIFT);
 	}
+	return 0;
 }
 
-static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			   struct mm_walk *walk)
+static int smaps_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
+			struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
-	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
+	if (pmd_trans_huge_lock(pmd, walk->vma, &ptl) == 1) {
+		smaps_pte((pte_t *)pmd, addr, addr + HPAGE_PMD_SIZE, walk);
 		spin_unlock(ptl);
 		mss->anonymous_thp += HPAGE_PMD_SIZE;
-		return 0;
+		/* don't call smaps_pte() */
+		walk->skip = 1;
 	}
-
-	if (pmd_trans_unstable(pmd))
-		return 0;
-	/*
-	 * The mmap_sem held all the way back in m_start() is what
-	 * keeps khugepaged out of here and from collapsing things
-	 * in here.
-	 */
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE)
-		smaps_pte_entry(*pte, addr, PAGE_SIZE, walk);
-	pte_unmap_unlock(pte - 1, ptl);
-	cond_resched();
 	return 0;
 }
 
@@ -581,16 +568,16 @@ static int show_smap(struct seq_file *m,
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
 	struct mm_walk smaps_walk = {
-		.pmd_entry = smaps_pte_range,
+		.pmd_entry = smaps_pmd,
+		.pte_entry = smaps_pte,
 		.mm = vma->vm_mm,
+		.vma = vma,
 		.private = &mss,
 	};
 
 	memset(&mss, 0, sizeof mss);
-	mss.vma = vma;
 	/* mmap_sem is held in m_start */
-	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
+	walk_page_vma(vma, &smaps_walk);
 
 	show_map_vma(m, vma, is_pid);
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-memory-failurec-move-refcount-only-in-mf_count_increased.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch

