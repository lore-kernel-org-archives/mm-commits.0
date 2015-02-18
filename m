From: akpm@linux-foundation.org
Subject: [merged] eventfd-dont-take-the-spinlock-in-eventfd_poll.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:43:24 -0800
Message-ID: <54e4eb5c.1dPJgyTkjTg/yY/F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbbBRTnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clm@fb.com, arnd@arndb.de, dan.carpenter@oracle.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     Subject: eventfd: don't take the spinlock in eventfd_poll
has been removed from the -mm tree.  Its filename was
     eventfd-dont-take-the-spinlock-in-eventfd_poll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[arnd@arndb.de: avoid unused variable warning]
[dan.carpenter@oracle.com: type bug in eventfd_poll()]
Signed-off-by: Chris Mason <clm@fb.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/eventfd.c~eventfd-dont-take-the-spinlock-in-eventfd_poll fs/eventfd.c
--- a/fs/eventfd.c~eventfd-dont-take-the-spinlock-in-eventfd_poll
+++ a/fs/eventfd.c
@@ -118,18 +118,18 @@ static unsigned int eventfd_poll(struct
 {
 	struct eventfd_ctx *ctx = file->private_data;
 	unsigned int events = 0;
-	unsigned long flags;
+	u64 count;
 
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

origin.patch
linux-next.patch

