From: akpm@linux-foundation.org
Subject: - signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:27 -0700
Message-ID: <200807252259.m6PMxRPR003391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754844AbYGYXGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: dequeue_signal: don't check SIGNAL_GROUP_EXIT when setting SIGNAL_STOP_DEQUEUED
has been removed from the -mm tree.  Its filename was
     signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: dequeue_signal: don't check SIGNAL_GROUP_EXIT when setting SIGNAL_STOP_DEQUEUED
From: Oleg Nesterov <oleg@tv-sign.ru>

dequeue_signal() checks SIGNAL_GROUP_EXIT before setting
SIGNAL_STOP_DEQUEUED.  This was added by
788e05a67c343fa22f2ae1d3ca264e7f15c25eaf a long ago to avoid the
coredump/SIGSTOP race.

Since then the related code was changed, and now this subtle check is both
incomplete and unneeded at the same time.  It is incomplete because
nowadays exec() doesn't set SIGNAL_GROUP_EXIT, so in fact we should check
signal_group_exit() to avoid a similar race.  Fortunately, we doesn't need
the check at all.  The only function which relies on SIGNAL_STOP_DEQUEUED
is do_signal_stop(), and it ignores this flag if signal_group_exit() == T,
this covers the SIGNAL_GROUP_EXIT case.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/signal.c~signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued kernel/signal.c
--- a/kernel/signal.c~signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued
+++ a/kernel/signal.c
@@ -454,8 +454,7 @@ int dequeue_signal(struct task_struct *t
 		 * is to alert stop-signal processing code when another
 		 * processor has come along and cleared the flag.
 		 */
-		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
-			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
+		tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
 	}
 	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
 		/*
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

