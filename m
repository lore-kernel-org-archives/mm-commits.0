From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-race-in-region-tracking.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:31:04 -0700
Message-ID: <533f0878.dwckv1c3XSvrRXu2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaDDTbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, iamjoonsoo.kim@lge.com, david@gibson.dropbear.id.au, davidlohr@hp.com

Subject: [merged] mm-hugetlb-fix-race-in-region-tracking.patch removed from -mm tree
To: davidlohr@hp.com,david@gibson.dropbear.id.au,iamjoonsoo.kim@lge.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:04 -0700


The patch titled
     Subject: mm, hugetlb: fix race in region tracking
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-race-in-region-tracking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm, hugetlb: fix race in region tracking

There is a race condition if we map a same file on different processes. 
Region tracking is protected by mmap_sem and hugetlb_instantiation_mutex. 
When we do mmap, we don't grab a hugetlb_instantiation_mutex, but only
the, mmap_sem (exclusively).  This doesn't prevent other tasks from
modifying the region structure, so it can be modified by two processes
concurrently.

To solve this, introduce a spinlock to resv_map and make region
manipulation function grab it before they do actual work.

[davidlohr@hp.com: updated changelog]
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Gibson <david@gibson.dropbear.id.au>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 
 mm/hugetlb.c            |   58 ++++++++++++++++++++++++--------------
 2 files changed, 39 insertions(+), 20 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-fix-race-in-region-tracking include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-fix-race-in-region-tracking
+++ a/include/linux/hugetlb.h
@@ -27,6 +27,7 @@ struct hugepage_subpool {
 
 struct resv_map {
 	struct kref refs;
+	spinlock_t lock;
 	struct list_head regions;
 };
 extern struct resv_map *resv_map_alloc(void);
diff -puN mm/hugetlb.c~mm-hugetlb-fix-race-in-region-tracking mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-race-in-region-tracking
+++ a/mm/hugetlb.c
@@ -135,15 +135,8 @@ static inline struct hugepage_subpool *s
  * Region tracking -- allows tracking of reservations and instantiated pages
  *                    across the pages in a mapping.
  *
- * The region data structures are protected by a combination of the mmap_sem
- * and the hugetlb_instantiation_mutex.  To access or modify a region the caller
- * must either hold the mmap_sem for write, or the mmap_sem for read and
- * the hugetlb_instantiation_mutex:
- *
- *	down_write(&mm->mmap_sem);
- * or
- *	down_read(&mm->mmap_sem);
- *	mutex_lock(&hugetlb_instantiation_mutex);
+ * The region data structures are embedded into a resv_map and
+ * protected by a resv_map's lock
  */
 struct file_region {
 	struct list_head link;
@@ -156,6 +149,7 @@ static long region_add(struct resv_map *
 	struct list_head *head = &resv->regions;
 	struct file_region *rg, *nrg, *trg;
 
+	spin_lock(&resv->lock);
 	/* Locate the region we are either in or before. */
 	list_for_each_entry(rg, head, link)
 		if (f <= rg->to)
@@ -185,15 +179,18 @@ static long region_add(struct resv_map *
 	}
 	nrg->from = f;
 	nrg->to = t;
+	spin_unlock(&resv->lock);
 	return 0;
 }
 
 static long region_chg(struct resv_map *resv, long f, long t)
 {
 	struct list_head *head = &resv->regions;
-	struct file_region *rg, *nrg;
+	struct file_region *rg, *nrg = NULL;
 	long chg = 0;
 
+retry:
+	spin_lock(&resv->lock);
 	/* Locate the region we are before or in. */
 	list_for_each_entry(rg, head, link)
 		if (f <= rg->to)
@@ -203,15 +200,21 @@ static long region_chg(struct resv_map *
 	 * Subtle, allocate a new region at the position but make it zero
 	 * size such that we can guarantee to record the reservation. */
 	if (&rg->link == head || t < rg->from) {
-		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
-		if (!nrg)
-			return -ENOMEM;
-		nrg->from = f;
-		nrg->to   = f;
-		INIT_LIST_HEAD(&nrg->link);
-		list_add(&nrg->link, rg->link.prev);
+		if (!nrg) {
+			spin_unlock(&resv->lock);
+			nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
+			if (!nrg)
+				return -ENOMEM;
+
+			nrg->from = f;
+			nrg->to   = f;
+			INIT_LIST_HEAD(&nrg->link);
+			goto retry;
+		}
 
-		return t - f;
+		list_add(&nrg->link, rg->link.prev);
+		chg = t - f;
+		goto out_nrg;
 	}
 
 	/* Round our left edge to the current segment if it encloses us. */
@@ -224,7 +227,7 @@ static long region_chg(struct resv_map *
 		if (&rg->link == head)
 			break;
 		if (rg->from > t)
-			return chg;
+			goto out;
 
 		/* We overlap with this area, if it extends further than
 		 * us then we must extend ourselves.  Account for its
@@ -235,6 +238,14 @@ static long region_chg(struct resv_map *
 		}
 		chg -= rg->to - rg->from;
 	}
+
+out:
+	spin_unlock(&resv->lock);
+	/*  We already know we raced and no longer need the new region */
+	kfree(nrg);
+	return chg;
+out_nrg:
+	spin_unlock(&resv->lock);
 	return chg;
 }
 
@@ -244,12 +255,13 @@ static long region_truncate(struct resv_
 	struct file_region *rg, *trg;
 	long chg = 0;
 
+	spin_lock(&resv->lock);
 	/* Locate the region we are either in or before. */
 	list_for_each_entry(rg, head, link)
 		if (end <= rg->to)
 			break;
 	if (&rg->link == head)
-		return 0;
+		goto out;
 
 	/* If we are in the middle of a region then adjust it. */
 	if (end > rg->from) {
@@ -266,6 +278,9 @@ static long region_truncate(struct resv_
 		list_del(&rg->link);
 		kfree(rg);
 	}
+
+out:
+	spin_unlock(&resv->lock);
 	return chg;
 }
 
@@ -275,6 +290,7 @@ static long region_count(struct resv_map
 	struct file_region *rg;
 	long chg = 0;
 
+	spin_lock(&resv->lock);
 	/* Locate each segment we overlap with, and count that overlap. */
 	list_for_each_entry(rg, head, link) {
 		long seg_from;
@@ -290,6 +306,7 @@ static long region_count(struct resv_map
 
 		chg += seg_to - seg_from;
 	}
+	spin_unlock(&resv->lock);
 
 	return chg;
 }
@@ -387,6 +404,7 @@ struct resv_map *resv_map_alloc(void)
 		return NULL;
 
 	kref_init(&resv_map->refs);
+	spin_lock_init(&resv_map->lock);
 	INIT_LIST_HEAD(&resv_map->regions);
 
 	return resv_map;
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
mm-memoryc-update-comment-in-unmap_single_vma.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-4.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6.patch
mm-per-thread-vma-caching-fix-6-fix.patch
ipccompat-remove-sc_semopm-macro.patch
ipc-use-device_initcall.patch

