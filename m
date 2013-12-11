From: akpm@linux-foundation.org
Subject: +
 mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch added to -mm tree
Date: Wed, 11 Dec 2013 15:43:11 -0800
Message-ID: <52a8f88f.7hshQz8nud8e3XQg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3LKXnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:43:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, vbabka@suse.cz

Subject: + mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch added to -mm tree
To: vbabka@suse.cz,iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:43:11 -0800


The patch titled
     Subject: mm: compaction: do not mark unmovable pageblocks as skipped in async compaction
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch

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
Subject: mm: compaction: do not mark unmovable pageblocks as skipped in async compaction

Compaction temporarily marks pageblocks where it fails to isolate pages as
to-be-skipped in further compactions, in order to improve efficiency.  One
of the reasons to fail isolating pages is that isolation is not attempted
in pageblocks that are not of MIGRATE_MOVABLE (or CMA) type.

The problem is that blocks skipped due to not being MIGRATE_MOVABLE in
async compaction become skipped due to the temporary mark also in future
sync compaction.  Moreover, this may follow quite soon during
__alloc_page_slowpath, without much time for kswapd to clear the pageblock
skip marks.  This goes against the idea that sync compaction should try to
scan these blocks more thoroughly than the async compaction.

The fix is to ensure in async compaction that these !MIGRATE_MOVABLE
blocks are not marked to be skipped.  Note this should not affect
performance or locking impact of further async compactions, as skipping a
block due to being !MIGRATE_MOVABLE is done soon after skipping a block
marked to be skipped, both without locking.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction
+++ a/mm/compaction.c
@@ -455,6 +455,7 @@ isolate_migratepages_range(struct zone *
 	unsigned long flags;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
+	bool skipped_async_unsuitable = false;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -530,6 +531,7 @@ isolate_migratepages_range(struct zone *
 		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
 		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
 			cc->finished_update_migrate = true;
+			skipped_async_unsuitable = true;
 			goto next_pageblock;
 		}
 
@@ -623,8 +625,13 @@ next_pageblock:
 	if (locked)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
-	/* Update the pageblock-skip if the whole pageblock was scanned */
-	if (low_pfn == end_pfn)
+	/*
+	 * Update the pageblock-skip information and cached scanner pfn,
+	 * if the whole pageblock was scanned without isolating any page.
+	 * This is not done when pageblock was skipped due to being unsuitable
+	 * for async compaction, so that eventual sync compaction can try.
+	 */
+	if (low_pfn == end_pfn && !skipped_async_unsuitable)
 		update_pageblock_skip(cc, valid_page, nr_isolated, true);
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
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

