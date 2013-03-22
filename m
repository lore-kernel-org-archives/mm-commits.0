From: akpm@linux-foundation.org
Subject: + ipcsem-fine-grained-locking-for-semtimedop.patch added to -mm tree
Date: Fri, 22 Mar 2013 14:04:53 -0700
Message-ID: <20130322210453.EF33A31C3C2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:36462 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423086Ab3CVVEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 17:04:55 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so423020vcb.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 14:04:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@surriel.com, benisty.e@gmail.com, chegu_vinod@hp.com, davidlohr.bueso@hp.com, jason.low2@hp.com, peter@hurleysoftware.com, riel@redhat.com, skinsbursky@parallels.com, torvalds@linux-foundation.org, walken@google.com


The patch titled
     Subject: ipc,sem: fine grained locking for semtimedop
has been added to the -mm tree.  Its filename is
     ipcsem-fine-grained-locking-for-semtimedop.patch

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
Subject: ipc,sem: fine grained locking for semtimedop

Introduce finer grained locking for semtimedop, to handle the common case
of a program wanting to manipulate one semaphore from an array with
multiple semaphores.

If the call is a semop manipulating just one semaphore in an array with
multiple semaphores, only take the lock for that semaphore itself.

If the call needs to manipulate multiple semaphores, or another caller is
in a transaction that manipulates multiple semaphores, the sem_array lock
is taken, as well as all the locks for the individual semaphores.

On a 24 CPU system, performance numbers with the semop-multi
test with N threads and N semaphores, look like this:

	vanilla		Davidlohr's	Davidlohr's +	Davidlohr's +
threads			patches		rwlock patches	v3 patches
10	610652		726325		1783589		2142206
20	341570		365699		1520453		1977878
30	288102		307037		1498167		2037995
40	290714		305955		1612665		2256484
50	288620		312890		1733453		2650292
60	289987		306043		1649360		2388008
70	291298		306347		1723167		2717486
80	290948		305662		1729545		2763582
90	290996		306680		1736021		2757524
100	292243		306700		1773700		3059159

Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |  196 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 129 insertions(+), 67 deletions(-)

diff -puN ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop ipc/sem.c
--- a/ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop
+++ a/ipc/sem.c
@@ -94,6 +94,7 @@
 struct sem {
 	int	semval;		/* current value */
 	int	sempid;		/* pid of last operation */
+	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
 	struct list_head sem_pending; /* pending single-sop operations */
 };
 
@@ -137,7 +138,6 @@ struct sem_undo_list {
 
 #define sem_ids(ns)	((ns)->ids[IPC_SEM_IDS])
 
-#define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
 #define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
 
 static int newary(struct ipc_namespace *, struct ipc_params *);
@@ -190,10 +190,72 @@ void __init sem_init (void)
 }
 
 /*
+ * If the sem_array contains just one semaphore, or if multiple
+ * semops are performed in one syscall, or if there are complex
+ * operations pending, the whole sem_array is locked.
+ * If one semop is performed on an array with multiple semaphores,
+ * get a shared lock on the array, and lock the individual semaphore.
+ *
+ * Carefully guard against sma->complex_count changing between zero
+ * and non-zero while we are spinning for the lock. The value of
+ * sma->complex_count cannot change while we are holding the lock,
+ * so sem_unlock should be fine.
+ */
+static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
+			      int nsops)
+{
+	int locknum;
+	if (nsops == 1 && !sma->complex_count) {
+		struct sem *sem = sma->sem_base + sops->sem_num;
+
+		/* Lock just the semaphore we are interested in. */
+		spin_lock(&sem->lock);
+
+		/*
+		 * If sma->complex_count was set while we were spinning,
+		 * we may need to look at things we did not lock here.
+		 */
+		if (unlikely(sma->complex_count)) {
+			spin_unlock(&sma->sem_perm.lock);
+			goto lock_all;
+		}
+		locknum = sops->sem_num;
+	} else {
+		int i;
+		/* Lock the sem_array, and all the semaphore locks */
+ lock_all:
+		spin_lock(&sma->sem_perm.lock);
+		for (i = 0; i < sma->sem_nsems; i++) {
+			struct sem *sem = sma->sem_base + i;
+			spin_lock(&sem->lock);
+		}
+		locknum = -1;
+	}
+	return locknum;
+}
+
+static inline void sem_unlock(struct sem_array *sma, int locknum)
+{
+	if (locknum == -1) {
+		int i;
+		for (i = 0; i < sma->sem_nsems; i++) {
+			struct sem *sem = sma->sem_base + i;
+			spin_unlock(&sem->lock);
+		}
+		spin_unlock(&sma->sem_perm.lock);
+	} else {
+		struct sem *sem = sma->sem_base + locknum;
+		spin_unlock(&sem->lock);
+	}
+	rcu_read_unlock();
+}
+
+/*
  * sem_lock_(check_) routines are called in the paths where the rw_mutex
  * is not held.
  */
