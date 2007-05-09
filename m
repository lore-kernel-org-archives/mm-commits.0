From: akpm@linux-foundation.org
Subject: - worker_thread-fix-racy-try_to_freeze-usage.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:12 -0700
Message-ID: <200705092152.l49LqCJC002978@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758862AbXEIVwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     worker_thread: fix racy try_to_freeze() usage
has been removed from the -mm tree.  Its filename was
     worker_thread-fix-racy-try_to_freeze-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: worker_thread: fix racy try_to_freeze() usage
From: Oleg Nesterov <oleg@tv-sign.ru>

worker_thread() can miss freeze_process()->signal_wake_up() if it happens
between try_to_freeze() and prepare_to_wait().  We should check freezing()
before entering schedule().

This race was introduced by me in

	[PATCH 1/1] workqueue: don't migrate pending works from the dead CPU

Looks like mm/vmscan.c:kswapd() has the same race.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/workqueue.c~worker_thread-fix-racy-try_to_freeze-usage kernel/workqueue.c
--- a/kernel/workqueue.c~worker_thread-fix-racy-try_to_freeze-usage
+++ a/kernel/workqueue.c
@@ -308,14 +308,14 @@ static int worker_thread(void *__cwq)
 	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
 
 	for (;;) {
-		if (cwq->wq->freezeable)
-			try_to_freeze();
-
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
-		if (!cwq->should_stop && list_empty(&cwq->worklist))
+		if (!freezing(current) && !cwq->should_stop
+		    && list_empty(&cwq->worklist))
 			schedule();
 		finish_wait(&cwq->more_work, &wait);
 
+		try_to_freeze();
+
 		if (cwq_should_stop(cwq))
 			break;
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
dont-init-pgrp-and-__session-in-init_signals.patch
