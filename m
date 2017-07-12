From: akpm@linux-foundation.org
Subject: [patch 49/96] ipc/msg: remove special msg_alloc/free
Date: Wed, 12 Jul 2017 14:35:28 -0700
Message-ID: <20170712213528.mSSOqnjNo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53662 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVf3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:35:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Kees Cook <keescook@chromium.org>
Subject: ipc/msg: remove special msg_alloc/free

There is nothing special about the msg_alloc/free routines any more,
so remove them to make code more readable.

[manfred@colorfullife.com: Rediff to keep rcu protection for security_msg_queue_alloc()]
Link: http://lkml.kernel.org/r/20170525185107.12869-19-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff -puN ipc/msg.c~ipc-msg-remove-special-msg_alloc-free ipc/msg.c
--- a/ipc/msg.c~ipc-msg-remove-special-msg_alloc-free
+++ a/ipc/msg.c
@@ -95,29 +95,13 @@ static inline void msg_rmid(struct ipc_n
 	ipc_rmid(&msg_ids(ns), &s->q_perm);
 }
 
-static void __msg_free(struct msg_queue *msq)
-{
-	kvfree(msq);
-}
-
 static void msg_rcu_free(struct rcu_head *head)
 {
 	struct kern_ipc_perm *p = container_of(head, struct kern_ipc_perm, rcu);
 	struct msg_queue *msq = container_of(p, struct msg_queue, q_perm);
 
 	security_msg_queue_free(msq);
-	__msg_free(msq);
-}
-
-static struct msg_queue *msg_alloc(void)
-{
-	struct msg_queue *msq;
-
-	msq = kvmalloc(sizeof(*msq), GFP_KERNEL);
-	if (unlikely(!msq))
-		return NULL;
-
-	return msq;
+	kvfree(msq);
 }
 
 /**
@@ -134,8 +118,8 @@ static int newque(struct ipc_namespace *
 	key_t key = params->key;
 	int msgflg = params->flg;
 
-	msq = msg_alloc();
-	if (!msq)
+	msq = kvmalloc(sizeof(*msq), GFP_KERNEL);
+	if (unlikely(!msq))
 		return -ENOMEM;
 
 	msq->q_perm.mode = msgflg & S_IRWXUGO;
@@ -144,7 +128,7 @@ static int newque(struct ipc_namespace *
 	msq->q_perm.security = NULL;
 	retval = security_msg_queue_alloc(msq);
 	if (retval) {
-		__msg_free(msq);
+		kvfree(msq);
 		return retval;
 	}
 
_
