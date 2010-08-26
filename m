From: akpm@linux-foundation.org
Subject: + epoll-make-epoll_wait-use-the-hrtimer-range-feature.patch added to -mm tree
Date: Thu, 26 Aug 2010 15:32:12 -0700
Message-ID: <201008262232.o7QMWCw4018545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754447Ab0HZWcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Aug 2010 18:32:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shawn.bohrer@gmail.com, davidel@xmailserver.org, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     epoll: make epoll_wait() use the hrtimer range feature
has been added to the -mm tree.  Its filename is
     epoll-make-epoll_wait-use-the-hrtimer-range-feature.patch

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
Subject: epoll: make epoll_wait() use the hrtimer range feature
From: Shawn Bohrer <shawn.bohrer@gmail.com>

This make epoll use hrtimers for the timeout value which prevents
epoll_wait() from timing out up to a millisecond early.

This mirrors the behavior of select() and poll().

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c       |   33 ++++++++++++++++++---------------
 fs/select.c          |    2 +-
 include/linux/poll.h |    2 ++
 3 files changed, 21 insertions(+), 16 deletions(-)

diff -puN fs/eventpoll.c~epoll-make-epoll_wait-use-the-hrtimer-range-feature fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-make-epoll_wait-use-the-hrtimer-range-feature
+++ a/fs/eventpoll.c
@@ -77,9 +77,6 @@
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
 
-/* Maximum msec timeout value storeable in a long int */
-#define EP_MAX_MSTIMEO min(1000ULL * MAX_SCHEDULE_TIMEOUT / HZ, (LONG_MAX - 999ULL) / HZ)
-
 #define EP_MAX_EVENTS (INT_MAX / sizeof(struct epoll_event))
 
 #define EP_UNACTIVE_PTR ((void *) -1L)
@@ -1116,18 +1113,22 @@ static int ep_send_events(struct eventpo
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res, eavail;
+	int res, eavail, timed_out = 0;
 	unsigned long flags;
-	long jtimeout;
+	long slack;
 	wait_queue_t wait;
+	struct timespec end_time;
+	ktime_t expires, *to = NULL;
 
-	/*
-	 * Calculate the timeout by checking for the "infinite" value (-1)
-	 * and the overflow condition. The passed timeout is in milliseconds,
-	 * that why (t * HZ) / 1000.
-	 */
-	jtimeout = (timeout < 0 || timeout >= EP_MAX_MSTIMEO) ?
-		MAX_SCHEDULE_TIMEOUT : (timeout * HZ + 999) / 1000;
+	if (timeout > 0) {
+		ktime_get_ts(&end_time);
+		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
+		slack = select_estimate_accuracy(&end_time);
+		to = &expires;
+		*to = timespec_to_ktime(end_time);
+	} else if (timeout == 0) {
+		timed_out = 1;
+	}
 
 retry:
 	spin_lock_irqsave(&ep->lock, flags);
@@ -1149,7 +1150,7 @@ retry:
 			 * to TASK_INTERRUPTIBLE before doing the checks.
 			 */
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (!list_empty(&ep->rdllist) || !jtimeout)
+			if (!list_empty(&ep->rdllist) || timed_out)
 				break;
 			if (signal_pending(current)) {
 				res = -EINTR;
@@ -1157,7 +1158,9 @@ retry:
 			}
 
 			spin_unlock_irqrestore(&ep->lock, flags);
-			jtimeout = schedule_timeout(jtimeout);
+			if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+				timed_out = 1;
+
 			spin_lock_irqsave(&ep->lock, flags);
 		}
 		__remove_wait_queue(&ep->wq, &wait);
@@ -1175,7 +1178,7 @@ retry:
 	 * more luck.
 	 */
 	if (!res && eavail &&
-	    !(res = ep_send_events(ep, events, maxevents)) && jtimeout)
+	    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
 		goto retry;
 
 	return res;
diff -puN fs/select.c~epoll-make-epoll_wait-use-the-hrtimer-range-feature fs/select.c
--- a/fs/select.c~epoll-make-epoll_wait-use-the-hrtimer-range-feature
+++ a/fs/select.c
@@ -67,7 +67,7 @@ static long __estimate_accuracy(struct t
 	return slack;
 }
 
-static long select_estimate_accuracy(struct timespec *tv)
+long select_estimate_accuracy(struct timespec *tv)
 {
 	unsigned long ret;
 	struct timespec now;
diff -puN include/linux/poll.h~epoll-make-epoll_wait-use-the-hrtimer-range-feature include/linux/poll.h
--- a/include/linux/poll.h~epoll-make-epoll_wait-use-the-hrtimer-range-feature
+++ a/include/linux/poll.h
@@ -73,6 +73,8 @@ extern void poll_initwait(struct poll_wq
 extern void poll_freewait(struct poll_wqueues *pwq);
 extern int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
 				 ktime_t *expires, unsigned long slack);
+extern long select_estimate_accuracy(struct timespec *tv);
+
 
 static inline int poll_schedule(struct poll_wqueues *pwq, int state)
 {
_

Patches currently in -mm which might be from shawn.bohrer@gmail.com are

select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
epoll-make-epoll_wait-use-the-hrtimer-range-feature.patch

