From: akpm@linux-foundation.org
Subject: [merged] ipc-msg-avoid-ipc_rcu_alloc.patch removed from
 -mm tree
Date: Thu, 13 Jul 2017 13:41:35 -0700
Message-ID: <20170713204135.fBAdZt7-l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59292 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUlg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: avoid ipc_rcu_alloc()
has been removed from the -mm tree.  Its filename was
     ipc-msg-avoid-ipc_rcu_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ipc/msg: avoid ipc_rcu_alloc()

Instead of using ipc_rcu_alloc() which only performs the refcount bump,
open code it.  This also allows for msg_queue structure layout to be
randomized in the future.

Link: http://lkml.kernel.org/r/20170525185107.12869-12-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN ipc/msg.c~ipc-msg-avoid-ipc_rcu_alloc ipc/msg.c
--- a/ipc/msg.c~ipc-msg-avoid-ipc_rcu_alloc
+++ a/ipc/msg.c
@@ -109,6 +109,19 @@ static void msg_rcu_free(struct rcu_head
 	__msg_free(msq);
 }
 
+static struct msg_queue *msg_alloc(void)
+{
+	struct msg_queue *msq;
+
+	msq = kvmalloc(sizeof(*msq), GFP_KERNEL);
+	if (unlikely(!msq))
+		return NULL;
+
+	atomic_set(&msq->q_perm.refcount, 1);
+
+	return msq;
+}
+
 /**
  * newque - Create a new msg queue
  * @ns: namespace
@@ -123,10 +136,7 @@ static int newque(struct ipc_namespace *
 	key_t key = params->key;
 	int msgflg = params->flg;
 
-	BUILD_BUG_ON(offsetof(struct msg_queue, q_perm) != 0);
