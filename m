From: akpm@linux-foundation.org
Subject: + madvise-redefine-callback-functions-for-page-table-walker.patch added to -mm tree
Date: Mon, 10 Feb 2014 14:42:21 -0800
Message-ID: <52f955cd.wEKIGsva+Y180J1z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaBJWmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:42:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mpm@selenic.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cpw@sgi.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: + madvise-redefine-callback-functions-for-page-table-walker.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,cpw@sgi.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,mpm@selenic.com,riel@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:42:21 -0800


The patch titled
     Subject: madvise: redefine callback functions for page table walker
has been added to the -mm tree.  Its filename is
     madvise-redefine-callback-functions-for-page-table-walker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/madvise-redefine-callback-functions-for-page-table-walker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/madvise-redefine-callback-functions-for-page-table-walker.patch

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
Subject: madvise: redefine callback functions for page table walker

swapin_walk_pmd_entry() is defined as pmd_entry(), but it has no code
about pmd handling (except pmd_none_or_trans_huge_or_clear_bad, but the
same check are now done in core page table walk code).  So let's move this
function on pte_entry() as swapin_walk_pte_entry().

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

 mm/madvise.c |   43 +++++++++++++------------------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff -puN mm/madvise.c~madvise-redefine-callback-functions-for-page-table-walker mm/madvise.c
--- a/mm/madvise.c~madvise-redefine-callback-functions-for-page-table-walker
+++ a/mm/madvise.c
@@ -135,38 +135,22 @@ out:
 }
 
 #ifdef CONFIG_SWAP
-static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
+static int swapin_walk_pte_entry(pte_t *pte, unsigned long start,
 	unsigned long end, struct mm_walk *walk)
 {
-	pte_t *orig_pte;
-	struct vm_area_struct *vma = walk->private;
-	unsigned long index;
+	swp_entry_t entry;
+	struct page *page;
+	struct vm_area_struct *vma = walk->vma;
 
-	if (pmd_none_or_trans_huge_or_clear_bad(pmd))
+	if (pte_present(*pte) || pte_none(*pte) || pte_file(*pte))
 		return 0;
-
-	for (index = start; index != end; index += PAGE_SIZE) {
-		pte_t pte;
-		swp_entry_t entry;
-		struct page *page;
-		spinlock_t *ptl;
-
-		orig_pte = pte_offset_map_lock(vma->vm_mm, pmd, start, &ptl);
-		pte = *(orig_pte + ((index - start) / PAGE_SIZE));
-		pte_unmap_unlock(orig_pte, ptl);
-
-		if (pte_present(pte) || pte_none(pte) || pte_file(pte))
-			continue;
-		entry = pte_to_swp_entry(pte);
-		if (unlikely(non_swap_entry(entry)))
-			continue;
-
-		page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
-								vma, index);
-		if (page)
-			page_cache_release(page);
-	}
-
+	entry = pte_to_swp_entry(*pte);
+	if (unlikely(non_swap_entry(entry)))
+		return 0;
+	page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
+				     vma, start);
+	if (page)
+		page_cache_release(page);
 	return 0;
 }
 
@@ -175,8 +159,7 @@ static void force_swapin_readahead(struc
 {
 	struct mm_walk walk = {
 		.mm = vma->vm_mm,
-		.pmd_entry = swapin_walk_pmd_entry,
-		.private = vma,
+		.pte_entry = swapin_walk_pte_entry,
 	};
 
 	walk_page_range(start, end, &walk);
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

