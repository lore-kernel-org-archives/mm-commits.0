From: akpm@linux-foundation.org
Subject: - posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:27:48 -0700
Message-ID: <200810092227.m99MRm3f006013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbYJIW2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: kill ->it_sigev_signo and ->it_sigev_value
has been removed from the -mm tree.  Its filename was
     posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-tip.patch
posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
posix-timers-simplify-de_thread-exit_itimers-path.patch
signal-procfs-lock_task_sighand-do-not-need-rcu_read_lock.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch
pid_ns-de_thread-kill-the-now-unneeded-child_reaper-change.patch
pid_ns-kill-the-now-unused-task_child_reaper.patch

