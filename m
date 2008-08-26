From: akpm@linux-foundation.org
Subject: - sched-do_wait_for_common-use-signal_pending_state.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:44:59 -0700
Message-ID: <200808261844.m7QIixqG021358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759362AbYHZSyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:54:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, matthew@wil.cx, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sched: do_wait_for_common: use signal_pending_state()
has been removed from the -mm tree.  Its filename was
     sched-do_wait_for_common-use-signal_pending_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: do_wait_for_common: use signal_pending_state()
From: Oleg Nesterov <oleg@tv-sign.ru>

Change do_wait_for_common() to use signal_pending_state() instead of open
coding.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/sched.c~sched-do_wait_for_common-use-signal_pending_state kernel/sched.c
--- a/kernel/sched.c~sched-do_wait_for_common-use-signal_pending_state
+++ a/kernel/sched.c
@@ -4596,10 +4596,7 @@ do_wait_for_common(struct completion *x,
 		wait.flags |= WQ_FLAG_EXCLUSIVE;
 		__add_wait_queue_tail(&x->wait, &wait);
 		do {
-			if ((state == TASK_INTERRUPTIBLE &&
-			     signal_pending(current)) ||
-			    (state == TASK_KILLABLE &&
-			     fatal_signal_pending(current))) {
+			if (signal_pending_state(state, current)) {
 				timeout = -ERESTARTSYS;
 				break;
 			}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

linux-next.patch
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

