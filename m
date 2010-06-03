From: akpm@linux-foundation.org
Subject: + rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock.patch added to -mm tree
Date: Thu, 03 Jun 2010 11:42:25 -0700
Message-ID: <201006031842.o53IgP8V009056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755877Ab0FCSm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 14:42:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, hpa@zytor.com, mikew@google.com, mingo@elte.hu, suleiman@google.com, tglx@linutronix.de, yinghan@google.com


The patch titled
     rwsem: wake queued readers when writer blocks on active read lock
has been added to the -mm tree.  Its filename is
     rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock.patch

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
Subject: rwsem: wake queued readers when writer blocks on active read lock
From: Michel Lespinasse <walken@google.com>

This change addresses the following situation:

- Thread A acquires the rwsem for read
- Thread B tries to acquire the rwsem for write, notices there is already
  an active owner for the rwsem.
- Thread C tries to acquire the rwsem for read, notices that thread B already
  tried to acquire it.
- Thread C grabs the spinlock and queues itself on the wait queue.
- Thread B grabs the spinlock and queues itself behind C. At this point A is
  the only remaining active owner on the rwsem.

In this situation thread B could notice that it was the last active writer
on the rwsem, and decide to wake C to let it proceed in parallel with A
since they both only want the rwsem for read.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rwsem.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN lib/rwsem.c~rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock lib/rwsem.c
--- a/lib/rwsem.c~rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock
+++ a/lib/rwsem.c
@@ -67,6 +67,9 @@ __rwsem_do_wake(struct rw_semaphore *sem
 		goto readers_only;
 
 	if (wake_type == RWSEM_WAKE_READ_OWNED)
+		/* Another active reader was observed, so wakeup is not
+		 * likely to succeed. Save the atomic op.
+		 */
 		goto out;
 
 	/* There's a writer at the front of the queue - try to grant it the
@@ -111,8 +114,8 @@ __rwsem_do_wake(struct rw_semaphore *sem
 	 * count adjustment pretty soon.
 	 */
 	if (wake_type == RWSEM_WAKE_ANY &&
-	    (rwsem_atomic_update(0, sem) & RWSEM_ACTIVE_MASK))
-		/* Someone grabbed the sem already */
+	    rwsem_atomic_update(0, sem) < RWSEM_WAITING_BIAS)
+		/* Someone grabbed the sem for write already */
 		goto out;
 
 	/* Grant an infinite number of read locks to the readers at the front
@@ -187,9 +190,17 @@ rwsem_down_failed_common(struct rw_semap
 	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
 
-	/* if there are no active locks, wake the front queued process(es) up */
-	if (!(count & RWSEM_ACTIVE_MASK))
+	/* If there are no active locks, wake the front queued process(es) up.
+	 *
+	 * Alternatively, if we're called from a failed down_write(), there
+	 * were already threads queued before us and there are no active
+	 * writers, the lock must be read owned; so we try to wake any read
+	 * locks that were queued ahead of us. */
+	if (count == RWSEM_WAITING_BIAS)
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_NO_ACTIVE);
+	else if (count > RWSEM_WAITING_BIAS &&
+		 adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
 	spin_unlock_irq(&sem->wait_lock);
 
_

Patches currently in -mm which might be from walken@google.com are

x86-rwsem-stay-on-fast-path-when-count0-in-__up_write.patch
x86-rwsem-minor-cleanups.patch
rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers.patch
rwsem-lighter-active-count-checks-when-waking-up-readers.patch
rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads.patch
rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock.patch
rwsem-smaller-wrappers-around-rwsem_down_failed_common.patch

