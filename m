Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725D1C3526F
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 367D323B7E
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgLRWCy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgLRWCy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:02:54 -0500
Date:   Fri, 18 Dec 2020 14:01:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608328918;
        bh=qSDa8QP2U5dSJTYkAegSWxWOc3++/4jOx8KSR6/EGu8=;
        h=From:To:Subject:In-Reply-To:From;
        b=IGjzbuH862sUOmVBLaCQmeSPi5WM8fCFSosbHfJK2nDy0P4Jlw7vA+llKHTYk5SIN
         jvsDNv4PEKZ7n/nWwH1g6UBEPI1gjKPiL0qp2w5Y8DH82WXlk2EmRUGrDD/DDBiVyc
         owqbk3BOWZLUj+kF0m7Va1E9wvd49/HHGIuNLPxU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, edumazet@google.com,
        guantaol@google.com, khazhy@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  [patch 10/78] epoll: simplify and optimize busy loop
 logic
Message-ID: <20201218220157.x9tlaAvwR%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

 fs/eventpoll.c |   40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

--- a/fs/eventpoll.c~epoll-simplify-and-optimize-busy-loop-logic
+++ a/fs/eventpoll.c
@@ -389,19 +389,24 @@ static bool ep_busy_loop_end(void *p, un
  *
  * we must do our busy polling with irqs enabled
  */
-static void ep_busy_loop(struct eventpoll *ep, int nonblock)
+static bool ep_busy_loop(struct eventpoll *ep, int nonblock)
 {
 	unsigned int napi_id = READ_ONCE(ep->napi_id);
 
-	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on())
+	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on()) {
 		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep, false,
 			       BUSY_POLL_BUDGET);
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
@@ -441,12 +446,9 @@ static inline void ep_set_busy_poll_napi
 
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
@@ -1772,21 +1774,13 @@ static int ep_poll(struct eventpoll *ep,
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
