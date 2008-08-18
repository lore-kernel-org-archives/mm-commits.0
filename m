From: akpm@linux-foundation.org
Subject: - wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:55:34 -0700
Message-ID: <200808181955.m7IJtYMu009375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713AbYHRT43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wait_task_inactive: "improve" the returned value for ->nvcsw == 0
has been removed from the -mm tree.  Its filename was
     wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wait_task_inactive: "improve" the returned value for ->nvcsw == 0
From: Oleg Nesterov <oleg@tv-sign.ru>

wait_task_inactive() returns 1 when p->nvcsw == 0 || p->nvcsw == 1.  This
means that two subsequent calls can return the same number while the task
was scheduled in between.

Change the code to return "nvcsw | LONG_MIN" instead of "nvcsw ?: 1", now
the overlap always needs LONG_MAX schedules.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0 kernel/sched.c
--- a/kernel/sched.c~wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0
+++ a/kernel/sched.c
@@ -1926,7 +1926,7 @@ unsigned long wait_task_inactive(struct 
 		on_rq = p->se.on_rq;
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
-			ncsw = p->nvcsw ?: 1;
+			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
 		task_rq_unlock(rq, &flags);
 
 		/*
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
wait_task_inactive-fix-the-config_smp-version.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

