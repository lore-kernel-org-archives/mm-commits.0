From: akpm@linux-foundation.org
Subject: +
 mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch added to -mm tree
Date: Wed, 09 Mar 2016 11:00:09 -0800
Message-ID: <56e072b9.7oz+vfz1m6N4je8Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbcCITAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 14:00:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aarcange@redhat.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kswapd: replace kswapd compaction with waking up kcompactd
has been added to the -mm tree.  Its filename is
     mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, kswapd: replace kswapd compaction with waking up kcompactd

Similarly to direct reclaim/compaction, kswapd attempts to combine reclaim
and compaction to attempt making memory allocation of given order
available.  The details differ from direct reclaim e.g.  in having high
watermark as a goal.  The code involved in kswapd's reclaim/compaction
decisions has evolved to be quite complex.  Testing reveals that it
doesn't actually work in at least one scenario, and closer inspection
suggests that it could be greatly simplified without compromising on the
goal (make high-order page available) or efficiency (don't reclaim too
much).  The simplification relieas of doing all compaction in kcompactd,
which is simply woken up when high watermarks are reached by kswapd's
reclaim.

The scenario where kswapd compaction doesn't work was found with mmtests
test stress-highalloc configured to attempt order-9 allocations without
direct reclaim, just waking up kswapd.  There was no compaction attempt
from kswapd during the whole test.  Some added instrumentation shows what
happens:

- balance_pgdat() sets end_zone to Normal, as it's not balanced
- reclaim is attempted on DMA zone, which sets nr_attempted to 99, but it
   cannot reclaim anything, so sc.nr_reclaimed is 0
- for zones DMA32 and Normal, kswapd_shrink_zone uses testorder=0, so it
   merely checks if high watermarks were reached for base pages. This is true,
   so no reclaim is attempted. For DMA, testorder=0 wasn't used, as
   compaction_suitable() returned COMPACT_SKIPPED
- even though the pgdat_needs_compaction flag wasn't set to false, no
   compaction happens due to the condition sc.nr_reclaimed > nr_attempted
   being false (as 0 < 99)
- priority-- due to nr_reclaimed being 0, repeat until priority reaches 0
   pgdat_balanced() is false as only the small zone DMA appears balanced
   (curiously in that check, watermark appears OK and compaction_suitable()
   returns COMPACT_PARTIAL, because a lower classzone_idx is used there)

Now, even if it was decided that reclaim shouldn't be attempted on the DMA
zone, the scenario would be the same, as (sc.nr_reclaimed=0 >
nr_attempted=0) is also false.  The condition really should use >= as the
comment suggests.  Then there is a mismatch in the check for setting
pgdat_needs_compaction to false using low watermark, while the rest uses
high watermark, and who knows what other subtlety.  Hopefully this
demonstrates that this is unsustainable.

Luckily we can simplify this a lot.  The reclaim/compaction decisions make
sense for direct reclaim scenario, but in kswapd, our primary goal is to
reach high watermark in order-0 pages.  Afterwards we can attempt
compaction just once.  Unlike direct reclaim, we don't reclaim extra pages
(over the high watermark), the current code already disallows it for good
reasons.

After this patch, we simply wake up kcompactd to process the pgdat, after
we have either succeeded or failed to reach the high watermarks in kswapd,
which goes to sleep.  We pass kswapd's order and classzone_idx, so
kcompactd can apply the same criteria to determine which zones are worth
compacting.  Note that we use the classzone_idx from wakeup_kswapd(), not
balanced_classzone_idx which can include higher zones that kswapd tried to
balance too, but didn't consider them in pgdat_balanced().

Since kswapd now cannot create high-order pages itself, we need to adjust
how it determines the zones to be balanced.  The key element here is
adding a "highorder" parameter to zone_balanced, which, when set to false,
makes it consider only order-0 watermark instead of the desired higher
order (this was done previously by kswapd_shrink_zone(), but not
elsewhere).  This false is passed for example in pgdat_balanced(). 
Importantly, wakeup_kswapd() uses true to make sure kswapd and thus
kcompactd are woken up for a high-order allocation failure.

The last thing is to decide what to do with pageblock_skip bitmap handling.
Compaction maintains a pageblock_skip bitmap to record pageblocks where
isolation recently failed.  This bitmap can be reset by three ways:

1) direct compaction is restarting after going through the full deferred cycle

2) kswapd goes to sleep, and some other direct compaction has previously
    finished scanning the whole zone and set zone->compact_blockskip_flush.
    Note that a successful direct compaction clears this flag.

3) compaction was invoked manually via trigger in /proc

The case 2) is somewhat fuzzy to begin with, but after introducing
kcompactd we should update it.  The check for direct compaction in 1), and
to set the flush flag in 2) use current_is_kswapd(), which doesn't work
for kcompactd.  Thus, this patch adds bool direct_compaction to
compact_control to use in 2).  For the case 1) we remove the check
completely - unlike the former kswapd compaction, kcompactd does use the
deferred compaction functionality, so flushing tied to restarting from
deferred compaction makes sense here.

Note that when kswapd goes to sleep, kcompactd is woken up, so it will see
the flushed pageblock_skip bits.  This is different from when the former
kswapd compaction observed the bits and I believe it makes more sense.
Kcompactd can afford to be more thorough than a direct compaction trying
to limit allocation latency, or kswapd whose primary goal is to reclaim.

For testing, I used stress-highalloc configured to do order-9 allocations
with GFP_NOWAIT|__GFP_HIGH|__GFP_COMP, so they relied just on
kswapd/kcompactd reclaim/compaction (the interfering kernel builds in
phases 1 and 2 work as usual):

stress-highalloc
                        4.5-rc1+before          4.5-rc1+after
                             -nodirect              -nodirect
Success 1 Min          1.00 (  0.00%)         5.00 (-66.67%)
Success 1 Mean         1.40 (  0.00%)         6.20 (-55.00%)
Success 1 Max          2.00 (  0.00%)         7.00 (-16.67%)
Success 2 Min          1.00 (  0.00%)         5.00 (-66.67%)
Success 2 Mean         1.80 (  0.00%)         6.40 (-52.38%)
Success 2 Max          3.00 (  0.00%)         7.00 (-16.67%)
Success 3 Min         34.00 (  0.00%)        62.00 (  1.59%)
Success 3 Mean        41.80 (  0.00%)        63.80 (  1.24%)
Success 3 Max         53.00 (  0.00%)        65.00 (  2.99%)

User                          3166.67        3181.09
System                        1153.37        1158.25
Elapsed                       1768.53        1799.37

                            4.5-rc1+before   4.5-rc1+after
                                 -nodirect    -nodirect
Direct pages scanned                32938        32797
Kswapd pages scanned              2183166      2202613
Kswapd pages reclaimed            2152359      2143524
Direct pages reclaimed              32735        32545
Percentage direct scans                1%           1%
THP fault alloc                       579          612
THP collapse alloc                    304          316
THP splits                              0            0
THP fault fallback                    793          778
THP collapse fail                      11           16
Compaction stalls                    1013         1007
Compaction success                     92           67
Compaction failures                   920          939
Page migrate success               238457       721374
Page migrate failure                23021        23469
Compaction pages isolated          504695      1479924
Compaction migrate scanned         661390      8812554
Compaction free scanned          13476658     84327916
Compaction cost                       262          838

