From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:03:53 -0700
Message-ID: <55ef2309.7eL3f88ECEeR0LTu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbbIHSDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:03:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: waitqueue: add nr wake parameter to __wake_up_locked_key
has been removed from the -mm tree.  Its filename was
     userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: waitqueue: add nr wake parameter to __wake_up_locked_key

userfaultfd needs to wake all waitqueues (pass 0 as nr parameter), instead
of the current hardcoded 1 (that would wake just the first waitqueue in
the head list).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |    5 +++--
 kernel/sched/wait.c  |    7 ++++---
 net/sunrpc/sched.c   |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/linux/wait.h~userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key include/linux/wait.h
--- a/include/linux/wait.h~userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key
+++ a/include/linux/wait.h
@@ -147,7 +147,8 @@ __remove_wait_queue(wait_queue_head_t *h
 
 typedef int wait_bit_action_f(struct wait_bit_key *);
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
-void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
+void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, int nr,
+			  void *key);
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
@@ -179,7 +180,7 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up_poll(x, m)						\
 	__wake_up(x, TASK_NORMAL, 1, (void *) (m))
 #define wake_up_locked_poll(x, m)					\
-	__wake_up_locked_key((x), TASK_NORMAL, (void *) (m))
+	__wake_up_locked_key((x), TASK_NORMAL, 1, (void *) (m))
 #define wake_up_interruptible_poll(x, m)				\
 	__wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
 #define wake_up_interruptible_sync_poll(x, m)				\
diff -puN kernel/sched/wait.c~userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key kernel/sched/wait.c
--- a/kernel/sched/wait.c~userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key
+++ a/kernel/sched/wait.c
@@ -106,9 +106,10 @@ void __wake_up_locked(wait_queue_head_t
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked);
 
-void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
+void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, int nr,
+			  void *key)
 {
-	__wake_up_common(q, mode, 1, 0, key);
+	__wake_up_common(q, mode, nr, 0, key);
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked_key);
 
@@ -283,7 +284,7 @@ void abort_exclusive_wait(wait_queue_hea
 	if (!list_empty(&wait->task_list))
 		list_del_init(&wait->task_list);
 	else if (waitqueue_active(q))
-		__wake_up_locked_key(q, mode, key);
+		__wake_up_locked_key(q, mode, 1, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(abort_exclusive_wait);
diff -puN net/sunrpc/sched.c~userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key net/sunrpc/sched.c
--- a/net/sunrpc/sched.c~userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key
+++ a/net/sunrpc/sched.c
@@ -297,7 +297,7 @@ static int rpc_complete_task(struct rpc_
 	clear_bit(RPC_TASK_ACTIVE, &task->tk_runstate);
 	ret = atomic_dec_and_test(&task->tk_count);
 	if (waitqueue_active(wq))
-		__wake_up_locked_key(wq, TASK_NORMAL, &k);
+		__wake_up_locked_key(wq, TASK_NORMAL, 1, &k);
 	spin_unlock_irqrestore(&wq->lock, flags);
 	return ret;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

