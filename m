From: akpm@linux-foundation.org
Subject: +
 mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch added
 to -mm tree
Date: Thu, 31 Mar 2016 15:10:06 -0700
Message-ID: <56fda03e.ZmEUE/lf5c738FZm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbcCaWKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2016 18:10:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: wrap calculating first and last pfn of pageblock
has been added to the -mm tree.  Its filename is
     mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch

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
Subject: mm, compaction: wrap calculating first and last pfn of pageblock

The goal here is to reduce latency (and increase success) of direct async
compaction by making it focus more on the goal of creating a high-order
page, at some expense of thoroughness.

This is based on an older attempt [1] which I didn't finish as it seemed
that it increased longer-term fragmentation.  Now it seems it doesn't, and
we have kcompactd for that goal.  The main patch (3) makes migration
scanner skip whole order-aligned blocks as soon as isolation fails in
them, as it takes just one unmigrated page to prevent a high-order buddy
page from fully merging.

Patch 4 then attempts to reduce the excessive freepage scanning (such as
reported in [2]) by allocating migration targets directly from freelists. 
Here we just need to be sure that the free pages are not from the same
block as the migrated pages.  This is also limited to direct async
compaction and is not meant to replace the more thorough free scanner for
other scenarios.

[1] https://lkml.org/lkml/2014/7/16/988
[2] http://www.spinics.net/lists/linux-mm/msg97475.html

Testing was done using stress-highalloc from mmtests, configured for order-4
GFP_KERNEL allocations:

                              4.6-rc1               4.6-rc1               4.6-rc1
                               patch2                patch3                patch4
Success 1 Min         24.00 (  0.00%)       27.00 (-12.50%)       43.00 (-79.17%)
Success 1 Mean        30.20 (  0.00%)       31.60 ( -4.64%)       51.60 (-70.86%)
Success 1 Max         37.00 (  0.00%)       35.00 (  5.41%)       73.00 (-97.30%)
Success 2 Min         42.00 (  0.00%)       32.00 ( 23.81%)       73.00 (-73.81%)
Success 2 Mean        44.00 (  0.00%)       44.80 ( -1.82%)       78.00 (-77.27%)
Success 2 Max         48.00 (  0.00%)       52.00 ( -8.33%)       81.00 (-68.75%)
Success 3 Min         91.00 (  0.00%)       92.00 ( -1.10%)       88.00 (  3.30%)
Success 3 Mean        92.20 (  0.00%)       92.80 ( -0.65%)       91.00 (  1.30%)
Success 3 Max         94.00 (  0.00%)       93.00 (  1.06%)       94.00 (  0.00%)

While the eager skipping of unsuitable blocks from patch 3 didn't affect
success rates, direct freepage allocation did improve them.

             4.6-rc1     4.6-rc1     4.6-rc1
              patch2      patch3      patch4
User         2587.42     2566.53     2413.57
System        482.89      471.20      461.71
Elapsed      1395.68     1382.00     1392.87

Times are not so useful metric for this benchmark as main portion is the
interfering kernel builds, but results do hint at reduced system times.

                                   4.6-rc1     4.6-rc1     4.6-rc1
                                    patch2      patch3      patch4
Direct pages scanned                163614      159608      123385
Kswapd pages scanned               2070139     2078790     2081385
Kswapd pages reclaimed             2061707     2069757     2073723
Direct pages reclaimed              163354      159505      122304

Reduced direct reclaim was unintended, but could be explained by more
successful first attempt at (async) direct compaction, which is attempted
before the first reclaim attempt in __alloc_pages_slowpath().

Compaction stalls                    33052       39853       55091
Compaction success                   12121       19773       37875
Compaction failures                  20931       20079       17216

Compaction is indeed more successful, and thus less likely to get
deferred, so there are also more direct compaction stalls.  

Page migrate success               3781876     3326819     2790838
Page migrate failure                 45817       41774       38113
Compaction pages isolated          7868232     6941457     5025092
Compaction migrate scanned       168160492   127269354    87087993
Compaction migrate prescanned            0           0           0
Compaction free scanned         2522142582  2326342620   743205879
Compaction free direct alloc             0           0      920792
Compaction free dir. all. miss           0           0        5865
Compaction cost                       5252        4476        3602

Patch 2 reduces migration scanned pages by 25% thanks to the eager
skipping.  Patch 3 reduces free scanned pages by 70%.  The portion of
direct allocation misses to all direct allocations is less than 1% which
should be acceptable.  Interestingly, patch 3 also reduces migration
scanned pages by another 30% on top of patch 2.  The reason is not clear,
but we can rejoice nevertheless.


This patch (of 4):

