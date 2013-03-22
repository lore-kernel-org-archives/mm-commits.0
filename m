From: akpm@linux-foundation.org
Subject: + ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch added to -mm tree
Date: Fri, 22 Mar 2013 14:04:41 -0700
Message-ID: <20130322210442.0B26731C3B1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:53225 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423101Ab3CVVEo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 17:04:44 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so422671ves.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 14:04:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidlohr.bueso@hp.com, benisty.e@gmail.com, chegu_vinod@hp.com, jason.low2@hp.com, peter@hurleysoftware.com, riel@redhat.com, skinsbursky@parallels.com, torvalds@linux-foundation.org, walken@google.com


The patch titled
     Subject: ipc,sem: do not hold ipc lock more than necessary
has been added to the -mm tree.  Its filename is
     ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,sem: do not hold ipc lock more than necessary

Instead of holding the ipc lock for permissions and security checks, among
others, only acquire it when necessary.

Some numbers....

1) With Rik's semop-multi.c microbenchmark we can see the following
   results:

Baseline (3.9-rc1):
cpus 4, threads: 256, semaphores: 128, test duration: 30 secs
total operations: 151452270, ops/sec 5048409

+  59.40%            a.out  [kernel.kallsyms]  [k] _raw_spin_lock
+   6.14%            a.out  [kernel.kallsyms]  [k] sys_semtimedop
+   3.84%            a.out  [kernel.kallsyms]  [k] avc_has_perm_flags
+   3.64%            a.out  [kernel.kallsyms]  [k] __audit_syscall_exit
+   2.06%            a.out  [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
+   1.86%            a.out  [kernel.kallsyms]  [k] ipc_lock

With this patchset:
cpus 4, threads: 256, semaphores: 128, test duration: 30 secs
total operations: 273156400, ops/sec 9105213

+  18.54%            a.out  [kernel.kallsyms]  [k] _raw_spin_lock
+  11.72%            a.out  [kernel.kallsyms]  [k] sys_semtimedop
+   7.70%            a.out  [kernel.kallsyms]  [k] ipc_has_perm.isra.21
+   6.58%            a.out  [kernel.kallsyms]  [k] avc_has_perm_flags
+   6.54%            a.out  [kernel.kallsyms]  [k] __audit_syscall_exit
+   4.71%            a.out  [kernel.kallsyms]  [k] ipc_obtain_object_check

2) While on an Oracle swingbench DSS (data mining) workload the
   improvements are not as exciting as with Rik's benchmark, we can see
   some positive numbers.  For an 8 socket machine the following are the
   percentages of %sys time incurred in the ipc lock:

Baseline (3.9-rc1):
100 swingbench users: 8,74%
400 swingbench users: 21,86%
800 swingbench users: 84,35%

With this patchset:
100 swingbench users: 8,11%
400 swingbench users: 19,93%
800 swingbench users: 77,69%

[riel@redhat.com: fix two locking bugs]
Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Chegu Vinod <chegu_vinod@hp.com>
Acked-by: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c  |  155 +++++++++++++++++++++++++++++++++++----------------
 ipc/util.h |    5 +
 2 files changed, 114 insertions(+), 46 deletions(-)

diff -puN ipc/sem.c~ipcsem-do-not-hold-ipc-lock-more-than-necessary ipc/sem.c
--- a/ipc/sem.c~ipcsem-do-not-hold-ipc-lock-more-than-necessary
+++ a/ipc/sem.c
@@ -204,13 +204,34 @@ static inline struct sem_array *sem_lock
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
+static inline struct sem_array *sem_obtain_object(struct ipc_namespace *ns, int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object(&sem_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct sem_array, sem_perm);
+}
+
 static inline struct sem_array *sem_lock_check(struct ipc_namespace *ns,
 						int id)
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check(&sem_ids(ns), id);
 
 	if (IS_ERR(ipcp))
