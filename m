From: akpm@linux-foundation.org
Subject: - posix-timers-use-struct-pid-instead-of-struct-task_struct.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:18:52 -0800
Message-ID: <200812291918.mBTJIqev031122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbYL2TTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:19:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: use "struct pid*" instead of "struct task_struct*"
has been removed from the -mm tree.  Its filename was
     posix-timers-use-struct-pid-instead-of-struct-task_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -471,7 +477,7 @@ sys_timer_create(const clockid_t which_c
 {
 	struct k_itimer *new_timer;
 	int error, new_timer_id;
-	struct task_struct *process;
+	struct pid *it_pid;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
 
@@ -525,11 +531,9 @@ sys_timer_create(const clockid_t which_c
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
@@ -537,8 +541,7 @@ sys_timer_create(const clockid_t which_c
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;
-		process = current->group_leader;
-		get_task_struct(process);
+		it_pid = get_pid(task_tgid(current));
 	}
 
 	new_timer->it_sigev_notify     = event.sigev_notify;
@@ -548,7 +551,8 @@ sys_timer_create(const clockid_t which_c
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
 	spin_lock_irq(&current->sighand->siglock);
-	new_timer->it_process = process;
+	new_timer->it_pid = it_pid;
+	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -583,8 +587,7 @@ static struct k_itimer *lock_timer(timer
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-		if (timr->it_process &&
-		    same_thread_group(timr->it_process, current)) {
+		if (timr->it_pid && timr->it_signal == current->signal) {
 			spin_unlock(&idr_lock);
 			return timr;
 		}
@@ -831,8 +834,8 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_task_struct(timer->it_process);
-	timer->it_process = NULL;
+	put_pid(timer->it_pid);
+	timer->it_pid = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
@@ -858,8 +861,8 @@ retry_delete:
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

origin.patch
linux-next.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
send_sig_noinfo-masquerade-si_pid-when-crossing-pid-ns-boundary.patch
send_sig_noinfo-set-si_pid-to-tgid-instead-of-pid.patch

