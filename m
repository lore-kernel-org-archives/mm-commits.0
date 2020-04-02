From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 145/155] hugetlb: disable region_add file_region
 coalescing
Date: Wed, 01 Apr 2020 21:11:25 -0700
Message-ID: <20200402041125.IGYRnb7n6%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEL2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:11:28 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, almasrymina@google.com, gthelen@google.com, linux-mm@kvack.org, miguel.ojeda.sandonis@gmail.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com, shuah@kernel.org, torvalds@linux-foundation.org

From: Mina Almasry <almasrymina@google.com>
Subject: hugetlb: disable region_add file_region coalescing

A follow up patch in this series adds hugetlb cgroup uncharge info the
file_region entries in resv->regions.  The cgroup uncharge info may differ
for different regions, so they can no longer be coalesced at region_add
time.  So, disable region coalescing in region_add in this patch.

Behavior change:

Say a resv_map exists like this [0->1], [2->3], and [5->6].

Then a region_chg/add call comes in region_chg/add(f=0, t=5).

Old code would generate resv->regions: [0->5], [5->6].
New code would generate resv->regions: [0->1], [1->2], [2->3], [3->5],
[5->6].

Special care needs to be taken to handle the resv->adds_in_progress
variable correctly.  In the past, only 1 region would be added for every
region_chg and region_add call.  But now, each call may add multiple
regions, so we can no longer increment adds_in_progress by 1 in
region_chg, or decrement adds_in_progress by 1 after region_add or
region_abort.  Instead, region_chg calls add_reservation_in_range() to
count the number of regions needed and allocates those, and that info is
passed to region_add and region_abort to decrement adds_in_progress
correctly.

We've also modified the assumption that region_add after region_chg never
fails.  region_chg now pre-allocates at least 1 region for region_add.  If
region_add needs more regions than region_chg has allocated for it, then
it may fail.

[almasrymina@google.com: fix file_region entry allocations]
  Link: http://lkml.kernel.org/r/20200219012736.20363-1-almasrymina@google.com
Link: http://lkml.kernel.org/r/20200211213128.73302-4-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  338 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 229 insertions(+), 109 deletions(-)

--- a/mm/hugetlb.c~hugetlb-disable-region_add-file_region-coalescing
+++ a/mm/hugetlb.c
@@ -245,107 +245,217 @@ struct file_region {
 	long to;
 };
 
