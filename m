Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66B5C3527A
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8933323B7E
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgLRWC6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:02:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgLRWC6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:02:58 -0500
Date:   Fri, 18 Dec 2020 14:02:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608328924;
        bh=1wsdQJcMxaNSD6uONJ2u9GA0UyVe8mkcshgkBarFMVE=;
        h=From:To:Subject:In-Reply-To:From;
        b=daFverbZ1W7xmDt6cjN5oNNd7axr9utjoDEd91iON7Y0Z1IB0Y7EBtmR0taD8YuJg
         GXb4O9FO6bNub5PhkfhUbV4oO9a9Od24xtfIQx/ur1dkx43GjckkDkYeLRyvCJjqAb
         fBbqgmNSreTKn8pi2diQxo98YgBmnaCU0Bi22Bj0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, edumazet@google.com,
        guantaol@google.com, khazhy@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  [patch 12/78] epoll: replace gotos with a proper loop
Message-ID: <20201218220203.uBS-rg8Is%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
