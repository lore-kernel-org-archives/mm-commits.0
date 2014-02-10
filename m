From: akpm@linux-foundation.org
Subject: + pagewalk-remove-argument-hmask-from-hugetlb_entry.patch added
 to -mm tree
Date: Mon, 10 Feb 2014 14:42:23 -0800
Message-ID: <52f955cf.SfZGw2NhgQWJBZ/n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaBJWmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:42:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mpm@selenic.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cpw@sgi.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: + pagewalk-remove-argument-hmask-from-hugetlb_entry.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,cpw@sgi.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,mpm@selenic.com,riel@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:42:23 -0800


The patch titled
     Subject: pagewalk: remove argument hmask from hugetlb_entry()
has been added to the -mm tree.  Its filename is
     pagewalk-remove-argument-hmask-from-hugetlb_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagewalk-remove-argument-hmask-from-hugetlb_entry.patch

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

 fs/proc/task_mmu.c |   12 ++++++------
 include/linux/mm.h |    5 ++---
 mm/pagewalk.c      |    2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff -puN fs/proc/task_mmu.c~pagewalk-remove-argument-hmask-from-hugetlb_entry fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagewalk-remove-argument-hmask-from-hugetlb_entry
+++ a/fs/proc/task_mmu.c
@@ -1022,8 +1022,7 @@ static void huge_pte_to_pagemap_entry(pa
 }
 
 /* This function walks within one hugetlb entry in the single call */
-static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
-				 unsigned long addr, unsigned long end,
+static int pagemap_hugetlb(pte_t *pte, unsigned long addr, unsigned long end,
 				 struct mm_walk *walk)
 {
 	struct pagemapread *pm = walk->private;
@@ -1031,6 +1030,7 @@ static int pagemap_hugetlb_range(pte_t *
 	int err = 0;
 	int flags2;
 	pagemap_entry_t pme;
+	unsigned long hmask;
 
 	WARN_ON_ONCE(!vma);
 
@@ -1292,8 +1292,8 @@ static int gather_pmd_stats(pmd_t *pmd,
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
@@ -1311,8 +1311,8 @@ static int gather_hugetlb_stats(pte_t *p
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
@@ -1099,9 +1099,8 @@ struct mm_walk {
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

