From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-more-robust-check-for-scanners-meeting.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:47:08 -0700
Message-ID: <55f08cbc.0iGKcuiCG9UT1vgX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbbIITrJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:47:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: more robust check for scanners meeting
has been removed from the -mm tree.  Its filename was
     mm-compaction-more-robust-check-for-scanners-meeting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: more robust check for scanners meeting

Assorted compaction cleanups and optimizations.  The interesting patches
are 4 and 5.  In 4, skipping of compound pages in single iteration is
improved for migration scanner, so it works also for !PageLRU compound
pages such as hugetlbfs, slab etc.  Patch 5 introduces this kind of
skipping in the free scanner.  The trick is that we can read
compound_order() without any protection, if we are careful to filter out
values larger than MAX_ORDER.  The only danger is that we skip too much. 
The same trick was already used for reading the freepage order in the
migrate scanner.

To demonstrate improvements of Patches 4 and 5 I've run stress-highalloc
from mmtests, set to simulate THP allocations (including __GFP_COMP) on a
4GB system where 1GB was occupied by hugetlbfs pages.  I'll include just
the relevant stats:

                               Patch 3     Patch 4     Patch 5

Compaction stalls                 7523        7529        7515
Compaction success                 323         304         322
Compaction failures               7200        7224        7192
Page migrate success            247778      264395      240737
Page migrate failure             15358       33184       21621
Compaction pages isolated       906928      980192      909983
Compaction migrate scanned     2005277     1692805     1498800
Compaction free scanned       13255284    11539986     9011276
Compaction cost                    288         305         277

With 5 iterations per patch, the results are still noisy, but we can see
that Patch 4 does reduce migrate_scanned by 15% thanks to skipping the
hugetlbfs pages at once.  Interestingly, free_scanned is also reduced and
I have no idea why.  Patch 5 further reduces free_scanned as expected, by
15%.  Other stats are unaffected modulo noise.

[1] https://lkml.org/lkml/2015/1/19/158


This patch (of 5):

Compaction should finish when the migration and free scanner meet, i.e. 
they reach the same pageblock.  Currently however, the test in
compact_finished() simply just compares the exact pfns, which may yield a
false negative when the free scanner position is in the middle of a
pageblock and the migration scanner reaches the begining of the same
pageblock.

This hasn't been a problem until commit e14c720efdd7 ("mm, compaction:
remember position within pageblock in free pages scanner") allowed the
free scanner position to be in the middle of a pageblock between
invocations.  The hot-fix 1d5bfe1ffb5b ("mm, compaction: prevent infinite
loop in compact_zone") prevented the issue by adding a special check in
the migration scanner to satisfy the current detection of scanners
meeting.

However, the proper fix is to make the detection more robust.  This patch
introduces the compact_scanners_met() function that returns true when the
free scanner position is in the same or lower pageblock than the migration
scanner.  The special case in isolate_migratepages() introduced by
1d5bfe1ffb5b is removed.

Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN mm/compaction.c~mm-compaction-more-robust-check-for-scanners-meeting mm/compaction.c
--- a/mm/compaction.c~mm-compaction-more-robust-check-for-scanners-meeting
+++ a/mm/compaction.c
@@ -898,6 +898,16 @@ static bool suitable_migration_target(st
 }
 
 /*
+ * Test whether the free scanner has reached the same or lower pageblock than
+ * the migration scanner, and compaction should thus terminate.
+ */
+static inline bool compact_scanners_met(struct compact_control *cc)
+{
+	return (cc->free_pfn >> pageblock_order)
+		<= (cc->migrate_pfn >> pageblock_order);
+}
+
+/*
  * Based on information in the current compact_control, find blocks
  * suitable for isolating free pages from and then isolate them.
  */
@@ -1127,12 +1137,8 @@ static isolate_migrate_t isolate_migrate
 	}
 
 	acct_isolated(zone, cc);
-	/*
-	 * Record where migration scanner will be restarted. If we end up in
-	 * the same pageblock as the free scanner, make the scanners fully
-	 * meet so that compact_finished() terminates compaction.
-	 */
-	cc->migrate_pfn = (end_pfn <= cc->free_pfn) ? low_pfn : cc->free_pfn;
+	/* Record where migration scanner will be restarted. */
+	cc->migrate_pfn = low_pfn;
 
 	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
 }
@@ -1147,7 +1153,7 @@ static int __compact_finished(struct zon
 		return COMPACT_PARTIAL;
 
 	/* Compaction run completes if the migrate and free scanner meet */
-	if (cc->free_pfn <= cc->migrate_pfn) {
+	if (compact_scanners_met(cc)) {
 		/* Let the next compaction start anew. */
 		zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
 		zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
@@ -1376,7 +1382,7 @@ static int compact_zone(struct zone *zon
 			 * migrate_pages() may return -ENOMEM when scanners meet
 			 * and we want compact_finished() to detect it
 			 */
-			if (err == -ENOMEM && cc->free_pfn > cc->migrate_pfn) {
+			if (err == -ENOMEM && !compact_scanners_met(cc)) {
 				ret = COMPACT_PARTIAL;
 				goto out;
 			}
_

Patches currently in -mm which might be from vbabka@suse.cz are


