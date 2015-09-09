From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:46:05 -0700
Message-ID: <55f08c7d.sg+mCCX+fI6+BzCj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbbIITqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add cache of descriptors to resv_map for region_add
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: add cache of descriptors to resv_map for region_add

hugetlbfs is used today by applications that want a high degree of control
over huge page usage.  Often, large hugetlbfs files are used to map a
large number huge pages into the application processes.  The applications
know when page ranges within these large files will no longer be used, and
ideally would like to release them back to the subpool or global pools for
other uses.  The fallocate() system call provides an interface for
preallocation and hole punching within files.  This patch set adds
fallocate functionality to hugetlbfs.




fallocate hole punch will want to remove a specific range of pages.  When
pages are removed, their associated entries in the region/reserve map will
also be removed.  This will break an assumption in the
region_chg/region_add calling sequence.  If a new region descriptor must
be allocated, it is done as part of the region_chg processing.  In this
way, region_add can not fail because it does not need to attempt an
allocation.

To prepare for fallocate hole punch, create a "cache" of descriptors that
can be used by region_add if necessary.  region_chg will ensure there are
sufficient entries in the cache.  It will be necessary to track the number
of in progress add operations to know a sufficient number of descriptors
reside in the cache.  A new routine region_abort is added to adjust this
in progress count when add operations are aborted.  vma_abort_reservation
is also added for callers creating reservations with
vma_needs_reservation/vma_commit_reservation.

[akpm@linux-foundation.org: fix typo in comment, use more cols]
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 
 mm/hugetlb.c            |  174 +++++++++++++++++++++++++++++++++-----
 2 files changed, 155 insertions(+), 22 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add
+++ a/include/linux/hugetlb.h
@@ -35,6 +35,9 @@ struct resv_map {
 	struct kref refs;
 	spinlock_t lock;
 	struct list_head regions;
+	long adds_in_progress;
+	struct list_head region_cache;
+	long region_cache_count;
 };
 extern struct resv_map *resv_map_alloc(void);
 void resv_map_release(struct kref *ref);
