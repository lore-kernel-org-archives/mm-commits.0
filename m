From: akpm@linux-foundation.org
Subject: [merged] mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:33 -0700
Message-ID: <20120322201733.6CF9CA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:56681 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab2CVURf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:35 -0400
Received: by mail-lb0-f202.google.com with SMTP id gj3so134062lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: cleanup with s/reclaim_mode/isolate_mode/
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/vmscan.c: cleanup with s/reclaim_mode/isolate_mode/

With tons of reclaim_mode (defined as one field of struct scan_control)
already in the file, it is clearer to rename the local reclaim_mode when
setting up the isolation mode.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
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

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch

