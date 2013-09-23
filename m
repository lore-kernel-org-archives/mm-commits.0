From: akpm@linux-foundation.org
Subject: + ipc-semc-fix-race-in-sem_lock.patch added to -mm tree
Date: Mon, 23 Sep 2013 14:07:32 -0700
Message-ID: <5240ad94.zcSH7IHqLQsoPnqJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3IWVHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 17:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, davidlohr.bueso@hp.com, bitbucket@online.de, manfred@colorfullife.com

Subject: + ipc-semc-fix-race-in-sem_lock.patch added to -mm tree
To: manfred@colorfullife.com,bitbucket@online.de,davidlohr.bueso@hp.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 14:07:32 -0700


The patch titled
     Subject: ipc/sem.c: fix race in sem_lock()
has been added to the -mm tree.  Its filename is
     ipc-semc-fix-race-in-sem_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-fix-race-in-sem_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-fix-race-in-sem_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: fix race in sem_lock()

The exclusion of complex operations in sem_lock() is insufficient: After
acquiring the per-semaphore lock, a simple op must first check that
sem_perm.lock is not locked and only after that test check complex_count. 
The current code does it the other way around - and that creates a race. 
Details are below.

The patch is a complete rewrite of sem_lock(), based in part on the code
from Mike Galbraith.  It removes all gotos and all loops and thus the risk
of livelocks.

I have tested the patch (together with the next one) on my i3 laptop and
it didn't cause any problems.

The bug is probably also present in 3.10 and 3.11, but for these kernels
it might be simpler just to move the test of sma->complex_count after the
spin_is_locked() test.

Details of the bug:

Assume:
- sma->complex_count = 0.
- Thread 1: semtimedop(complex op that must sleep)
- Thread 2: semtimedop(simple op).

Pseudo-Trace:

Thread 1: sem_lock(): acquire sem_perm.lock
Thread 1: sem_lock(): check for ongoing simple ops
			Nothing ongoing, thread 2 is still before sem_lock().
Thread 1: try_atomic_semop()
	<<< preempted.

