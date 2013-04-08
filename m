From: akpm@linux-foundation.org
Subject: + posix_timers-remove-dead-task-timer-expiry-caching.patch added to -mm tree
Date: Mon, 08 Apr 2013 16:54:18 -0700
Message-ID: <20130408235419.035A131C300@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:64885 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936555Ab3DHXyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 19:54:20 -0400
Received: by mail-ia0-f202.google.com with SMTP id p22so1622344iad.5
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 16:54:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, sgruszka@redhat.com, tglx@linutronix.de


The patch titled
     Subject: posix_timers: Remove dead task timer expiry caching
has been added to the -mm tree.  Its filename is
     posix_timers-remove-dead-task-timer-expiry-caching.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: posix_timers: Remove dead task timer expiry caching

When reading a timer sample, posix_cpu_timer_get() and
posix_cpu_timer_schedule() both perform a caching of the timer expiry time
by converting its value from absolute to relative if the task has exited.

The reason for this caching is not clear though, it could be:

1) For performance reasons: no need to calculate the delta after the
   task has died, its cputime won't change anymore.  We can thus avoid
   some locking (sighand, tasklist_lock, rq->lock for task_delta_exec(),
   ...), and various operations to calculate the sample...

2) To keep the remaining delta for the timer available after the task
   has died.  When it gets reaped, its sighand disappears, so accessing
   the process wide cputime through tsk->signal is probably not safe.

Now, is the first reason really worth it?  I have no idea if it is a case
we really want to optimize.

Considering the second reason, we return a disarmed zero'ed timer when
tsk->sighand == NULL.  So if this is an assumed reason, it's broken.  And
this case only concern process wide timers that have their group leader
reaped.  The posix cpu timer shouldn't even be available anymore at that
time.  Unless the group leader changed since we called
posix_cpu_timer_create() after an exec?

Anyway for now I'm sending this as an RFC because there may well be subtle
things I left behind.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   67 +-----------------------------------
 1 file changed, 2 insertions(+), 65 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix_timers-remove-dead-task-timer-expiry-caching kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix_timers-remove-dead-task-timer-expiry-caching
+++ a/kernel/posix-cpu-timers.c
@@ -436,23 +436,6 @@ void posix_cpu_timers_exit_group(struct
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
-static void clear_dead_task(struct k_itimer *itimer, unsigned long long now)
-{
-	struct cpu_timer_list *timer = &itimer->it.cpu;
-
-	/*
-	 * That's all for this thread or process.
-	 * We leave our residual in expires to be reported.
-	 */
-	put_task_struct(timer->task);
-	timer->task = NULL;
-	if (timer->expires < now) {
-		timer->expires = 0;
-	} else {
-		timer->expires -= now;
-	}
-}
-
 static inline int expires_gt(cputime_t expires, cputime_t new_exp)
 {
 	return expires == 0 || expires > new_exp;
@@ -737,7 +720,6 @@ static void posix_cpu_timer_get(struct k
 {
 	unsigned long long now;
 	struct task_struct *p = timer->it.cpu.task;
-	int clear_dead;
 
 	/*
 	 * Easy part: convert the reload time.
@@ -750,23 +732,11 @@ static void posix_cpu_timer_get(struct k
 		return;
 	}
 
-	if (unlikely(p == NULL)) {
-		/*
-		 * This task already died and the timer will never fire.
-		 * In this case, expires is actually the dead value.
-		 */
-	dead:
-		sample_to_timespec(timer->it_clock, timer->it.cpu.expires,
-				   &itp->it_value);
-		return;
-	}
-
 	/*
 	 * Sample the clock to take the difference with the expiry time.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &now);
-		clear_dead = p->exit_state;
 	} else {
 		read_lock(&tasklist_lock);
 		if (unlikely(p->sighand == NULL)) {
@@ -775,29 +745,16 @@ static void posix_cpu_timer_get(struct k
 			 * We can't even collect a sample any more.
 			 * Call the timer disarmed, nothing else to do.
 			 */
-			put_task_struct(p);
-			timer->it.cpu.task = NULL;
 			timer->it.cpu.expires = 0;
+			itp->it_value.tv_sec = itp->it_value.tv_nsec = 0;
 			read_unlock(&tasklist_lock);
-			goto dead;
+			return;
 		} else {
 			cpu_timer_sample_group(timer->it_clock, p, &now);
-			clear_dead = (unlikely(p->exit_state) &&
-				      thread_group_empty(p));
 		}
 		read_unlock(&tasklist_lock);
 	}
 
-	if (unlikely(clear_dead)) {
-		/*
-		 * We've noticed that the thread is dead, but
-		 * not yet reaped.  Take this opportunity to
-		 * drop our task ref.
-		 */
-		clear_dead_task(timer, now);
-		goto dead;
-	}
-
 	if (now < timer->it.cpu.expires) {
 		sample_to_timespec(timer->it_clock,
 				   timer->it.cpu.expires - now,
@@ -1027,22 +984,12 @@ void posix_cpu_timer_schedule(struct k_i
 	struct task_struct *p = timer->it.cpu.task;
 	unsigned long long now;
 
-	if (unlikely(p == NULL))
-		/*
-		 * The task was cleaned up already, no future firings.
-		 */
-		goto out;
-
 	/*
 	 * Fetch the current sample and update the timer's expiry time.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
-		if (unlikely(p->exit_state)) {
-			clear_dead_task(timer, now);
-			goto out;
-		}
 		read_lock(&tasklist_lock); /* arm_timer needs it.  */
 		spin_lock(&p->sighand->siglock);
 	} else {
@@ -1056,15 +1003,6 @@ void posix_cpu_timer_schedule(struct k_i
 			timer->it.cpu.task = p = NULL;
 			timer->it.cpu.expires = 0;
 			goto out_unlock;
-		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
-			/*
-			 * We've noticed that the thread is dead, but
-			 * not yet reaped.  Take this opportunity to
-			 * drop our task ref.
-			 */
-			cpu_timer_sample_group(timer->it_clock, p, &now);
-			clear_dead_task(timer, now);
-			goto out_unlock;
 		}
 		spin_lock(&p->sighand->siglock);
 		cpu_timer_sample_group(timer->it_clock, p, &now);
@@ -1082,7 +1020,6 @@ void posix_cpu_timer_schedule(struct k_i
 out_unlock:
 	read_unlock(&tasklist_lock);
 
-out:
 	timer->it_overrun_last = timer->it_overrun;
 	timer->it_overrun = -1;
 	++timer->it_requeue_pending;
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
selftests-add-basic-posix-timers-selftests.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
posix_timers-remove-dead-task-timer-expiry-caching.patch
mm-trace-filemap-add-and-del.patch
mm-trace-filemap-add-and-del-v2.patch
printk-tracing-rework-console-tracing.patch

