From: akpm@linux-foundation.org
Subject: +
 mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
 added to -mm tree
Date: Thu, 11 Aug 2016 14:29:41 -0700
Message-ID: <57acee45.TqN3ct1jXbwgCBjj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbcHKV3n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 17:29:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: make whole_zone flag ignore cached scanner positions
has been added to the -mm tree.  Its filename is
     mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch

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
Subject: mm, compaction: make whole_zone flag ignore cached scanner positions

Patch series "make direct compaction more deterministic")

This is mostly a followup to Michal's oom detection rework, which
highlighted the need for direct compaction to provide better feedback in
reclaim/compaction loop, so that it can reliably recognize when compaction
cannot make further progress, and allocation should invoke OOM killer or
fail.  We've discussed this at LSF/MM [1] where I proposed expanding the
async/sync migration mode used in compaction to more general "priorities".
This patchset adds one new priority that just overrides all the
heuristics and makes compaction fully scan all zones.  I don't currently
think that we need more fine-grained priorities, but we'll see.  Other
than that there's some smaller fixes and cleanups, mainly related to the
THP-specific hacks.

I've tested this with stress-highalloc in GFP_KERNEL order-4 and THP-like
order-9 scenarios.  There's some improvement for compaction stats for the
order-4, which is likely due to the better watermarks handling.  In the
previous version I reported mostly noise wrt compaction stats, and
decreased direct reclaim - now the reclaim is without difference.  I
believe this is due to the less aggressive compaction priority increase in
patch 6.

"before" is a mmotm tree prior to 4.7 release plus the first part of the
series that was sent and merged separately

                                    before        after
order-4:

Compaction stalls                    27216       30759
Compaction success                   19598       25475
Compaction failures                   7617        5283
Page migrate success                370510      464919
Page migrate failure                 25712       27987
Compaction pages isolated           849601     1041581
Compaction migrate scanned       143146541   101084990
Compaction free scanned          208355124   144863510
Compaction cost                       1403        1210

order-9:

Compaction stalls                     7311        7401
Compaction success                    1634        1683
Compaction failures                   5677        5718
Page migrate success                194657      183988
Page migrate failure                  4753        4170
Compaction pages isolated           498790      456130
Compaction migrate scanned          565371      524174
Compaction free scanned            4230296     4250744
Compaction cost                        215         203

[1] https://lwn.net/Articles/684611/



This patch (of 11):

A recent patch has added whole_zone flag that compaction sets when
scanning starts from the zone boundary, in order to report that zone has
been fully scanned in one attempt.  For allocations that want to try
really hard or cannot fail, we will want to introduce a mode where
scanning whole zone is guaranteed regardless of the cached positions.

This patch reuses the whole_zone flag in a way that if it's already passed
true to compaction, the cached scanner positions are ignored.  Employing
this flag during reclaim/compaction loop will be done in the next patch. 
This patch however converts compaction invoked from userspace via procfs
to use this flag.  Before this patch, the cached positions were first
reset to zone boundaries and then read back from struct zone, so there was
a window where a parallel compaction could replace the reset values,
making the manual compaction less effective.  Using the flag instead of
performing reset is more robust.

Link: http://lkml.kernel.org/r/20160810091226.6709-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   43 +++++++++++++++++++++----------------------
 mm/internal.h   |    2 +-
 2 files changed, 22 insertions(+), 23 deletions(-)

diff -puN mm/compaction.c~mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions
+++ a/mm/compaction.c
@@ -1492,23 +1492,29 @@ static enum compact_result compact_zone(
 
 	/*
 	 * Setup to move all movable pages to the end of the zone. Used cached
-	 * information on where the scanners should start but check that it
-	 * is initialised by ensuring the values are within zone boundaries.
+	 * information on where the scanners should start (unless we explictly
+	 * want to compact the whole zone), but check that it is initialised
+	 * by ensuring the values are within zone boundaries.
 	 */
-	cc->migrate_pfn = zone->compact_cached_migrate_pfn[sync];
-	cc->free_pfn = zone->compact_cached_free_pfn;
-	if (cc->free_pfn < start_pfn || cc->free_pfn >= end_pfn) {
-		cc->free_pfn = pageblock_start_pfn(end_pfn - 1);
-		zone->compact_cached_free_pfn = cc->free_pfn;
-	}
-	if (cc->migrate_pfn < start_pfn || cc->migrate_pfn >= end_pfn) {
+	if (cc->whole_zone) {
 		cc->migrate_pfn = start_pfn;
-		zone->compact_cached_migrate_pfn[0] = cc->migrate_pfn;
-		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
-	}
+		cc->free_pfn = pageblock_start_pfn(end_pfn - 1);
+	} else {
+		cc->migrate_pfn = zone->compact_cached_migrate_pfn[sync];
+		cc->free_pfn = zone->compact_cached_free_pfn;
+		if (cc->free_pfn < start_pfn || cc->free_pfn >= end_pfn) {
+			cc->free_pfn = pageblock_start_pfn(end_pfn - 1);
+			zone->compact_cached_free_pfn = cc->free_pfn;
+		}
+		if (cc->migrate_pfn < start_pfn || cc->migrate_pfn >= end_pfn) {
+			cc->migrate_pfn = start_pfn;
+			zone->compact_cached_migrate_pfn[0] = cc->migrate_pfn;
+			zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
+		}
 
-	if (cc->migrate_pfn == start_pfn)
-		cc->whole_zone = true;
+		if (cc->migrate_pfn == start_pfn)
+			cc->whole_zone = true;
+	}
 
 	cc->last_migrated_pfn = 0;
 
@@ -1747,14 +1753,6 @@ static void __compact_pgdat(pg_data_t *p
 		INIT_LIST_HEAD(&cc->freepages);
 		INIT_LIST_HEAD(&cc->migratepages);
 
-		/*
-		 * When called via /proc/sys/vm/compact_memory
-		 * this makes sure we compact the whole zone regardless of
-		 * cached scanner positions.
-		 */
-		if (is_via_compact_memory(cc->order))
-			__reset_isolation_suitable(zone);
-
 		if (is_via_compact_memory(cc->order) ||
 				!compaction_deferred(zone, cc->order))
 			compact_zone(zone, cc);
@@ -1790,6 +1788,7 @@ static void compact_node(int nid)
 		.order = -1,
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
+		.whole_zone = true,
 	};
 
 	__compact_pgdat(NODE_DATA(nid), &cc);
diff -puN mm/internal.h~mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions mm/internal.h
--- a/mm/internal.h~mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions
+++ a/mm/internal.h
@@ -179,7 +179,7 @@ struct compact_control {
 	enum migrate_mode mode;		/* Async or sync migration mode */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
 	bool direct_compaction;		/* False from kcompactd or /proc/... */
-	bool whole_zone;		/* Whole zone has been scanned */
+	bool whole_zone;		/* Whole zone should/has been scanned */
 	int order;			/* order a direct compactor needs */
 	const gfp_t gfp_mask;		/* gfp mask of a direct compactor */
 	const unsigned int alloc_flags;	/* alloc flags of a direct compactor */
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch

