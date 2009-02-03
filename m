From: akpm@linux-foundation.org
Subject: + epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch added to -mm tree
Date: Tue, 03 Feb 2009 00:15:08 -0800
Message-ID: <200902030815.n138F85A025305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbZBCIQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 03:16:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, mingo@elte.hu, torvalds@linux-foundation.org, wli@movementarian.org


The patch titled
     epoll keyed wakeups: teach epoll about hints coming with the wakeup key
has been added to the -mm tree.  Its filename is
     epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch

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
Subject: epoll keyed wakeups: teach epoll about hints coming with the wakeup key
From: Davide Libenzi <davidel@xmailserver.org>

Use the events hint now sent by some devices, to avoid unnecessary wakeups
for events that are of no interest for the caller.  This code handles both
devices that are sending keyed events, and the ones that are not (and
event the ones that sometimes send events, and sometimes don't).

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: William Lee Irwin III <wli@movementarian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/eventpoll.c~epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key
+++ a/fs/eventpoll.c
@@ -372,7 +372,8 @@ static int ep_call_nested(struct nested_
 
 static int ep_poll_wakeup_proc(void *priv, void *cookie, int call_nests)
 {
-	wake_up_nested((wait_queue_head_t *) cookie, 1 + call_nests);
+	wake_up_nested_poll((wait_queue_head_t *) cookie, POLLIN,
+			    1 + call_nests);
 	return 0;
 }
 
@@ -785,6 +786,15 @@ static int ep_poll_callback(wait_queue_t
 	if (!(epi->event.events & ~EP_PRIVATE_BITS))
 		goto out_unlock;
 
+        /*
+	 * Check the events coming with the callback. At this stage, not
+	 * every device reports the events in the "key" parameter of the
+	 * callback. We need to be able to handle both cases here, hence the
+	 * test for "key" != NULL before the event match test.
+	 */
+	if (key && !((unsigned long) key & epi->event.events))
+		goto out_unlock;
+
 	/*
 	 * If we are trasfering events to userspace, we can hold no locks
 	 * (because we're accessing user memory, and because of linux f_op->poll()
@@ -1260,7 +1270,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	case EPOLL_CTL_ADD:
 		if (!epi) {
 			epds.events |= POLLERR | POLLHUP;
