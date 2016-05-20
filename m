From: akpm@linux-foundation.org
Subject: [patch 106/117] mm, page_alloc: remove field from alloc_context
Date: Thu, 19 May 2016 17:14:13 -0700
Message-ID: <573e56d5.bU0td2JBFJCeN+TI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbcETAOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:14:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: remove field from alloc_context

The classzone_idx can be inferred from preferred_zoneref so remove the
unnecessary field and save stack space.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 mm/internal.h   |    3 ++-
 mm/page_alloc.c |    8 +++-----
 3 files changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/compaction.c~mm-page_alloc-remove-field-from-alloc_context mm/compaction.c
--- a/mm/compaction.c~mm-page_alloc-remove-field-from-alloc_context
+++ a/mm/compaction.c
@@ -1602,7 +1602,7 @@ unsigned long try_to_compact_pages(gfp_t
 
 		status = compact_zone_order(zone, order, gfp_mask, mode,
 				&zone_contended, alloc_flags,
-				ac->classzone_idx);
+				ac_classzone_idx(ac));
 		rc = max(status, rc);
 		/*
 		 * It takes at least one zone that wasn't lock contended
@@ -1612,7 +1612,7 @@ unsigned long try_to_compact_pages(gfp_t
 
 		/* If a normal allocation would succeed, stop compacting */
 		if (zone_watermark_ok(zone, order, low_wmark_pages(zone),
-					ac->classzone_idx, alloc_flags)) {
+					ac_classzone_idx(ac), alloc_flags)) {
 			/*
 			 * We think the allocation will succeed in this zone,
 			 * but it is not certain, hence the false. The caller
diff -puN mm/internal.h~mm-page_alloc-remove-field-from-alloc_context mm/internal.h
--- a/mm/internal.h~mm-page_alloc-remove-field-from-alloc_context
+++ a/mm/internal.h
@@ -103,12 +103,13 @@ struct alloc_context {
 	struct zonelist *zonelist;
 	nodemask_t *nodemask;
 	struct zoneref *preferred_zoneref;
-	int classzone_idx;
 	int migratetype;
 	enum zone_type high_zoneidx;
 	bool spread_dirty_pages;
 };
 
+#define ac_classzone_idx(ac) zonelist_zone_idx(ac->preferred_zoneref)
+
 /*
  * Locate the struct page for both the matching buddy in our
  * pair (buddy1) and the combined O(n+1) page they form (page).
diff -puN mm/page_alloc.c~mm-page_alloc-remove-field-from-alloc_context mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-field-from-alloc_context
+++ a/mm/page_alloc.c
@@ -2771,7 +2771,7 @@ zonelist_scan:
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 		if (!zone_watermark_fast(zone, order, mark,
-				       ac->classzone_idx, alloc_flags)) {
+				       ac_classzone_idx(ac), alloc_flags)) {
 			int ret;
 
 			/* Checked here to keep the fast path fast */
@@ -2794,7 +2794,7 @@ zonelist_scan:
 			default:
 				/* did we reclaim enough */
 				if (zone_watermark_ok(zone, order, mark,
-						ac->classzone_idx, alloc_flags))
+						ac_classzone_idx(ac), alloc_flags))
 					goto try_this_zone;
 
 				continue;
@@ -3114,7 +3114,7 @@ static void wake_all_kswapds(unsigned in
 
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
 						ac->high_zoneidx, ac->nodemask)
-		wakeup_kswapd(zone, order, zonelist_zone_idx(ac->preferred_zoneref));
+		wakeup_kswapd(zone, order, ac_classzone_idx(ac));
 }
 
 static inline unsigned int
@@ -3422,8 +3422,6 @@ retry_cpuset:
 		goto no_zone;
 	}
 
-	ac.classzone_idx = zonelist_zone_idx(ac.preferred_zoneref);
