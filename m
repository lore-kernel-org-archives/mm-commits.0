From: akpm@linux-foundation.org
Subject: [obsolete] mm-hugetlb-use-vma_resv_map-map-types-update.patch
 removed from -mm tree
Date: Mon, 03 Feb 2014 16:36:27 -0800
Message-ID: <52f0360b.ZeWfYDrO+DVQmUQy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBDAg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 19:36:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [obsolete] mm-hugetlb-use-vma_resv_map-map-types-update.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 16:36:27 -0800


The patch titled
     Subject: mm, hugetlb: use vma_resv_map() map types
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-vma_resv_map-map-types-update.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: use vma_resv_map() map types

Util now, we get a resv_map by two ways according to each mapping type.
This makes code dirty and unreadable. Unify it.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-vma_resv_map-map-types-update mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-vma_resv_map-map-types-update
+++ a/mm/hugetlb.c
@@ -2275,21 +2275,26 @@ static void hugetlb_vm_op_close(struct v
 	struct hstate *h = hstate_vma(vma);
 	struct resv_map *resv = vma_resv_map(vma);
 	struct hugepage_subpool *spool = subpool_vma(vma);
-	unsigned long reserve, start, end;
+	unsigned long reserve;
+	unsigned long start;
+	unsigned long end;
 
-	if (!resv || !is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+	if (!resv)
 		return;
 
-	start = vma_hugecache_offset(h, vma, vma->vm_start);
-	end = vma_hugecache_offset(h, vma, vma->vm_end);
-
-	reserve = (end - start) - region_count(resv, start, end);
-
-	kref_put(&resv->refs, resv_map_release);
-
-	if (reserve) {
-		hugetlb_acct_memory(h, -reserve);
-		hugepage_subpool_put_pages(spool, reserve);
+	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+		start = vma_hugecache_offset(h, vma, vma->vm_start);
+		end = vma_hugecache_offset(h, vma, vma->vm_end);
+
+		reserve = (end - start) -
+			region_count(resv, start, end);
+
+		kref_put(&resv->refs, resv_map_release);
+
+		if (reserve) {
+			hugetlb_acct_memory(h, -reserve);
+			hugepage_subpool_put_pages(spool, reserve);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

kthread-ensure-locality-of-task_struct-allocations.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-use-vma_resv_map-map-types-update-fix.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlb-improve-page-fault-scalability-update.patch

