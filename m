From: akpm@linux-foundation.org
Subject: - posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:27:38 -0700
Message-ID: <200810092227.m99MRcei005972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbYJIW2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: move the initialization of timer->sigq from send to create path
has been removed from the -mm tree.  Its filename was
     posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: move the initialization of timer->sigq from send to create path
From: Oleg Nesterov <oleg@tv-sign.ru>

posix_timer_event() always populates timer->sigq with the same numbers,
move this code into sys_timer_create().

Note that with this patch we can kill it_sigev_signo and it_sigev_value.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path
+++ a/kernel/posix-timers.c
@@ -327,11 +327,6 @@ int posix_timer_event(struct k_itimer *t
 	 */
 	timr->sigq->info.si_sys_private = si_private;
 
-	timr->sigq->info.si_signo = timr->it_sigev_signo;
-	timr->sigq->info.si_code = SI_TIMER;
-	timr->sigq->info.si_tid = timr->it_id;
-	timr->sigq->info.si_value = timr->it_sigev_value;
-
 	shared = !(timr->it_sigev_notify & SIGEV_THREAD_ID);
 	ret = send_sigqueue(timr->sigq, timr->it_process, shared);
 	/* If we failed to send the signal the timer stops. */
@@ -552,6 +547,11 @@ sys_timer_create(const clockid_t which_c
 		get_task_struct(process);
 	}
 
+	new_timer->sigq->info.si_code  = SI_TIMER;
+	new_timer->sigq->info.si_tid   = new_timer->it_id;
+	new_timer->sigq->info.si_signo = new_timer->it_sigev_signo;
+	new_timer->sigq->info.si_value = new_timer->it_sigev_value;
+
 	spin_lock_irq(&current->sighand->siglock);
 	new_timer->it_process = process;
 	list_add(&new_timer->list, &current->signal->posix_timers);
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

