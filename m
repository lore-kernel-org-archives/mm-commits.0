Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2392DC3526F
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0CC523B27
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgLTC6y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 21:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbgLTC6y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 21:58:54 -0500
Date:   Sat, 19 Dec 2020 18:57:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608433074;
        bh=XRC5hzSPQMi97o2+KoGMYnJ/eefe7WGmbDBxwHRzq8w=;
        h=From:To:Subject:From;
        b=F6vXzo7qDV+1buzUPXGdUx551/JXoXxUGrekpt1QaHqzBOFfHSUyukB905oAow6qc
         SlvttPvflBdnrlQwGSR0s1XVcpqli4AFfLv6WTR+qEP5QDtA77pm+wUgipRbLwnQkY
         s3lLOGq630mI6/39HK2DZl6zvGOB5M7Sv/dWkUhU=
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  [merged]
 epoll-pull-all-code-between-fetch_events-and-send_event-into-the-loop.patch
 removed from -mm tree
Message-ID: <20201220025753.irQbxPm0V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: pull all code between fetch_events and send_event into the loop
has been removed from the -mm tree.  Its filename was
     epoll-pull-all-code-between-fetch_events-and-send_event-into-the-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Soheil Hassas Yeganeh <soheil@google.com>
Subject: epoll: pull all code between fetch_events and send_event into the loop

This is a no-op change which simplifies the follow up patches.

Link: https://lkml.kernel.org/r/20201106231635.3528496-7-soheil.kdev@gmail.com
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Cc: Guantao Liu <guantaol@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

--- a/fs/eventpoll.c~epoll-pull-all-code-between-fetch_events-and-send_event-into-the-loop
+++ a/fs/eventpoll.c
@@ -1774,14 +1774,14 @@ static int ep_poll(struct eventpoll *ep,
 	}
 
 fetch_events:
-	eavail = ep_events_available(ep);
-	if (!eavail)
-		eavail = ep_busy_loop(ep, timed_out);
+	do {
+		eavail = ep_events_available(ep);
+		if (!eavail)
+			eavail = ep_busy_loop(ep, timed_out);
 
-	if (eavail)
-		goto send_events;
+		if (eavail)
+			goto send_events;
 
-	do {
 		if (signal_pending(current))
 			return -EINTR;
 
@@ -1830,21 +1830,22 @@ fetch_events:
 		 * carefully under lock, below.
 		 */
 		eavail = 1;
-	} while (0);
 
-	if (!list_empty_careful(&wait.entry)) {
-		write_lock_irq(&ep->lock);
-		/*
-		 * If the thread timed out and is not on the wait queue, it
-		 * means that the thread was woken up after its timeout expired
-		 * before it could reacquire the lock. Thus, when wait.entry is
-		 * empty, it needs to harvest events.
-		 */
-		if (timed_out)
-			eavail = list_empty(&wait.entry);
-		__remove_wait_queue(&ep->wq, &wait);
-		write_unlock_irq(&ep->lock);
-	}
+		if (!list_empty_careful(&wait.entry)) {
+			write_lock_irq(&ep->lock);
+			/*
+			 * If the thread timed out and is not on the wait queue,
+			 * it means that the thread was woken up after its
+			 * timeout expired before it could reacquire the lock.
+			 * Thus, when wait.entry is empty, it needs to harvest
+			 * events.
+			 */
+			if (timed_out)
+				eavail = list_empty(&wait.entry);
+			__remove_wait_queue(&ep->wq, &wait);
+			write_unlock_irq(&ep->lock);
+		}
+	} while (0);
 
 send_events:
 	/*
_

Patches currently in -mm which might be from soheil@google.com are


