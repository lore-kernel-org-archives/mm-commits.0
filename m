From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-add-minimum-size-accounting-to-subpools.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:48 -0700
Message-ID: <552fe8a4.55oQBdlIWRNbRjLl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbbDPQqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, andi@firstfloor.org, aneesh.kumar@linux.vnet.ibm.com, dave@stgolabs.net, iamjoonsoo.kim@lge.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: add minimum size accounting to subpools
has been removed from the -mm tree.  Its filename was
     hugetlbfs-add-minimum-size-accounting-to-subpools.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: add minimum size accounting to subpools

The same routines that perform subpool maximum size accounting
hugepage_subpool_get/put_pages() are modified to also perform minimum size
accounting.  When a delta value is passed to these routines, calculate how
global reservations must be adjusted to maintain the subpool minimum size.
 The routines now return this global reserve count adjustment.  This
global reserve count adjustment is then passed to the global accounting
routine hugetlb_acct_memory().

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  123 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 100 insertions(+), 23 deletions(-)

diff -puN mm/hugetlb.c~hugetlbfs-add-minimum-size-accounting-to-subpools mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-add-minimum-size-accounting-to-subpools
+++ a/mm/hugetlb.c
@@ -96,36 +96,89 @@ void hugepage_put_subpool(struct hugepag
 	unlock_or_release_subpool(spool);
 }
 
-static int hugepage_subpool_get_pages(struct hugepage_subpool *spool,
+/*
+ * Subpool accounting for allocating and reserving pages.
+ * Return -ENOMEM if there are not enough resources to satisfy the
+ * the request.  Otherwise, return the number of pages by which the
+ * global pools must be adjusted (upward).  The returned value may
+ * only be different than the passed value (delta) in the case where
+ * a subpool minimum size must be manitained.
+ */
+static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 				      long delta)
 {
-	int ret = 0;
+	long ret = delta;
 
 	if (!spool)
-		return 0;
+		return ret;
 
 	spin_lock(&spool->lock);
-	if ((spool->used_hpages + delta) <= spool->max_hpages) {
-		spool->used_hpages += delta;
-	} else {
-		ret = -ENOMEM;
+
+	if (spool->max_hpages != -1) {		/* maximum size accounting */
+		if ((spool->used_hpages + delta) <= spool->max_hpages)
+			spool->used_hpages += delta;
+		else {
+			ret = -ENOMEM;
+			goto unlock_ret;
+		}
 	}
-	spin_unlock(&spool->lock);
 
+	if (spool->min_hpages != -1) {		/* minimum size accounting */
+		if (delta > spool->rsv_hpages) {
+			/*
+			 * Asking for more reserves than those already taken on
+			 * behalf of subpool.  Return difference.
+			 */
+			ret = delta - spool->rsv_hpages;
+			spool->rsv_hpages = 0;
+		} else {
+			ret = 0;	/* reserves already accounted for */
+			spool->rsv_hpages -= delta;
+		}
+	}
+
+unlock_ret:
+	spin_unlock(&spool->lock);
 	return ret;
 }
 
-static void hugepage_subpool_put_pages(struct hugepage_subpool *spool,
+/*
+ * Subpool accounting for freeing and unreserving pages.
+ * Return the number of global page reservations that must be dropped.
+ * The return value may only be different than the passed value (delta)
+ * in the case where a subpool minimum size must be maintained.
+ */
+static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
 				       long delta)
 {
+	long ret = delta;
+
 	if (!spool)
-		return;
+		return delta;
 
 	spin_lock(&spool->lock);
-	spool->used_hpages -= delta;
-	/* If hugetlbfs_put_super couldn't free spool due to
-	* an outstanding quota reference, free it now. */
+
+	if (spool->max_hpages != -1)		/* maximum size accounting */
+		spool->used_hpages -= delta;
+
+	if (spool->min_hpages != -1) {		/* minimum size accounting */
+		if (spool->rsv_hpages + delta <= spool->min_hpages)
+			ret = 0;
+		else
+			ret = spool->rsv_hpages + delta - spool->min_hpages;
+
+		spool->rsv_hpages += delta;
+		if (spool->rsv_hpages > spool->min_hpages)
+			spool->rsv_hpages = spool->min_hpages;
+	}
+
+	/*
+	 * If hugetlbfs_put_super couldn't free spool due to an outstanding
+	 * quota reference, free it now.
+	 */
 	unlock_or_release_subpool(spool);
+
+	return ret;
 }
 
 static inline struct hugepage_subpool *subpool_inode(struct inode *inode)
@@ -873,6 +926,14 @@ void free_huge_page(struct page *page)
 	restore_reserve = PagePrivate(page);
 	ClearPagePrivate(page);
 
+	/*
+	 * A return code of zero implies that the subpool will be under its
+	 * minimum size if the reservation is not restored after page is free.
+	 * Therefore, force restore_reserve operation.
+	 */
+	if (hugepage_subpool_put_pages(spool, 1) == 0)
+		restore_reserve = true;
+
 	spin_lock(&hugetlb_lock);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
@@ -890,7 +951,6 @@ void free_huge_page(struct page *page)
 		enqueue_huge_page(h, page);
 	}
 	spin_unlock(&hugetlb_lock);
