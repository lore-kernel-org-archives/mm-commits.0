From: akpm@linux-foundation.org
Subject: [patch 46/96] ipc/msg.c: avoid ipc_rcu_putref for failed
 ipc_addid()
Date: Wed, 12 Jul 2017 14:35:19 -0700
Message-ID: <20170712213519.d5zrjhDTr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753369AbdGLVfU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:35:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/msg.c: avoid ipc_rcu_putref for failed ipc_addid()

Loosely based on a patch from Kees Cook <keescook@chromium.org>:
- id and retval can be merged
- if ipc_addid() fails, then use call_rcu() directly.

The difference is that call_rcu is used for failed ipc_addid() calls, to
continue to guaranteed an rcu delay for security_msg_queue_free().

Link: http://lkml.kernel.org/r/20170525185107.12869-16-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN ipc/msg.c~ipc-msgc-avoid-ipc_rcu_putref-for-failed-ipc_addid ipc/msg.c
--- a/ipc/msg.c~ipc-msgc-avoid-ipc_rcu_putref-for-failed-ipc_addid
+++ a/ipc/msg.c
@@ -132,7 +132,7 @@ static struct msg_queue *msg_alloc(void)
 static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 {
 	struct msg_queue *msq;
-	int id, retval;
+	int retval;
 	key_t key = params->key;
 	int msgflg = params->flg;
 
@@ -160,10 +160,10 @@ static int newque(struct ipc_namespace *
 	INIT_LIST_HEAD(&msq->q_senders);
 
 	/* ipc_addid() locks msq upon success. */
-	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
-	if (id < 0) {
-		ipc_rcu_putref(&msq->q_perm, msg_rcu_free);
-		return id;
+	retval = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
+	if (retval < 0) {
+		call_rcu(&msq->q_perm.rcu, msg_rcu_free);
+		return retval;
 	}
 
 	ipc_unlock_object(&msq->q_perm);
_
