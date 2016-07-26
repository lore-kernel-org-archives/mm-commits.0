From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-split-freepages-without-holding-the-zone-lock-fix.patch
 removed from -mm tree
Date: Tue, 26 Jul 2016 14:54:13 -0700
Message-ID: <5797dc05.H9cmYRVEIWKjUT1E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891AbcGZVyO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:54:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, glider@google.com, hughd@google.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: split freepages without holding the zone lock fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-split-freepages-without-holding-the-zone-lock-fix.patch

This patch was dropped because it was folded into mm-compaction-split-freepages-without-holding-the-zone-lock.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm/compaction: split freepages without holding the zone lock fix

If __isolate_free_page() fails, avoid adding to freelist so we don't call
map_pages() with it.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1606211447001.43430@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/compaction.c~mm-compaction-split-freepages-without-holding-the-zone-lock-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-split-freepages-without-holding-the-zone-lock-fix
+++ a/mm/compaction.c
@@ -497,13 +497,11 @@ static unsigned long isolate_freepages_b
 
 		/* Found a free page, will break it into order-0 pages */
 		order = page_order(page);
-		isolated = __isolate_free_page(page, page_order(page));
+		isolated = __isolate_free_page(page, order);
 		set_page_private(page, order);
-
 		total_isolated += isolated;
-		cc->nr_freepages += isolated;
 		list_add_tail(&page->lru, freelist);
-
+		cc->nr_freepages += isolated;
 		if (!strict && cc->nr_migratepages <= cc->nr_freepages) {
 			blockpfn += isolated;
 			break;
@@ -622,7 +620,7 @@ isolate_freepages_range(struct compact_c
 		 */
 	}
 
-	/* split_free_page does not map the pages */
+	/* __isolate_free_page() does not map the pages */
 	map_pages(&freelist);
 
 	if (pfn < end_pfn) {
@@ -1119,7 +1117,7 @@ static void isolate_freepages(struct com
 		}
 	}
 
-	/* split_free_page does not map the pages */
+	/* __isolate_free_page() does not map the pages */
 	map_pages(freelist);
 
 	/*
_

Patches currently in -mm which might be from rientjes@google.com are

mm-compaction-split-freepages-without-holding-the-zone-lock.patch

