From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-check-pageblock-suitability-once-per-pageblock.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 13:36:59 -0700
Message-ID: <53445deb.JFDzsBPyjTFYlpZw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbaDHUhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com

Subject: [merged] mm-compaction-check-pageblock-suitability-once-per-pageblock.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:36:59 -0700


The patch titled
     Subject: mm/compaction: check pageblock suitability once per pageblock
has been removed from the -mm tree.  Its filename was
     mm-compaction-check-pageblock-suitability-once-per-pageblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: check pageblock suitability once per pageblock

isolation_suitable() and migrate_async_suitable() is used to be sure that
this pageblock range is fine to be migragted.  It isn't needed to call it
on every page.  Current code do well if not suitable, but, don't do well
when suitable.

1) It re-checks isolation_suitable() on each page of a pageblock that was
   already estabilished as suitable.
2) It re-checks migrate_async_suitable() on each page of a pageblock that
   was not entered through the next_pageblock: label, because
   last_pageblock_nr is not otherwise updated.

This patch fixes situation by 1) calling isolation_suitable() only once
per pageblock and 2) always updating last_pageblock_nr to the pageblock
that was just checked.

Additionally, move PageBuddy() check after pageblock unit check, since
pageblock check is the first thing we should do and makes things more
simple.

[vbabka@suse.cz: rephrase commit description]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff -puN mm/compaction.c~mm-compaction-check-pageblock-suitability-once-per-pageblock mm/compaction.c
--- a/mm/compaction.c~mm-compaction-check-pageblock-suitability-once-per-pageblock
+++ a/mm/compaction.c
@@ -526,8 +526,25 @@ isolate_migratepages_range(struct zone *
 
 		/* If isolation recently failed, do not retry */
 		pageblock_nr = low_pfn >> pageblock_order;
-		if (!isolation_suitable(cc, page))
-			goto next_pageblock;
+		if (last_pageblock_nr != pageblock_nr) {
+			int mt;
+
+			last_pageblock_nr = pageblock_nr;
+			if (!isolation_suitable(cc, page))
+				goto next_pageblock;
+
+			/*
+			 * For async migration, also only scan in MOVABLE
+			 * blocks. Async migration is optimistic to see if
+			 * the minimum amount of work satisfies the allocation
+			 */
+			mt = get_pageblock_migratetype(page);
+			if (!cc->sync && !migrate_async_suitable(mt)) {
+				cc->finished_update_migrate = true;
+				skipped_async_unsuitable = true;
+				goto next_pageblock;
+			}
+		}
 
 		/*
 		 * Skip if free. page_order cannot be used without zone->lock
@@ -537,18 +554,6 @@ isolate_migratepages_range(struct zone *
 			continue;
 
 		/*
-		 * For async migration, also only scan in MOVABLE blocks. Async
-		 * migration is optimistic to see if the minimum amount of work
-		 * satisfies the allocation
-		 */
-		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
-		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
-			cc->finished_update_migrate = true;
-			skipped_async_unsuitable = true;
-			goto next_pageblock;
-		}
