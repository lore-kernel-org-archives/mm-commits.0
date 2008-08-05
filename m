From: akpm@linux-foundation.org
Subject: + posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch added to -mm tree
Date: Tue, 05 Aug 2008 13:24:56 -0700
Message-ID: <200808052024.m75KOu9m021702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760854AbYHEU0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 16:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: kill ->it_sigev_signo and ->it_sigev_value
has been added to the -mm tree.  Its filename is
     posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch

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
Subject: posix-timers: kill ->it_sigev_signo and ->it_sigev_value
From: Oleg Nesterov <oleg@tv-sign.ru>

With the recent changes ->it_sigev_signo and ->it_sigev_value are only
used in sys_timer_create(), kill them.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/posix-timers.h |    2 --
 kernel/posix-timers.c        |   17 +++++++----------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff -puN include/linux/posix-timers.h~posix-timers-kill-it_sigev_signo-and-it_sigev_value include/linux/posix-timers.h
--- a/include/linux/posix-timers.h~posix-timers-kill-it_sigev_signo-and-it_sigev_value
+++ a/include/linux/posix-timers.h
@@ -45,8 +45,6 @@ struct k_itimer {
 	int it_requeue_pending;		/* waiting to requeue this timer */
 #define REQUEUE_PENDING 1
 	int it_sigev_notify;		/* notify word of sigevent struct */
-	int it_sigev_signo;		/* signo word of sigevent struct */
-	sigval_t it_sigev_value;	/* value word of sigevent struct */
 	struct task_struct *it_process;	/* process to send signal to */
 	struct sigqueue *sigq;		/* signal queue entry. */
 	union {
diff -puN kernel/posix-timers.c~posix-timers-kill-it_sigev_signo-and-it_sigev_value kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-kill-it_sigev_signo-and-it_sigev_value
+++ a/kernel/posix-timers.c
@@ -526,10 +526,6 @@ sys_timer_create(const clockid_t which_c
 			error = -EFAULT;
 			goto out;
 		}
-		new_timer->it_sigev_notify = event.sigev_notify;
-		new_timer->it_sigev_signo = event.sigev_signo;
-		new_timer->it_sigev_value = event.sigev_value;
-
 		rcu_read_lock();
 		process = good_sigevent(&event);
 		if (process)
@@ -540,17 +536,18 @@ sys_timer_create(const clockid_t which_c
 			goto out;
 		}
 	} else {
-		new_timer->it_sigev_notify = SIGEV_SIGNAL;
-		new_timer->it_sigev_signo = SIGALRM;
-		new_timer->it_sigev_value.sival_int = new_timer->it_id;
+		event.sigev_notify = SIGEV_SIGNAL;
+		event.sigev_signo = SIGALRM;
+		event.sigev_value.sival_int = new_timer->it_id;
 		process = current->group_leader;
 		get_task_struct(process);
 	}
 
-	new_timer->sigq->info.si_code  = SI_TIMER;
+	new_timer->it_sigev_notify     = event.sigev_notify;
+	new_timer->sigq->info.si_signo = event.sigev_signo;
+	new_timer->sigq->info.si_value = event.sigev_value;
 	new_timer->sigq->info.si_tid   = new_timer->it_id;
-	new_timer->sigq->info.si_signo = new_timer->it_sigev_signo;
-	new_timer->sigq->info.si_value = new_timer->it_sigev_value;
+	new_timer->sigq->info.si_code  = SI_TIMER;
 
 	spin_lock_irq(&current->sighand->siglock);
 	new_timer->it_process = process;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
semaphore-__down_common-use-signal_pending_state.patch
proc-fix-warnings.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

