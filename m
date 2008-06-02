From: akpm@linux-foundation.org
Subject: + ipc-semc-convert-undo-structures-to-struct-list_head.patch added to -mm tree
Date: Mon, 02 Jun 2008 14:47:54 -0700
Message-ID: <200806022147.m52LlsCF001643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225AbYFBVtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 17:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, Nadia.Derbey@bull.net, peifferp@gmail.com


The patch titled
     ipc/sem.c: convert undo structures to struct list_head
has been added to the -mm tree.  Its filename is
     ipc-semc-convert-undo-structures-to-struct-list_head.patch

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
Subject: ipc/sem.c: convert undo structures to struct list_head
From: Manfred Spraul <manfred@colorfullife.com>

The undo structures contain two linked lists, the attached patch replaces
them with generic struct list_head lists.

(akpm: might need updates after Nadia's review)

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |   12 +--
 ipc/sem.c           |  163 ++++++++++++++++++++++--------------------
 2 files changed, 95 insertions(+), 80 deletions(-)

diff -puN include/linux/sem.h~ipc-semc-convert-undo-structures-to-struct-list_head include/linux/sem.h
--- a/include/linux/sem.h~ipc-semc-convert-undo-structures-to-struct-list_head
+++ a/include/linux/sem.h
@@ -95,7 +95,7 @@ struct sem_array {
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
 	struct sem_queue	*sem_pending;	/* pending operations to be processed */
 	struct sem_queue	**sem_pending_last; /* last pending operation */
-	struct sem_undo		*undo;		/* undo requests on this array */
+	struct list_head	list_id;	/* undo requests on this array */
 	unsigned long		sem_nsems;	/* no. of semaphores in array */
 };
 
@@ -118,8 +118,8 @@ struct sem_queue {
  * when the process exits.
  */
 struct sem_undo {
-	struct sem_undo *	proc_next;	/* next entry on this process */
-	struct sem_undo *	id_next;	/* next entry on this semaphore set */
+	struct list_head	list_proc;	/* per-process list: all undos from one process */
+	struct list_head	list_id;	/* per semaphore array list: all undos for one array */
 	int			semid;		/* semaphore set identifier */
 	short *			semadj;		/* array of adjustments, one per semaphore */
 };
@@ -128,9 +128,9 @@ struct sem_undo {
  * that may be shared among all a CLONE_SYSVSEM task group.
  */ 
 struct sem_undo_list {
-	atomic_t	refcnt;
-	spinlock_t	lock;
-	struct sem_undo	*proc_list;
+	atomic_t		refcnt;
+	spinlock_t		lock;
+	struct list_head	list_proc;
 };
 
 struct sysv_sem {
diff -puN ipc/sem.c~ipc-semc-convert-undo-structures-to-struct-list_head ipc/sem.c
--- a/ipc/sem.c~ipc-semc-convert-undo-structures-to-struct-list_head
+++ a/ipc/sem.c
@@ -274,7 +274,7 @@ static int newary(struct ipc_namespace *
 	sma->sem_base = (struct sem *) &sma[1];
 	/* sma->sem_pending = NULL; */
 	sma->sem_pending_last = &sma->sem_pending;
-	/* sma->undo = NULL; */
+	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
 	sem_unlock(sma);
@@ -536,7 +536,8 @@ static void freeary(struct ipc_namespace
 	 * (They will be freed without any further action in exit_sem()
 	 * or during the next semop.)
 	 */
-	for (un = sma->undo; un; un = un->id_next)
+	assert_spin_locked(&sma->sem_perm.lock);
+	list_for_each_entry(un, &sma->list_id, list_id)
 		un->semid = -1;
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
@@ -763,9 +764,12 @@ static int semctl_main(struct ipc_namesp
 
 		for (i = 0; i < nsems; i++)
 			sma->sem_base[i].semval = sem_io[i];
-		for (un = sma->undo; un; un = un->id_next)
+
+		assert_spin_locked(&sma->sem_perm.lock);
+		list_for_each_entry(un, &sma->list_id, list_id) {
 			for (i = 0; i < nsems; i++)
 				un->semadj[i] = 0;
+		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
 		update_queue(sma);
@@ -797,12 +801,15 @@ static int semctl_main(struct ipc_namesp
 	{
 		int val = arg.val;
 		struct sem_undo *un;
+
 		err = -ERANGE;
 		if (val > SEMVMX || val < 0)
 			goto out_unlock;
 
-		for (un = sma->undo; un; un = un->id_next)
+		assert_spin_locked(&sma->sem_perm.lock);
+		list_for_each_entry(un, &sma->list_id, list_id)
 			un->semadj[semnum] = 0;
+
 		curr->semval = val;
 		curr->sempid = task_tgid_vnr(current);
 		sma->sem_ctime = get_seconds();
@@ -952,6 +959,8 @@ static inline int get_undo_list(struct s
 			return -ENOMEM;
 		spin_lock_init(&undo_list->lock);
 		atomic_set(&undo_list->refcnt, 1);
+		INIT_LIST_HEAD(&undo_list->list_proc);
+
 		current->sysvsem.undo_list = undo_list;
 	}
 	*undo_listp = undo_list;
@@ -960,25 +969,30 @@ static inline int get_undo_list(struct s
 
 static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, int semid)
 {
-	struct sem_undo **last, *un;
+	struct sem_undo *walk, *tmp;
 
-	last = &ulp->proc_list;
-	un = *last;
-	while(un != NULL) {
-		if(un->semid==semid)
-			break;
-		if(un->semid==-1) {
-			*last=un->proc_next;
-			kfree(un);
-		} else {
-			last=&un->proc_next;
+	assert_spin_locked(&ulp->lock);
+	list_for_each_entry_safe(walk, tmp, &ulp->list_proc, list_proc) {
+		if(walk->semid==semid)
+			return walk;
+		if(walk->semid==-1) {
+			list_del(&walk->list_proc);
+			kfree(walk);
 		}
-		un=*last;
 	}
-	return un;
+	return NULL;
 }
 
-static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
+/**
+ * find_alloc_undo - Lookup (and if not present create) undo array
+ * @ns: namespace
+ * @semid: semaphore array id
+ *
+ * The function looks up (and if not present creates) the undo structure.
+ * The size of the undo structure depends on the size of the semaphore
+ * array, thus the alloc path is not that straightforward.
+ */
+static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 {
 	struct sem_array *sma;
 	struct sem_undo_list *ulp;
@@ -997,6 +1011,7 @@ static struct sem_undo *find_undo(struct
 		goto out;
 
 	/* no undo structure around - allocate one. */
+	/* step 1: figure out the size of the semaphore array */
 	sma = sem_lock_check(ns, semid);
 	if (IS_ERR(sma))
 		return ERR_PTR(PTR_ERR(sma));
@@ -1004,15 +1019,19 @@ static struct sem_undo *find_undo(struct
 	nsems = sma->sem_nsems;
 	sem_getref_and_unlock(sma);
 
+	/* step 2: allocate new undo structure */
 	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
 	if (!new) {
 		sem_putref(sma);
 		return ERR_PTR(-ENOMEM);
 	}
-	new->semadj = (short *) &new[1];
-	new->semid = semid;
 
+	/* step 3: Acquire the lock on the undo list pointer */
 	spin_lock(&ulp->lock);
+
+	/* step 4: check for races: someone else allocated the undo struct,
+	 *         semaphore array was destroyed.
+	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
 		spin_unlock(&ulp->lock);
@@ -1028,13 +1047,17 @@ static struct sem_undo *find_undo(struct
 		un = ERR_PTR(-EIDRM);
 		goto out;
 	}
-	new->proc_next = ulp->proc_list;
-	ulp->proc_list = new;
-	new->id_next = sma->undo;
-	sma->undo = new;
+	/* step 5: initialize & link new undo structure */
+	new->semadj = (short *) &new[1];
+	new->semid = semid;
+	assert_spin_locked(&ulp->lock);
+	list_add(&new->list_proc, &ulp->list_proc);
+	assert_spin_locked(&sma->sem_perm.lock);
+	list_add(&new->list_id, &sma->list_id);
+
 	sem_unlock(sma);
-	un = new;
 	spin_unlock(&ulp->lock);
+	un = new;
 out:
 	return un;
 }
@@ -1090,9 +1113,8 @@ asmlinkage long sys_semtimedop(int semid
 			alter = 1;
 	}
 
-retry_undos:
 	if (undos) {
-		un = find_undo(ns, semid);
+		un = find_alloc_undo(ns, semid);
 		if (IS_ERR(un)) {
 			error = PTR_ERR(un);
 			goto out_free;
@@ -1107,14 +1129,14 @@ retry_undos:
 	}
 
 	/*
-	 * semid identifiers are not unique - find_undo may have
+	 * semid identifiers are not unique - find_alloc_undo may have
 	 * allocated an undo structure, it was invalidated by an RMID
-	 * and now a new array with received the same id. Check and retry.
+	 * and now a new array with received the same id. Check and fail.
 	 */
-	if (un && un->semid == -1) {
-		sem_unlock(sma);
-		goto retry_undos;
-	}
+	error = -EIDRM;
+	if (un && un->semid == -1)
+		goto out_unlock_free;
+
 	error = -EFBIG;
 	if (max >= sma->sem_nsems)
 		goto out_unlock_free;
@@ -1243,56 +1265,44 @@ int copy_semundo(unsigned long clone_fla
  */
 void exit_sem(struct task_struct *tsk)
 {
-	struct sem_undo_list *undo_list;
-	struct sem_undo *u, **up;
-	struct ipc_namespace *ns;
+	struct sem_undo_list *ulp;
+	struct sem_undo *un, *tmp;
 
-	undo_list = tsk->sysvsem.undo_list;
-	if (!undo_list)
+	ulp= tsk->sysvsem.undo_list;
+	if (!ulp)
 		return;
 	tsk->sysvsem.undo_list = NULL;
 
-	if (!atomic_dec_and_test(&undo_list->refcnt))
+	if (!atomic_dec_and_test(&ulp->refcnt))
 		return;
 
-	ns = tsk->nsproxy->ipc_ns;
-	/* There's no need to hold the semundo list lock, as current
-         * is the last task exiting for this undo list.
-	 */
-	for (up = &undo_list->proc_list; (u = *up); *up = u->proc_next, kfree(u)) {
-		struct sem_array *sma;
-		int nsems, i;
-		struct sem_undo *un, **unp;
-		int semid;
-	       
-		semid = u->semid;
-
-		if(semid == -1)
-			continue;
-		sma = sem_lock(ns, semid);
+	spin_lock(&ulp->lock);
+
+	list_for_each_entry_safe(un, tmp, &ulp->list_proc, list_proc) {
+  		struct sem_array *sma;
+		int i;
+
+		if(un->semid == -1)
+			goto free;
+
+		sma = sem_lock(tsk->nsproxy->ipc_ns, un->semid);
 		if (IS_ERR(sma))
-			continue;
+			goto free;
 
-		if (u->semid == -1)
-			goto next_entry;
+		if (un->semid == -1)
+			goto unlock_free;
 
-		BUG_ON(sem_checkid(sma, u->semid));
+		BUG_ON(sem_checkid(sma, un->semid));
 
-		/* remove u from the sma->undo list */
-		for (unp = &sma->undo; (un = *unp); unp = &un->id_next) {
-			if (u == un)
-				goto found;
-		}
-		printk ("exit_sem undo list error id=%d\n", u->semid);
-		goto next_entry;
-found:
-		*unp = un->id_next;
-		/* perform adjustments registered in u */
-		nsems = sma->sem_nsems;
-		for (i = 0; i < nsems; i++) {
+		/* remove un from sma->list_id */
+		assert_spin_locked(&sma->sem_perm.lock);
+		list_del(&un->list_id);
+
+		/* perform adjustments registered in un */
+		for (i = 0; i < sma->sem_nsems; i++) {
 			struct sem * semaphore = &sma->sem_base[i];
-			if (u->semadj[i]) {
-				semaphore->semval += u->semadj[i];
+			if (un->semadj[i]) {
+				semaphore->semval += un->semadj[i];
 				/*
 				 * Range checks of the new semaphore value,
 				 * not defined by sus:
@@ -1316,10 +1326,15 @@ found:
 		sma->sem_otime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
 		update_queue(sma);
-next_entry:
+unlock_free:
 		sem_unlock(sma);
+free:
+		assert_spin_locked(&ulp->lock);
+		list_del(&un->list_proc);
+		kfree(un);
 	}
-	kfree(undo_list);
+	spin_unlock(&ulp->lock);
+	kfree(ulp);
 }
 
 #ifdef CONFIG_PROC_FS
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
ipc-semc-remove-unused-entries-from-struct-sem_queue.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch
ipc-semc-rewrite-undo-list-locking.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch

