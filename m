From: akpm@linux-foundation.org
Subject: + rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers.patch added to -mm tree
Date: Thu, 03 Jun 2010 11:42:19 -0700
Message-ID: <201006031842.o53IgJVA009040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755683Ab0FCSm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 14:42:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, hpa@zytor.com, mikew@google.com, mingo@elte.hu, suleiman@google.com, tglx@linutronix.de, yinghan@google.com


The patch titled
     rwsem: fully separate code paths to wake writers vs readers
has been added to the -mm tree.  Its filename is
     rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers.patch

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
Subject: rwsem: fully separate code paths to wake writers vs readers
From: Michel Lespinasse <walken@google.com>

This is in preparation for later changes in the series.

In __rwsem_do_wake(), the first queued waiter is checked first in order to
determine whether it's a writer or a reader.  The code paths diverge at
this point.  The code that checks and increments the rwsem active count is
duplicated on both sides - the point is that later changes in the series
will be able to independently modify both sides.

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

 lib/rwsem.c |   61 +++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 27 deletions(-)

diff -puN lib/rwsem.c~rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers lib/rwsem.c
--- a/lib/rwsem.c~rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers
+++ a/lib/rwsem.c
@@ -41,7 +41,7 @@ struct rwsem_waiter {
  * - if we come here from up_xxxx(), then:
  *   - the 'active part' of count (&0x0000ffff) reached 0 (but may have changed)
  *   - the 'waiting part' of count (&0xffff0000) is -ve (and will still be so)
- *   - there must be someone on the queue
+ * - there must be someone on the queue
  * - the spinlock must be held by the caller
  * - woken process blocks are discarded from the list after having task zeroed
  * - writers are only woken if downgrading is false
@@ -54,26 +54,23 @@ __rwsem_do_wake(struct rw_semaphore *sem
 	struct list_head *next;
 	signed long oldcount, woken, loop;
 
+	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
+	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
+		goto readers_only;
+
 	if (downgrading)
-		goto dont_wake_writers;
+		goto out;
 
-	/* if we came through an up_xxxx() call, we only only wake someone up
-	 * if we can transition the active part of the count from 0 -> 1
+	/* There's a writer at the front of the queue - try to grant it the
+	 * write lock.  However, we only wake this writer if we can transition
+	 * the active part of the count from 0 -> 1
 	 */
- try_again:
+ try_again_write:
 	oldcount = rwsem_atomic_update(RWSEM_ACTIVE_BIAS, sem)
 						- RWSEM_ACTIVE_BIAS;
 	if (oldcount & RWSEM_ACTIVE_MASK)
-		goto undo;
-
-	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-
-	/* try to grant a single write lock if there's a writer at the front
-	 * of the queue - note we leave the 'active part' of the count
-	 * incremented by 1 and the waiting part incremented by 0x00010000
-	 */
-	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
-		goto readers_only;
+		/* Someone grabbed the sem already */
+		goto undo_write;
 
 	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
 	 * It is an allocated on the waiter's stack and may become invalid at
@@ -87,18 +84,24 @@ __rwsem_do_wake(struct rw_semaphore *sem
 	put_task_struct(tsk);
 	goto out;
 
-	/* don't want to wake any writers */
- dont_wake_writers:
-	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	if (waiter->flags & RWSEM_WAITING_FOR_WRITE)
-		goto out;
+ readers_only:
+	if (downgrading)
+		goto wake_readers;
+
+	/* if we came through an up_xxxx() call, we only only wake someone up
+	 * if we can transition the active part of the count from 0 -> 1 */
+ try_again_read:
+	oldcount = rwsem_atomic_update(RWSEM_ACTIVE_BIAS, sem)
+						- RWSEM_ACTIVE_BIAS;
+	if (oldcount & RWSEM_ACTIVE_MASK)
+		/* Someone grabbed the sem already */
+		goto undo_read;
 
-	/* grant an infinite number of read locks to the readers at the front
-	 * of the queue
-	 * - note we increment the 'active part' of the count by the number of
-	 *   readers before waking any processes up
+ wake_readers:
+	/* Grant an infinite number of read locks to the readers at the front
+	 * of the queue.  Note we increment the 'active part' of the count by
+	 * the number of readers before waking any processes up.
 	 */
- readers_only:
 	woken = 0;
 	do {
 		woken++;
@@ -138,10 +141,14 @@ __rwsem_do_wake(struct rw_semaphore *sem
 
 	/* undo the change to the active count, but check for a transition
 	 * 1->0 */
- undo:
+ undo_write:
+	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
+		goto out;
+	goto try_again_write;
+ undo_read:
 	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
 		goto out;
-	goto try_again;
+	goto try_again_read;
 }
 
 /*
_

Patches currently in -mm which might be from walken@google.com are

x86-rwsem-stay-on-fast-path-when-count0-in-__up_write.patch
x86-rwsem-minor-cleanups.patch
rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers.patch
rwsem-lighter-active-count-checks-when-waking-up-readers.patch
rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads.patch
rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock.patch
rwsem-smaller-wrappers-around-rwsem_down_failed_common.patch

