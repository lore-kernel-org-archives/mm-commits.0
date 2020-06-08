From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 02/54] ipc/msg: add missing annotation for
 freeque()
Date: Sun, 07 Jun 2020 21:40:07 -0700
Message-ID: <20200608044007.facFrVHN2%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEkI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:40:08 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, boqun.feng@gmail.com, dave@stgolabs.net, jbi.octave@gmail.com, linux-mm@kvack.org, manfred@colorfullife.com, mm-commits@vger.kernel.org, natechancellor@gmail.com, shuaibinglu@126.com, torvalds@linux-foundation.org

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
