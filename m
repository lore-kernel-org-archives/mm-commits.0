From: akpm@linux-foundation.org
Subject: [merged] ipc-msg-do-not-use-ipc_rcu_free.patch removed
 from -mm tree
Date: Thu, 13 Jul 2017 13:41:27 -0700
Message-ID: <20170713204127.EQt9l5_FA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59194 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752745AbdGMUl2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: do not use ipc_rcu_free()
has been removed from the -mm tree.  Its filename was
     ipc-msg-do-not-use-ipc_rcu_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ipc/msg: do not use ipc_rcu_free()

Avoid using ipc_rcu_free, since it just re-finds the original structure
pointer.  For the pre-list-init failure path, there is no RCU needed,
since it was just allocated.  It can be directly freed.

Link: http://lkml.kernel.org/r/20170525185107.12869-8-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN ipc/msg.c~ipc-msg-do-not-use-ipc_rcu_free ipc/msg.c
--- a/ipc/msg.c~ipc-msg-do-not-use-ipc_rcu_free
+++ a/ipc/msg.c
@@ -95,13 +95,18 @@ static inline void msg_rmid(struct ipc_n
 	ipc_rmid(&msg_ids(ns), &s->q_perm);
 }
 
+static void __msg_free(struct msg_queue *msq)
+{
+	kvfree(msq);
+}
+
 static void msg_rcu_free(struct rcu_head *head)
 {
 	struct kern_ipc_perm *p = container_of(head, struct kern_ipc_perm, rcu);
 	struct msg_queue *msq = container_of(p, struct msg_queue, q_perm);
 
 	security_msg_queue_free(msq);
-	ipc_rcu_free(head);
+	__msg_free(msq);
 }
 
 /**
@@ -131,7 +136,7 @@ static int newque(struct ipc_namespace *
 	msq->q_perm.security = NULL;
 	retval = security_msg_queue_alloc(msq);
 	if (retval) {
-		ipc_rcu_putref(&msq->q_perm, ipc_rcu_free);
+		__msg_free(msq);
 		return retval;
 	}
 
_

Patches currently in -mm which might be from keescook@chromium.org are


