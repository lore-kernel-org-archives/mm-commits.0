From: akpm@linux-foundation.org
Subject: + sched-increase-ksoftirqd-priority.patch added to -mm tree
Date: Thu, 19 Apr 2007 14:02:08 -0700
Message-ID: <200704192102.l3JL28Qi030545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766993AbXDSVHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 17:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org


The patch titled
     sched: increase ksoftirqd priority
has been added to the -mm tree.  Its filename is
     sched-increase-ksoftirqd-priority.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: increase ksoftirqd priority
From: Con Kolivas <kernel@kolivas.org>

More aggressive nice discrimination by the Staircase-Deadline cpu scheduler
means ksoftirqd is getting significantly less cpu than previously.  Adjust
nice value accordingly for similar cpu distribution.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/softirq.c~sched-increase-ksoftirqd-priority kernel/softirq.c
--- a/kernel/softirq.c~sched-increase-ksoftirqd-priority
+++ a/kernel/softirq.c
@@ -489,7 +489,7 @@ void __init softirq_init(void)
 
 static int ksoftirqd(void * __bind_cpu)
 {
-	set_user_nice(current, 19);
+	set_user_nice(current, 15);
 	current->flags |= PF_NOFREEZE;
 
 	set_current_state(TASK_INTERRUPTIBLE);
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
sched-increase-ksoftirqd-priority.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-implement-staircase-deadline-scheduler-docupdate.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
