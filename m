From: akpm@linux-foundation.org
Subject: + mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch added to -mm tree
Date: Thu, 20 Aug 2009 15:57:56 -0700
Message-ID: <200908202257.n7KMvugZ013800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181AbZHTW7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 18:59:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macli@brc.ubc.ca, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm/vmscan: rename zone_nr_pages() to zone_lru_nr_pages()
has been added to the -mm tree.  Its filename is
     mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/vmscan: rename zone_nr_pages() to zone_lru_nr_pages()
From: Vincent Li <macli@brc.ubc.ca>

The name `zone_nr_pages' can be mis-read as zone's (total) number pages,
but it actually returns zone's LRU list number pages.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages
+++ a/mm/vmscan.c
@@ -148,7 +148,7 @@ static struct zone_reclaim_stat *get_rec
 	return &zone->reclaim_stat;
 }
 
-static unsigned long zone_nr_pages(struct zone *zone, struct scan_control *sc,
+static unsigned long zone_lru_nr_pages(struct zone *zone, struct scan_control *sc,
 				   enum lru_list lru)
 {
 	if (!scanning_global_lru(sc))
@@ -1489,10 +1489,10 @@ static void get_scan_ratio(struct zone *
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
-	anon  = zone_nr_pages(zone, sc, LRU_ACTIVE_ANON) +
-		zone_nr_pages(zone, sc, LRU_INACTIVE_ANON);
-	file  = zone_nr_pages(zone, sc, LRU_ACTIVE_FILE) +
-		zone_nr_pages(zone, sc, LRU_INACTIVE_FILE);
+	anon  = zone_lru_nr_pages(zone, sc, LRU_ACTIVE_ANON) +
+		zone_lru_nr_pages(zone, sc, LRU_INACTIVE_ANON);
+	file  = zone_lru_nr_pages(zone, sc, LRU_ACTIVE_FILE) +
+		zone_lru_nr_pages(zone, sc, LRU_INACTIVE_FILE);
 
 	if (scanning_global_lru(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
@@ -1600,7 +1600,7 @@ static void shrink_zone(int priority, st
 		int file = is_file_lru(l);
 		unsigned long scan;
 
-		scan = zone_nr_pages(zone, sc, l);
+		scan = zone_lru_nr_pages(zone, sc, l);
 		if (priority || noswap) {
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
_

Patches currently in -mm which might be from macli@brc.ubc.ca are

mm-count-only-reclaimable-lru-pages-v2.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check.patch

