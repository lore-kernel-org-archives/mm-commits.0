From: akpm@linux-foundation.org
Subject: + mm-hugetlb-improve-cleanup-resv_map-parameters.patch added to
 -mm tree
Date: Fri, 31 Jan 2014 13:08:40 -0800
Message-ID: <52ec10d8.huVzJB9pBQfMuLMh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaVIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 16:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: + mm-hugetlb-improve-cleanup-resv_map-parameters.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 13:08:40 -0800


The patch titled
     Subject: mm, hugetlb: improve, cleanup resv_map parameters
has been added to the -mm tree.  Its filename is
     mm-hugetlb-improve-cleanup-resv_map-parameters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-improve-cleanup-resv_map-parameters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-improve-cleanup-resv_map-parameters.patch

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
Subject: mm, hugetlb: improve, cleanup resv_map parameters

To change a protection method for region tracking to find grained one, we
pass the resv_map, instead of list_head, to region manipulation functions.
 This doesn't introduce any functional change, and it is just for
preparing a next step.

[davidlohr@hp.com: update changelog]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-improve-cleanup-resv_map-parameters mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-improve-cleanup-resv_map-parameters
+++ a/mm/hugetlb.c
@@ -151,8 +151,9 @@ struct file_region {
 	long to;
 };
 
-static long region_add(struct list_head *head, long f, long t)
+static long region_add(struct resv_map *resv, long f, long t)
 {
+	struct list_head *head = &resv->regions;
 	struct file_region *rg, *nrg, *trg;
 
 	/* Locate the region we are either in or before. */
@@ -187,8 +188,9 @@ static long region_add(struct list_head
 	return 0;
 }
 
-static long region_chg(struct list_head *head, long f, long t)
+static long region_chg(struct resv_map *resv, long f, long t)
 {
+	struct list_head *head = &resv->regions;
 	struct file_region *rg, *nrg;
 	long chg = 0;
 
@@ -236,8 +238,9 @@ static long region_chg(struct list_head
 	return chg;
 }
 
-static long region_truncate(struct list_head *head, long end)
+static long region_truncate(struct resv_map *resv, long end)
 {
+	struct list_head *head = &resv->regions;
 	struct file_region *rg, *trg;
 	long chg = 0;
 
@@ -266,8 +269,9 @@ static long region_truncate(struct list_
 	return chg;
 }
 
-static long region_count(struct list_head *head, long f, long t)
+static long region_count(struct resv_map *resv, long f, long t)
 {
+	struct list_head *head = &resv->regions;
 	struct file_region *rg;
 	long chg = 0;
 
@@ -393,7 +397,7 @@ void resv_map_release(struct kref *ref)
 	struct resv_map *resv_map = container_of(ref, struct resv_map, refs);
 
 	/* Clear out any active regions before we release the map. */
-	region_truncate(&resv_map->regions, 0);
+	region_truncate(resv_map, 0);
 	kfree(resv_map);
 }
 
@@ -1152,7 +1156,7 @@ static long vma_needs_reservation(struct
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *resv = inode->i_mapping->private_data;
 
-		return region_chg(&resv->regions, idx, idx + 1);
+		return region_chg(resv, idx, idx + 1);
 
 	} else if (!is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		return 1;
@@ -1162,7 +1166,7 @@ static long vma_needs_reservation(struct
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *resv = vma_resv_map(vma);
 
-		err = region_chg(&resv->regions, idx, idx + 1);
+		err = region_chg(resv, idx, idx + 1);
 		if (err < 0)
 			return err;
 		return 0;
@@ -1178,14 +1182,14 @@ static void vma_commit_reservation(struc
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *resv = inode->i_mapping->private_data;
 
-		region_add(&resv->regions, idx, idx + 1);
+		region_add(resv, idx, idx + 1);
 
 	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *resv = vma_resv_map(vma);
 
 		/* Mark this page used in the map. */
-		region_add(&resv->regions, idx, idx + 1);
+		region_add(resv, idx, idx + 1);
 	}
 }
 
@@ -2276,7 +2280,7 @@ static void hugetlb_vm_op_close(struct v
 		end = vma_hugecache_offset(h, vma, vma->vm_end);
 
 		reserve = (end - start) -
-			region_count(&resv->regions, start, end);
+			region_count(resv, start, end);
 
 		resv_map_put(vma);
 
@@ -3178,7 +3182,7 @@ int hugetlb_reserve_pages(struct inode *
 	if (!vma || vma->vm_flags & VM_MAYSHARE) {
 		resv_map = inode->i_mapping->private_data;
 
-		chg = region_chg(&resv_map->regions, from, to);
+		chg = region_chg(resv_map, from, to);
 
 	} else {
 		resv_map = resv_map_alloc();
@@ -3224,7 +3228,7 @@ int hugetlb_reserve_pages(struct inode *
 	 * else has to be done for private mappings here
 	 */
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
-		region_add(&resv_map->regions, from, to);
+		region_add(resv_map, from, to);
 	return 0;
 out_err:
 	if (vma)
@@ -3240,7 +3244,7 @@ void hugetlb_unreserve_pages(struct inod
 	struct hugepage_subpool *spool = subpool_inode(inode);
 
 	if (resv_map)
-		chg = region_truncate(&resv_map->regions, offset);
+		chg = region_truncate(resv_map, offset);
 	spin_lock(&inode->i_lock);
 	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);
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

