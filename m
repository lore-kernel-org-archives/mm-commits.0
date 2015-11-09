From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:44:11 -0800
Message-ID: <5640f78b.g18Ajg5f2oJU7nDd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbbKIToM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove unnecessary parameter from zone_watermark_ok_safe
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: remove unnecessary parameter from zone_watermark_ok_safe

Overall, the intent of this series is to remove the zonelist cache which
was introduced to avoid high overhead in the page allocator.  Once this is
done, it is necessary to reduce the cost of watermark checks.

The series starts with minor micro-optimisations.

Next it notes that GFP flags that affect watermark checks are abused. 
__GFP_WAIT historically identified callers that could not sleep and could
access reserves.  This was later abused to identify callers that simply
prefer to avoid sleeping and have other options.  A patch distinguishes
between atomic callers, high-priority callers and those that simply wish
to avoid sleep.

The zonelist cache has been around for a long time but it is of dubious
merit with a lot of complexity and some issues that are explained.  The
most important issue is that a failed THP allocation can cause a zone to
be treated as "full".  This potentially causes unnecessary stalls, reclaim
activity or remote fallbacks.  The issues could be fixed but it's not
worth it.  The series places a small number of other micro-optimisations
on top before examining GFP flags watermarks.

High-order watermarks enforcement can cause high-order allocations to fail
even though pages are free.  The watermark checks both protect high-order
atomic allocations and make kswapd aware of high-order pages but there is
a much better way that can be handled using migrate types.  This series
uses page grouping by mobility to reserve pageblocks for high-order
allocations with the size of the reservation depending on demand.  kswapd
awareness is maintained by examining the free lists.  By patch 12 in this
series, there are no high-order watermark checks while preserving the
properties that motivated the introduction of the watermark checks.



This patch (of 10):

No user of zone_watermark_ok_safe() specifies alloc_flags.  This patch
removes the unnecessary parameter.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/page_alloc.c        |    5 +++--
 mm/vmscan.c            |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe
+++ a/include/linux/mmzone.h
@@ -817,7 +817,7 @@ void wakeup_kswapd(struct zone *zone, in
 bool zone_watermark_ok(struct zone *z, unsigned int order,
 		unsigned long mark, int classzone_idx, int alloc_flags);
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
-		unsigned long mark, int classzone_idx, int alloc_flags);
+		unsigned long mark, int classzone_idx);
 enum memmap_context {
 	MEMMAP_EARLY,
 	MEMMAP_HOTPLUG,
diff -puN mm/page_alloc.c~mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe
+++ a/mm/page_alloc.c
@@ -2249,6 +2249,7 @@ static bool __zone_watermark_ok(struct z
 		min -= min / 2;
 	if (alloc_flags & ALLOC_HARDER)
 		min -= min / 4;
+
 #ifdef CONFIG_CMA
 	/* If allocation can't use CMA areas don't use free CMA pages */
 	if (!(alloc_flags & ALLOC_CMA))
@@ -2278,14 +2279,14 @@ bool zone_watermark_ok(struct zone *z, u
 }
 
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
-			unsigned long mark, int classzone_idx, int alloc_flags)
+			unsigned long mark, int classzone_idx)
 {
 	long free_pages = zone_page_state(z, NR_FREE_PAGES);
 
 	if (z->percpu_drift_mark && free_pages < z->percpu_drift_mark)
 		free_pages = zone_page_state_snapshot(z, NR_FREE_PAGES);
 
-	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
+	return __zone_watermark_ok(z, order, mark, classzone_idx, 0,
 								free_pages);
 }
 
diff -puN mm/vmscan.c~mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe mm/vmscan.c
--- a/mm/vmscan.c~mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe
+++ a/mm/vmscan.c
@@ -2477,7 +2477,7 @@ static inline bool compaction_ready(stru
 	balance_gap = min(low_wmark_pages(zone), DIV_ROUND_UP(
 			zone->managed_pages, KSWAPD_ZONE_BALANCE_GAP_RATIO));
 	watermark = high_wmark_pages(zone) + balance_gap + (2UL << order);
-	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, 0, 0);
+	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, 0);
 
 	/*
 	 * If compaction is deferred, reclaim up to a point where
@@ -2960,7 +2960,7 @@ static bool zone_balanced(struct zone *z
 			  unsigned long balance_gap, int classzone_idx)
 {
 	if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone) +
-				    balance_gap, classzone_idx, 0))
+				    balance_gap, classzone_idx))
 		return false;
 
 	if (IS_ENABLED(CONFIG_COMPACTION) && order && compaction_suitable(zone,
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


