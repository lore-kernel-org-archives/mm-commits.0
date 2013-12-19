From: akpm@linux-foundation.org
Subject: +
 ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races.patch
 added to -mm tree
Date: Thu, 19 Dec 2013 14:13:59 -0800
Message-ID: <52b36fa7.BK0loiqH3IPk//Gn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3LSWOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 17:14:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, gthelen@google.com, davidlohr@hp.com, aquini@redhat.com

Subject: + ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races.patch added to -mm tree
To: aquini@redhat.com,davidlohr@hp.com,gthelen@google.com,manfred@colorfullife.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 14:13:59 -0800


The patch titled
     Subject: ipc: introduce ipc_valid_object() helper to sort out IPC_RMID races
has been added to the -mm tree.  Its filename is
     ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: ipc: introduce ipc_valid_object() helper to sort out IPC_RMID races

After the locking semantics for the SysV IPC API got improved, a couple of
IPC_RMID race windows were opened because we ended up dropping the
'kern_ipc_perm.deleted' check performed way down in ipc_lock().  The
spotted races got sorted out by re-introducing the old test within the
racy critical sections.

This patch introduces ipc_valid_object() to consolidate the way we cope
with IPC_RMID races by using the same abstraction across the API
implementation.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    7 ++++---
 ipc/sem.c  |   24 ++++++++++++++++--------
 ipc/shm.c  |   16 ++++++++--------
 ipc/util.h |   13 +++++++++++++
 4 files changed, 41 insertions(+), 19 deletions(-)

