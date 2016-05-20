From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:06:47 -0700
Message-ID: <573f7c67.XzGIgTtLEHnKZzA3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbcETVGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: avoid looking up the first zone in a zonelist twice
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: avoid looking up the first zone in a zonelist twice

The allocator fast path looks up the first usable zone in a zonelist and
then get_page_from_freelist does the same job in the zonelist iterator. 
This patch preserves the necessary information.

                                           4.6.0-rc2                  4.6.0-rc2
                                      fastmark-v1r20             initonce-v1r20
Min      alloc-odr0-1               364.00 (  0.00%)           359.00 (  1.37%)
Min      alloc-odr0-2               262.00 (  0.00%)           260.00 (  0.76%)
Min      alloc-odr0-4               214.00 (  0.00%)           214.00 (  0.00%)
Min      alloc-odr0-8               186.00 (  0.00%)           186.00 (  0.00%)
Min      alloc-odr0-16              173.00 (  0.00%)           173.00 (  0.00%)
Min      alloc-odr0-32              165.00 (  0.00%)           165.00 (  0.00%)
Min      alloc-odr0-64              161.00 (  0.00%)           162.00 ( -0.62%)
Min      alloc-odr0-128             159.00 (  0.00%)           161.00 ( -1.26%)
Min      alloc-odr0-256             168.00 (  0.00%)           170.00 ( -1.19%)
Min      alloc-odr0-512             180.00 (  0.00%)           181.00 ( -0.56%)
Min      alloc-odr0-1024            190.00 (  0.00%)           190.00 (  0.00%)
Min      alloc-odr0-2048            196.00 (  0.00%)           196.00 (  0.00%)
Min      alloc-odr0-4096            202.00 (  0.00%)           202.00 (  0.00%)
Min      alloc-odr0-8192            206.00 (  0.00%)           205.00 (  0.49%)
Min      alloc-odr0-16384           206.00 (  0.00%)           205.00 (  0.49%)

The benefit is negligible and the results are within the noise but each
cycle counts.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c            |   10 +++++-----
 include/linux/mmzone.h |   18 +++++++++++-------
 mm/internal.h          |    2 +-
 mm/mempolicy.c         |   19 ++++++++++---------
 mm/page_alloc.c        |   34 ++++++++++++++++------------------
 5 files changed, 43 insertions(+), 40 deletions(-)

