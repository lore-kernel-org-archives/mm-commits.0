Return-Path: <SRS0=LO12=EO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46291C388F7
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B85C221FA
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604797531;
	bh=Faq2lScqbsA4mMbuFZIrtujw7UpeFTr5tQY4FPVDRvc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xbellLj+uqxD8RLH73NabM1fQVQSSuUSrEP7SexN4VP697xuuJCslvSPighFb/TN8
	 CtgoUd+/Etn3EtSTZAZO/kCCdfecxIsI+eG6BUuRZMrnxE7pk4QclBr76DORhOtTrY
	 3XCL9n6hLJFleDKMGZ3ud0aApdt74bKg0C8/GtqM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgKHBFa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 20:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgKHBFa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 20:05:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB0E920885;
        Sun,  8 Nov 2020 01:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604797530;
        bh=Faq2lScqbsA4mMbuFZIrtujw7UpeFTr5tQY4FPVDRvc=;
        h=Date:From:To:Subject:From;
        b=E501y4CbWrobJX/BotjBWVQROGkSqhgmjXEAR2D6/OZu2xRSP71La/c/8rFmF8G5D
         sIpmdHc5DOg2SQvK3b7yVpQ0QTvYqPXJ/aMoYW1sKTpMuF3aVr+2HcY2XesDGbcpnh
         3eur99Q7N4snI1WOVGfhJdmHd7jPu8hYRCscD1s4=
Date:   Sat, 07 Nov 2020 17:05:29 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  + epoll-simplify-and-optimize-busy-loop-logic.patch added
 to -mm tree
Message-ID: <20201108010529.oGBlprpzm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: simplify and optimize busy loop logic
has been added to the -mm tree.  Its filename is
     epoll-simplify-and-optimize-busy-loop-logic.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-simplify-and-optimize-busy-loop-logic.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-simplify-and-optimize-busy-loop-logic.patch

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
Subject: epoll: simplify and optimize busy loop logic

ep_events_available() is called multiple times around the busy loop logic,
even though the logic is generally not used.  ep_reset_busy_poll_napi_id()
is similarly always called, even when busy loop is not used.

Eliminate ep_reset_busy_poll_napi_id() and inline it inside
ep_busy_loop().  Make ep_busy_loop() return whether there are any events
available after the busy loop.  This will eliminate unnecessary loads and
branches, and simplifies the loop.

Link: https://lkml.kernel.org/r/20201106231635.3528496-6-soheil.kdev@gmail.com
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Cc: Guantao Liu <guantaol@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

--- a/fs/eventpoll.c~epoll-simplify-and-optimize-busy-loop-logic
+++ a/fs/eventpoll.c
@@ -391,19 +391,26 @@ static bool ep_busy_loop_end(void *p, un
  * busy loop will return if need_resched or ep_events_available.
  *
  * we must do our busy polling with irqs enabled
+ *
+ * Returns whether new events are available after a successful busy loop.
  */
-static void ep_busy_loop(struct eventpoll *ep, int nonblock)
+static bool ep_busy_loop(struct eventpoll *ep, int nonblock)
 {
 	unsigned int napi_id = READ_ONCE(ep->napi_id);
 
-	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on())
+	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on()) {
 		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep);
-}
-
-static inline void ep_reset_busy_poll_napi_id(struct eventpoll *ep)
-{
-	if (ep->napi_id)
+		if (ep_events_available(ep))
+			return true;
+		/*
+		 * Busy poll timed out.  Drop NAPI ID for now, we can add
+		 * it back in when we have moved a socket with a valid NAPI
+		 * ID onto the ready list.
+		 */
 		ep->napi_id = 0;
+		return false;
+	}
+	return false;
 }
 
 /*
@@ -444,12 +451,9 @@ static inline void ep_set_busy_poll_napi
 
 #else
 
-static inline void ep_busy_loop(struct eventpoll *ep, int nonblock)
-{
-}
-
-static inline void ep_reset_busy_poll_napi_id(struct eventpoll *ep)
+static inline bool ep_busy_loop(struct eventpoll *ep, int nonblock)
 {
+	return false;
 }
 
 static inline void ep_set_busy_poll_napi_id(struct epitem *epi)
@@ -1857,21 +1861,13 @@ static int ep_poll(struct eventpoll *ep,
 	}
 
 fetch_events:
-
-	if (!ep_events_available(ep))
-		ep_busy_loop(ep, timed_out);
-
 	eavail = ep_events_available(ep);
+	if (!eavail)
+		eavail = ep_busy_loop(ep, timed_out);
+
 	if (eavail)
 		goto send_events;
 
-	/*
-	 * Busy poll timed out.  Drop NAPI ID for now, we can add
-	 * it back in when we have moved a socket with a valid NAPI
-	 * ID onto the ready list.
-	 */
-	ep_reset_busy_poll_napi_id(ep);
-
 	do {
 		if (signal_pending(current))
 			return -EINTR;
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

