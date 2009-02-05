From: akpm@linux-foundation.org
Subject: + epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update.patch added to -mm tree
Date: Thu, 05 Feb 2009 14:35:13 -0800
Message-ID: <200902052235.n15MZDAV023028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbZBEWf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 17:35:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, wli@movementarian.org


The patch titled
     epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key update
has been added to the -mm tree.  Its filename is
     epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update.patch

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
Subject: epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key update
From: Davide Libenzi <davidel@xmailserver.org>

- wake_up_nested() was only used by epoll, so the new wake_up_nested_poll()
  has been moved into fs/eventpoll.c, and wake_up_nested() being no more
  used, has been dropped

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: William Lee Irwin III <wli@movementarian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN fs/eventpoll.c~epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update
+++ a/fs/eventpoll.c
@@ -370,10 +370,28 @@ static int ep_call_nested(struct nested_
 	return error;
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
+				     unsigned long events, int subclass)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave_nested(&wqueue->lock, flags, subclass);
+	wake_up_locked_poll(wqueue, events);
+	spin_unlock_irqrestore(&wqueue->lock, flags);
+}
+#else
+static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
+				     unsigned long events, int subclass)
+{
+	wake_up_poll(wqueue, events);
+}
+#endif
+
 static int ep_poll_wakeup_proc(void *priv, void *cookie, int call_nests)
 {
-	wake_up_nested_poll((wait_queue_head_t *) cookie, POLLIN,
-			    1 + call_nests);
+	ep_wake_up_nested((wait_queue_head_t *) cookie, POLLIN,
+			  1 + call_nests);
 	return 0;
 }
 
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
linux-next.patch
epoll-fix-own-poll.patch
epoll-fix-epolls-own-poll-update.patch
epoll-remove-debugging-code.patch
eventfd-improve-support-for-semaphore-like-behavior.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch

