Return-Path: <SRS0=LO12=EO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14347C388F7
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0843221FA
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604797525;
	bh=LDya5FUOCmB0R9EmAbAx/Ayb9ScZWIdXifC+W/Rj3zc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2iVqcdnRRnF7BgQv1aFzTpabBJJ+bal/6MsDS8OxP5yaElShcU1HaCLsPc9hmwEwc
	 JxXfaPzh9wsNIR6XfXZSJvmo1/lvfpXTmVrOlv+f6De4MLIf17etRmc0s2YazShQBV
	 T5BYi0wyqYkzRp8BceUUWnQBmcgPDhG7hgmPp9Vg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgKHBFZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 20:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKHBFZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 20:05:25 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2B952151B;
        Sun,  8 Nov 2020 01:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604797523;
        bh=LDya5FUOCmB0R9EmAbAx/Ayb9ScZWIdXifC+W/Rj3zc=;
        h=Date:From:To:Subject:From;
        b=YWORpEKZQAO29WKUDNJUDIonZ+uDBxcooyf+Sg3IcdQ+fBMw5JufngveggemXA4eu
         cb4Q6FdgfP7DpFJLRqsDeXhevxmX1lnxCon3RCajUUBUwPN91jEMqYzBvcdjBn7X+0
         /DzHY6OOF+L/7vv/c7t4Y3cSq9SQg1LmTRXPH0eo=
Date:   Sat, 07 Nov 2020 17:05:22 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  + epoll-simplify-signal-handling.patch added to -mm tree
Message-ID: <20201108010522.Alj0MKHOM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: simplify signal handling
has been added to the -mm tree.  Its filename is
     epoll-simplify-signal-handling.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-simplify-signal-handling.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-simplify-signal-handling.patch

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
@@ -1818,7 +1818,7 @@ static inline struct timespec64 ep_set_m
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res = 0, eavail, timed_out = 0;
+	int res, eavail, timed_out = 0;
 	u64 slack = 0;
 	wait_queue_entry_t wait;
 	ktime_t expires, *to = NULL;
@@ -1865,6 +1865,9 @@ fetch_events:
 	ep_reset_busy_poll_napi_id(ep);
 
 	do {
+		if (signal_pending(current))
+			return -EINTR;
+
 		/*
 		 * Internally init_wait() uses autoremove_wake_function(),
 		 * thus wait entry is removed from the wait queue on each
@@ -1894,15 +1897,12 @@ fetch_events:
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
 
@@ -1938,14 +1938,14 @@ send_events:
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

epoll-check-for-events-when-removing-a-timed-out-thread-from-the-wait-queue.patch
epoll-simplify-signal-handling.patch
epoll-pull-fatal-signal-checks-into-ep_send_events.patch
epoll-move-eavail-next-to-the-list_empty_careful-check.patch
epoll-simplify-and-optimize-busy-loop-logic.patch
epoll-pull-all-code-between-fetch_events-and-send_event-into-the-loop.patch
epoll-replace-gotos-with-a-proper-loop.patch
epoll-eliminate-unnecessary-lock-for-zero-timeout.patch

