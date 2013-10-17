From: akpm@linux-foundation.org
Subject: [merged]
 ipc-semc-synchronize-semop-and-semctl-with-ipc_rmid.patch removed from -mm
 tree
Date: Thu, 17 Oct 2013 11:12:57 -0700
Message-ID: <526028a9.MJfjOHjskh5RMe9S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab3JQSM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, efault@gmx.de, davidlohr@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-semc-synchronize-semop-and-semctl-with-ipc_rmid.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr@hp.com,efault@gmx.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:57 -0700


The patch titled
     Subject: ipc/sem.c: synchronize semop and semctl with IPC_RMID
has been removed from the -mm tree.  Its filename was
     ipc-semc-synchronize-semop-and-semctl-with-ipc_rmid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: synchronize semop and semctl with IPC_RMID

After acquiring the semlock spinlock, operations must test that the array
is still valid.

- semctl() and exit_sem() would walk stale linked lists (ugly, but should
  be ok: all lists are empty)

- semtimedop() would sleep forever - and if woken up due to a signal -
  access memory after free.

The patch also:
- standardizes the tests for .deleted, so that all tests in one
  function leave the function with the same approach.
- unconditionally tests for .deleted immediately after every call to
  sem_lock - even it it means that for semctl(GETALL), .deleted will be
  tested twice.

Both changes make the review simpler: After every sem_lock, there must be
a test of .deleted, followed by a goto to the cleanup code (if the
function uses "goto cleanup").

The only exception is semctl_down(): If sem_ids().rwsem is locked, then
the presence in ids->ipcs_idr is equivalent to !.deleted, thus no
additional test is required.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Mike Galbraith <efault@gmx.de>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff -puN ipc/sem.c~ipc-semc-synchronize-semop-and-semctl-with-ipc_rmid ipc/sem.c
--- a/ipc/sem.c~ipc-semc-synchronize-semop-and-semctl-with-ipc_rmid
+++ a/ipc/sem.c
@@ -1282,6 +1282,12 @@ static int semctl_setval(struct ipc_name
 
 	sem_lock(sma, NULL, -1);
 
+	if (sma->sem_perm.deleted) {
+		sem_unlock(sma, -1);
+		rcu_read_unlock();
+		return -EIDRM;
+	}
+
 	curr = &sma->sem_base[semnum];
 
 	ipc_assert_locked_object(&sma->sem_perm);
@@ -1336,12 +1342,14 @@ static int semctl_main(struct ipc_namesp
 		int i;
 
 		sem_lock(sma, NULL, -1);
+		if (sma->sem_perm.deleted) {
+			err = -EIDRM;
+			goto out_unlock;
+		}
 		if(nsems > SEMMSL_FAST) {
 			if (!ipc_rcu_getref(sma)) {
-				sem_unlock(sma, -1);
-				rcu_read_unlock();
 				err = -EIDRM;
-				goto out_free;
+				goto out_unlock;
 			}
 			sem_unlock(sma, -1);
 			rcu_read_unlock();
@@ -1354,10 +1362,8 @@ static int semctl_main(struct ipc_namesp
 			rcu_read_lock();
 			sem_lock_and_putref(sma);
 			if (sma->sem_perm.deleted) {
-				sem_unlock(sma, -1);
-				rcu_read_unlock();
 				err = -EIDRM;
-				goto out_free;
+				goto out_unlock;
 			}
 		}
 		for (i = 0; i < sma->sem_nsems; i++)
@@ -1375,8 +1381,8 @@ static int semctl_main(struct ipc_namesp
 		struct sem_undo *un;
 
 		if (!ipc_rcu_getref(sma)) {
-			rcu_read_unlock();
-			return -EIDRM;
+			err = -EIDRM;
+			goto out_rcu_wakeup;
 		}
 		rcu_read_unlock();
 
@@ -1404,10 +1410,8 @@ static int semctl_main(struct ipc_namesp
 		rcu_read_lock();
 		sem_lock_and_putref(sma);
 		if (sma->sem_perm.deleted) {
-			sem_unlock(sma, -1);
-			rcu_read_unlock();
 			err = -EIDRM;
-			goto out_free;
+			goto out_unlock;
 		}
 
 		for (i = 0; i < nsems; i++)
@@ -1431,6 +1435,10 @@ static int semctl_main(struct ipc_namesp
 		goto out_rcu_wakeup;
 
 	sem_lock(sma, NULL, -1);
+	if (sma->sem_perm.deleted) {
+		err = -EIDRM;
+		goto out_unlock;
+	}
 	curr = &sma->sem_base[semnum];
 
 	switch (cmd) {
@@ -1836,6 +1844,10 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	if (error)
 		goto out_rcu_wakeup;
 
+	error = -EIDRM;
+	locknum = sem_lock(sma, sops, nsops);
+	if (sma->sem_perm.deleted)
+		goto out_unlock_free;
 	/*
 	 * semid identifiers are not unique - find_alloc_undo may have
 	 * allocated an undo structure, it was invalidated by an RMID
@@ -1843,8 +1855,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	 * This case can be detected checking un->semid. The existence of
 	 * "un" itself is guaranteed by rcu.
 	 */
-	error = -EIDRM;
-	locknum = sem_lock(sma, sops, nsops);
 	if (un && un->semid == -1)
 		goto out_unlock_free;
 
@@ -2057,6 +2067,12 @@ void exit_sem(struct task_struct *tsk)
 		}
 
 		sem_lock(sma, NULL, -1);
+		/* exit_sem raced with IPC_RMID, nothing to do */
+		if (sma->sem_perm.deleted) {
+			sem_unlock(sma, -1);
+			rcu_read_unlock();
+			continue;
+		}
 		un = __lookup_undo(ulp, semid);
 		if (un == NULL) {
 			/* exit_sem raced with IPC_RMID+semget() that created
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch

