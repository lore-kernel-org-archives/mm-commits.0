From: akpm@linux-foundation.org
Subject: + kthread_bind-use-wait_task_inactivetask_uninterruptible.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:23:52 -0700
Message-ID: <200807292223.m6TMNqYb024835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbYG2WYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com


The patch titled
     kthread_bind: use wait_task_inactive(TASK_UNINTERRUPTIBLE)
has been added to the -mm tree.  Its filename is
     kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

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
Subject: kthread_bind: use wait_task_inactive(TASK_UNINTERRUPTIBLE)
From: Oleg Nesterov <oleg@tv-sign.ru>

Now that wait_task_inactive(task, state) checks task->state == state,
we can simplify the code and make this debugging check more robust.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/kthread.c~kthread_bind-use-wait_task_inactivetask_uninterruptible kernel/kthread.c
--- a/kernel/kthread.c~kthread_bind-use-wait_task_inactivetask_uninterruptible
+++ a/kernel/kthread.c
@@ -152,12 +152,11 @@ EXPORT_SYMBOL(__kthread_create);
  */
 void kthread_bind(struct task_struct *k, unsigned int cpu)
 {
-	if (k->state != TASK_UNINTERRUPTIBLE) {
+	/* Must have done schedule() in kthread() before we set_task_cpu */
+	if (!wait_task_inactive(k, TASK_UNINTERRUPTIBLE)) {
 		WARN_ON(1);
 		return;
 	}
-	/* Must have done schedule() in kthread() before we set_task_cpu */
-	wait_task_inactive(k, 0);
 	set_task_cpu(k, cpu);
 	k->cpus_allowed = cpumask_of_cpu(cpu);
 	k->rt.nr_cpus_allowed = 1;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
semaphore-__down_common-use-signal_pending_state.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

