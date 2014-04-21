From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlbc-add-cond_resched_lock-in-return_unused_surplus_pages.patch
 removed from -mm tree
Date: Mon, 21 Apr 2014 11:11:05 -0700
Message-ID: <53555f39.G5vSbnW/eM8qg+ZB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaDUSLG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 14:11:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, m.mizuma@jp.fujitsu.com

Subject: [merged] mm-hugetlbc-add-cond_resched_lock-in-return_unused_surplus_pages.patch removed from -mm tree
To: m.mizuma@jp.fujitsu.com,aneesh.kumar@linux.vnet.ibm.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 11:11:05 -0700


The patch titled
     Subject: mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-add-cond_resched_lock-in-return_unused_surplus_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Mizuma, Masayoshi" <m.mizuma@jp.fujitsu.com>
Subject: mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

soft lockup in freeing gigantic hugepage fixed in commit 55f67141a892 "mm:
hugetlb: fix softlockup when a large number of hugepages are freed." can
happen in return_unused_surplus_pages(), so let's fix it.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/hugetlb.c~mm-hugetlbc-add-cond_resched_lock-in-return_unused_surplus_pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-add-cond_resched_lock-in-return_unused_surplus_pages
+++ a/mm/hugetlb.c
@@ -1172,6 +1172,7 @@ static void return_unused_surplus_pages(
 	while (nr_pages--) {
 		if (!free_pool_huge_page(h, &node_states[N_MEMORY], 1))
 			break;
+		cond_resched_lock(&hugetlb_lock);
 	}
 }
 
_

Patches currently in -mm which might be from m.mizuma@jp.fujitsu.com are


