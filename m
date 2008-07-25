From: akpm@linux-foundation.org
Subject: - workqueues-lockdep-annotations-for-flush_work.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:23 -0700
Message-ID: <200807252300.m6PN0NM1003579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123AbYGYXHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jarkao2@o2.pl, johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     workqueues: lockdep annotations for flush_work()
has been removed from the -mm tree.  Its filename was
     workqueues-lockdep-annotations-for-flush_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues: lockdep annotations for flush_work()
From: Oleg Nesterov <oleg@tv-sign.ru>

Add lockdep annotations to flush_work() and update the comment.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jarek Poplawski <jarkao2@o2.pl>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/workqueue.c~workqueues-lockdep-annotations-for-flush_work kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-lockdep-annotations-for-flush_work
+++ a/kernel/workqueue.c
@@ -427,6 +427,8 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
  * flush_work - block until a work_struct's callback has terminated
  * @work: the work which is to be flushed
  *
+ * Returns false if @work has already terminated.
+ *
  * It is expected that, prior to calling flush_work(), the caller has
  * arranged for the work to not be requeued, otherwise it doesn't make
  * sense to use this function.
@@ -442,6 +444,9 @@ int flush_work(struct work_struct *work)
 	if (!cwq)
 		return 0;
 
+	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+
 	prev = NULL;
 	spin_lock_irq(&cwq->lock);
 	if (!list_empty(&work->entry)) {
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

