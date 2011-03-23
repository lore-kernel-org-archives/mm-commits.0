From: akpm@linux-foundation.org
Subject: [merged] epoll-move-ready-event-check-into-proper-inline.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:31 -0700
Message-ID: <201103232044.p2NKi7k9029035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933459Ab1CWUoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, shawn.bohrer@gmail.com, mm-commits@vger.kernel.org


The patch titled
     epoll: move ready event check into proper inline
has been removed from the -mm tree.  Its filename was
     epoll-move-ready-event-check-into-proper-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: move ready event check into proper inline
From: Davide Libenzi <davidel@xmailserver.org>

Move the event readiness check into a proper inline, and use it uniformly
inside ep_poll() code.  Events in the ->ovflist are no less ready than the
ones in ->rdllist.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN fs/eventpoll.c~epoll-move-ready-event-check-into-proper-inline fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-move-ready-event-check-into-proper-inline
+++ a/fs/eventpoll.c
@@ -316,6 +316,19 @@ static void ep_nested_calls_init(struct 
 }
 
 /**
+ * ep_events_available - Checks if ready events might be available.
+ *
+ * @ep: Pointer to the eventpoll context.
+ *
+ * Returns: Returns a value different than zero if ready events are available,
+ *          or zero otherwise.
+ */
+static inline int ep_events_available(struct eventpoll *ep)
+{
+	return !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
+}
+
+/**
  * ep_call_nested - Perform a bound (possibly) nested call, by checking
  *                  that the recursion limit is not exceeded, and that
  *                  the same nested call (by the meaning of same cookie) is
@@ -1158,7 +1171,7 @@ retry:
 	spin_lock_irqsave(&ep->lock, flags);
 
 	res = 0;
-	if (list_empty(&ep->rdllist)) {
+	if (!ep_events_available(ep)) {
 		/*
 		 * We don't have any available event to return to the caller.
 		 * We need to sleep here, and we will be wake up by
@@ -1174,7 +1187,7 @@ retry:
 			 * to TASK_INTERRUPTIBLE before doing the checks.
 			 */
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (!list_empty(&ep->rdllist) || timed_out)
+			if (ep_events_available(ep) || timed_out)
 				break;
 			if (signal_pending(current)) {
 				res = -EINTR;
@@ -1192,7 +1205,7 @@ retry:
 		set_current_state(TASK_RUNNING);
 	}
 	/* Is it worth to try to dig for events ? */
-	eavail = !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
+	eavail = ep_events_available(ep);
 
 	spin_unlock_irqrestore(&ep->lock, flags);
 
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch

