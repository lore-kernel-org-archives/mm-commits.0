From: akpm@linux-foundation.org
Subject: [nacked] pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
 removed from -mm tree
Date: Mon, 16 Jun 2014 16:32:14 -0700
Message-ID: <539f7e7e.JhmZcfttELuC+/oR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaFPXcP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mpm@selenic.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cpw@sgi.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: pagewalk: remove argument hmask from hugetlb_entry()
has been removed from the -mm tree.  Its filename was
     pagewalk-remove-argument-hmask-from-hugetlb_entry.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: pagewalk: remove argument hmask from hugetlb_entry()

hugetlb_entry() doesn't use the argument hmask any more, so let's remove
it now.

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

 fs/proc/task_mmu.c |   14 +++++++-------
 include/linux/mm.h |    5 ++---
 mm/pagewalk.c      |    2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff -puN fs/proc/task_mmu.c~pagewalk-remove-argument-hmask-from-hugetlb_entry fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagewalk-remove-argument-hmask-from-hugetlb_entry
+++ a/fs/proc/task_mmu.c
@@ -1032,15 +1032,15 @@ static void huge_pte_to_pagemap_entry(pa
 }
 
 /* This function walks within one hugetlb entry in the single call */
-static int pagemap_hugetlb(pte_t *pte, unsigned long hmask,
-				 unsigned long addr, unsigned long end,
-				 struct mm_walk *walk)
+static int pagemap_hugetlb(pte_t *pte, unsigned long addr, unsigned long end,
+			   struct mm_walk *walk)
 {
 	struct pagemapread *pm = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	int err = 0;
 	int flags2;
 	pagemap_entry_t pme;
+	unsigned long hmask;
 
 	WARN_ON_ONCE(!vma);
 
@@ -1302,8 +1302,8 @@ static int gather_pmd_stats(pmd_t *pmd,
 	return 0;
 }
 #ifdef CONFIG_HUGETLB_PAGE
-static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
-		unsigned long addr, unsigned long end, struct mm_walk *walk)
+static int gather_hugetlb_stats(pte_t *pte, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
 {
 	struct numa_maps *md;
 	struct page *page;
@@ -1321,8 +1321,8 @@ static int gather_hugetlb_stats(pte_t *p
 }
 
 #else
-static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
-		unsigned long addr, unsigned long end, struct mm_walk *walk)
+static int gather_hugetlb_stats(pte_t *pte, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
 {
 	return 0;
 }
diff -puN include/linux/mm.h~pagewalk-remove-argument-hmask-from-hugetlb_entry include/linux/mm.h
--- a/include/linux/mm.h~pagewalk-remove-argument-hmask-from-hugetlb_entry
+++ a/include/linux/mm.h
@@ -1131,9 +1131,8 @@ struct mm_walk {
 			 unsigned long next, struct mm_walk *walk);
 	int (*pte_hole)(unsigned long addr, unsigned long next,
 			struct mm_walk *walk);
-	int (*hugetlb_entry)(pte_t *pte, unsigned long hmask,
-			     unsigned long addr, unsigned long next,
-			     struct mm_walk *walk);
+	int (*hugetlb_entry)(pte_t *pte, unsigned long addr,
+			unsigned long next, struct mm_walk *walk);
 	int (*test_walk)(unsigned long addr, unsigned long next,
 			struct mm_walk *walk);
 	struct mm_struct *mm;
diff -puN mm/pagewalk.c~pagewalk-remove-argument-hmask-from-hugetlb_entry mm/pagewalk.c
--- a/mm/pagewalk.c~pagewalk-remove-argument-hmask-from-hugetlb_entry
+++ a/mm/pagewalk.c
@@ -199,7 +199,7 @@ static int walk_hugetlb_range(unsigned l
 		 * in walk->hugetlb_entry().
 		 */
 		if (pte && walk->hugetlb_entry)
-			err = walk->hugetlb_entry(pte, hmask, addr, next, walk);
+			err = walk->hugetlb_entry(pte, addr, next, walk);
 		spin_unlock(ptl);
 		if (err)
 			break;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
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

