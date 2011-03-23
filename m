From: akpm@linux-foundation.org
Subject: [merged] epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:33 -0700
Message-ID: <201103232044.p2NKi9ke029047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933310Ab1CWUoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shawn.bohrer@gmail.com, akpm@linux-foundation.org, davidel@xmailserver.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     epoll: fix compiler warning and optimize the non-blocking path
has been removed from the -mm tree.  Its filename was
     epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: fix compiler warning and optimize the non-blocking path
From: Shawn Bohrer <shawn.bohrer@gmail.com>

Add a comment to ep_poll(), rename labels a bit clearly, fix a warning of
unused variable from gcc and optimize the non-blocking path a little.

Hinted-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Davide Libenzi <davidel@xmailserver.org>

hannes@cmpxchg.org:

: The non-blocking ep_poll path optimization introduced skipping over the
: return value setup.
: 
: Initialize it properly, my userspace gets upset by epoll_wait() returning
: random things.
: 
: In addition, remove the reinitialization at the fetch_events label, the
: return value is garuanteed to be zero when execution reaches there.

[hannes@cmpxchg.org: fix initialization]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff -puN fs/eventpoll.c~epoll-fix-compiler-warning-and-optimize-the-non-blocking-path fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-fix-compiler-warning-and-optimize-the-non-blocking-path
+++ a/fs/eventpoll.c
@@ -1148,12 +1148,29 @@ static inline struct timespec ep_set_mst
 	return timespec_add_safe(now, ts);
 }
 
+/**
+ * ep_poll - Retrieves ready events, and delivers them to the caller supplied
+ *           event buffer.
+ *
+ * @ep: Pointer to the eventpoll context.
+ * @events: Pointer to the userspace buffer where the ready events should be
+ *          stored.
+ * @maxevents: Size (in terms of number of events) of the caller event buffer.
+ * @timeout: Maximum timeout for the ready events fetch operation, in
+ *           milliseconds. If the @timeout is zero, the function will not block,
+ *           while if the @timeout is less than zero, the function will block
+ *           until at least one event has been retrieved (or an error
+ *           occurred).
+ *
+ * Returns: Returns the number of ready events which have been fetched, or an
+ *          error code, in case of error.
+ */
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res, eavail, timed_out = 0;
+	int res = 0, eavail, timed_out = 0;
 	unsigned long flags;
-	long slack;
+	long slack = 0;
 	wait_queue_t wait;
 	ktime_t expires, *to = NULL;
 
@@ -1164,13 +1181,18 @@ static int ep_poll(struct eventpoll *ep,
 		to = &expires;
 		*to = timespec_to_ktime(end_time);
 	} else if (timeout == 0) {
+		/*
+		 * Avoid the unnecessary trip to the wait queue loop, if the
+		 * caller specified a non blocking operation.
+		 */
 		timed_out = 1;
+		spin_lock_irqsave(&ep->lock, flags);
+		goto check_events;
 	}
 
-retry:
+fetch_events:
 	spin_lock_irqsave(&ep->lock, flags);
 
-	res = 0;
 	if (!ep_events_available(ep)) {
 		/*
 		 * We don't have any available event to return to the caller.
@@ -1204,6 +1226,7 @@ retry:
 
 		set_current_state(TASK_RUNNING);
 	}
+check_events:
 	/* Is it worth to try to dig for events ? */
 	eavail = ep_events_available(ep);
 
@@ -1216,7 +1239,7 @@ retry:
 	 */
 	if (!res && eavail &&
 	    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
-		goto retry;
+		goto fetch_events;
 
 	return res;
 }
_

Patches currently in -mm which might be from shawn.bohrer@gmail.com are

origin.patch

