From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:57 -0700
Message-ID: <5390ca99.zvWhrBi0NZohOGKM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaFETw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, davidlohr@hp.com, aneesh.kumar@linux.vnet.ibm.com, nasa4836@gmail.com

Subject: [merged] mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch removed from -mm tree
To: nasa4836@gmail.com,aneesh.kumar@linux.vnet.ibm.com,davidlohr@hp.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:57 -0700


The patch titled
     Subject: mm, hugetlb: move the error handle logic out of normal code path
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm, hugetlb: move the error handle logic out of normal code path

alloc_huge_page() now mixes normal code path with error handle logic. 
This patches move out the error handle logic, to make normal code path
more clean and redue code duplicate.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path
+++ a/mm/hugetlb.c
@@ -1386,24 +1386,17 @@ static struct page *alloc_huge_page(stru
 			return ERR_PTR(-ENOSPC);
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret) {
-		if (chg || avoid_reserve)
-			hugepage_subpool_put_pages(spool, 1);
-		return ERR_PTR(-ENOSPC);
-	}
+	if (ret)
+		goto out_subpool_put;
+
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, chg);
 	if (!page) {
 		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
-		if (!page) {
-			hugetlb_cgroup_uncharge_cgroup(idx,
-						       pages_per_huge_page(h),
-						       h_cg);
-			if (chg || avoid_reserve)
-				hugepage_subpool_put_pages(spool, 1);
-			return ERR_PTR(-ENOSPC);
-		}
+		if (!page)
+			goto out_uncharge_cgroup;
+
 		spin_lock(&hugetlb_lock);
 		list_move(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
@@ -1415,6 +1408,13 @@ static struct page *alloc_huge_page(stru
 
 	vma_commit_reservation(h, vma, addr);
 	return page;
+
+out_uncharge_cgroup:
+	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
+out_subpool_put:
+	if (chg || avoid_reserve)
+		hugepage_subpool_put_pages(spool, 1);
+	return ERR_PTR(-ENOSPC);
 }
 
 /*
_

Patches currently in -mm which might be from nasa4836@gmail.com are

origin.patch
linux-next.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch

