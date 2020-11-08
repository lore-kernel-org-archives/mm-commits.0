Return-Path: <SRS0=LO12=EO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A088AC55178
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66945221FA
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604797526;
	bh=MwGZKVXfI5v0c16edSnU9DVh4XEQ+G9+lEe+IXwACJc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=UT9FEPDfaZpvswJDfRG9a+rLhOcxILxwlXoqB9D0okawtNLIC2MwQwxVuUytdPNcp
	 ySgbaqdJF5uz2jO8hbnFBciYuZTKnblHR04Zee20/CjKWtU8++DHB+QOnp2977S0nh
	 t9c5dzthCDTg+xstcCQtXBxbDkuWjw76LTD93znU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgKHBF0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 20:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgKHBF0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 20:05:26 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA8BA20885;
        Sun,  8 Nov 2020 01:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604797525;
        bh=MwGZKVXfI5v0c16edSnU9DVh4XEQ+G9+lEe+IXwACJc=;
        h=Date:From:To:Subject:From;
        b=IBObxSS1hSyEoEWjt3HRiCqa7N1hJm1YtfC58xqZHWdzKzNRjbxzhvar822quFWF7
         SoG9MeJqFHww/RlL0Yjv14gaTo9tBB2im+NyRzayOMlGO0DRRWoIhmW1RvdjSO9Xmy
         EDlhdrTF5zsWlIQL31itQE78DtJv2trQ5wPZz+Sc=
Date:   Sat, 07 Nov 2020 17:05:24 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  +
 epoll-pull-fatal-signal-checks-into-ep_send_events.patch added to -mm tree
Message-ID: <20201108010524.vThITfpII%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: pull fatal signal checks into ep_send_events()
has been added to the -mm tree.  Its filename is
     epoll-pull-fatal-signal-checks-into-ep_send_events.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-pull-fatal-signal-checks-into-ep_send_events.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-pull-fatal-signal-checks-into-ep_send_events.patch

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
Subject: epoll: pull fatal signal checks into ep_send_events()

To simplify the code, pull in checking the fatal signals into
ep_send_events().  ep_send_events() is called only from ep_poll().

Note that, previously, we were always checking fatal events, but it is
checked only if eavail is true.  This should be fine because the goal of
that check is to quickly return from epoll_wait() when there is a pending
fatal signal.

Link: https://lkml.kernel.org/r/20201106231635.3528496-4-soheil.kdev@gmail.com
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Suggested-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Cc: Guantao Liu <guantaol@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/eventpoll.c~epoll-pull-fatal-signal-checks-into-ep_send_events
+++ a/fs/eventpoll.c
@@ -1780,6 +1780,14 @@ static int ep_send_events(struct eventpo
 {
 	struct ep_send_events_data esed;
 
+	/*
+	 * Always short-circuit for fatal signals to allow threads to make a
+	 * timely exit without the chance of finding more events available and
+	 * fetching repeatedly.
+	 */
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
 	esed.maxevents = maxevents;
 	esed.events = events;
 
@@ -1931,15 +1939,6 @@ fetch_events:
 	}
 
 send_events:
-	if (fatal_signal_pending(current)) {
-		/*
-		 * Always short-circuit for fatal signals to allow
-		 * threads to make a timely exit without the chance of
-		 * finding more events available and fetching
-		 * repeatedly.
-		 */
-		return -EINTR;
-	}
 	/*
 	 * Try to transfer events to user space. In case we get 0 events and
 	 * there's still timeout left over, we go trying again in search of
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

