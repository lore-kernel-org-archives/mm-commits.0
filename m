From: akpm@linux-foundation.org
Subject: + ipc-semc-fix-complex_count-vs-simple-op-race.patch added to -mm tree
Date: Mon, 04 Jan 2016 14:20:54 -0800
Message-ID: <568af046.VjlUgXSYzfyDtvLK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbcADWUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2016 17:20:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, dave@stgolabs.net, felixh@informatik.uni-bremen.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: Fix complex_count vs. simple op race
has been added to the -mm tree.  Its filename is
     ipc-semc-fix-complex_count-vs-simple-op-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-fix-complex_count-vs-simple-op-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-fix-complex_count-vs-simple-op-race.patch

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
Subject: ipc/sem.c: Fix complex_count vs. simple op race

Commit 6d07b68ce16a ("ipc/sem.c: optimize sem_lock()") introduced a race:

sem_lock has a fast path that allows parallel simple operations.
There are two reasons why a simple operation cannot run in parallel:

- a non-simple operations is ongoing (sma->sem_perm.lock held)
- a complex operation is sleeping (sma->complex_count != 0)

As both facts are stored independently, a thread can bypass the current
checks by sleeping in the right positions.  See below for more details (or
kernel bugzilla 105651).

The patch fixes that by creating one variable (complex_mode) that tracks
both reasons why parallel operations are not possible.

The patch also updates stale documentation regarding the locking.

With regards to stable kernels:
The patch is required for all kernels that include the commit 6d07b68ce16a
("ipc/sem.c: optimize sem_lock()") (3.10?)

The alternative is to revert the patch that introduced the race.

Background:
Here is the race of the current implementation:

Thread A: (simple op)
- does the first "sma->complex_count == 0" test

Thread B: (complex op)
- does sem_lock(): This includes an array scan. But the scan can't
  find Thread A, because Thread A does not own sem->lock yet.
- the thread does the operation, increases complex_count,
  drops sem_lock, sleeps

Thread A:
- spin_lock(&sem->lock), spin_is_locked(sma->sem_perm.lock)
- sleeps before the complex_count test

Thread C: (complex op)
- does sem_lock (no array scan, complex_count==1)
- wakes up Thread B.
- decrements complex_count

Thread A:
- does the complex_count test

Bug:
Now both thread A and thread C operate on the same array, without
any synchronization.

Fixes: 6d07b68ce16a ("ipc/sem.c: optimize sem_lock()")
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reported-by: <felixh@informatik.uni-bremen.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |    1 
 ipc/sem.c           |  124 ++++++++++++++++++++++++------------------
 2 files changed, 72 insertions(+), 53 deletions(-)

diff -puN include/linux/sem.h~ipc-semc-fix-complex_count-vs-simple-op-race include/linux/sem.h
--- a/include/linux/sem.h~ipc-semc-fix-complex_count-vs-simple-op-race
+++ a/include/linux/sem.h
@@ -21,6 +21,7 @@ struct sem_array {
 	struct list_head	list_id;	/* undo requests on this array */
 	int			sem_nsems;	/* no. of semaphores in array */
 	int			complex_count;	/* pending complex operations */
+	bool			complex_mode;	/* no parallel simple ops */
 };
 
 #ifdef CONFIG_SYSVIPC
