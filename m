From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:17 -0700
Message-ID: <52321955.SdXxvVACLgrZbDRi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3ILTnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, davidlohr.bueso@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-remove-decrement_hugepage_resv_vma.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr.bueso@hp.com,dhillf@gmail.com,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:17 -0700


The patch titled
     Subject: mm, hugetlb: remove decrement_hugepage_resv_vma()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-decrement_hugepage_resv_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: remove decrement_hugepage_resv_vma()

Now, Checking condition of decrement_hugepage_resv_vma() and
vma_has_reserves() is same, so we can clean-up this function with
vma_has_reserves().  Additionally, decrement_hugepage_resv_vma() has only
one call site, so we can remove function and embed it into
dequeue_huge_page_vma() directly.  This patch implement it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-remove-decrement_hugepage_resv_vma mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-remove-decrement_hugepage_resv_vma
+++ a/mm/hugetlb.c
@@ -434,25 +434,6 @@ static int is_vma_resv_set(struct vm_are
 	return (get_vma_private_data(vma) & flag) != 0;
 }
 
-/* Decrement the reserved pages in the hugepage pool by one */
-static void decrement_hugepage_resv_vma(struct hstate *h,
-			struct vm_area_struct *vma)
-{
-	if (vma->vm_flags & VM_NORESERVE)
-		return;
-
-	if (vma->vm_flags & VM_MAYSHARE) {
-		/* Shared mappings always use reserves */
-		h->resv_huge_pages--;
-	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
-		/*
-		 * Only the process that called mmap() has reserves for
-		 * private mappings.
-		 */
-		h->resv_huge_pages--;
-	}
-}
-
 /* Reset counters to 0 and clear all HPAGE_RESV_* flags */
 void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
@@ -466,10 +447,18 @@ static int vma_has_reserves(struct vm_ar
 {
 	if (vma->vm_flags & VM_NORESERVE)
 		return 0;
+
+	/* Shared mappings always use reserves */
 	if (vma->vm_flags & VM_MAYSHARE)
 		return 1;
+
+	/*
+	 * Only the process that called mmap() has reserves for
+	 * private mappings.
+	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER))
 		return 1;
+
 	return 0;
 }
 
@@ -564,8 +553,8 @@ retry_cpuset:
 		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask)) {
 			page = dequeue_huge_page_node(h, zone_to_nid(zone));
 			if (page) {
-				if (!avoid_reserve)
-					decrement_hugepage_resv_vma(h, vma);
+				if (!avoid_reserve && vma_has_reserves(vma))
+					h->resv_huge_pages--;
 				break;
 			}
 		}
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

