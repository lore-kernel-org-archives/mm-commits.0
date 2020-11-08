Return-Path: <SRS0=LO12=EO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AEAC388F9
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81DDC2151B
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604797538;
	bh=gfphuj/Qy7VFML3Q0w+wAdsVsKZQKVLGF54gLBXBw7Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=c7tmmHoDNEQCgC1SyhMfM4thTFVgAemSj00IITnrYLRkIrbJMnIIH/FAG9jU6n/lK
	 NTjLJLivAm2/97shjq3i7fpb0NnSH7CfZnHd3i63nzlTB0WhmEY6XTrTJ5r+nd4eCx
	 CD8zWXE3Wv4PZUOjDrrDi5epznW4BYfaqmn4PBFg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgKHBFi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 20:05:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgKHBFi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 20:05:38 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDDF4221F7;
        Sun,  8 Nov 2020 01:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604797537;
        bh=gfphuj/Qy7VFML3Q0w+wAdsVsKZQKVLGF54gLBXBw7Q=;
        h=Date:From:To:Subject:From;
        b=NHpv7Zakif/d1OUE0zHPXhaDSasV/VbiSDX8QelcgxUyvAv2IRIOwoqiOS5My8Y9y
         ZgF6CXknw/40ZHDhIMXjPK1SzNDsLjXQw1brhUhSednUDi6ZKWlVNwMOUVJdMI55R4
         fcKnk+Ald39gwV0bALY7k+0iFPge4JI4JUht6X1o=
Date:   Sat, 07 Nov 2020 17:05:36 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  + epoll-eliminate-unnecessary-lock-for-zero-timeout.patch
 added to -mm tree
Message-ID: <20201108010536.7P0HaL0OX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: eliminate unnecessary lock for zero timeout
has been added to the -mm tree.  Its filename is
     epoll-eliminate-unnecessary-lock-for-zero-timeout.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-eliminate-unnecessary-lock-for-zero-timeout.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-eliminate-unnecessary-lock-for-zero-timeout.patch

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
@@ -1830,7 +1830,7 @@ static inline struct timespec64 ep_set_m
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res, eavail = 0, timed_out = 0;
+	int res, eavail, timed_out = 0;
 	u64 slack = 0;
 	wait_queue_entry_t wait;
 	ktime_t expires, *to = NULL;
@@ -1846,18 +1846,21 @@ static int ep_poll(struct eventpoll *ep,
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
@@ -1873,10 +1876,6 @@ static int ep_poll(struct eventpoll *ep,
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

Patches currently in -mm which might be from soheil@google.com are

epoll-check-for-events-when-removing-a-timed-out-thread-from-the-wait-queue.patch
epoll-simplify-signal-handling.patch
epoll-pull-fatal-signal-checks-into-ep_send_events.patch
epoll-move-eavail-next-to-the-list_empty_careful-check.patch
epoll-simplify-and-optimize-busy-loop-logic.patch
epoll-pull-all-code-between-fetch_events-and-send_event-into-the-loop.patch
epoll-replace-gotos-with-a-proper-loop.patch
epoll-eliminate-unnecessary-lock-for-zero-timeout.patch

