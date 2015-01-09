From: akpm@linux-foundation.org
Subject: + eventfd-dont-take-the-spinlock-in-eventfd_poll.patch added to
 -mm tree
Date: Fri, 09 Jan 2015 15:26:41 -0800
Message-ID: <54b063b1.tTCx/pApqIIpts91%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbbAIX0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 18:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clm@fb.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     Subject: eventfd: don't take the spinlock in eventfd_poll
has been added to the -mm tree.  Its filename is
     eventfd-dont-take-the-spinlock-in-eventfd_poll.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/eventfd-dont-take-the-spinlock-in-eventfd_poll.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/eventfd-dont-take-the-spinlock-in-eventfd_poll.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Mason <clm@fb.com>
Subject: eventfd: don't take the spinlock in eventfd_poll

The spinlock in eventfd_poll is trying to protect the count of events so
it can decide if it should return POLLIN, POLLERR, or POLLOUT.  But,
because of the way we drop the lock after calling poll_wait, and drop it
again before returning, we have the same pile of races with the lock as we
do with a single read of ctx->count().

This replaces the lock with a read barrier and single read.

eventfd_write does a single bump of ctx->count, so this should not add new
races with adding events.  eventfd_read is similar, it will do a single
decrement with the lock held, and so we're making the race with concurrent
readers slightly larger.

This spinlock is the top CPU user in kernel code during one of our
workloads.  Removing it gives us a ~2% boost.

Signed-off-by: Chris Mason <clm@fb.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/eventfd.c~eventfd-dont-take-the-spinlock-in-eventfd_poll fs/eventfd.c
--- a/fs/eventfd.c~eventfd-dont-take-the-spinlock-in-eventfd_poll
+++ a/fs/eventfd.c
@@ -119,17 +119,18 @@ static unsigned int eventfd_poll(struct
 	struct eventfd_ctx *ctx = file->private_data;
 	unsigned int events = 0;
 	unsigned long flags;
+	unsigned int count;
 
 	poll_wait(file, &ctx->wqh, wait);
+	smp_rmb();
+	count = ctx->count;
 
-	spin_lock_irqsave(&ctx->wqh.lock, flags);
-	if (ctx->count > 0)
+	if (count > 0)
 		events |= POLLIN;
-	if (ctx->count == ULLONG_MAX)
+	if (count == ULLONG_MAX)
 		events |= POLLERR;
-	if (ULLONG_MAX - 1 > ctx->count)
+	if (ULLONG_MAX - 1 > count)
 		events |= POLLOUT;
-	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return events;
 }
_

Patches currently in -mm which might be from clm@fb.com are

eventfd-dont-take-the-spinlock-in-eventfd_poll.patch

