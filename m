From: akpm@linux-foundation.org
Subject: + destroy_workqueue-can-livelock.patch added to -mm tree
Date: Fri, 13 Jul 2007 12:14:08 -0700
Message-ID: <200707131914.l6DJE8e5013614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758828AbXGMTPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 15:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mschmidt@redhat.com, stable@kernel.org, vatsa@in.ibm.com


The patch titled
     destroy_workqueue() can livelock
has been added to the -mm tree.  Its filename is
     destroy_workqueue-can-livelock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: destroy_workqueue() can livelock
From: Oleg Nesterov <oleg@tv-sign.ru>

Pointed out by Michal Schmidt <mschmidt@redhat.com>.

The bug was introduced in 2.6.22 by me.

cleanup_workqueue_thread() does flush_cpu_workqueue(cwq) in a loop until
->worklist becomes empty.  This is live-lockable, a re-niced caller can get
CPU after wake_up() and insert a new barrier before the lower-priority
cwq->thread has a chance to clear ->current_work.

Change cleanup_workqueue_thread() to do flush_cpu_workqueue(cwq) only once.
 We can rely on the fact that run_workqueue() won't return until it flushes
all works.  So it is safe to call kthread_stop() after that, the "should
stop" request won't be noticed until run_workqueue() returns.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Michal Schmidt <mschmidt@redhat.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff -puN kernel/workqueue.c~destroy_workqueue-can-livelock kernel/workqueue.c
--- a/kernel/workqueue.c~destroy_workqueue-can-livelock
+++ a/kernel/workqueue.c
@@ -739,18 +739,17 @@ static void cleanup_workqueue_thread(str
 	if (cwq->thread == NULL)
 		return;
 
+	flush_cpu_workqueue(cwq);
 	/*
-	 * If the caller is CPU_DEAD the single flush_cpu_workqueue()
-	 * is not enough, a concurrent flush_workqueue() can insert a
-	 * barrier after us.
+	 * If the caller is CPU_DEAD and cwq->worklist was not empty,
+	 * a concurrent flush_workqueue() can insert a barrier after us.
+	 * However, in that case run_workqueue() won't return and check
+	 * kthread_should_stop() until it flushes all work_struct's.
 	 * When ->worklist becomes empty it is safe to exit because no
 	 * more work_structs can be queued on this cwq: flush_workqueue
 	 * checks list_empty(), and a "normal" queue_work() can't use
 	 * a dead CPU.
 	 */
-	while (flush_cpu_workqueue(cwq))
-		;
-
 	kthread_stop(cwq->thread);
 	cwq->thread = NULL;
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

libata-core-convert-to-use-cancel_rearming_delayed_work.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-run-show_state-when-freezing-times-out.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mm-fix-create_new_namespaces-return-value.patch
adb_probe_task-remove-unneeded-flush_signals-call.patch
kcdrwd-remove-unneeded-flush_signals-call.patch
nbdcsock_xmit-cleanup-signal-related-code.patch
rename-cancel_rearming_delayed_work-to-cancel_delayed_work_sync.patch
make-cancel_xxx_work_sync-return-a-boolean.patch
destroy_workqueue-can-livelock.patch
