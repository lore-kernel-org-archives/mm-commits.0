From: akpm@linux-foundation.org
Subject: [merged] epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:45 -0700
Message-ID: <200904011840.n31Iekus009112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933629AbZDASqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, mingo@elte.hu, torvalds@linux-foundation.org, wli@movementarian.org, mm-commits@vger.kernel.org


The patch titled
     epoll keyed wakeups: add __wake_up_locked_key() and __wake_up_sync_key()
has been removed from the -mm tree.  Its filename was
     epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll keyed wakeups: add __wake_up_locked_key() and __wake_up_sync_key()
From: Davide Libenzi <davidel@xmailserver.org>

This patchset introduces wakeup hints for some of the most popular (from
epoll POV) devices, so that epoll code can avoid spurious wakeups on its
waiters.

The problem with epoll is that the callback-based wakeups do not, ATM,
carry any information about the events the wakeup is related to.  So the
only choice epoll has (not being able to call f_op->poll() from inside the
callback), is to add the file* to a ready-list and resolve the real events
later on, at epoll_wait() (or its own f_op->poll()) time.  This can cause
spurious wakeups, since the wake_up() itself might be for an event the
caller is not interested into.

The rate of these spurious wakeup can be pretty high in case of many
network sockets being monitored.

By allowing devices to report the events the wakeups refer to (at least
the two major classes - POLLIN/POLLOUT), we are able to spare useless
wakeups by proper handling inside the epoll's poll callback.

Epoll will have in any case to call f_op->poll() on the file* later on,
since the change to be done in order to have the full event set sent via
wakeup, is too invasive for the way our f_op->poll() system works (the
full event set is calculated inside the poll function - there are too many
of them to even start thinking the change - also poll/select would need
change too).

Epoll is changed in a way that both devices which send event hints, and
the ones that don't, are correctly handled.  The former will gain some
efficiency though.

As a general rule for devices, would be to add an event mask by using
key-aware wakeup macros, when making up poll wait queues.  I tested it
(together with the epoll's poll fix patch Andrew has in -mm) and wakeups
for the supported devices are correctly filtered.

Test program available here:

http://www.xmailserver.org/epoll_test.c


This patch:

Nothing revolutionary here.  Just using the available "key" that our
wakeup core already support.  The __wake_up_locked_key() was no brainer,
since both __wake_up_locked() and __wake_up_locked_key() are thin wrappers
around __wake_up_common().

The __wake_up_sync() function had a body, so the choice was between
borrowing the body for __wake_up_sync_key() and calling it from
__wake_up_sync(), or make an inline and calling it from both.  I chose the
former since in most archs it all resolves to "mov $0, REG; jmp ADDR".

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: William Lee Irwin III <wli@movementarian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |    7 +++++--
 kernel/sched.c       |   23 +++++++++++++++++++----
 2 files changed, 24 insertions(+), 6 deletions(-)

diff -puN include/linux/wait.h~epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key include/linux/wait.h
--- a/include/linux/wait.h~epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key
+++ a/include/linux/wait.h
@@ -135,8 +135,11 @@ static inline void __remove_wait_queue(w
 void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, int sync, void *key);
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
-extern void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
-extern void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
+void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
+void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr,
+			void *key);
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
+void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
 int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
 int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
diff -puN kernel/sched.c~epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key kernel/sched.c
--- a/kernel/sched.c~epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key
+++ a/kernel/sched.c
@@ -5196,11 +5196,17 @@ void __wake_up_locked(wait_queue_head_t 
 	__wake_up_common(q, mode, 1, 0, NULL);
 }
 
+void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
+{
+	__wake_up_common(q, mode, 1, 0, key);
+}
+
 /**
- * __wake_up_sync - wake up threads blocked on a waitqueue.
+ * __wake_up_sync_key - wake up threads blocked on a waitqueue.
  * @q: the waitqueue
  * @mode: which threads
  * @nr_exclusive: how many wake-one or wake-many threads to wake up
+ * @key: opaque value to be passed to wakeup targets
  *
  * The sync wakeup differs that the waker knows that it will schedule
  * away soon, so while the target thread will be woken up, it will not
@@ -5209,8 +5215,8 @@ void __wake_up_locked(wait_queue_head_t 
  *
  * On UP it can prevent extra preemption.
  */
-void
-__wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
+void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, void *key)
 {
 	unsigned long flags;
 	int sync = 1;
@@ -5222,9 +5228,18 @@ __wake_up_sync(wait_queue_head_t *q, uns
 		sync = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, sync, NULL);
+	__wake_up_common(q, mode, nr_exclusive, sync, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
+EXPORT_SYMBOL_GPL(__wake_up_sync_key);
+
+/*
+ * __wake_up_sync - see __wake_up_sync_key()
+ */
+void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
+{
+	__wake_up_sync_key(q, mode, nr_exclusive, NULL);
+}
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
 /**
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
linux-next.patch

