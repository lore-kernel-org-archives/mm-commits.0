From: akpm@linux-foundation.org
Subject: - semaphore-__down_common-use-signal_pending_state.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:19 -0700
Message-ID: <200808062056.m76KuJP9014657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758841AbYHFU5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:57:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, matthew@wil.cx, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     semaphore: __down_common: use signal_pending_state()
has been removed from the -mm tree.  Its filename was
     semaphore-__down_common-use-signal_pending_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: semaphore: __down_common: use signal_pending_state()
From: Oleg Nesterov <oleg@tv-sign.ru>

Change __down_common() to use signal_pending_state() instead of open
coding.

The changes in kernel/semaphore.o are just artifacts, the state checks are
optimized away.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/semaphore.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/semaphore.c~semaphore-__down_common-use-signal_pending_state kernel/semaphore.c
--- a/kernel/semaphore.c~semaphore-__down_common-use-signal_pending_state
+++ a/kernel/semaphore.c
@@ -212,9 +212,7 @@ static inline int __sched __down_common(
 	waiter.up = 0;
 
 	for (;;) {
-		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
-			goto interrupted;
-		if (state == TASK_KILLABLE && fatal_signal_pending(task))
+		if (signal_pending_state(state, task))
 			goto interrupted;
 		if (timeout <= 0)
 			goto timed_out;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
wait_task_inactive-fix-the-config_smp-version.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

