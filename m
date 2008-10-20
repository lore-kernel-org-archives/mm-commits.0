From: akpm@linux-foundation.org
Subject: - kthread_bind-use-wait_task_inactivetask_uninterruptible.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:00 -0700
Message-ID: <200810202037.m9KKb0B9011504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbYJTUq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kthread_bind: use wait_task_inactive(TASK_UNINTERRUPTIBLE)
has been removed from the -mm tree.  Its filename was
     kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -171,12 +171,11 @@ EXPORT_SYMBOL(kthread_create);
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

origin.patch
linux-next.patch
posix-timers-simplify-de_thread-exit_itimers-path.patch

