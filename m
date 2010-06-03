From: akpm@linux-foundation.org
Subject: + rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads.patch added to -mm tree
Date: Thu, 03 Jun 2010 11:42:23 -0700
Message-ID: <201006031842.o53IgN0g009048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083Ab0FCSmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 14:42:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, hpa@zytor.com, mikew@google.com, mingo@elte.hu, suleiman@google.com, tglx@linutronix.de, yinghan@google.com


The patch titled
     rwsem: let RWSEM_WAITING_BIAS represent any number of waiting threads
has been added to the -mm tree.  Its filename is
     rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads.patch

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
Subject: rwsem: let RWSEM_WAITING_BIAS represent any number of waiting threads
From: Michel Lespinasse <walken@google.com>

Previously each waiting thread added a bias of RWSEM_WAITING_BIAS.  With
this change, the bias is added only once to indicate that the wait list is
non-empty.

This has a few nice properties which will be used in following changes:
- when the spinlock is held and the waiter list is known to be non-empty,
  count < RWSEM_WAITING_BIAS  <=>  there is an active writer on that sem
- count == RWSEM_WAITING_BIAS  <=>  there are waiting threads and no
                                     active readers/writers on that sem

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rwsem.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff -puN lib/rwsem.c~rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads lib/rwsem.c
--- a/lib/rwsem.c~rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads
+++ a/lib/rwsem.c
@@ -60,7 +60,7 @@ __rwsem_do_wake(struct rw_semaphore *sem
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
 	struct list_head *next;
-	signed long oldcount, woken, loop;
+	signed long oldcount, woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
@@ -73,9 +73,12 @@ __rwsem_do_wake(struct rw_semaphore *sem
 	 * write lock.  However, we only wake this writer if we can transition
 	 * the active part of the count from 0 -> 1
 	 */
+	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
+	if (waiter->list.next == &sem->wait_list)
+		adjustment -= RWSEM_WAITING_BIAS;
+
  try_again_write:
-	oldcount = rwsem_atomic_update(RWSEM_ACTIVE_BIAS, sem)
-						- RWSEM_ACTIVE_BIAS;
+	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
 	if (oldcount & RWSEM_ACTIVE_MASK)
 		/* Someone grabbed the sem already */
 		goto undo_write;
@@ -128,13 +131,15 @@ __rwsem_do_wake(struct rw_semaphore *sem
 
 	} while (waiter->flags & RWSEM_WAITING_FOR_READ);
 
-	loop = woken;
-	woken *= RWSEM_ACTIVE_BIAS - RWSEM_WAITING_BIAS;
+	adjustment = woken * RWSEM_ACTIVE_READ_BIAS;
+	if (waiter->flags & RWSEM_WAITING_FOR_READ)
+		/* hit end of list above */
+		adjustment -= RWSEM_WAITING_BIAS;
 
-	rwsem_atomic_add(woken, sem);
+	rwsem_atomic_add(adjustment, sem);
 
 	next = sem->wait_list.next;
-	for (; loop > 0; loop--) {
+	for (loop = woken; loop > 0; loop--) {
 		waiter = list_entry(next, struct rwsem_waiter, list);
 		next = waiter->list.next;
 		tsk = waiter->task;
@@ -153,7 +158,7 @@ __rwsem_do_wake(struct rw_semaphore *sem
 	/* undo the change to the active count, but check for a transition
 	 * 1->0 */
  undo_write:
-	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
+	if (rwsem_atomic_update(-adjustment, sem) & RWSEM_ACTIVE_MASK)
 		goto out;
 	goto try_again_write;
 }
@@ -175,6 +180,8 @@ rwsem_down_failed_common(struct rw_semap
 	waiter->task = tsk;
 	get_task_struct(tsk);
 
+	if (list_empty(&sem->wait_list))
+		adjustment += RWSEM_WAITING_BIAS;
 	list_add_tail(&waiter->list, &sem->wait_list);
 
 	/* we're now waiting on the lock, but no longer actively locking */
@@ -208,8 +215,7 @@ rwsem_down_read_failed(struct rw_semapho
 	struct rwsem_waiter waiter;
 
 	waiter.flags = RWSEM_WAITING_FOR_READ;
-	rwsem_down_failed_common(sem, &waiter,
-				RWSEM_WAITING_BIAS - RWSEM_ACTIVE_BIAS);
+	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_READ_BIAS);
 	return sem;
 }
 
@@ -222,7 +228,7 @@ rwsem_down_write_failed(struct rw_semaph
 	struct rwsem_waiter waiter;
 
 	waiter.flags = RWSEM_WAITING_FOR_WRITE;
-	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_BIAS);
+	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_WRITE_BIAS);
 
 	return sem;
 }
_

Patches currently in -mm which might be from walken@google.com are

x86-rwsem-stay-on-fast-path-when-count0-in-__up_write.patch
x86-rwsem-minor-cleanups.patch
rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers.patch
rwsem-lighter-active-count-checks-when-waking-up-readers.patch
rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads.patch
rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock.patch
rwsem-smaller-wrappers-around-rwsem_down_failed_common.patch

