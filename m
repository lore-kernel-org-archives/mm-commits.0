From: akpm@linux-foundation.org
Subject: + epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch added to -mm tree
Date: Wed, 19 Jan 2011 14:29:53 -0800
Message-ID: <201101192229.p0JMTr6b007212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055Ab1ASW34 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 17:29:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shawn.bohrer@gmail.com, akpm@linux-foundation.org, davidel@xmailserver.org


The patch titled
     epoll: fix compiler warning and optimize the non-blocking path
has been added to the -mm tree.  Its filename is
     epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch

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
Subject: epoll: fix compiler warning and optimize the non-blocking path
From: Shawn Bohrer <shawn.bohrer@gmail.com>

Add a comment to ep_poll(), rename labels a bit clearly, fix a warning of
unused variable from gcc and optimize the non-blocking path a little.

Hinted-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff -puN fs/eventpoll.c~epoll-fix-compiler-warning-and-optimize-the-non-blocking-path fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-fix-compiler-warning-and-optimize-the-non-blocking-path
+++ a/fs/eventpoll.c
@@ -1127,27 +1127,50 @@ static int ep_send_events(struct eventpo
 	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
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
 	int res, eavail, timed_out = 0;
 	unsigned long flags;
-	long slack;
+	long slack = 0;
 	wait_queue_t wait;
 	struct timespec end_time;
 	ktime_t expires, *to = NULL;
 
 	if (timeout > 0) {
 		ktime_get_ts(&end_time);
-		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
+		timespec_add_ns(&end_time, (u64) timeout * NSEC_PER_MSEC);
 		slack = select_estimate_accuracy(&end_time);
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
 
 	res = 0;
@@ -1184,6 +1207,7 @@ retry:
 
 		set_current_state(TASK_RUNNING);
 	}
+check_events:
 	/* Is it worth to try to dig for events ? */
 	eavail = ep_events_available(ep);
 
@@ -1196,7 +1220,7 @@ retry:
 	 */
 	if (!res && eavail &&
 	    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
-		goto retry;
+		goto fetch_events;
 
 	return res;
 }
_

Patches currently in -mm which might be from shawn.bohrer@gmail.com are

epoll-move-ready-event-check-into-proper-inline.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch

