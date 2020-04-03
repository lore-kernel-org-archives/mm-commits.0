From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb_cgroup-add-reservation-accounting-for-private-mappings.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:40:36 -0700
Message-ID: <20200403204036.tv8HYmvsX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgDCUki (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, gthelen@google.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com, shuah@kernel.org


The patch titled
     Subject: hugetlb_cgroup: add reservation accounting for private mappings
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-add-reservation-accounting-for-private-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: hugetlb_cgroup: add reservation accounting for private mappings

Normally the pointer to the cgroup to uncharge hangs off the struct page,
and gets queried when it's time to free the page.  With hugetlb_cgroup
reservations, this is not possible.  Because it's possible for a page to
be reserved by one task and actually faulted in by another task.

The best place to put the hugetlb_cgroup pointer to uncharge for
reservations is in the resv_map.  But, because the resv_map has different
semantics for private and shared mappings, the code patch to
charge/uncharge shared and private mappings is different.  This patch
implements charging and uncharging for private mappings.

For private mappings, the counter to uncharge is in
resv_map->reservation_counter.  On initializing the resv_map this is set
to NULL.  On reservation of a region in private mapping, the tasks
hugetlb_cgroup is charged and the hugetlb_cgroup is placed is
resv_map->reservation_counter.

On hugetlb_vm_op_close, we uncharge resv_map->reservation_counter.

[akpm@linux-foundation.org: forward declare struct resv_map]
Link: http://lkml.kernel.org/r/20200211213128.73302-3-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h        |   10 ++++++
 include/linux/hugetlb_cgroup.h |   41 +++++++++++++++++++++++++--
 mm/hugetlb.c                   |   47 +++++++++++++++++++++++++++++--
 mm/hugetlb_cgroup.c            |   41 ++++-----------------------
 4 files changed, 99 insertions(+), 40 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~hugetlb_cgroup-add-reservation-accounting-for-private-mappings
+++ a/include/linux/hugetlb_cgroup.h
@@ -18,6 +18,8 @@
 #include <linux/mmdebug.h>
 
 struct hugetlb_cgroup;
+struct resv_map;
+
 /*
  * Minimum page order trackable by hugetlb cgroup.
  * At least 4 pages are necessary for all the tracking information.
@@ -27,6 +29,33 @@ struct hugetlb_cgroup;
 #define HUGETLB_CGROUP_MIN_ORDER	2
 
 #ifdef CONFIG_CGROUP_HUGETLB
+enum hugetlb_memory_event {
+	HUGETLB_MAX,
+	HUGETLB_NR_MEMORY_EVENTS,
+};
+
+struct hugetlb_cgroup {
+	struct cgroup_subsys_state css;
+
+	/*
+	 * the counter to account for hugepages from hugetlb.
+	 */
+	struct page_counter hugepage[HUGE_MAX_HSTATE];
+
+	/*
+	 * the counter to account for hugepage reservations from hugetlb.
+	 */
+	struct page_counter rsvd_hugepage[HUGE_MAX_HSTATE];
+
+	atomic_long_t events[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
+	atomic_long_t events_local[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
+
+	/* Handle for "hugetlb.events" */
+	struct cgroup_file events_file[HUGE_MAX_HSTATE];
+
+	/* Handle for "hugetlb.events.local" */
+	struct cgroup_file events_local_file[HUGE_MAX_HSTATE];
+};
 
 static inline struct hugetlb_cgroup *
 __hugetlb_cgroup_from_page(struct page *page, bool rsvd)
@@ -102,9 +131,9 @@ extern void hugetlb_cgroup_uncharge_cgro
 					   struct hugetlb_cgroup *h_cg);
 extern void hugetlb_cgroup_uncharge_cgroup_rsvd(int idx, unsigned long nr_pages,
 						struct hugetlb_cgroup *h_cg);
-extern void hugetlb_cgroup_uncharge_counter(struct page_counter *p,
-					    unsigned long nr_pages,
-					    struct cgroup_subsys_state *css);
+extern void hugetlb_cgroup_uncharge_counter(struct resv_map *resv,
+					    unsigned long start,
+					    unsigned long end);
 
 extern void hugetlb_cgroup_file_init(void) __init;
 extern void hugetlb_cgroup_migrate(struct page *oldhpage,
@@ -193,6 +222,12 @@ hugetlb_cgroup_uncharge_cgroup_rsvd(int
 {
 }
 
+static inline void hugetlb_cgroup_uncharge_counter(struct resv_map *resv,
+						   unsigned long start,
+						   unsigned long end)
+{
+}
+
 static inline void hugetlb_cgroup_file_init(void)
 {
 }
--- a/include/linux/hugetlb.h~hugetlb_cgroup-add-reservation-accounting-for-private-mappings
+++ a/include/linux/hugetlb.h
@@ -46,6 +46,16 @@ struct resv_map {
 	long adds_in_progress;
 	struct list_head region_cache;
 	long region_cache_count;
+#ifdef CONFIG_CGROUP_HUGETLB
+	/*
+	 * On private mappings, the counter to uncharge reservations is stored
+	 * here. If these fields are 0, then either the mapping is shared, or
+	 * cgroup accounting is disabled for this resv_map.
+	 */
+	struct page_counter *reservation_counter;
+	unsigned long pages_per_hpage;
+	struct cgroup_subsys_state *css;
+#endif
 };
 extern struct resv_map *resv_map_alloc(void);
 void resv_map_release(struct kref *ref);
--- a/mm/hugetlb.c~hugetlb_cgroup-add-reservation-accounting-for-private-mappings
+++ a/mm/hugetlb.c
@@ -650,6 +650,25 @@ static void set_vma_private_data(struct
 	vma->vm_private_data = (void *)value;
 }
 
+static void
+resv_map_set_hugetlb_cgroup_uncharge_info(struct resv_map *resv_map,
+					  struct hugetlb_cgroup *h_cg,
+					  struct hstate *h)
+{
+#ifdef CONFIG_CGROUP_HUGETLB
+	if (!h_cg || !h) {
+		resv_map->reservation_counter = NULL;
+		resv_map->pages_per_hpage = 0;
+		resv_map->css = NULL;
+	} else {
+		resv_map->reservation_counter =
+			&h_cg->rsvd_hugepage[hstate_index(h)];
+		resv_map->pages_per_hpage = pages_per_huge_page(h);
+		resv_map->css = &h_cg->css;
+	}
+#endif
+}
+
 struct resv_map *resv_map_alloc(void)
 {
 	struct resv_map *resv_map = kmalloc(sizeof(*resv_map), GFP_KERNEL);
@@ -666,6 +685,13 @@ struct resv_map *resv_map_alloc(void)
 	INIT_LIST_HEAD(&resv_map->regions);
 
 	resv_map->adds_in_progress = 0;
+	/*
+	 * Initialize these to 0. On shared mappings, 0's here indicate these
+	 * fields don't do cgroup accounting. On private mappings, these will be
+	 * re-initialized to the proper values, to indicate that hugetlb cgroup
+	 * reservations are to be un-charged from here.
+	 */
+	resv_map_set_hugetlb_cgroup_uncharge_info(resv_map, NULL, NULL);
 
 	INIT_LIST_HEAD(&resv_map->region_cache);
 	list_add(&rg->link, &resv_map->region_cache);
@@ -3296,9 +3322,7 @@ static void hugetlb_vm_op_close(struct v
 	end = vma_hugecache_offset(h, vma, vma->vm_end);
 
 	reserve = (end - start) - region_count(resv, start, end);
-
-	kref_put(&resv->refs, resv_map_release);
-
+	hugetlb_cgroup_uncharge_counter(resv, start, end);
 	if (reserve) {
 		/*
 		 * Decrement reserve counts.  The global reserve count may be
@@ -3307,6 +3331,8 @@ static void hugetlb_vm_op_close(struct v
 		gbl_reserve = hugepage_subpool_put_pages(spool, reserve);
 		hugetlb_acct_memory(h, -gbl_reserve);
 	}
+
+	kref_put(&resv->refs, resv_map_release);
 }
 
 static int hugetlb_vm_op_split(struct vm_area_struct *vma, unsigned long addr)
@@ -4691,6 +4717,7 @@ int hugetlb_reserve_pages(struct inode *
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
+	struct hugetlb_cgroup *h_cg;
 	long gbl_reserve;
 
 	/* This should never happen */
@@ -4724,12 +4751,26 @@ int hugetlb_reserve_pages(struct inode *
 		chg = region_chg(resv_map, from, to);
 
 	} else {
+		/* Private mapping. */
 		resv_map = resv_map_alloc();
 		if (!resv_map)
 			return -ENOMEM;
 
 		chg = to - from;
 
+		if (hugetlb_cgroup_charge_cgroup_rsvd(
+			    hstate_index(h), chg * pages_per_huge_page(h),
+			    &h_cg)) {
+			kref_put(&resv_map->refs, resv_map_release);
+			return -ENOMEM;
+		}
+
+		/*
+		 * Since this branch handles private mappings, we attach the
+		 * counter to uncharge for this reservation off resv_map.
+		 */
+		resv_map_set_hugetlb_cgroup_uncharge_info(resv_map, h_cg, h);
+
 		set_vma_resv_map(vma, resv_map);
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-add-reservation-accounting-for-private-mappings
+++ a/mm/hugetlb_cgroup.c
@@ -23,34 +23,6 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 
-enum hugetlb_memory_event {
-	HUGETLB_MAX,
-	HUGETLB_NR_MEMORY_EVENTS,
-};
-
-struct hugetlb_cgroup {
-	struct cgroup_subsys_state css;
-
-	/*
-	 * the counter to account for hugepages from hugetlb.
-	 */
-	struct page_counter hugepage[HUGE_MAX_HSTATE];
-
-	/*
-	 * the counter to account for hugepage reservations from hugetlb.
-	 */
-	struct page_counter rsvd_hugepage[HUGE_MAX_HSTATE];
-
-	atomic_long_t events[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
-	atomic_long_t events_local[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
-
-	/* Handle for "hugetlb.events" */
-	struct cgroup_file events_file[HUGE_MAX_HSTATE];
-
-	/* Handle for "hugetlb.events.local" */
-	struct cgroup_file events_local_file[HUGE_MAX_HSTATE];
-};
-
 #define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
 #define MEMFILE_IDX(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
@@ -407,15 +379,16 @@ void hugetlb_cgroup_uncharge_cgroup_rsvd
 	__hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg, true);
 }
 
-void hugetlb_cgroup_uncharge_counter(struct page_counter *p,
-				     unsigned long nr_pages,
-				     struct cgroup_subsys_state *css)
+void hugetlb_cgroup_uncharge_counter(struct resv_map *resv, unsigned long start,
+				     unsigned long end)
 {
-	if (hugetlb_cgroup_disabled() || !p || !css)
+	if (hugetlb_cgroup_disabled() || !resv || !resv->reservation_counter ||
+	    !resv->css)
 		return;
 
-	page_counter_uncharge(p, nr_pages);
-	css_put(css);
+	page_counter_uncharge(resv->reservation_counter,
+			      (end - start) * resv->pages_per_hpage);
+	css_put(resv->css);
 }
 
 enum {
_

Patches currently in -mm which might be from almasrymina@google.com are
