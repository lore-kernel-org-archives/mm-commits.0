From: akpm@linux-foundation.org
Subject: + ipc-msg-remove-special-msg_alloc-free.patch added to -mm tree
Date: Thu, 25 May 2017 15:11:26 -0700
Message-ID: <5927568e.k0f+yUzXfD39wmgK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165841AbdEYWL1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: remove special msg_alloc/free
has been added to the -mm tree.  Its filename is
     ipc-msg-remove-special-msg_alloc-free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msg-remove-special-msg_alloc-free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msg-remove-special-msg_alloc-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from keescook@chromium.org are

ipc-drop-non-rcu-allocation.patch
ipc-sem-do-not-use-ipc_rcu_free.patch
ipc-shm-do-not-use-ipc_rcu_free.patch
ipc-msg-do-not-use-ipc_rcu_free.patch
ipc-util-drop-ipc_rcu_free.patch
ipc-sem-avoid-ipc_rcu_alloc.patch
ipc-shm-avoid-ipc_rcu_alloc.patch
ipc-msg-avoid-ipc_rcu_alloc.patch
ipc-util-drop-ipc_rcu_alloc.patch
ipc-move-atomic_set-to-where-it-is-needed.patch
ipc-shm-remove-special-shm_alloc-free.patch
ipc-msg-remove-special-msg_alloc-free.patch
ipc-sem-drop-__sem_free.patch

