From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 146/155] hugetlb_cgroup: add accounting for shared
 mappings
Date: Wed, 01 Apr 2020 21:11:28 -0700
Message-ID: <20200402041128.npEWSkAnw%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBELa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:11:30 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, almasrymina@google.com, gthelen@google.com, linux-mm@kvack.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com, shuah@kernel.org, torvalds@linux-foundation.org

From: Mina Almasry <almasrymina@google.com>
Subject: hugetlb_cgroup: add accounting for shared mappings

For shared mappings, the pointer to the hugetlb_cgroup to uncharge lives
in the resv_map entries, in file_region->reservation_counter.

After a call to region_chg, we charge the approprate hugetlb_cgroup, and
if successful, we pass on the hugetlb_cgroup info to a follow up
region_add call.  When a file_region entry is added to the resv_map via
region_add, we put the pointer to that cgroup in
file_region->reservation_counter.  If charging doesn't succeed, we report
the error to the caller, so that the kernel fails the reservation.

On region_del, which is when the hugetlb memory is unreserved, we also
uncharge the file_region->reservation_counter.

[akpm@linux-foundation.org: forward declare struct file_region]
Link: http://lkml.kernel.org/r/20200211213128.73302-5-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h        |   35 +++++++
 include/linux/hugetlb_cgroup.h |   11 ++
 mm/hugetlb.c                   |  148 +++++++++++++++++++------------
 mm/hugetlb_cgroup.c            |   15 +++
 4 files changed, 155 insertions(+), 54 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~hugetlb_cgroup-add-accounting-for-shared-mappings
+++ a/include/linux/hugetlb_cgroup.h
@@ -19,6 +19,7 @@
 
 struct hugetlb_cgroup;
 struct resv_map;
+struct file_region;
 
 /*
  * Minimum page order trackable by hugetlb cgroup.
@@ -135,11 +136,21 @@ extern void hugetlb_cgroup_uncharge_coun
 					    unsigned long start,
 					    unsigned long end);
 
+extern void hugetlb_cgroup_uncharge_file_region(struct resv_map *resv,
+						struct file_region *rg,
+						unsigned long nr_pages);
+
 extern void hugetlb_cgroup_file_init(void) __init;
 extern void hugetlb_cgroup_migrate(struct page *oldhpage,
 				   struct page *newhpage);
 
 #else
+static inline void hugetlb_cgroup_uncharge_file_region(struct resv_map *resv,
+						       struct file_region *rg,
+						       unsigned long nr_pages)
+{
+}
+
 static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
 {
 	return NULL;
--- a/include/linux/hugetlb.h~hugetlb_cgroup-add-accounting-for-shared-mappings
+++ a/include/linux/hugetlb.h
@@ -57,6 +57,41 @@ struct resv_map {
 	struct cgroup_subsys_state *css;
 #endif
 };
+
+/*
+ * Region tracking -- allows tracking of reservations and instantiated pages
+ *                    across the pages in a mapping.
+ *
+ * The region data structures are embedded into a resv_map and protected
+ * by a resv_map's lock.  The set of regions within the resv_map represent
+ * reservations for huge pages, or huge pages that have already been
+ * instantiated within the map.  The from and to elements are huge page
+ * indicies into the associated mapping.  from indicates the starting index
+ * of the region.  to represents the first index past the end of  the region.
+ *
+ * For example, a file region structure with from == 0 and to == 4 represents
+ * four huge pages in a mapping.  It is important to note that the to element
+ * represents the first element past the end of the region. This is used in
+ * arithmetic as 4(to) - 0(from) = 4 huge pages in the region.
+ *
+ * Interval notation of the form [from, to) will be used to indicate that
+ * the endpoint from is inclusive and to is exclusive.
+ */
+struct file_region {
+	struct list_head link;
+	long from;
+	long to;
+#ifdef CONFIG_CGROUP_HUGETLB
+	/*
+	 * On shared mappings, each reserved region appears as a struct
+	 * file_region in resv_map. These fields hold the info needed to
+	 * uncharge each reservation.
+	 */
+	struct page_counter *reservation_counter;
+	struct cgroup_subsys_state *css;
+#endif
+};
+
 extern struct resv_map *resv_map_alloc(void);
 void resv_map_release(struct kref *ref);
 
--- a/mm/hugetlb.c~hugetlb_cgroup-add-accounting-for-shared-mappings
+++ a/mm/hugetlb.c
@@ -220,31 +220,6 @@ static inline struct hugepage_subpool *s
 	return subpool_inode(file_inode(vma->vm_file));
 }
 
-/*
- * Region tracking -- allows tracking of reservations and instantiated pages
- *                    across the pages in a mapping.
- *
- * The region data structures are embedded into a resv_map and protected
- * by a resv_map's lock.  The set of regions within the resv_map represent
- * reservations for huge pages, or huge pages that have already been
- * instantiated within the map.  The from and to elements are huge page
- * indicies into the associated mapping.  from indicates the starting index
- * of the region.  to represents the first index past the end of  the region.
- *
- * For example, a file region structure with from == 0 and to == 4 represents
- * four huge pages in a mapping.  It is important to note that the to element
- * represents the first element past the end of the region. This is used in
- * arithmetic as 4(to) - 0(from) = 4 huge pages in the region.
- *
- * Interval notation of the form [from, to) will be used to indicate that
- * the endpoint from is inclusive and to is exclusive.
- */
-struct file_region {
-	struct list_head link;
-	long from;
-	long to;
-};
-
 /* Helper that removes a struct file_region from the resv_map cache and returns
  * it for use.
  */
@@ -266,6 +241,41 @@ get_file_region_entry_from_cache(struct
 	return nrg;
 }
 
