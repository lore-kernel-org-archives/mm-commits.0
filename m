From: akpm@linux-foundation.org
Subject: +
 mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch added to -mm tree
Date: Tue, 10 Jun 2014 16:33:54 -0700
Message-ID: <539795e2.audl1JRpA5oJ3Su9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaFJXdz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 19:33:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, slaoub@gmail.com

Subject: + mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch added to -mm tree
To: slaoub@gmail.com,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,minchan@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 16:33:54 -0700


The patch titled
     Subject: mm/vmscan.c: avoid recording the original scan targets in shrink_lruvec()
has been added to the -mm tree.  Its filename is
     mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
