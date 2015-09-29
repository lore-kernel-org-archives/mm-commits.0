From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch added to -mm tree
Date: Tue, 29 Sep 2015 14:07:41 -0700
Message-ID: <560afd9d.1yuB6zlBYzLho8eK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbbI2VHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove unnecessary recalculations for dirty zone balancing
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch

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
Subject: mm, page_alloc: remove unnecessary recalculations for dirty zone balancing

File-backed pages that will be immediately written are balanced between
zones.  This heuristic tries to avoid having a single zone filled with
recently dirtied pages but the checks are unnecessarily expensive.  Move
consider_zone_balanced into the alloc_context instead of checking bitmaps
multiple times.  The patch also gives the parameter a more meaningful
name.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 +
 mm/page_alloc.c |   11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/internal.h~mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing mm/internal.h
--- a/mm/internal.h~mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing
+++ a/mm/internal.h
@@ -133,6 +133,7 @@ struct alloc_context {
 	int classzone_idx;
 	int migratetype;
 	enum zone_type high_zoneidx;
+	bool spread_dirty_pages;
 };
 
 /*
diff -puN mm/page_alloc.c~mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing
+++ a/mm/page_alloc.c
@@ -2478,8 +2478,6 @@ get_page_from_freelist(gfp_t gfp_mask, u
 	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
-	bool consider_zone_dirty = (alloc_flags & ALLOC_WMARK_LOW) &&
-				(gfp_mask & __GFP_WRITE);
 	int nr_fair_skipped = 0;
 	bool zonelist_rescan;
 
@@ -2534,14 +2532,14 @@ zonelist_scan:
 		 *
 		 * XXX: For now, allow allocations to potentially
 		 * exceed the per-zone dirty limit in the slowpath
-		 * (ALLOC_WMARK_LOW unset) before going into reclaim,
+		 * (spread_dirty_pages unset) before going into reclaim,
 		 * which is important when on a NUMA setup the allowed
 		 * zones are together not big enough to reach the
 		 * global limit.  The proper fix for these situations
 		 * will require awareness of zones in the
 		 * dirty-throttling and the flusher threads.
 		 */
-		if (consider_zone_dirty && !zone_dirty_ok(zone))
+		if (ac->spread_dirty_pages && !zone_dirty_ok(zone))
 			continue;
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
@@ -3232,6 +3230,10 @@ retry_cpuset:
 
 	/* We set it here, as __alloc_pages_slowpath might have changed it */
 	ac.zonelist = zonelist;
+
+	/* Dirty zone balancing only done in the fast path */
+	ac.spread_dirty_pages = (gfp_mask & __GFP_WRITE);
+
 	/* The preferred zone is used for statistics later */
 	preferred_zoneref = first_zones_zonelist(ac.zonelist, ac.high_zoneidx,
 				ac.nodemask ? : &cpuset_current_mems_allowed,
@@ -3250,6 +3252,7 @@ retry_cpuset:
 		 * complete.
 		 */
 		alloc_mask = memalloc_noio_flags(gfp_mask);
+		ac.spread_dirty_pages = false;
 
 		page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 	}
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch
mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch
mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-delete-the-zonelist_cache.patch
mm-page_alloc-remove-migrate_reserve.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

