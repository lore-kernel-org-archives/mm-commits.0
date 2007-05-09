From: akpm@linux-foundation.org
Subject: - worker_thread-dont-play-with-sigchld-and-numa-policy.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:35 -0700
Message-ID: <200705092152.l49LqZxJ003013@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759000AbXEIVw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     worker_thread: don't play with SIGCHLD and numa policy
has been removed from the -mm tree.  Its filename was
     worker_thread-dont-play-with-sigchld-and-numa-policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: worker_thread: don't play with SIGCHLD and numa policy
From: Oleg Nesterov <oleg@tv-sign.ru>

worker_thread() inherits ignored SIGCHLD and numa_default_policy() from its
parent, kthreadd.  No need to setup this again.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN kernel/workqueue.c~worker_thread-dont-play-with-sigchld-and-numa-policy kernel/workqueue.c
--- a/kernel/workqueue.c~worker_thread-dont-play-with-sigchld-and-numa-policy
+++ a/kernel/workqueue.c
@@ -289,23 +289,11 @@ static int worker_thread(void *__cwq)
 {
 	struct cpu_workqueue_struct *cwq = __cwq;
 	DEFINE_WAIT(wait);
-	struct k_sigaction sa;
 
 	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
 	set_user_nice(current, -5);
-	/*
-	 * We inherited MPOL_INTERLEAVE from the booting kernel.
-	 * Set MPOL_DEFAULT to insure node local allocations.
-	 */
-	numa_default_policy();
-
-	/* SIG_IGN makes children autoreap: see do_notify_parent(). */
-	sa.sa.sa_handler = SIG_IGN;
-	sa.sa.sa_flags = 0;
-	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
-	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
 
 	for (;;) {
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
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
