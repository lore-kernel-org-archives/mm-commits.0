From: akpm@linux-foundation.org
Subject: - workqueues-schedule_on_each_cpu-use-flush_work.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:15 -0700
Message-ID: <200807252300.m6PN0Ftp003569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbYGYXBK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:01:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jarkao2@gmail.com, maxk@qualcomm.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     workqueues: schedule_on_each_cpu: use flush_work()
has been removed from the -mm tree.  Its filename was
     workqueues-schedule_on_each_cpu-use-flush_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues: schedule_on_each_cpu: use flush_work()
From: Oleg Nesterov <oleg@tv-sign.ru>

Change schedule_on_each_cpu() to use flush_work() instead of
flush_workqueue(), this way we don't wait for other work_struct's which
can be queued meanwhile.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jarek Poplawski <jarkao2@gmail.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/workqueue.c~workqueues-schedule_on_each_cpu-use-flush_work kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-schedule_on_each_cpu-use-flush_work
+++ a/kernel/workqueue.c
@@ -690,7 +690,8 @@ int schedule_on_each_cpu(work_func_t fun
 		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
 		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
 	}
-	flush_workqueue(keventd_wq);
+	for_each_online_cpu(cpu)
+		flush_work(per_cpu_ptr(works, cpu));
 	put_online_cpus();
 	free_percpu(works);
 	return 0;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