Thread 2: sem_lock():
        static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
                                      int nsops)
        {
                int locknum;
         again:
                if (nsops == 1 && !sma->complex_count) {
                        struct sem *sem = sma->sem_base + sops->sem_num;

                        /* Lock just the semaphore we are interested in. */
                        spin_lock(&sem->lock);

                        /*
                         * If sma->complex_count was set while we were spinning,
                         * we may need to look at things we did not lock here.
                         */
                        if (unlikely(sma->complex_count)) {
                                spin_unlock(&sem->lock);
                                goto lock_array;
                        }
        <<<<<<<<<
	<<< complex_count is still 0.
	<<<
        <<< Here it is preempted
        <<<<<<<<<

Thread 1: try_atomic_semop() returns, notices that it must sleep.
Thread 1: increases sma->complex_count.
Thread 1: drops sem_perm.lock
Thread 2:
                /*
                 * Another process is holding the global lock on the
                 * sem_array; we cannot enter our critical section,
                 * but have to wait for the global lock to be released.
                 */
                if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
                        spin_unlock(&sem->lock);
                        spin_unlock_wait(&sma->sem_perm.lock);
                        goto again;
                }
	<<< sem_perm.lock already dropped, thus no "goto again;"

                locknum = sops->sem_num;

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |  122 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 78 insertions(+), 44 deletions(-)

diff -puN ipc/sem.c~ipc-semc-fix-race-in-sem_lock ipc/sem.c
--- a/ipc/sem.c~ipc-semc-fix-race-in-sem_lock
+++ a/ipc/sem.c
@@ -244,70 +244,104 @@ static void merge_queues(struct sem_arra
 }
 
 /*
+ * Wait until all currently ongoing simple ops have completed.
+ * Caller must own sem_perm.lock.
+ * New simple ops cannot start, because simple ops first check
+ * that sem_perm.lock is free.
+ */
+static void sem_wait_array(struct sem_array *sma)
+{
+	int i;
+	struct sem *sem;
+
+	for (i = 0; i < sma->sem_nsems; i++) {
+		sem = sma->sem_base + i;
+		spin_unlock_wait(&sem->lock);
+	}
+}
+
+/*
  * If the request contains only one semaphore operation, and there are
  * no complex transactions pending, lock only the semaphore involved.
  * Otherwise, lock the entire semaphore array, since we either have
  * multiple semaphores in our own semops, or we need to look at
  * semaphores from other pending complex operations.
- *
- * Carefully guard against sma->complex_count changing between zero
- * and non-zero while we are spinning for the lock. The value of
- * sma->complex_count cannot change while we are holding the lock,
- * so sem_unlock should be fine.
- *
- * The global lock path checks that all the local locks have been released,
- * checking each local lock once. This means that the local lock paths
- * cannot start their critical sections while the global lock is held.
  */
 static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 			      int nsops)
 {
-	int locknum;
- again:
-	if (nsops == 1 && !sma->complex_count) {
-		struct sem *sem = sma->sem_base + sops->sem_num;
+	struct sem *sem;
 
-		/* Lock just the semaphore we are interested in. */
-		spin_lock(&sem->lock);
+	if (nsops != 1) {
+		/* Complex operation - acquire a full lock */
+		ipc_lock_object(&sma->sem_perm);
 
-		/*
-		 * If sma->complex_count was set while we were spinning,
-		 * we may need to look at things we did not lock here.
+		/* And wait until all simple ops that are processed
+		 * right now have dropped their locks.
 		 */
-		if (unlikely(sma->complex_count)) {
-			spin_unlock(&sem->lock);
-			goto lock_array;
-		}
+		sem_wait_array(sma);
+		return -1;
+	}
+
+	/*
+	 * Only one semaphore affected - try to optimize locking.
+	 * The rules are:
+	 * - optimized locking is possible if no complex operation
+	 *   is either enqueued or processed right now.
+	 * - The test for enqueued complex ops is simple:
+	 *      sma->complex_count != 0
+	 * - Testing for complex ops that are processed right now is
+	 *   a bit more difficult. Complex ops acquire the full lock
+	 *   and first wait that the running simple ops have completed.
+	 *   (see above)
+	 *   Thus: If we own a simple lock and the global lock is free
+	 *	and complex_count is now 0, then it will stay 0 and
+	 *	thus just locking sem->lock is sufficient.
+	 */
+	sem = sma->sem_base + sops->sem_num;
 
+	if (sma->complex_count == 0) {
 		/*
-		 * Another process is holding the global lock on the
-		 * sem_array; we cannot enter our critical section,
-		 * but have to wait for the global lock to be released.
+		 * It appears that no complex operation is around.
+		 * Acquire the per-semaphore lock.
 		 */
-		if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
-			spin_unlock(&sem->lock);
-			spin_unlock_wait(&sma->sem_perm.lock);
-			goto again;
+		spin_lock(&sem->lock);
+
+		/* Then check that the global lock is free */
+		if (!spin_is_locked(&sma->sem_perm.lock)) {
+			/* spin_is_locked() is not a memory barrier */
+			smp_mb();
+
+			/* Now repeat the test of complex_count:
+			 * It can't change anymore until we drop sem->lock.
+			 * Thus: if is now 0, then it will stay 0.
+			 */
+			if (sma->complex_count == 0) {
+				/* fast path successful! */
+				return sops->sem_num;
+			}
 		}
+		spin_unlock(&sem->lock);
+	}
+
+	/* slow path: acquire the full lock */
+	ipc_lock_object(&sma->sem_perm);
 
-		locknum = sops->sem_num;
+	if (sma->complex_count == 0) {
+		/* False alarm:
+		 * There is no complex operation, thus we can switch
+		 * back to the fast path.
+		 */
+		spin_lock(&sem->lock);
+		ipc_unlock_object(&sma->sem_perm);
+		return sops->sem_num;
 	} else {
-		int i;
-		/*
-		 * Lock the semaphore array, and wait for all of the
-		 * individual semaphore locks to go away.  The code
-		 * above ensures no new single-lock holders will enter
-		 * their critical section while the array lock is held.
+		/* Not a false alarm, thus complete the sequence for a
+		 * full lock.
 		 */
- lock_array:
-		ipc_lock_object(&sma->sem_perm);
-		for (i = 0; i < sma->sem_nsems; i++) {
-			struct sem *sem = sma->sem_base + i;
-			spin_unlock_wait(&sem->lock);
-		}
-		locknum = -1;
+		sem_wait_array(sma);
+		return -1;
 	}
-	return locknum;
 }
 
 static inline void sem_unlock(struct sem_array *sma, int locknum)
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-fix-race-in-sem_lock.patch
ipc-semc-optimize-sem_lock.patch
slab-leaks3-default-y.patch