diff -puN ipc/sem.c~ipc-semc-fix-complex_count-vs-simple-op-race ipc/sem.c
--- a/ipc/sem.c~ipc-semc-fix-complex_count-vs-simple-op-race
+++ a/ipc/sem.c
@@ -155,14 +155,21 @@ static int sysvipc_sem_proc_show(struct
 
 /*
  * Locking:
+ * a) global sem_lock() for read/write
  *	sem_undo.id_next,
  *	sem_array.complex_count,
- *	sem_array.pending{_alter,_cont},
- *	sem_array.sem_undo: global sem_lock() for read/write
- *	sem_undo.proc_next: only "current" is allowed to read/write that field.
+ *	sem_array.complex_mode
+ *	sem_array.pending{_alter,_const},
+ *	sem_array.sem_undo
  *
+ * b) global or semaphore sem_lock() for read/write:
  *	sem_array.sem_base[i].pending_{const,alter}:
- *		global or semaphore sem_lock() for read/write
+ *	sem_array.complex_mode (for read)
+ *
+ * c) special:
+ *	sem_undo_list.list_proc:
+ *	* undo_list->lock for write
+ *	* rcu for read
  */
 
 #define sc_semmsl	sem_ctls[0]
@@ -263,23 +270,25 @@ static void sem_rcu_free(struct rcu_head
 #define ipc_smp_acquire__after_spin_is_unlocked()	smp_rmb()
 
 /*
- * Wait until all currently ongoing simple ops have completed.
+ * Enter the mode suitable for non-simple operations:
  * Caller must own sem_perm.lock.
- * New simple ops cannot start, because simple ops first check
- * that sem_perm.lock is free.
- * that a) sem_perm.lock is free and b) complex_count is 0.
  */
-static void sem_wait_array(struct sem_array *sma)
+static void complexmode_enter(struct sem_array *sma)
 {
 	int i;
 	struct sem *sem;
 
-	if (sma->complex_count)  {
-		/* The thread that increased sma->complex_count waited on
-		 * all sem->lock locks. Thus we don't need to wait again.
-		 */
+	if (sma->complex_mode)  {
+		/* We are already in complex_mode. Nothing to do */
 		return;
 	}
+	WRITE_ONCE(sma->complex_mode, true);
+
+	/* We need a full barrier:
+	 * The write to complex_mode must be visible
+	 * before we read the first sem->lock spinlock state.
+	 */
+	smp_mb();
 
 	for (i = 0; i < sma->sem_nsems; i++) {
 		sem = sma->sem_base + i;
@@ -289,6 +298,29 @@ static void sem_wait_array(struct sem_ar
 }
 
 /*
+ * Try to leave the mode that disallows simple operations:
+ * Caller must own sem_perm.lock.
+ */
+static void complexmode_tryleave(struct sem_array *sma)
+{
+	if (sma->complex_count)  {
+		/* Complex ops are sleeping.
+		 * We must stay in complex mode
+		 */
+		return;
+	}
+	/*
+	 * Immediately after setting complex_mode to false,
+	 * a simple op can start. Thus: all memory writes
+	 * performed by the current operation must be visible
+	 * before we set complex_mode to false.
+	 */
+	smp_wmb();
+
+	WRITE_ONCE(sma->complex_mode, false);
+}
+
+/*
  * If the request contains only one semaphore operation, and there are
  * no complex transactions pending, lock only the semaphore involved.
  * Otherwise, lock the entire semaphore array, since we either have
@@ -304,56 +336,38 @@ static inline int sem_lock(struct sem_ar
 		/* Complex operation - acquire a full lock */
 		ipc_lock_object(&sma->sem_perm);
 
-		/* And wait until all simple ops that are processed
-		 * right now have dropped their locks.
-		 */
-		sem_wait_array(sma);
+		/* Prevent parallel simple ops */
+		complexmode_enter(sma);
 		return -1;
 	}
 
 	/*
 	 * Only one semaphore affected - try to optimize locking.
-	 * The rules are:
-	 * - optimized locking is possible if no complex operation
-	 *   is either enqueued or processed right now.
-	 * - The test for enqueued complex ops is simple:
-	 *      sma->complex_count != 0
-	 * - Testing for complex ops that are processed right now is
-	 *   a bit more difficult. Complex ops acquire the full lock
-	 *   and first wait that the running simple ops have completed.
-	 *   (see above)
-	 *   Thus: If we own a simple lock and the global lock is free
-	 *	and complex_count is now 0, then it will stay 0 and
-	 *	thus just locking sem->lock is sufficient.
+	 * Optimized locking is possible if no complex operation
+	 * is either enqueued or processed right now.
+	 *
+	 * Both facts are tracked by complex_mode.
 	 */
 	sem = sma->sem_base + sops->sem_num;
 
-	if (sma->complex_count == 0) {
+	/*
+	 * Initial check for complex_mode. Just an optimization,
+	 * no locking.
+	 */
+	if (!READ_ONCE(sma->complex_mode)) {
 		/*
 		 * It appears that no complex operation is around.
 		 * Acquire the per-semaphore lock.
 		 */
 		spin_lock(&sem->lock);
 
-		/* Then check that the global lock is free */
-		if (!spin_is_locked(&sma->sem_perm.lock)) {
-			/*
-			 * We need a memory barrier with acquire semantics,
-			 * otherwise we can race with another thread that does:
-			 *	complex_count++;
-			 *	spin_unlock(sem_perm.lock);
-			 */
-			ipc_smp_acquire__after_spin_is_unlocked();
-
-			/*
-			 * Now repeat the test of complex_count:
-			 * It can't change anymore until we drop sem->lock.
-			 * Thus: if is now 0, then it will stay 0.
-			 */
-			if (sma->complex_count == 0) {
-				/* fast path successful! */
-				return sops->sem_num;
-			}
+		/* Now repeat the test for complex_mode.
+		 * A memory barrier is provided by the spin_lock()
+		 * above.
+		 */
+		if (!READ_ONCE(sma->complex_mode)) {
+			/* fast path successful! */
+			return sops->sem_num;
 		}
 		spin_unlock(&sem->lock);
 	}
@@ -373,7 +387,7 @@ static inline int sem_lock(struct sem_ar
 		/* Not a false alarm, thus complete the sequence for a
 		 * full lock.
 		 */
-		sem_wait_array(sma);
+		complexmode_enter(sma);
 		return -1;
 	}
 }
@@ -382,6 +396,7 @@ static inline void sem_unlock(struct sem
 {
 	if (locknum == -1) {
 		unmerge_queues(sma);
+		complexmode_tryleave(sma);
 		ipc_unlock_object(&sma->sem_perm);
 	} else {
 		struct sem *sem = sma->sem_base + locknum;
@@ -533,6 +548,7 @@ static int newary(struct ipc_namespace *
 	}
 
 	sma->complex_count = 0;
+	sma->complex_mode = true; /* dropped by sem_unlock below */
 	INIT_LIST_HEAD(&sma->pending_alter);
 	INIT_LIST_HEAD(&sma->pending_const);
 	INIT_LIST_HEAD(&sma->list_id);
@@ -2186,10 +2202,10 @@ static int sysvipc_sem_proc_show(struct
 	/*
 	 * The proc interface isn't aware of sem_lock(), it calls
 	 * ipc_lock_object() directly (in sysvipc_find_ipc).
-	 * In order to stay compatible with sem_lock(), we must wait until
-	 * all simple semop() calls have left their critical regions.
+	 * In order to stay compatible with sem_lock(), we must
+	 * enter / leave complex_mode.
 	 */
-	sem_wait_array(sma);
+	complexmode_enter(sma);
 
 	sem_otime = get_semotime(sma);
 
@@ -2206,6 +2222,8 @@ static int sysvipc_sem_proc_show(struct
 		   sem_otime,
 		   sma->sem_ctime);
 
+	complexmode_tryleave(sma);
+
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-fix-complex_count-vs-simple-op-race.patch

