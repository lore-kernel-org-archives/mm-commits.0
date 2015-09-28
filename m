From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch removed from -mm tree
Date: Mon, 28 Sep 2015 11:15:38 -0700
Message-ID: <560983ca.+yduCUMOCvtztNXP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbbI1SPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: revert "userfaultfd: waitqueue: add nr wake parameter to __wake_up_locked_key"
has been removed from the -mm tree.  Its filename was
     userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: revert "userfaultfd: waitqueue: add nr wake parameter to __wake_up_locked_key"

This reverts commit 51360155eccb907ff8635bd10fc7de876408c2e0 and adapts
fs/userfaultfd.c to use the old version of that function.

It didn't look robust to call __wake_up_common with "nr == 1" when we
absolutely require wakeall semantics, but we've full control of what we
insert in the two waitqueue heads of the blocked userfaults.  No exclusive
waitqueue risks to be inserted into those two waitqueue heads so we can as
well stick to "nr == 1" of the old code and we can rely purely on the fact
no waitqueue inserted in one of the two waitqueue heads we must enforce as
wakeall, has wait->flags WQ_FLAG_EXCLUSIVE set.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c     |    8 ++++----
 include/linux/wait.h |    5 ++---
 kernel/sched/wait.c  |    7 +++----
 net/sunrpc/sched.c   |    2 +-
 4 files changed, 10 insertions(+), 12 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key
+++ a/fs/userfaultfd.c
@@ -467,8 +467,8 @@ static int userfaultfd_release(struct in
 	 * the fault_*wqh.
 	 */
 	spin_lock(&ctx->fault_pending_wqh.lock);
-	__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL, 0, &range);
-	__wake_up_locked_key(&ctx->fault_wqh, TASK_NORMAL, 0, &range);
+	__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL, &range);
+	__wake_up_locked_key(&ctx->fault_wqh, TASK_NORMAL, &range);
 	spin_unlock(&ctx->fault_pending_wqh.lock);
 
 	wake_up_poll(&ctx->fd_wqh, POLLHUP);
@@ -650,10 +650,10 @@ static void __wake_userfault(struct user
 	spin_lock(&ctx->fault_pending_wqh.lock);
 	/* wake all in the range and autoremove */
 	if (waitqueue_active(&ctx->fault_pending_wqh))
-		__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL, 0,
+		__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL,
 				     range);
 	if (waitqueue_active(&ctx->fault_wqh))
-		__wake_up_locked_key(&ctx->fault_wqh, TASK_NORMAL, 0, range);
+		__wake_up_locked_key(&ctx->fault_wqh, TASK_NORMAL, range);
 	spin_unlock(&ctx->fault_pending_wqh.lock);
 }
 
diff -puN include/linux/wait.h~userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key include/linux/wait.h
--- a/include/linux/wait.h~userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key
+++ a/include/linux/wait.h
@@ -147,8 +147,7 @@ __remove_wait_queue(wait_queue_head_t *h
 
 typedef int wait_bit_action_f(struct wait_bit_key *);
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
-void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, int nr,
-			  void *key);
+void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
@@ -180,7 +179,7 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up_poll(x, m)						\
 	__wake_up(x, TASK_NORMAL, 1, (void *) (m))
 #define wake_up_locked_poll(x, m)					\
-	__wake_up_locked_key((x), TASK_NORMAL, 1, (void *) (m))
+	__wake_up_locked_key((x), TASK_NORMAL, (void *) (m))
 #define wake_up_interruptible_poll(x, m)				\
 	__wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
 #define wake_up_interruptible_sync_poll(x, m)				\
diff -puN kernel/sched/wait.c~userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key kernel/sched/wait.c
--- a/kernel/sched/wait.c~userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key
+++ a/kernel/sched/wait.c
@@ -106,10 +106,9 @@ void __wake_up_locked(wait_queue_head_t
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked);
 
-void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, int nr,
-			  void *key)
+void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
 {
-	__wake_up_common(q, mode, nr, 0, key);
+	__wake_up_common(q, mode, 1, 0, key);
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked_key);
 
@@ -284,7 +283,7 @@ void abort_exclusive_wait(wait_queue_hea
 	if (!list_empty(&wait->task_list))
 		list_del_init(&wait->task_list);
 	else if (waitqueue_active(q))
-		__wake_up_locked_key(q, mode, 1, key);
+		__wake_up_locked_key(q, mode, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(abort_exclusive_wait);
diff -puN net/sunrpc/sched.c~userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key net/sunrpc/sched.c
--- a/net/sunrpc/sched.c~userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key
+++ a/net/sunrpc/sched.c
@@ -297,7 +297,7 @@ static int rpc_complete_task(struct rpc_
 	clear_bit(RPC_TASK_ACTIVE, &task->tk_runstate);
 	ret = atomic_dec_and_test(&task->tk_count);
 	if (waitqueue_active(wq))
-		__wake_up_locked_key(wq, TASK_NORMAL, 1, &k);
+		__wake_up_locked_key(wq, TASK_NORMAL, &k);
 	spin_unlock_irqrestore(&wq->lock, flags);
 	return ret;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are


