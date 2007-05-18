From: akpm@linux-foundation.org
Subject: + simplify-cleanup_workqueue_thread-fix2.patch added to -mm tree
Date: Fri, 18 May 2007 15:14:06 -0700
Message-ID: <200705182214.l4IME62s024604@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755050AbXERWPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 18:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     simplify-cleanup_workqueue_thread-fix2
has been added to the -mm tree.  Its filename is
     simplify-cleanup_workqueue_thread-fix2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: simplify-cleanup_workqueue_thread-fix2
From: Oleg Nesterov <oleg@tv-sign.ru>

But it is a bit silly to have 2 variables, we need only one.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff -puN kernel/workqueue.c~simplify-cleanup_workqueue_thread-fix2 kernel/workqueue.c
--- a/kernel/workqueue.c~simplify-cleanup_workqueue_thread-fix2
+++ a/kernel/workqueue.c
@@ -330,7 +330,7 @@ static void insert_wq_barrier(struct cpu
 
 static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 {
-	int ret;
+	int active;
 
 	if (cwq->thread == current) {
 		/*
@@ -338,11 +338,11 @@ static int flush_cpu_workqueue(struct cp
 		 * it by hand rather than deadlocking.
 		 */
 		run_workqueue(cwq);
-		ret = 1;
+		active = 1;
 	} else {
 		struct wq_barrier barr;
-		int active = 0;
 
+		active = 0;
 		spin_lock_irq(&cwq->lock);
 		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
 			insert_wq_barrier(cwq, &barr, 1);
@@ -352,10 +352,9 @@ static int flush_cpu_workqueue(struct cp
 
 		if (active)
 			wait_for_completion(&barr.done);
-
-		ret = active;
 	}
-	return ret;
+
+	return active;
 }
 
 /**
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-cancel_delayed_work-use-del_timer-instead-of-del_timer_sync.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
git-nfs.patch
recalc_sigpending_tsk-fixes.patch
simplify-cleanup_workqueue_thread.patch
simplify-cleanup_workqueue_thread-fix.patch
simplify-cleanup_workqueue_thread-fix2.patch
freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
tidy-up-usermode-helper-waiting-a-bit.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