+/* Helper that removes a struct file_region from the resv_map cache and returns
+ * it for use.
+ */
+static struct file_region *
+get_file_region_entry_from_cache(struct resv_map *resv, long from, long to)
+{
+	struct file_region *nrg = NULL;
+
+	VM_BUG_ON(resv->region_cache_count <= 0);
+
+	resv->region_cache_count--;
+	nrg = list_first_entry(&resv->region_cache, struct file_region, link);
+	VM_BUG_ON(!nrg);
+	list_del(&nrg->link);
+
+	nrg->from = from;
+	nrg->to = to;
+
+	return nrg;
+}
+
 /* Must be called with resv->lock held. Calling this with count_only == true
  * will count the number of pages to be added but will not modify the linked
- * list.
+ * list. If regions_needed != NULL and count_only == true, then regions_needed
+ * will indicate the number of file_regions needed in the cache to carry out to
+ * add the regions for this range.
  */
 static long add_reservation_in_range(struct resv_map *resv, long f, long t,
-				     bool count_only)
+				     long *regions_needed, bool count_only)
 {
-	long chg = 0;
+	long add = 0;
 	struct list_head *head = &resv->regions;
+	long last_accounted_offset = f;
 	struct file_region *rg = NULL, *trg = NULL, *nrg = NULL;
 
-	/* Locate the region we are before or in. */
-	list_for_each_entry(rg, head, link)
-		if (f <= rg->to)
-			break;
+	if (regions_needed)
+		*regions_needed = 0;
 
-	/* Round our left edge to the current segment if it encloses us. */
-	if (f > rg->from)
-		f = rg->from;
-
-	chg = t - f;
-
-	/* Check for and consume any regions we now overlap with. */
-	nrg = rg;
-	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
-		if (&rg->link == head)
-			break;
+	/* In this loop, we essentially handle an entry for the range
+	 * [last_accounted_offset, rg->from), at every iteration, with some
+	 * bounds checking.
+	 */
+	list_for_each_entry_safe(rg, trg, head, link) {
+		/* Skip irrelevant regions that start before our range. */
+		if (rg->from < f) {
+			/* If this region ends after the last accounted offset,
+			 * then we need to update last_accounted_offset.
+			 */
+			if (rg->to > last_accounted_offset)
+				last_accounted_offset = rg->to;
+			continue;
+		}
+
+		/* When we find a region that starts beyond our range, we've
+		 * finished.
+		 */
 		if (rg->from > t)
 			break;
 
-		/* We overlap with this area, if it extends further than
-		 * us then we must extend ourselves.  Account for its
-		 * existing reservation.
+		/* Add an entry for last_accounted_offset -> rg->from, and
+		 * update last_accounted_offset.
 		 */
-		if (rg->to > t) {
-			chg += rg->to - t;
-			t = rg->to;
+		if (rg->from > last_accounted_offset) {
+			add += rg->from - last_accounted_offset;
+			if (!count_only) {
+				nrg = get_file_region_entry_from_cache(
+					resv, last_accounted_offset, rg->from);
+				list_add(&nrg->link, rg->link.prev);
+			} else if (regions_needed)
+				*regions_needed += 1;
+		}
+
+		last_accounted_offset = rg->to;
+	}
+
+	/* Handle the case where our range extends beyond
+	 * last_accounted_offset.
+	 */
+	if (last_accounted_offset < t) {
+		add += t - last_accounted_offset;
+		if (!count_only) {
+			nrg = get_file_region_entry_from_cache(
+				resv, last_accounted_offset, t);
+			list_add(&nrg->link, rg->link.prev);
+		} else if (regions_needed)
+			*regions_needed += 1;
+	}
+
+	VM_BUG_ON(add < 0);
+	return add;
+}
+
+/* Must be called with resv->lock acquired. Will drop lock to allocate entries.
+ */
+static int allocate_file_region_entries(struct resv_map *resv,
+					int regions_needed)
+	__must_hold(&resv->lock)
+{
+	struct list_head allocated_regions;
+	int to_allocate = 0, i = 0;
+	struct file_region *trg = NULL, *rg = NULL;
+
+	VM_BUG_ON(regions_needed < 0);
+
+	INIT_LIST_HEAD(&allocated_regions);
+
+	/*
+	 * Check for sufficient descriptors in the cache to accommodate
+	 * the number of in progress add operations plus regions_needed.
+	 *
+	 * This is a while loop because when we drop the lock, some other call
+	 * to region_add or region_del may have consumed some region_entries,
+	 * so we keep looping here until we finally have enough entries for
+	 * (adds_in_progress + regions_needed).
+	 */
+	while (resv->region_cache_count <
+	       (resv->adds_in_progress + regions_needed)) {
+		to_allocate = resv->adds_in_progress + regions_needed -
+			      resv->region_cache_count;
+
+		/* At this point, we should have enough entries in the cache
+		 * for all the existings adds_in_progress. We should only be
+		 * needing to allocate for regions_needed.
+		 */
+		VM_BUG_ON(resv->region_cache_count < resv->adds_in_progress);
+
+		spin_unlock(&resv->lock);
+		for (i = 0; i < to_allocate; i++) {
+			trg = kmalloc(sizeof(*trg), GFP_KERNEL);
+			if (!trg)
+				goto out_of_memory;
+			list_add(&trg->link, &allocated_regions);
 		}
-		chg -= rg->to - rg->from;
 
-		if (!count_only && rg != nrg) {
+		spin_lock(&resv->lock);
+
+		list_for_each_entry_safe(rg, trg, &allocated_regions, link) {
 			list_del(&rg->link);
-			kfree(rg);
+			list_add(&rg->link, &resv->region_cache);
+			resv->region_cache_count++;
 		}
 	}
 
-	if (!count_only) {
-		nrg->from = f;
-		nrg->to = t;
-	}
+	return 0;
 
-	return chg;
+out_of_memory:
+	list_for_each_entry_safe(rg, trg, &allocated_regions, link) {
+		list_del(&rg->link);
+		kfree(rg);
+	}
+	return -ENOMEM;
 }
 
 /*
  * Add the huge page range represented by [f, t) to the reserve
- * map.  Existing regions will be expanded to accommodate the specified
- * range, or a region will be taken from the cache.  Sufficient regions
- * must exist in the cache due to the previous call to region_chg with
- * the same range.
+ * map.  Regions will be taken from the cache to fill in this range.
+ * Sufficient regions should exist in the cache due to the previous
+ * call to region_chg with the same range, but in some cases the cache will not
+ * have sufficient entries due to races with other code doing region_add or
+ * region_del.  The extra needed entries will be allocated.
  *
- * Return the number of new huge pages added to the map.  This
- * number is greater than or equal to zero.
+ * regions_needed is the out value provided by a previous call to region_chg.
+ *
+ * Return the number of new huge pages added to the map.  This number is greater
+ * than or equal to zero.  If file_region entries needed to be allocated for
+ * this operation and we were not able to allocate, it ruturns -ENOMEM.
+ * region_add of regions of length 1 never allocate file_regions and cannot
+ * fail; region_chg will always allocate at least 1 entry and a region_add for
+ * 1 page will only require at most 1 entry.
  */
-static long region_add(struct resv_map *resv, long f, long t)
+static long region_add(struct resv_map *resv, long f, long t,
+		       long in_regions_needed)
 {
-	struct list_head *head = &resv->regions;
-	struct file_region *rg, *nrg;
-	long add = 0;
+	long add = 0, actual_regions_needed = 0;
 
 	spin_lock(&resv->lock);
-	/* Locate the region we are either in or before. */
-	list_for_each_entry(rg, head, link)
-		if (f <= rg->to)
-			break;
+retry:
 
-	/*
-	 * If no region exists which can be expanded to include the
-	 * specified range, pull a region descriptor from the cache
-	 * and use it for this range.
-	 */
-	if (&rg->link == head || t < rg->from) {
-		VM_BUG_ON(resv->region_cache_count <= 0);
+	/* Count how many regions are actually needed to execute this add. */
+	add_reservation_in_range(resv, f, t, &actual_regions_needed, true);
 
-		resv->region_cache_count--;
-		nrg = list_first_entry(&resv->region_cache, struct file_region,
-					link);
-		list_del(&nrg->link);
+	/*
+	 * Check for sufficient descriptors in the cache to accommodate
+	 * this add operation. Note that actual_regions_needed may be greater
+	 * than in_regions_needed, as the resv_map may have been modified since
+	 * the region_chg call. In this case, we need to make sure that we
+	 * allocate extra entries, such that we have enough for all the
+	 * existing adds_in_progress, plus the excess needed for this
+	 * operation.
+	 */
+	if (actual_regions_needed > in_regions_needed &&
+	    resv->region_cache_count <
+		    resv->adds_in_progress +
+			    (actual_regions_needed - in_regions_needed)) {
+		/* region_add operation of range 1 should never need to
+		 * allocate file_region entries.
+		 */
+		VM_BUG_ON(t - f <= 1);
 
-		nrg->from = f;
-		nrg->to = t;
-		list_add(&nrg->link, rg->link.prev);
+		if (allocate_file_region_entries(
+			    resv, actual_regions_needed - in_regions_needed)) {
+			return -ENOMEM;
+		}
 
-		add += t - f;
-		goto out_locked;
+		goto retry;
 	}
 
-	add = add_reservation_in_range(resv, f, t, false);
+	add = add_reservation_in_range(resv, f, t, NULL, false);
+
+	resv->adds_in_progress -= in_regions_needed;
 
-out_locked:
-	resv->adds_in_progress--;
 	spin_unlock(&resv->lock);
 	VM_BUG_ON(add < 0);
 	return add;
@@ -358,46 +468,36 @@ out_locked:
  * call to region_add that will actually modify the reserve
  * map to add the specified range [f, t).  region_chg does
  * not change the number of huge pages represented by the
- * map.  A new file_region structure is added to the cache
- * as a placeholder, so that the subsequent region_add
- * call will have all the regions it needs and will not fail.
+ * map.  A number of new file_region structures is added to the cache as a
+ * placeholder, for the subsequent region_add call to use. At least 1
+ * file_region structure is added.
+ *
+ * out_regions_needed is the number of regions added to the
+ * resv->adds_in_progress.  This value needs to be provided to a follow up call
+ * to region_add or region_abort for proper accounting.
  *
  * Returns the number of huge pages that need to be added to the existing
  * reservation map for the range [f, t).  This number is greater or equal to
  * zero.  -ENOMEM is returned if a new file_region structure or cache entry
  * is needed and can not be allocated.
  */
-static long region_chg(struct resv_map *resv, long f, long t)
+static long region_chg(struct resv_map *resv, long f, long t,
+		       long *out_regions_needed)
 {
 	long chg = 0;
 
 	spin_lock(&resv->lock);
-retry_locked:
-	resv->adds_in_progress++;
 
-	/*
-	 * Check for sufficient descriptors in the cache to accommodate
-	 * the number of in progress add operations.
-	 */
-	if (resv->adds_in_progress > resv->region_cache_count) {
-		struct file_region *trg;
-
-		VM_BUG_ON(resv->adds_in_progress - resv->region_cache_count > 1);
-		/* Must drop lock to allocate a new descriptor. */
-		resv->adds_in_progress--;
-		spin_unlock(&resv->lock);
+	/* Count how many hugepages in this range are NOT respresented. */
+	chg = add_reservation_in_range(resv, f, t, out_regions_needed, true);
 
-		trg = kmalloc(sizeof(*trg), GFP_KERNEL);
-		if (!trg)
-			return -ENOMEM;
+	if (*out_regions_needed == 0)
+		*out_regions_needed = 1;
 
-		spin_lock(&resv->lock);
-		list_add(&trg->link, &resv->region_cache);
-		resv->region_cache_count++;
-		goto retry_locked;
-	}
+	if (allocate_file_region_entries(resv, *out_regions_needed))
+		return -ENOMEM;
 
-	chg = add_reservation_in_range(resv, f, t, true);
+	resv->adds_in_progress += *out_regions_needed;
 
 	spin_unlock(&resv->lock);
 	return chg;
@@ -408,17 +508,20 @@ retry_locked:
  * of the resv_map keeps track of the operations in progress between
  * calls to region_chg and region_add.  Operations are sometimes
  * aborted after the call to region_chg.  In such cases, region_abort
- * is called to decrement the adds_in_progress counter.
+ * is called to decrement the adds_in_progress counter. regions_needed
+ * is the value returned by the region_chg call, it is used to decrement
+ * the adds_in_progress counter.
  *
  * NOTE: The range arguments [f, t) are not needed or used in this
  * routine.  They are kept to make reading the calling code easier as
  * arguments will match the associated region_chg call.
  */
-static void region_abort(struct resv_map *resv, long f, long t)
+static void region_abort(struct resv_map *resv, long f, long t,
+			 long regions_needed)
 {
 	spin_lock(&resv->lock);
 	VM_BUG_ON(!resv->region_cache_count);
-	resv->adds_in_progress--;
+	resv->adds_in_progress -= regions_needed;
 	spin_unlock(&resv->lock);
 }
 
@@ -2004,6 +2107,7 @@ static long __vma_reservation_common(str
 	struct resv_map *resv;
 	pgoff_t idx;
 	long ret;
+	long dummy_out_regions_needed;
 
 	resv = vma_resv_map(vma);
 	if (!resv)
@@ -2012,20 +2116,29 @@ static long __vma_reservation_common(str
 	idx = vma_hugecache_offset(h, vma, addr);
 	switch (mode) {
 	case VMA_NEEDS_RESV:
-		ret = region_chg(resv, idx, idx + 1);
+		ret = region_chg(resv, idx, idx + 1, &dummy_out_regions_needed);
+		/* We assume that vma_reservation_* routines always operate on
+		 * 1 page, and that adding to resv map a 1 page entry can only
+		 * ever require 1 region.
+		 */
+		VM_BUG_ON(dummy_out_regions_needed != 1);
 		break;
 	case VMA_COMMIT_RESV:
-		ret = region_add(resv, idx, idx + 1);
+		ret = region_add(resv, idx, idx + 1, 1);
+		/* region_add calls of range 1 should never fail. */
+		VM_BUG_ON(ret < 0);
 		break;
 	case VMA_END_RESV:
-		region_abort(resv, idx, idx + 1);
+		region_abort(resv, idx, idx + 1, 1);
 		ret = 0;
 		break;
 	case VMA_ADD_RESV:
-		if (vma->vm_flags & VM_MAYSHARE)
-			ret = region_add(resv, idx, idx + 1);
-		else {
-			region_abort(resv, idx, idx + 1);
+		if (vma->vm_flags & VM_MAYSHARE) {
+			ret = region_add(resv, idx, idx + 1, 1);
+			/* region_add calls of range 1 should never fail. */
+			VM_BUG_ON(ret < 0);
+		} else {
+			region_abort(resv, idx, idx + 1, 1);
 			ret = region_del(resv, idx, idx + 1);
 		}
 		break;
@@ -4713,12 +4826,12 @@ int hugetlb_reserve_pages(struct inode *
 					struct vm_area_struct *vma,
 					vm_flags_t vm_flags)
 {
-	long ret, chg;
+	long ret, chg, add = -1;
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg;
-	long gbl_reserve;
+	long gbl_reserve, regions_needed = 0;
 
 	/* This should never happen */
 	if (from > to) {
@@ -4748,7 +4861,7 @@ int hugetlb_reserve_pages(struct inode *
 		 */
 		resv_map = inode_resv_map(inode);
 
-		chg = region_chg(resv_map, from, to);
+		chg = region_chg(resv_map, from, to, &regions_needed);
 
 	} else {
 		/* Private mapping. */
@@ -4814,9 +4927,14 @@ int hugetlb_reserve_pages(struct inode *
 	 * else has to be done for private mappings here
 	 */
 	if (!vma || vma->vm_flags & VM_MAYSHARE) {
-		long add = region_add(resv_map, from, to);
+		add = region_add(resv_map, from, to, regions_needed);
 
-		if (unlikely(chg > add)) {
+		if (unlikely(add < 0)) {
+			hugetlb_acct_memory(h, -gbl_reserve);
+			/* put back original number of pages, chg */
+			(void)hugepage_subpool_put_pages(spool, chg);
+			goto out_err;
+		} else if (unlikely(chg > add)) {
 			/*
 			 * pages in this range were added to the reserve
 			 * map between region_chg and region_add.  This
@@ -4834,9 +4952,11 @@ int hugetlb_reserve_pages(struct inode *
 	return 0;
 out_err:
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
-		/* Don't call region_abort if region_chg failed */
-		if (chg >= 0)
-			region_abort(resv_map, from, to);
+		/* Only call region_abort if the region_chg succeeded but the
+		 * region_add failed or didn't run.
+		 */
+		if (chg >= 0 && add < 0)
+			region_abort(resv_map, from, to, regions_needed);
 	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
 		kref_put(&resv_map->refs, resv_map_release);
 	return ret;
_
