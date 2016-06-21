From: akpm@linux-foundation.org
Subject: +
 mm-compaction-split-freepages-without-holding-the-zone-lock-fix.patch added to -mm tree
Date: Tue, 21 Jun 2016 16:14:28 -0700
Message-ID: <5769ca54.gwMDbTOc4lLM8KUy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbcFUXOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 19:14:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, glider@google.com, hughd@google.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: split freepages without holding the zone lock fix
has been added to the -mm tree.  Its filename is
     mm-compaction-split-freepages-without-holding-the-zone-lock-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-split-freepages-without-holding-the-zone-lock-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-split-freepages-without-holding-the-zone-lock-fix.patch

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

 mm/compaction.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff -puN mm/compaction.c~mm-compaction-split-freepages-without-holding-the-zone-lock-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-split-freepages-without-holding-the-zone-lock-fix
+++ a/mm/compaction.c
@@ -497,24 +497,21 @@ static unsigned long isolate_freepages_b
 
 		/* Found a free page, will break it into order-0 pages */
 		order = page_order(page);
-		isolated = __isolate_free_page(page, page_order(page));
+		isolated = __isolate_free_page(page, order);
+		if (!isolated)
+			goto isolate_fail;
 		set_page_private(page, order);
 		total_isolated += isolated;
 		list_add_tail(&page->lru, freelist);
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
+		cc->nr_freepages += isolated;
+		if (!strict && cc->nr_migratepages <= cc->nr_freepages) {
+			blockpfn += isolated;
+			break;
 		}
+		/* Advance to end of split page */
+		blockpfn += isolated - 1;
+		cursor += isolated - 1;
+		continue;
 
 isolate_fail:
 		if (strict)
@@ -625,7 +622,7 @@ isolate_freepages_range(struct compact_c
 		 */
 	}
 
-	/* split_free_page does not map the pages */
+	/* __isolate_free_page() does not map the pages */
 	map_pages(&freelist);
 
 	if (pfn < end_pfn) {
@@ -1125,7 +1122,7 @@ static void isolate_freepages(struct com
 		}
 	}
 
-	/* split_free_page does not map the pages */
+	/* __isolate_free_page() does not map the pages */
 	map_pages(freelist);
 
 	/*
_

Patches currently in -mm which might be from rientjes@google.com are

mm-compaction-split-freepages-without-holding-the-zone-lock-fix.patch

