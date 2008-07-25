From: akpm@linux-foundation.org
Subject: - posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:18 -0700
Message-ID: <200807252259.m6PMxIf4003368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757909AbYGYXNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:13:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, johnstul@us.ibm.com, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix timers: release_posix_timer: kill the bogus put_task_struct(->it_process);
has been removed from the -mm tree.  Its filename was
     posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix timers: release_posix_timer: kill the bogus put_task_struct(->it_process);
From: Oleg Nesterov <oleg@tv-sign.ru>

release_posix_timer() can't be called with ->it_process != NULL.  Once
sys_timer_create() sets ->it_process it must not call
release_posix_timer(), otherwise we can race with another thread doing
sys_timer_delete(), this timer is visible to idr_find() and unlocked.

The same is true for two other callers (actually, for any possible
caller), sys_timer_delete() and itimer_delete().  They must clear
->it_process before unlock_timer() + release_posix_timer().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process
+++ a/kernel/posix-timers.c
@@ -449,9 +449,6 @@ static void release_posix_timer(struct k
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
 	sigqueue_free(tmr->sigq);
-	if (unlikely(tmr->it_process) &&
-	    tmr->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(tmr->it_process);
 	kmem_cache_free(posix_timers_cache, tmr);
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

