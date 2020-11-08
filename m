Return-Path: <SRS0=LO12=EO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1ECAC55178
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D74C221FA
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604797536;
	bh=KDTNn2Uoj9tnuWbuU8oif43vwrKAsFwQw6zJzEKSrOQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TsJisXundG7VgvjNpjTSOzlwrKuvYMysNilKnpUq16Oosxw6oNFbt83apR8dbsipk
	 YyW6LcOtgohXjcvaUh+23VrnyWPoKjNU24s+JcmuG2gOE74emFGAOVUvgWZb4KO+sg
	 CStSfq2QYot0YE2nIMRXXW9Z1CaSTJC7YE1txlcA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgKHBFg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 20:05:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgKHBFg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 20:05:36 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5A8520885;
        Sun,  8 Nov 2020 01:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604797535;
        bh=KDTNn2Uoj9tnuWbuU8oif43vwrKAsFwQw6zJzEKSrOQ=;
        h=Date:From:To:Subject:From;
        b=OpECgMu5zYOCXdXrSNtVtjbtfODbQhEra1uSAFaFH1JCMvoHD0BdCOFECSQlWM9CF
         lGU9NsN6bT6n4YWTmgzyBXuiDvq/bAMwgNFNrbzo4EfWrCGaiR1by07uQAIPNdJkoz
         uIux95MNBPswR5tYWAHCZSBzzYDGP87Nbx2kN7Ks=
Date:   Sat, 07 Nov 2020 17:05:34 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  + epoll-replace-gotos-with-a-proper-loop.patch added to
 -mm tree
Message-ID: <20201108010534.fB7_puyn7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: replace gotos with a proper loop
has been added to the -mm tree.  Its filename is
     epoll-replace-gotos-with-a-proper-loop.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-replace-gotos-with-a-proper-loop.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-replace-gotos-with-a-proper-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1830,7 +1830,7 @@ static inline struct timespec64 ep_set_m
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res, eavail, timed_out = 0;
+	int res, eavail = 0, timed_out = 0;
 	u64 slack = 0;
 	wait_queue_entry_t wait;
 	ktime_t expires, *to = NULL;
@@ -1856,18 +1856,30 @@ static int ep_poll(struct eventpoll *ep,
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
@@ -1932,19 +1944,7 @@ fetch_events:
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

epoll-check-for-events-when-removing-a-timed-out-thread-from-the-wait-queue.patch
epoll-simplify-signal-handling.patch
epoll-pull-fatal-signal-checks-into-ep_send_events.patch
epoll-move-eavail-next-to-the-list_empty_careful-check.patch
epoll-simplify-and-optimize-busy-loop-logic.patch
epoll-pull-all-code-between-fetch_events-and-send_event-into-the-loop.patch
epoll-replace-gotos-with-a-proper-loop.patch
epoll-eliminate-unnecessary-lock-for-zero-timeout.patch