+static void copy_hugetlb_cgroup_uncharge_info(struct file_region *nrg,
+					      struct file_region *rg)
+{
+#ifdef CONFIG_CGROUP_HUGETLB
+	nrg->reservation_counter = rg->reservation_counter;
+	nrg->css = rg->css;
+	if (rg->css)
+		css_get(rg->css);
+#endif
+}
+
+/* Helper that records hugetlb_cgroup uncharge info. */
+static void record_hugetlb_cgroup_uncharge_info(struct hugetlb_cgroup *h_cg,
+						struct hstate *h,
+						struct resv_map *resv,
+						struct file_region *nrg)
+{
+#ifdef CONFIG_CGROUP_HUGETLB
+	if (h_cg) {
+		nrg->reservation_counter =
+			&h_cg->rsvd_hugepage[hstate_index(h)];
+		nrg->css = &h_cg->css;
+		if (!resv->pages_per_hpage)
+			resv->pages_per_hpage = pages_per_huge_page(h);
+		/* pages_per_hpage should be the same for all entries in
+		 * a resv_map.
+		 */
+		VM_BUG_ON(resv->pages_per_hpage != pages_per_huge_page(h));
+	} else {
+		nrg->reservation_counter = NULL;
+		nrg->css = NULL;
+	}
+#endif
+}
+
 /* Must be called with resv->lock held. Calling this with count_only == true
  * will count the number of pages to be added but will not modify the linked
  * list. If regions_needed != NULL and count_only == true, then regions_needed
@@ -273,7 +283,9 @@ get_file_region_entry_from_cache(struct
  * add the regions for this range.
  */
 static long add_reservation_in_range(struct resv_map *resv, long f, long t,
-				     long *regions_needed, bool count_only)
+				     struct hugetlb_cgroup *h_cg,
+				     struct hstate *h, long *regions_needed,
+				     bool count_only)
 {
 	long add = 0;
 	struct list_head *head = &resv->regions;
@@ -312,6 +324,8 @@ static long add_reservation_in_range(str
 			if (!count_only) {
 				nrg = get_file_region_entry_from_cache(
 					resv, last_accounted_offset, rg->from);
+				record_hugetlb_cgroup_uncharge_info(h_cg, h,
+								    resv, nrg);
 				list_add(&nrg->link, rg->link.prev);
 			} else if (regions_needed)
 				*regions_needed += 1;
@@ -328,6 +342,7 @@ static long add_reservation_in_range(str
 		if (!count_only) {
 			nrg = get_file_region_entry_from_cache(
 				resv, last_accounted_offset, t);
+			record_hugetlb_cgroup_uncharge_info(h_cg, h, resv, nrg);
 			list_add(&nrg->link, rg->link.prev);
 		} else if (regions_needed)
 			*regions_needed += 1;
@@ -416,7 +431,8 @@ out_of_memory:
  * 1 page will only require at most 1 entry.
  */
 static long region_add(struct resv_map *resv, long f, long t,
-		       long in_regions_needed)
+		       long in_regions_needed, struct hstate *h,
+		       struct hugetlb_cgroup *h_cg)
 {
 	long add = 0, actual_regions_needed = 0;
 
@@ -424,7 +440,8 @@ static long region_add(struct resv_map *
 retry:
 
 	/* Count how many regions are actually needed to execute this add. */
-	add_reservation_in_range(resv, f, t, &actual_regions_needed, true);
+	add_reservation_in_range(resv, f, t, NULL, NULL, &actual_regions_needed,
+				 true);
 
 	/*
 	 * Check for sufficient descriptors in the cache to accommodate
@@ -452,7 +469,7 @@ retry:
 		goto retry;
 	}
 
-	add = add_reservation_in_range(resv, f, t, NULL, false);
+	add = add_reservation_in_range(resv, f, t, h_cg, h, NULL, false);
 
 	resv->adds_in_progress -= in_regions_needed;
 
@@ -489,7 +506,8 @@ static long region_chg(struct resv_map *
 	spin_lock(&resv->lock);
 
 	/* Count how many hugepages in this range are NOT respresented. */
-	chg = add_reservation_in_range(resv, f, t, out_regions_needed, true);
+	chg = add_reservation_in_range(resv, f, t, NULL, NULL,
+				       out_regions_needed, true);
 
 	if (*out_regions_needed == 0)
 		*out_regions_needed = 1;
@@ -589,11 +607,17 @@ retry:
 			/* New entry for end of split region */
 			nrg->from = t;
 			nrg->to = rg->to;
+
+			copy_hugetlb_cgroup_uncharge_info(nrg, rg);
+
 			INIT_LIST_HEAD(&nrg->link);
 
 			/* Original entry is trimmed */
 			rg->to = f;
 
+			hugetlb_cgroup_uncharge_file_region(
+				resv, rg, nrg->to - nrg->from);
+
 			list_add(&nrg->link, &rg->link);
 			nrg = NULL;
 			break;
@@ -601,6 +625,8 @@ retry:
 
 		if (f <= rg->from && t >= rg->to) { /* Remove entire region */
 			del += rg->to - rg->from;
+			hugetlb_cgroup_uncharge_file_region(resv, rg,
+							    rg->to - rg->from);
 			list_del(&rg->link);
 			kfree(rg);
 			continue;
@@ -609,9 +635,15 @@ retry:
 		if (f <= rg->from) {	/* Trim beginning of region */
 			del += t - rg->from;
 			rg->from = t;
+
+			hugetlb_cgroup_uncharge_file_region(resv, rg,
+							    t - rg->from);
 		} else {		/* Trim end of region */
 			del += rg->to - f;
 			rg->to = f;
+
+			hugetlb_cgroup_uncharge_file_region(resv, rg,
+							    rg->to - f);
 		}
 	}
 
@@ -2124,7 +2156,7 @@ static long __vma_reservation_common(str
 		VM_BUG_ON(dummy_out_regions_needed != 1);
 		break;
 	case VMA_COMMIT_RESV:
-		ret = region_add(resv, idx, idx + 1, 1);
+		ret = region_add(resv, idx, idx + 1, 1, NULL, NULL);
 		/* region_add calls of range 1 should never fail. */
 		VM_BUG_ON(ret < 0);
 		break;
@@ -2134,7 +2166,7 @@ static long __vma_reservation_common(str
 		break;
 	case VMA_ADD_RESV:
 		if (vma->vm_flags & VM_MAYSHARE) {
-			ret = region_add(resv, idx, idx + 1, 1);
+			ret = region_add(resv, idx, idx + 1, 1, NULL, NULL);
 			/* region_add calls of range 1 should never fail. */
 			VM_BUG_ON(ret < 0);
 		} else {
@@ -4830,7 +4862,7 @@ int hugetlb_reserve_pages(struct inode *
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
-	struct hugetlb_cgroup *h_cg;
+	struct hugetlb_cgroup *h_cg = NULL;
 	long gbl_reserve, regions_needed = 0;
 
 	/* This should never happen */
@@ -4871,19 +4903,6 @@ int hugetlb_reserve_pages(struct inode *
 
 		chg = to - from;
 
-		if (hugetlb_cgroup_charge_cgroup_rsvd(
-			    hstate_index(h), chg * pages_per_huge_page(h),
-			    &h_cg)) {
-			kref_put(&resv_map->refs, resv_map_release);
-			return -ENOMEM;
-		}
-
-		/*
-		 * Since this branch handles private mappings, we attach the
-		 * counter to uncharge for this reservation off resv_map.
-		 */
-		resv_map_set_hugetlb_cgroup_uncharge_info(resv_map, h_cg, h);
-
 		set_vma_resv_map(vma, resv_map);
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
@@ -4893,6 +4912,21 @@ int hugetlb_reserve_pages(struct inode *
 		goto out_err;
 	}
 
+	ret = hugetlb_cgroup_charge_cgroup_rsvd(
+		hstate_index(h), chg * pages_per_huge_page(h), &h_cg);
+
+	if (ret < 0) {
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	if (vma && !(vma->vm_flags & VM_MAYSHARE) && h_cg) {
+		/* For private mappings, the hugetlb_cgroup uncharge info hangs
+		 * of the resv_map.
+		 */
+		resv_map_set_hugetlb_cgroup_uncharge_info(resv_map, h_cg, h);
+	}
+
 	/*
 	 * There must be enough pages in the subpool for the mapping. If
 	 * the subpool has a minimum size, there may be some global
@@ -4901,7 +4935,7 @@ int hugetlb_reserve_pages(struct inode *
 	gbl_reserve = hugepage_subpool_get_pages(spool, chg);
 	if (gbl_reserve < 0) {
 		ret = -ENOSPC;
-		goto out_err;
+		goto out_uncharge_cgroup;
 	}
 
 	/*
@@ -4910,9 +4944,7 @@ int hugetlb_reserve_pages(struct inode *
 	 */
 	ret = hugetlb_acct_memory(h, gbl_reserve);
 	if (ret < 0) {
-		/* put back original number of pages, chg */
-		(void)hugepage_subpool_put_pages(spool, chg);
-		goto out_err;
+		goto out_put_pages;
 	}
 
 	/*
@@ -4927,13 +4959,11 @@ int hugetlb_reserve_pages(struct inode *
 	 * else has to be done for private mappings here
 	 */
 	if (!vma || vma->vm_flags & VM_MAYSHARE) {
-		add = region_add(resv_map, from, to, regions_needed);
+		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
 			hugetlb_acct_memory(h, -gbl_reserve);
-			/* put back original number of pages, chg */
-			(void)hugepage_subpool_put_pages(spool, chg);
-			goto out_err;
+			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
 			/*
 			 * pages in this range were added to the reserve
@@ -4944,12 +4974,22 @@ int hugetlb_reserve_pages(struct inode *
 			 */
 			long rsv_adjust;
 
+			hugetlb_cgroup_uncharge_cgroup_rsvd(
+				hstate_index(h),
+				(chg - add) * pages_per_huge_page(h), h_cg);
+
 			rsv_adjust = hugepage_subpool_put_pages(spool,
 								chg - add);
 			hugetlb_acct_memory(h, -rsv_adjust);
 		}
 	}
 	return 0;
+out_put_pages:
+	/* put back original number of pages, chg */
+	(void)hugepage_subpool_put_pages(spool, chg);
+out_uncharge_cgroup:
+	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
+					    chg * pages_per_huge_page(h), h_cg);
 out_err:
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
 		/* Only call region_abort if the region_chg succeeded but the
--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-add-accounting-for-shared-mappings
+++ a/mm/hugetlb_cgroup.c
@@ -391,6 +391,21 @@ void hugetlb_cgroup_uncharge_counter(str
 	css_put(resv->css);
 }
 
+void hugetlb_cgroup_uncharge_file_region(struct resv_map *resv,
+					 struct file_region *rg,
+					 unsigned long nr_pages)
+{
+	if (hugetlb_cgroup_disabled() || !resv || !rg || !nr_pages)
+		return;
+
+	if (rg->reservation_counter && resv->pages_per_hpage && nr_pages > 0 &&
+	    !resv->reservation_counter) {
+		page_counter_uncharge(rg->reservation_counter,
+				      nr_pages * resv->pages_per_hpage);
+		css_put(rg->css);
+	}
+}
+
 enum {
 	RES_USAGE,
 	RES_RSVD_USAGE,
_
