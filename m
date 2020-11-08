Return-Path: <SRS0=LO12=EO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C019C388F9
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5E992151B
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604797522;
	bh=h20YPr/A1pSO4PM1L9TGP2YCgLSZ1UwEip/KntDcn+8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Fothwtn7r8ItLC4M8sCnjzDFejyuzW1tZKmAw6jw8AbJNFvg6iMZfgW/6oFURaawm
	 Ijx5hPrxBX93Jz2E25GcPfl3huG7DvbcHyzEVu4SKxHoqmTwyCTsVENi0chv9X80/1
	 zA6PSgyBttPYzNwPL7dfvvquHg50jZnh7jUZ8KV0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgKHBFV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 20:05:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKHBFV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 20:05:21 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45DAB20885;
        Sun,  8 Nov 2020 01:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604797520;
        bh=h20YPr/A1pSO4PM1L9TGP2YCgLSZ1UwEip/KntDcn+8=;
        h=Date:From:To:Subject:From;
        b=TfFXMJsNmgE+jSoYFo2Gw54PDpjh2zUXAZwzkr4eXbVtYWI3ApEqXBVfdM4Fik5MY
         4z7ijKKkqu4GunTkgy6MXYgTaGErWvM6W12Oi5pzA6gW1U/fYVNGoRG9nqR0YFR2ZG
         v9z0AFMl9yFrNMywzPgfra4+m0rlxwcrG1QuW4Fc=
Date:   Sat, 07 Nov 2020 17:05:19 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, guantaol@google.com, khazhy@google.com,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, willemb@google.com
Subject:  +
 =?US-ASCII?Q?epoll-check-for-events-when-removing-a-timed-out-thread-f?=
 =?US-ASCII?Q?rom-the-wait-queue.patch?= added to -mm tree
Message-ID: <20201108010519.KEu9nd-mB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: check for events when removing a timed out thread from the wait queue
has been added to the -mm tree.  Its filename is
     epoll-check-for-events-when-removing-a-timed-out-thread-from-the-wait-queue.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-check-for-events-when-removing-a-timed-out-thread-from-the-wait-queue.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-check-for-events-when-removing-a-timed-out-thread-from-the-wait-queue.patch

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
Subject: epoll: check for events when removing a timed out thread from the wait queue

Patch series "simplify ep_poll".

This patch series is a followup based on the suggestions and feedback by
Linus:
https://lkml.kernel.org/r/CAHk-=wizk=OxUyQPbO8MS41w2Pag1kniUV5WdD5qWL-gq1kjDA@mail.gmail.com

The first patch in the series is a fix for the epoll race in presence of
timeouts, so that it can be cleanly backported to all affected stable
kernels.

The rest of the patch series simplify the ep_poll() implementation.  Some
of these simplifications result in minor performance enhancements as well.
We have kept these changes under self tests and internal benchmarks for a
few days, and there are minor (1-2%) performance enhancements as a result.


This patch (of 8):

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

To fix this issue:
1) Simplify the timed_out case as suggested by Linus.
2) while holding the lock, recheck whether the thread was woken up
   after its time out has reached.

Note that (2) is different from Linus' original suggestion: It do not set
"eavail = ep_events_available(ep)" to avoid unnecessary contention (when
there are too many timed-out threads and a small number of events), as
well as races mentioned in the discussion thread.

This is the first patch in the series so that the backport to stable
releases is straightforward.

Link: https://lkml.kernel.org/r/20201106231635.3528496-1-soheil.kdev@gmail.com
Link: https://lkml.kernel.org/r/CAHk-=wizk=OxUyQPbO8MS41w2Pag1kniUV5WdD5qWL-gq1kjDA@mail.gmail.com
Link: https://lkml.kernel.org/r/20201106231635.3528496-2-soheil.kdev@gmail.com
Fixes: abc610e01c66 ("fs/epoll: avoid barrier after an epoll_wait(2) timeout")
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Tested-by: Guantao Liu <guantaol@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Guantao Liu <guantaol@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/fs/eventpoll.c~epoll-check-for-events-when-removing-a-timed-out-thread-from-the-wait-queue
+++ a/fs/eventpoll.c
@@ -1902,23 +1902,30 @@ fetch_events:
 		}
 		write_unlock_irq(&ep->lock);
 
-		if (eavail || res)
-			break;
-
-		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
-			timed_out = 1;
-			break;
-		}
-
-		/* We were woken up, thus go and try to harvest some events */
+		if (!eavail && !res)
+			timed_out = !schedule_hrtimeout_range(to, slack,
+							      HRTIMER_MODE_ABS);
+
+		/*
+		 * We were woken up, thus go and try to harvest some events.
+		 * If timed out and still on the wait queue, recheck eavail
+		 * carefully under lock, below.
+		 */
 		eavail = 1;
-
 	} while (0);
 
 	__set_current_state(TASK_RUNNING);
 
 	if (!list_empty_careful(&wait.entry)) {
 		write_lock_irq(&ep->lock);
+		/*
+		 * If the thread timed out and is not on the wait queue, it
+		 * means that the thread was woken up after its timeout expired
+		 * before it could reacquire the lock. Thus, when wait.entry is
+		 * empty, it needs to harvest events.
+		 */
+		if (timed_out)
+			eavail = list_empty(&wait.entry);
 		__remove_wait_queue(&ep->wq, &wait);
 		write_unlock_irq(&ep->lock);
 	}
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

