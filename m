From: akpm@linux-foundation.org
Subject: [merged] mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:34 -0700
Message-ID: <201107260752.p6Q7qb9i003145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115Ab1GZHxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, cl@linux.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: page allocator: reconsider zones for allocation after direct reclaim
has been removed from the -mm tree.  Its filename was
     mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: page allocator: reconsider zones for allocation after direct reclaim
From: Mel Gorman <mgorman@suse.de>

With zone_reclaim_mode enabled, it's possible for zones to be considered
full in the zonelist_cache so they are skipped in the future.  If the
process enters direct reclaim, the ZLC may still consider zones to be full
even after reclaiming pages.  Reconsider all zones for allocation if
direct reclaim returns successfully.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN mm/page_alloc.c~mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-reconsider-zones-for-allocation-after-direct-reclaim
+++ a/mm/page_alloc.c
@@ -1616,6 +1616,21 @@ static void zlc_mark_zone_full(struct zo
 	set_bit(i, zlc->fullzones);
 }
 
+/*
+ * clear all zones full, called after direct reclaim makes progress so that
+ * a zone that was recently full is not skipped over for up to a second
+ */
+static void zlc_clear_zones_full(struct zonelist *zonelist)
+{
+	struct zonelist_cache *zlc;	/* cached zonelist speedup info */
+
+	zlc = zonelist->zlcache_ptr;
+	if (!zlc)
+		return;
+
+	bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
+}
+
 #else	/* CONFIG_NUMA */
 
 static nodemask_t *zlc_setup(struct zonelist *zonelist, int alloc_flags)
@@ -1632,6 +1647,10 @@ static int zlc_zone_worth_trying(struct 
 static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
 {
 }
+
+static void zlc_clear_zones_full(struct zonelist *zonelist)
+{
+}
 #endif	/* CONFIG_NUMA */
 
 /*
@@ -1963,6 +1982,10 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	if (unlikely(!(*did_some_progress)))
 		return NULL;
 
+	/* After successful reclaim, reconsider all zones for allocation */
+	if (NUMA_BUILD)
+		zlc_clear_zones_full(zonelist);
+
 retry:
 	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

