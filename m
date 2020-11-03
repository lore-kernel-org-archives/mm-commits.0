Return-Path: <SRS0=UcEf=EJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BAAC2D0A3
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EA3222226
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604427346;
	bh=uQFylU4FJDz4T7OHlHeErpvWRslJIJXTavtWXepTKDs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RRsN6Eweo1ues9nVOPLzHkZ7DZ6ufsl5HwmbhdBGfHXHP2E+M/8wA4z3E/++CuAz+
	 NTC76R4l1yPCmnfqYUZiM1TPjZ7Re+2NPtbnlLYHZX1pksCajI7Gr8U2oCB0/+blFz
	 iZMyjNyWKbml2tZfHtSOJrCI3IR0UXl2jo/cSW4U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgKCSPp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:15:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbgKCSPp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 13:15:45 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F9D620757;
        Tue,  3 Nov 2020 18:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604427344;
        bh=uQFylU4FJDz4T7OHlHeErpvWRslJIJXTavtWXepTKDs=;
        h=Date:From:To:Subject:From;
        b=jzmRDxJPu8Sew0vVS3/ddCQ5lPU2WiOZ8Eg+x/P/ncjbfQwR8Kr1oRTODE3X1CYIk
         jpJsnK3k4UaM0ZFYqK08Mtl/UA2g6ZUWHNzCtDQKB6QxI/50M4dCpDM3OwvexKT1Rr
         vYbLLENPUYqVEhnF1cR3RcSR0ADMqDg30zZzHC9w=
Date:   Tue, 03 Nov 2020 10:15:43 -0800
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, edumazet@google.com, guantaol@google.com,
        khazhy@google.com, mm-commits@vger.kernel.org, soheil@google.com,
        viro@zeniv.linux.org.uk, willemb@google.com
Subject:  [to-be-updated]
 epoll-check-ep_events_available-upon-timeout.patch removed from -mm tree
Message-ID: <20201103181543.5ZsKK85hR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: check ep_events_available() upon timeout
has been removed from the -mm tree.  Its filename was
     epoll-check-ep_events_available-upon-timeout.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Soheil Hassas Yeganeh <soheil@google.com>
Subject: epoll: check ep_events_available() upon timeout

After abc610e01c66 ("fs/epoll: avoid barrier after an epoll_wait(2)
timeout"), we break out of the ep_poll loop upon timeout, without checking
whether there is any new events available.  Prior to that patch-series we
always called ep_events_available() after exiting the loop.

This can cause races and missed wakeups.  For example, consider the
following scenario reported by Guantao Liu:

Suppose we have an eventfd added using EPOLLET to an epollfd.

Thread 1: Sleeps for just below 5ms and then writes to an eventfd.
Thread 2: Calls epoll_wait with a timeout of 5 ms. If it sees an
          event of the eventfd, it will write back on that fd.
Thread 3: Calls epoll_wait with a negative timeout.

Prior to abc610e01c66, it is guaranteed that Thread 3 will wake up either
by Thread 1 or Thread 2.  After abc610e01c66, Thread 3 can be blocked
indefinitely if Thread 2 sees a timeout right before the write to the
eventfd by Thread 1.  Thread 2 will be woken up from
schedule_hrtimeout_range and, with evail 0, it will not call
ep_send_events().

To fix this issue, while holding the lock, try to remove the thread that
timed out the wait queue and check whether it was woken up or not.

Link: https://lkml.kernel.org/r/20201028180202.952079-1-soheil.kdev@gmail.com
Fixes: abc610e01c66 ("fs/epoll: avoid barrier after an epoll_wait(2) timeout")
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Reported-by: Guantao Liu <guantaol@google.com>
Tested-by: Guantao Liu <guantaol@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/eventpoll.c~epoll-check-ep_events_available-upon-timeout
+++ a/fs/eventpoll.c
@@ -1907,7 +1907,21 @@ fetch_events:
 
 		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
 			timed_out = 1;
-			break;
+			__set_current_state(TASK_RUNNING);
+			/*
+			 * Acquire the lock and try to remove this thread from
+			 * the wait queue. If this thread is not on the wait
+			 * queue, it has woken up after its timeout ended
+			 * before it could re-acquire the lock. In that case,
+			 * try to harvest some events.
+			 */
+			write_lock_irq(&ep->lock);
+			if (!list_empty(&wait.entry))
+				__remove_wait_queue(&ep->wq, &wait);
+			else
+				eavail = 1;
+			write_unlock_irq(&ep->lock);
+			goto send_events;
 		}
 
 		/* We were woken up, thus go and try to harvest some events */
_

Patches currently in -mm which might be from soheil@google.com are

epoll-add-a-selftest-for-epoll-timeout-race.patch

