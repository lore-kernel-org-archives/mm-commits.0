From: akpm@linux-foundation.org
Subject: + mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch added to -mm tree
Date: Wed, 19 Jul 2017 15:20:25 -0700
Message-ID: <596fdb29.Rck7aelOL5sXrpYQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36376 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755587AbdGSWU0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 18:20:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: do not loop on too_many_isolated for ever
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1742,9 +1742,15 @@ shrink_inactive_list(unsigned long nr_to
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
+		schedule_timeout_interruptible(HZ/10);
+		stalled = true;
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch

