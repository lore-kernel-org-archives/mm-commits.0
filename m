From: akpm@linux-foundation.org
Subject: - ptrace-give-more-respect-to-sigkill.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:42 -0700
Message-ID: <200807252259.m6PMxgdq003409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250AbYGYXAs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:00:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, matthew@wil.cx, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: give more respect to SIGKILL
has been removed from the -mm tree.  Its filename was
     ptrace-give-more-respect-to-sigkill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: give more respect to SIGKILL
From: Oleg Nesterov <oleg@tv-sign.ru>

ptrace_stop() has some complicated checks to prevent the scheduling in the
TASK_TRACED state with the pending SIGKILL, but these checks are racy, and
they depend on arch_ptrace_stop_needed().

This patch assumes that the traced task should die asap if it was killed by
SIGKILL, in that case schedule()->signal_pending_state() has no reason to
ignore the TASK_WAKEKILL part of TASK_TRACED, and we can kill this nasty
special case.

Note: do_exit()->ptrace_notify() is special, the killed task can already
dequeue SIGKILL at this point. Another indication that fatal_signal_pending()
is not exactly right.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/sched.h~ptrace-give-more-respect-to-sigkill include/linux/sched.h
--- a/include/linux/sched.h~ptrace-give-more-respect-to-sigkill
+++ a/include/linux/sched.h
@@ -2054,9 +2054,6 @@ static inline int signal_pending_state(l
 	if (!signal_pending(p))
 		return 0;
 
-	if (state & (__TASK_STOPPED | __TASK_TRACED))
-		return 0;
-
 	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
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

