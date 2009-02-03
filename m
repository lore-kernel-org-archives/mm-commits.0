From: akpm@linux-foundation.org
Subject: + epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch added to -mm tree
Date: Tue, 03 Feb 2009 00:15:06 -0800
Message-ID: <200902030815.n138F6dg025276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbZBCIQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 03:16:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, mingo@elte.hu, torvalds@linux-foundation.org, wli@movementarian.org


The patch titled
     epoll keyed wakeups: make sockets use keyed wakeups
has been added to the -mm tree.  Its filename is
     epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch

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
Subject: epoll keyed wakeups: make sockets use keyed wakeups
From: Davide Libenzi <davidel@xmailserver.org>

Add support for event-aware wakeups to the sockets code.  Events are
delivered to the wakeup target, so that epoll can avoid spurious wakeups
for non-interesting events.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: William Lee Irwin III <wli@movementarian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/sock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/core/sock.c~epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups net/core/sock.c
--- a/net/core/sock.c~epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups
+++ a/net/core/sock.c
@@ -1628,7 +1628,7 @@ static void sock_def_error_report(struct
 {
 	read_lock(&sk->sk_callback_lock);
 	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-		wake_up_interruptible(sk->sk_sleep);
+		wake_up_interruptible_poll(sk->sk_sleep, POLLERR);
 	sk_wake_async(sk, SOCK_WAKE_IO, POLL_ERR);
 	read_unlock(&sk->sk_callback_lock);
 }
@@ -1637,7 +1637,7 @@ static void sock_def_readable(struct soc
 {
 	read_lock(&sk->sk_callback_lock);
 	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-		wake_up_interruptible_sync(sk->sk_sleep);
+		wake_up_interruptible_sync_poll(sk->sk_sleep, POLLIN);
 	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	read_unlock(&sk->sk_callback_lock);
 }
@@ -1651,7 +1651,7 @@ static void sock_def_write_space(struct 
 	 */
 	if ((atomic_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf) {
 		if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-			wake_up_interruptible_sync(sk->sk_sleep);
+			wake_up_interruptible_sync_poll(sk->sk_sleep, POLLOUT);
 
 		/* Should agree with poll, otherwise some programs break */
 		if (sock_writeable(sk))
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

