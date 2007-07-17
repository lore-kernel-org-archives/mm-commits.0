From: akpm@linux-foundation.org
Subject: - destroy_workqueue-can-livelock.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:33 -0700
Message-ID: <200707172302.l6HN2XKH011581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46630 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765604AbXGQXRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mschmidt@redhat.com, stable@kernel.org, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     destroy_workqueue() can livelock
has been removed from the -mm tree.  Its filename was
     destroy_workqueue-can-livelock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN kernel/workqueue.c~destroy_workqueue-can-livelock kernel/workqueue.c
--- a/kernel/workqueue.c~destroy_workqueue-can-livelock
+++ a/kernel/workqueue.c
@@ -752,18 +752,17 @@ static void cleanup_workqueue_thread(str
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

origin.patch
git-sparc64.patch
freezer-run-show_state-when-freezing-times-out.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
