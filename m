From: akpm@linux-foundation.org
Subject: +
 mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-fix-2.patch
 added to -mm tree
Date: Fri, 10 Mar 2017 14:34:49 -0800
Message-ID: <58c32a09.BV734C/g7tWZN8rZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41300 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755399AbdCJWev (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 17:34:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shakeelb@google.com, hannes@cmpxchg.org, hejianet@gmail.com, hillf.zj@alibaba-inc.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix condition for throttle_direct_reclaim
has been added to the -mm tree.  Its filename is
     mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-100%25-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-100%25-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-fix-2.patch

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

Recently kswapd has been modified to give up after MAX_RECLAIM_RETRIES
number of unsucessful iterations. Before going to sleep, kswapd thread
will unconditionally wakeup all threads sleeping on pfmemalloc_wait.
However the awoken threads will recheck the watermarks and wake the
kswapd thread and sleep again on pfmemalloc_wait. There is a chance
of continuous back and forth between kswapd and direct reclaiming
threads if the kswapd keep failing and thus defeat the purpose of
adding backoff mechanism to kswapd. So, add kswapd_failures check
on the throttle_direct_reclaim condition.

Link: http://lkml.kernel.org/r/20170310194620.5021-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jia He <hejianet@gmail.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-fix-2 mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-fix-2
+++ a/mm/vmscan.c
@@ -2856,6 +2856,12 @@ static bool pfmemalloc_watermark_ok(pg_d
 	return wmark_ok;
 }
 
+static bool should_throttle_direct_reclaim(pg_data_t *pgdat)
+{
+	return (pgdat->kswapd_failures < MAX_RECLAIM_RETRIES &&
+		!pfmemalloc_watermark_ok(pgdat));
+}
+
 /*
  * Throttle direct reclaimers if backing storage is backed by the network
  * and the PFMEMALLOC reserve for the preferred node is getting dangerously
@@ -2910,7 +2916,7 @@ static bool throttle_direct_reclaim(gfp_
 
 		/* Throttle based on the first usable node */
 		pgdat = zone->zone_pgdat;
-		if (pfmemalloc_watermark_ok(pgdat))
+		if (!should_throttle_direct_reclaim(pgdat))
 			goto out;
 		break;
 	}
@@ -2932,14 +2938,14 @@ static bool throttle_direct_reclaim(gfp_
 	 */
 	if (!(gfp_mask & __GFP_FS)) {
 		wait_event_interruptible_timeout(pgdat->pfmemalloc_wait,
-			pfmemalloc_watermark_ok(pgdat), HZ);
+			!should_throttle_direct_reclaim(pgdat), HZ);
 
 		goto check_pending;
 	}
 
 	/* Throttle until kswapd wakes the process */
 	wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
-		pfmemalloc_watermark_ok(pgdat));
+		!should_throttle_direct_reclaim(pgdat));
 
 check_pending:
 	if (fatal_signal_pending(current))
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix-fix-2.patch

