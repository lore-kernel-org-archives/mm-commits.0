From: akpm@linux-foundation.org
Subject: [patch 015/124] mm: vmscan: remove old flusher wakeup from direct reclaim path
Date: Fri, 24 Feb 2017 14:56:17 -0800
Message-ID: <58b0ba11.Dxynis9F3zLXgeeK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXW4T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:56:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, riel@redhat.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: remove old flusher wakeup from direct reclaim path

Direct reclaim has been replaced by kswapd reclaim in pretty much all
common memory pressure situations, so this code most likely doesn't
accomplish the described effect anymore.  The previous patch wakes up
flushers for all reclaimers when we encounter dirty pages at the tail end
of the LRU.  Remove the crufty old direct reclaim invocation.

Link: http://lkml.kernel.org/r/20170123181641.23938-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path
+++ a/mm/vmscan.c
@@ -2757,8 +2757,6 @@ static unsigned long do_try_to_free_page
 					  struct scan_control *sc)
 {
 	int initial_priority = sc->priority;
-	unsigned long total_scanned = 0;
-	unsigned long writeback_threshold;
 retry:
 	delayacct_freepages_start();
 
@@ -2771,7 +2769,6 @@ retry:
 		sc->nr_scanned = 0;
 		shrink_zones(zonelist, sc);
 
-		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
 			break;
 
@@ -2784,20 +2781,6 @@ retry:
 		 */
 		if (sc->priority < DEF_PRIORITY - 2)
 			sc->may_writepage = 1;
