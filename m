From: akpm@linux-foundation.org
Subject: - worker_thread-dont-play-with-signals.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:10 -0700
Message-ID: <200705092152.l49LqAav002975@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758815AbXEIVwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     worker_thread: don't play with signals
has been removed from the -mm tree.  Its filename was
     worker_thread-dont-play-with-signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: worker_thread: don't play with signals
From: Oleg Nesterov <oleg@tv-sign.ru>

worker_thread() doesn't need to "Block and flush all signals", this was
already done by its caller, kthread().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN kernel/workqueue.c~worker_thread-dont-play-with-signals kernel/workqueue.c
--- a/kernel/workqueue.c~worker_thread-dont-play-with-signals
+++ a/kernel/workqueue.c
@@ -290,18 +290,11 @@ static int worker_thread(void *__cwq)
 	struct cpu_workqueue_struct *cwq = __cwq;
 	DEFINE_WAIT(wait);
 	struct k_sigaction sa;
-	sigset_t blocked;
 
 	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
 	set_user_nice(current, -5);
-
-	/* Block and flush all signals */
-	sigfillset(&blocked);
-	sigprocmask(SIG_BLOCK, &blocked, NULL);
-	flush_signals(current);
-
 	/*
 	 * We inherited MPOL_INTERLEAVE from the booting kernel.
 	 * Set MPOL_DEFAULT to insure node local allocations.
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
