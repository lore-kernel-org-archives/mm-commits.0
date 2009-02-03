From: akpm@linux-foundation.org
Subject: + epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch added to -mm tree
Date: Tue, 03 Feb 2009 00:15:04 -0800
Message-ID: <200902030815.n138F4Pn025273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbZBCIQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 03:16:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, mingo@elte.hu, torvalds@linux-foundation.org, wli@movementarian.org


The patch titled
     epoll keyed wakeups: introduce new *_poll() wakeup macros
has been added to the -mm tree.  Its filename is
     epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch

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
Subject: epoll keyed wakeups: introduce new *_poll() wakeup macros
From: Davide Libenzi <davidel@xmailserver.org>

Introduce new wakeup macros that allow passing an event mask to the wakeup
targets.  They exactly mimic their non-_poll() counterpart, with the added
event mask passing capability.  I did add only the ones currently
requested, avoiding the _nr() and _all() for the moment.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: William Lee Irwin III <wli@movementarian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN include/linux/wait.h~epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros include/linux/wait.h
--- a/include/linux/wait.h~epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros
+++ a/include/linux/wait.h
@@ -158,6 +158,18 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
 #define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_INTERRUPTIBLE, 1)
 
+/*
+ * Wakeup macros to be used to report events to the targets.
+ */
+#define wake_up_poll(x, m)				\
+	__wake_up(x, TASK_NORMAL, 1, (void *) (m))
+#define wake_up_locked_poll(x, m)				\
+	__wake_up_locked_key((x), TASK_NORMAL, (void *) (m))
+#define wake_up_interruptible_poll(x, m)			\
+	__wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
+#define wake_up_interruptible_sync_poll(x, m)				\
+	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
  * macro to avoid include hell
@@ -170,8 +182,17 @@ do {									\
 	wake_up_locked(x); 						\
 	spin_unlock_irqrestore(&(x)->lock, flags);			\
 } while (0)
+#define wake_up_nested_poll(x, m, s)					\
+do {									\
+	unsigned long flags;						\
+									\
+	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
+	wake_up_locked_poll(x, m);					\
+	spin_unlock_irqrestore(&(x)->lock, flags);			\
+} while (0)
 #else
 #define wake_up_nested(x, s)		wake_up(x)
+#define wake_up_nested_poll(x, m, s)	wake_up_poll(x, m)
 #endif
 
 #define __wait_event(wq, condition) 					\
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
linux-next.patch
epoll-fix-own-poll.patch
epoll-fix-epolls-own-poll-update.patch
epoll-remove-debugging-code.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch

