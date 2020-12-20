Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7466DC3527E
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4830B23B08
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgLTC64 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 21:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbgLTC64 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 21:58:56 -0500
Date:   Sat, 19 Dec 2020 18:57:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608433079;
        bh=x5rEx0DXJj0j2oMJdjW0nvgbBcMiK1nje8g1iwERmYI=;
        h=From:To:Subject:From;
        b=oe4fIsmpVbx6nBXO5mxhZvEZ15+s3X53rpkGzvD8w8LKGEJYCUMEB2Yg3NhyGIUyf
         AgDXyS0itfp5EicoCC6fDOBUlwSybO0JeoG6nLJWx/ZhE9wHu/7hzkB5Pqx98NyyIu
         RpcZT7pt99ZF8GfGwKzxNgHsx2hHlTH8AGJVeH4E=
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  [merged]
 epoll-eliminate-unnecessary-lock-for-zero-timeout.patch removed from -mm
 tree
Message-ID: <20201220025759.JcZDvTBtt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: eliminate unnecessary lock for zero timeout
has been removed from the -mm tree.  Its filename was
     epoll-eliminate-unnecessary-lock-for-zero-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Soheil Hassas Yeganeh <soheil@google.com>
Subject: epoll: eliminate unnecessary lock for zero timeout

We call ep_events_available() under lock when timeout is 0, and then call
it without locks in the loop for the other cases.

Instead, call ep_events_available() without lock for all cases.  For
non-zero timeouts, we will recheck after adding the thread to the wait
queue.  For zero timeout cases, by definition, user is opportunistically
polling and will have to call epoll_wait again in the future.

Note that this lock was kept in c5a282e9635e9 because the whole loop was
historically under lock.

This patch results in a 1% CPU/RPC reduction in RPC benchmarks.

Link: https://lkml.kernel.org/r/20201106231635.3528496-9-soheil.kdev@gmail.com
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Cc: Guantao Liu <guantaol@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/fs/eventpoll.c~epoll-eliminate-unnecessary-lock-for-zero-timeout
+++ a/fs/eventpoll.c
@@ -1743,7 +1743,7 @@ static inline struct timespec64 ep_set_m
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res, eavail = 0, timed_out = 0;
+	int res, eavail, timed_out = 0;
 	u64 slack = 0;
 	wait_queue_entry_t wait;
 	ktime_t expires, *to = NULL;
@@ -1759,18 +1759,21 @@ static int ep_poll(struct eventpoll *ep,
 	} else if (timeout == 0) {
 		/*
 		 * Avoid the unnecessary trip to the wait queue loop, if the
-		 * caller specified a non blocking operation. We still need
-		 * lock because we could race and not see an epi being added
-		 * to the ready list while in irq callback. Thus incorrectly
-		 * returning 0 back to userspace.
+		 * caller specified a non blocking operation.
 		 */
 		timed_out = 1;
-
-		write_lock_irq(&ep->lock);
-		eavail = ep_events_available(ep);
-		write_unlock_irq(&ep->lock);
 	}
 
+	/*
+	 * This call is racy: We may or may not see events that are being added
+	 * to the ready list under the lock (e.g., in IRQ callbacks). For, cases
+	 * with a non-zero timeout, this thread will check the ready list under
+	 * lock and will added to the wait queue.  For, cases with a zero
+	 * timeout, the user by definition should not care and will have to
+	 * recheck again.
+	 */
+	eavail = ep_events_available(ep);
+
 	while (1) {
 		if (eavail) {
 			/*
@@ -1786,10 +1789,6 @@ static int ep_poll(struct eventpoll *ep,
 		if (timed_out)
 			return 0;
 
-		eavail = ep_events_available(ep);
-		if (eavail)
-			continue;
-
 		eavail = ep_busy_loop(ep, timed_out);
 		if (eavail)
 			continue;
_

Patches currently in -mm which might be from soheil@google.com are


