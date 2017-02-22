From: akpm@linux-foundation.org
Subject: [patch 092/142] mm, vmscan: show the number of skipped pages in
 mm_vmscan_lru_isolate
Date: Wed, 22 Feb 2017 15:44:21 -0800
Message-ID: <58ae2255.OzGWvpPsTQljaTLb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933833AbdBVXoX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:44:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, mgorman@suse.de, minchan@kernel.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: show the number of skipped pages in mm_vmscan_lru_isolate

mm_vmscan_lru_isolate shows the number of requested, scanned and taken
pages.  This is mostly OK but on 32b systems the number of scanned pages
is quite misleading because it includes both the scanned and skipped
pages.  Moreover the skipped part is scaled based on the number of taken
pages.  Let's report the exact numbers without any additional logic and
add the number of skipped pages.  This should make the reported data much
more easier to interpret.

Link: http://lkml.kernel.org/r/20170104101942.4860-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |    8 ++++++--
 mm/vmscan.c                   |   13 +++++++------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate
+++ a/include/trace/events/vmscan.h
@@ -274,17 +274,19 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		int order,
 		unsigned long nr_requested,
 		unsigned long nr_scanned,
+		unsigned long nr_skipped,
 		unsigned long nr_taken,
 		isolate_mode_t isolate_mode,
 		int file),
 
-	TP_ARGS(classzone_idx, order, nr_requested, nr_scanned, nr_taken, isolate_mode, file),
+	TP_ARGS(classzone_idx, order, nr_requested, nr_scanned, nr_skipped, nr_taken, isolate_mode, file),
 
 	TP_STRUCT__entry(
 		__field(int, classzone_idx)
 		__field(int, order)
 		__field(unsigned long, nr_requested)
 		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_skipped)
 		__field(unsigned long, nr_taken)
 		__field(isolate_mode_t, isolate_mode)
 		__field(int, file)
@@ -295,17 +297,19 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->order = order;
 		__entry->nr_requested = nr_requested;
 		__entry->nr_scanned = nr_scanned;
+		__entry->nr_skipped = nr_skipped;
 		__entry->nr_taken = nr_taken;
 		__entry->isolate_mode = isolate_mode;
 		__entry->file = file;
 	),
 
-	TP_printk("isolate_mode=%d classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_taken=%lu file=%d",
+	TP_printk("isolate_mode=%d classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_skipped=%lu nr_taken=%lu file=%d",
 		__entry->isolate_mode,
 		__entry->classzone_idx,
 		__entry->order,
 		__entry->nr_requested,
 		__entry->nr_scanned,
+		__entry->nr_skipped,
 		__entry->nr_taken,
 		__entry->file)
 );
diff -puN mm/vmscan.c~mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate
+++ a/mm/vmscan.c
@@ -1437,6 +1437,7 @@ static unsigned long isolate_lru_pages(u
 	unsigned long nr_taken = 0;
 	unsigned long nr_zone_taken[MAX_NR_ZONES] = { 0 };
 	unsigned long nr_skipped[MAX_NR_ZONES] = { 0, };
+	unsigned long skipped = 0, total_skipped = 0;
 	unsigned long scan, nr_pages;
 	LIST_HEAD(pages_skipped);
 
@@ -1488,14 +1489,13 @@ static unsigned long isolate_lru_pages(u
 	 */
 	if (!list_empty(&pages_skipped)) {
 		int zid;
-		unsigned long total_skipped = 0;
 
 		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 			if (!nr_skipped[zid])
 				continue;
 
 			__count_zid_vm_events(PGSCAN_SKIP, zid, nr_skipped[zid]);
-			total_skipped += nr_skipped[zid];
+			skipped += nr_skipped[zid];
 		}
 
 		/*
@@ -1503,13 +1503,14 @@ static unsigned long isolate_lru_pages(u
 		 * close to unreclaimable. If the LRU list is empty, account
 		 * skipped pages as a full scan.
 		 */
-		scan += list_empty(src) ? total_skipped : total_skipped >> 2;
+		total_skipped = list_empty(src) ? skipped : skipped >> 2;
 
 		list_splice(&pages_skipped, src);
 	}
-	*nr_scanned = scan;
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan, scan,
-				    nr_taken, mode, is_file_lru(lru));
+	*nr_scanned = scan + total_skipped;
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
+				    scan, skipped, nr_taken, mode,
+				    is_file_lru(lru));
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
 	return nr_taken;
 }
_
