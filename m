From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 17/67] ipc/msg.c: update and document memory
 barriers
Date: Mon, 03 Feb 2020 17:34:39 -0800
Message-ID: <20200204013439.2wM1mnJcM%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBek (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:34:40 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 1vier1@web.de, akpm@linux-foundation.org, dave@stgolabs.net, linux-mm@kvack.org, longman@redhat.com, manfred@colorfullife.com, mm-commits@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org, will.deacon@arm.com

From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/msg.c: update and document memory barriers

Transfer findings from ipc/mqueue.c:

- A control barrier was missing for the lockless receive case So in
  theory, not yet initialized data may have been copied to user space -
  obviously only for architectures where control barriers are not NOP.

- use smp_store_release().  In theory, the refount may have been
  decreased to 0 already when wake_q_add() tries to get a reference.

Link: http://lkml.kernel.org/r/20191020123305.14715-5-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <1vier1@web.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

--- a/ipc/msg.c~ipc-msgc-update-and-document-memory-barriers
+++ a/ipc/msg.c
@@ -61,6 +61,16 @@ struct msg_queue {
 	struct list_head q_senders;
 } __randomize_layout;
 
+/*
+ * MSG_BARRIER Locking:
+ *
+ * Similar to the optimization used in ipc/mqueue.c, one syscall return path
+ * does not acquire any locks when it sees that a message exists in
+ * msg_receiver.r_msg. Therefore r_msg is set using smp_store_release()
+ * and accessed using READ_ONCE()+smp_acquire__after_ctrl_dep(). In addition,
+ * wake_q_add_safe() is used. See ipc/mqueue.c for more details
+ */
+
 /* one msg_receiver structure for each sleeping receiver */
 struct msg_receiver {
 	struct list_head	r_list;
@@ -184,6 +194,10 @@ static inline void ss_add(struct msg_que
 {
 	mss->tsk = current;
 	mss->msgsz = msgsz;
+	/*
+	 * No memory barrier required: we did ipc_lock_object(),
+	 * and the waker obtains that lock before calling wake_q_add().
+	 */
 	__set_current_state(TASK_INTERRUPTIBLE);
 	list_add_tail(&mss->list, &msq->q_senders);
 }
@@ -237,8 +251,11 @@ static void expunge_all(struct msg_queue
 	struct msg_receiver *msr, *t;
 
 	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
-		wake_q_add(wake_q, msr->r_tsk);
-		WRITE_ONCE(msr->r_msg, ERR_PTR(res));
+		get_task_struct(msr->r_tsk);
+
+		/* see MSG_BARRIER for purpose/pairing */
+		smp_store_release(&msr->r_msg, ERR_PTR(res));
+		wake_q_add_safe(wake_q, msr->r_tsk);
 	}
 }
 
@@ -798,13 +815,17 @@ static inline int pipelined_send(struct
 			list_del(&msr->r_list);
 			if (msr->r_maxsize < msg->m_ts) {
 				wake_q_add(wake_q, msr->r_tsk);
-				WRITE_ONCE(msr->r_msg, ERR_PTR(-E2BIG));
+
+				/* See expunge_all regarding memory barrier */
+				smp_store_release(&msr->r_msg, ERR_PTR(-E2BIG));
 			} else {
 				ipc_update_pid(&msq->q_lrpid, task_pid(msr->r_tsk));
 				msq->q_rtime = ktime_get_real_seconds();
 
 				wake_q_add(wake_q, msr->r_tsk);
-				WRITE_ONCE(msr->r_msg, msg);
+
+				/* See expunge_all regarding memory barrier */
+				smp_store_release(&msr->r_msg, msg);
 				return 1;
 			}
 		}
@@ -1154,7 +1175,11 @@ static long do_msgrcv(int msqid, void __
 			msr_d.r_maxsize = INT_MAX;
 		else
 			msr_d.r_maxsize = bufsz;
-		msr_d.r_msg = ERR_PTR(-EAGAIN);
+
+		/* memory barrier not require due to ipc_lock_object() */
+		WRITE_ONCE(msr_d.r_msg, ERR_PTR(-EAGAIN));
+
+		/* memory barrier not required, we own ipc_lock_object() */
 		__set_current_state(TASK_INTERRUPTIBLE);
 
 		ipc_unlock_object(&msq->q_perm);
@@ -1183,8 +1208,12 @@ static long do_msgrcv(int msqid, void __
 		 * signal) it will either see the message and continue ...
 		 */
 		msg = READ_ONCE(msr_d.r_msg);
-		if (msg != ERR_PTR(-EAGAIN))
+		if (msg != ERR_PTR(-EAGAIN)) {
+			/* see MSG_BARRIER for purpose/pairing */
+			smp_acquire__after_ctrl_dep();
+
 			goto out_unlock1;
+		}
 
 		 /*
 		  * ... or see -EAGAIN, acquire the lock to check the message
@@ -1192,7 +1221,7 @@ static long do_msgrcv(int msqid, void __
 		  */
 		ipc_lock_object(&msq->q_perm);
 
-		msg = msr_d.r_msg;
+		msg = READ_ONCE(msr_d.r_msg);
 		if (msg != ERR_PTR(-EAGAIN))
 			goto out_unlock0;
 
_
