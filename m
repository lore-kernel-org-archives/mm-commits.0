From: akpm@linux-foundation.org
Subject: [merged] mm-swap-add-swap_cluster_list.patch removed from -mm
 tree
Date: Mon, 10 Oct 2016 15:43:52 -0700
Message-ID: <57fc19a8.dI0CZ0aK4rCAAY+S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36659 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752440AbcJJWnx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, hughd@google.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: add swap_cluster_list
has been removed from the -mm tree.  Its filename was
     mm-swap-add-swap_cluster_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: add swap_cluster_list

This is a code clean up patch without functionality changes.  The
swap_cluster_list data structure and its operations are introduced to
provide some better encapsulation for the free cluster and discard cluster
list operations.  This avoid some code duplication, improved the code
readability, and reduced the total line number.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/1472067356-16004-1-git-send-email-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   11 ++-
 mm/swapfile.c        |  133 +++++++++++++++++++----------------------
 2 files changed, 70 insertions(+), 74 deletions(-)

diff -puN include/linux/swap.h~mm-swap-add-swap_cluster_list include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-add-swap_cluster_list
+++ a/include/linux/swap.h
@@ -191,6 +191,11 @@ struct percpu_cluster {
 	unsigned int next; /* Likely next allocation offset */
 };
 
+struct swap_cluster_list {
+	struct swap_cluster_info head;
+	struct swap_cluster_info tail;
+};
+
 /*
  * The in-memory structure used to track swap areas.
  */
@@ -203,8 +208,7 @@ struct swap_info_struct {
 	unsigned int	max;		/* extent of the swap_map */
 	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
-	struct swap_cluster_info free_cluster_head; /* free cluster list head */
-	struct swap_cluster_info free_cluster_tail; /* free cluster list tail */
+	struct swap_cluster_list free_clusters; /* free clusters list */
 	unsigned int lowest_bit;	/* index of first free in swap_map */
 	unsigned int highest_bit;	/* index of last free in swap_map */
 	unsigned int pages;		/* total of usable pages of swap */
@@ -235,8 +239,7 @@ struct swap_info_struct {
 					 * first.
 					 */
 	struct work_struct discard_work; /* discard worker */
-	struct swap_cluster_info discard_cluster_head; /* list head of discard clusters */
-	struct swap_cluster_info discard_cluster_tail; /* list tail of discard clusters */
+	struct swap_cluster_list discard_clusters; /* discard clusters list */
 };
 
 /* linux/mm/workingset.c */
diff -puN mm/swapfile.c~mm-swap-add-swap_cluster_list mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-add-swap_cluster_list
+++ a/mm/swapfile.c
@@ -257,6 +257,53 @@ static inline void cluster_set_null(stru
 	info->data = 0;
 }
 
+static inline bool cluster_list_empty(struct swap_cluster_list *list)
+{
+	return cluster_is_null(&list->head);
+}
+
+static inline unsigned int cluster_list_first(struct swap_cluster_list *list)
+{
+	return cluster_next(&list->head);
+}
+
+static void cluster_list_init(struct swap_cluster_list *list)
+{
+	cluster_set_null(&list->head);
+	cluster_set_null(&list->tail);
+}
+
+static void cluster_list_add_tail(struct swap_cluster_list *list,
+				  struct swap_cluster_info *ci,
+				  unsigned int idx)
+{
+	if (cluster_list_empty(list)) {
+		cluster_set_next_flag(&list->head, idx, 0);
+		cluster_set_next_flag(&list->tail, idx, 0);
+	} else {
+		unsigned int tail = cluster_next(&list->tail);
+
+		cluster_set_next(&ci[tail], idx);
+		cluster_set_next_flag(&list->tail, idx, 0);
+	}
+}
+
+static unsigned int cluster_list_del_first(struct swap_cluster_list *list,
+					   struct swap_cluster_info *ci)
+{
+	unsigned int idx;
+
+	idx = cluster_next(&list->head);
+	if (cluster_next(&list->tail) == idx) {
+		cluster_set_null(&list->head);
+		cluster_set_null(&list->tail);
+	} else
+		cluster_set_next_flag(&list->head,
+				      cluster_next(&ci[idx]), 0);
+
+	return idx;
+}
+
 /* Add a cluster to discard list and schedule it to do discard */
 static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 		unsigned int idx)
@@ -270,17 +317,7 @@ static void swap_cluster_schedule_discar
 	memset(si->swap_map + idx * SWAPFILE_CLUSTER,
 			SWAP_MAP_BAD, SWAPFILE_CLUSTER);
 
-	if (cluster_is_null(&si->discard_cluster_head)) {
-		cluster_set_next_flag(&si->discard_cluster_head,
-						idx, 0);
-		cluster_set_next_flag(&si->discard_cluster_tail,
-						idx, 0);
-	} else {
-		unsigned int tail = cluster_next(&si->discard_cluster_tail);
-		cluster_set_next(&si->cluster_info[tail], idx);
-		cluster_set_next_flag(&si->discard_cluster_tail,
-						idx, 0);
-	}
+	cluster_list_add_tail(&si->discard_clusters, si->cluster_info, idx);
 
 	schedule_work(&si->discard_work);
 }
@@ -296,15 +333,8 @@ static void swap_do_scheduled_discard(st
 
 	info = si->cluster_info;
 
-	while (!cluster_is_null(&si->discard_cluster_head)) {
-		idx = cluster_next(&si->discard_cluster_head);
-
-		cluster_set_next_flag(&si->discard_cluster_head,
-						cluster_next(&info[idx]), 0);
-		if (cluster_next(&si->discard_cluster_tail) == idx) {
-			cluster_set_null(&si->discard_cluster_head);
-			cluster_set_null(&si->discard_cluster_tail);
-		}
+	while (!cluster_list_empty(&si->discard_clusters)) {
+		idx = cluster_list_del_first(&si->discard_clusters, info);
 		spin_unlock(&si->lock);
 
 		discard_swap_cluster(si, idx * SWAPFILE_CLUSTER,
@@ -312,19 +342,7 @@ static void swap_do_scheduled_discard(st
 
 		spin_lock(&si->lock);
 		cluster_set_flag(&info[idx], CLUSTER_FLAG_FREE);
-		if (cluster_is_null(&si->free_cluster_head)) {
-			cluster_set_next_flag(&si->free_cluster_head,
-						idx, 0);
-			cluster_set_next_flag(&si->free_cluster_tail,
-						idx, 0);
-		} else {
-			unsigned int tail;
-
-			tail = cluster_next(&si->free_cluster_tail);
-			cluster_set_next(&info[tail], idx);
-			cluster_set_next_flag(&si->free_cluster_tail,
-						idx, 0);
-		}
+		cluster_list_add_tail(&si->free_clusters, info, idx);
 		memset(si->swap_map + idx * SWAPFILE_CLUSTER,
 				0, SWAPFILE_CLUSTER);
 	}
@@ -353,13 +371,8 @@ static void inc_cluster_info_page(struct
 	if (!cluster_info)
 		return;
 	if (cluster_is_free(&cluster_info[idx])) {
-		VM_BUG_ON(cluster_next(&p->free_cluster_head) != idx);
-		cluster_set_next_flag(&p->free_cluster_head,
-			cluster_next(&cluster_info[idx]), 0);
-		if (cluster_next(&p->free_cluster_tail) == idx) {
-			cluster_set_null(&p->free_cluster_tail);
-			cluster_set_null(&p->free_cluster_head);
-		}
+		VM_BUG_ON(cluster_list_first(&p->free_clusters) != idx);
+		cluster_list_del_first(&p->free_clusters, cluster_info);
 		cluster_set_count_flag(&cluster_info[idx], 0, 0);
 	}
 
@@ -398,14 +411,7 @@ static void dec_cluster_info_page(struct
 		}
 
 		cluster_set_flag(&cluster_info[idx], CLUSTER_FLAG_FREE);
-		if (cluster_is_null(&p->free_cluster_head)) {
-			cluster_set_next_flag(&p->free_cluster_head, idx, 0);
-			cluster_set_next_flag(&p->free_cluster_tail, idx, 0);
-		} else {
-			unsigned int tail = cluster_next(&p->free_cluster_tail);
-			cluster_set_next(&cluster_info[tail], idx);
-			cluster_set_next_flag(&p->free_cluster_tail, idx, 0);
-		}
+		cluster_list_add_tail(&p->free_clusters, cluster_info, idx);
 	}
 }
 
@@ -421,8 +427,8 @@ scan_swap_map_ssd_cluster_conflict(struc
 	bool conflict;
 
 	offset /= SWAPFILE_CLUSTER;
-	conflict = !cluster_is_null(&si->free_cluster_head) &&
-		offset != cluster_next(&si->free_cluster_head) &&
+	conflict = !cluster_list_empty(&si->free_clusters) &&
+		offset != cluster_list_first(&si->free_clusters) &&
 		cluster_is_free(&si->cluster_info[offset]);
 
 	if (!conflict)
@@ -447,11 +453,11 @@ static void scan_swap_map_try_ssd_cluste
 new_cluster:
 	cluster = this_cpu_ptr(si->percpu_cluster);
 	if (cluster_is_null(&cluster->index)) {
-		if (!cluster_is_null(&si->free_cluster_head)) {
-			cluster->index = si->free_cluster_head;
+		if (!cluster_list_empty(&si->free_clusters)) {
+			cluster->index = si->free_clusters.head;
 			cluster->next = cluster_next(&cluster->index) *
 					SWAPFILE_CLUSTER;
-		} else if (!cluster_is_null(&si->discard_cluster_head)) {
+		} else if (!cluster_list_empty(&si->discard_clusters)) {
 			/*
 			 * we don't have free cluster but have some clusters in
 			 * discarding, do discard now and reclaim them
@@ -2292,10 +2298,8 @@ static int setup_swap_map_and_extents(st
 
 	nr_good_pages = maxpages - 1;	/* omit header page */
 
-	cluster_set_null(&p->free_cluster_head);
-	cluster_set_null(&p->free_cluster_tail);
-	cluster_set_null(&p->discard_cluster_head);
-	cluster_set_null(&p->discard_cluster_tail);
+	cluster_list_init(&p->free_clusters);
+	cluster_list_init(&p->discard_clusters);
 
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
@@ -2341,19 +2345,8 @@ static int setup_swap_map_and_extents(st
 	for (i = 0; i < nr_clusters; i++) {
 		if (!cluster_count(&cluster_info[idx])) {
 			cluster_set_flag(&cluster_info[idx], CLUSTER_FLAG_FREE);
-			if (cluster_is_null(&p->free_cluster_head)) {
-				cluster_set_next_flag(&p->free_cluster_head,
-								idx, 0);
-				cluster_set_next_flag(&p->free_cluster_tail,
-								idx, 0);
-			} else {
-				unsigned int tail;
