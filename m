From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlbc-add-null-check-of-return-value-of-huge_pte_offset.patch removed from -mm tree
Date: Tue, 08 Apr 2014 13:31:07 -0700
Message-ID: <53445c8b.zow3NbjMgxPudYED%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaDHUbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:31:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, mgorman@suse.de, kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-hugetlbc-add-null-check-of-return-value-of-huge_pte_offset.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,kirill.shutemov@linux.intel.com,mgorman@suse.de,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:31:07 -0700


The patch titled
     Subject: mm/hugetlb.c: add NULL check of return value of huge_pte_offset
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-add-null-check-of-return-value-of-huge_pte_offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb.c: add NULL check of return value of huge_pte_offset

huge_pte_offset() could return NULL, so we need NULL check to avoid
potential NULL pointer dereferences.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-add-null-check-of-return-value-of-huge_pte_offset mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-add-null-check-of-return-value-of-huge_pte_offset
+++ a/mm/hugetlb.c
@@ -2690,7 +2690,8 @@ retry_avoidcopy:
 				BUG_ON(huge_pte_none(pte));
 				spin_lock(ptl);
 				ptep = huge_pte_offset(mm, address & huge_page_mask(h));
-				if (likely(pte_same(huge_ptep_get(ptep), pte)))
+				if (likely(ptep &&
+					   pte_same(huge_ptep_get(ptep), pte)))
 					goto retry_avoidcopy;
 				/*
 				 * race occurs while re-acquiring page table
@@ -2734,7 +2735,7 @@ retry_avoidcopy:
 	 */
 	spin_lock(ptl);
 	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
-	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
+	if (likely(ptep && pte_same(huge_ptep_get(ptep), pte))) {
 		ClearPagePrivate(new_page);
 
 		/* Break COW */
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
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
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-pagewalkc-move-pte-null-check.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

