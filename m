From: akpm@linux-foundation.org
Subject: [folded] epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups-update.patch removed from -mm tree
Date: Tue, 31 Mar 2009 15:04:39 -0700
Message-ID: <200903312204.n2VM4eXd016817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756659AbZCaWHA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 18:07:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, Valdis.Kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups update
has been removed from the -mm tree.  Its filename was
     epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups-update.patch

This patch was dropped because it was folded into epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups update
From: Davide Libenzi <davidel@xmailserver.org>

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/sock.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN net/core/sock.c~epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups-update net/core/sock.c
--- a/net/core/sock.c~epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups-update
+++ a/net/core/sock.c
@@ -1687,7 +1687,8 @@ static void sock_def_readable(struct soc
 {
 	read_lock(&sk->sk_callback_lock);
 	if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-		wake_up_interruptible_sync_poll(sk->sk_sleep, POLLIN);
+		wake_up_interruptible_sync_poll(sk->sk_sleep, POLLIN |
+						POLLRDNORM | POLLRDBAND);
 	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	read_unlock(&sk->sk_callback_lock);
 }
@@ -1701,7 +1702,8 @@ static void sock_def_write_space(struct 
 	 */
 	if ((atomic_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf) {
 		if (sk->sk_sleep && waitqueue_active(sk->sk_sleep))
-			wake_up_interruptible_sync_poll(sk->sk_sleep, POLLOUT);
+			wake_up_interruptible_sync_poll(sk->sk_sleep, POLLOUT |
+						POLLWRNORM | POLLWRBAND);
 
 		/* Should agree with poll, otherwise some programs break */
 		if (sock_writeable(sk))
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
epoll-fix-own-poll.patch
epoll-fix-epolls-own-poll-update.patch
epoll-remove-debugging-code.patch
epoll-dont-use-current-in-irq-context.patch
epoll-remember-the-event-if-epoll_wait-returns-efault.patch
epoll-remove-unnecessary-xchg.patch
epoll-clean-up-ep_modify.patch
epoll-use-real-type-instead-of-void.patch
eventfd-improve-support-for-semaphore-like-behavior.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups-update.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch
linux-next.patch

