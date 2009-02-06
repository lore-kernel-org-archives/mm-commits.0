From: akpm@linux-foundation.org
Subject: + epoll-keyed-wakeups-v3-introduce-new-_poll-wakeup-macros.patch added to -mm tree
Date: Thu, 05 Feb 2009 17:33:04 -0800
Message-ID: <200902060133.n161X4UI004271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbZBFBdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 20:33:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org


The patch titled
     epoll keyed wakeups v3 - introduce new *_poll() wakeup macros
has been added to the -mm tree.  Its filename is
     epoll-keyed-wakeups-v3-introduce-new-_poll-wakeup-macros.patch

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
Subject: epoll keyed wakeups v3 - introduce new *_poll() wakeup macros
From: Davide Libenzi <davidel@xmailserver.org>

This patch introduces new wakeup macros that allow passing an event
mask to the wakeup targets. They exactly mimic their non-_poll()
counterpart, with the added event mask passing capability.
I did add only the ones currently requested, avoiding the _nr() and
_all() for the moment.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |   25 -------------------------
 1 file changed, 25 deletions(-)

diff -puN include/linux/wait.h~epoll-keyed-wakeups-v3-introduce-new-_poll-wakeup-macros include/linux/wait.h
--- a/include/linux/wait.h~epoll-keyed-wakeups-v3-introduce-new-_poll-wakeup-macros
+++ a/include/linux/wait.h
@@ -170,31 +170,6 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up_interruptible_sync_poll(x, m)				\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-/*
- * macro to avoid include hell
- */
-#define wake_up_nested(x, s)						\
-do {									\
-	unsigned long flags;						\
-									\
-	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
-	wake_up_locked(x); 						\
-	spin_unlock_irqrestore(&(x)->lock, flags);			\
-} while (0)
-#define wake_up_nested_poll(x, m, s)					\
-do {									\
-	unsigned long flags;						\
-									\
-	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
-	wake_up_locked_poll(x, m);					\
-	spin_unlock_irqrestore(&(x)->lock, flags);			\
-} while (0)
-#else
-#define wake_up_nested(x, s)		wake_up(x)
-#define wake_up_nested_poll(x, m, s)	wake_up_poll(x, m)
-#endif
