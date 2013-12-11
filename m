From: akpm@linux-foundation.org
Subject: +
 mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch added to -mm tree
Date: Wed, 11 Dec 2013 15:43:10 -0800
Message-ID: <52a8f88e.V6IzHBGe2/q0lUxk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3LKXnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:43:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, vbabka@suse.cz

Subject: + mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch added to -mm tree
To: vbabka@suse.cz,iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:43:10 -0800


The patch titled
     Subject: mm: compaction: detect when scanners meet in isolate_freepages
has been added to the -mm tree.  Its filename is
     mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch

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
Subject: mm: compaction: detect when scanners meet in isolate_freepages

Compaction of a zone is finished when the migrate scanner (which begins at
the zone's lowest pfn) meets the free page scanner (which begins at the
zone's highest pfn).  This is detected in compact_zone() and in the case
of direct compaction, the compact_blockskip_flush flag is set so that
kswapd later resets the cached scanner pfn's, and a new compaction may
again start at the zone's borders.

The meeting of the scanners can happen during either scanner's activity. 
However, it may currently fail to be detected when it occurs in the free
page scanner, due to two problems.  First, isolate_freepages() keeps
free_pfn at the highest block where it isolated pages from, for the
purposes of not missing the pages that are returned back to allocator when
migration fails.  Second, failing to isolate enough free pages due to
scanners meeting results in -ENOMEM being returned by migrate_pages(),
which makes compact_zone() bail out immediately without calling
compact_finished() that would detect scanners meeting.

This failure to detect scanners meeting might result in repeated attempts
at compaction of a zone that keep starting from the cached pfn's close to
the meeting point, and quickly failing through the -ENOMEM path, without
the cached pfns being reset, over and over.  This has been observed
(through additional tracepoints) in the third phase of the mmtests
stress-highalloc benchmark, where the allocator runs on an otherwise idle
system.  The problem was observed in the DMA32 zone, which was used as a
fallback to the preferred Normal zone, but on the 4GB system it was
actually the largest zone.  The problem is even amplified for such
fallback zone - the deferred compaction logic, which could (after being
fixed by a previous patch) reset the cached scanner pfn's, is only applied
to the preferred zone and not for the fallbacks.

The problem in the third phase of the benchmark was further amplified by
commit 81c0a2bb ("mm: page_alloc: fair zone allocator policy") which
resulted in a non-deterministic regression of the allocation success rate
from ~85% to ~65%.  This occurs in about half of benchmark runs, making
bisection problematic.  It is unlikely that the commit itself is buggy,
but it should put more pressure on the DMA32 zone during phases 1 and 2,
which may leave it more fragmented in phase 3 and expose the bugs that
this patch fixes.

The fix is to make scanners meeting in isolate_freepage() stay that way,
and to check in compact_zone() for scanners meeting when migrate_pages()
returns -ENOMEM.  The result is that compact_finished() also detects
scanners meeting and sets the compact_blockskip_flush flag to make kswapd
reset the scanner pfn's.

The results in stress-highalloc benchmark show that the "regression" by
commit 81c0a2bb in phase 3 no longer occurs, and phase 1 and 2 allocation
success rates are also significantly improved.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-compaction-detect-when-scanners-meet-in-isolate_freepages mm/compaction.c
--- a/mm/compaction.c~mm-compaction-detect-when-scanners-meet-in-isolate_freepages
+++ a/mm/compaction.c
@@ -656,7 +656,7 @@ static void isolate_freepages(struct zon
 	 * is the end of the pageblock the migration scanner is using.
 	 */
 	pfn = cc->free_pfn;
-	low_pfn = cc->migrate_pfn + pageblock_nr_pages;
+	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
 	 * Take care that if the migration scanner is at the end of the zone
@@ -672,7 +672,7 @@ static void isolate_freepages(struct zon
 	 * pages on cc->migratepages. We stop searching if the migrate
 	 * and free page scanners meet or enough free pages are isolated.
 	 */
-	for (; pfn > low_pfn && cc->nr_migratepages > nr_freepages;
+	for (; pfn >= low_pfn && cc->nr_migratepages > nr_freepages;
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
 
@@ -734,7 +734,14 @@ static void isolate_freepages(struct zon
 	/* split_free_page does not map the pages */
 	map_pages(freelist);
 
-	cc->free_pfn = high_pfn;
+	/*
+	 * If we crossed the migrate scanner, we want to keep it that way
+	 * so that compact_finished() may detect this
+	 */
+	if (pfn < low_pfn)
+		cc->free_pfn = max(pfn, zone->zone_start_pfn);
+	else
+		cc->free_pfn = high_pfn;
 	cc->nr_freepages = nr_freepages;
 }
 
@@ -1001,7 +1008,11 @@ static int compact_zone(struct zone *zon
 		if (err) {
 			putback_movable_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
-			if (err == -ENOMEM) {
+			/*
+			 * migrate_pages() may return -ENOMEM when scanners meet
+			 * and we want compact_finished() to detect it
+			 */
+			if (err == -ENOMEM && cc->free_pfn > cc->migrate_pfn) {
 				ret = COMPACT_PARTIAL;
 				goto out;
 			}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
mm-compaction-trace-compaction-begin-and-end.patch
mm-compaction-encapsulate-defer-reset-logic.patch
mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch
mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch
mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch
mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch

