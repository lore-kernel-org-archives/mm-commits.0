From: akpm@linux-foundation.org
Subject: + ipc-semc-rewrite-undo-list-locking.patch added to -mm tree
Date: Mon, 02 Jun 2008 14:52:55 -0700
Message-ID: <200806022152.m52Lquiw001818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbYFBVyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 17:54:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, Nadia.Derbey@bull.net, peifferp@gmail.com


The patch titled
     ipc/sem.c: rewrite undo list locking
has been added to the -mm tree.  Its filename is
     ipc-semc-rewrite-undo-list-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/sem.c: rewrite undo list locking
From: Manfred Spraul <manfred@colorfullife.com>

The attached patch:
- reverses the locking order of ulp->lock and sem_lock:
  Previously, it was first ulp->lock, then inside sem_lock.
  Now it's the other way around.
- converts the undo structure to rcu.

Benefits:
- With the old locking order, IPC_RMID could not kfree the undo structures.
  The stale entries remained in the linked lists and were released later.
- The patch fixes a a race in semtimedop(): if both IPC_RMID and a semget() that
  recreates exactly the same id happen between find_alloc_undo() and sem_lock,
  then semtimedop() would access already kfree'd memory.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |    6 +
 ipc/sem.c           |  145 ++++++++++++++++++++++++++----------------
 2 files changed, 96 insertions(+), 55 deletions(-)

diff -puN include/linux/sem.h~ipc-semc-rewrite-undo-list-locking include/linux/sem.h
--- a/include/linux/sem.h~ipc-semc-rewrite-undo-list-locking
+++ a/include/linux/sem.h
@@ -78,6 +78,7 @@ struct  seminfo {
 
 #ifdef __KERNEL__
 #include <asm/atomic.h>
+#include <linux/rcupdate.h>
 
 struct task_struct;
 
@@ -114,7 +115,10 @@ struct sem_queue {
  * when the process exits.
  */
 struct sem_undo {
-	struct list_head	list_proc;	/* per-process list: all undos from one process */
+	struct list_head	list_proc;	/* per-process list: all undos from one process. */
+						/* rcu protected */
+	struct rcu_head		rcu;		/* rcu struct for sem_undo() */
+	struct sem_undo_list	*ulp;		/* sem_undo_list for the process */
 	struct list_head	list_id;	/* per semaphore array list: all undos for one array */
 	int			semid;		/* semaphore set identifier */
 	short *			semadj;		/* array of adjustments, one per semaphore */
diff -puN ipc/sem.c~ipc-semc-rewrite-undo-list-locking ipc/sem.c
--- a/ipc/sem.c~ipc-semc-rewrite-undo-list-locking
+++ a/ipc/sem.c
@@ -504,27 +504,35 @@ static int count_semzcnt (struct sem_arr
 	return semzcnt;
 }
 
+void free_un(struct rcu_head *head)
+{
+	struct sem_undo *un = container_of(head, struct sem_undo, rcu);
+	kfree(un);
+}
+
 /* Free a semaphore set. freeary() is called with sem_ids.rw_mutex locked
  * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
  * remains locked on exit.
  */
 static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 {
-	struct sem_undo *un;
-	struct sem_queue *q, *t;
+	struct sem_undo *un, *tu;
+	struct sem_queue *q, *tq;
 	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
 
-	/* Invalidate the existing undo structures for this semaphore set.
-	 * (They will be freed without any further action in exit_sem()
-	 * or during the next semop.)
-	 */
+	/* Free the existing undo structures for this semaphore set.  */
 	assert_spin_locked(&sma->sem_perm.lock);
-	list_for_each_entry(un, &sma->list_id, list_id)
+	list_for_each_entry_safe(un, tu, &sma->list_id, list_id) {
+		list_del(&un->list_id);
+		spin_lock(&un->ulp->lock);
 		un->semid = -1;
+		list_del_rcu(&un->list_proc);
+		spin_unlock(&un->ulp->lock);
+		call_rcu(&un->rcu, free_un);
+	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
-
-	list_for_each_entry_safe(q, t, &sma->sem_pending, list) {
+	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
 		list_del(&q->list);
 
 		q->status = IN_WAKEUP;
@@ -948,16 +956,11 @@ static inline int get_undo_list(struct s
 
 static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, int semid)
 {
-	struct sem_undo *walk, *tmp;
+	struct sem_undo *walk;
 
-	assert_spin_locked(&ulp->lock);
-	list_for_each_entry_safe(walk, tmp, &ulp->list_proc, list_proc) {
+	list_for_each_entry_rcu(walk, &ulp->list_proc, list_proc) {
 		if (walk->semid == semid)
 			return walk;
-		if (walk->semid == -1) {
-			list_del(&walk->list_proc);
-			kfree(walk);
-		}
 	}
 	return NULL;
 }
@@ -970,6 +973,8 @@ static struct sem_undo *lookup_undo(stru
  * The function looks up (and if not present creates) the undo structure.
  * The size of the undo structure depends on the size of the semaphore
  * array, thus the alloc path is not that straightforward.
+ * Lifetime-rules: sem_undo is rcu-protected, on success, the function
+ * performs a rcu_read_lock().
  */
 static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 {
@@ -983,11 +988,13 @@ static struct sem_undo *find_alloc_undo(
 	if (error)
 		return ERR_PTR(error);
 
+	rcu_read_lock();
 	spin_lock(&ulp->lock);
 	un = lookup_undo(ulp, semid);
 	spin_unlock(&ulp->lock);
 	if (likely(un!=NULL))
 		goto out;
+	rcu_read_unlock();
 
 	/* no undo structure around - allocate one. */
 	/* step 1: figure out the size of the semaphore array */
@@ -1005,38 +1012,36 @@ static struct sem_undo *find_alloc_undo(
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/* step 3: Acquire the lock on the undo list pointer */
-	spin_lock(&ulp->lock);
-
-	/* step 4: check for races: someone else allocated the undo struct,
-	 *         semaphore array was destroyed.
-	 */
-	un = lookup_undo(ulp, semid);
-	if (un) {
-		spin_unlock(&ulp->lock);
-		kfree(new);
-		sem_putref(sma);
-		goto out;
-	}
+	/* step 3: Acquire the lock on semaphore array */
 	sem_lock_and_putref(sma);
 	if (sma->sem_perm.deleted) {
 		sem_unlock(sma);
-		spin_unlock(&ulp->lock);
 		kfree(new);
 		un = ERR_PTR(-EIDRM);
 		goto out;
 	}
+	spin_lock(&ulp->lock);
+
+	/* step 4: check for races: did someone else allocate the undo struct? */
+	un = lookup_undo(ulp, semid);
+	if (un) {
+		kfree(new);
+		goto success;
+	}
 	/* step 5: initialize & link new undo structure */
 	new->semadj = (short *) &new[1];
+	new->ulp = ulp;
 	new->semid = semid;
 	assert_spin_locked(&ulp->lock);
-	list_add(&new->list_proc, &ulp->list_proc);
+	list_add_rcu(&new->list_proc, &ulp->list_proc);
 	assert_spin_locked(&sma->sem_perm.lock);
 	list_add(&new->list_id, &sma->list_id);
+	un = new;
 
-	sem_unlock(sma);
+success:
 	spin_unlock(&ulp->lock);
-	un = new;
+	rcu_read_lock();
+	sem_unlock(sma);
 out:
 	return un;
 }
@@ -1103,6 +1108,8 @@ asmlinkage long sys_semtimedop(int semid
 
 	sma = sem_lock_check(ns, semid);
 	if (IS_ERR(sma)) {
+		if (un)
+			rcu_read_unlock();
 		error = PTR_ERR(sma);
 		goto out_free;
 	}
@@ -1111,10 +1118,26 @@ asmlinkage long sys_semtimedop(int semid
 	 * semid identifiers are not unique - find_alloc_undo may have
 	 * allocated an undo structure, it was invalidated by an RMID
 	 * and now a new array with received the same id. Check and fail.
+	 * This case can be detected checking un->semid. The existance of
+	 * "un" itself is guaranteed by rcu.
 	 */
 	error = -EIDRM;
-	if (un && un->semid == -1)
-		goto out_unlock_free;
+	if (un) {
+		if(un->semid == -1) {
+			rcu_read_unlock();
+			goto out_unlock_free;
+		} else {
+			/*
+			 * rcu lock can be released, "un" cannot disappear:
+			 * - sem_lock is acquired, thus IPC_RMID is
+			 *   impossible.
+			 * - exit_sem is impossible, it always operates on
+			 *   current (or a dead task).
+			 */
+
+			rcu_read_unlock();
+		}
+	}
 
 	error = -EFBIG;
 	if (max >= sma->sem_nsems)
@@ -1242,7 +1265,6 @@ int copy_semundo(unsigned long clone_fla
 void exit_sem(struct task_struct *tsk)
 {
 	struct sem_undo_list *ulp;
-	struct sem_undo *un, *tmp;
 
 	ulp = tsk->sysvsem.undo_list;
 	if (!ulp)
@@ -1252,28 +1274,47 @@ void exit_sem(struct task_struct *tsk)
 	if (!atomic_dec_and_test(&ulp->refcnt))
 		return;
 
-	spin_lock(&ulp->lock);
-
-	list_for_each_entry_safe(un, tmp, &ulp->list_proc, list_proc) {
+	for (;;) {
 		struct sem_array *sma;
+		struct sem_undo *un;
+		int semid;
 		int i;
 
-		if (un->semid == -1)
-			goto free;
+		rcu_read_lock();
+		un =list_entry(rcu_dereference(ulp->list_proc.next),
+					struct sem_undo, list_proc);
+		if (&un->list_proc == &ulp->list_proc)
+			semid = -1;
+		 else
+			semid = un->semid;
+		rcu_read_unlock();
 
-		sma = sem_lock(tsk->nsproxy->ipc_ns, un->semid);
-		if (IS_ERR(sma))
-			goto free;
+		if(semid == -1)
+			break;
+
+		sma = sem_lock_check(tsk->nsproxy->ipc_ns, un->semid);
 
-		if (un->semid == -1)
-			goto unlock_free;
+		/* exit_sem raced with IPC_RMID, nothing to do */
+		if (IS_ERR(sma))
+			continue;
 
-		BUG_ON(sem_checkid(sma, un->semid));
+		un = lookup_undo(ulp, semid);
+		if (un == NULL) {
+			/* exit_sem raced with IPC_RMID+semget() that created
+			 * exactly the same semid. Nothing to do.
+			 */
+			sem_unlock(sma);
+			continue;
+		}
 
-		/* remove un from sma->list_id */
+		/* remove un from the linked lists */
 		assert_spin_locked(&sma->sem_perm.lock);
 		list_del(&un->list_id);
 
+		spin_lock(&ulp->lock);
+		list_del_rcu(&un->list_proc);
+		spin_unlock(&ulp->lock);
+
 		/* perform adjustments registered in un */
 		for (i = 0; i < sma->sem_nsems; i++) {
 			struct sem * semaphore = &sma->sem_base[i];
@@ -1302,14 +1343,10 @@ void exit_sem(struct task_struct *tsk)
 		sma->sem_otime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
 		update_queue(sma);
-unlock_free:
 		sem_unlock(sma);
-free:
-		assert_spin_locked(&ulp->lock);
-		list_del(&un->list_proc);
-		kfree(un);
+
+		call_rcu(&un->rcu, free_un);
 	}
-	spin_unlock(&ulp->lock);
 	kfree(ulp);
 }
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-restore-msgpool-original-value.patch
ipc-only-output-msgmni-value-at-boot-time.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
ipc-semc-convert-undo-structures-to-struct-list_head.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-remove-unused-entries-from-struct-sem_queue.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch

