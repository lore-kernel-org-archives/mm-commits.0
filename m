From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-subpool-accounting-handling.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:03 -0700
Message-ID: <52321983.v/cniEf3YQwa58No%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, dhillf@gmail.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-fix-subpool-accounting-handling.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,dhillf@gmail.com,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:03 -0700


The patch titled
     Subject: mm, hugetlb: fix subpool accounting handling
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-subpool-accounting-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: fix subpool accounting handling

If we alloc hugepage with avoid_reserve, we don't dequeue reserved one. 
So, we should check subpool counter when avoid_reserve.  This patch
implement it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-subpool-accounting-handling mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-subpool-accounting-handling
+++ a/mm/hugetlb.c
@@ -1164,13 +1164,14 @@ static struct page *alloc_huge_page(stru
 	chg = vma_needs_reservation(h, vma, addr);
 	if (chg < 0)
 		return ERR_PTR(-ENOMEM);
-	if (chg)
-		if (hugepage_subpool_get_pages(spool, chg))
+	if (chg || avoid_reserve)
+		if (hugepage_subpool_get_pages(spool, 1))
 			return ERR_PTR(-ENOSPC);
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
 	if (ret) {
-		hugepage_subpool_put_pages(spool, chg);
+		if (chg || avoid_reserve)
+			hugepage_subpool_put_pages(spool, 1);
 		return ERR_PTR(-ENOSPC);
 	}
 	spin_lock(&hugetlb_lock);
@@ -1182,7 +1183,8 @@ static struct page *alloc_huge_page(stru
 			hugetlb_cgroup_uncharge_cgroup(idx,
 						       pages_per_huge_page(h),
 						       h_cg);
-			hugepage_subpool_put_pages(spool, chg);
+			if (chg || avoid_reserve)
+				hugepage_subpool_put_pages(spool, 1);
 			return ERR_PTR(-ENOSPC);
 		}
 		spin_lock(&hugetlb_lock);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

