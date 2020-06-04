From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:20:53 -0700
Message-ID: <20200604172053.B3IwpvDjw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbgFDRUz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm: vmscan: drop unnecessary div0 avoidance rounding in get_scan_count()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: drop unnecessary div0 avoidance rounding in get_scan_count()

When we calculate the relative scan pressure between the anon and file LRU
lists, we have to assume that reclaim_stat can contain zeroes.  To avoid
div0 crashes, we add 1 to all denominators like so:

        anon_prio = swappiness;
        file_prio = 200 - anon_prio;

	[...]

        /*
         * The amount of pressure on anon vs file pages is inversely
         * proportional to the fraction of recently scanned pages on
         * each list that were recently referenced and in active use.
         */
        ap = anon_prio * (reclaim_stat->recent_scanned[0] + 1);
        ap /= reclaim_stat->recent_rotated[0] + 1;

        fp = file_prio * (reclaim_stat->recent_scanned[1] + 1);
        fp /= reclaim_stat->recent_rotated[1] + 1;
        spin_unlock_irq(&pgdat->lru_lock);

        fraction[0] = ap;
        fraction[1] = fp;
        denominator = ap + fp + 1;

While reclaim_stat can contain 0, it's not actually possible for ap + fp
to be 0.  One of anon_prio or file_prio could be zero, but they must still
add up to 200.  And the reclaim_stat fraction, due to the +1 in there, is
always at least 1.  So if one of the two numerators is 0, the other one
can't be.  ap + fp is always at least 1.  Drop the + 1.

Link: http://lkml.kernel.org/r/20200520232525.798933-8-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count
+++ a/mm/vmscan.c
@@ -2348,7 +2348,7 @@ static void get_scan_count(struct lruvec
 
 	fraction[0] = ap;
 	fraction[1] = fp;
-	denominator = ap + fp + 1;
+	denominator = ap + fp;
 out:
 	for_each_evictable_lru(lru) {
 		int file = is_file_lru(lru);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are
