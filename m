Return-Path: <SRS0=LO12=EO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96E7C388F9
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3759221FA
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604797535;
	bh=tZARXytZ/GuPxXxW0EeTJJS+17BZYS6YURXU7dtXLcA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CwgtjKD8cvrAoe2tOPipBSe0fryTyKfBVoJL3BXTRy+pyRuMYeSbVKcDkJR5S11uI
	 kcFRMTqOC94yeIGaeFAw3sQyU2H2SEBjtCLJmTdvIw/jg8XFihQDD7CIcjEHeDnndF
	 Q+ja1MScH571vHkvKmVXJ5MaIZXjNe3puQdZmXvc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgKHBFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 20:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgKHBFf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 20:05:35 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B9A2151B;
        Sun,  8 Nov 2020 01:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604797533;
        bh=tZARXytZ/GuPxXxW0EeTJJS+17BZYS6YURXU7dtXLcA=;
        h=Date:From:To:Subject:From;
        b=R9RXBz1EhrZMuFzU19zH3lKsX6lb6obhGEwxsYGEZur2PMVt3doiEG+n7j5CovbDc
         n2ll5WvdcdRJHCtF2DKz3AGPz2jsrOk4XhtrNfRG/RX+DXkvjz8yNOhSdWrY0iUMZz
         DcQGFoZt+qBXa80/DzjYaHoluRfOj/f0rOjOAEjU=
Date:   Sat, 07 Nov 2020 17:05:32 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  +
 epoll-pull-all-code-between-fetch_events-and-send_event-into-the-loop.patch
 added to -mm tree
Message-ID: <20201108010532.9pzGtQbpd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: pull all code between fetch_events and send_event into the loop
has been added to the -mm tree.  Its filename is
     epoll-pull-all-code-between-fetch_events-and-send_event-into-the-loop.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-pull-all-code-between-fetch_events-and-send_event-into-the-loop.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-pull-all-code-between-fetch_events-and-send_event-into-the-loop.patch

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
@@ -1861,14 +1861,14 @@ static int ep_poll(struct eventpoll *ep,
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
 
@@ -1917,21 +1917,22 @@ fetch_events:
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

epoll-check-for-events-when-removing-a-timed-out-thread-from-the-wait-queue.patch
epoll-simplify-signal-handling.patch
epoll-pull-fatal-signal-checks-into-ep_send_events.patch
epoll-move-eavail-next-to-the-list_empty_careful-check.patch
epoll-simplify-and-optimize-busy-loop-logic.patch
epoll-pull-all-code-between-fetch_events-and-send_event-into-the-loop.patch
epoll-replace-gotos-with-a-proper-loop.patch
epoll-eliminate-unnecessary-lock-for-zero-timeout.patch

