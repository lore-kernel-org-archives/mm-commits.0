From: akpm@linux-foundation.org
Subject: [merged] epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:50 -0700
Message-ID: <200904011840.n31IeoDv009165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933633AbZDASqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, mingo@elte.hu, torvalds@linux-foundation.org, wli@movementarian.org, mm-commits@vger.kernel.org


The patch titled
     epoll keyed wakeups: make sockets use keyed wakeups
has been removed from the -mm tree.  Its filename was
     epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 net/core/sock.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN net/core/sock.c~epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups net/core/sock.c
--- a/net/core/sock.c~epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups
+++ a/net/core/sock.c
@@ -1677,7 +1677,7 @@ static void sock_def_error_report(struct
 {
 	read_lock(&sk->sk_callback_lock);
 	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-		wake_up_interruptible(sk->sk_sleep);
+		wake_up_interruptible_poll(sk->sk_sleep, POLLERR);
 	sk_wake_async(sk, SOCK_WAKE_IO, POLL_ERR);
 	read_unlock(&sk->sk_callback_lock);
 }
@@ -1686,7 +1686,8 @@ static void sock_def_readable(struct soc
 {
 	read_lock(&sk->sk_callback_lock);
 	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-		wake_up_interruptible_sync(sk->sk_sleep);
+		wake_up_interruptible_sync_poll(sk->sk_sleep, POLLIN |
+						POLLRDNORM | POLLRDBAND);
 	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	read_unlock(&sk->sk_callback_lock);
 }
@@ -1700,7 +1701,8 @@ static void sock_def_write_space(struct 
 	 */
 	if ((atomic_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf) {
 		if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-			wake_up_interruptible_sync(sk->sk_sleep);
+			wake_up_interruptible_sync_poll(sk->sk_sleep, POLLOUT |
+						POLLWRNORM | POLLWRBAND);
 
 		/* Should agree with poll, otherwise some programs break */
 		if (sock_writeable(sk))
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
linux-next.patch

