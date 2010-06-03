From: akpm@linux-foundation.org
Subject: + rwsem-lighter-active-count-checks-when-waking-up-readers.patch added to -mm tree
Date: Thu, 03 Jun 2010 11:42:21 -0700
Message-ID: <201006031842.o53IgMfF009045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013Ab0FCSmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 14:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, hpa@zytor.com, mikew@google.com, mingo@elte.hu, suleiman@google.com, tglx@linutronix.de, yinghan@google.com


The patch titled
     rwsem: lighter active count checks when waking up readers
has been added to the -mm tree.  Its filename is
     rwsem-lighter-active-count-checks-when-waking-up-readers.patch

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
Subject: rwsem: lighter active count checks when waking up readers
From: Michel Lespinasse <walken@google.com>

In __rwsem_do_wake(), we can skip the active count check unless we come
there from up_xxxx().  Also when checking the active count, it is not
actually necessary to increment it; this allows us to get rid of the read
side undo code and simplify the calculation of the final rwsem count
adjustment once we've counted the reader threads to wake.

The basic observation is the following.  When there are waiter threads on
a rwsem and the spinlock is held, other threads can only increment the
active count by trying to grab the rwsem in down_xxxx().  However
down_xxxx() will notice there are waiter threads and take the down_failed
path, blocking to acquire the spinlock on the way there.  Therefore, a
thread observing an active count of zero with waiters queued and the
spinlock held, is protected against other threads acquiring the rwsem
until it wakes the last waiter or releases the spinlock.

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

 lib/rwsem.c |   57 ++++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff -puN lib/rwsem.c~rwsem-lighter-active-count-checks-when-waking-up-readers lib/rwsem.c
--- a/lib/rwsem.c~rwsem-lighter-active-count-checks-when-waking-up-readers
+++ a/lib/rwsem.c
@@ -36,6 +36,14 @@ struct rwsem_waiter {
 #define RWSEM_WAITING_FOR_WRITE	0x00000002
 };
 
+/* Wake types for __rwsem_do_wake().  Note that RWSEM_WAKE_NO_ACTIVE and
+ * RWSEM_WAKE_READ_OWNED imply that the spinlock must have been kept held
+ * since the rwsem value was observed.
+ */
+#define RWSEM_WAKE_ANY        0 /* Wake whatever's at head of wait list */
+#define RWSEM_WAKE_NO_ACTIVE  1 /* rwsem was observed with no active thread */
+#define RWSEM_WAKE_READ_OWNED 2 /* rwsem was observed to be read owned */
+
 /*
  * handle the lock release when processes blocked on it that can now run
  * - if we come here from up_xxxx(), then:
@@ -46,8 +54,8 @@ struct rwsem_waiter {
  * - woken process blocks are discarded from the list after having task zeroed
  * - writers are only woken if downgrading is false
  */
-static inline struct rw_semaphore *
-__rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
+static struct rw_semaphore *
+__rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 {
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
@@ -58,7 +66,7 @@ __rwsem_do_wake(struct rw_semaphore *sem
 	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
 		goto readers_only;
 
-	if (downgrading)
+	if (wake_type == RWSEM_WAKE_READ_OWNED)
 		goto out;
 
 	/* There's a writer at the front of the queue - try to grant it the
@@ -85,19 +93,25 @@ __rwsem_do_wake(struct rw_semaphore *sem
 	goto out;
 
  readers_only:
-	if (downgrading)
-		goto wake_readers;
-
-	/* if we came through an up_xxxx() call, we only only wake someone up
-	 * if we can transition the active part of the count from 0 -> 1 */
- try_again_read:
-	oldcount = rwsem_atomic_update(RWSEM_ACTIVE_BIAS, sem)
-						- RWSEM_ACTIVE_BIAS;
-	if (oldcount & RWSEM_ACTIVE_MASK)
+	/* If we come here from up_xxxx(), another thread might have reached
+	 * rwsem_down_failed_common() before we acquired the spinlock and
+	 * woken up a waiter, making it now active.  We prefer to check for
+	 * this first in order to not spend too much time with the spinlock
+	 * held if we're not going to be able to wake up readers in the end.
+	 *
+	 * Note that we do not need to update the rwsem count: any writer
+	 * trying to acquire rwsem will run rwsem_down_write_failed() due
+	 * to the waiting threads and block trying to acquire the spinlock.
+	 *
+	 * We use a dummy atomic update in order to acquire the cache line
+	 * exclusively since we expect to succeed and run the final rwsem
+	 * count adjustment pretty soon.
+	 */
+	if (wake_type == RWSEM_WAKE_ANY &&
+	    (rwsem_atomic_update(0, sem) & RWSEM_ACTIVE_MASK))
 		/* Someone grabbed the sem already */
-		goto undo_read;
+		goto out;
 
- wake_readers:
 	/* Grant an infinite number of read locks to the readers at the front
 	 * of the queue.  Note we increment the 'active part' of the count by
 	 * the number of readers before waking any processes up.
@@ -116,9 +130,6 @@ __rwsem_do_wake(struct rw_semaphore *sem
 
 	loop = woken;
 	woken *= RWSEM_ACTIVE_BIAS - RWSEM_WAITING_BIAS;
-	if (!downgrading)
-		/* we'd already done one increment earlier */
-		woken -= RWSEM_ACTIVE_BIAS;
 
 	rwsem_atomic_add(woken, sem);
 
@@ -145,10 +156,6 @@ __rwsem_do_wake(struct rw_semaphore *sem
 	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
 		goto out;
 	goto try_again_write;
- undo_read:
-	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
-		goto out;
-	goto try_again_read;
 }
 
 /*
@@ -170,12 +177,12 @@ rwsem_down_failed_common(struct rw_semap
 
 	list_add_tail(&waiter->list, &sem->wait_list);
 
-	/* we're now waiting on the lock, but no longer actively read-locking */
+	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
 
 	/* if there are no active locks, wake the front queued process(es) up */
 	if (!(count & RWSEM_ACTIVE_MASK))
-		sem = __rwsem_do_wake(sem, 0);
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_NO_ACTIVE);
 
 	spin_unlock_irq(&sem->wait_lock);
 
@@ -232,7 +239,7 @@ asmregparm struct rw_semaphore *rwsem_wa
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, 0);
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
 
 	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
@@ -252,7 +259,7 @@ asmregparm struct rw_semaphore *rwsem_do
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, 1);
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
 	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
_

Patches currently in -mm which might be from walken@google.com are

x86-rwsem-stay-on-fast-path-when-count0-in-__up_write.patch
x86-rwsem-minor-cleanups.patch
rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers.patch
rwsem-lighter-active-count-checks-when-waking-up-readers.patch
rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads.patch
rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock.patch
rwsem-smaller-wrappers-around-rwsem_down_failed_common.patch

