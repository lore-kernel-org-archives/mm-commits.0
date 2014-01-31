From: akpm@linux-foundation.org
Subject: + mm-hugetlb-use-vma_resv_map-map-types.patch added to -mm tree
Date: Fri, 31 Jan 2014 13:08:43 -0800
Message-ID: <52ec10db.u4jzxPJw+ie6GBPe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbaAaVIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 16:08:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: + mm-hugetlb-use-vma_resv_map-map-types.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 13:08:43 -0800


The patch titled
     Subject: mm, hugetlb: use vma_resv_map() map types
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-vma_resv_map-map-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-vma_resv_map-map-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-vma_resv_map-map-types.patch

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
Subject: mm, hugetlb: use vma_resv_map() map types

Util now, we get a resv_map by two ways according to each mapping type. 
This makes code dirty and unreadable.  Unify it.

[davidlohr@hp.com: code cleanups]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  105 +++++++++++++++++++++++--------------------------
 1 file changed, 50 insertions(+), 55 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-vma_resv_map-map-types mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-vma_resv_map-map-types
+++ a/mm/hugetlb.c
@@ -419,13 +419,24 @@ void resv_map_release(struct kref *ref)
 	kfree(resv_map);
 }
 
+static inline struct resv_map *inode_resv_map(struct inode *inode)
+{
+	return inode->i_mapping->private_data;
+}
+
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
 {
 	VM_BUG_ON(!is_vm_hugetlb_page(vma));
-	if (!(vma->vm_flags & VM_MAYSHARE))
+	if (vma->vm_flags & VM_MAYSHARE) {
+		struct address_space *mapping = vma->vm_file->f_mapping;
+		struct inode *inode = mapping->host;
+
+		return inode_resv_map(inode);
+
+	} else {
 		return (struct resv_map *)(get_vma_private_data(vma) &
 							~HPAGE_RESV_MASK);
-	return NULL;
+	}
 }
 
 static void set_vma_resv_map(struct vm_area_struct *vma, struct resv_map *map)
@@ -1167,48 +1178,34 @@ static void return_unused_surplus_pages(
 static long vma_needs_reservation(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long addr)
 {
-	struct address_space *mapping = vma->vm_file->f_mapping;
-	struct inode *inode = mapping->host;
-
-	if (vma->vm_flags & VM_MAYSHARE) {
-		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
-		struct resv_map *resv = inode->i_mapping->private_data;
-
-		return region_chg(resv, idx, idx + 1);
+	struct resv_map *resv;
+	pgoff_t idx;
+	long chg;
 
-	} else if (!is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+	resv = vma_resv_map(vma);
+	if (!resv)
 		return 1;
 
-	} else  {
-		long err;
-		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
-		struct resv_map *resv = vma_resv_map(vma);
-
-		err = region_chg(resv, idx, idx + 1);
-		if (err < 0)
-			return err;
-		return 0;
-	}
+	idx = vma_hugecache_offset(h, vma, addr);
+	chg = region_chg(resv, idx, idx + 1);
+
+	if (vma->vm_flags & VM_MAYSHARE)
+		return chg;
+	else
+		return chg < 0 ? chg : 0;
 }
 static void vma_commit_reservation(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long addr)
 {
-	struct address_space *mapping = vma->vm_file->f_mapping;
-	struct inode *inode = mapping->host;
-
-	if (vma->vm_flags & VM_MAYSHARE) {
-		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
-		struct resv_map *resv = inode->i_mapping->private_data;
-
-		region_add(resv, idx, idx + 1);
+	struct resv_map *resv;
+	pgoff_t idx;
 
-	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
-		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
-		struct resv_map *resv = vma_resv_map(vma);
+	resv = vma_resv_map(vma);
+	if (!resv)
+		return;
 
-		/* Mark this page used in the map. */
-		region_add(resv, idx, idx + 1);
-	}
+	idx = vma_hugecache_offset(h, vma, addr);
+	region_add(resv, idx, idx + 1);
 }
 
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
@@ -2271,7 +2268,7 @@ static void hugetlb_vm_op_open(struct vm
 	 * after this open call completes.  It is therefore safe to take a
 	 * new reference here without additional locking.
 	 */
-	if (resv)
+	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
 		kref_get(&resv->refs);
 }
 
@@ -2280,23 +2277,21 @@ static void hugetlb_vm_op_close(struct v
 	struct hstate *h = hstate_vma(vma);
 	struct resv_map *resv = vma_resv_map(vma);
 	struct hugepage_subpool *spool = subpool_vma(vma);
-	unsigned long reserve;
-	unsigned long start;
-	unsigned long end;
-
-	if (resv) {
-		start = vma_hugecache_offset(h, vma, vma->vm_start);
-		end = vma_hugecache_offset(h, vma, vma->vm_end);
-
-		reserve = (end - start) -
-			region_count(resv, start, end);
-
-		kref_put(&resv->refs, resv_map_release);
-
-		if (reserve) {
-			hugetlb_acct_memory(h, -reserve);
-			hugepage_subpool_put_pages(spool, reserve);
-		}
+	unsigned long reserve, start, end;
+
+	if (!resv || !is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+		return;
+
+	start = vma_hugecache_offset(h, vma, vma->vm_start);
+	end = vma_hugecache_offset(h, vma, vma->vm_end);
+
+	reserve = (end - start) - region_count(resv, start, end);
+
+	kref_put(&resv->refs, resv_map_release);
+
+	if (reserve) {
+		hugetlb_acct_memory(h, -reserve);
+		hugepage_subpool_put_pages(spool, reserve);
 	}
 }
 
@@ -3189,7 +3184,7 @@ int hugetlb_reserve_pages(struct inode *
 	 * called to make the mapping read-write. Assume !vma is a shm mapping
 	 */
 	if (!vma || vma->vm_flags & VM_MAYSHARE) {
-		resv_map = inode->i_mapping->private_data;
+		resv_map = inode_resv_map(inode);
 
 		chg = region_chg(resv_map, from, to);
 
@@ -3248,7 +3243,7 @@ out_err:
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 {
 	struct hstate *h = hstate_inode(inode);
-	struct resv_map *resv_map = inode->i_mapping->private_data;
+	struct resv_map *resv_map = inode_resv_map(inode);
 	long chg = 0;
 	struct hugepage_subpool *spool = subpool_inode(inode);
 
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

