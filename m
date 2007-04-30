From: akpm@linux-foundation.org
Subject: - sched-dont-renice-kernel-threads.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:47:01 -0700
Message-ID: <200704301847.l3UIl28A011751@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946587AbXD3Srd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: dont renice kernel threads
has been removed from the -mm tree.  Its filename was
     sched-dont-renice-kernel-threads.patch

This patch was dropped because I need to clear the decks

------------------------------------------------------
Subject: sched: dont renice kernel threads
From: Con Kolivas <kernel@kolivas.org>

The practice of renicing kernel threads to negative nice values is of
questionable benefit at best, and at worst leads to larger latencies when
kernel threads are busy on behalf of other tasks.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN kernel/workqueue.c~sched-dont-renice-kernel-threads kernel/workqueue.c
--- a/kernel/workqueue.c~sched-dont-renice-kernel-threads
+++ a/kernel/workqueue.c
@@ -293,8 +293,6 @@ static int worker_thread(void *__cwq)
 	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
-	set_user_nice(current, -5);
-
 	for (;;) {
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
 		if (!freezing(current) && !cwq->should_stop
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch
sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch
sched-implement-staircase-deadline-cpu-scheduler-tweak.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix.patch
sched-implement-staircase-deadline-scheduler-further-improvements-1.patch
sched-implement-staircase-deadline-scheduler-timeslice-fixes.patch
sched-implement-staircase-scheduler-yaf-fix.patch
sched-implement-staircase-deadline-scheduler-ymf-accounting-fixes.patch
sched-ymf-typo.patch
sched-implement-staircase-deadline-scheduler-load-weight-fix.patch
sched-increase-ksoftirqd-priority.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
sched-implement-staircase-deadline-scheduler-docupdate.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