diff -puN mm/hugetlb.c~mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add
+++ a/mm/hugetlb.c
@@ -240,11 +240,14 @@ struct file_region {
 
 /*
  * Add the huge page range represented by [f, t) to the reserve
- * map.  Existing regions will be expanded to accommodate the
- * specified range.  We know only existing regions need to be
- * expanded, because region_add is only called after region_chg
- * with the same range.  If a new file_region structure must
- * be allocated, it is done in region_chg.
+ * map.  In the normal case, existing regions will be expanded
+ * to accommodate the specified range.  Sufficient regions should
+ * exist for expansion due to the previous call to region_chg
+ * with the same range.  However, it is possible that region_del
+ * could have been called after region_chg and modifed the map
+ * in such a way that no region exists to be expanded.  In this
+ * case, pull a region descriptor from the cache associated with
+ * the map and use that for the new range.
  *
  * Return the number of new huge pages added to the map.  This
  * number is greater than or equal to zero.
@@ -261,6 +264,28 @@ static long region_add(struct resv_map *
 		if (f <= rg->to)
 			break;
 
+	/*
+	 * If no region exists which can be expanded to include the
+	 * specified range, the list must have been modified by an
+	 * interleving call to region_del().  Pull a region descriptor
+	 * from the cache and use it for this range.
+	 */
+	if (&rg->link == head || t < rg->from) {
+		VM_BUG_ON(resv->region_cache_count <= 0);
+
+		resv->region_cache_count--;
+		nrg = list_first_entry(&resv->region_cache, struct file_region,
+					link);
+		list_del(&nrg->link);
+
+		nrg->from = f;
+		nrg->to = t;
+		list_add(&nrg->link, rg->link.prev);
+
+		add += t - f;
+		goto out_locked;
+	}
+
 	/* Round our left edge to the current segment if it encloses us. */
 	if (f > rg->from)
 		f = rg->from;
@@ -294,6 +319,8 @@ static long region_add(struct resv_map *
 	add += t - nrg->to;		/* Added to end of region */
 	nrg->to = t;
 
+out_locked:
+	resv->adds_in_progress--;
 	spin_unlock(&resv->lock);
 	VM_BUG_ON(add < 0);
 	return add;
@@ -312,11 +339,14 @@ static long region_add(struct resv_map *
  * so that the subsequent region_add call will have all the
  * regions it needs and will not fail.
  *
- * Returns the number of huge pages that need to be added
- * to the existing reservation map for the range [f, t).
- * This number is greater or equal to zero.  -ENOMEM is
- * returned if a new file_region structure is needed and can
- * not be allocated.
+ * Upon entry, region_chg will also examine the cache of region descriptors
+ * associated with the map.  If there are not enough descriptors cached, one
+ * will be allocated for the in progress add operation.
+ *
+ * Returns the number of huge pages that need to be added to the existing
+ * reservation map for the range [f, t).  This number is greater or equal to
+ * zero.  -ENOMEM is returned if a new file_region structure or cache entry
+ * is needed and can not be allocated.
  */
 static long region_chg(struct resv_map *resv, long f, long t)
 {
@@ -326,6 +356,31 @@ static long region_chg(struct resv_map *
 
 retry:
 	spin_lock(&resv->lock);
+retry_locked:
+	resv->adds_in_progress++;
+
+	/*
+	 * Check for sufficient descriptors in the cache to accommodate
+	 * the number of in progress add operations.
+	 */
+	if (resv->adds_in_progress > resv->region_cache_count) {
+		struct file_region *trg;
+
+		VM_BUG_ON(resv->adds_in_progress - resv->region_cache_count > 1);
+		/* Must drop lock to allocate a new descriptor. */
+		resv->adds_in_progress--;
+		spin_unlock(&resv->lock);
+
+		trg = kmalloc(sizeof(*trg), GFP_KERNEL);
+		if (!trg)
+			return -ENOMEM;
+
+		spin_lock(&resv->lock);
+		list_add(&trg->link, &resv->region_cache);
+		resv->region_cache_count++;
+		goto retry_locked;
+	}
+
 	/* Locate the region we are before or in. */
 	list_for_each_entry(rg, head, link)
 		if (f <= rg->to)
@@ -336,6 +391,7 @@ retry:
 	 * size such that we can guarantee to record the reservation. */
 	if (&rg->link == head || t < rg->from) {
 		if (!nrg) {
+			resv->adds_in_progress--;
 			spin_unlock(&resv->lock);
 			nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
 			if (!nrg)
@@ -385,6 +441,25 @@ out_nrg:
 }
 
 /*
+ * Abort the in progress add operation.  The adds_in_progress field
+ * of the resv_map keeps track of the operations in progress between
+ * calls to region_chg and region_add.  Operations are sometimes
+ * aborted after the call to region_chg.  In such cases, region_abort
+ * is called to decrement the adds_in_progress counter.
+ *
+ * NOTE: The range arguments [f, t) are not needed or used in this
+ * routine.  They are kept to make reading the calling code easier as
+ * arguments will match the associated region_chg call.
+ */
+static void region_abort(struct resv_map *resv, long f, long t)
+{
+	spin_lock(&resv->lock);
+	VM_BUG_ON(!resv->region_cache_count);
+	resv->adds_in_progress--;
+	spin_unlock(&resv->lock);
+}
+
+/*
  * Truncate the reserve map at index 'end'.  Modify/truncate any
  * region which contains end.  Delete any regions past end.
  * Return the number of huge pages removed from the map.
@@ -544,22 +619,44 @@ static void set_vma_private_data(struct
 struct resv_map *resv_map_alloc(void)
 {
 	struct resv_map *resv_map = kmalloc(sizeof(*resv_map), GFP_KERNEL);
-	if (!resv_map)
+	struct file_region *rg = kmalloc(sizeof(*rg), GFP_KERNEL);
+
+	if (!resv_map || !rg) {
+		kfree(resv_map);
+		kfree(rg);
 		return NULL;
+	}
 
 	kref_init(&resv_map->refs);
 	spin_lock_init(&resv_map->lock);
 	INIT_LIST_HEAD(&resv_map->regions);
 
+	resv_map->adds_in_progress = 0;
+
+	INIT_LIST_HEAD(&resv_map->region_cache);
+	list_add(&rg->link, &resv_map->region_cache);
+	resv_map->region_cache_count = 1;
+
 	return resv_map;
 }
 
 void resv_map_release(struct kref *ref)
 {
 	struct resv_map *resv_map = container_of(ref, struct resv_map, refs);
+	struct list_head *head = &resv_map->region_cache;
+	struct file_region *rg, *trg;
 
 	/* Clear out any active regions before we release the map. */
 	region_truncate(resv_map, 0);
+
+	/* ... and any entries left in the cache */
+	list_for_each_entry_safe(rg, trg, head, link) {
+		list_del(&rg->link);
+		kfree(rg);
+	}
+
+	VM_BUG_ON(resv_map->adds_in_progress);
+
 	kfree(resv_map);
 }
 
@@ -1473,16 +1570,18 @@ static void return_unused_surplus_pages(
 	}
 }
 
+
 /*
- * vma_needs_reservation and vma_commit_reservation are used by the huge
- * page allocation routines to manage reservations.
+ * vma_needs_reservation, vma_commit_reservation and vma_abort_reservation
+ * are used by the huge page allocation routines to manage reservations.
  *
  * vma_needs_reservation is called to determine if the huge page at addr
  * within the vma has an associated reservation.  If a reservation is
  * needed, the value 1 is returned.  The caller is then responsible for
  * managing the global reservation and subpool usage counts.  After
  * the huge page has been allocated, vma_commit_reservation is called
- * to add the page to the reservation map.
+ * to add the page to the reservation map.  If the reservation must be
+ * aborted instead of committed, vma_abort_reservation is called.
  *
  * In the normal case, vma_commit_reservation returns the same value
  * as the preceding vma_needs_reservation call.  The only time this
@@ -1490,9 +1589,14 @@ static void return_unused_surplus_pages(
  * is the responsibility of the caller to notice the difference and
  * take appropriate action.
  */
+enum vma_resv_mode {
+	VMA_NEEDS_RESV,
+	VMA_COMMIT_RESV,
+	VMA_ABORT_RESV,
+};
 static long __vma_reservation_common(struct hstate *h,
 				struct vm_area_struct *vma, unsigned long addr,
-				bool commit)
+				enum vma_resv_mode mode)
 {
 	struct resv_map *resv;
 	pgoff_t idx;
@@ -1503,10 +1607,20 @@ static long __vma_reservation_common(str
 		return 1;
 
 	idx = vma_hugecache_offset(h, vma, addr);
-	if (commit)
-		ret = region_add(resv, idx, idx + 1);
-	else
+	switch (mode) {
+	case VMA_NEEDS_RESV:
 		ret = region_chg(resv, idx, idx + 1);
+		break;
+	case VMA_COMMIT_RESV:
+		ret = region_add(resv, idx, idx + 1);
+		break;
+	case VMA_ABORT_RESV:
+		region_abort(resv, idx, idx + 1);
+		ret = 0;
+		break;
+	default:
+		BUG();
+	}
 
 	if (vma->vm_flags & VM_MAYSHARE)
 		return ret;
@@ -1517,13 +1631,19 @@ static long __vma_reservation_common(str
 static long vma_needs_reservation(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long addr)
 {
-	return __vma_reservation_common(h, vma, addr, false);
+	return __vma_reservation_common(h, vma, addr, VMA_NEEDS_RESV);
 }
 
 static long vma_commit_reservation(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long addr)
 {
-	return __vma_reservation_common(h, vma, addr, true);
+	return __vma_reservation_common(h, vma, addr, VMA_COMMIT_RESV);
+}
+
+static void vma_abort_reservation(struct hstate *h,
+			struct vm_area_struct *vma, unsigned long addr)
+{
+	(void)__vma_reservation_common(h, vma, addr, VMA_ABORT_RESV);
 }
 
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
@@ -1549,8 +1669,10 @@ static struct page *alloc_huge_page(stru
 	if (chg < 0)
 		return ERR_PTR(-ENOMEM);
 	if (chg || avoid_reserve)
-		if (hugepage_subpool_get_pages(spool, 1) < 0)
+		if (hugepage_subpool_get_pages(spool, 1) < 0) {
+			vma_abort_reservation(h, vma, addr);
 			return ERR_PTR(-ENOSPC);
+		}
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
 	if (ret)
@@ -1596,6 +1718,7 @@ out_uncharge_cgroup:
 out_subpool_put:
 	if (chg || avoid_reserve)
 		hugepage_subpool_put_pages(spool, 1);
+	vma_abort_reservation(h, vma, addr);
 	return ERR_PTR(-ENOSPC);
 }
 
@@ -3236,11 +3359,14 @@ retry:
 	 * any allocations necessary to record that reservation occur outside
 	 * the spinlock.
 	 */
-	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED))
+	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		if (vma_needs_reservation(h, vma, address) < 0) {
 			ret = VM_FAULT_OOM;
 			goto backout_unlocked;
 		}
+		/* Just decrements count, does not deallocate */
+		vma_abort_reservation(h, vma, address);
+	}
 
 	ptl = huge_pte_lockptr(h, mm, ptep);
 	spin_lock(ptl);
@@ -3387,6 +3513,8 @@ int hugetlb_fault(struct mm_struct *mm,
 			ret = VM_FAULT_OOM;
 			goto out_mutex;
 		}
+		/* Just decrements count, does not deallocate */
+		vma_abort_reservation(h, vma, address);
 
 		if (!(vma->vm_flags & VM_MAYSHARE))
 			pagecache_page = hugetlbfs_pagecache_page(h,
@@ -3726,6 +3854,8 @@ int hugetlb_reserve_pages(struct inode *
 	}
 	return 0;
 out_err:
+	if (!vma || vma->vm_flags & VM_MAYSHARE)
+		region_abort(resv_map, from, to);
 	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
 		kref_put(&resv_map->refs, resv_map_release);
 	return ret;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


