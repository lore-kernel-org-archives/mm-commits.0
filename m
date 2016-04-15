From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch added to
 -mm tree
Date: Fri, 15 Apr 2016 16:11:55 -0700
Message-ID: <5711753b.W6N5+ZgPIdZfQoW1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbcDOXL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 19:11:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: inline the fast path of the zonelist iterator
has been added to the -mm tree.  Its filename is
     mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -922,6 +922,10 @@ static inline int zonelist_node_idx(stru
 #endif /* CONFIG_NUMA */
 }
 
+struct zoneref *__next_zones_zonelist(struct zoneref *z,
+					enum zone_type highest_zoneidx,
+					nodemask_t *nodes);
+
 /**
  * next_zones_zonelist - Returns the next zone at or below highest_zoneidx within the allowed nodemask using a cursor within a zonelist as a starting point
  * @z - The cursor used as a starting point for the search
@@ -934,9 +938,14 @@ static inline int zonelist_node_idx(stru
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
@@ -3219,17 +3219,6 @@ retry:
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
@@ -3385,14 +3374,21 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
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
@@ -3416,16 +3412,12 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
-	/* We set it here, as __alloc_pages_slowpath might have changed it */
-	ac.zonelist = zonelist;
-
 	/* Dirty zone balancing only done in the fast path */
 	ac.spread_dirty_pages = (gfp_mask & __GFP_WRITE);
 
 	/* The preferred zone is used for statistics later */
 	preferred_zoneref = first_zones_zonelist(ac.zonelist, ac.high_zoneidx,
-				ac.nodemask ? : &cpuset_current_mems_allowed,
-				&ac.preferred_zone);
+				ac.nodemask, &ac.preferred_zone);
 	if (!ac.preferred_zone)
 		goto out;
 	ac.classzone_idx = zonelist_zone_idx(preferred_zoneref);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-only-check-pagecompound-for-high-order-pages.patch
mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch
mm-page_alloc-reduce-branches-in-zone_statistics.patch
mm-page_alloc-inline-zone_statistics.patch
mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch
mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch
mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch
mm-page_alloc-convert-alloc_flags-to-unsigned.patch
mm-page_alloc-convert-nr_fair_skipped-to-bool.patch
mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist.patch
mm-page_alloc-remove-redundant-check-for-empty-zonelist.patch
mm-page_alloc-simplify-last-cpupid-reset.patch
mm-page_alloc-move-might_sleep_if-check-to-the-allocator-slowpath.patch
mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-remove-field-from-alloc_context.patch
mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch

