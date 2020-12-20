Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A5FC3526C
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7605023B03
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgLTC6u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 21:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgLTC6u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 21:58:50 -0500
Date:   Sat, 19 Dec 2020 18:57:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608433062;
        bh=qdcYc6yehOGBWJnOpeXlIz0OqsxyRpX463Ek1x7EXJQ=;
        h=From:To:Subject:From;
        b=Dgu+06yXAZdwXFNY1m18j325919Ejw6B85F67oMOMekDIHwJysoPNk7ZwYlJSGKVS
         7i/8pQzucOKAof/XRdu/jzE1P6vkmyKAZwcPkPGFq9waQKVrL5TRRe9Qm8AuM+tjy7
         e6fJB01oIuewulZtxKG8R5Sgt05p1KDuXUQKU2CY=
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  [merged] epoll-simplify-signal-handling.patch removed
 from -mm tree
Message-ID: <20201220025742.gqGygvzOJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: simplify signal handling
has been removed from the -mm tree.  Its filename was
     epoll-simplify-signal-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Soheil Hassas Yeganeh <soheil@google.com>
Subject: epoll: simplify signal handling

Check signals before locking ep->lock, and immediately return -EINTR if
there is any signal pending.

This saves a few loads, stores, and branches from the hot path and
simplifies the loop structure for follow up patches.

Link: https://lkml.kernel.org/r/20201106231635.3528496-3-soheil.kdev@gmail.com
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Cc: Guantao Liu <guantaol@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/fs/eventpoll.c~epoll-simplify-signal-handling
+++ a/fs/eventpoll.c
@@ -1733,7 +1733,7 @@ static inline struct timespec64 ep_set_m
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res = 0, eavail, timed_out = 0;
+	int res, eavail, timed_out = 0;
 	u64 slack = 0;
 	wait_queue_entry_t wait;
 	ktime_t expires, *to = NULL;
@@ -1780,6 +1780,9 @@ fetch_events:
 	ep_reset_busy_poll_napi_id(ep);
 
 	do {
+		if (signal_pending(current))
+			return -EINTR;
+
 		/*
 		 * Internally init_wait() uses autoremove_wake_function(),
 		 * thus wait entry is removed from the wait queue on each
@@ -1809,15 +1812,12 @@ fetch_events:
 		 * important.
 		 */
 		eavail = ep_events_available(ep);
-		if (!eavail) {
-			if (signal_pending(current))
-				res = -EINTR;
-			else
-				__add_wait_queue_exclusive(&ep->wq, &wait);
-		}
+		if (!eavail)
+			__add_wait_queue_exclusive(&ep->wq, &wait);
+
 		write_unlock_irq(&ep->lock);
 
-		if (!eavail && !res)
+		if (!eavail)
 			timed_out = !schedule_hrtimeout_range(to, slack,
 							      HRTIMER_MODE_ABS);
 
@@ -1853,14 +1853,14 @@ send_events:
 		 * finding more events available and fetching
 		 * repeatedly.
 		 */
-		res = -EINTR;
+		return -EINTR;
 	}
 	/*
 	 * Try to transfer events to user space. In case we get 0 events and
 	 * there's still timeout left over, we go trying again in search of
 	 * more luck.
 	 */
-	if (!res && eavail &&
+	if (eavail &&
 	    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
 		goto fetch_events;
 
_

Patches currently in -mm which might be from soheil@google.com are


