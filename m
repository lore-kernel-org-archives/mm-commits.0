From: akpm@linux-foundation.org
Subject: - posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:15 -0700
Message-ID: <200807252259.m6PMxF5f003365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757905AbYGYXNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:13:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, johnstul@us.ibm.com, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix timers: timer_delete: remove the bogus "->it_process != NULL" check
has been removed from the -mm tree.  Its filename was
     posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix timers: timer_delete: remove the bogus "->it_process != NULL" check
From: Oleg Nesterov <oleg@tv-sign.ru>

sys_timer_delete() and itimer_delete() check "timer->it_process != NULL",
this looks completely bogus.  ->it_process == NULL means that this timer
is already under destruction or it is not fully initialized, this must not
happen.

	sys_timer_delete: the timer is locked, and lock_timer() can't succeed
	if ->it_process == NULL.

	itimer_delete: it is called by exit_itimers() when there are no other
	threads which can play with signal_struct->posix_timers.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check
+++ a/kernel/posix-timers.c
@@ -856,11 +856,10 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_process) {
-		if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-			put_task_struct(timer->it_process);
-		timer->it_process = NULL;
-	}
+	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
+		put_task_struct(timer->it_process);
+	timer->it_process = NULL;
+
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
 	return 0;
@@ -885,11 +884,10 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_process) {
-		if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-			put_task_struct(timer->it_process);
-		timer->it_process = NULL;
-	}
+	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
+		put_task_struct(timer->it_process);
+	timer->it_process = NULL;
+
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