-		return (struct sem_array *)ipcp;
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct sem_array, sem_perm);
+}
+
+static inline struct sem_array *sem_obtain_object_check(struct ipc_namespace *ns,
+							int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object_check(&sem_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
 
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
@@ -234,6 +255,16 @@ static inline void sem_putref(struct sem
 	ipc_unlock(&(sma)->sem_perm);
 }
 
+/*
+ * Call inside the rcu read section.
+ */
+static inline void sem_getref(struct sem_array *sma)
+{
+	spin_lock(&(sma)->sem_perm.lock);
+	ipc_rcu_getref(sma);
+	ipc_unlock(&(sma)->sem_perm);
+}
+
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
 {
 	ipc_rmid(&sem_ids(ns), &s->sem_perm);
@@ -842,18 +873,25 @@ static int semctl_nolock(struct ipc_name
 	case SEM_STAT:
 	{
 		struct semid64_ds tbuf;
-		int id;
+		int id = 0;
+
+		memset(&tbuf, 0, sizeof(tbuf));
 
 		if (cmd == SEM_STAT) {
-			sma = sem_lock(ns, semid);
-			if (IS_ERR(sma))
-				return PTR_ERR(sma);
+			rcu_read_lock();
+			sma = sem_obtain_object(ns, semid);
+			if (IS_ERR(sma)) {
+				err = PTR_ERR(sma);
+				goto out_unlock;
+			}
 			id = sma->sem_perm.id;
 		} else {
-			sma = sem_lock_check(ns, semid);
-			if (IS_ERR(sma))
-				return PTR_ERR(sma);
-			id = 0;
+			rcu_read_lock();
+			sma = sem_obtain_object_check(ns, semid);
+			if (IS_ERR(sma)) {
+				err = PTR_ERR(sma);
+				goto out_unlock;
+			}
 		}
 
 		err = -EACCES;
@@ -864,13 +902,11 @@ static int semctl_nolock(struct ipc_name
 		if (err)
 			goto out_unlock;
 
-		memset(&tbuf, 0, sizeof(tbuf));
-
 		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
 		tbuf.sem_otime  = sma->sem_otime;
 		tbuf.sem_ctime  = sma->sem_ctime;
 		tbuf.sem_nsems  = sma->sem_nsems;
-		sem_unlock(sma);
+		rcu_read_unlock();
 		if (copy_semid_to_user(p, &tbuf, version))
 			return -EFAULT;
 		return id;
@@ -879,7 +915,7 @@ static int semctl_nolock(struct ipc_name
 		return -EINVAL;
 	}
 out_unlock:
-	sem_unlock(sma);
+	rcu_read_unlock();
 	return err;
 }
 
@@ -947,27 +983,34 @@ static int semctl_main(struct ipc_namesp
 {
 	struct sem_array *sma;
 	struct sem* curr;
-	int err;
+	int err, nsems;
 	ushort fast_sem_io[SEMMSL_FAST];
 	ushort* sem_io = fast_sem_io;
-	int nsems;
 	struct list_head tasks;
 
-	sma = sem_lock_check(ns, semid);
-	if (IS_ERR(sma))
+	INIT_LIST_HEAD(&tasks);
+
+	rcu_read_lock();
+	sma = sem_obtain_object_check(ns, semid);
+	if (IS_ERR(sma)) {
+		rcu_read_unlock();
 		return PTR_ERR(sma);
+	}
 
-	INIT_LIST_HEAD(&tasks);
 	nsems = sma->sem_nsems;
 
 	err = -EACCES;
 	if (ipcperms(ns, &sma->sem_perm,
-			cmd == SETALL ? S_IWUGO : S_IRUGO))
-		goto out_unlock;
+			cmd == SETALL ? S_IWUGO : S_IRUGO)) {
+		rcu_read_unlock();
+		goto out_wakeup;
+	}
 
 	err = security_sem_semctl(sma, cmd);
-	if (err)
-		goto out_unlock;
+	if (err) {
+		rcu_read_unlock();
+		goto out_wakeup;
+	}
 
 	err = -EACCES;
 	switch (cmd) {
@@ -977,7 +1020,7 @@ static int semctl_main(struct ipc_namesp
 		int i;
 
 		if(nsems > SEMMSL_FAST) {
-			sem_getref_and_unlock(sma);
+			sem_getref(sma);
 
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if(sem_io == NULL) {
@@ -993,6 +1036,7 @@ static int semctl_main(struct ipc_namesp
 			}
 		}
 
+		spin_lock(&sma->sem_perm.lock);
 		for (i = 0; i < sma->sem_nsems; i++)
 			sem_io[i] = sma->sem_base[i].semval;
 		sem_unlock(sma);
@@ -1006,7 +1050,8 @@ static int semctl_main(struct ipc_namesp
 		int i;
 		struct sem_undo *un;
 
-		sem_getref_and_unlock(sma);
+		ipc_rcu_getref(sma);
+		rcu_read_unlock();
 
 		if(nsems > SEMMSL_FAST) {
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
@@ -1056,6 +1101,7 @@ static int semctl_main(struct ipc_namesp
 	if(semnum < 0 || semnum >= nsems)
 		goto out_unlock;
 
+	spin_lock(&sma->sem_perm.lock);
 	curr = &sma->sem_base[semnum];
 
 	switch (cmd) {
@@ -1072,10 +1118,11 @@ static int semctl_main(struct ipc_namesp
 		err = count_semzcnt(sma,semnum);
 		goto out_unlock;
 	}
+
 out_unlock:
 	sem_unlock(sma);
+out_wakeup:
 	wake_up_sem_queue_do(&tasks);
-
 out_free:
 	if(sem_io != fast_sem_io)
 		ipc_free(sem_io, sizeof(ushort)*nsems);
@@ -1126,29 +1173,35 @@ static int semctl_down(struct ipc_namesp
 			return -EFAULT;
 	}
 
-	ipcp = ipcctl_pre_down(ns, &sem_ids(ns), semid, cmd,
-			       &semid64.sem_perm, 0);
+	ipcp = ipcctl_pre_down_nolock(ns, &sem_ids(ns), semid, cmd,
+				      &semid64.sem_perm, 0);
 	if (IS_ERR(ipcp))
 		return PTR_ERR(ipcp);
 
 	sma = container_of(ipcp, struct sem_array, sem_perm);
 
 	err = security_sem_semctl(sma, cmd);
-	if (err)
+	if (err) {
+		rcu_read_unlock();
 		goto out_unlock;
+	}
 
 	switch(cmd){
 	case IPC_RMID:
+		ipc_lock_object(&sma->sem_perm);
 		freeary(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
+		ipc_lock_object(&sma->sem_perm);
 		err = ipc_update_perm(&semid64.sem_perm, ipcp);
 		if (err)
 			goto out_unlock;
 		sma->sem_ctime = get_seconds();
 		break;
 	default:
+		rcu_read_unlock();
 		err = -EINVAL;
+		goto out_up;
 	}
 
 out_unlock:
@@ -1277,16 +1330,18 @@ static struct sem_undo *find_alloc_undo(
 	spin_unlock(&ulp->lock);
 	if (likely(un!=NULL))
 		goto out;
-	rcu_read_unlock();
 
 	/* no undo structure around - allocate one. */
 	/* step 1: figure out the size of the semaphore array */
-	sma = sem_lock_check(ns, semid);
-	if (IS_ERR(sma))
+	sma = sem_obtain_object_check(ns, semid);
+	if (IS_ERR(sma)) {
+		rcu_read_unlock();
 		return ERR_CAST(sma);
+	}
 
 	nsems = sma->sem_nsems;
-	sem_getref_and_unlock(sma);
+	ipc_rcu_getref(sma);
+	rcu_read_unlock();
 
 	/* step 2: allocate new undo structure */
 	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
@@ -1421,7 +1476,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 
 	INIT_LIST_HEAD(&tasks);
 
-	sma = sem_lock_check(ns, semid);
+	rcu_read_lock();
+	sma = sem_obtain_object_check(ns, semid);
 	if (IS_ERR(sma)) {
 		if (un)
 			rcu_read_unlock();
@@ -1429,6 +1485,24 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 		goto out_free;
 	}
 
+	error = -EFBIG;
+	if (max >= sma->sem_nsems) {
+		rcu_read_unlock();
+		goto out_wakeup;
+	}
+
+	error = -EACCES;
+	if (ipcperms(ns, &sma->sem_perm, alter ? S_IWUGO : S_IRUGO)) {
+		rcu_read_unlock();
+		goto out_wakeup;
+	}
+
+	error = security_sem_semop(sma, sops, nsops, alter);
+	if (error) {
+		rcu_read_unlock();
+		goto out_wakeup;
+	}
+
 	/*
 	 * semid identifiers are not unique - find_alloc_undo may have
 	 * allocated an undo structure, it was invalidated by an RMID
@@ -1437,6 +1511,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	 * "un" itself is guaranteed by rcu.
 	 */
 	error = -EIDRM;
+	ipc_lock_object(&sma->sem_perm);
 	if (un) {
 		if (un->semid == -1) {
 			rcu_read_unlock();
@@ -1454,18 +1529,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 		}
 	}
 
-	error = -EFBIG;
-	if (max >= sma->sem_nsems)
-		goto out_unlock_free;
-
-	error = -EACCES;
-	if (ipcperms(ns, &sma->sem_perm, alter ? S_IWUGO : S_IRUGO))
-		goto out_unlock_free;
-
-	error = security_sem_semop(sma, sops, nsops, alter);
-	if (error)
-		goto out_unlock_free;
-
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
@@ -1568,7 +1631,7 @@ sleep_again:
 
 out_unlock_free:
 	sem_unlock(sma);
-
+out_wakeup:
 	wake_up_sem_queue_do(&tasks);
 out_free:
 	if(sops != fast_sops)
diff -puN ipc/util.h~ipcsem-do-not-hold-ipc-lock-more-than-necessary ipc/util.h
--- a/ipc/util.h~ipcsem-do-not-hold-ipc-lock-more-than-necessary
+++ a/ipc/util.h
@@ -171,6 +171,11 @@ static inline void ipc_unlock(struct ker
 	rcu_read_unlock();
 }
 
+static inline void ipc_lock_object(struct kern_ipc_perm *perm)
+{
+	spin_lock(&perm->lock);
+}
+
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

lib-int_sqrtc-optimize-square-root-algorithm.patch
ipc-remove-bogus-lock-comment-for-ipc_checkid.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipc-introduce-lockless-pre_down-ipcctl.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch

