From: akpm@linux-foundation.org
Subject: [merged] epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:54 -0700
Message-ID: <200904011840.n31IesDp009171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbZDATba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:31:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, mingo@elte.hu, torvalds@linux-foundation.org, wli@movementarian.org, mm-commits@vger.kernel.org


The patch titled
     epoll keyed wakeups: make eventfd use keyed wakeups
has been removed from the -mm tree.  Its filename was
     epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll keyed wakeups: make eventfd use keyed wakeups
From: Davide Libenzi <davidel@xmailserver.org>

Introduce keyed event wakeups inside the eventfd code.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: William Lee Irwin III <wli@movementarian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/eventfd.c~epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups fs/eventfd.c
--- a/fs/eventfd.c~epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups
+++ a/fs/eventfd.c
@@ -51,7 +51,7 @@ int eventfd_signal(struct file *file, in
 		n = (int) (ULLONG_MAX - ctx->count);
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
-		wake_up_locked(&ctx->wqh);
+		wake_up_locked_poll(&ctx->wqh, POLLIN);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
@@ -120,7 +120,7 @@ static ssize_t eventfd_read(struct file 
 		ucnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
 		ctx->count -= ucnt;
 		if (waitqueue_active(&ctx->wqh))
-			wake_up_locked(&ctx->wqh);
+			wake_up_locked_poll(&ctx->wqh, POLLOUT);
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 	if (res > 0 && put_user(ucnt, (__u64 __user *) buf))
@@ -169,7 +169,7 @@ static ssize_t eventfd_write(struct file
 	if (likely(res > 0)) {
 		ctx->count += ucnt;
 		if (waitqueue_active(&ctx->wqh))
-			wake_up_locked(&ctx->wqh);
+			wake_up_locked_poll(&ctx->wqh, POLLIN);
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
linux-next.patch

