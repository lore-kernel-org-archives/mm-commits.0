From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-clean-up-alloc_huge_page.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:43:07 -0700
Message-ID: <5232194b.TEoeJ6rqB5k7QPpd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3ILTnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, davidlohr.bueso@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-clean-up-alloc_huge_page.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr.bueso@hp.com,dhillf@gmail.com,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:07 -0700


The patch titled
     Subject: mm, hugetlb: clean-up alloc_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-clean-up-alloc_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: clean-up alloc_huge_page()

Unify successful allocation paths to make the code more readable.  There
are no functional changes.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-clean-up-alloc_huge_page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-clean-up-alloc_huge_page
+++ a/mm/hugetlb.c
@@ -1166,12 +1166,7 @@ static struct page *alloc_huge_page(stru
 	}
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
-	if (page) {
-		/* update page cgroup details */
-		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h),
-					     h_cg, page);
-		spin_unlock(&hugetlb_lock);
-	} else {
+	if (!page) {
 		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
@@ -1182,11 +1177,11 @@ static struct page *alloc_huge_page(stru
 			return ERR_PTR(-ENOSPC);
 		}
 		spin_lock(&hugetlb_lock);
-		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h),
-					     h_cg, page);
 		list_move(&page->lru, &h->hugepage_activelist);
-		spin_unlock(&hugetlb_lock);
+		/* Fall through */
 	}
+	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
+	spin_unlock(&hugetlb_lock);
 
 	set_page_private(page, (unsigned long)spool);
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

