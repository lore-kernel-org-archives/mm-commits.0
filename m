From: akpm@linux-foundation.org
Subject: [folded-merged]
 hugetlb-disable-region_add-file_region-coalescing-fix.patch removed from
 -mm tree
Date: Wed, 01 Apr 2020 20:38:02 -0700
Message-ID: <20200402033802.XdRp5R99A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387414AbgDBDiF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:38:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, cai@lca.pw, gthelen@google.com, miguel.ojeda.sandonis@gmail.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com, shuah@kernel.org


The patch titled
     Subject: mm/hugetlb: fix file_region entry allocations
has been removed from the -mm tree.  Its filename was
     hugetlb-disable-region_add-file_region-coalescing-fix.patch

This patch was dropped because it was folded into hugetlb-disable-region_add-file_region-coalescing.patch

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: mm/hugetlb: fix file_region entry allocations

Commit a9e443086489e ("hugetlb: disable region_add file_region
coalescing") introduced a bug with adding file_region entries
that is fixed here:

1. Refactor file_region entry allocation logic into 1 function called
   from region_add and region_chg since the code is now identical.
2. region_chg only modifies resv->adds_in_progress after the regions
   have been allocated. In the past it used to increment
   adds_in_progress and then drop the lock, which would confuse racing
   region_add calls into thinking they need to allocate entries when
   they are not allowed.
3. In region_add, only try to allocate regions when
   actual_regions_needed > in_regions_needed. This is not causing a bug
   but is better for cleanliness and reasoning about the code.

Tested using ltp hugemmap0* tests, and libhugetlbfs tests.

Link: http://lkml.kernel.org/r/20200219012736.20363-1-almasrymina@google.com
Fixes: Commit a9e443086489e ("hugetlb: disable region_add file_region coalescing")
Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Mina Almasry <almasrymina@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  150 ++++++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 75 deletions(-)

--- a/mm/hugetlb.c~hugetlb-disable-region_add-file_region-coalescing-fix
+++ a/mm/hugetlb.c
@@ -337,6 +337,67 @@ static long add_reservation_in_range(str
 	return add;
 }
 
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
+		}
+
+		spin_lock(&resv->lock);
+
+		list_for_each_entry_safe(rg, trg, &allocated_regions, link) {
+			list_del(&rg->link);
+			list_add(&rg->link, &resv->region_cache);
+			resv->region_cache_count++;
+		}
+	}
+
+	return 0;
+
+out_of_memory:
+	list_for_each_entry_safe(rg, trg, &allocated_regions, link) {
+		list_del(&rg->link);
+		kfree(rg);
+	}
+	return -ENOMEM;
+}
+
 /*
  * Add the huge page range represented by [f, t) to the reserve
  * map.  Regions will be taken from the cache to fill in this range.
@@ -357,11 +418,7 @@ static long add_reservation_in_range(str
 static long region_add(struct resv_map *resv, long f, long t,
 		       long in_regions_needed)
 {
-	long add = 0, actual_regions_needed = 0, i = 0;
-	struct file_region *trg = NULL, *rg = NULL;
-	struct list_head allocated_regions;
-
-	INIT_LIST_HEAD(&allocated_regions);
+	long add = 0, actual_regions_needed = 0;
 
 	spin_lock(&resv->lock);
 retry:
@@ -372,34 +429,24 @@ retry:
 	/*
 	 * Check for sufficient descriptors in the cache to accommodate
 	 * this add operation. Note that actual_regions_needed may be greater
-	 * than in_regions_needed. In this case, we need to make sure that we
+	 * than in_regions_needed, as the resv_map may have been modified since
+	 * the region_chg call. In this case, we need to make sure that we
 	 * allocate extra entries, such that we have enough for all the
 	 * existing adds_in_progress, plus the excess needed for this
 	 * operation.
 	 */
-	if (resv->region_cache_count <
-	    resv->adds_in_progress +
-		    (actual_regions_needed - in_regions_needed)) {
+	if (actual_regions_needed > in_regions_needed &&
+	    resv->region_cache_count <
+		    resv->adds_in_progress +
+			    (actual_regions_needed - in_regions_needed)) {
 		/* region_add operation of range 1 should never need to
 		 * allocate file_region entries.
 		 */
 		VM_BUG_ON(t - f <= 1);
 
-		/* Must drop lock to allocate a new descriptor. */
-		spin_unlock(&resv->lock);
-		for (i = 0; i < (actual_regions_needed - in_regions_needed);
-		     i++) {
-			trg = kmalloc(sizeof(*trg), GFP_KERNEL);
-			if (!trg)
-				goto out_of_memory;
-			list_add(&trg->link, &allocated_regions);
-		}
-		spin_lock(&resv->lock);
-
-		list_for_each_entry_safe(rg, trg, &allocated_regions, link) {
-			list_del(&rg->link);
-			list_add(&rg->link, &resv->region_cache);
-			resv->region_cache_count++;
+		if (allocate_file_region_entries(
+			    resv, actual_regions_needed - in_regions_needed)) {
+			return -ENOMEM;
 		}
 
 		goto retry;
@@ -412,13 +459,6 @@ retry:
 	spin_unlock(&resv->lock);
 	VM_BUG_ON(add < 0);
 	return add;
-
-out_of_memory:
-	list_for_each_entry_safe(rg, trg, &allocated_regions, link) {
-		list_del(&rg->link);
-		kfree(rg);
-	}
-	return -ENOMEM;
 }
 
 /*
@@ -444,11 +484,7 @@ out_of_memory:
 static long region_chg(struct resv_map *resv, long f, long t,
 		       long *out_regions_needed)
 {
-	struct file_region *trg = NULL, *rg = NULL;
-	long chg = 0, i = 0, to_allocate = 0;
-	struct list_head allocated_regions;
-
-	INIT_LIST_HEAD(&allocated_regions);
+	long chg = 0;
 
 	spin_lock(&resv->lock);
 
@@ -458,49 +494,13 @@ static long region_chg(struct resv_map *
 	if (*out_regions_needed == 0)
 		*out_regions_needed = 1;
 
-	resv->adds_in_progress += *out_regions_needed;
-
-	/*
-	 * Check for sufficient descriptors in the cache to accommodate
-	 * the number of in progress add operations.
-	 */
-	while (resv->region_cache_count < resv->adds_in_progress) {
-		to_allocate = resv->adds_in_progress - resv->region_cache_count;
-
-		/* Must drop lock to allocate a new descriptor. Note that even
-		 * though we drop the lock here, we do not make another call to
-		 * add_reservation_in_range after re-acquiring the lock.
-		 * Essentially this branch makes sure that we have enough
-		 * descriptors in the cache as suggested by the first call to
-		 * add_reservation_in_range. If more regions turn out to be
-		 * required, region_add will deal with it.
-		 */
-		spin_unlock(&resv->lock);
-		for (i = 0; i < to_allocate; i++) {
-			trg = kmalloc(sizeof(*trg), GFP_KERNEL);
-			if (!trg)
-				goto out_of_memory;
-			list_add(&trg->link, &allocated_regions);
-		}
-
-		spin_lock(&resv->lock);
+	if (allocate_file_region_entries(resv, *out_regions_needed))
+		return -ENOMEM;
 
-		list_for_each_entry_safe(rg, trg, &allocated_regions, link) {
-			list_del(&rg->link);
-			list_add(&rg->link, &resv->region_cache);
-			resv->region_cache_count++;
-		}
-	}
+	resv->adds_in_progress += *out_regions_needed;
 
 	spin_unlock(&resv->lock);
 	return chg;
