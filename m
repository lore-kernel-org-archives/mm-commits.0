From: akpm@linux-foundation.org
Subject: [patch 110/117] mm, page_alloc: remove unnecessary variable from
 free_pcppages_bulk
Date: Thu, 19 May 2016 17:14:24 -0700
Message-ID: <573e56e0.fnehZC5s4e5rw3x/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbcETAOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:14:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: remove unnecessary variable from free_pcppages_bulk

The original count is never reused so it can be removed.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk
+++ a/mm/page_alloc.c
@@ -857,7 +857,6 @@ static void free_pcppages_bulk(struct zo
 {
 	int migratetype = 0;
 	int batch_free = 0;
-	int to_free = count;
 	unsigned long nr_scanned;
 	bool isolated_pageblocks;
 
@@ -867,7 +866,7 @@ static void free_pcppages_bulk(struct zo
 	if (nr_scanned)
 		__mod_zone_page_state(zone, NR_PAGES_SCANNED, -nr_scanned);
 
-	while (to_free) {
+	while (count) {
 		struct page *page;
 		struct list_head *list;
 
@@ -887,7 +886,7 @@ static void free_pcppages_bulk(struct zo
 
 		/* This is the only non-empty list. Free them all. */
 		if (batch_free == MIGRATE_PCPTYPES)
-			batch_free = to_free;
+			batch_free = count;
 
 		do {
 			int mt;	/* migratetype of the to-be-freed page */
@@ -905,7 +904,7 @@ static void free_pcppages_bulk(struct zo
 
 			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
-		} while (--to_free && --batch_free && !list_empty(list));
+		} while (--count && --batch_free && !list_empty(list));
 	}
 	spin_unlock(&zone->lock);
 }
_