-	hugepage_subpool_put_pages(spool, 1);
 }
 
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
@@ -1385,7 +1445,7 @@ static struct page *alloc_huge_page(stru
 	if (chg < 0)
 		return ERR_PTR(-ENOMEM);
 	if (chg || avoid_reserve)
-		if (hugepage_subpool_get_pages(spool, 1))
+		if (hugepage_subpool_get_pages(spool, 1) < 0)
 			return ERR_PTR(-ENOSPC);
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
@@ -2453,6 +2513,7 @@ static void hugetlb_vm_op_close(struct v
 	struct resv_map *resv = vma_resv_map(vma);
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	unsigned long reserve, start, end;
+	long gbl_reserve;
 
 	if (!resv || !is_vma_resv_set(vma, HPAGE_RESV_OWNER))
 		return;
@@ -2465,8 +2526,12 @@ static void hugetlb_vm_op_close(struct v
 	kref_put(&resv->refs, resv_map_release);
 
 	if (reserve) {
-		hugetlb_acct_memory(h, -reserve);
-		hugepage_subpool_put_pages(spool, reserve);
+		/*
+		 * Decrement reserve counts.  The global reserve count may be
+		 * adjusted if the subpool has a minimum size.
+		 */
+		gbl_reserve = hugepage_subpool_put_pages(spool, reserve);
+		hugetlb_acct_memory(h, -gbl_reserve);
 	}
 }
 
@@ -3446,6 +3511,7 @@ int hugetlb_reserve_pages(struct inode *
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
+	long gbl_reserve;
 
 	/*
 	 * Only apply hugepage reservation if asked. At fault time, an
@@ -3482,8 +3548,13 @@ int hugetlb_reserve_pages(struct inode *
 		goto out_err;
 	}
 
-	/* There must be enough pages in the subpool for the mapping */
-	if (hugepage_subpool_get_pages(spool, chg)) {
+	/*
+	 * There must be enough pages in the subpool for the mapping. If
+	 * the subpool has a minimum size, there may be some global
+	 * reservations already in place (gbl_reserve).
+	 */
+	gbl_reserve = hugepage_subpool_get_pages(spool, chg);
+	if (gbl_reserve < 0) {
 		ret = -ENOSPC;
 		goto out_err;
 	}
@@ -3492,9 +3563,10 @@ int hugetlb_reserve_pages(struct inode *
 	 * Check enough hugepages are available for the reservation.
 	 * Hand the pages back to the subpool if there are not
 	 */
-	ret = hugetlb_acct_memory(h, chg);
+	ret = hugetlb_acct_memory(h, gbl_reserve);
 	if (ret < 0) {
-		hugepage_subpool_put_pages(spool, chg);
+		/* put back original number of pages, chg */
+		(void)hugepage_subpool_put_pages(spool, chg);
 		goto out_err;
 	}
 
@@ -3524,6 +3596,7 @@ void hugetlb_unreserve_pages(struct inod
 	struct resv_map *resv_map = inode_resv_map(inode);
 	long chg = 0;
 	struct hugepage_subpool *spool = subpool_inode(inode);
+	long gbl_reserve;
 
 	if (resv_map)
 		chg = region_truncate(resv_map, offset);
@@ -3531,8 +3604,12 @@ void hugetlb_unreserve_pages(struct inod
 	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);
 
-	hugepage_subpool_put_pages(spool, (chg - freed));
-	hugetlb_acct_memory(h, -(chg - freed));
+	/*
+	 * If the subpool has a minimum size, the number of global
+	 * reservations to be released may be adjusted.
+	 */
+	gbl_reserve = hugepage_subpool_put_pages(spool, (chg - freed));
+	hugetlb_acct_memory(h, -gbl_reserve);
 }
 
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

origin.patch

