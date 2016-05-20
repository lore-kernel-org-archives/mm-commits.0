From: akpm@linux-foundation.org
Subject: [folded-merged] mmoom-speed-up-select_bad_process-loop-fix.patch
 removed from -mm tree
Date: Fri, 20 May 2016 16:36:33 -0700
Message-ID: <573f9f81.3JL33mW/sp7IZ6mA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETXge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:36:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmotm: mmoom-speed-up-select_bad_process-loop-fix
has been removed from the -mm tree.  Its filename was
     mmoom-speed-up-select_bad_process-loop-fix.patch

This patch was dropped because it was folded into mmoom-speed-up-select_bad_process-loop.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mmotm: mmoom-speed-up-select_bad_process-loop-fix

Do not blow the signal_struct size. pahole -C signal_struct says:

struct signal_struct {
	atomic_t                   sigcnt;               /*     0     4 */
	atomic_t                   live;                 /*     4     4 */
	int                        nr_threads;           /*     8     4 */

	/* XXX 4 bytes hole, try to pack */

	struct list_head           thread_head;          /*    16    16 */

So we can stick the new counter after nr_threads and keep the size
of the structure on 64b.

While we are at it also remove the thread_group_leader check from
select_bad_process because it is not really needed as we are iterating
processes rather than threads.

Link: http://lkml.kernel.org/r/20160520075035.GF19172@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 mm/oom_kill.c         |    3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/sched.h~mmoom-speed-up-select_bad_process-loop-fix include/linux/sched.h
--- a/include/linux/sched.h~mmoom-speed-up-select_bad_process-loop-fix
+++ a/include/linux/sched.h
@@ -669,6 +669,7 @@ struct signal_struct {
 	atomic_t		sigcnt;
 	atomic_t		live;
 	int			nr_threads;
+	atomic_t oom_victims; /* # of TIF_MEDIE threads in this thread group */
 	struct list_head	thread_head;
 
 	wait_queue_head_t	wait_chldexit;	/* for wait4() */
@@ -771,7 +772,6 @@ struct signal_struct {
 	 */
 	unsigned long long sum_sched_runtime;
 
-	atomic_t oom_victims; /* # of TIF_MEDIE threads in this thread group */
 	/*
 	 * We don't bother to synchronize most readers of this at all,
 	 * because there is no reader checking a limit that actually needs
diff -puN mm/oom_kill.c~mmoom-speed-up-select_bad_process-loop-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-speed-up-select_bad_process-loop-fix
+++ a/mm/oom_kill.c
@@ -327,9 +327,6 @@ static struct task_struct *select_bad_pr
 		points = oom_badness(p, NULL, oc->nodemask, totalpages);
 		if (!points || points < chosen_points)
 			continue;
-		/* Prefer thread group leaders for display purposes */
-		if (points == chosen_points && thread_group_leader(chosen))
-			continue;
 
 		chosen = p;
 		chosen_points = points;
_

Patches currently in -mm which might be from mhocko@suse.com are

vmscan-consider-classzone_idx-in-compaction_ready.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch
mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch
oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch
mmoom-speed-up-select_bad_process-loop.patch

