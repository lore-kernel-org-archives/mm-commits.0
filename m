From: akpm@linux-foundation.org
Subject: - workqueues-queue_work-can-use-queue_work_on.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:25 -0700
Message-ID: <200807252300.m6PN0P39003584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754295AbYGYXGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     workqueues: queue_work() can use queue_work_on()
has been removed from the -mm tree.  Its filename was
     workqueues-queue_work-can-use-queue_work_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues: queue_work() can use queue_work_on()
From: Oleg Nesterov <oleg@tv-sign.ru>

queue_work() can use queue_work_on() to avoid the code duplication.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/workqueue.c~workqueues-queue_work-can-use-queue_work_on kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-queue_work-can-use-queue_work_on
+++ a/kernel/workqueue.c
@@ -159,14 +159,11 @@ static void __queue_work(struct cpu_work
  */
 int queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
-	int ret = 0;
+	int ret;
+
+	ret = queue_work_on(get_cpu(), wq, work);
+	put_cpu();
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		BUG_ON(!list_empty(&work->entry));
-		__queue_work(wq_per_cpu(wq, get_cpu()), work);
-		put_cpu();
-		ret = 1;
-	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(queue_work);
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

