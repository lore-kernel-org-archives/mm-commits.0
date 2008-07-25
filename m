From: akpm@linux-foundation.org
Subject: - signals-do_signal_stop-kill-the-signal_unkillable-check.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:29 -0700
Message-ID: <200807252259.m6PMxTSc003394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786AbYGYXAS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:00:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: do_signal_stop: kill the SIGNAL_UNKILLABLE check
has been removed from the -mm tree.  Its filename was
     signals-do_signal_stop-kill-the-signal_unkillable-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: do_signal_stop: kill the SIGNAL_UNKILLABLE check
From: Oleg Nesterov <oleg@tv-sign.ru>

fae5fa44f1fd079ffbed8e0add929dd7bbd1347f changed do_signal_stop() to check
SIGNAL_UNKILLABLE, this wasn't needed.  If signal_group_exit() == F, the
signal sent to SIGNAL_UNKILLABLE task must be already filtered out by the
caller, get_signal_to_deliver().  And if signal_group_exit() == T we are
not going to stop.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/signal.c~signals-do_signal_stop-kill-the-signal_unkillable-check kernel/signal.c
--- a/kernel/signal.c~signals-do_signal_stop-kill-the-signal_unkillable-check
+++ a/kernel/signal.c
@@ -1649,8 +1649,7 @@ static int do_signal_stop(int signr)
 	} else {
 		struct task_struct *t;
 
-		if (unlikely((sig->flags & (SIGNAL_STOP_DEQUEUED | SIGNAL_UNKILLABLE))
-					 != SIGNAL_STOP_DEQUEUED) ||
+		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
 			return 0;
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

