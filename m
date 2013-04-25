From: akpm@linux-foundation.org
Subject: + ipcsem-fine-grained-locking-for-semtimedop-fix-lockdep-false-positive.patch added to -mm tree
Date: Thu, 25 Apr 2013 13:21:20 -0700
Message-ID: <20130425202120.8013B5A40F7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:63620 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab3DYUVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Apr 2013 16:21:22 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so126071vcb.5
        for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2013 13:21:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@surriel.com, peterz@infradead.org, riel@redhat.com, sasha.levin@oracle.com, sedat.dilek@gmail.com, walken@google.com


The patch titled
     Subject: ipc,sem: fix lockdep false positive
has been added to the -mm tree.  Its filename is
     ipcsem-fine-grained-locking-for-semtimedop-fix-lockdep-false-positive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: ipc,sem: fix lockdep false positive

Unfortunately the locking scheme originally proposed has false positives
with lockdep.  This can be fixed by changing the code to only ever take
one lock, and making sure that other relevant locks are not locked, before
entering a critical section.

For the "global lock" case, this is done by taking the sem_array lock,
and then (potentially) waiting for all the semaphore's spinlocks to be
unlocked.

For the "local lock" case, we wait on the sem_array's lock to be free,
before taking the semaphore local lock. To prevent races, we need to
check again after we have taken the local lock.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff -puN ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-fix-lockdep-false-positive ipc/sem.c
--- a/ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-fix-lockdep-false-positive
+++ a/ipc/sem.c
@@ -190,21 +190,26 @@ void __init sem_init (void)
 }
 
 /*
- * If the sem_array contains just one semaphore, or if multiple
- * semops are performed in one syscall, or if there are complex
- * operations pending, the whole sem_array is locked.
- * If one semop is performed on an array with multiple semaphores,
- * get a shared lock on the array, and lock the individual semaphore.
+ * If the request contains only one semaphore operation, and there are
+ * no complex transactions pending, lock only the semaphore involved.
+ * Otherwise, lock the entire semaphore array, since we either have
+ * multiple semaphores in our own semops, or we need to look at
+ * semaphores from other pending complex operations.
  *
  * Carefully guard against sma->complex_count changing between zero
  * and non-zero while we are spinning for the lock. The value of
  * sma->complex_count cannot change while we are holding the lock,
  * so sem_unlock should be fine.
+ *
+ * The global lock path checks that all the local locks have been released,
+ * checking each local lock once. This means that the local lock paths
+ * cannot start their critical sections while the global lock is held.
  */
 static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 			      int nsops)
 {
 	int locknum;
+ again:
 	if (nsops == 1 && !sma->complex_count) {
 		struct sem *sem = sma->sem_base + sops->sem_num;
 
@@ -217,17 +222,34 @@ static inline int sem_lock(struct sem_ar
 		 */
 		if (unlikely(sma->complex_count)) {
 			spin_unlock(&sem->lock);
-			goto lock_all;
+			goto lock_array;
 		}
+
+		/*
+		 * Another process is holding the global lock on the
+		 * sem_array; we cannot enter our critical section,
+		 * but have to wait for the global lock to be released.
+		 */
+		if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
+			spin_unlock(&sem->lock);
+			spin_unlock_wait(&sma->sem_perm.lock);
+			goto again;
+		}
+
 		locknum = sops->sem_num;
 	} else {
 		int i;
-		/* Lock the sem_array, and all the semaphore locks */
- lock_all:
+		/*
+		 * Lock the semaphore array, and wait for all of the
+		 * individual semaphore locks to go away.  The code
+		 * above ensures no new single-lock holders will enter
+		 * their critical section while the array lock is held.
+		 */
+ lock_array:
 		spin_lock(&sma->sem_perm.lock);
 		for (i = 0; i < sma->sem_nsems; i++) {
 			struct sem *sem = sma->sem_base + i;
-			spin_lock(&sem->lock);
+			spin_unlock_wait(&sem->lock);
 		}
 		locknum = -1;
 	}
@@ -237,11 +259,6 @@ static inline int sem_lock(struct sem_ar
 static inline void sem_unlock(struct sem_array *sma, int locknum)
 {
 	if (locknum == -1) {
-		int i;
-		for (i = 0; i < sma->sem_nsems; i++) {
-			struct sem *sem = sma->sem_base + i;
-			spin_unlock(&sem->lock);
-		}
 		spin_unlock(&sma->sem_perm.lock);
 	} else {
 		struct sem *sem = sma->sem_base + locknum;
@@ -426,7 +443,6 @@ static int newary(struct ipc_namespace *
 	for (i = 0; i < nsems; i++) {
 		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
 		spin_lock_init(&sma->sem_base[i].lock);
-		spin_lock(&sma->sem_base[i].lock);
 	}
 
 	sma->complex_count = 0;
_

Patches currently in -mm which might be from riel@surriel.com are

ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch
ipcsem-fine-grained-locking-for-semtimedop-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-untangle-rcu-locking-with-find_alloc_undo.patch
ipcsem-fine-grained-locking-for-semtimedop-do-not-call-sem_lock-when-bogus-sma.patch
ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-lockdep-false-positive.patch

