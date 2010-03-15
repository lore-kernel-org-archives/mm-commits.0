From: akpm@linux-foundation.org
Subject: [merged] copy_signal-cleanup-use-zalloc-and-remove-initializations.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:19 -0400
Message-ID: <201003150701.o2F71qDb016820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935837Ab0COHCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vfalico@redhat.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     copy_signal() cleanup: use zalloc and remove initializations
has been removed from the -mm tree.  Its filename was
     copy_signal-cleanup-use-zalloc-and-remove-initializations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: copy_signal() cleanup: use zalloc and remove initializations
From: Veaceslav Falico <vfalico@redhat.com>

Use kmem_cache_zalloc() on signal creation and remove unneeded
initialization lines in copy_signal().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff -puN kernel/fork.c~copy_signal-cleanup-use-zalloc-and-remove-initializations kernel/fork.c
--- a/kernel/fork.c~copy_signal-cleanup-use-zalloc-and-remove-initializations
+++ a/kernel/fork.c
@@ -863,7 +863,7 @@ static int copy_signal(unsigned long clo
 	if (clone_flags & CLONE_THREAD)
 		return 0;
 
-	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
+	sig = kmem_cache_zalloc(signal_cachep, GFP_KERNEL);
 	tsk->signal = sig;
 	if (!sig)
 		return -ENOMEM;
@@ -871,46 +871,21 @@ static int copy_signal(unsigned long clo
 	atomic_set(&sig->count, 1);
 	atomic_set(&sig->live, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
-	sig->flags = 0;
 	if (clone_flags & CLONE_NEWPID)
 		sig->flags |= SIGNAL_UNKILLABLE;
-	sig->group_exit_code = 0;
-	sig->group_exit_task = NULL;
-	sig->group_stop_count = 0;
 	sig->curr_target = tsk;
 	init_sigpending(&sig->shared_pending);
 	INIT_LIST_HEAD(&sig->posix_timers);
 
 	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	sig->it_real_incr.tv64 = 0;
 	sig->real_timer.function = it_real_fn;
 
-	sig->leader = 0;	/* session leadership doesn't inherit */
-	sig->tty_old_pgrp = NULL;
-	sig->tty = NULL;
-
-	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
-	sig->gtime = cputime_zero;
-	sig->cgtime = cputime_zero;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	sig->prev_utime = sig->prev_stime = cputime_zero;
-#endif
-	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
-	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
-	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
-	sig->maxrss = sig->cmaxrss = 0;
-	task_io_accounting_init(&sig->ioac);
-	sig->sum_sched_runtime = 0;
-	taskstats_tgid_init(sig);
-
 	task_lock(current->group_leader);
 	memcpy(sig->rlim, current->signal->rlim, sizeof sig->rlim);
 	task_unlock(current->group_leader);
 
 	posix_cpu_timers_init_group(sig);
 
-	acct_init_pacct(&sig->pacct);