-static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns, int id)
+static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns,
+			int id, struct sembuf *sops, int nsops, int *locknum)
 {
 	struct kern_ipc_perm *ipcp;
 	struct sem_array *sma;
@@ -205,7 +267,8 @@ static inline struct sem_array *sem_obta
 		goto err;
 	}
 
-	spin_lock(&ipcp->lock);
+	sma = container_of(ipcp, struct sem_array, sem_perm);
+	*locknum = sem_lock(sma, sops, nsops);
 
 	/* ipc_rmid() may have already freed the ID while sem_lock
 	 * was spinning: verify that the structure is still valid
@@ -213,7 +276,7 @@ static inline struct sem_array *sem_obta
 	if (!ipcp->deleted)
 		return container_of(ipcp, struct sem_array, sem_perm);
 
-	spin_unlock(&ipcp->lock);
+	sem_unlock(sma, *locknum);
 	sma = ERR_PTR(-EINVAL);
 err:
 	rcu_read_unlock();
@@ -230,17 +293,6 @@ static inline struct sem_array *sem_obta
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
-static inline struct sem_array *sem_lock_check(struct ipc_namespace *ns,
-						int id)
-{
-	struct kern_ipc_perm *ipcp = ipc_lock_check(&sem_ids(ns), id);
-
-	if (IS_ERR(ipcp))
-		return ERR_CAST(ipcp);
-
-	return container_of(ipcp, struct sem_array, sem_perm);
-}
-
 static inline struct sem_array *sem_obtain_object_check(struct ipc_namespace *ns,
 							int id)
 {
@@ -254,21 +306,21 @@ static inline struct sem_array *sem_obta
 
 static inline void sem_lock_and_putref(struct sem_array *sma)
 {
-	ipc_lock_by_ptr(&sma->sem_perm);
+	rcu_read_lock();
+	sem_lock(sma, NULL, -1);
 	ipc_rcu_putref(sma);
 }
 
 static inline void sem_getref_and_unlock(struct sem_array *sma)
 {
 	ipc_rcu_getref(sma);
-	ipc_unlock(&(sma)->sem_perm);
+	sem_unlock(sma, -1);
 }
 
 static inline void sem_putref(struct sem_array *sma)
 {
-	ipc_lock_by_ptr(&sma->sem_perm);
-	ipc_rcu_putref(sma);
-	ipc_unlock(&(sma)->sem_perm);
+	sem_lock_and_putref(sma);
+	sem_unlock(sma, -1);
 }
 
 /*
@@ -276,9 +328,9 @@ static inline void sem_putref(struct sem
  */
 static inline void sem_getref(struct sem_array *sma)
 {
-	spin_lock(&(sma)->sem_perm.lock);
+	sem_lock(sma, NULL, -1);
 	ipc_rcu_getref(sma);
-	ipc_unlock(&(sma)->sem_perm);
+	sem_unlock(sma, -1);
 }
 
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
@@ -371,15 +423,18 @@ static int newary(struct ipc_namespace *
 
 	sma->sem_base = (struct sem *) &sma[1];
 
-	for (i = 0; i < nsems; i++)
+	for (i = 0; i < nsems; i++) {
 		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
+		spin_lock_init(&sma->sem_base[i].lock);
+		spin_lock(&sma->sem_base[i].lock);
+	}
 
 	sma->complex_count = 0;
 	INIT_LIST_HEAD(&sma->sem_pending);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
-	sem_unlock(sma);
+	sem_unlock(sma, -1);
 
 	return sma->sem_perm.id;
 }
