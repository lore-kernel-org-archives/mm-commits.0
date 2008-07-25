From: akpm@linux-foundation.org
Subject: - __exit_signal-dont-take-rcu-lock.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:25 -0700
Message-ID: <200807252259.m6PMxPGv003388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbYGYXGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     __exit_signal: don't take rcu lock
has been removed from the -mm tree.  Its filename was
     __exit_signal-dont-take-rcu-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: __exit_signal: don't take rcu lock
From: Oleg Nesterov <oleg@tv-sign.ru>

There is no reason for rcu_read_lock() in __exit_signal().  tsk->sighand
can only be changed if tsk does exec, obviously this is not possible.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/exit.c~__exit_signal-dont-take-rcu-lock kernel/exit.c
--- a/kernel/exit.c~__exit_signal-dont-take-rcu-lock
+++ a/kernel/exit.c
@@ -85,7 +85,6 @@ static void __exit_signal(struct task_st
 	BUG_ON(!sig);
 	BUG_ON(!atomic_read(&sig->count));
 
-	rcu_read_lock();
 	sighand = rcu_dereference(tsk->sighand);
 	spin_lock(&sighand->siglock);
 
@@ -136,7 +135,6 @@ static void __exit_signal(struct task_st
 	tsk->signal = NULL;
 	tsk->sighand = NULL;
 	spin_unlock(&sighand->siglock);
-	rcu_read_unlock();
 
 	__cleanup_sighand(sighand);
 	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
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

