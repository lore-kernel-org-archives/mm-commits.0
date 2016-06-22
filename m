From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-compaction-abort-free-scanner-if-split-fails.patch removed from -mm tree
Date: Wed, 22 Jun 2016 14:50:02 -0700
Message-ID: <576b080a.h6W5FsnwU6MyvHBV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbcFVVuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 17:50:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hughd@google.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: abort free scanner if split fails
has been removed from the -mm tree.  Its filename was
     mm-compaction-abort-free-scanner-if-split-fails.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: abort free scanner if split fails

If the memory compaction free scanner cannot successfully split a free
page (only possible due to per-zone low watermark), terminate the free
scanner rather than continuing to scan memory needlessly.

If the per-zone watermark is insufficient for a free page of order <=
cc->order, then terminate the scanner since future splits will also likely
fail.

This prevents the compaction freeing scanner from scanning all memory on
very large zones (very noticeable for zones > 128GB, for instance) when
all splits will likely fail.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1606211447360.43430@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/compaction.c~mm-compaction-abort-free-scanner-if-split-fails mm/compaction.c
--- a/mm/compaction.c~mm-compaction-abort-free-scanner-if-split-fails
+++ a/mm/compaction.c
@@ -496,7 +496,7 @@ static unsigned long isolate_freepages_b
 		order = page_order(page);
 		isolated = __isolate_free_page(page, order);
 		if (!isolated)
-			goto isolate_fail;
+			break;
 		set_page_private(page, order);
 		total_isolated += isolated;
 		list_add_tail(&page->lru, freelist);
@@ -518,6 +518,9 @@ isolate_fail:
 
 	}
 
+	if (locked)
+		spin_unlock_irqrestore(&cc->zone->lock, flags);
+
 	/*
 	 * There is a tiny chance that we have read bogus compound_order(),
 	 * so be careful to not go outside of the pageblock.
@@ -539,9 +542,6 @@ isolate_fail:
 	if (strict && blockpfn < end_pfn)
 		total_isolated = 0;
 
-	if (locked)
-		spin_unlock_irqrestore(&cc->zone->lock, flags);
-
 	/* Update the pageblock-skip if the whole pageblock was scanned */
 	if (blockpfn == end_pfn)
 		update_pageblock_skip(cc, valid_page, total_isolated, false);
@@ -1066,6 +1066,7 @@ static void isolate_freepages(struct com
 				block_end_pfn = block_start_pfn,
 				block_start_pfn -= pageblock_nr_pages,
 				isolate_start_pfn = block_start_pfn) {
+		unsigned long isolated;
 
 		/*
 		 * This can iterate a massively long zone without finding any
@@ -1090,8 +1091,12 @@ static void isolate_freepages(struct com
 			continue;
 
 		/* Found a block suitable for isolating free pages from. */
-		isolate_freepages_block(cc, &isolate_start_pfn,
-					block_end_pfn, freelist, false);
+		isolated = isolate_freepages_block(cc, &isolate_start_pfn,
+						block_end_pfn, freelist, false);
+		/* If isolation failed, do not continue needlessly */
+		if (!isolated && isolate_start_pfn < block_end_pfn &&
+		    cc->nr_freepages <= cc->nr_migratepages)
+			break;
 
 		/*
 		 * If we isolated enough freepages, or aborted due to async
_

Patches currently in -mm which might be from rientjes@google.com are

mm-compaction-split-freepages-without-holding-the-zone-lock-fix.patch

