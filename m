From: akpm@linux-foundation.org
Subject: [patch 062/101] mm, vmscan: account for skipped pages as a
 partial scan
Date: Thu, 28 Jul 2016 15:47:37 -0700
Message-ID: <579a8b89.2jvHlHK9UkqRsrBk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbcG1Wrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: account for skipped pages as a partial scan

Page reclaim determines whether a pgdat is unreclaimable by examining how
many pages have been scanned since a page was freed and comparing that to
the LRU sizes.  Skipped pages are not reclaim candidates but contribute to
scanned.  This can prematurely mark a pgdat as unreclaimable and trigger
an OOM kill.

This patch accounts for skipped pages as a partial scan so that an
unreclaimable pgdat will still be marked as such but by scaling the cost
of a skip, it'll avoid the pgdat being marked prematurely.

Link: http://lkml.kernel.org/r/1469110261-7365-6-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-account-for-skipped-pages-as-a-partial-scan mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-account-for-skipped-pages-as-a-partial-scan
+++ a/mm/vmscan.c
@@ -1424,7 +1424,7 @@ static unsigned long isolate_lru_pages(u
 	LIST_HEAD(pages_skipped);
 
 	for (scan = 0; scan < nr_to_scan && nr_taken < nr_to_scan &&
-					!list_empty(src); scan++) {
+					!list_empty(src);) {
 		struct page *page;
 
 		page = lru_to_page(src);
@@ -1438,6 +1438,12 @@ static unsigned long isolate_lru_pages(u
 			continue;
 		}
 
+		/*
+		 * Account for scanned and skipped separetly to avoid the pgdat
+		 * being prematurely marked unreclaimable by pgdat_reclaimable.
+		 */
+		scan++;
+
 		switch (__isolate_lru_page(page, mode)) {
 		case 0:
 			nr_pages = hpage_nr_pages(page);
@@ -1465,14 +1471,24 @@ static unsigned long isolate_lru_pages(u
 	 */
 	if (!list_empty(&pages_skipped)) {
 		int zid;
+		unsigned long total_skipped = 0;
 
-		list_splice(&pages_skipped, src);
 		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 			if (!nr_skipped[zid])
 				continue;
 
 			__count_zid_vm_events(PGSCAN_SKIP, zid, nr_skipped[zid]);
+			total_skipped += nr_skipped[zid];
 		}
+
+		/*
+		 * Account skipped pages as a partial scan as the pgdat may be
+		 * close to unreclaimable. If the LRU list is empty, account
+		 * skipped pages as a full scan.
+		 */
+		scan += list_empty(src) ? total_skipped : total_skipped >> 2;
+
+		list_splice(&pages_skipped, src);
 	}
 	*nr_scanned = scan;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan, scan,
_
