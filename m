From: akpm@linux-foundation.org
Subject: [folded] epoll-keyed-wakeups-v3-introduce-new-_poll-wakeup-macros.patch removed from -mm tree
Date: Tue, 31 Mar 2009 15:04:21 -0700
Message-ID: <200903312204.n2VM4M46016733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbZCaWGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 18:06:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     epoll keyed wakeups v3 - introduce new *_poll() wakeup macros
has been removed from the -mm tree.  Its filename was
     epoll-keyed-wakeups-v3-introduce-new-_poll-wakeup-macros.patch

This patch was dropped because it was folded into epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch

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
-
 #define __wait_event(wq, condition) 					\
 do {									\
 	DEFINE_WAIT(__wait);						\
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
epoll-fix-own-poll.patch
epoll-fix-epolls-own-poll-update.patch
epoll-remove-debugging-code.patch
epoll-dont-use-current-in-irq-context.patch
epoll-remember-the-event-if-epoll_wait-returns-efault.patch
epoll-remove-unnecessary-xchg.patch
epoll-clean-up-ep_modify.patch
epoll-use-real-type-instead-of-void.patch
eventfd-improve-support-for-semaphore-like-behavior.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v3-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups-update.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch
linux-next.patch

