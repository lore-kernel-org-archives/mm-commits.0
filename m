From: akpm@linux-foundation.org
Subject: + wait_task_inactive-dont-consider-task-nivcsw.patch added to -mm tree
Date: Tue, 19 Aug 2008 12:55:22 -0700
Message-ID: <200808191955.m7JJtN39003273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423AbYHST4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 15:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com


The patch titled
     wait_task_inactive(): don't consider task->nivcsw
has been added to the -mm tree.  Its filename is
     wait_task_inactive-dont-consider-task-nivcsw.patch

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
Subject: wait_task_inactive(): don't consider task->nivcsw
From: Oleg Nesterov <oleg@tv-sign.ru>

If wait_task_inactive() returns success the task was deactivated.  In that
case schedule() always increments ->nvcsw which alone can be used as a
"generation counter".

If the next call returns the same number, we can be sure that the task was
unscheduled.  Otherwise, because we know that .on_rq == 0 again, ->nvcsw
should have been changed in between.

Q: perhaps it is better to do "ncsw = (p->nvcsw << 1) | 1" ?  This
decreases the possibility of "was it unscheduled" false positive when
->nvcsw == 0.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN kernel/sched.c~wait_task_inactive-dont-consider-task-nivcsw kernel/sched.c
--- a/kernel/sched.c~wait_task_inactive-dont-consider-task-nivcsw
+++ a/kernel/sched.c
@@ -1925,11 +1925,8 @@ unsigned long wait_task_inactive(struct 
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		ncsw = 0;
-		if (!match_state || p->state == match_state) {
-			ncsw = p->nivcsw + p->nvcsw;
-			if (unlikely(!ncsw))
-				ncsw = 1;
-		}
+		if (!match_state || p->state == match_state)
+			ncsw = p->nvcsw ?: 1;
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

