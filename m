From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:55:30 -0700
Message-ID: <579ba6a2.FyY3e8KYXS9qHKYD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbcG2Szb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: cache the last node whose dirty limit is reached
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: page_alloc: cache the last node whose dirty limit is reached

If a page is about to be dirtied then the page allocator attempts to limit
the total number of dirty pages that exists in any given zone.  The call
to node_dirty_ok is expensive so this patch records if the last pgdat
examined hit the dirty limits.  In some cases, this reduces the number of
calls to node_dirty_ok().

Link: http://lkml.kernel.org/r/1467970510-21195-31-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached
+++ a/mm/page_alloc.c
@@ -2848,6 +2848,8 @@ get_page_from_freelist(gfp_t gfp_mask, u
 {
 	struct zoneref *z = ac->preferred_zoneref;
 	struct zone *zone;
+	struct pglist_data *last_pgdat_dirty_limit = NULL;
+
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
@@ -2880,8 +2882,15 @@ get_page_from_freelist(gfp_t gfp_mask, u
 		 * will require awareness of nodes in the
 		 * dirty-throttling and the flusher threads.
 		 */
-		if (ac->spread_dirty_pages && !node_dirty_ok(zone->zone_pgdat))
-			continue;
+		if (ac->spread_dirty_pages) {
+			if (last_pgdat_dirty_limit == zone->zone_pgdat)
+				continue;
+
+			if (!node_dirty_ok(zone->zone_pgdat)) {
+				last_pgdat_dirty_limit = zone->zone_pgdat;
+				continue;
+			}
+		}
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 		if (!zone_watermark_fast(zone, order, mark,
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


