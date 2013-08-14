From: akpm@linux-foundation.org
Subject: + mm-hugetlb-change-variable-name-reservations-to-resv.patch
 added to -mm tree
Date: Wed, 14 Aug 2013 16:21:11 -0700
Message-ID: <520c10e7.rY+NhzykE2zb/Jmi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab3HNXVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 19:21:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, dhillf@gmail.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: + mm-hugetlb-change-variable-name-reservations-to-resv.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,dhillf@gmail.com,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 16:21:11 -0700


The patch titled
     Subject: mm, hugetlb: change variable name reservations to resv
has been added to the -mm tree.  Its filename is
     mm-hugetlb-change-variable-name-reservations-to-resv.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-change-variable-name-reservations-to-resv.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-change-variable-name-reservations-to-resv.patch

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
mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
mm-move-pgtable-related-functions-to-right-place.patch
swap-clean-up-ifdef-in-page_mapping.patch
mm-vmalloc-remove-useless-variable-in-vmap_block.patch
mm-vmalloc-use-well-defined-find_last_bit-func.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
linux-next.patch

