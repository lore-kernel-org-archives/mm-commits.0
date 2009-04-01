From: akpm@linux-foundation.org
Subject: [merged] epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:52 -0700
Message-ID: <200904011840.n31Ieqko009168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbZDATey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, mingo@elte.hu, torvalds@linux-foundation.org, wli@movementarian.org, mm-commits@vger.kernel.org


The patch titled
     epoll keyed wakeups: teach epoll about hints coming with the wakeup key
has been removed from the -mm tree.  Its filename was
     epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll keyed wakeups: teach epoll about hints coming with the wakeup key
From: Davide Libenzi <davidel@xmailserver.org>

Use the events hint now sent by some devices, to avoid unnecessary wakeups
for events that are of no interest for the caller.  This code handles both
devices that are sending keyed events, and the ones that are not (and
event the ones that sometimes send events, and sometimes don't).

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: William Lee Irwin III <wli@movementarian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff -puN fs/eventpoll.c~epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key
+++ a/fs/eventpoll.c
@@ -371,9 +371,28 @@ static int ep_call_nested(struct nested_
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
-	wake_up_nested((wait_queue_head_t *) cookie, 1 + call_nests);
+	ep_wake_up_nested((wait_queue_head_t *) cookie, POLLIN,
+			  1 + call_nests);
 	return 0;
 }
 
@@ -783,6 +802,15 @@ static int ep_poll_callback(wait_queue_t
 		goto out_unlock;
 
 	/*
+	 * Check the events coming with the callback. At this stage, not
+	 * every device reports the events in the "key" parameter of the
+	 * callback. We need to be able to handle both cases here, hence the
+	 * test for "key" != NULL before the event match test.
+	 */
+	if (key && !((unsigned long) key & epi->event.events))
+		goto out_unlock;
+
+	/*
 	 * If we are trasfering events to userspace, we can hold no locks
 	 * (because we're accessing user memory, and because of linux f_op->poll()
 	 * semantics). All the events that happens during that period of time are
@@ -1254,7 +1282,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	case EPOLL_CTL_ADD:
 		if (!epi) {
 			epds.events |= POLLERR | POLLHUP;
