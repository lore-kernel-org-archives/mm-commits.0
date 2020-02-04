From: akpm@linux-foundation.org
Subject: [merged] ipc-mqueuec-remove-duplicated-code.patch removed
 from -mm tree
Date: Tue, 04 Feb 2020 10:40:31 -0800
Message-ID: <20200204184031.n9DncHMnW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbgBDSke (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 1vier1@web.de, dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com, mm-commits@vger.kernel.org, peterz@infradead.org, will.deacon@arm.com


The patch titled
     Subject: ipc/mqueue.c: remove duplicated code
has been removed from the -mm tree.  Its filename was
     ipc-mqueuec-remove-duplicated-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/mqueue.c: remove duplicated code

pipelined_send() and pipelined_receive() are identical, so merge them.

[manfred@colorfullife.com: add changelog]
Link: http://lkml.kernel.org/r/20191020123305.14715-3-manfred@colorfullife.com
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: <1vier1@web.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/ipc/mqueue.c~ipc-mqueuec-remove-duplicated-code
+++ a/ipc/mqueue.c
@@ -918,17 +918,12 @@ out_name:
  * The same algorithm is used for senders.
  */
 
-/* pipelined_send() - send a message directly to the task waiting in
- * sys_mq_timedreceive() (without inserting message into a queue).
- */
-static inline void pipelined_send(struct wake_q_head *wake_q,
+static inline void __pipelined_op(struct wake_q_head *wake_q,
 				  struct mqueue_inode_info *info,
-				  struct msg_msg *message,
-				  struct ext_wait_queue *receiver)
+				  struct ext_wait_queue *this)
 {
-	receiver->msg = message;
-	list_del(&receiver->list);
-	wake_q_add(wake_q, receiver->task);
+	list_del(&this->list);
+	wake_q_add(wake_q, this->task);
 	/*
 	 * Rely on the implicit cmpxchg barrier from wake_q_add such
 	 * that we can ensure that updating receiver->state is the last
@@ -937,7 +932,19 @@ static inline void pipelined_send(struct
 	 * yet, at that point we can later have a use-after-free
 	 * condition and bogus wakeup.
 	 */
-	receiver->state = STATE_READY;
+	this->state = STATE_READY;
+}
+
+/* pipelined_send() - send a message directly to the task waiting in
+ * sys_mq_timedreceive() (without inserting message into a queue).
+ */
+static inline void pipelined_send(struct wake_q_head *wake_q,
+				  struct mqueue_inode_info *info,
+				  struct msg_msg *message,
+				  struct ext_wait_queue *receiver)
+{
+	receiver->msg = message;
+	__pipelined_op(wake_q, info, receiver);
 }
 
 /* pipelined_receive() - if there is task waiting in sys_mq_timedsend()
@@ -955,9 +962,7 @@ static inline void pipelined_receive(str
 	if (msg_insert(sender->msg, info))
 		return;
 
-	list_del(&sender->list);
-	wake_q_add(wake_q, sender->task);
-	sender->state = STATE_READY;
+	__pipelined_op(wake_q, info, sender);
 }
 
 static int do_mq_timedsend(mqd_t mqdes, const char __user *u_msg_ptr,
_

Patches currently in -mm which might be from dave@stgolabs.net are
