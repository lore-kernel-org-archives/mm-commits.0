From: akpm@linux-foundation.org
Subject: + wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch added to -mm tree
Date: Tue, 19 Aug 2008 12:55:25 -0700
Message-ID: <200808191955.m7JJtPAU003279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423AbYHST4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 15:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com


The patch titled
     wait_task_inactive: "improve" the returned value for ->nvcsw == 0
has been added to the -mm tree.  Its filename is
     wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

