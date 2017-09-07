From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:38:43 -0700
Message-ID: <20170907183843.8D-k3siez%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55726 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755705AbdIGSio (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:38:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, vbabka@suse.cz


The patch titled
     Subject: mm, vmscan: do not loop on too_many_isolated for ever
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: do not loop on too_many_isolated for ever

Tetsuo Handa has reported[1][2][3] that direct reclaimers might get stuck
in too_many_isolated loop basically for ever because the last few pages on
the LRU lists are isolated by the kswapd which is stuck on fs locks when
doing the pageout or slab reclaim.  This in turn means that there is
nobody to actually trigger the oom killer and the system is basically
unusable.

too_many_isolated has been introduced by 35cd78156c49 ("vmscan: throttle
direct reclaim when too many pages are isolated already") to prevent from
pre-mature oom killer invocations because back then no reclaim progress
could indeed trigger the OOM killer too early.  But since the oom
detection rework 0a0337e0d1d1 ("mm, oom: rework oom detection") the
allocation/reclaim retry loop considers all the reclaimable pages and
throttles the allocation at that layer so we can loosen the direct reclaim
throttling.

Make shrink_inactive_list loop over too_many_isolated bounded and returns
immediately when the situation hasn't resolved after the first sleep. 
Replace congestion_wait by a simple schedule_timeout_interruptible because
we are not really waiting on the IO congestion in this path.

Please note that this patch can theoretically cause the OOM killer to
trigger earlier while there are many pages isolated for the reclaim which
makes progress only very slowly.  This would be obvious from the oom
report as the number of isolated pages are printed there.  If we ever hit
this should_reclaim_retry should consider those numbers in the evaluation
in one way or another.

[1] http://lkml.kernel.org/r/201602092349.ACG81273.OSVtMJQHLOFOFF@I-love.SAKURA.ne.jp
[2] http://lkml.kernel.org/r/201702212335.DJB30777.JOFMHSFtVLQOOF@I-love.SAKURA.ne.jp
[3] http://lkml.kernel.org/r/201706300914.CEH95859.FMQOLVFHJFtOOS@I-love.SAKURA.ne.jp

[mhocko@suse.com: switch to uninterruptible sleep]
  Link: http://lkml.kernel.org/r/20170724065048.GB25221@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/20170710074842.23175-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-loop-on-too_many_isolated-for-ever mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-loop-on-too_many_isolated-for-ever
+++ a/mm/vmscan.c
@@ -1743,9 +1743,15 @@ shrink_inactive_list(unsigned long nr_to
 	int file = is_file_lru(lru);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
+	bool stalled = false;
 
 	while (unlikely(too_many_isolated(pgdat, file, sc))) {
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
+		if (stalled)
+			return 0;
+
+		/* wait a bit for the reclaimer. */
+		msleep(100);
+		stalled = true;
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-memory_hotplug-introduce-add_pages.patch
mm-sparse-fix-typo-in-online_mem_sections.patch
fs-proc-remove-priv-argument-from-is_stack.patch
treewide-remove-gfp_temporary-allocation-flag.patch

