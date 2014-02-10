From: akpm@linux-foundation.org
Subject: +
 numa_maps-redefine-callback-functions-for-page-table-walker.patch added to
 -mm tree
Date: Mon, 10 Feb 2014 14:42:18 -0800
Message-ID: <52f955ca.1dsiK14v9nflRH/c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaBJWmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:42:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mpm@selenic.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cpw@sgi.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: + numa_maps-redefine-callback-functions-for-page-table-walker.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,cpw@sgi.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,mpm@selenic.com,riel@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:42:18 -0800


The patch titled
     Subject: numa_maps: redefine callback functions for page table walker
has been added to the -mm tree.  Its filename is
     numa_maps-redefine-callback-functions-for-page-table-walker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/numa_maps-redefine-callback-functions-for-page-table-walker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/numa_maps-redefine-callback-functions-for-page-table-walker.patch

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
Subject: numa_maps: redefine callback functions for page table walker

gather_pte_stats() connected to pmd_entry() does both of pmd loop and pte
loop.  So this patch moves pte part into pte_entry().

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

 fs/proc/task_mmu.c |   54 ++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff -puN fs/proc/task_mmu.c~numa_maps-redefine-callback-functions-for-page-table-walker fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~numa_maps-redefine-callback-functions-for-page-table-walker
+++ a/fs/proc/task_mmu.c
@@ -1193,7 +1193,6 @@ const struct file_operations proc_pagema
 #ifdef CONFIG_NUMA
 
 struct numa_maps {
-	struct vm_area_struct *vma;
 	unsigned long pages;
 	unsigned long anon;
 	unsigned long active;
@@ -1259,43 +1258,41 @@ static struct page *can_gather_numa_stat
 	return page;
 }
 
-static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
+static int gather_pte_stats(pte_t *pte, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
-	struct numa_maps *md;
-	spinlock_t *ptl;
-	pte_t *orig_pte;
-	pte_t *pte;
+	struct numa_maps *md = walk->private;
 
-	md = walk->private;
+	struct page *page = can_gather_numa_stats(*pte, walk->vma, addr);
+	if (!page)
+		return 0;
+	gather_stats(page, md, pte_dirty(*pte), 1);
+	return 0;
+}
 
-	if (pmd_trans_huge_lock(pmd, md->vma, &ptl) == 1) {
+static int gather_pmd_stats(pmd_t *pmd, unsigned long addr,
+		unsigned long end, struct mm_walk *walk)
+{
+	struct numa_maps *md = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	spinlock_t *ptl;
+
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		pte_t huge_pte = *(pte_t *)pmd;
 		struct page *page;
 
-		page = can_gather_numa_stats(huge_pte, md->vma, addr);
+		page = can_gather_numa_stats(huge_pte, vma, addr);
 		if (page)
 			gather_stats(page, md, pte_dirty(huge_pte),
 				     HPAGE_PMD_SIZE/PAGE_SIZE);
 		spin_unlock(ptl);
-		return 0;
+		/* don't call gather_pte_stats() */
+		walk->skip = 1;
 	}
-
-	if (pmd_trans_unstable(pmd))
-		return 0;
-	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	do {
-		struct page *page = can_gather_numa_stats(*pte, md->vma, addr);
-		if (!page)
-			continue;
-		gather_stats(page, md, pte_dirty(*pte), 1);
-
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	pte_unmap_unlock(orig_pte, ptl);
 	return 0;
 }
 #ifdef CONFIG_HUGETLB_PAGE
-static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
+static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
 	struct numa_maps *md;
@@ -1314,7 +1311,7 @@ static int gather_hugetbl_stats(pte_t *p
 }
 
 #else
-static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
+static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
 	return 0;
@@ -1344,12 +1341,12 @@ static int show_numa_map(struct seq_file
 	/* Ensure we start with an empty set of numa_maps statistics. */
 	memset(md, 0, sizeof(*md));
 
-	md->vma = vma;
-
-	walk.hugetlb_entry = gather_hugetbl_stats;
-	walk.pmd_entry = gather_pte_stats;
+	walk.hugetlb_entry = gather_hugetlb_stats;
+	walk.pmd_entry = gather_pmd_stats;
+	walk.pte_entry = gather_pte_stats;
 	walk.private = md;
 	walk.mm = mm;
+	walk.vma = vma;
 
 	pol = get_vma_policy(task, vma, vma->vm_start);
 	mpol_to_str(buffer, sizeof(buffer), pol);
@@ -1380,6 +1377,7 @@ static int show_numa_map(struct seq_file
 	if (is_vm_hugetlb_page(vma))
 		seq_printf(m, " huge");
 
+	/* mmap_sem is held by m_start */
 	walk_page_range(vma->vm_start, vma->vm_end, &walk);
 
 	if (!md->pages)
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

