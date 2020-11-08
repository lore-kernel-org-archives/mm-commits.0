Return-Path: <SRS0=LO12=EO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AD1C388F9
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 111C6221F7
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604797529;
	bh=PgC2Nxf9FExmQrEesgiaPqoma7UsPNqJxSsOFx4Ub5s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ZMtCVujF3e3uX2lqFBEbEvi24Z0zE81QlZhgXrvrgm8da4rRq5nBsJjvY+5YetPik
	 U4mN5TQrdUHVnpqXrz9o5HV1GDZUvvQi8TjpJDHLDsilyjjAi2rXu9Jf3fqebYWj7x
	 1pKcY3wszcufhiKlbcdvJpDsXZMkQSy0nu4MkrNU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgKHBF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 20:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgKHBF2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 20:05:28 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB7D42151B;
        Sun,  8 Nov 2020 01:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604797528;
        bh=PgC2Nxf9FExmQrEesgiaPqoma7UsPNqJxSsOFx4Ub5s=;
        h=Date:From:To:Subject:From;
        b=oq3Tq2puGOj0cl5Ft+lxxweyVLFskjSJhDBSfTJVfNXr9CeCUMGKNyZF6M5mqv1nQ
         yuXTesUpz1kZs+uktMOwKkM9rzP2zT6ZeI++vC7RvDVAJ1nNkeeE/PvXn5JfYQCxD4
         25bfuPv/V4CFHlV0ANGJsR6N5RhhoPYgLFoq7vsw=
Date:   Sat, 07 Nov 2020 17:05:27 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  +
 epoll-move-eavail-next-to-the-list_empty_careful-check.patch added to -mm
 tree
Message-ID: <20201108010527.gh2pBFToX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: move eavail next to the list_empty_careful check
has been added to the -mm tree.  Its filename is
     epoll-move-eavail-next-to-the-list_empty_careful-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-move-eavail-next-to-the-list_empty_careful-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-move-eavail-next-to-the-list_empty_careful-check.patch

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
Subject: epoll: move eavail next to the list_empty_careful check

This is a no-op change and simply to make the code more coherent.

Link: https://lkml.kernel.org/r/20201106231635.3528496-5-soheil.kdev@gmail.com
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Cc: Guantao Liu <guantaol@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/eventpoll.c~epoll-move-eavail-next-to-the-list_empty_careful-check
+++ a/fs/eventpoll.c
@@ -1913,6 +1913,7 @@ fetch_events:
 		if (!eavail)
 			timed_out = !schedule_hrtimeout_range(to, slack,
 							      HRTIMER_MODE_ABS);
+		__set_current_state(TASK_RUNNING);
 
 		/*
 		 * We were woken up, thus go and try to harvest some events.
@@ -1922,8 +1923,6 @@ fetch_events:
 		eavail = 1;
 	} while (0);
 
-	__set_current_state(TASK_RUNNING);
-
 	if (!list_empty_careful(&wait.entry)) {
 		write_lock_irq(&ep->lock);
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

