From: akpm@linux-foundation.org
Subject: + eventfd-document-lockless-access-in-eventfd_poll.patch added to -mm tree
Date: Fri, 04 Mar 2016 13:40:15 -0800
Message-ID: <56da00bf.878cnoXg5ujdvJDX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759058AbcCDVkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 16:40:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbonzini@redhat.com, aarcange@redhat.com, clm@fb.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     Subject: eventfd: document lockless access in eventfd_poll
has been added to the -mm tree.  Its filename is
     eventfd-document-lockless-access-in-eventfd_poll.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/eventfd-document-lockless-access-in-eventfd_poll.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/eventfd-document-lockless-access-in-eventfd_poll.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: eventfd: document lockless access in eventfd_poll

Since commit e22553e2a25e ("eventfd: don't take the spinlock in
eventfd_poll", 2015-02-17), eventfd is reading ctx->count outside
ctx->wqh.lock.

However, things aren't as simple as the read barrier in eventfd_poll would
suggest.  In fact, the read barrier, besides lacking a comment, is not
paired in any obvious manner with another read barrier, and it is
pointless because it is sitting between a write (deep in poll_wait) and
the read of ctx->count.  The read barrier is acting just as a compiler
barrier, for which we can use READ_ONCE instead.  This is what the code
change in this patch does.

The documentation change is just as important, however.  The question,
posed by Andrea Arcangeli, is then why the thing is safe on architectures
where spin_unlock does not imply a store-load memory barrier.  The answer
is that it's safe because writes of ctx->count use the same lock as
poll_wait, and hence an acquire barrier implicit in poll_wait provides the
necessary synchronization between eventfd_poll and callers of
wake_up_locked_poll.  This is sort of mentioned in the commit message with
respect to eventfd_ctx_read ("eventfd_read is similar, it will do a single
decrement with the lock held") but it applies to all other callers too. 
It's tricky enough that it should be documented in the code.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Mason <clm@fb.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff -puN fs/eventfd.c~eventfd-document-lockless-access-in-eventfd_poll fs/eventfd.c
--- a/fs/eventfd.c~eventfd-document-lockless-access-in-eventfd_poll
+++ a/fs/eventfd.c
@@ -121,8 +121,46 @@ static unsigned int eventfd_poll(struct
 	u64 count;
 
 	poll_wait(file, &ctx->wqh, wait);
-	smp_rmb();
-	count = ctx->count;
+
+	/*
+	 * All writes to ctx->count occur within ctx->wqh.lock.  This read
+	 * can be done outside ctx->wqh.lock because we know that poll_wait
+	 * takes that lock (through add_wait_queue) if our caller will sleep.
+	 *
+	 * The read _can_ therefore seep into add_wait_queue's critical
+	 * section, but cannot move above it!  add_wait_queue's spin_lock acts
+	 * as an acquire barrier and ensures that the read be ordered properly
+	 * against the writes.  The following CAN happen and is safe:
+	 *
+	 *     poll                               write
+	 *     -----------------                  ------------
+	 *     lock ctx->wqh.lock (in poll_wait)
+	 *     count = ctx->count
+	 *     __add_wait_queue
+	 *     unlock ctx->wqh.lock
+	 *                                        lock ctx->qwh.lock
+	 *                                        ctx->count += n
+	 *                                        if (waitqueue_active)
+	 *                                          wake_up_locked_poll
+	 *                                        unlock ctx->qwh.lock
+	 *     eventfd_poll returns 0
+	 *
+	 * but the following, which would miss a wakeup, cannot happen:
+	 *
+	 *     poll                               write
+	 *     -----------------                  ------------
+	 *     count = ctx->count (INVALID!)
+	 *                                        lock ctx->qwh.lock
+	 *                                        ctx->count += n
+	 *                                        **waitqueue_active is false**
+	 *                                        **no wake_up_locked_poll!**
+	 *                                        unlock ctx->qwh.lock
+	 *     lock ctx->wqh.lock (in poll_wait)
+	 *     __add_wait_queue
+	 *     unlock ctx->wqh.lock
+	 *     eventfd_poll returns 0
+	 */
+	count = READ_ONCE(ctx->count);
 
 	if (count > 0)
 		events |= POLLIN;
_

Patches currently in -mm which might be from pbonzini@redhat.com are

eventfd-document-lockless-access-in-eventfd_poll.patch

