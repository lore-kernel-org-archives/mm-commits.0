From: akpm@linux-foundation.org
Subject: [merged] epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:48 -0700
Message-ID: <200904011840.n31IemVR009120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933647AbZDASp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:45:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, mingo@elte.hu, torvalds@linux-foundation.org, wli@movementarian.org, mm-commits@vger.kernel.org


The patch titled
     epoll keyed wakeups: introduce new *_poll() wakeup macros
has been removed from the -mm tree.  Its filename was
     epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 include/linux/wait.h |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN include/linux/wait.h~epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros include/linux/wait.h
--- a/include/linux/wait.h~epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros
+++ a/include/linux/wait.h
@@ -158,21 +158,17 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
 #define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_INTERRUPTIBLE, 1)
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
- * macro to avoid include hell
+ * Wakeup macros to be used to report events to the targets.
  */
-#define wake_up_nested(x, s)						\
-do {									\
-	unsigned long flags;						\
-									\
-	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
-	wake_up_locked(x); 						\
-	spin_unlock_irqrestore(&(x)->lock, flags);			\
-} while (0)
-#else
-#define wake_up_nested(x, s)		wake_up(x)
-#endif
+#define wake_up_poll(x, m)				\
+	__wake_up(x, TASK_NORMAL, 1, (void *) (m))
+#define wake_up_locked_poll(x, m)				\
+	__wake_up_locked_key((x), TASK_NORMAL, (void *) (m))
+#define wake_up_interruptible_poll(x, m)			\
+	__wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
+#define wake_up_interruptible_sync_poll(x, m)				\
+	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
 #define __wait_event(wq, condition) 					\
 do {									\
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
linux-next.patch

