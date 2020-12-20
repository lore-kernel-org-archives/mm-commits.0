Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3FFC35270
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F4B723B27
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgLTC64 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 21:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbgLTC64 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 21:58:56 -0500
Date:   Sat, 19 Dec 2020 18:57:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608433076;
        bh=xlxKKuDjxmlCnB72RgpBzbvHqQTrCxcxWvj9GjbKCvY=;
        h=From:To:Subject:From;
        b=ryPx7VFCqiSejYuqkZdgKZJmNB0iW1XPxrYWYiWdDuXwXAKEHKrAnr3CW9c9KEtes
         acUwdZ1jihWjoZSrHqJyzw/NCSPFD+aumf0I+0YtRFUlsyjDfiLRUhYXdKqYuDI69i
         99W0QkK6r5xniHjgGEluBDuQAZF8TQ9NbyHx5eIA=
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  [merged] epoll-replace-gotos-with-a-proper-loop.patch
 removed from -mm tree
Message-ID: <20201220025756.g8l2RTlJb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: replace gotos with a proper loop
has been removed from the -mm tree.  Its filename was
     epoll-replace-gotos-with-a-proper-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Soheil Hassas Yeganeh <soheil@google.com>
Subject: epoll: replace gotos with a proper loop

The existing loop is pointless, and the labels make it really hard to
follow the structure.

Replace that control structure with a simple loop that returns when there
are new events, there is a signal, or the thread has timed out.

Link: https://lkml.kernel.org/r/20201106231635.3528496-8-soheil.kdev@gmail.com
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Cc: Guantao Liu <guantaol@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/fs/eventpoll.c~epoll-replace-gotos-with-a-proper-loop
+++ a/fs/eventpoll.c
@@ -1743,7 +1743,7 @@ static inline struct timespec64 ep_set_m
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res, eavail, timed_out = 0;
+	int res, eavail = 0, timed_out = 0;
 	u64 slack = 0;
 	wait_queue_entry_t wait;
 	ktime_t expires, *to = NULL;
@@ -1769,18 +1769,30 @@ static int ep_poll(struct eventpoll *ep,
 		write_lock_irq(&ep->lock);
 		eavail = ep_events_available(ep);
 		write_unlock_irq(&ep->lock);
-
-		goto send_events;
 	}
 
-fetch_events:
-	do {
+	while (1) {
+		if (eavail) {
+			/*
+			 * Try to transfer events to user space. In case we get
+			 * 0 events and there's still timeout left over, we go
+			 * trying again in search of more luck.
+			 */
+			res = ep_send_events(ep, events, maxevents);
+			if (res)
+				return res;
+		}
+
+		if (timed_out)
+			return 0;
+
 		eavail = ep_events_available(ep);
-		if (!eavail)
-			eavail = ep_busy_loop(ep, timed_out);
+		if (eavail)
+			continue;
 
+		eavail = ep_busy_loop(ep, timed_out);
 		if (eavail)
-			goto send_events;
+			continue;
 
 		if (signal_pending(current))
 			return -EINTR;
@@ -1845,19 +1857,7 @@ fetch_events:
 			__remove_wait_queue(&ep->wq, &wait);
 			write_unlock_irq(&ep->lock);
 		}
-	} while (0);
-
-send_events:
-	/*
-	 * Try to transfer events to user space. In case we get 0 events and
-	 * there's still timeout left over, we go trying again in search of
-	 * more luck.
-	 */
-	if (eavail &&
-	    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
-		goto fetch_events;
-
-	return res;
+	}
 }
 
 /**
_

Patches currently in -mm which might be from soheil@google.com are


