From: akpm@linux-foundation.org
Subject: + epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch added to -mm tree
Date: Tue, 03 Feb 2009 00:15:10 -0800
Message-ID: <200902030815.n138FACu025458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655AbZBCIQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 03:16:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, mingo@elte.hu, torvalds@linux-foundation.org, wli@movementarian.org


The patch titled
     epoll keyed wakeups: make eventfd use keyed wakeups
has been added to the -mm tree.  Its filename is
     epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -50,7 +50,7 @@ int eventfd_signal(struct file *file, in
 		n = (int) (ULLONG_MAX - ctx->count);
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
-		wake_up_locked(&ctx->wqh);
+		wake_up_locked_poll(&ctx->wqh, POLLIN);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
@@ -120,7 +120,7 @@ static ssize_t eventfd_read(struct file 
 	if (res > 0) {
 		ctx->count = 0;
 		if (waitqueue_active(&ctx->wqh))
-			wake_up_locked(&ctx->wqh);
+			wake_up_locked_poll(&ctx->wqh, POLLOUT);
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 	if (res > 0 && put_user(ucnt, (__u64 __user *) buf))
@@ -169,7 +169,7 @@ static ssize_t eventfd_write(struct file
 	if (res > 0) {
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
epoll-fix-own-poll.patch
epoll-fix-epolls-own-poll-update.patch
epoll-remove-debugging-code.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch

