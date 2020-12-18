Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28003C3526E
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E378423B7E
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgLRWCu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:02:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgLRWCu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:02:50 -0500
Date:   Fri, 18 Dec 2020 14:01:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608328912;
        bh=1O+6iTrYDDJFJRw14JQJikgb7q+y5IwY4bCQXmmFejE=;
        h=From:To:Subject:In-Reply-To:From;
        b=aOC3QcCS46ZfxvPXPOUhrQPnRtWqSZka/LOoFtIM4ysmtWiO3CDcpWoP5FbCwoOyT
         8P9vWrC+2Dn8f3wq4/8qPZp0tVnpnpXEWE3ubyO5flzcdlprpHEhTMEj5YRgukYZ4U
         Cnq1clouMRWOB8AO+Cyb6MV/KCXu5BBFeGPGqg9U=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, edumazet@google.com,
        guantaol@google.com, khazhy@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  [patch 08/78] epoll: pull fatal signal checks into
 ep_send_events()
Message-ID: <20201218220151.ncBs4CLZW%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1625,6 +1625,14 @@ static int ep_send_events(struct eventpo
 	poll_table pt;
 	int res = 0;
 
+	/*
+	 * Always short-circuit for fatal signals to allow threads to make a
+	 * timely exit without the chance of finding more events available and
+	 * fetching repeatedly.
+	 */
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
 	init_poll_funcptr(&pt, NULL);
 
 	mutex_lock(&ep->mtx);
@@ -1846,15 +1854,6 @@ fetch_events:
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
