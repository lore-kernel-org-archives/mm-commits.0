From: akpm@linux-foundation.org
Subject: [merged] kthread-dont-looking-for-a-task-in-create_kthread-2.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:37:11 -0800
Message-ID: <200902021937.n12JbBBN013927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbZBBTio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:38:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgusev@openvz.org, hch@lst.de, oleg@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     kthread: don't look for a task in create_kthread()
has been removed from the -mm tree.  Its filename was
     kthread-dont-looking-for-a-task-in-create_kthread-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kthread: don't look for a task in create_kthread()
From: Vitaliy Gusev <vgusev@openvz.org>

Remove the unnecessary find_task_by_pid_ns().  kthread() can just use
"current" to get the same result.

Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/kthread.c~kthread-dont-looking-for-a-task-in-create_kthread-2 kernel/kthread.c
--- a/kernel/kthread.c~kthread-dont-looking-for-a-task-in-create_kthread-2
+++ a/kernel/kthread.c
@@ -78,6 +78,7 @@ static int kthread(void *_create)
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
+	create->result = current;
 	complete(&create->started);
 	schedule();
 
@@ -103,9 +104,6 @@ static void create_kthread(struct kthrea
 	} else {
 		struct sched_param param = { .sched_priority = 0 };
 		wait_for_completion(&create->started);
-		read_lock(&tasklist_lock);
-		create->result = find_task_by_pid_ns(pid, &init_pid_ns);
-		read_unlock(&tasklist_lock);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
 		 * The kernel thread should not inherit these properties.
_

Patches currently in -mm which might be from vgusev@openvz.org are

linux-next.patch
kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch

