From: akpm@linux-foundation.org
Subject: + mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch added to -mm tree
Date: Wed, 18 Jan 2012 15:50:15 -0800
Message-ID: <20120118235016.0EA8820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58600 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2ARXuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 18:50:18 -0500
Received: by eekb15 with SMTP id b15so140213eek.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2012 15:50:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, rientjes@google.com


The patch titled
     Subject: mm/vmscan.c: cleanup with s/reclaim_mode/isolate_mode/
has been added to the -mm tree.  Its filename is
     mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/vmscan.c: cleanup with s/reclaim_mode/isolate_mode/

With tons of reclaim_mode (defined as one field of struct scan_control)
already in the file, it is clearer to rename the local reclaim_mode when
setting up the isolation mode.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode
+++ a/mm/vmscan.c
@@ -1509,7 +1509,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_file;
 	unsigned long nr_dirty = 0;
 	unsigned long nr_writeback = 0;
-	isolate_mode_t reclaim_mode = ISOLATE_INACTIVE;
+	isolate_mode_t isolate_mode = ISOLATE_INACTIVE;
 	struct zone *zone = mz->zone;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
@@ -1522,20 +1522,20 @@ shrink_inactive_list(unsigned long nr_to
 
 	set_reclaim_mode(priority, sc, false);
 	if (sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM)
-		reclaim_mode |= ISOLATE_ACTIVE;
+		isolate_mode |= ISOLATE_ACTIVE;
 
 	lru_add_drain();
 
 	if (!sc->may_unmap)
-		reclaim_mode |= ISOLATE_UNMAPPED;
+		isolate_mode |= ISOLATE_UNMAPPED;
 	if (!sc->may_writepage)
-		reclaim_mode |= ISOLATE_CLEAN;
+		isolate_mode |= ISOLATE_CLEAN;
 
 	spin_lock_irq(&zone->lru_lock);
 
 	nr_taken = isolate_lru_pages(nr_to_scan, mz, &page_list,
 				     &nr_scanned, sc->order,
-				     reclaim_mode, 0, file);
+				     isolate_mode, 0, file);
 	if (global_reclaim(sc)) {
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
@@ -1699,21 +1699,21 @@ static void shrink_active_list(unsigned 
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 	unsigned long nr_rotated = 0;
-	isolate_mode_t reclaim_mode = ISOLATE_ACTIVE;
+	isolate_mode_t isolate_mode = ISOLATE_ACTIVE;
 	struct zone *zone = mz->zone;
 
 	lru_add_drain();
 
 	if (!sc->may_unmap)
-		reclaim_mode |= ISOLATE_UNMAPPED;
+		isolate_mode |= ISOLATE_UNMAPPED;
 	if (!sc->may_writepage)
-		reclaim_mode |= ISOLATE_CLEAN;
+		isolate_mode |= ISOLATE_CLEAN;
 
 	spin_lock_irq(&zone->lru_lock);
 
 	nr_taken = isolate_lru_pages(nr_to_scan, mz, &l_hold,
 				     &nr_scanned, sc->order,
-				     reclaim_mode, 1, file);
+				     isolate_mode, 1, file);
 	if (global_reclaim(sc))
 		zone->pages_scanned += nr_scanned;
 
_
Subject: Subject: mm/vmscan.c: cleanup with s/reclaim_mode/isolate_mode/

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch

