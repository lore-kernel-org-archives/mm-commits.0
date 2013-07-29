From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:07:45 -0700
Message-ID: <51f6e7b1./0PcyrX88VGM6EaO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3G2WHr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:07:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, davidlohr.bueso@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: + mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr.bueso@hp.com,dhillf@gmail.com,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:07:45 -0700


The patch titled
     Subject: mm, hugetlb: move up the code which check availability of free huge page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: move up the code which check availability of free huge page

In this time we are holding a hugetlb_lock, so hstate values can't be
changed.  If we don't have any usable free huge page in this time, we
don't need to proceede the processing.  So move this code up.

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

mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch

