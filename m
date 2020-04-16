From: akpm@linux-foundation.org
Subject: + ipc-msg-add-missing-annotation-for-freeque.patch added
 to -mm tree
Date: Wed, 15 Apr 2020 20:04:04 -0700
Message-ID: <20200416030404.8akcDrLiK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388679AbgDPDEF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 23:04:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, boqun.feng@gmail.com, dave@stgolabs.net, jbi.octave@gmail.com, manfred@colorfullife.com, mm-commits@vger.kernel.org, natechancellor@gmail.com, shuaibinglu@126.com


The patch titled
     Subject: ipc/msg: add missing annotation for freeque()
has been added to the -mm tree.  Its filename is
     ipc-msg-add-missing-annotation-for-freeque.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msg-add-missing-annotation-for-freeque.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msg-add-missing-annotation-for-freeque.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: ipc/msg: add missing annotation for freeque()

Sparse reports a warning at freeque()

warning: context imbalance in freeque() - unexpected unlock

The root cause is the missing annotation at freeque()

Add the missing __releases(RCU) annotation
Add the missing __releases(&msq->q_perm) annotation

Link: http://lkml.kernel.org/r/20200403160505.2832-2-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Lu Shuaibing <shuaibinglu@126.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/ipc/msg.c~ipc-msg-add-missing-annotation-for-freeque
+++ a/ipc/msg.c
@@ -268,6 +268,8 @@ static void expunge_all(struct msg_queue
  * before freeque() is called. msg_ids.rwsem remains locked on exit.
  */
 static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
+	__releases(RCU)
+	__releases(&msq->q_perm)
 {
 	struct msg_msg *msg, *t;
 	struct msg_queue *msq = container_of(ipcp, struct msg_queue, q_perm);
_

Patches currently in -mm which might be from jbi.octave@gmail.com are

ocfs2-add-missing-annotation-for-dlm_empty_lockres.patch
ipc-msg-add-missing-annotation-for-freeque.patch
