From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch removed from -mm tree
Date: Mon, 16 Jun 2014 16:42:46 -0700
Message-ID: <539f80f6.Tvg1Ts8zrVOcgtSI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaFPXmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, slaoub@gmail.com


The patch titled
     Subject: mm/vmscan.c: avoid recording the original scan targets in shrink_lruvec()
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Chen Yucong <slaoub@gmail.com>
Subject: mm/vmscan.c: avoid recording the original scan targets in shrink_lruvec()

Via https://lkml.org/lkml/2013/4/10/334, we can find that recording the
original scan targets introduces extra 40 bytes on the stack.  This patch
is able to avoid this situation and the call to memcpy().  At the same
time, it does not change the relative design idea.

ratio = original_nr_file / original_nr_anon;

If (nr_file > nr_anon), then ratio = (nr_file - x) / nr_anon.
 x = nr_file - ratio * nr_anon;

if (nr_file <= nr_anon), then ratio = nr_file / (nr_anon - x).
 x = nr_anon - nr_file / ratio;

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff -puN mm/vmscan.c~mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec
+++ a/mm/vmscan.c
@@ -2055,8 +2055,7 @@ out:
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
-	unsigned long targets[NR_LRU_LISTS];
-	unsigned long nr_to_scan;
+	unsigned long nr_to_scan, ratio;
 	enum lru_list lru;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
@@ -2065,8 +2064,8 @@ static void shrink_lruvec(struct lruvec
 
 	get_scan_count(lruvec, sc, nr);
 
-	/* Record the original scan target for proportional adjustments later */
-	memcpy(targets, nr, sizeof(nr));
+	ratio = (nr[LRU_INACTIVE_FILE] + nr[LRU_ACTIVE_FILE] + 1) /
+			(nr[LRU_INACTIVE_ANON] + nr[LRU_ACTIVE_ANON] + 1);
 
 	/*
 	 * Global reclaiming within direct reclaim at DEF_PRIORITY is a normal
@@ -2086,7 +2085,6 @@ static void shrink_lruvec(struct lruvec
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
 		unsigned long nr_anon, nr_file, percentage;
-		unsigned long nr_scanned;
 
 		for_each_evictable_lru(lru) {
 			if (nr[lru]) {
@@ -2121,15 +2119,13 @@ static void shrink_lruvec(struct lruvec
 			break;
 
 		if (nr_file > nr_anon) {
-			unsigned long scan_target = targets[LRU_INACTIVE_ANON] +
-						targets[LRU_ACTIVE_ANON] + 1;
+			nr_to_scan = nr_file - ratio * nr_anon;
+			percentage = nr[LRU_FILE] * 100 / nr_file;
 			lru = LRU_BASE;
-			percentage = nr_anon * 100 / scan_target;
 		} else {
-			unsigned long scan_target = targets[LRU_INACTIVE_FILE] +
-						targets[LRU_ACTIVE_FILE] + 1;
+			nr_to_scan = nr_anon - nr_file / ratio;
+			percentage = nr[LRU_BASE] * 100 / nr_anon;
 			lru = LRU_FILE;
-			percentage = nr_file * 100 / scan_target;
 		}
 
 		/* Stop scanning the smaller of the LRU */
@@ -2141,14 +2137,8 @@ static void shrink_lruvec(struct lruvec
 		 * scan target and the percentage scanning already complete
 		 */
 		lru = (lru == LRU_FILE) ? LRU_BASE : LRU_FILE;
-		nr_scanned = targets[lru] - nr[lru];
-		nr[lru] = targets[lru] * (100 - percentage) / 100;
-		nr[lru] -= min(nr[lru], nr_scanned);
