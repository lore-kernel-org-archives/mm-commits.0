From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:04 -0700
Message-ID: <20120326192804.A1FDDA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:41979 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2CZT2G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:06 -0400
Received: by vcbfk26 with SMTP id fk26so831226vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: cleanup duplicated code in unmapping vm range
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: hugetlb: cleanup duplicated code in unmapping vm range

Fix code duplication in __unmap_hugepage_range(), such as pte_page() and
huge_pte_none().

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range
+++ a/mm/hugetlb.c
@@ -2331,16 +2331,23 @@ void __unmap_hugepage_range(struct vm_ar
 		if (huge_pmd_unshare(mm, &address, ptep))
 			continue;
 
+		pte = huge_ptep_get(ptep);
+		if (huge_pte_none(pte))
+			continue;
+
+		/*
+		 * HWPoisoned hugepage is already unmapped and dropped reference
+		 */
+		if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
+			continue;
+
+		page = pte_page(pte);
 		/*
 		 * If a reference page is supplied, it is because a specific
 		 * page is being unmapped, not a range. Ensure the page we
 		 * are about to unmap is the actual page of interest.
 		 */
 		if (ref_page) {
-			pte = huge_ptep_get(ptep);
-			if (huge_pte_none(pte))
-				continue;
-			page = pte_page(pte);
 			if (page != ref_page)
 				continue;
 
@@ -2353,16 +2360,6 @@ void __unmap_hugepage_range(struct vm_ar
 		}
 
 		pte = huge_ptep_get_and_clear(mm, address, ptep);
-		if (huge_pte_none(pte))
-			continue;
-
-		/*
-		 * HWPoisoned hugepage is already unmapped and dropped reference
-		 */
-		if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
-			continue;
