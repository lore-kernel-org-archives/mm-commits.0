From: akpm@linux-foundation.org
Subject: + ipc-msg-make-ss_wakeup-kill-arg-boolean.patch added to -mm tree
Date: Wed, 10 Aug 2016 15:53:34 -0700
Message-ID: <57abb06e.MX/eeBWfXBnNDMW7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbcHJWxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 18:53:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, bigeasy@linutronix.de, manfred@colorfullife.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: make ss_wakeup() kill arg boolean
has been added to the -mm tree.  Its filename is
     ipc-msg-make-ss_wakeup-kill-arg-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msg-make-ss_wakeup-kill-arg-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msg-make-ss_wakeup-kill-arg-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/msg: make ss_wakeup() kill arg boolean

... 'tis annoying.

Link: http://lkml.kernel.org/r/1469748819-19484-4-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN ipc/msg.c~ipc-msg-make-ss_wakeup-kill-arg-boolean ipc/msg.c
--- a/ipc/msg.c~ipc-msg-make-ss_wakeup-kill-arg-boolean
+++ a/ipc/msg.c
@@ -167,7 +167,7 @@ static inline void ss_del(struct msg_sen
 }
 
 static void ss_wakeup(struct list_head *h,
-		      struct wake_q_head *wake_q, int kill)
+		      struct wake_q_head *wake_q, bool kill)
 {
 	struct msg_sender *mss, *t;
 
@@ -204,7 +204,7 @@ static void freeque(struct ipc_namespace
 	WAKE_Q(wake_q);
 
 	expunge_all(msq, -EIDRM, &wake_q);
-	ss_wakeup(&msq->q_senders, &wake_q, 1);
+	ss_wakeup(&msq->q_senders, &wake_q, true);
 	msg_rmid(ns, msq);
 	ipc_unlock_object(&msq->q_perm);
 	wake_up_q(&wake_q);
@@ -388,7 +388,7 @@ static int msgctl_down(struct ipc_namesp
 		 * Sleeping senders might be able to send
 		 * due to a larger queue size.
 		 */
-		ss_wakeup(&msq->q_senders, &wake_q, 0);
+		ss_wakeup(&msq->q_senders, &wake_q, false);
 		ipc_unlock_object(&msq->q_perm);
 		wake_up_q(&wake_q);
 
@@ -882,7 +882,7 @@ long do_msgrcv(int msqid, void __user *b
 			msq->q_cbytes -= msg->m_ts;
 			atomic_sub(msg->m_ts, &ns->msg_bytes);
 			atomic_dec(&ns->msg_hdrs);
-			ss_wakeup(&msq->q_senders, &wake_q, 0);
+			ss_wakeup(&msq->q_senders, &wake_q, false);
 
 			goto out_unlock0;
 		}
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-msg-batch-queue-sender-wakeups.patch
ipc-msg-make-ss_wakeup-kill-arg-boolean.patch
ipc-msg-lockless-security-checks-for-msgsnd.patch
ipc-msg-avoid-waking-sender-upon-full-queue.patch

