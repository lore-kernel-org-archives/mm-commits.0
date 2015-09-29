From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch added to -mm tree
Date: Tue, 29 Sep 2015 14:07:38 -0700
Message-ID: <560afd9a./R79Ef2S5E+Cqtpn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbbI2VHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:07:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove unnecessary parameter from zone_watermark_ok_safe
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch

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

