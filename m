From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:44:13 -0800
Message-ID: <5640f78d.EkGN4XD69HSFm1cd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbbKIToO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove unnecessary recalculations for dirty zone balancing
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 +
 mm/page_alloc.c |   11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/internal.h~mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing mm/internal.h
--- a/mm/internal.h~mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing
+++ a/mm/internal.h
@@ -129,6 +129,7 @@ struct alloc_context {
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


