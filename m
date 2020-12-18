Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397F4C3526D
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E1A23BAB
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgLRWCx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgLRWCx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:02:53 -0500
Date:   Fri, 18 Dec 2020 14:01:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608328915;
        bh=j3qlxyfozMkL4HzesaEpJH5bOTQCSc6uzzDERBusoBY=;
        h=From:To:Subject:In-Reply-To:From;
        b=F4rQzoNIllnhzLNmG17fKoSp1cM2BkvZrXmGEPIzvVRpZWRWZdhGgeRAgCB4tSbP4
         PTumCTrJJAllmJCi2Zlf9PMhjY1yxyinzi4z7ZFI29utzYo4sqsQv1fj0SIbTklz58
         i0fQv7wB+qoKin79WvUARzzUB8Hh5yIMfcBoZbP0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, edumazet@google.com,
        guantaol@google.com, khazhy@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  [patch 09/78] epoll: move eavail next to the
 list_empty_careful check
Message-ID: <20201218220154.x7I97m8oa%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1828,6 +1828,7 @@ fetch_events:
 		if (!eavail)
 			timed_out = !schedule_hrtimeout_range(to, slack,
 							      HRTIMER_MODE_ABS);
+		__set_current_state(TASK_RUNNING);
 
 		/*
 		 * We were woken up, thus go and try to harvest some events.
@@ -1837,8 +1838,6 @@ fetch_events:
 		eavail = 1;
 	} while (0);
 
-	__set_current_state(TASK_RUNNING);
-
 	if (!list_empty_careful(&wait.entry)) {
 		write_lock_irq(&ep->lock);
 		/*
_
