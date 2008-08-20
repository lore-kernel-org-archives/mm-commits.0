From: akpm@linux-foundation.org
Subject: - tracehook-fix-sa_nocldwait.patch removed from -mm tree
Date: Wed, 20 Aug 2008 13:12:52 -0700
Message-ID: <200808202012.m7KKCqQK029365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865AbYHTUNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 16:13:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, andi@firstfloor.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: fix SA_NOCLDWAIT
has been removed from the -mm tree.  Its filename was
     tracehook-fix-sa_nocldwait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: fix SA_NOCLDWAIT
From: Roland McGrath <roland@redhat.com>

I outwitted myself again in commit 2b2a1ff64afbadac842bbc58c5166962cf4f7664,
and broke the SA_NOCLDWAIT behavior so it leaks zombies.  This fixes it.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~tracehook-fix-sa_nocldwait kernel/signal.c
--- a/kernel/signal.c~tracehook-fix-sa_nocldwait
+++ a/kernel/signal.c
@@ -1338,6 +1338,7 @@ int do_notify_parent(struct task_struct 
 	struct siginfo info;
 	unsigned long flags;
 	struct sighand_struct *psig;
+	int ret = sig;
 
 	BUG_ON(sig == -1);
 
@@ -1402,7 +1403,7 @@ int do_notify_parent(struct task_struct 
 		 * is implementation-defined: we do (if you don't want
 		 * it, just use SIG_IGN instead).
 		 */
-		tsk->exit_signal = -1;
+		ret = tsk->exit_signal = -1;
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
 			sig = -1;
 	}
@@ -1411,7 +1412,7 @@ int do_notify_parent(struct task_struct 
 	__wake_up_parent(tsk, tsk->parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
 
-	return sig;
+	return ret;
 }
 
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
linux-next.patch
x86-tracehook-config_have_arch_tracehook.patch
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
posix-timers-simplify-de_thread-exit_itimers-path.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

