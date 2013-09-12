From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-change-variable-name-reservations-to-resv.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:01 -0700
Message-ID: <52321981.sFnvITAkP3wQXlpC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, dhillf@gmail.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-change-variable-name-reservations-to-resv.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,dhillf@gmail.com,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:01 -0700


The patch titled
     Subject: mm, hugetlb: change variable name reservations to resv
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-change-variable-name-reservations-to-resv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: change variable name reservations to resv

'reservations' is so long name as a variable and we use 'resv_map' to
represent 'struct resv_map' in other place.  To reduce confusion and
unreadability, change it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-change-variable-name-reservations-to-resv mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-change-variable-name-reservations-to-resv
+++ a/mm/hugetlb.c
@@ -1115,9 +1115,9 @@ static long vma_needs_reservation(struct
 	} else  {
 		long err;
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
-		struct resv_map *reservations = vma_resv_map(vma);
+		struct resv_map *resv = vma_resv_map(vma);
 
-		err = region_chg(&reservations->regions, idx, idx + 1);
+		err = region_chg(&resv->regions, idx, idx + 1);
 		if (err < 0)
 			return err;
 		return 0;
@@ -1135,10 +1135,10 @@ static void vma_commit_reservation(struc
 
 	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
-		struct resv_map *reservations = vma_resv_map(vma);
+		struct resv_map *resv = vma_resv_map(vma);
 
 		/* Mark this page used in the map. */
-		region_add(&reservations->regions, idx, idx + 1);
+		region_add(&resv->regions, idx, idx + 1);
 	}
 }
 
@@ -2188,7 +2188,7 @@ out:
 
 static void hugetlb_vm_op_open(struct vm_area_struct *vma)
 {
-	struct resv_map *reservations = vma_resv_map(vma);
+	struct resv_map *resv = vma_resv_map(vma);
 
 	/*
 	 * This new VMA should share its siblings reservation map if present.
@@ -2198,34 +2198,34 @@ static void hugetlb_vm_op_open(struct vm
 	 * after this open call completes.  It is therefore safe to take a
 	 * new reference here without additional locking.
 	 */
-	if (reservations)
-		kref_get(&reservations->refs);
+	if (resv)
+		kref_get(&resv->refs);
 }
 
 static void resv_map_put(struct vm_area_struct *vma)
 {
-	struct resv_map *reservations = vma_resv_map(vma);
+	struct resv_map *resv = vma_resv_map(vma);
 
-	if (!reservations)
+	if (!resv)
 		return;
-	kref_put(&reservations->refs, resv_map_release);
+	kref_put(&resv->refs, resv_map_release);
 }
 
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 {
 	struct hstate *h = hstate_vma(vma);
-	struct resv_map *reservations = vma_resv_map(vma);
+	struct resv_map *resv = vma_resv_map(vma);
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	unsigned long reserve;
 	unsigned long start;
 	unsigned long end;
 
-	if (reservations) {
+	if (resv) {
 		start = vma_hugecache_offset(h, vma, vma->vm_start);
 		end = vma_hugecache_offset(h, vma, vma->vm_end);
 
 		reserve = (end - start) -
-			region_count(&reservations->regions, start, end);
+			region_count(&resv->regions, start, end);
 
 		resv_map_put(vma);
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

