From: akpm@linux-foundation.org
Subject: +
 mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-2.patch added to -mm tree
Date: Tue, 14 Mar 2017 14:11:45 -0700
Message-ID: <58c85c91.RjYMd+lWEmECwpe/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50884 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbdCNVLq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2017 17:11:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shakeelb@google.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix condition for throttle_direct_reclaim
has been added to the -mm tree.  Its filename is
     mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-100%25-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-100%25-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: fix condition for throttle_direct_reclaim

Since "mm: fix 100% CPU kswapd busyloop on unreclaimable nodes" kswapd has
been modified to give up after MAX_RECLAIM_RETRIES number of unsucessful
iterations.  Before going to sleep, kswapd thread will unconditionally
wakeup all threads sleeping on pfmemalloc_wait.  However the awoken
threads will recheck the watermarks and wake the kswapd thread and sleep
again on pfmemalloc_wait.  There is a chance that the system might end up
in livelock between unsuccessful kswapd and direct reclaimers because all
direct reclaimer might end up in throttle_direct_reclaim and there is
nobody to make a forward progress.  So, add kswapd_failures check on the
throttle_direct_reclaim condition.

Link: http://lkml.kernel.org/r/20170314183228.20152-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-2 mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-2
+++ a/mm/vmscan.c
@@ -2822,7 +2822,7 @@ retry:
 	return 0;
 }
 
-static bool pfmemalloc_watermark_ok(pg_data_t *pgdat)
+static bool allow_direct_reclaim(pg_data_t *pgdat)
 {
 	struct zone *zone;
 	unsigned long pfmemalloc_reserve = 0;
@@ -2830,6 +2830,9 @@ static bool pfmemalloc_watermark_ok(pg_d
 	int i;
 	bool wmark_ok;
 
+	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES)
+		return true;
+
 	for (i = 0; i <= ZONE_NORMAL; i++) {
 		zone = &pgdat->node_zones[i];
 		if (!managed_zone(zone) ||
@@ -2910,7 +2913,7 @@ static bool throttle_direct_reclaim(gfp_
 
 		/* Throttle based on the first usable node */
 		pgdat = zone->zone_pgdat;
-		if (pfmemalloc_watermark_ok(pgdat))
+		if (allow_direct_reclaim(pgdat))
 			goto out;
 		break;
 	}
@@ -2932,14 +2935,14 @@ static bool throttle_direct_reclaim(gfp_
 	 */
 	if (!(gfp_mask & __GFP_FS)) {
 		wait_event_interruptible_timeout(pgdat->pfmemalloc_wait,
-			pfmemalloc_watermark_ok(pgdat), HZ);
+			allow_direct_reclaim(pgdat), HZ);
 
 		goto check_pending;
 	}
 
 	/* Throttle until kswapd wakes the process */
 	wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
-		pfmemalloc_watermark_ok(pgdat));
+		allow_direct_reclaim(pgdat));
 
 check_pending:
 	if (fatal_signal_pending(current))
@@ -3119,7 +3122,7 @@ static bool prepare_kswapd_sleep(pg_data
 
 	/*
 	 * The throttled processes are normally woken up in balance_pgdat() as
-	 * soon as pfmemalloc_watermark_ok() is true. But there is a potential
+	 * soon as allow_direct_reclaim() is true. But there is a potential
 	 * race between when kswapd checks the watermarks and a process gets
 	 * throttled. There is also a potential race if processes get
 	 * throttled, kswapd wakes, a large process exits thereby balancing the
@@ -3304,7 +3307,7 @@ static int balance_pgdat(pg_data_t *pgda
 		 * able to safely make forward progress. Wake them
 		 */
 		if (waitqueue_active(&pgdat->pfmemalloc_wait) &&
-				pfmemalloc_watermark_ok(pgdat))
+				allow_direct_reclaim(pgdat))
 			wake_up_all(&pgdat->pfmemalloc_wait);
 
 		/* Check if kswapd should be suspending */
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-2.patch