@@ -818,7 +873,7 @@ static void freeary(struct ipc_namespace
 
 	/* Remove the semaphore set from the IDR */
 	sem_rmid(ns, sma);
-	sem_unlock(sma);
+	sem_unlock(sma, -1);
 
 	wake_up_sem_queue_do(&tasks);
 	ns->used_sems -= sma->sem_nsems;
@@ -947,7 +1002,6 @@ static int semctl_setval(struct ipc_name
 	struct sem_array *sma;
 	struct sem* curr;
 	int err;
-	int nsems;
 	struct list_head tasks;
 	int val;
 #if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
@@ -958,31 +1012,39 @@ static int semctl_setval(struct ipc_name
 	val = arg;
 #endif
 
-	sma = sem_lock_check(ns, semid);
-	if (IS_ERR(sma))
-		return PTR_ERR(sma);
+	if (val > SEMVMX || val < 0)
+		return -ERANGE;
 
 	INIT_LIST_HEAD(&tasks);
-	nsems = sma->sem_nsems;
 
-	err = -EACCES;
-	if (ipcperms(ns, &sma->sem_perm, S_IWUGO))
-		goto out_unlock;
+	rcu_read_lock();
+	sma = sem_obtain_object_check(ns, semid);
+	if (IS_ERR(sma)) {
+		rcu_read_unlock();
+		return PTR_ERR(sma);
+	}
+
+	if (semnum < 0 || semnum >= sma->sem_nsems) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+
+	if (ipcperms(ns, &sma->sem_perm, S_IWUGO)) {
+		rcu_read_unlock();
+		return -EACCES;
+	}
 
 	err = security_sem_semctl(sma, SETVAL);
-	if (err)
-		goto out_unlock;
+	if (err) {
+		rcu_read_unlock();
+		return -EACCES;
+	}
 
-	err = -EINVAL;
-	if(semnum < 0 || semnum >= nsems)
-		goto out_unlock;
+	sem_lock(sma, NULL, -1);
 
 	curr = &sma->sem_base[semnum];
 
-	err = -ERANGE;
-	if (val > SEMVMX || val < 0)
-		goto out_unlock;
-
 	assert_spin_locked(&sma->sem_perm.lock);
 	list_for_each_entry(un, &sma->list_id, list_id)
 		un->semadj[semnum] = 0;
@@ -992,11 +1054,9 @@ static int semctl_setval(struct ipc_name
 	sma->sem_ctime = get_seconds();
 	/* maybe some queued-up processes were waiting for this */
 	do_smart_update(sma, NULL, 0, 0, &tasks);
-	err = 0;
-out_unlock:
-	sem_unlock(sma);
+	sem_unlock(sma, -1);
 	wake_up_sem_queue_do(&tasks);
-	return err;
+	return 0;
 }
 
 static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
@@ -1051,16 +1111,16 @@ static int semctl_main(struct ipc_namesp
 
 			sem_lock_and_putref(sma);
 			if (sma->sem_perm.deleted) {
-				sem_unlock(sma);
+				sem_unlock(sma, -1);
 				err = -EIDRM;
 				goto out_free;
 			}
 		}
 
-		spin_lock(&sma->sem_perm.lock);
+		sem_lock(sma, NULL, -1);
 		for (i = 0; i < sma->sem_nsems; i++)
 			sem_io[i] = sma->sem_base[i].semval;
-		sem_unlock(sma);
+		sem_unlock(sma, -1);
 		err = 0;
 		if(copy_to_user(array, sem_io, nsems*sizeof(ushort)))
 			err = -EFAULT;
@@ -1097,7 +1157,7 @@ static int semctl_main(struct ipc_namesp
 		}
 		sem_lock_and_putref(sma);
 		if (sma->sem_perm.deleted) {
-			sem_unlock(sma);
+			sem_unlock(sma, -1);
 			err = -EIDRM;
 			goto out_free;
 		}
@@ -1122,7 +1182,7 @@ static int semctl_main(struct ipc_namesp
 	if(semnum < 0 || semnum >= nsems)
 		goto out_unlock;
 
-	spin_lock(&sma->sem_perm.lock);
+	sem_lock(sma, NULL, -1);
 	curr = &sma->sem_base[semnum];
 
 	switch (cmd) {
@@ -1141,7 +1201,7 @@ static int semctl_main(struct ipc_namesp
 	}
 
 out_unlock:
-	sem_unlock(sma);
+	sem_unlock(sma, -1);
 out_wakeup:
 	wake_up_sem_queue_do(&tasks);
 out_free:
@@ -1209,11 +1269,11 @@ static int semctl_down(struct ipc_namesp
 
 	switch(cmd){
 	case IPC_RMID:
-		ipc_lock_object(&sma->sem_perm);
+		sem_lock(sma, NULL, -1);
 		freeary(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
-		ipc_lock_object(&sma->sem_perm);
+		sem_lock(sma, NULL, -1);
 		err = ipc_update_perm(&semid64.sem_perm, ipcp);
 		if (err)
 			goto out_unlock;
@@ -1226,7 +1286,7 @@ static int semctl_down(struct ipc_namesp
 	}
 
 out_unlock:
-	sem_unlock(sma);
+	sem_unlock(sma, -1);
 out_up:
 	up_write(&sem_ids(ns).rw_mutex);
 	return err;
@@ -1374,7 +1434,7 @@ static struct sem_undo *find_alloc_undo(
 	/* step 3: Acquire the lock on semaphore array */
 	sem_lock_and_putref(sma);
 	if (sma->sem_perm.deleted) {
-		sem_unlock(sma);
+		sem_unlock(sma, -1);
 		kfree(new);
 		un = ERR_PTR(-EIDRM);
 		goto out;
@@ -1402,7 +1462,7 @@ static struct sem_undo *find_alloc_undo(
 success:
 	spin_unlock(&ulp->lock);
 	rcu_read_lock();
-	sem_unlock(sma);
+	sem_unlock(sma, -1);
 out:
 	return un;
 }
@@ -1442,7 +1502,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	struct sembuf fast_sops[SEMOPM_FAST];
 	struct sembuf* sops = fast_sops, *sop;
 	struct sem_undo *un;
-	int undos = 0, alter = 0, max;
+	int undos = 0, alter = 0, max, locknum;
 	struct sem_queue queue;
 	unsigned long jiffies_left = 0;
 	struct ipc_namespace *ns;
@@ -1532,7 +1592,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	 * "un" itself is guaranteed by rcu.
 	 */
 	error = -EIDRM;
-	ipc_lock_object(&sma->sem_perm);
+	locknum = sem_lock(sma, sops, nsops);
 	if (un) {
 		if (un->semid == -1) {
 			rcu_read_unlock();
@@ -1589,7 +1649,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 
 sleep_again:
 	current->state = TASK_INTERRUPTIBLE;
-	sem_unlock(sma);
+	sem_unlock(sma, locknum);
 
 	if (timeout)
 		jiffies_left = schedule_timeout(jiffies_left);
@@ -1611,7 +1671,7 @@ sleep_again:
 		goto out_free;
 	}
 
-	sma = sem_obtain_lock(ns, semid);
+	sma = sem_obtain_lock(ns, semid, sops, nsops, &locknum);
 
 	/*
 	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
@@ -1650,7 +1710,7 @@ sleep_again:
 	unlink_queue(sma, &queue);
 
 out_unlock_free:
-	sem_unlock(sma);
+	sem_unlock(sma, locknum);
 out_wakeup:
 	wake_up_sem_queue_do(&tasks);
 out_free:
@@ -1724,12 +1784,14 @@ void exit_sem(struct task_struct *tsk)
 			semid = -1;
 		 else
 			semid = un->semid;
-		rcu_read_unlock();
 
-		if (semid == -1)
+		if (semid == -1) {
+			rcu_read_unlock();
 			break;
+		}
 
-		sma = sem_lock_check(tsk->nsproxy->ipc_ns, un->semid);
+		sma = sem_obtain_object_check(tsk->nsproxy->ipc_ns, un->semid);
+		sem_lock(sma, NULL, -1);
 
 		/* exit_sem raced with IPC_RMID, nothing to do */
 		if (IS_ERR(sma))
@@ -1740,7 +1802,7 @@ void exit_sem(struct task_struct *tsk)
 			/* exit_sem raced with IPC_RMID+semget() that created
 			 * exactly the same semid. Nothing to do.
 			 */
-			sem_unlock(sma);
+			sem_unlock(sma, -1);
 			continue;
 		}
 
@@ -1780,7 +1842,7 @@ void exit_sem(struct task_struct *tsk)
 		/* maybe some queued-up processes were waiting for this */
 		INIT_LIST_HEAD(&tasks);
 		do_smart_update(sma, NULL, 0, 1, &tasks);
-		sem_unlock(sma);
+		sem_unlock(sma, -1);
 		wake_up_sem_queue_do(&tasks);
 
 		kfree_rcu(un, rcu);
_

Patches currently in -mm which might be from riel@surriel.com are

ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch

