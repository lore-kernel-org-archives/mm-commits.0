From: akpm@linux-foundation.org
Subject: [merged] vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:19 -0800
Message-ID: <200912152154.nBFLsJp3015349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761263AbZLOVzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:55:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, mangoo@wpkg.org, mm-commits@vger.kernel.org


The patch titled
     vmscan: do not evict inactive pages when skipping an active list scan
has been removed from the -mm tree.  Its filename was
     vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: do not evict inactive pages when skipping an active list scan
From: Rik van Riel <riel@redhat.com>

In AIM7 runs, recent kernels start swapping out anonymous pages well
before they should.  This is due to shrink_list falling through to
shrink_inactive_list if !inactive_anon_is_low(zone, sc), when all we
really wanted to do is pre-age some anonymous pages to give them extra
time to be referenced while on the inactive list.

The obvious fix is to make sure that shrink_list does not fall through to
scanning/reclaiming inactive pages when we called it to scan one of the
active lists.

This change should be safe because the loop in shrink_zone ensures that we
will still shrink the anon and file inactive lists whenever we should.

[kosaki.motohiro@jp.fujitsu.com: inactive_file_is_low() should be inactive_anon_is_low()]
Reported-by: Larry Woodman <lwoodman@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan mm/vmscan.c
--- a/mm/vmscan.c~vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan
+++ a/mm/vmscan.c
@@ -1463,20 +1463,26 @@ static int inactive_file_is_low(struct z
 	return low;
 }
 
+static int inactive_list_is_low(struct zone *zone, struct scan_control *sc,
+				int file)
+{
+	if (file)
+		return inactive_file_is_low(zone, sc);
+	else
+		return inactive_anon_is_low(zone, sc);
+}
+
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	struct zone *zone, struct scan_control *sc, int priority)
 {
 	int file = is_file_lru(lru);
 
-	if (lru == LRU_ACTIVE_FILE && inactive_file_is_low(zone, sc)) {
-		shrink_active_list(nr_to_scan, zone, sc, priority, file);
+	if (is_active_lru(lru)) {
+		if (inactive_list_is_low(zone, sc, file))
+		    shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
 
-	if (lru == LRU_ACTIVE_ANON && inactive_anon_is_low(zone, sc)) {
-		shrink_active_list(nr_to_scan, zone, sc, priority, file);
-		return 0;
-	}
 	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);
 }
 
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch

