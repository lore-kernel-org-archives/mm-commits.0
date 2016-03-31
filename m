From: akpm@linux-foundation.org
Subject: + mm-compaction-reduce-spurious-pcplist-drains.patch added to -mm tree
Date: Thu, 31 Mar 2016 15:10:09 -0700
Message-ID: <56fda041.7lWR5x2CZKfCf3Vh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883AbcCaWKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2016 18:10:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: reduce spurious pcplist drains
has been added to the -mm tree.  Its filename is
     mm-compaction-reduce-spurious-pcplist-drains.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-reduce-spurious-pcplist-drains.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-reduce-spurious-pcplist-drains.patch

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
Subject: mm, compaction: reduce spurious pcplist drains

Compaction drains the local pcplists each time migration scanner moves
away from a cc->order aligned block where it isolated pages for migration,
so that the pages freed by migrations can merge into higher orders.

The detection is currently coarser than it could be.  The
cc->last_migrated_pfn variable should track the lowest pfn that was
isolated for migration.  But it is set to the pfn where
isolate_migratepages_block() starts scanning, which is typically the first
pfn of the pageblock.  There, the scanner might fail to isolate several
order-aligned blocks, and then isolate COMPACT_CLUSTER_MAX in another
block.  This would cause the pcplists drain to be performed, although the
scanner didn't yet finish the block where it isolated from.

This patch thus makes cc->last_migrated_pfn handling more accurate by
setting it to the pfn of an actually isolated page in
isolate_migratepages_block().  Although practical effects of this patch
are likely low, it arguably makes the intent of the code more obvious. 
Also the next patch will make async direct compaction skip blocks more
aggressively, and draining pcplists due to skipped blocks is wasteful.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN mm/compaction.c~mm-compaction-reduce-spurious-pcplist-drains mm/compaction.c
--- a/mm/compaction.c~mm-compaction-reduce-spurious-pcplist-drains
+++ a/mm/compaction.c
@@ -792,6 +792,15 @@ isolate_success:
 		cc->nr_migratepages++;
 		nr_isolated++;
 
+		/*
+		 * Record where we could have freed pages by migration and not
+		 * yet flushed them to buddy allocator.
+		 * - this is the lowest page that was isolated and likely be
+		 * then freed by migration.
+		 */
+		if (!cc->last_migrated_pfn)
+			cc->last_migrated_pfn = low_pfn;
+
 		/* Avoid isolating too much */
 		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX) {
 			++low_pfn;
@@ -1088,7 +1097,6 @@ static isolate_migrate_t isolate_migrate
 	unsigned long block_start_pfn;
 	unsigned long block_end_pfn;
 	unsigned long low_pfn;
-	unsigned long isolate_start_pfn;
 	struct page *page;
 	const isolate_mode_t isolate_mode =
 		(sysctl_compact_unevictable_allowed ? ISOLATE_UNEVICTABLE : 0) |
@@ -1143,7 +1151,6 @@ static isolate_migrate_t isolate_migrate
 			continue;
 
 		/* Perform the isolation */
-		isolate_start_pfn = low_pfn;
 		low_pfn = isolate_migratepages_block(cc, low_pfn,
 						block_end_pfn, isolate_mode);
 
@@ -1153,15 +1160,6 @@ static isolate_migrate_t isolate_migrate
 		}
 
 		/*
-		 * Record where we could have freed pages by migration and not
-		 * yet flushed them to buddy allocator.
-		 * - this is the lowest page that could have been isolated and
-		 * then freed by migration.
-		 */
-		if (cc->nr_migratepages && !cc->last_migrated_pfn)
-			cc->last_migrated_pfn = isolate_start_pfn;
