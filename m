From: akpm@linux-foundation.org
Subject: - sched-increase-ksoftirqd-priority.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:48:10 -0700
Message-ID: <200704301848.l3UImAsH011813@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946603AbXD3SsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:48:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mm-commits@vger.kernel.org


The patch titled
     sched: increase ksoftirqd priority
has been removed from the -mm tree.  Its filename was
     sched-increase-ksoftirqd-priority.patch

This patch was dropped because I need to clear the decks

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