Compaction code has accumulated numerous instances of manual calculations
of the first (inclusive) and last (exclusive) pfn of a pageblock (or a
smaller block of given order), given a pfn within the pageblock.  Wrap
these calculations by introducing pageblock_start_pfn(pfn) and
pageblock_end_pfn(pfn) macros.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff -puN mm/compaction.c~mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock mm/compaction.c
--- a/mm/compaction.c~mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock
+++ a/mm/compaction.c
@@ -42,6 +42,11 @@ static inline void count_compact_events(
 #define CREATE_TRACE_POINTS
 #include <trace/events/compaction.h>
 
+#define block_start_pfn(pfn, order)	round_down(pfn, 1UL << (order))
+#define block_end_pfn(pfn, order)	ALIGN((pfn) + 1, 1UL << (order))
+#define pageblock_start_pfn(pfn)	block_start_pfn(pfn, pageblock_order)
+#define pageblock_end_pfn(pfn)		block_end_pfn(pfn, pageblock_order)
+
 static unsigned long release_freepages(struct list_head *freelist)
 {
 	struct page *page, *next;
@@ -161,7 +166,7 @@ static void reset_cached_positions(struc
 	zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
 	zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
 	zone->compact_cached_free_pfn =
-			round_down(zone_end_pfn(zone) - 1, pageblock_nr_pages);
+				pageblock_start_pfn(zone_end_pfn(zone) - 1);
 }
 
 /*
@@ -519,10 +524,10 @@ isolate_freepages_range(struct compact_c
 	LIST_HEAD(freelist);
 
 	pfn = start_pfn;
-	block_start_pfn = pfn & ~(pageblock_nr_pages - 1);
+	block_start_pfn = pageblock_start_pfn(pfn);
 	if (block_start_pfn < cc->zone->zone_start_pfn)
 		block_start_pfn = cc->zone->zone_start_pfn;
-	block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+	block_end_pfn = pageblock_end_pfn(pfn);
 
 	for (; pfn < end_pfn; pfn += isolated,
 				block_start_pfn = block_end_pfn,
@@ -538,8 +543,8 @@ isolate_freepages_range(struct compact_c
 		 * scanning range to right one.
 		 */
 		if (pfn >= block_end_pfn) {
-			block_start_pfn = pfn & ~(pageblock_nr_pages - 1);
-			block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+			block_start_pfn = pageblock_start_pfn(pfn);
+			block_end_pfn = pageblock_end_pfn(pfn);
 			block_end_pfn = min(block_end_pfn, end_pfn);
 		}
 
@@ -839,10 +844,10 @@ isolate_migratepages_range(struct compac
 
 	/* Scan block by block. First and last block may be incomplete */
 	pfn = start_pfn;
-	block_start_pfn = pfn & ~(pageblock_nr_pages - 1);
+	block_start_pfn = pageblock_start_pfn(pfn);
 	if (block_start_pfn < cc->zone->zone_start_pfn)
 		block_start_pfn = cc->zone->zone_start_pfn;
-	block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+	block_end_pfn = pageblock_end_pfn(pfn);
 
 	for (; pfn < end_pfn; pfn = block_end_pfn,
 				block_start_pfn = block_end_pfn,
@@ -937,10 +942,10 @@ static void isolate_freepages(struct com
 	 * is using.
 	 */
 	isolate_start_pfn = cc->free_pfn;
-	block_start_pfn = cc->free_pfn & ~(pageblock_nr_pages-1);
+	block_start_pfn = pageblock_start_pfn(cc->free_pfn);
 	block_end_pfn = min(block_start_pfn + pageblock_nr_pages,
 						zone_end_pfn(zone));
-	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
+	low_pfn = pageblock_start_pfn(cc->migrate_pfn);
 
 	/*
 	 * Isolate free pages until enough are available to migrate the
@@ -1094,12 +1099,12 @@ static isolate_migrate_t isolate_migrate
 	 * initialized by compact_zone()
 	 */
 	low_pfn = cc->migrate_pfn;
-	block_start_pfn = cc->migrate_pfn & ~(pageblock_nr_pages - 1);
+	block_start_pfn = pageblock_start_pfn(low_pfn);
 	if (block_start_pfn < zone->zone_start_pfn)
 		block_start_pfn = zone->zone_start_pfn;
 
 	/* Only scan within a pageblock boundary */
-	block_end_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages);
+	block_end_pfn = pageblock_end_pfn(low_pfn);
 
 	/*
 	 * Iterate over whole pageblocks until we find the first suitable.
@@ -1356,7 +1361,7 @@ static int compact_zone(struct zone *zon
 	cc->migrate_pfn = zone->compact_cached_migrate_pfn[sync];
 	cc->free_pfn = zone->compact_cached_free_pfn;
 	if (cc->free_pfn < start_pfn || cc->free_pfn >= end_pfn) {
-		cc->free_pfn = round_down(end_pfn - 1, pageblock_nr_pages);
+		cc->free_pfn = pageblock_start_pfn(end_pfn - 1);
 		zone->compact_cached_free_pfn = cc->free_pfn;
 	}
 	if (cc->migrate_pfn < start_pfn || cc->migrate_pfn >= end_pfn) {
@@ -1424,7 +1429,7 @@ check_drain:
 		if (cc->order > 0 && cc->last_migrated_pfn) {
 			int cpu;
 			unsigned long current_block_start =
-				cc->migrate_pfn & ~((1UL << cc->order) - 1);
+				block_start_pfn(cc->migrate_pfn, cc->order);
 
 			if (cc->last_migrated_pfn < current_block_start) {
 				cpu = get_cpu();
@@ -1449,7 +1454,7 @@ out:
 		cc->nr_freepages = 0;
 		VM_BUG_ON(free_pfn == 0);
 		/* The cached pfn is always the first in a pageblock */
-		free_pfn &= ~(pageblock_nr_pages-1);
+		free_pfn = pageblock_start_pfn(free_pfn);
 		/*
 		 * Only go back, not forward. The cached pfn might have been
 		 * already reset to zone end in compact_finished()
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch
mm-compaction-reduce-spurious-pcplist-drains.patch
mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction.patch

