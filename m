From: akpm@linux-foundation.org
Subject: [merged] ipcmsg-document-barriers.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:41 -0800
Message-ID: <52e80075.1G6Mkv5R5y+BFSvK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbaA1TJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: [merged] ipcmsg-document-barriers.patch removed from -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:41 -0800


The patch titled
     Subject: ipc,msg: document barriers
has been removed from the -mm tree.  Its filename was
     ipcmsg-document-barriers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,msg: document barriers

Both expunge_all() and pipeline_send() rely on both a nil msg value and a
full barrier to guarantee the correct ordering when waking up a task. 
While its counter part at the receiving end is well documented for the
lockless recv algorithm, we still need to document these specific smp_mb()
calls.

[akpm@linux-foundation.org: fix typo, per Mike]
[akpm@linux-foundation.org: mroe tpyos]
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN ipc/msg.c~ipcmsg-document-barriers ipc/msg.c
--- a/ipc/msg.c~ipcmsg-document-barriers
+++ a/ipc/msg.c
@@ -253,8 +253,14 @@ static void expunge_all(struct msg_queue
 	struct msg_receiver *msr, *t;
 
 	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
-		msr->r_msg = NULL;
+		msr->r_msg = NULL; /* initialize expunge ordering */
 		wake_up_process(msr->r_tsk);
+		/*
+		 * Ensure that the wakeup is visible before setting r_msg as
+		 * the receiving end depends on it: either spinning on a nil,
+		 * or dealing with -EAGAIN cases. See lockless receive part 1
+		 * and 2 in do_msgrcv().
+		 */
 		smp_mb();
 		msr->r_msg = ERR_PTR(res);
 	}
@@ -638,15 +644,22 @@ static inline int pipelined_send(struct
 
 			list_del(&msr->r_list);
 			if (msr->r_maxsize < msg->m_ts) {
+				/* initialize pipelined send ordering */
 				msr->r_msg = NULL;
 				wake_up_process(msr->r_tsk);
-				smp_mb();
+				smp_mb(); /* see barrier comment below */
 				msr->r_msg = ERR_PTR(-E2BIG);
 			} else {
 				msr->r_msg = NULL;
 				msq->q_lrpid = task_pid_vnr(msr->r_tsk);
 				msq->q_rtime = get_seconds();
 				wake_up_process(msr->r_tsk);
+				/*
+				 * Ensure that the wakeup is visible before
+				 * setting r_msg, as the receiving end depends
+				 * on it. See lockless receive part 1 and 2 in
+				 * do_msgrcv().
+				 */
 				smp_mb();
 				msr->r_msg = msg;
 
@@ -654,6 +667,7 @@ static inline int pipelined_send(struct
 			}
 		}
 	}
+
 	return 0;
 }
 
@@ -716,6 +730,7 @@ long do_msgsnd(int msqid, long mtype, vo
 			goto out_unlock0;
 		}
 
+		/* enqueue the sender and prepare to block */
 		ss_add(msq, &s);
 
 		if (!ipc_rcu_getref(msq)) {
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
linux-next.patch