diff -puN ipc/msg.c~ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races ipc/msg.c
--- a/ipc/msg.c~ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races
+++ a/ipc/msg.c
@@ -696,7 +696,7 @@ long do_msgsnd(int msqid, long mtype, vo
 			goto out_unlock0;
 
 		/* raced with RMID? */
-		if (msq->q_perm.deleted) {
+		if (!ipc_valid_object(&msq->q_perm)) {
 			err = -EIDRM;
 			goto out_unlock0;
 		}
@@ -731,7 +731,8 @@ long do_msgsnd(int msqid, long mtype, vo
 		ipc_lock_object(&msq->q_perm);
 
 		ipc_rcu_putref(msq, ipc_rcu_free);
-		if (msq->q_perm.deleted) {
+		/* raced with RMID? */
+		if (!ipc_valid_object(&msq->q_perm)) {
 			err = -EIDRM;
 			goto out_unlock0;
 		}
@@ -909,7 +910,7 @@ long do_msgrcv(int msqid, void __user *b
 		ipc_lock_object(&msq->q_perm);
 
 		/* raced with RMID? */
-		if (msq->q_perm.deleted) {
+		if (!ipc_valid_object(&msq->q_perm)) {
 			msg = ERR_PTR(-EIDRM);
 			goto out_unlock0;
 		}
diff -puN ipc/sem.c~ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races ipc/sem.c
--- a/ipc/sem.c~ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races
+++ a/ipc/sem.c
@@ -1284,7 +1284,7 @@ static int semctl_setval(struct ipc_name
 
 	sem_lock(sma, NULL, -1);
 
-	if (sma->sem_perm.deleted) {
+	if (!ipc_valid_object(&sma->sem_perm)) {
 		sem_unlock(sma, -1);
 		rcu_read_unlock();
 		return -EIDRM;
@@ -1344,7 +1344,7 @@ static int semctl_main(struct ipc_namesp
 		int i;
 
 		sem_lock(sma, NULL, -1);
-		if (sma->sem_perm.deleted) {
+		if (!ipc_valid_object(&sma->sem_perm)) {
 			err = -EIDRM;
 			goto out_unlock;
 		}
@@ -1363,7 +1363,7 @@ static int semctl_main(struct ipc_namesp
 
 			rcu_read_lock();
 			sem_lock_and_putref(sma);
-			if (sma->sem_perm.deleted) {
+			if (!ipc_valid_object(&sma->sem_perm)) {
 				err = -EIDRM;
 				goto out_unlock;
 			}
@@ -1411,7 +1411,7 @@ static int semctl_main(struct ipc_namesp
 		}
 		rcu_read_lock();
 		sem_lock_and_putref(sma);
-		if (sma->sem_perm.deleted) {
+		if (!ipc_valid_object(&sma->sem_perm)) {
 			err = -EIDRM;
 			goto out_unlock;
 		}
@@ -1437,7 +1437,7 @@ static int semctl_main(struct ipc_namesp
 		goto out_rcu_wakeup;
 
 	sem_lock(sma, NULL, -1);
-	if (sma->sem_perm.deleted) {
+	if (!ipc_valid_object(&sma->sem_perm)) {
 		err = -EIDRM;
 		goto out_unlock;
 	}
@@ -1701,7 +1701,7 @@ static struct sem_undo *find_alloc_undo(
 	/* step 3: Acquire the lock on semaphore array */
 	rcu_read_lock();
 	sem_lock_and_putref(sma);
-	if (sma->sem_perm.deleted) {
+	if (!ipc_valid_object(&sma->sem_perm)) {
 		sem_unlock(sma, -1);
 		rcu_read_unlock();
 		kfree(new);
@@ -1848,7 +1848,15 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 
 	error = -EIDRM;
 	locknum = sem_lock(sma, sops, nsops);
-	if (sma->sem_perm.deleted)
+	/*
+	 * We eventually might perform the following check in a lockless
+	 * fashion, considering ipc_valid_object() locking constraints.
+	 * If nsops == 1 and there is no contention for sem_perm.lock, then
+	 * only a per-semaphore lock is held and it's OK to proceed with the
+	 * check below. More details on the fine grained locking scheme
+	 * entangled here and why it's RMID race safe on comments at sem_lock()
+	 */
+	if (!ipc_valid_object(&sma->sem_perm))
 		goto out_unlock_free;
 	/*
 	 * semid identifiers are not unique - find_alloc_undo may have
@@ -2070,7 +2078,7 @@ void exit_sem(struct task_struct *tsk)
 
 		sem_lock(sma, NULL, -1);
 		/* exit_sem raced with IPC_RMID, nothing to do */
-		if (sma->sem_perm.deleted) {
+		if (!ipc_valid_object(&sma->sem_perm)) {
 			sem_unlock(sma, -1);
 			rcu_read_unlock();
 			continue;
diff -puN ipc/shm.c~ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races ipc/shm.c
--- a/ipc/shm.c~ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races
+++ a/ipc/shm.c
@@ -975,6 +975,13 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 			goto out_unlock1;
 
 		ipc_lock_object(&shp->shm_perm);
+
+		/* check if shm_destroy() is tearing down shp */
+		if (!ipc_valid_object(&shp->shm_perm)) {
+			err = -EIDRM;
+			goto out_unlock0;
+		}
+
 		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
 			kuid_t euid = current_euid();
 			if (!uid_eq(euid, shp->shm_perm.uid) &&
@@ -989,13 +996,6 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 		}
 
 		shm_file = shp->shm_file;
-
-		/* check if shm_destroy() is tearing down shp */
-		if (shm_file == NULL) {
-			err = -EIDRM;
-			goto out_unlock0;
-		}
-
 		if (is_file_hugepages(shm_file))
 			goto out_unlock0;
 
@@ -1116,7 +1116,7 @@ long do_shmat(int shmid, char __user *sh
 	ipc_lock_object(&shp->shm_perm);
 
 	/* check if shm_destroy() is tearing down shp */
-	if (shp->shm_file == NULL) {
+	if (!ipc_valid_object(&shp->shm_perm)) {
 		ipc_unlock_object(&shp->shm_perm);
 		err = -EIDRM;
 		goto out_unlock;
diff -puN ipc/util.h~ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races ipc/util.h
--- a/ipc/util.h~ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races
+++ a/ipc/util.h
@@ -185,6 +185,19 @@ static inline void ipc_unlock(struct ker
 	rcu_read_unlock();
 }
 
+/*
+ * ipc_valid_object() - helper to sort out IPC_RMID races for codepaths
+ * where the respective ipc_ids.rwsem is not being held down.
+ * Checks whether the ipc object is still around or if it's gone already, as
+ * ipc_rmid() may have already freed the ID while the ipc lock was spinning.
+ * Needs to be called with kern_ipc_perm.lock held -- exception made for one
+ * checkpoint case at sys_semtimedop() as noted in code commentary.
+ */
+static inline bool ipc_valid_object(struct kern_ipc_perm *perm)
+{
+	return perm->deleted == 0;
+}
+
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
_

Patches currently in -mm which might be from aquini@redhat.com are

origin.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races.patch

