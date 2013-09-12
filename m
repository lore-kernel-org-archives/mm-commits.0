From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:11 -0700
Message-ID: <5232194f.PByig/jTKifbVIaT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3ILTnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, davidlohr.bueso@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr.bueso@hp.com,dhillf@gmail.com,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:11 -0700


The patch titled
     Subject: mm, hugetlb: remove redundant list_empty check in gather_surplus_pages()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: remove redundant list_empty check in gather_surplus_pages()

If list is empty, list_for_each_entry_safe() doesn't do anything.  So,
this check is redundant.  Remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
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

 mm/hugetlb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages
+++ a/mm/hugetlb.c
@@ -1037,11 +1037,8 @@ free:
 	spin_unlock(&hugetlb_lock);
 
 	/* Free unnecessary surplus pages to the buddy allocator */
-	if (!list_empty(&surplus_list)) {
-		list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
-			put_page(page);
-		}
-	}
+	list_for_each_entry_safe(page, tmp, &surplus_list, lru)
+		put_page(page);
 	spin_lock(&hugetlb_lock);
 
 	return ret;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