After this patch we see improvements in allocation success rate
(especially for phase 3) along with increased compaction activity.  The
compaction stalls (direct compaction) in the interfering kernel builds
(probably THP's) also decreased somewhat thanks to kcompactd activity, yet
THP alloc successes improved a bit.

Note that elapsed and user time isn't so useful for this benchmark,
because of the background interference being unpredictable.  It's just to
quickly spot some major unexpected differences.  System time is somewhat
more useful and that didn't increase.

Also (after adjusting mmtests' ftrace monitor):

Time kswapd awake               2547781     2269241
Time kcompactd awake                  0      119253
Time direct compacting           939937      557649
Time kswapd compacting                0           0
Time kcompactd compacting             0      119099

The decrease of overal time spent compacting appears to not match the
increased compaction stats.  I suspect the tasks get rescheduled and since
the ftrace monitor doesn't see that, the reported time is wall time, not
CPU time.  But arguably direct compactors care about overall latency
anyway, whether busy compacting or waiting for CPU doesn't matter.  And
that latency seems to almost halved.

It's also interesting how much time kswapd spent awake just going through
all the priorities and failing to even try compacting, over and over.

We can also configure stress-highalloc to perform both direct
reclaim/compaction and wakeup kswapd/kcompactd, by using
GFP_KERNEL|__GFP_HIGH|__GFP_COMP:

stress-highalloc
                        4.5-rc1+before         4.5-rc1+after
                               -direct               -direct
Success 1 Min          4.00 (  0.00%)        9.00 (-50.00%)
Success 1 Mean         8.00 (  0.00%)       10.00 (-19.05%)
Success 1 Max         12.00 (  0.00%)       11.00 ( 15.38%)
Success 2 Min          4.00 (  0.00%)        9.00 (-50.00%)
Success 2 Mean         8.20 (  0.00%)       10.00 (-16.28%)
Success 2 Max         13.00 (  0.00%)       11.00 (  8.33%)
Success 3 Min         75.00 (  0.00%)       74.00 (  1.33%)
Success 3 Mean        75.60 (  0.00%)       75.20 (  0.53%)
Success 3 Max         77.00 (  0.00%)       76.00 (  0.00%)

User                          3344.73       3246.04
System                        1194.24       1172.29
Elapsed                       1838.04       1836.76

                            4.5-rc1+before  4.5-rc1+after
                                   -direct     -direct
Direct pages scanned               125146      120966
Kswapd pages scanned              2119757     2135012
Kswapd pages reclaimed            2073183     2108388
Direct pages reclaimed             124909      120577
Percentage direct scans                5%          5%
THP fault alloc                       599         652
THP collapse alloc                    323         354
THP splits                              0           0
THP fault fallback                    806         793
THP collapse fail                      17          16
Compaction stalls                    2457        2025
Compaction success                    906         518
Compaction failures                  1551        1507
Page migrate success              2031423     2360608
Page migrate failure                32845       40852
Compaction pages isolated         4129761     4802025
Compaction migrate scanned       11996712    21750613
Compaction free scanned         214970969   344372001
Compaction cost                      2271        2694

In this scenario, this patch doesn't change the overall success rate as
direct compaction already tries all it can.  There's however significant
reduction in direct compaction stalls (that is, the number of allocations
that went into direct compaction).  The number of successes (i.e.  direct
compaction stalls that ended up with successful allocation) is reduced by
the same number.  This means the offload to kcompactd is working as
expected, and direct compaction is reduced either due to detecting
contention, or compaction deferred by kcompactd.  In the previous version
of this patchset there was some apparent reduction of success rate, but
the changes in this version (such as using sync compaction only), new
baseline kernel, and/or averaging results from 5 executions (my bet), made
this go away.

Ftrace-based stats seem to roughly agree:

Time kswapd awake               2532984     2326824
Time kcompactd awake                  0      257916
Time direct compacting           864839      735130
Time kswapd compacting                0           0
Time kcompactd compacting             0      257585

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 +--
 mm/internal.h   |    1 
 mm/vmscan.c     |  149 +++++++++++++++-------------------------------
 3 files changed, 55 insertions(+), 105 deletions(-)

diff -puN mm/compaction.c~mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd mm/compaction.c
--- a/mm/compaction.c~mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd
+++ a/mm/compaction.c
@@ -1191,11 +1191,11 @@ static int __compact_finished(struct zon
 
 		/*
 		 * Mark that the PG_migrate_skip information should be cleared
-		 * by kswapd when it goes to sleep. kswapd does not set the
+		 * by kswapd when it goes to sleep. kcompactd does not set the
 		 * flag itself as the decision to be clear should be directly
 		 * based on an allocation request.
 		 */
-		if (!current_is_kswapd())
+		if (cc->direct_compaction)
 			zone->compact_blockskip_flush = true;
 
 		return COMPACT_COMPLETE;
@@ -1338,10 +1338,9 @@ static int compact_zone(struct zone *zon
 
 	/*
 	 * Clear pageblock skip if there were failures recently and compaction
-	 * is about to be retried after being deferred. kswapd does not do
-	 * this reset as it'll reset the cached information when going to sleep.
+	 * is about to be retried after being deferred.
 	 */
-	if (compaction_restarting(zone, cc->order) && !current_is_kswapd())
+	if (compaction_restarting(zone, cc->order))
 		__reset_isolation_suitable(zone);
 
 	/*
@@ -1477,6 +1476,7 @@ static unsigned long compact_zone_order(
 		.mode = mode,
 		.alloc_flags = alloc_flags,
 		.classzone_idx = classzone_idx,
+		.direct_compaction = true,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
diff -puN mm/internal.h~mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd mm/internal.h
--- a/mm/internal.h~mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd
+++ a/mm/internal.h
@@ -177,6 +177,7 @@ struct compact_control {
 	unsigned long last_migrated_pfn;/* Not yet flushed page being freed */
 	enum migrate_mode mode;		/* Async or sync migration mode */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
+	bool direct_compaction;		/* False from kcompactd or /proc/... */
 	int order;			/* order a direct compactor needs */
 	const gfp_t gfp_mask;		/* gfp mask of a direct compactor */
 	const int alloc_flags;		/* alloc flags of a direct compactor */
diff -puN mm/vmscan.c~mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd mm/vmscan.c
--- a/mm/vmscan.c~mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd
+++ a/mm/vmscan.c
@@ -2968,18 +2968,23 @@ static void age_active_anon(struct zone
 	} while (memcg);
 }
 
-static bool zone_balanced(struct zone *zone, int order,
-			  unsigned long balance_gap, int classzone_idx)
+static bool zone_balanced(struct zone *zone, int order, bool highorder,
+			unsigned long balance_gap, int classzone_idx)
 {
-	if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone) +
-				    balance_gap, classzone_idx))
-		return false;
+	unsigned long mark = high_wmark_pages(zone) + balance_gap;
 
-	if (IS_ENABLED(CONFIG_COMPACTION) && order && compaction_suitable(zone,
-				order, 0, classzone_idx) == COMPACT_SKIPPED)
-		return false;
+	/*
+	 * When checking from pgdat_balanced(), kswapd should stop and sleep
+	 * when it reaches the high order-0 watermark and let kcompactd take
+	 * over. Other callers such as wakeup_kswapd() want to determine the
+	 * true high-order watermark.
+	 */
+	if (IS_ENABLED(CONFIG_COMPACTION) && !highorder) {
+		mark += (1UL << order);
+		order = 0;
+	}
 
-	return true;
+	return zone_watermark_ok_safe(zone, order, mark, classzone_idx);
 }
 
 /*
@@ -3029,7 +3034,7 @@ static bool pgdat_balanced(pg_data_t *pg
 			continue;
 		}
 
-		if (zone_balanced(zone, order, 0, i))
+		if (zone_balanced(zone, order, false, 0, i))
 			balanced_pages += zone->managed_pages;
 		else if (!order)
 			return false;
@@ -3083,10 +3088,8 @@ static bool prepare_kswapd_sleep(pg_data
  */
 static bool kswapd_shrink_zone(struct zone *zone,
 			       int classzone_idx,
-			       struct scan_control *sc,
-			       unsigned long *nr_attempted)
+			       struct scan_control *sc)
 {
-	int testorder = sc->order;
 	unsigned long balance_gap;
 	bool lowmem_pressure;
 
@@ -3094,17 +3097,6 @@ static bool kswapd_shrink_zone(struct zo
 	sc->nr_to_reclaim = max(SWAP_CLUSTER_MAX, high_wmark_pages(zone));
 
 	/*
-	 * Kswapd reclaims only single pages with compaction enabled. Trying
-	 * too hard to reclaim until contiguous free pages have become
-	 * available can hurt performance by evicting too much useful data
-	 * from memory. Do not reclaim more than needed for compaction.
-	 */
-	if (IS_ENABLED(CONFIG_COMPACTION) && sc->order &&
-			compaction_suitable(zone, sc->order, 0, classzone_idx)
-							!= COMPACT_SKIPPED)
-		testorder = 0;
-
-	/*
 	 * We put equal pressure on every zone, unless one zone has way too
 	 * many pages free already. The "too many pages" is defined as the
 	 * high wmark plus a "gap" where the gap is either the low
@@ -3118,15 +3110,12 @@ static bool kswapd_shrink_zone(struct zo
 	 * reclaim is necessary
 	 */
 	lowmem_pressure = (buffer_heads_over_limit && is_highmem(zone));
-	if (!lowmem_pressure && zone_balanced(zone, testorder,
+	if (!lowmem_pressure && zone_balanced(zone, sc->order, false,
 						balance_gap, classzone_idx))
 		return true;
 
 	shrink_zone(zone, sc, zone_idx(zone) == classzone_idx);
 
-	/* Account for the number of pages attempted to reclaim */
-	*nr_attempted += sc->nr_to_reclaim;
-
 	clear_bit(ZONE_WRITEBACK, &zone->flags);
 
 	/*
@@ -3136,7 +3125,7 @@ static bool kswapd_shrink_zone(struct zo
 	 * waits.
 	 */
 	if (zone_reclaimable(zone) &&
-	    zone_balanced(zone, testorder, 0, classzone_idx)) {
+	    zone_balanced(zone, sc->order, false, 0, classzone_idx)) {
 		clear_bit(ZONE_CONGESTED, &zone->flags);
 		clear_bit(ZONE_DIRTY, &zone->flags);
 	}
@@ -3148,7 +3137,7 @@ static bool kswapd_shrink_zone(struct zo
  * For kswapd, balance_pgdat() will work across all this node's zones until
  * they are all at high_wmark_pages(zone).
  *
- * Returns the final order kswapd was reclaiming at
+ * Returns the highest zone idx kswapd was reclaiming at
  *
  * There is special handling here for zones which are full of pinned pages.
  * This can happen if the pages are all mlocked, or if they are all used by
@@ -3165,8 +3154,7 @@ static bool kswapd_shrink_zone(struct zo
  * interoperates with the page allocator fallback scheme to ensure that aging
  * of pages is balanced across the zones.
  */
-static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
-							int *classzone_idx)
+static int balance_pgdat(pg_data_t *pgdat, int order, int classzone_idx)
 {
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
@@ -3183,9 +3171,7 @@ static unsigned long balance_pgdat(pg_da
 	count_vm_event(PAGEOUTRUN);
 
 	do {
-		unsigned long nr_attempted = 0;
 		bool raise_priority = true;
-		bool pgdat_needs_compaction = (order > 0);
 
 		sc.nr_reclaimed = 0;
 
@@ -3220,7 +3206,7 @@ static unsigned long balance_pgdat(pg_da
 				break;
 			}
 
-			if (!zone_balanced(zone, order, 0, 0)) {
+			if (!zone_balanced(zone, order, false, 0, 0)) {
 				end_zone = i;
 				break;
 			} else {
@@ -3236,24 +3222,6 @@ static unsigned long balance_pgdat(pg_da
 		if (i < 0)
 			goto out;
 
-		for (i = 0; i <= end_zone; i++) {
-			struct zone *zone = pgdat->node_zones + i;
-
-			if (!populated_zone(zone))
-				continue;
-
-			/*
-			 * If any zone is currently balanced then kswapd will
-			 * not call compaction as it is expected that the
-			 * necessary pages are already available.
-			 */
-			if (pgdat_needs_compaction &&
-					zone_watermark_ok(zone, order,
-						low_wmark_pages(zone),
-						*classzone_idx, 0))
-				pgdat_needs_compaction = false;
-		}
-
 		/*
 		 * If we're getting trouble reclaiming, start doing writepage
 		 * even in laptop mode.
@@ -3297,8 +3265,7 @@ static unsigned long balance_pgdat(pg_da
 			 * that that high watermark would be met at 100%
 			 * efficiency.
 			 */
-			if (kswapd_shrink_zone(zone, end_zone,
-					       &sc, &nr_attempted))
+			if (kswapd_shrink_zone(zone, end_zone, &sc))
 				raise_priority = false;
 		}
 
@@ -3311,49 +3278,29 @@ static unsigned long balance_pgdat(pg_da
 				pfmemalloc_watermark_ok(pgdat))
 			wake_up_all(&pgdat->pfmemalloc_wait);
 
-		/*
-		 * Fragmentation may mean that the system cannot be rebalanced
-		 * for high-order allocations in all zones. If twice the
-		 * allocation size has been reclaimed and the zones are still
-		 * not balanced then recheck the watermarks at order-0 to
-		 * prevent kswapd reclaiming excessively. Assume that a
-		 * process requested a high-order can direct reclaim/compact.
-		 */
-		if (order && sc.nr_reclaimed >= 2UL << order)
-			order = sc.order = 0;
-
 		/* Check if kswapd should be suspending */
 		if (try_to_freeze() || kthread_should_stop())
 			break;
 
 		/*
-		 * Compact if necessary and kswapd is reclaiming at least the
-		 * high watermark number of pages as requsted
-		 */
-		if (pgdat_needs_compaction && sc.nr_reclaimed > nr_attempted)
-			compact_pgdat(pgdat, order);
-
-		/*
 		 * Raise priority if scanning rate is too low or there was no
 		 * progress in reclaiming pages
 		 */
 		if (raise_priority || !sc.nr_reclaimed)
 			sc.priority--;
 	} while (sc.priority >= 1 &&
-		 !pgdat_balanced(pgdat, order, *classzone_idx));
+			!pgdat_balanced(pgdat, order, classzone_idx));
 
 out:
 	/*
-	 * Return the order we were reclaiming at so prepare_kswapd_sleep()
-	 * makes a decision on the order we were last reclaiming at. However,
-	 * if another caller entered the allocator slow path while kswapd
-	 * was awake, order will remain at the higher level
+	 * Return the highest zone idx we were reclaiming at so
+	 * prepare_kswapd_sleep() makes the same decisions as here.
 	 */
-	*classzone_idx = end_zone;
-	return order;
+	return end_zone;
 }
 
-static void kswapd_try_to_sleep(pg_data_t *pgdat, int order, int classzone_idx)
+static void kswapd_try_to_sleep(pg_data_t *pgdat, int order,
+				int classzone_idx, int balanced_classzone_idx)
 {
 	long remaining = 0;
 	DEFINE_WAIT(wait);
@@ -3364,7 +3311,8 @@ static void kswapd_try_to_sleep(pg_data_
 	prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 
 	/* Try to sleep for a short interval */
-	if (prepare_kswapd_sleep(pgdat, order, remaining, classzone_idx)) {
+	if (prepare_kswapd_sleep(pgdat, order, remaining,
+						balanced_classzone_idx)) {
 		remaining = schedule_timeout(HZ/10);
 		finish_wait(&pgdat->kswapd_wait, &wait);
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
@@ -3374,7 +3322,8 @@ static void kswapd_try_to_sleep(pg_data_
 	 * After a short sleep, check if it was a premature sleep. If not, then
 	 * go fully to sleep until explicitly woken up.
 	 */
-	if (prepare_kswapd_sleep(pgdat, order, remaining, classzone_idx)) {
+	if (prepare_kswapd_sleep(pgdat, order, remaining,
+						balanced_classzone_idx)) {
 		trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
 
 		/*
@@ -3395,6 +3344,12 @@ static void kswapd_try_to_sleep(pg_data_
 		 */
 		reset_isolation_suitable(pgdat);
 
+		/*
+		 * We have freed the memory, now we should compact it to make
+		 * allocation of the requested order possible.
+		 */
+		wakeup_kcompactd(pgdat, order, classzone_idx);
+
 		if (!kthread_should_stop())
 			schedule();
 
@@ -3424,7 +3379,6 @@ static void kswapd_try_to_sleep(pg_data_
 static int kswapd(void *p)
 {
 	unsigned long order, new_order;
-	unsigned balanced_order;
 	int classzone_idx, new_classzone_idx;
 	int balanced_classzone_idx;
 	pg_data_t *pgdat = (pg_data_t*)p;
@@ -3457,23 +3411,19 @@ static int kswapd(void *p)
 	set_freezable();
 
 	order = new_order = 0;
-	balanced_order = 0;
 	classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
 	balanced_classzone_idx = classzone_idx;
 	for ( ; ; ) {
 		bool ret;
 
 		/*
-		 * If the last balance_pgdat was unsuccessful it's unlikely a
-		 * new request of a similar or harder type will succeed soon
-		 * so consider going to sleep on the basis we reclaimed at
-		 */
-		if (balanced_order == new_order) {
-			new_order = pgdat->kswapd_max_order;
-			new_classzone_idx = pgdat->classzone_idx;
-			pgdat->kswapd_max_order =  0;
-			pgdat->classzone_idx = pgdat->nr_zones - 1;
-		}
+		 * While we were reclaiming, there might have been another
+		 * wakeup, so check the values.
+		 */
+		new_order = pgdat->kswapd_max_order;
+		new_classzone_idx = pgdat->classzone_idx;
+		pgdat->kswapd_max_order =  0;
+		pgdat->classzone_idx = pgdat->nr_zones - 1;
 
 		if (order < new_order || classzone_idx > new_classzone_idx) {
 			/*
@@ -3483,7 +3433,7 @@ static int kswapd(void *p)
 			order = new_order;
 			classzone_idx = new_classzone_idx;
 		} else {
-			kswapd_try_to_sleep(pgdat, balanced_order,
+			kswapd_try_to_sleep(pgdat, order, classzone_idx,
 						balanced_classzone_idx);
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
@@ -3503,9 +3453,8 @@ static int kswapd(void *p)
 		 */
 		if (!ret) {
 			trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
-			balanced_classzone_idx = classzone_idx;
-			balanced_order = balance_pgdat(pgdat, order,
-						&balanced_classzone_idx);
+			balanced_classzone_idx = balance_pgdat(pgdat, order,
+								classzone_idx);
 		}
 	}
 
@@ -3535,7 +3484,7 @@ void wakeup_kswapd(struct zone *zone, in
 	}
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
-	if (zone_balanced(zone, order, 0, 0))
+	if (zone_balanced(zone, order, true, 0, 0))
 		return;
 
 	trace_mm_vmscan_wakeup_kswapd(pgdat->node_id, zone_idx(zone), order);
_

Patches currently in -mm which might be from vbabka@suse.cz are

tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
mm-tracing-make-show_gfp_flags-up-to-date.patch
tools-perf-make-gfp_compact_table-up-to-date.patch
mm-tracing-unify-mm-flags-handling-in-tracepoints-and-printk.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
mm-debug-replace-dump_flags-with-the-new-printk-formats.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch
mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory.patch
mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-compaction-introduce-kcompactd-fix-3.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-tracing-refresh-__def_vmaflag_names-fix.patch
mm-use-radix_tree_iter_retry-fix.patch

