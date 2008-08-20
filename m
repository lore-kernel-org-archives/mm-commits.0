From: akpm@linux-foundation.org
Subject: + posix-timers-use-struct-pid-instead-of-struct-task_struct.patch added to -mm tree
Date: Wed, 20 Aug 2008 12:11:13 -0700
Message-ID: <200808201911.m7KJBETI026770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbYHTTM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 15:12:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: use "struct pid*" instead of "struct task_struct*"
has been added to the -mm tree.  Its filename is
     posix-timers-use-struct-pid-instead-of-struct-task_struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: use "struct pid*" instead of "struct task_struct*"
From: Oleg Nesterov <oleg@tv-sign.ru>

k_itimer holds the ref to the ->it_process until sys_timer_delete().  This
allows to pin up to RLIMIT_SIGPENDING dead task_struct's.  Change the code
to use "struct pid *" instead.

The patch doesn't kill ->it_process, it places ->it_pid into the union. 
->it_process is still used by do_cpu_nanosleep() as before.  It would be
trivial to change the nanosleep code as well, but since it uses it_process
in a special way I think it is better to keep this field for grep.

The patch bloats the kernel by 104 bytes and it also adds the new pointer,
->it_signal, to k_itimer.  It is used by lock_timer() to verify that the
found timer was not created by another process.  It is not clear why do we
use the global database (and thus the global idr_lock) for posix timers. 
We still need the signal_struct->posix_timers which contains all useable
timers, perhaps it is better to use some form of per-process array
instead.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/posix-timers.h |    6 +++-
 kernel/posix-timers.c        |   43 +++++++++++++++++----------------
 2 files changed, 28 insertions(+), 21 deletions(-)

diff -puN include/linux/posix-timers.h~posix-timers-use-struct-pid-instead-of-struct-task_struct include/linux/posix-timers.h
--- a/include/linux/posix-timers.h~posix-timers-use-struct-pid-instead-of-struct-task_struct
+++ a/include/linux/posix-timers.h
@@ -45,7 +45,11 @@ struct k_itimer {
 	int it_requeue_pending;		/* waiting to requeue this timer */
 #define REQUEUE_PENDING 1
 	int it_sigev_notify;		/* notify word of sigevent struct */
-	struct task_struct *it_process;	/* process to send signal to */
+	struct signal_struct *it_signal;
+	union {
+		struct pid *it_pid;	/* pid of process to send signal to */
+		struct task_struct *it_process;	/* for clock_nanosleep */
+	};
 	struct sigqueue *sigq;		/* signal queue entry. */
 	union {
 		struct {
diff -puN kernel/posix-timers.c~posix-timers-use-struct-pid-instead-of-struct-task_struct kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-use-struct-pid-instead-of-struct-task_struct
+++ a/kernel/posix-timers.c
@@ -116,7 +116,7 @@ static DEFINE_SPINLOCK(idr_lock);
  *	    must supply functions here, even if the function just returns
  *	    ENOSYS.  The standard POSIX timer management code assumes the
  *	    following: 1.) The k_itimer struct (sched.h) is used for the
- *	    timer.  2.) The list, it_lock, it_clock, it_id and it_process
+ *	    timer.  2.) The list, it_lock, it_clock, it_id and it_pid
  *	    fields are not modified by timer code.
  *
  *          At this time all functions EXCEPT clock_nanosleep can be
@@ -313,7 +313,8 @@ void do_schedule_next_timer(struct sigin
 
 int posix_timer_event(struct k_itimer *timr, int si_private)
 {
-	int shared, ret;
+	struct task_struct *task;
+	int shared, ret = -1;
 	/*
 	 * FIXME: if ->sigq is queued we can race with
 	 * dequeue_signal()->do_schedule_next_timer().
@@ -327,8 +328,13 @@ int posix_timer_event(struct k_itimer *t
 	 */
 	timr->sigq->info.si_sys_private = si_private;
 
-	shared = !(timr->it_sigev_notify & SIGEV_THREAD_ID);
-	ret = send_sigqueue(timr->sigq, timr->it_process, shared);
+	rcu_read_lock();
+	task = pid_task(timr->it_pid, PIDTYPE_PID);
+	if (task) {
+		shared = !(timr->it_sigev_notify & SIGEV_THREAD_ID);
+		ret = send_sigqueue(timr->sigq, task, shared);
+	}
+	rcu_read_unlock();
 	/* If we failed to send the signal the timer stops. */
 	return ret > 0;
 }
@@ -405,7 +411,7 @@ static enum hrtimer_restart posix_timer_
 	return ret;
 }
 
-static struct task_struct * good_sigevent(sigevent_t * event)
+static struct pid *good_sigevent(sigevent_t * event)
 {
 	struct task_struct *rtn = current->group_leader;
 
@@ -419,7 +425,7 @@ static struct task_struct * good_sigeven
 	    ((event->sigev_signo <= 0) || (event->sigev_signo > SIGRTMAX)))
 		return NULL;
 
-	return rtn;
+	return task_pid(rtn);
 }
 
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock)
@@ -472,9 +478,9 @@ sys_timer_create(const clockid_t which_c
 	int error;
 	struct k_itimer *new_timer;
 	int new_timer_id;
-	struct task_struct *process;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
+	struct pid *it_pid;
 
 	if (invalid_clockid(which_clock))
 		return -EINVAL;
@@ -526,11 +532,9 @@ sys_timer_create(const clockid_t which_c
 			goto out;
 		}
 		rcu_read_lock();
-		process = good_sigevent(&event);
-		if (process)
-			get_task_struct(process);
+		it_pid = get_pid(good_sigevent(&event));
 		rcu_read_unlock();
-		if (!process) {
+		if (!it_pid) {
 			error = -EINVAL;
 			goto out;
 		}
@@ -538,8 +542,7 @@ sys_timer_create(const clockid_t which_c
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;
-		process = current->group_leader;
-		get_task_struct(process);
+		it_pid = get_pid(task_tgid(current));
 	}
 
 	new_timer->it_sigev_notify     = event.sigev_notify;
@@ -549,7 +552,8 @@ sys_timer_create(const clockid_t which_c
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
 	spin_lock_irq(&current->sighand->siglock);
-	new_timer->it_process = process;
+	new_timer->it_pid = it_pid;
+	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -584,8 +588,7 @@ static struct k_itimer *lock_timer(timer
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-		if (timr->it_process &&
-		    same_thread_group(timr->it_process, current)) {
+		if (timr->it_pid && timr->it_signal == current->signal) {
 			spin_unlock(&idr_lock);
 			return timr;
 		}
@@ -834,8 +837,8 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_task_struct(timer->it_process);
-	timer->it_process = NULL;
+	put_pid(timer->it_pid);
+	timer->it_pid = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
@@ -861,8 +864,8 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_task_struct(timer->it_process);
-	timer->it_process = NULL;
+	put_pid(timer->it_pid);
+	timer->it_pid = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

tracehook-fix-sa_nocldwait.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
fix-setpriorityprio_pgrp-thread-iterator-breakage.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

