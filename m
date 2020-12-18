Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAD9C35273
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF9D923BDD
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgLRWDA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:03:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgLRWDA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:03:00 -0500
Date:   Fri, 18 Dec 2020 14:02:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608328927;
        bh=/w5Chu1RojjOulIY4C553qsl8NTMpu2u/eUurC+C05c=;
        h=From:To:Subject:In-Reply-To:From;
        b=AInEbVLnqgOW6UQx+Wz5148vG500CI8PvZFKpkGe5J7G/W72CLUrVgjqsxy6zVDCn
         Hr7em/D7udu/bqIENwfgpkWKHXeOTXh5E6PsZn5kg2Y3UN8dbQ39sWLC2VX0mTA93l
         HpP8zETon8DcS8kkUrx1Kk5272NS3m9WtBrjMECE=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, edumazet@google.com,
        guantaol@google.com, khazhy@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  [patch 13/78] epoll: eliminate unnecessary lock for zero
 timeout
Message-ID: <20201218220206.CTX0JqXyM%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
