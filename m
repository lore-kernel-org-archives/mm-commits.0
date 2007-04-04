From: akpm@linux-foundation.org
Subject: + sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch added to -mm tree
Date: Wed, 04 Apr 2007 16:04:11 -0700
Message-ID: <200704042304.l34N4BnS001331@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59029 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbXDDXEO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 19:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org, dmitry.adamushko@gmail.com


The patch titled
     sched: implement staircase deadline cpu scheduler improvements fix
has been added to the -mm tree.  Its filename is
     sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: implement staircase deadline cpu scheduler improvements fix
From: Con Kolivas <kernel@kolivas.org>

Use of memset was bogus. Fix it.

Fix exiting recalc_task_prio without p->array being updated.

Microoptimisation courtesy of Dmitry Adamushko <dmitry.adamushko@gmail.com>

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff -puN kernel/sched.c~sched-implement-staircase-deadline-cpu-scheduler-improvements-fix kernel/sched.c
--- a/kernel/sched.c~sched-implement-staircase-deadline-cpu-scheduler-improvements-fix
+++ a/kernel/sched.c
@@ -682,11 +682,13 @@ static void dequeue_task(struct task_str
  * The task is being queued on a fresh array so it has its entitlement
  * bitmap cleared.
  */
-static inline void task_new_array(struct task_struct *p, struct rq *rq)
+static void task_new_array(struct task_struct *p, struct rq *rq,
+			   struct prio_array *array)
 {
 	bitmap_zero(p->bitmap, PRIO_RANGE);
 	p->rotation = rq->prio_rotation;
 	p->time_slice = p->quota;
+	p->array = array;
 }
 
 /* Find the first slot from the relevant prio_matrix entry */
@@ -708,6 +710,8 @@ static inline int next_entitled_slot(str
 	DECLARE_BITMAP(tmp, PRIO_RANGE);
 	int search_prio, uprio = USER_PRIO(p->static_prio);
 
+	if (!rq->prio_level[uprio])
+		rq->prio_level[uprio] = MAX_RT_PRIO;
 	/*
 	 * Only priorities equal to the prio_level and above for their
 	 * static_prio are acceptable, and only if it's not better than
@@ -735,11 +739,8 @@ static inline int next_entitled_slot(str
 
 static void queue_expired(struct task_struct *p, struct rq *rq)
 {
-	p->array = rq->expired;
-	task_new_array(p, rq);
+	task_new_array(p, rq, rq->expired);
 	p->prio = p->normal_prio = first_prio_slot(p);
-	p->time_slice = p->quota;
-	p->rotation = rq->prio_rotation;
 }
 
 #ifdef CONFIG_SMP
@@ -799,9 +800,9 @@ static void recalc_task_prio(struct task
 			queue_expired(p, rq);
 			return;
 		} else
-			task_new_array(p, rq);
+			task_new_array(p, rq, array);
 	} else
-		task_new_array(p, rq);
+		task_new_array(p, rq, array);
 
 	queue_prio = next_entitled_slot(p, rq);
 	if (queue_prio >= MAX_PRIO) {
@@ -3444,7 +3445,7 @@ EXPORT_SYMBOL(sub_preempt_count);
 
 static inline void reset_prio_levels(struct rq *rq)
 {
-	memset(rq->prio_level, MAX_RT_PRIO, ARRAY_SIZE(rq->prio_level));
+	memset(rq->prio_level, 0, sizeof(int) * PRIO_RANGE);
 }
 
 /*
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
