From: akpm@linux-foundation.org
Subject: [patch 043/101] mm, vmscan: avoid passing in `remaining'
 unnecessarily to prepare_kswapd_sleep()
Date: Thu, 28 Jul 2016 15:46:41 -0700
Message-ID: <579a8b51.GK1CRPaPREnpANjA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbcG1Wqm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:46:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

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
