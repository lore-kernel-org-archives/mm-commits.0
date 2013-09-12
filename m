From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:03 -0700
Message-ID: <52321947.jErhJpcCM1qDe6Wq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3ILTnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, davidlohr.bueso@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr.bueso@hp.com,dhillf@gmail.com,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:03 -0700


The patch titled
     Subject: mm, hugetlb: move up the code which check availability of free huge page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: move up the code which check availability of free huge page

In this time we are holding a hugetlb_lock, so hstate values can't be
changed.  If we don't have any usable free huge page in this time, we
don't need to proceed with the processing.  So move this code up.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page
+++ a/mm/hugetlb.c
@@ -539,10 +539,6 @@ static struct page *dequeue_huge_page_vm
 	struct zoneref *z;
 	unsigned int cpuset_mems_cookie;
 
-retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
-	zonelist = huge_zonelist(vma, address,
-					htlb_alloc_mask, &mpol, &nodemask);
 	/*
 	 * A child process with MAP_PRIVATE mappings created by their parent
 	 * have no page reserves. This check ensures that reservations are
@@ -556,6 +552,11 @@ retry_cpuset:
 	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
 		goto err;
 
+retry_cpuset:
+	cpuset_mems_cookie = get_mems_allowed();
+	zonelist = huge_zonelist(vma, address,
+					htlb_alloc_mask, &mpol, &nodemask);
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						MAX_NR_ZONES - 1, nodemask) {
 		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask)) {
@@ -574,7 +575,6 @@ retry_cpuset:
 	return page;
 
 err:
-	mpol_cond_put(mpol);
 	return NULL;
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

