From: akpm@linux-foundation.org
Subject: + mm-hugetlb-remove-resv_map_put.patch added to -mm tree
Date: Fri, 31 Jan 2014 13:08:42 -0800
Message-ID: <52ec10da.IqCbss+Wu3Z162Xr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaVIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 16:08:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: + mm-hugetlb-remove-resv_map_put.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 13:08:42 -0800


The patch titled
     Subject: mm, hugetlb: remove resv_map_put
has been added to the -mm tree.  Its filename is
     mm-hugetlb-remove-resv_map_put.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-remove-resv_map_put.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-remove-resv_map_put.patch

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
Subject: mm, hugetlb: remove resv_map_put

This is a preparation patch to unify the use of vma_resv_map() regardless
of the map type.  This patch prepares it by removing resv_map_put(), which
only works for HPAGE_RESV_OWNER's resv_map, not for all resv_maps.

[davidlohr@hp.com: update changelog]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-remove-resv_map_put mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-remove-resv_map_put
+++ a/mm/hugetlb.c
@@ -2275,15 +2275,6 @@ static void hugetlb_vm_op_open(struct vm
 		kref_get(&resv->refs);
 }
 
-static void resv_map_put(struct vm_area_struct *vma)
-{
-	struct resv_map *resv = vma_resv_map(vma);
-
-	if (!resv)
-		return;
-	kref_put(&resv->refs, resv_map_release);
-}
-
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 {
 	struct hstate *h = hstate_vma(vma);
@@ -2300,7 +2291,7 @@ static void hugetlb_vm_op_close(struct v
 		reserve = (end - start) -
 			region_count(resv, start, end);
 
-		resv_map_put(vma);
+		kref_put(&resv->refs, resv_map_release);
 
 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
@@ -3249,8 +3240,8 @@ int hugetlb_reserve_pages(struct inode *
 		region_add(resv_map, from, to);
 	return 0;
 out_err:
-	if (vma)
-		resv_map_put(vma);
+	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+		kref_put(&resv_map->refs, resv_map_release);
 	return ret;
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch

