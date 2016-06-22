From: akpm@linux-foundation.org
Subject: + mm-compaction-abort-free-scanner-if-split-fails.patch added to
 -mm tree
Date: Wed, 22 Jun 2016 14:51:28 -0700
Message-ID: <576b0860.CD397APEX+VbSjGJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbcFVVv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 17:51:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hughd@google.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, minchan@kernel.org, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: abort free scanner if split fails
has been added to the -mm tree.  Its filename is
     mm-compaction-abort-free-scanner-if-split-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-abort-free-scanner-if-split-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-abort-free-scanner-if-split-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: abort free scanner if split fails

If the memory compaction free scanner cannot successfully split a free
page (only possible due to per-zone low watermark), terminate the free
scanner rather than continuing to scan memory needlessly.  If the
watermark is insufficient for a free page of order <= cc->order, then
terminate the scanner since all future splits will also likely fail.

This prevents the compaction freeing scanner from scanning all memory on
very large zones (very noticeable for zones > 128GB, for instance) when
all splits will likely fail while holding zone->lock.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1606211820350.97086@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff -puN mm/compaction.c~mm-compaction-abort-free-scanner-if-split-fails mm/compaction.c
--- a/mm/compaction.c~mm-compaction-abort-free-scanner-if-split-fails
+++ a/mm/compaction.c
@@ -441,25 +441,23 @@ static unsigned long isolate_freepages_b
 
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
+		if (!isolated)
+			break;
+
 		total_isolated += isolated;
+		cc->nr_freepages += isolated;
 		for (i = 0; i < isolated; i++) {
 			list_add(&page->lru, freelist);
 			page++;
 		}
-
-		/* If a page was split, advance to the end of it */
-		if (isolated) {
-			cc->nr_freepages += isolated;
-			if (!strict &&
-				cc->nr_migratepages <= cc->nr_freepages) {
-				blockpfn += isolated;
-				break;
-			}
-
-			blockpfn += isolated - 1;
-			cursor += isolated - 1;
-			continue;
+		if (!strict && cc->nr_migratepages <= cc->nr_freepages) {
+			blockpfn += isolated;
+			break;
 		}
+		/* Advance to the end of split page */
+		blockpfn += isolated - 1;
+		cursor += isolated - 1;
+		continue;
 
 isolate_fail:
 		if (strict)
@@ -469,6 +467,9 @@ isolate_fail:
 
 	}
 
+	if (locked)
+		spin_unlock_irqrestore(&cc->zone->lock, flags);
+
 	/*
 	 * There is a tiny chance that we have read bogus compound_order(),
 	 * so be careful to not go outside of the pageblock.
@@ -490,9 +491,6 @@ isolate_fail:
 	if (strict && blockpfn < end_pfn)
 		total_isolated = 0;
 
-	if (locked)
-		spin_unlock_irqrestore(&cc->zone->lock, flags);
-
 	/* Update the pageblock-skip if the whole pageblock was scanned */
 	if (blockpfn == end_pfn)
 		update_pageblock_skip(cc, valid_page, total_isolated, false);
@@ -1011,6 +1009,7 @@ static void isolate_freepages(struct com
 				block_end_pfn = block_start_pfn,
 				block_start_pfn -= pageblock_nr_pages,
 				isolate_start_pfn = block_start_pfn) {
+		unsigned long isolated;
 
 		/*
 		 * This can iterate a massively long zone without finding any
@@ -1035,8 +1034,12 @@ static void isolate_freepages(struct com
 			continue;
 
 		/* Found a block suitable for isolating free pages from. */
-		isolate_freepages_block(cc, &isolate_start_pfn,
-					block_end_pfn, freelist, false);
+		isolated = isolate_freepages_block(cc, &isolate_start_pfn,
+						block_end_pfn, freelist, false);
+		/* If isolation failed early, do not continue needlessly */
+		if (!isolated && isolate_start_pfn < block_end_pfn &&
+		    cc->nr_migratepages > cc->nr_freepages)
+			break;
 
 		/*
 		 * If we isolated enough freepages, or aborted due to async
_

Patches currently in -mm which might be from rientjes@google.com are

mm-compaction-abort-free-scanner-if-split-fails.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix.patch