diff -puN fs/buffer.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice fs/buffer.c
--- a/fs/buffer.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice
+++ a/fs/buffer.c
@@ -255,17 +255,17 @@ out:
  */
 static void free_more_memory(void)
 {
-	struct zone *zone;
+	struct zoneref *z;
 	int nid;
 
 	wakeup_flusher_threads(1024, WB_REASON_FREE_MORE_MEM);
 	yield();
 
 	for_each_online_node(nid) {
-		(void)first_zones_zonelist(node_zonelist(nid, GFP_NOFS),
-						gfp_zone(GFP_NOFS), NULL,
-						&zone);
-		if (zone)
+
+		z = first_zones_zonelist(node_zonelist(nid, GFP_NOFS),
+						gfp_zone(GFP_NOFS), NULL);
+		if (z->zone)
 			try_to_free_pages(node_zonelist(nid, GFP_NOFS), 0,
 						GFP_NOFS, NULL);
 	}
diff -puN include/linux/mmzone.h~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice
+++ a/include/linux/mmzone.h
@@ -959,13 +959,10 @@ static __always_inline struct zoneref *n
  */
 static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes,
-					struct zone **zone)
+					nodemask_t *nodes)
 {
-	struct zoneref *z = next_zones_zonelist(zonelist->_zonerefs,
+	return next_zones_zonelist(zonelist->_zonerefs,
 							highest_zoneidx, nodes);
-	*zone = zonelist_zone(z);
-	return z;
 }
 
 /**
@@ -980,10 +977,17 @@ static inline struct zoneref *first_zone
  * within a given nodemask
  */
 #define for_each_zone_zonelist_nodemask(zone, z, zlist, highidx, nodemask) \
-	for (z = first_zones_zonelist(zlist, highidx, nodemask, &zone);	\
+	for (z = first_zones_zonelist(zlist, highidx, nodemask), zone = zonelist_zone(z);	\
 		zone;							\
 		z = next_zones_zonelist(++z, highidx, nodemask),	\
-			zone = zonelist_zone(z))			\
+			zone = zonelist_zone(z))
+
+#define for_next_zone_zonelist_nodemask(zone, z, zlist, highidx, nodemask) \
+	for (zone = z->zone;	\
+		zone;							\
+		z = next_zones_zonelist(++z, highidx, nodemask),	\
+			zone = zonelist_zone(z))
+
 
 /**
  * for_each_zone_zonelist - helper macro to iterate over valid zones in a zonelist at or below a given zone index
diff -puN mm/internal.h~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice mm/internal.h
--- a/mm/internal.h~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice
+++ a/mm/internal.h
@@ -102,7 +102,7 @@ extern pmd_t *mm_find_pmd(struct mm_stru
 struct alloc_context {
 	struct zonelist *zonelist;
 	nodemask_t *nodemask;
-	struct zone *preferred_zone;
+	struct zoneref *preferred_zoneref;
 	int classzone_idx;
 	int migratetype;
 	enum zone_type high_zoneidx;
diff -puN mm/mempolicy.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice mm/mempolicy.c
--- a/mm/mempolicy.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice
+++ a/mm/mempolicy.c
@@ -1739,18 +1739,18 @@ unsigned int mempolicy_slab_node(void)
 		return interleave_nodes(policy);
 
 	case MPOL_BIND: {
+		struct zoneref *z;
+
 		/*
 		 * Follow bind policy behavior and start allocation at the
 		 * first node.
 		 */
 		struct zonelist *zonelist;
-		struct zone *zone;
 		enum zone_type highest_zoneidx = gfp_zone(GFP_KERNEL);
 		zonelist = &NODE_DATA(node)->node_zonelists[0];
-		(void)first_zones_zonelist(zonelist, highest_zoneidx,
-							&policy->v.nodes,
-							&zone);
-		return zone ? zone->node : node;
+		z = first_zones_zonelist(zonelist, highest_zoneidx,
+							&policy->v.nodes);
+		return z->zone ? z->zone->node : node;
 	}
 
 	default:
@@ -2266,7 +2266,7 @@ static void sp_free(struct sp_node *n)
 int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mempolicy *pol;
-	struct zone *zone;
+	struct zoneref *z;
 	int curnid = page_to_nid(page);
 	unsigned long pgoff;
 	int thiscpu = raw_smp_processor_id();
@@ -2298,6 +2298,7 @@ int mpol_misplaced(struct page *page, st
 		break;
 
 	case MPOL_BIND:
+
 		/*
 		 * allows binding to multiple nodes.
 		 * use current page if in policy nodemask,
@@ -2306,11 +2307,11 @@ int mpol_misplaced(struct page *page, st
 		 */
 		if (node_isset(curnid, pol->v.nodes))
 			goto out;
-		(void)first_zones_zonelist(
+		z = first_zones_zonelist(
 				node_zonelist(numa_node_id(), GFP_HIGHUSER),
 				gfp_zone(GFP_HIGHUSER),
-				&pol->v.nodes, &zone);
-		polnid = zone->node;
+				&pol->v.nodes);
+		polnid = z->zone->node;
 		break;
 
 	default:
diff -puN mm/page_alloc.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice
+++ a/mm/page_alloc.c
@@ -2704,7 +2704,7 @@ static struct page *
 get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 						const struct alloc_context *ac)
 {
-	struct zoneref *z;
+	struct zoneref *z = ac->preferred_zoneref;
 	struct zone *zone;
 	bool fair_skipped = false;
 	bool apply_fair = (alloc_flags & ALLOC_FAIR);
@@ -2714,7 +2714,7 @@ zonelist_scan:
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
 	 */
-	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
+	for_next_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
 								ac->nodemask) {
 		struct page *page;
 		unsigned long mark;
@@ -2734,7 +2734,7 @@ zonelist_scan:
 				fair_skipped = true;
 				continue;
 			}
-			if (!zone_local(ac->preferred_zone, zone)) {
+			if (!zone_local(ac->preferred_zoneref->zone, zone)) {
 				if (fair_skipped)
 					goto reset_fair;
 				apply_fair = false;
@@ -2780,7 +2780,7 @@ zonelist_scan:
 				goto try_this_zone;
 
 			if (zone_reclaim_mode == 0 ||
-			    !zone_allows_reclaim(ac->preferred_zone, zone))
+			    !zone_allows_reclaim(ac->preferred_zoneref->zone, zone))
 				continue;
 
 			ret = zone_reclaim(zone, gfp_mask, order);
@@ -2802,7 +2802,7 @@ zonelist_scan:
 		}
 
 try_this_zone:
-		page = buffered_rmqueue(ac->preferred_zone, zone, order,
+		page = buffered_rmqueue(ac->preferred_zoneref->zone, zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			if (prep_new_page(page, order, gfp_mask, alloc_flags))
@@ -2831,7 +2831,7 @@ try_this_zone:
 reset_fair:
 		apply_fair = false;
 		fair_skipped = false;
-		reset_alloc_batches(ac->preferred_zone);
+		reset_alloc_batches(ac->preferred_zoneref->zone);
 		goto zonelist_scan;
 	}
 
@@ -3114,7 +3114,7 @@ static void wake_all_kswapds(unsigned in
 
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
 						ac->high_zoneidx, ac->nodemask)
-		wakeup_kswapd(zone, order, zone_idx(ac->preferred_zone));
+		wakeup_kswapd(zone, order, zonelist_zone_idx(ac->preferred_zoneref));
 }
 
 static inline unsigned int
@@ -3332,7 +3332,7 @@ retry:
 	if ((did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER) ||
 	    ((gfp_mask & __GFP_REPEAT) && pages_reclaimed < (1 << order))) {
 		/* Wait for some write requests to complete then retry */
-		wait_iff_congested(ac->preferred_zone, BLK_RW_ASYNC, HZ/50);
+		wait_iff_congested(ac->preferred_zoneref->zone, BLK_RW_ASYNC, HZ/50);
 		goto retry;
 	}
 
@@ -3370,7 +3370,6 @@ struct page *
 __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
-	struct zoneref *preferred_zoneref;
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW|ALLOC_FAIR;
@@ -3416,14 +3415,14 @@ retry_cpuset:
 	ac.spread_dirty_pages = (gfp_mask & __GFP_WRITE);
 
 	/* The preferred zone is used for statistics later */
-	preferred_zoneref = first_zones_zonelist(ac.zonelist, ac.high_zoneidx,
-				ac.nodemask, &ac.preferred_zone);
-	if (!ac.preferred_zone) {
+	ac.preferred_zoneref = first_zones_zonelist(ac.zonelist,
+					ac.high_zoneidx, ac.nodemask);
+	if (!ac.preferred_zoneref) {
 		page = NULL;
 		goto no_zone;
 	}
 
-	ac.classzone_idx = zonelist_zone_idx(preferred_zoneref);
+	ac.classzone_idx = zonelist_zone_idx(ac.preferred_zoneref);
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_mask, order, alloc_flags, &ac);
@@ -4462,13 +4461,12 @@ static void build_zonelists(pg_data_t *p
  */
 int local_memory_node(int node)
 {
-	struct zone *zone;
+	struct zoneref *z;
 
-	(void)first_zones_zonelist(node_zonelist(node, GFP_KERNEL),
+	z = first_zones_zonelist(node_zonelist(node, GFP_KERNEL),
 				   gfp_zone(GFP_KERNEL),
-				   NULL,
-				   &zone);
-	return zone->node;
+				   NULL);
+	return z->zone->node;
 }
 #endif
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


