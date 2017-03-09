From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-only-clear-pgdat-congested-dirty-writeback-state-when-balanced.patch added to -mm tree
Date: Thu, 09 Mar 2017 13:51:49 -0800
Message-ID: <58c1ce75.kehPPvGRu9tLtNJ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37344 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdCIVvv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 16:51:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, sgoel01@yahoo.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: only clear pgdat congested/dirty/writeback state when balanced
has been added to the -mm tree.  Its filename is
     mm-vmscan-only-clear-pgdat-congested-dirty-writeback-state-when-balanced.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-only-clear-pgdat-congested-dirty-writeback-state-when-balanced.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-only-clear-pgdat-congested-dirty-writeback-state-when-balanced.patch

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
Subject: mm, vmscan: only clear pgdat congested/dirty/writeback state when balanced

A pgdat tracks if recent reclaim encountered too many dirty, writeback or
congested pages.  The flags control whether kswapd writes pages back from
reclaim context, tags pages for immediate reclaim when IO completes,
whether processes block on wait_iff_congested and whether kswapd blocks
when too many pages marked for immediate reclaim are encountered.

The state is cleared in a check function with side-effects.  With the
patch "mm, vmscan: fix zone balance check in prepare_kswapd_sleep", the
timing of when the bits get cleared changed.  Due to the way the check
works, it'll clear the bits if ZONE_DMA is balanced for a GFP_DMA
allocation because it does not account for lowmem reserves properly.

For the simoop workload, kswapd is not stalling when it should due to the
premature clearing, writing pages from reclaim context like crazy and
generally being unhelpful.

This patch resets the pgdat bits related to page reclaim only when kswapd
is going to sleep.  The comparison with simoop is then

                                         4.11.0-rc1            4.11.0-rc1            4.11.0-rc1
                                            vanilla           fixcheck-v2              clear-v2
Amean    p50-Read             21670074.18 (  0.00%) 20464344.18 (  5.56%) 19786774.76 (  8.69%)
Amean    p95-Read             25456267.64 (  0.00%) 25721423.64 ( -1.04%) 24101956.27 (  5.32%)
Amean    p99-Read             29369064.73 (  0.00%) 30174230.76 ( -2.74%) 27691872.71 (  5.71%)
Amean    p50-Write                1390.30 (  0.00%)     1395.28 ( -0.36%)     1011.91 ( 27.22%)
Amean    p95-Write              412901.57 (  0.00%)    37737.74 ( 90.86%)    34874.98 ( 91.55%)
Amean    p99-Write             6668722.09 (  0.00%)   666489.04 ( 90.01%)   575449.60 ( 91.37%)
Amean    p50-Allocation          78714.31 (  0.00%)    86286.22 ( -9.62%)    84246.26 ( -7.03%)
Amean    p95-Allocation         175533.51 (  0.00%)   351812.27 (-100.42%)   400058.43 (-127.91%)
Amean    p99-Allocation         247003.02 (  0.00%)  6291171.56 (-2447.00%) 10905600.00 (-4315.17%)

Read latency is improved, write latency is mostly improved but allocation
latency is regressed.  kswapd is still reclaiming inefficiently, pages are
being written back from writeback context and a host of other issues. 
However, given the change, it needed to be spelled out why the side-effect
was moved.

Link: http://lkml.kernel.org/r/20170309075657.25121-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shantanu Goel <sgoel01@yahoo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-only-clear-pgdat-congested-dirty-writeback-state-when-balanced mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-only-clear-pgdat-congested-dirty-writeback-state-when-balanced
+++ a/mm/vmscan.c
@@ -3053,17 +3053,17 @@ static bool zone_balanced(struct zone *z
 	if (!zone_watermark_ok_safe(zone, order, mark, classzone_idx))
 		return false;
 
-	/*
-	 * If any eligible zone is balanced then the node is not considered
-	 * to be congested or dirty
-	 */
-	clear_bit(PGDAT_CONGESTED, &zone->zone_pgdat->flags);
-	clear_bit(PGDAT_DIRTY, &zone->zone_pgdat->flags);
-	clear_bit(PGDAT_WRITEBACK, &zone->zone_pgdat->flags);
-
 	return true;
 }
 
+/* Clear pgdat state for congested, dirty or under writeback. */
+static void clear_pgdat_congested(pg_data_t *pgdat)
+{
+	clear_bit(PGDAT_CONGESTED, &pgdat->flags);
+	clear_bit(PGDAT_DIRTY, &pgdat->flags);
+	clear_bit(PGDAT_WRITEBACK, &pgdat->flags);
+}
+
 /*
  * Prepare kswapd for sleeping. This verifies that there are no processes
  * waiting in throttle_direct_reclaim() and that watermarks have been met.
@@ -3100,8 +3100,10 @@ static bool prepare_kswapd_sleep(pg_data
 		if (!managed_zone(zone))
 			continue;
 
-		if (zone_balanced(zone, order, classzone_idx))
+		if (zone_balanced(zone, order, classzone_idx)) {
+			clear_pgdat_congested(pgdat);
 			return true;
+		}
 	}
 
 	return false;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-vmscan-only-clear-pgdat-congested-dirty-writeback-state-when-balanced.patch
mm-vmscan-prevent-kswapd-sleeping-prematurely-due-to-mismatched-classzone_idx.patch

