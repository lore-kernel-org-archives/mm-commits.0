From: akpm@linux-foundation.org
Subject: +
 mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch
 added to -mm tree
Date: Wed, 11 Dec 2013 15:43:12 -0800
Message-ID: <52a8f890.fkHjhlqIAEHcCHua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3LKXnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:43:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, vbabka@suse.cz

Subject: + mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch added to -mm tree
To: vbabka@suse.cz,iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:43:12 -0800


The patch titled
     Subject: mm: compaction: reset scanner positions immediately when they meet
has been added to the -mm tree.  Its filename is
     mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch

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
Subject: mm: compaction: reset scanner positions immediately when they meet

Compaction used to start its migrate and free page scaners at the zone's
lowest and highest pfn, respectively.  Later, caching was introduced to
remember the scanners' progress across compaction attempts so that
pageblocks are not re-scanned uselessly.  Additionally, pageblocks where
isolation failed are marked to be quickly skipped when encountered again
in future compactions.

Currently, both the reset of cached pfn's and clearing of the pageblock
skip information for a zone is done in __reset_isolation_suitable().  This
function gets called when:

 - compaction is restarting after being deferred
 - compact_blockskip_flush flag is set in compact_finished() when the scanners
   meet (and not again cleared when direct compaction succeeds in allocation)
   and kswapd acts upon this flag before going to sleep

This behavior is suboptimal for several reasons:

 - when direct sync compaction is called after async compaction fails (in the
   allocation slowpath), it will effectively do nothing, unless kswapd
   happens to process the compact_blockskip_flush flag meanwhile. This is racy
   and goes against the purpose of sync compaction to more thoroughly retry
   the compaction of a zone where async compaction has failed.
   The restart-after-deferring path cannot help here as deferring happens only
   after the sync compaction fails. It is also done only for the preferred
   zone, while the compaction might be done for a fallback zone.

 - the mechanism of marking pageblock to be skipped has little value since the
   cached pfn's are reset only together with the pageblock skip flags. This
   effectively limits pageblock skip usage to parallel compactions.

This patch changes compact_finished() so that cached pfn's are reset
immediately when the scanners meet.  Clearing pageblock skip flags is
unchanged, as well as the other situations where cached pfn's are reset. 
This allows the sync-after-async compaction to retry pageblocks not marked
as skipped, such as blocks !MIGRATE_MOVABLE blocks that async compactions
now skips without marking them.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/compaction.c~mm-compaction-reset-scanner-positions-immediately-when-they-meet mm/compaction.c
--- a/mm/compaction.c~mm-compaction-reset-scanner-positions-immediately-when-they-meet
+++ a/mm/compaction.c
@@ -847,6 +847,10 @@ static int compact_finished(struct zone
 
 	/* Compaction run completes if the migrate and free scanner meet */
 	if (cc->free_pfn <= cc->migrate_pfn) {
+		/* Let the next compaction start anew. */
+		zone->compact_cached_migrate_pfn = zone->zone_start_pfn;
+		zone->compact_cached_free_pfn = zone_end_pfn(zone);
+
 		/*
 		 * Mark that the PG_migrate_skip information should be cleared
 		 * by kswapd when it goes to sleep. kswapd does not set the
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

