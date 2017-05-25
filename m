From: akpm@linux-foundation.org
Subject: + ipc-msgc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch added
 to -mm tree
Date: Thu, 25 May 2017 15:11:20 -0700
Message-ID: <59275688.1VW2E6P3iIILYSND%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163339AbdEYWL0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, dave@stgolabs.net, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg.c: avoid ipc_rcu_putref for failed ipc_addid()
has been added to the -mm tree.  Its filename is
     ipc-msgc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msgc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msgc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-remove-sem_base-embed-struct-sem.patch
ipc-semc-remove-sem_base-embed-struct-sem-v3.patch
ipc-merge-ipc_rcu-and-kern_ipc_perm.patch
include-linux-semh-correctly-document-sem_ctime.patch
ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-shmc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-msgc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref.patch

