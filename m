From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch removed from -mm tree
Date: Fri, 29 Jul 2016 11:55:20 -0700
Message-ID: <579ba698.Z5PtsA8gqfrWnwuh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbcG2SzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: avoid passing in `remaining' unnecessarily to prepare_kswapd_sleep()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: avoid passing in `remaining' unnecessarily to prepare_kswapd_sleep()

As pointed out by Minchan Kim, the first call to prepare_kswapd_sleep()
always passes in 0 for `remaining' and the second call can trivially check
the parameter in advance.

Suggested-by: Minchan Kim <minchan@kernel.org>
Link: http://lkml.kernel.org/r/1467970510-21195-27-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep
+++ a/mm/vmscan.c
@@ -3021,15 +3021,10 @@ static bool zone_balanced(struct zone *z
  *
  * Returns true if kswapd is ready to sleep
  */
-static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
-					int classzone_idx)
+static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, int classzone_idx)
 {
 	int i;
 
-	/* If a direct reclaimer woke kswapd within HZ/10, it's premature */
-	if (remaining)
-		return false;
-
 	/*
 	 * The throttled processes are normally woken up in balance_pgdat() as
 	 * soon as pfmemalloc_watermark_ok() is true. But there is a potential
@@ -3244,7 +3239,7 @@ static void kswapd_try_to_sleep(pg_data_
 	prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 
 	/* Try to sleep for a short interval */
-	if (prepare_kswapd_sleep(pgdat, reclaim_order, remaining, classzone_idx)) {
+	if (prepare_kswapd_sleep(pgdat, reclaim_order, classzone_idx)) {
 		/*
 		 * Compaction records what page blocks it recently failed to
 		 * isolate pages from and skips them in the future scanning.
@@ -3279,7 +3274,8 @@ static void kswapd_try_to_sleep(pg_data_
 	 * After a short sleep, check if it was a premature sleep. If not, then
 	 * go fully to sleep until explicitly woken up.
 	 */
-	if (prepare_kswapd_sleep(pgdat, reclaim_order, remaining, classzone_idx)) {
+	if (!remaining &&
+	    prepare_kswapd_sleep(pgdat, reclaim_order, classzone_idx)) {
 		trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
 
 		/*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


