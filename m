From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:06:18 -0700
Message-ID: <573f7c4a.OCVsDcNigbCU1Maj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbcETVGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: inline the fast path of the zonelist iterator
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: inline the fast path of the zonelist iterator

The page allocator iterates through a zonelist for zones that match the
addressing limitations and nodemask of the caller but many allocations
will not be restricted.  Despite this, there is always functional call
overhead which builds up.

This patch inlines the optimistic basic case and only calls the iterator
function for the complex case.  A hindrance was the fact that
cpuset_current_mems_allowed is used in the fastpath as the allowed
nodemask even though all nodes are allowed on most systems.  The patch
handles this by only considering cpuset_current_mems_allowed if a cpuset
exists.  As well as being faster in the fast-path, this removes some junk
in the slowpath.

The performance difference on a page allocator microbenchmark is;

                                           4.6.0-rc2                  4.6.0-rc2
                                    statinline-v1r20              optiter-v1r20
Min      alloc-odr0-1               412.00 (  0.00%)           382.00 (  7.28%)
Min      alloc-odr0-2               301.00 (  0.00%)           282.00 (  6.31%)
Min      alloc-odr0-4               247.00 (  0.00%)           233.00 (  5.67%)
Min      alloc-odr0-8               215.00 (  0.00%)           203.00 (  5.58%)
Min      alloc-odr0-16              199.00 (  0.00%)           188.00 (  5.53%)
Min      alloc-odr0-32              191.00 (  0.00%)           182.00 (  4.71%)
Min      alloc-odr0-64              187.00 (  0.00%)           177.00 (  5.35%)
Min      alloc-odr0-128             185.00 (  0.00%)           175.00 (  5.41%)
Min      alloc-odr0-256             193.00 (  0.00%)           184.00 (  4.66%)
Min      alloc-odr0-512             207.00 (  0.00%)           197.00 (  4.83%)
Min      alloc-odr0-1024            213.00 (  0.00%)           203.00 (  4.69%)
Min      alloc-odr0-2048            220.00 (  0.00%)           209.00 (  5.00%)
Min      alloc-odr0-4096            226.00 (  0.00%)           214.00 (  5.31%)
Min      alloc-odr0-8192            229.00 (  0.00%)           218.00 (  4.80%)
Min      alloc-odr0-16384           229.00 (  0.00%)           219.00 (  4.37%)

perf indicated that next_zones_zonelist disappeared in the profile and
__next_zones_zonelist did not appear.  This is expected as the
micro-benchmark would hit the inlined fast-path every time.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   13 +++++++++++--
 mm/mmzone.c            |    2 +-
 mm/page_alloc.c        |   26 +++++++++-----------------
 3 files changed, 21 insertions(+), 20 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator
+++ a/include/linux/mmzone.h
@@ -919,6 +919,10 @@ static inline int zonelist_node_idx(stru
 #endif /* CONFIG_NUMA */
 }
 
+struct zoneref *__next_zones_zonelist(struct zoneref *z,
+					enum zone_type highest_zoneidx,
+					nodemask_t *nodes);
+
 /**
  * next_zones_zonelist - Returns the next zone at or below highest_zoneidx within the allowed nodemask using a cursor within a zonelist as a starting point
  * @z - The cursor used as a starting point for the search
@@ -931,9 +935,14 @@ static inline int zonelist_node_idx(stru
  * being examined. It should be advanced by one before calling
  * next_zones_zonelist again.
  */
-struct zoneref *next_zones_zonelist(struct zoneref *z,
+static __always_inline struct zoneref *next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes);
+					nodemask_t *nodes)
+{
+	if (likely(!nodes && zonelist_zone_idx(z) <= highest_zoneidx))
+		return z;
+	return __next_zones_zonelist(z, highest_zoneidx, nodes);
+}
 
 /**
  * first_zones_zonelist - Returns the first zone at or below highest_zoneidx within the allowed nodemask in a zonelist
diff -puN mm/mmzone.c~mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator mm/mmzone.c
--- a/mm/mmzone.c~mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator
+++ a/mm/mmzone.c
@@ -52,7 +52,7 @@ static inline int zref_in_nodemask(struc
 }
 
 /* Returns the next zone at or below highest_zoneidx in a zonelist */
-struct zoneref *next_zones_zonelist(struct zoneref *z,
+struct zoneref *__next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
 					nodemask_t *nodes)
 {
diff -puN mm/page_alloc.c~mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator
+++ a/mm/page_alloc.c
@@ -3192,17 +3192,6 @@ retry:
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
-	/*
-	 * Find the true preferred zone if the allocation is unconstrained by
-	 * cpusets.
-	 */
-	if (!(alloc_flags & ALLOC_CPUSET) && !ac->nodemask) {
-		struct zoneref *preferred_zoneref;
-		preferred_zoneref = first_zones_zonelist(ac->zonelist,
-				ac->high_zoneidx, NULL, &ac->preferred_zone);
-		ac->classzone_idx = zonelist_zone_idx(preferred_zoneref);
-	}
-
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, order,
 				alloc_flags & ~ALLOC_NO_WATERMARKS, ac);
@@ -3358,14 +3347,21 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	struct zoneref *preferred_zoneref;
 	struct page *page = NULL;
 	unsigned int cpuset_mems_cookie;
-	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
+	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_FAIR;
 	gfp_t alloc_mask; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = {
 		.high_zoneidx = gfp_zone(gfp_mask),
+		.zonelist = zonelist,
 		.nodemask = nodemask,
 		.migratetype = gfpflags_to_migratetype(gfp_mask),
 	};
 
+	if (cpusets_enabled()) {
+		alloc_flags |= ALLOC_CPUSET;
+		if (!ac.nodemask)
+			ac.nodemask = &cpuset_current_mems_allowed;
+	}
+
 	gfp_mask &= gfp_allowed_mask;
 
 	lockdep_trace_alloc(gfp_mask);
@@ -3389,16 +3385,12 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
-	/* We set it here, as __alloc_pages_slowpath might have changed it */
-	ac.zonelist = zonelist;
