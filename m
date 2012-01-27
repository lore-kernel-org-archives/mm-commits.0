From: akpm@linux-foundation.org
Subject: + epoll-comment-the-funky-ifdef.patch added to -mm tree
Date: Fri, 27 Jan 2012 14:19:54 -0800
Message-ID: <20120127221954.E44EEA016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:42342 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab2A0WT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 17:19:58 -0500
Received: by wgbgn7 with SMTP id gn7so103224wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 14:19:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, a.p.zijlstra@chello.nl, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, davidel@xmailserver.org, mingo@elte.hu


The patch titled
     Subject: epoll: comment the funky #ifdef
has been added to the -mm tree.  Its filename is
     epoll-comment-the-funky-ifdef.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: epoll: comment the funky #ifdef

Looking for a bug in -rt, I stumbled across this code here from:

commit 2dfa4eeab0fc7e8633974f2770945311b31eedf6
Author: Davide Libenzi <davidel@xmailserver.org>
Date:   Tue Mar 31 15:24:22 2009 -0700

epoll keyed wakeups: teach epoll about hints coming with the wakeup key

Specifically:

@@ -371,9 +371,28 @@ static int ep_call_nested(struct nested_calls *ncalls, int
        return error;
 }

+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
+                                    unsigned long events, int subclass)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave_nested(&wqueue->lock, flags, subclass);
+       wake_up_locked_poll(wqueue, events);
+       spin_unlock_irqrestore(&wqueue->lock, flags);
+}
+#else
+static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
+                                    unsigned long events, int subclass)
+{
+       wake_up_poll(wqueue, events);
+}
+#endif
+

You change the function of ep_wake_up_nested() depending on whether
CONFIG_DEBUG_LOCK_ALLOC is set or not.  This looks awfully suspicious, and
there's no comment to explain why.  I initially thought that this was
trying to fool lockdep, and hiding a real bug.

Investigating it, I found the creation of wake_up_nested() (which no
longer exists) but was created for the sole purpose of epoll and its
strange wake ups, as explained in:

commit 0ccf831cbee94df9c5006dd46248c0f07847dd7c
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Feb 4 22:27:20 2008 -0800

lockdep: annotate epoll

Although the commit message says "annotate epoll" the change log is much
better at explaining what is happening than what is in the actual code.
Thus a comment is really necessary here. And to save the time of other
developers from having to go trudging through the git logs trying to
figure out why this code exists.

I took parts of the change log and placed it into a comment above the
affected code. This will make the description of what is happening more
visible to new developers that have to look at this code for the first
time.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN fs/eventpoll.c~epoll-comment-the-funky-ifdef fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-comment-the-funky-ifdef
+++ a/fs/eventpoll.c
@@ -422,6 +422,31 @@ out_unlock:
 	return error;
 }
 
+/*
+ * As described in commit 0ccf831cb lockdep: annotate epoll
+ * the use of wait queues used by epoll is done in a very controlled
+ * manner. Wake ups can nest inside each other, but are never done
+ * with the same locking. For example:
+ *
+ *   dfd = socket(...);
+ *   efd1 = epoll_create();
+ *   efd2 = epoll_create();
+ *   epoll_ctl(efd1, EPOLL_CTL_ADD, dfd, ...);
+ *   epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);
+ *
+ * When a packet arrives to the device underneath "dfd", the net code will
+ * issue a wake_up() on its poll wake list. Epoll (efd1) has installed a
+ * callback wakeup entry on that queue, and the wake_up() performed by the
+ * "dfd" net code will end up in ep_poll_callback(). At this point epoll
+ * (efd1) notices that it may have some event ready, so it needs to wake up
+ * the waiters on its poll wait list (efd2). So it calls ep_poll_safewake()
+ * that ends up in another wake_up(), after having checked about the
+ * recursion constraints. That are, no more than EP_MAX_POLLWAKE_NESTS, to
+ * avoid stack blasting.
+ *
+ * When CONFIG_DEBUG_LOCK_ALLOC is enabled, make sure lockdep can handle
+ * this special case of epoll.
+ */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
 				     unsigned long events, int subclass)
_
Subject: Subject: epoll: comment the funky #ifdef

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
epoll-comment-the-funky-ifdef.patch

