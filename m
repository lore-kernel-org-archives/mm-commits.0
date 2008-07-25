From: akpm@linux-foundation.org
Subject: - signals-collect_signal-remove-the-unneeded-sigismember-check.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:20 -0700
Message-ID: <200807252259.m6PMxKI1003376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754810AbYGYXGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: collect_signal: remove the unneeded sigismember() check
has been removed from the -mm tree.  Its filename was
     signals-collect_signal-remove-the-unneeded-sigismember-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: collect_signal: remove the unneeded sigismember() check
From: Oleg Nesterov <oleg@tv-sign.ru>

collect_signal() checks sigismember(&list->signal, sig), this is not
needed.  This "sig" was just found by next_signal(), so it must be valid.

We have a (completely broken) call to ->notifier in between, but it must
not play with sigpending->signal bits or unlock ->siglock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/signal.c~signals-collect_signal-remove-the-unneeded-sigismember-check kernel/signal.c
--- a/kernel/signal.c~signals-collect_signal-remove-the-unneeded-sigismember-check
+++ a/kernel/signal.c
@@ -343,9 +343,6 @@ static int collect_signal(int sig, struc
 	struct sigqueue *q, *first = NULL;
 	int still_pending = 0;
 
-	if (unlikely(!sigismember(&list->signal, sig)))
-		return 0;
-
 	/*
 	 * Collect the siginfo appropriate to this signal.  Check if
 	 * there is another siginfo for the same signal.
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

