From: akpm@linux-foundation.org
Subject: [patch 103/117] mm, page_alloc: reduce cost of fair zone
 allocation policy retry
Date: Thu, 19 May 2016 17:14:04 -0700
Message-ID: <573e56cc.XOdVuUwLwzsHwl2J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbcETAOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:14:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: reduce cost of fair zone allocation policy retry

The fair zone allocation policy is not without cost but it can be reduced
slightly.  This patch removes an unnecessary local variable, checks the
likely conditions of the fair zone policy first, uses a bool instead of a
flags check and falls through when a remote node is encountered instead of
doing a full restart.  The benefit is marginal but it's there

                                           4.6.0-rc2                  4.6.0-rc2
                                       decstat-v1r20              optfair-v1r20
Min      alloc-odr0-1               377.00 (  0.00%)           380.00 ( -0.80%)
Min      alloc-odr0-2               273.00 (  0.00%)           273.00 (  0.00%)
Min      alloc-odr0-4               226.00 (  0.00%)           227.00 ( -0.44%)
Min      alloc-odr0-8               196.00 (  0.00%)           196.00 (  0.00%)
Min      alloc-odr0-16              183.00 (  0.00%)           183.00 (  0.00%)
Min      alloc-odr0-32              175.00 (  0.00%)           173.00 (  1.14%)
Min      alloc-odr0-64              172.00 (  0.00%)           169.00 (  1.74%)
Min      alloc-odr0-128             170.00 (  0.00%)           169.00 (  0.59%)
Min      alloc-odr0-256             183.00 (  0.00%)           180.00 (  1.64%)
Min      alloc-odr0-512             191.00 (  0.00%)           190.00 (  0.52%)
Min      alloc-odr0-1024            199.00 (  0.00%)           198.00 (  0.50%)
Min      alloc-odr0-2048            204.00 (  0.00%)           204.00 (  0.00%)
Min      alloc-odr0-4096            210.00 (  0.00%)           209.00 (  0.48%)
Min      alloc-odr0-8192            213.00 (  0.00%)           213.00 (  0.00%)
Min      alloc-odr0-16384           214.00 (  0.00%)           214.00 (  0.00%)

The benefit is marginal at best but one of the most important benefits,
avoiding a second search when falling back to another node is not
triggered by this particular test so the benefit for some corner cases is
understated.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry
+++ a/mm/page_alloc.c
@@ -2680,12 +2680,10 @@ get_page_from_freelist(gfp_t gfp_mask, u
 {
 	struct zoneref *z;
 	struct zone *zone;
-	bool fair_skipped;
-	bool zonelist_rescan;
+	bool fair_skipped = false;
+	bool apply_fair = (alloc_flags & ALLOC_FAIR);
 
 zonelist_scan:
-	zonelist_rescan = false;
-
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
@@ -2705,13 +2703,16 @@ zonelist_scan:
 		 * page was allocated in should have no effect on the
 		 * time the page has in memory before being reclaimed.
 		 */
-		if (alloc_flags & ALLOC_FAIR) {
-			if (!zone_local(ac->preferred_zone, zone))
-				break;
+		if (apply_fair) {
 			if (test_bit(ZONE_FAIR_DEPLETED, &zone->flags)) {
 				fair_skipped = true;
 				continue;
 			}
+			if (!zone_local(ac->preferred_zone, zone)) {
+				if (fair_skipped)
+					goto reset_fair;
+				apply_fair = false;
+			}
 		}
 		/*
 		 * When allocating a page cache page for writing, we
@@ -2800,18 +2801,13 @@ try_this_zone:
 	 * include remote zones now, before entering the slowpath and waking
 	 * kswapd: prefer spilling to a remote zone over swapping locally.
 	 */
-	if (alloc_flags & ALLOC_FAIR) {
-		alloc_flags &= ~ALLOC_FAIR;
-		if (fair_skipped) {
-			zonelist_rescan = true;
-			reset_alloc_batches(ac->preferred_zone);
-		}
-		if (nr_online_nodes > 1)
-			zonelist_rescan = true;
-	}
