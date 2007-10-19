From: akpm@linux-foundation.org
Subject: - ipc-store-ipcs-into-idrs.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:32 -0700
Message-ID: <200710192253.l9JMrW3Y024433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764222AbXJSXGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     ipc: store ipcs into IDRs
has been removed from the -mm tree.  Its filename was
     ipc-store-ipcs-into-idrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipc: store ipcs into IDRs
From: Nadia Derbey <Nadia.Derbey@bull.net>

This patch introduces ipcs storage into IDRs. The main changes are:
  . This ipc_ids structure is changed: the entries array is changed into a
    root idr structure.
  . The grow_ary() routine is removed: it is not needed anymore when adding
    an ipc structure, since we are now using the IDR facility.
  . The ipc_rmid() routine interface is changed:
       . there is no need for this routine to return the pointer passed in as
         argument: it is now declared as a void
       . since the id is now part of the kern_ipc_perm structure, no need to
         have it as an argument to the routine

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h |    1 
 include/linux/msg.h |    1 
 include/linux/sem.h |    1 
 include/linux/shm.h |    1 
 ipc/msg.c           |  113 ++++++++++-------
 ipc/sem.c           |  111 ++++++++++-------
 ipc/shm.c           |  116 ++++++++++--------
 ipc/util.c          |  264 ++++++++++++++++++------------------------
 ipc/util.h          |   32 +----
 9 files changed, 329 insertions(+), 311 deletions(-)

diff -puN include/linux/ipc.h~ipc-store-ipcs-into-idrs include/linux/ipc.h
--- a/include/linux/ipc.h~ipc-store-ipcs-into-idrs
+++ a/include/linux/ipc.h
@@ -89,6 +89,7 @@ struct kern_ipc_perm
 {
 	spinlock_t	lock;
 	int		deleted;
+	int		id;
 	key_t		key;
 	uid_t		uid;
 	gid_t		gid;
diff -puN include/linux/msg.h~ipc-store-ipcs-into-idrs include/linux/msg.h
--- a/include/linux/msg.h~ipc-store-ipcs-into-idrs
+++ a/include/linux/msg.h
@@ -77,7 +77,6 @@ struct msg_msg {
 /* one msq_queue structure for each present queue on the system */
 struct msg_queue {
 	struct kern_ipc_perm q_perm;
-	int q_id;
 	time_t q_stime;			/* last msgsnd time */
 	time_t q_rtime;			/* last msgrcv time */
 	time_t q_ctime;			/* last change time */
diff -puN include/linux/sem.h~ipc-store-ipcs-into-idrs include/linux/sem.h
--- a/include/linux/sem.h~ipc-store-ipcs-into-idrs
+++ a/include/linux/sem.h
@@ -90,7 +90,6 @@ struct sem {
 /* One sem_array data structure for each set of semaphores in the system. */
 struct sem_array {
 	struct kern_ipc_perm	sem_perm;	/* permissions .. see ipc.h */
-	int			sem_id;
 	time_t			sem_otime;	/* last semop time */
 	time_t			sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
diff -puN include/linux/shm.h~ipc-store-ipcs-into-idrs include/linux/shm.h
--- a/include/linux/shm.h~ipc-store-ipcs-into-idrs
+++ a/include/linux/shm.h
@@ -79,7 +79,6 @@ struct shmid_kernel /* private to the ke
 {	
 	struct kern_ipc_perm	shm_perm;
 	struct file *		shm_file;
-	int			id;
 	unsigned long		shm_nattch;
 	unsigned long		shm_segsz;
 	time_t			shm_atim;
diff -puN ipc/msg.c~ipc-store-ipcs-into-idrs ipc/msg.c
--- a/ipc/msg.c~ipc-store-ipcs-into-idrs
+++ a/ipc/msg.c
@@ -75,13 +75,12 @@ static struct ipc_ids init_msg_ids;
 
 #define msg_lock(ns, id)	((struct msg_queue*)ipc_lock(&msg_ids(ns), id))
 #define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
-#define msg_rmid(ns, id)	((struct msg_queue*)ipc_rmid(&msg_ids(ns), id))
 #define msg_checkid(ns, msq, msgid)	\
 	ipc_checkid(&msg_ids(ns), &msq->q_perm, msgid)
 #define msg_buildid(ns, id, seq) \
 	ipc_buildid(&msg_ids(ns), id, seq)
 
-static void freeque (struct ipc_namespace *ns, struct msg_queue *msq, int id);
+static void freeque(struct ipc_namespace *, struct msg_queue *);
 static int newque (struct ipc_namespace *ns, key_t key, int msgflg);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it);
@@ -93,7 +92,7 @@ static void __msg_init_ns(struct ipc_nam
 	ns->msg_ctlmax = MSGMAX;
 	ns->msg_ctlmnb = MSGMNB;
 	ns->msg_ctlmni = MSGMNI;
-	ipc_init_ids(ids, ns->msg_ctlmni);
+	ipc_init_ids(ids);
 }
 
 int msg_init_ns(struct ipc_namespace *ns)
@@ -110,20 +109,24 @@ int msg_init_ns(struct ipc_namespace *ns
 
 void msg_exit_ns(struct ipc_namespace *ns)
 {
-	int i;
 	struct msg_queue *msq;
+	int next_id;
+	int total, in_use;
 
 	mutex_lock(&msg_ids(ns).mutex);
-	for (i = 0; i <= msg_ids(ns).max_id; i++) {
-		msq = msg_lock(ns, i);
+
+	in_use = msg_ids(ns).in_use;
+
+	for (total = 0, next_id = 0; total < in_use; next_id++) {
+		msq = idr_find(&msg_ids(ns).ipcs_idr, next_id);
 		if (msq == NULL)
 			continue;
-
-		freeque(ns, msq, i);
+		ipc_lock_by_ptr(&msq->q_perm);
+		freeque(ns, msq);
+		total++;
 	}
 	mutex_unlock(&msg_ids(ns).mutex);
 
-	ipc_fini_ids(ns->ids[IPC_MSG_IDS]);
 	kfree(ns->ids[IPC_MSG_IDS]);
 	ns->ids[IPC_MSG_IDS] = NULL;
 }
@@ -136,6 +139,11 @@ void __init msg_init(void)
 				IPC_MSG_IDS, sysvipc_msg_proc_show);
 }
 
+static inline void msg_rmid(struct ipc_namespace *ns, struct msg_queue *s)
+{
+	ipc_rmid(&msg_ids(ns), &s->q_perm);
+}
+
 static int newque (struct ipc_namespace *ns, key_t key, int msgflg)
 {
 	struct msg_queue *msq;
@@ -155,6 +163,9 @@ static int newque (struct ipc_namespace 
 		return retval;
 	}
 
+	/*
+	 * ipc_addid() locks msq
+	 */
 	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
 	if (id == -1) {
 		security_msg_queue_free(msq);
@@ -162,7 +173,7 @@ static int newque (struct ipc_namespace 
 		return -ENOSPC;
 	}
 
-	msq->q_id = msg_buildid(ns, id, msq->q_perm.seq);
+	msq->q_perm.id = msg_buildid(ns, id, msq->q_perm.seq);
 	msq->q_stime = msq->q_rtime = 0;
 	msq->q_ctime = get_seconds();
 	msq->q_cbytes = msq->q_qnum = 0;
@@ -171,9 +182,10 @@ static int newque (struct ipc_namespace 
 	INIT_LIST_HEAD(&msq->q_messages);
 	INIT_LIST_HEAD(&msq->q_receivers);
 	INIT_LIST_HEAD(&msq->q_senders);
+
 	msg_unlock(msq);
 
-	return msq->q_id;
+	return msq->q_perm.id;
 }
 
 static inline void ss_add(struct msg_queue *msq, struct msg_sender *mss)
@@ -225,18 +237,18 @@ static void expunge_all(struct msg_queue
 /*
  * freeque() wakes up waiters on the sender and receiver waiting queue,
  * removes the message queue from message queue ID
- * array, and cleans up all the messages associated with this queue.
+ * IDR, and cleans up all the messages associated with this queue.
  *
- * msg_ids.mutex and the spinlock for this message queue is hold
+ * msg_ids.mutex and the spinlock for this message queue are held
  * before freeque() is called. msg_ids.mutex remains locked on exit.
  */
-static void freeque(struct ipc_namespace *ns, struct msg_queue *msq, int id)
+static void freeque(struct ipc_namespace *ns, struct msg_queue *msq)
 {
 	struct list_head *tmp;
 
 	expunge_all(msq, -EIDRM);
 	ss_wakeup(&msq->q_senders, 1);
-	msq = msg_rmid(ns, id);
+	msg_rmid(ns, msq);
 	msg_unlock(msq);
 
 	tmp = msq->q_messages.next;
@@ -255,36 +267,51 @@ static void freeque(struct ipc_namespace
 asmlinkage long sys_msgget(key_t key, int msgflg)
 {
 	struct msg_queue *msq;
-	int id, ret = -EPERM;
+	int ret;
 	struct ipc_namespace *ns;
 
 	ns = current->nsproxy->ipc_ns;
-	
-	mutex_lock(&msg_ids(ns).mutex);
-	if (key == IPC_PRIVATE) 
-		ret = newque(ns, key, msgflg);
-	else if ((id = ipc_findkey(&msg_ids(ns), key)) == -1) { /* key not used */
-		if (!(msgflg & IPC_CREAT))
-			ret = -ENOENT;
-		else
+
+	ret = idr_pre_get(&msg_ids(ns).ipcs_idr, GFP_KERNEL);
+
+	if (key == IPC_PRIVATE)  {
+		if (!ret)
+			ret = -ENOMEM;
+		else {
+			mutex_lock(&msg_ids(ns).mutex);
 			ret = newque(ns, key, msgflg);
-	} else if (msgflg & IPC_CREAT && msgflg & IPC_EXCL) {
-		ret = -EEXIST;
+			mutex_unlock(&msg_ids(ns).mutex);
+		}
 	} else {
-		msq = msg_lock(ns, id);
-		BUG_ON(msq == NULL);
-		if (ipcperms(&msq->q_perm, msgflg))
-			ret = -EACCES;
-		else {
-			int qid = msg_buildid(ns, id, msq->q_perm.seq);
+		mutex_lock(&msg_ids(ns).mutex);
+		msq = (struct msg_queue *) ipc_findkey(&msg_ids(ns), key);
+		if (msq == NULL) {
+			/* key not used */
+			if (!(msgflg & IPC_CREAT))
+				ret = -ENOENT;
+			else if (!ret)
+				ret = -ENOMEM;
+			else
+				ret = newque(ns, key, msgflg);
+		} else {
+			/* msq has been locked by ipc_findkey() */
 
-			ret = security_msg_queue_associate(msq, msgflg);
-			if (!ret)
-				ret = qid;
+			if (msgflg & IPC_CREAT && msgflg & IPC_EXCL)
+				ret = -EEXIST;
+			else {
+				if (ipcperms(&msq->q_perm, msgflg))
+					ret = -EACCES;
+				else {
+					ret = security_msg_queue_associate(
+								msq, msgflg);
+					if (!ret)
+						ret = msq->q_perm.id;
+				}
+			}
+			msg_unlock(msq);
 		}
-		msg_unlock(msq);
+		mutex_unlock(&msg_ids(ns).mutex);
 	}
-	mutex_unlock(&msg_ids(ns).mutex);
 
 	return ret;
 }
@@ -430,13 +457,13 @@ asmlinkage long sys_msgctl(int msqid, in
 			msginfo.msgpool = MSGPOOL;
 			msginfo.msgtql = MSGTQL;
 		}
-		max_id = msg_ids(ns).max_id;
+		max_id = ipc_get_maxid(&msg_ids(ns));
 		mutex_unlock(&msg_ids(ns).mutex);
 		if (copy_to_user(buf, &msginfo, sizeof(struct msginfo)))
 			return -EFAULT;
 		return (max_id < 0) ? 0 : max_id;
 	}
-	case MSG_STAT:
+	case MSG_STAT:	/* msqid is an index rather than a msg queue id */
 	case IPC_STAT:
 	{
 		struct msqid64_ds tbuf;
@@ -444,8 +471,6 @@ asmlinkage long sys_msgctl(int msqid, in
 
 		if (!buf)
 			return -EFAULT;
-		if (cmd == MSG_STAT && msqid >= msg_ids(ns).entries->size)
-			return -EINVAL;
 
 		memset(&tbuf, 0, sizeof(tbuf));
 
@@ -454,7 +479,7 @@ asmlinkage long sys_msgctl(int msqid, in
 			return -EINVAL;
 
 		if (cmd == MSG_STAT) {
-			success_return = msg_buildid(ns, msqid, msq->q_perm.seq);
+			success_return = msq->q_perm.id;
 		} else {
 			err = -EIDRM;
 			if (msg_checkid(ns, msq, msqid))
@@ -552,7 +577,7 @@ asmlinkage long sys_msgctl(int msqid, in
 		break;
 	}
 	case IPC_RMID:
-		freeque(ns, msq, msqid);
+		freeque(ns, msq);
 		break;
 	}
 	err = 0;
@@ -926,7 +951,7 @@ static int sysvipc_msg_proc_show(struct 
 	return seq_printf(s,
 			"%10d %10d  %4o  %10lu %10lu %5u %5u %5u %5u %5u %5u %10lu %10lu %10lu\n",
 			msq->q_perm.key,
-			msq->q_id,
+			msq->q_perm.id,
 			msq->q_perm.mode,
 			msq->q_cbytes,
 			msq->q_qnum,
diff -puN ipc/sem.c~ipc-store-ipcs-into-idrs ipc/sem.c
--- a/ipc/sem.c~ipc-store-ipcs-into-idrs
+++ a/ipc/sem.c
@@ -90,7 +90,6 @@
 
 #define sem_lock(ns, id)	((struct sem_array*)ipc_lock(&sem_ids(ns), id))
 #define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
-#define sem_rmid(ns, id)	((struct sem_array*)ipc_rmid(&sem_ids(ns), id))
 #define sem_checkid(ns, sma, semid)	\
 	ipc_checkid(&sem_ids(ns),&sma->sem_perm,semid)
 #define sem_buildid(ns, id, seq) \
@@ -99,7 +98,7 @@
 static struct ipc_ids init_sem_ids;
 
 static int newary(struct ipc_namespace *, key_t, int, int);
-static void freeary(struct ipc_namespace *ns, struct sem_array *sma, int id);
+static void freeary(struct ipc_namespace *, struct sem_array *);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
 #endif
@@ -129,7 +128,7 @@ static void __sem_init_ns(struct ipc_nam
 	ns->sc_semopm = SEMOPM;
 	ns->sc_semmni = SEMMNI;
 	ns->used_sems = 0;
-	ipc_init_ids(ids, ns->sc_semmni);
+	ipc_init_ids(ids);
 }
 
 int sem_init_ns(struct ipc_namespace *ns)
@@ -146,20 +145,24 @@ int sem_init_ns(struct ipc_namespace *ns
 
 void sem_exit_ns(struct ipc_namespace *ns)
 {
-	int i;
 	struct sem_array *sma;
+	int next_id;
+	int total, in_use;
 
 	mutex_lock(&sem_ids(ns).mutex);
-	for (i = 0; i <= sem_ids(ns).max_id; i++) {
-		sma = sem_lock(ns, i);
+
+	in_use = sem_ids(ns).in_use;
+
+	for (total = 0, next_id = 0; total < in_use; next_id++) {
+		sma = idr_find(&sem_ids(ns).ipcs_idr, next_id);
 		if (sma == NULL)
 			continue;
-
-		freeary(ns, sma, i);
+		ipc_lock_by_ptr(&sma->sem_perm);
+		freeary(ns, sma);
+		total++;
 	}
 	mutex_unlock(&sem_ids(ns).mutex);
 
-	ipc_fini_ids(ns->ids[IPC_SEM_IDS]);
 	kfree(ns->ids[IPC_SEM_IDS]);
 	ns->ids[IPC_SEM_IDS] = NULL;
 }
@@ -172,6 +175,11 @@ void __init sem_init (void)
 				IPC_SEM_IDS, sysvipc_sem_proc_show);
 }
 
+static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
+{
+	ipc_rmid(&sem_ids(ns), &s->sem_perm);
+}
+
 /*
  * Lockless wakeup algorithm:
  * Without the check/retry algorithm a lockless wakeup is possible:
@@ -243,7 +251,7 @@ static int newary (struct ipc_namespace 
 	}
 	ns->used_sems += nsems;
 
-	sma->sem_id = sem_buildid(ns, id, sma->sem_perm.seq);
+	sma->sem_perm.id = sem_buildid(ns, id, sma->sem_perm.seq);
 	sma->sem_base = (struct sem *) &sma[1];
 	/* sma->sem_pending = NULL; */
 	sma->sem_pending_last = &sma->sem_pending;
@@ -252,12 +260,12 @@ static int newary (struct ipc_namespace 
 	sma->sem_ctime = get_seconds();
 	sem_unlock(sma);
 
-	return sma->sem_id;
+	return sma->sem_perm.id;
 }
 
 asmlinkage long sys_semget (key_t key, int nsems, int semflg)
 {
-	int id, err = -EINVAL;
+	int err;
 	struct sem_array *sma;
 	struct ipc_namespace *ns;
 
@@ -265,34 +273,50 @@ asmlinkage long sys_semget (key_t key, i
 
 	if (nsems < 0 || nsems > ns->sc_semmsl)
 		return -EINVAL;
-	mutex_lock(&sem_ids(ns).mutex);
-	
+
+	err = idr_pre_get(&sem_ids(ns).ipcs_idr, GFP_KERNEL);
+
 	if (key == IPC_PRIVATE) {
-		err = newary(ns, key, nsems, semflg);
-	} else if ((id = ipc_findkey(&sem_ids(ns), key)) == -1) {  /* key not used */
-		if (!(semflg & IPC_CREAT))
-			err = -ENOENT;
-		else
+		if (!err)
+			err = -ENOMEM;
+		else {
+			mutex_lock(&sem_ids(ns).mutex);
 			err = newary(ns, key, nsems, semflg);
-	} else if (semflg & IPC_CREAT && semflg & IPC_EXCL) {
-		err = -EEXIST;
+			mutex_unlock(&sem_ids(ns).mutex);
+		}
 	} else {
-		sma = sem_lock(ns, id);
-		BUG_ON(sma==NULL);
-		if (nsems > sma->sem_nsems)
-			err = -EINVAL;
-		else if (ipcperms(&sma->sem_perm, semflg))
-			err = -EACCES;
-		else {
-			int semid = sem_buildid(ns, id, sma->sem_perm.seq);
-			err = security_sem_associate(sma, semflg);
-			if (!err)
-				err = semid;
+		mutex_lock(&sem_ids(ns).mutex);
+		sma = (struct sem_array *) ipc_findkey(&sem_ids(ns), key);
+		if (sma == NULL) {
+			/* key not used */
+			if (!(semflg & IPC_CREAT))
+				err = -ENOENT;
+			else if (!err)
+				err = -ENOMEM;
+			else
+				err = newary(ns, key, nsems, semflg);
+		} else {
+			/* sma has been locked by ipc_findkey() */
+
+			if (semflg & IPC_CREAT && semflg & IPC_EXCL)
+				err = -EEXIST;
+			else {
+				if (nsems > sma->sem_nsems)
+					err = -EINVAL;
+				else if (ipcperms(&sma->sem_perm, semflg))
+					err = -EACCES;
+				else {
+					err = security_sem_associate(sma,
+								semflg);
+					if (!err)
+						err = sma->sem_perm.id;
+				}
+			}
+			sem_unlock(sma);
 		}
-		sem_unlock(sma);
+		mutex_unlock(&sem_ids(ns).mutex);
 	}
 
-	mutex_unlock(&sem_ids(ns).mutex);
 	return err;
 }
 
@@ -491,11 +515,10 @@ static int count_semzcnt (struct sem_arr
  * the spinlock for this semaphore set hold. sem_ids.mutex remains locked
  * on exit.
  */
-static void freeary (struct ipc_namespace *ns, struct sem_array *sma, int id)
+static void freeary(struct ipc_namespace *ns, struct sem_array *sma)
 {
 	struct sem_undo *un;
 	struct sem_queue *q;
-	int size;
 
 	/* Invalidate the existing undo structures for this semaphore set.
 	 * (They will be freed without any further action in exit_sem()
@@ -518,12 +541,11 @@ static void freeary (struct ipc_namespac
 		q = n;
 	}
 
-	/* Remove the semaphore set from the ID array*/
-	sma = sem_rmid(ns, id);
+	/* Remove the semaphore set from the IDR */
+	sem_rmid(ns, sma);
 	sem_unlock(sma);
 
 	ns->used_sems -= sma->sem_nsems;
-	size = sizeof (*sma) + sma->sem_nsems * sizeof (struct sem);
 	security_sem_free(sma);
 	ipc_rcu_putref(sma);
 }
@@ -584,7 +606,7 @@ static int semctl_nolock(struct ipc_name
 			seminfo.semusz = SEMUSZ;
 			seminfo.semaem = SEMAEM;
 		}
-		max_id = sem_ids(ns).max_id;
+		max_id = ipc_get_maxid(&sem_ids(ns));
 		mutex_unlock(&sem_ids(ns).mutex);
 		if (copy_to_user (arg.__buf, &seminfo, sizeof(struct seminfo))) 
 			return -EFAULT;
@@ -595,9 +617,6 @@ static int semctl_nolock(struct ipc_name
 		struct semid64_ds tbuf;
 		int id;
 
-		if(semid >= sem_ids(ns).entries->size)
-			return -EINVAL;
-
 		memset(&tbuf,0,sizeof(tbuf));
 
 		sma = sem_lock(ns, semid);
@@ -612,7 +631,7 @@ static int semctl_nolock(struct ipc_name
 		if (err)
 			goto out_unlock;
 
-		id = sem_buildid(ns, semid, sma->sem_perm.seq);
+		id = sma->sem_perm.id;
 
 		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
 		tbuf.sem_otime  = sma->sem_otime;
@@ -894,7 +913,7 @@ static int semctl_down(struct ipc_namesp
 
 	switch(cmd){
 	case IPC_RMID:
-		freeary(ns, sma, semid);
+		freeary(ns, sma);
 		err = 0;
 		break;
 	case IPC_SET:
@@ -1402,7 +1421,7 @@ static int sysvipc_sem_proc_show(struct 
 	return seq_printf(s,
 			  "%10d %10d  %4o %10lu %5u %5u %5u %5u %10lu %10lu\n",
 			  sma->sem_perm.key,
-			  sma->sem_id,
+			  sma->sem_perm.id,
 			  sma->sem_perm.mode,
 			  sma->sem_nsems,
 			  sma->sem_perm.uid,
diff -puN ipc/shm.c~ipc-store-ipcs-into-idrs ipc/shm.c
--- a/ipc/shm.c~ipc-store-ipcs-into-idrs
+++ a/ipc/shm.c
@@ -84,7 +84,7 @@ static void __shm_init_ns(struct ipc_nam
 	ns->shm_ctlall = SHMALL;
 	ns->shm_ctlmni = SHMMNI;
 	ns->shm_tot = 0;
-	ipc_init_ids(ids, 1);
+	ipc_init_ids(ids);
 }
 
 static void do_shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *shp)
@@ -112,20 +112,24 @@ int shm_init_ns(struct ipc_namespace *ns
 
 void shm_exit_ns(struct ipc_namespace *ns)
 {
-	int i;
 	struct shmid_kernel *shp;
+	int next_id;
+	int total, in_use;
 
 	mutex_lock(&shm_ids(ns).mutex);
-	for (i = 0; i <= shm_ids(ns).max_id; i++) {
-		shp = shm_lock(ns, i);
+
+	in_use = shm_ids(ns).in_use;
+
+	for (total = 0, next_id = 0; total < in_use; next_id++) {
+		shp = idr_find(&shm_ids(ns).ipcs_idr, next_id);
 		if (shp == NULL)
 			continue;
-
+		ipc_lock_by_ptr(&shp->shm_perm);
 		do_shm_rmid(ns, shp);
+		total++;
 	}
 	mutex_unlock(&shm_ids(ns).mutex);
 
-	ipc_fini_ids(ns->ids[IPC_SHM_IDS]);
 	kfree(ns->ids[IPC_SHM_IDS]);
 	ns->ids[IPC_SHM_IDS] = NULL;
 }
@@ -146,9 +150,9 @@ static inline int shm_checkid(struct ipc
 	return 0;
 }
 
-static inline struct shmid_kernel *shm_rmid(struct ipc_namespace *ns, int id)
+static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
 {
-	return (struct shmid_kernel *)ipc_rmid(&shm_ids(ns), id);
+	ipc_rmid(&shm_ids(ns), &s->shm_perm);
 }
 
 static inline int shm_addid(struct ipc_namespace *ns, struct shmid_kernel *shp)
@@ -184,7 +188,7 @@ static void shm_open(struct vm_area_stru
 static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 {
 	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	shm_rmid(ns, shp->id);
+	shm_rmid(ns, shp);
 	shm_unlock(shp);
 	if (!is_file_hugepages(shp->shm_file))
 		shmem_lock(shp->shm_file, 0, shp->mlock_user);
@@ -398,17 +402,18 @@ static int newseg (struct ipc_namespace 
 	shp->shm_ctim = get_seconds();
 	shp->shm_segsz = size;
 	shp->shm_nattch = 0;
-	shp->id = shm_buildid(ns, id, shp->shm_perm.seq);
+	shp->shm_perm.id = shm_buildid(ns, id, shp->shm_perm.seq);
 	shp->shm_file = file;
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
 	 * proc-ps tools use this. Changing this will break them.
 	 */
-	file->f_dentry->d_inode->i_ino = shp->id;
+	file->f_dentry->d_inode->i_ino = shp->shm_perm.id;
 
 	ns->shm_tot += numpages;
+	error = shp->shm_perm.id;
 	shm_unlock(shp);
-	return shp->id;
+	return error;
 
 no_id:
 	fput(file);
@@ -421,37 +426,52 @@ no_file:
 asmlinkage long sys_shmget (key_t key, size_t size, int shmflg)
 {
 	struct shmid_kernel *shp;
-	int err, id = 0;
+	int err;
 	struct ipc_namespace *ns;
 
 	ns = current->nsproxy->ipc_ns;
 
-	mutex_lock(&shm_ids(ns).mutex);
+	err = idr_pre_get(&shm_ids(ns).ipcs_idr, GFP_KERNEL);
+
 	if (key == IPC_PRIVATE) {
-		err = newseg(ns, key, shmflg, size);
-	} else if ((id = ipc_findkey(&shm_ids(ns), key)) == -1) {
-		if (!(shmflg & IPC_CREAT))
-			err = -ENOENT;
-		else
+		if (!err)
+			err = -ENOMEM;
+		else {
+			mutex_lock(&shm_ids(ns).mutex);
 			err = newseg(ns, key, shmflg, size);
-	} else if ((shmflg & IPC_CREAT) && (shmflg & IPC_EXCL)) {
-		err = -EEXIST;
+			mutex_unlock(&shm_ids(ns).mutex);
+		}
 	} else {
-		shp = shm_lock(ns, id);
-		BUG_ON(shp==NULL);
-		if (shp->shm_segsz < size)
-			err = -EINVAL;
-		else if (ipcperms(&shp->shm_perm, shmflg))
-			err = -EACCES;
-		else {
-			int shmid = shm_buildid(ns, id, shp->shm_perm.seq);
-			err = security_shm_associate(shp, shmflg);
-			if (!err)
-				err = shmid;
+		mutex_lock(&shm_ids(ns).mutex);
+		shp = (struct shmid_kernel *) ipc_findkey(&shm_ids(ns), key);
+		if (shp == NULL) {
+			if (!(shmflg & IPC_CREAT))
+				err = -ENOENT;
+			else if (!err)
+				err = -ENOMEM;
+			else
+				err = newseg(ns, key, shmflg, size);
+		} else {
+			/* shp has been locked by ipc_findkey() */
+
+			if ((shmflg & IPC_CREAT) && (shmflg & IPC_EXCL))
+				err = -EEXIST;
+			else {
+				if (shp->shm_segsz < size)
+					err = -EINVAL;
+				else if (ipcperms(&shp->shm_perm, shmflg))
+					err = -EACCES;
+				else {
+					err = security_shm_associate(shp,
+								shmflg);
+					if (!err)
+						err = shp->shm_perm.id;
+				}
+			}
+			shm_unlock(shp);
 		}
-		shm_unlock(shp);
+		mutex_unlock(&shm_ids(ns).mutex);
 	}
-	mutex_unlock(&shm_ids(ns).mutex);
 
 	return err;
 }
@@ -550,17 +570,20 @@ static inline unsigned long copy_shminfo
 static void shm_get_stat(struct ipc_namespace *ns, unsigned long *rss,
 		unsigned long *swp)
 {
-	int i;
+	int next_id;
+	int total, in_use;
 
 	*rss = 0;
 	*swp = 0;
 
-	for (i = 0; i <= shm_ids(ns).max_id; i++) {
+	in_use = shm_ids(ns).in_use;
+
+	for (total = 0, next_id = 0; total < in_use; next_id++) {
 		struct shmid_kernel *shp;
 		struct inode *inode;
 
-		shp = shm_get(ns, i);
-		if(!shp)
+		shp = shm_get(ns, next_id);
+		if (shp == NULL)
 			continue;
 
 		inode = shp->shm_file->f_path.dentry->d_inode;
@@ -575,6 +598,8 @@ static void shm_get_stat(struct ipc_name
 			*swp += info->swapped;
 			spin_unlock(&info->lock);
 		}
+
+		total++;
 	}
 }
 
@@ -611,7 +636,7 @@ asmlinkage long sys_shmctl (int shmid, i
 		if(copy_shminfo_to_user (buf, &shminfo, version))
 			return -EFAULT;
 		/* reading a integer is always atomic */
-		err= shm_ids(ns).max_id;
+		err = ipc_get_maxid(&shm_ids(ns));
 		if(err<0)
 			err = 0;
 		goto out;
@@ -631,7 +656,7 @@ asmlinkage long sys_shmctl (int shmid, i
 		shm_info.shm_tot = ns->shm_tot;
 		shm_info.swap_attempts = 0;
 		shm_info.swap_successes = 0;
-		err = shm_ids(ns).max_id;
+		err = ipc_get_maxid(&shm_ids(ns));
 		mutex_unlock(&shm_ids(ns).mutex);
 		if(copy_to_user (buf, &shm_info, sizeof(shm_info))) {
 			err = -EFAULT;
@@ -651,11 +676,8 @@ asmlinkage long sys_shmctl (int shmid, i
 		if(shp==NULL) {
 			err = -EINVAL;
 			goto out;
-		} else if(cmd==SHM_STAT) {
-			err = -EINVAL;
-			if (shmid > shm_ids(ns).max_id)
-				goto out_unlock;
-			result = shm_buildid(ns, shmid, shp->shm_perm.seq);
+		} else if (cmd == SHM_STAT) {
+			result = shp->shm_perm.id;
 		} else {
 			err = shm_checkid(ns, shp,shmid);
 			if(err)
@@ -925,7 +947,7 @@ long do_shmat(int shmid, char __user *sh
 
 	file->private_data = sfd;
 	file->f_mapping = shp->shm_file->f_mapping;
-	sfd->id = shp->id;
+	sfd->id = shp->shm_perm.id;
 	sfd->ns = get_ipc_ns(ns);
 	sfd->file = shp->shm_file;
 	sfd->vm_ops = NULL;
@@ -1094,7 +1116,7 @@ static int sysvipc_shm_proc_show(struct 
 		format = BIG_STRING;
 	return seq_printf(s, format,
 			  shp->shm_perm.key,
-			  shp->id,
+			  shp->shm_perm.id,
 			  shp->shm_perm.mode,
 			  shp->shm_segsz,
 			  shp->shm_cprid,
diff -puN ipc/util.c~ipc-store-ipcs-into-idrs ipc/util.c
--- a/ipc/util.c~ipc-store-ipcs-into-idrs
+++ a/ipc/util.c
@@ -129,23 +129,16 @@ __initcall(ipc_init);
 /**
  *	ipc_init_ids		-	initialise IPC identifiers
  *	@ids: Identifier set
- *	@size: Number of identifiers
  *
- *	Given a size for the ipc identifier range (limited below IPCMNI)
- *	set up the sequence range to use then allocate and initialise the
- *	array itself. 
+ *	Set up the sequence range to use for the ipc identifier range (limited
+ *	below IPCMNI) then initialise the ids idr.
  */
  
-void ipc_init_ids(struct ipc_ids* ids, int size)
+void ipc_init_ids(struct ipc_ids *ids)
 {
-	int i;
-
 	mutex_init(&ids->mutex);
 
-	if(size > IPCMNI)
-		size = IPCMNI;
 	ids->in_use = 0;
-	ids->max_id = -1;
 	ids->seq = 0;
 	{
 		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
@@ -155,17 +148,7 @@ void ipc_init_ids(struct ipc_ids* ids, i
 		 	ids->seq_max = seq_limit;
 	}
 
-	ids->entries = ipc_rcu_alloc(sizeof(struct kern_ipc_perm *)*size +
-				     sizeof(struct ipc_id_ary));
-
-	if(ids->entries == NULL) {
-		printk(KERN_ERR "ipc_init_ids() failed, ipc service disabled.\n");
-		size = 0;
-		ids->entries = &ids->nullentry;
-	}
-	ids->entries->size = size;
-	for(i=0;i<size;i++)
-		ids->entries->p[i] = NULL;
+	idr_init(&ids->ipcs_idr);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -209,72 +192,73 @@ void __init ipc_init_proc_interface(cons
  *	@key: The key to find
  *	
  *	Requires ipc_ids.mutex locked.
- *	Returns the identifier if found or -1 if not.
+ *	Returns the LOCKED pointer to the ipc structure if found or NULL
+ *	if not.
+ *	If key is found ipc contains its ipc structure
  */
  
-int ipc_findkey(struct ipc_ids* ids, key_t key)
+struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
 {
-	int id;
-	struct kern_ipc_perm* p;
-	int max_id = ids->max_id;
+	struct kern_ipc_perm *ipc;
+	int next_id;
+	int total;
 
-	/*
-	 * rcu_dereference() is not needed here
-	 * since ipc_ids.mutex is held
-	 */
-	for (id = 0; id <= max_id; id++) {
-		p = ids->entries->p[id];
-		if(p==NULL)
+	for (total = 0, next_id = 0; total < ids->in_use; next_id++) {
+		ipc = idr_find(&ids->ipcs_idr, next_id);
+
+		if (ipc == NULL)
 			continue;
-		if (key == p->key)
-			return id;
+
+		if (ipc->key != key) {
+			total++;
+			continue;
+		}
+
+		ipc_lock_by_ptr(ipc);
+		return ipc;
 	}
-	return -1;
+
+	return NULL;
 }
 
-/*
- * Requires ipc_ids.mutex locked
+/**
+ *	ipc_get_maxid 	-	get the last assigned id
+ *	@ids: IPC identifier set
+ *
+ *	Called with ipc_ids.mutex held.
  */
-static int grow_ary(struct ipc_ids* ids, int newsize)
+
+int ipc_get_maxid(struct ipc_ids *ids)
 {
-	struct ipc_id_ary* new;
-	struct ipc_id_ary* old;
-	int i;
-	int size = ids->entries->size;
-
-	if(newsize > IPCMNI)
-		newsize = IPCMNI;
-	if(newsize <= size)
-		return newsize;
-
-	new = ipc_rcu_alloc(sizeof(struct kern_ipc_perm *)*newsize +
-			    sizeof(struct ipc_id_ary));
-	if(new == NULL)
-		return size;
-	new->size = newsize;
-	memcpy(new->p, ids->entries->p, sizeof(struct kern_ipc_perm *)*size);
-	for(i=size;i<newsize;i++) {
-		new->p[i] = NULL;
-	}
-	old = ids->entries;
+	struct kern_ipc_perm *ipc;
+	int max_id = -1;
+	int total, id;
 
-	/*
-	 * Use rcu_assign_pointer() to make sure the memcpyed contents
-	 * of the new array are visible before the new array becomes visible.
-	 */
-	rcu_assign_pointer(ids->entries, new);
+	if (ids->in_use == 0)
+		return -1;
+
+	if (ids->in_use == IPCMNI)
+		return IPCMNI - 1;
 
-	__ipc_fini_ids(ids, old);
-	return newsize;
+	/* Look for the last assigned id */
+	total = 0;
+	for (id = 0; id < IPCMNI && total < ids->in_use; id++) {
+		ipc = idr_find(&ids->ipcs_idr, id);
+		if (ipc != NULL) {
+			max_id = id;
+			total++;
+		}
+	}
+	return max_id;
 }
 
 /**
  *	ipc_addid 	-	add an IPC identifier
  *	@ids: IPC identifier set
  *	@new: new IPC permission set
- *	@size: new size limit for the id array
+ *	@size: limit for the number of used ids
  *
- *	Add an entry 'new' to the IPC arrays. The permissions object is
+ *	Add an entry 'new' to the IPC idr. The permissions object is
  *	initialised and the first free entry is set up and the id assigned
  *	is returned. The list is returned in a locked state on success.
  *	On failure the list is not locked and -1 is returned.
@@ -284,23 +268,23 @@ static int grow_ary(struct ipc_ids* ids,
  
 int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 {
-	int id;
-
-	size = grow_ary(ids,size);
+	int id, err;
 
 	/*
 	 * rcu_dereference()() is not needed here since
 	 * ipc_ids.mutex is held
 	 */
-	for (id = 0; id < size; id++) {
-		if(ids->entries->p[id] == NULL)
-			goto found;
-	}
-	return -1;
-found:
+	if (size > IPCMNI)
+		size = IPCMNI;
+
+	if (ids->in_use >= size)
+		return -1;
+
+	err = idr_get_new(&ids->ipcs_idr, new, &id);
+	if (err)
+		return -1;
+
 	ids->in_use++;
-	if (id > ids->max_id)
-		ids->max_id = id;
 
 	new->cuid = new->uid = current->euid;
 	new->gid = new->cgid = current->egid;
@@ -313,48 +297,32 @@ found:
 	new->deleted = 0;
 	rcu_read_lock();
 	spin_lock(&new->lock);
-	ids->entries->p[id] = new;
 	return id;
 }
 
 /**
  *	ipc_rmid	-	remove an IPC identifier
  *	@ids: identifier set
- *	@id: Identifier to remove
+ *	@id: ipc perm structure containing the identifier to remove
  *
  *	The identifier must be valid, and in use. The kernel will panic if
  *	fed an invalid identifier. The entry is removed and internal
- *	variables recomputed. The object associated with the identifier
- *	is returned.
- *	ipc_ids.mutex and the spinlock for this ID is hold before this function
- *	is called, and remain locked on the exit.
+ *	variables recomputed.
+ *	ipc_ids.mutex and the spinlock for this ID are held before this
+ *	function is called, and remain locked on the exit.
  */
  
-struct kern_ipc_perm* ipc_rmid(struct ipc_ids* ids, int id)
+void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 {
-	struct kern_ipc_perm* p;
-	int lid = id % SEQ_MULTIPLIER;
-	BUG_ON(lid >= ids->entries->size);
+	int lid = ipcp->id % SEQ_MULTIPLIER;
+
+	idr_remove(&ids->ipcs_idr, lid);
 
-	/* 
-	 * do not need a rcu_dereference()() here to force ordering
-	 * on Alpha, since the ipc_ids.mutex is held.
-	 */	
-	p = ids->entries->p[lid];
-	ids->entries->p[lid] = NULL;
-	BUG_ON(p==NULL);
 	ids->in_use--;
 
-	if (lid == ids->max_id) {
-		do {
-			lid--;
-			if(lid == -1)
-				break;
-		} while (ids->entries->p[lid] == NULL);
-		ids->max_id = lid;
-	}
-	p->deleted = 1;
-	return p;
+	ipcp->deleted = 1;
+
+	return;
 }
 
 /**
@@ -613,33 +581,26 @@ void ipc64_perm_to_ipc_perm (struct ipc6
  * if in the future ipc_get() is used by other places without ipc_ids.mutex
  * down, then ipc_get() needs read memery barriers as ipc_lock() does.
  */
-struct kern_ipc_perm* ipc_get(struct ipc_ids* ids, int id)
+struct kern_ipc_perm *ipc_get(struct ipc_ids *ids, int id)
 {
-	struct kern_ipc_perm* out;
+	struct kern_ipc_perm *out;
 	int lid = id % SEQ_MULTIPLIER;
-	if(lid >= ids->entries->size)
-		return NULL;
-	out = ids->entries->p[lid];
+	out = idr_find(&ids->ipcs_idr, lid);
 	return out;
 }
 
-struct kern_ipc_perm* ipc_lock(struct ipc_ids* ids, int id)
+struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 {
-	struct kern_ipc_perm* out;
+	struct kern_ipc_perm *out;
 	int lid = id % SEQ_MULTIPLIER;
-	struct ipc_id_ary* entries;
 
 	rcu_read_lock();
-	entries = rcu_dereference(ids->entries);
-	if(lid >= entries->size) {
-		rcu_read_unlock();
-		return NULL;
-	}
-	out = entries->p[lid];
-	if(out == NULL) {
+	out = idr_find(&ids->ipcs_idr, lid);
+	if (out == NULL) {
 		rcu_read_unlock();
 		return NULL;
 	}
+
 	spin_lock(&out->lock);
 	
 	/* ipc_rmid() may have already freed the ID while ipc_lock
@@ -650,6 +611,7 @@ struct kern_ipc_perm* ipc_lock(struct ip
 		rcu_read_unlock();
 		return NULL;
 	}
+
 	return out;
 }
 
@@ -707,27 +669,30 @@ struct ipc_proc_iter {
 	struct ipc_proc_iface *iface;
 };
 
-static void *sysvipc_proc_next(struct seq_file *s, void *it, loff_t *pos)
+/*
+ * This routine locks the ipc structure found at least at position pos.
+ */
+struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
+					loff_t *new_pos)
 {
-	struct ipc_proc_iter *iter = s->private;
-	struct ipc_proc_iface *iface = iter->iface;
-	struct kern_ipc_perm *ipc = it;
-	loff_t p;
-	struct ipc_ids *ids;
+	struct kern_ipc_perm *ipc;
+	int total, id;
 
-	ids = iter->ns->ids[iface->ids];
+	total = 0;
+	for (id = 0; id < pos && total < ids->in_use; id++) {
+		ipc = idr_find(&ids->ipcs_idr, id);
+		if (ipc != NULL)
+			total++;
+	}
 
-	/* If we had an ipc id locked before, unlock it */
-	if (ipc && ipc != SEQ_START_TOKEN)
-		ipc_unlock(ipc);
+	if (total >= ids->in_use)
+		return NULL;
 
-	/*
-	 * p = *pos - 1 (because id 0 starts at position 1)
-	 *          + 1 (because we increment the position by one)
-	 */
-	for (p = *pos; p <= ids->max_id; p++) {
-		if ((ipc = ipc_lock(ids, p)) != NULL) {
-			*pos = p + 1;
+	for ( ; pos < IPCMNI; pos++) {
+		ipc = idr_find(&ids->ipcs_idr, pos);
+		if (ipc != NULL) {
+			*new_pos = pos + 1;
+			ipc_lock_by_ptr(ipc);
 			return ipc;
 		}
 	}
@@ -736,6 +701,19 @@ static void *sysvipc_proc_next(struct se
 	return NULL;
 }
 
+static void *sysvipc_proc_next(struct seq_file *s, void *it, loff_t *pos)
+{
+	struct ipc_proc_iter *iter = s->private;
+	struct ipc_proc_iface *iface = iter->iface;
+	struct kern_ipc_perm *ipc = it;
+
+	/* If we had an ipc id locked before, unlock it */
+	if (ipc && ipc != SEQ_START_TOKEN)
+		ipc_unlock(ipc);
+
+	return sysvipc_find_ipc(iter->ns->ids[iface->ids], *pos, pos);
+}
+
 /*
  * File positions: pos 0 -> header, pos n -> ipc id + 1.
  * SeqFile iterator: iterator value locked shp or SEQ_TOKEN_START.
@@ -744,8 +722,6 @@ static void *sysvipc_proc_start(struct s
 {
 	struct ipc_proc_iter *iter = s->private;
 	struct ipc_proc_iface *iface = iter->iface;
-	struct kern_ipc_perm *ipc;
-	loff_t p;
 	struct ipc_ids *ids;
 
 	ids = iter->ns->ids[iface->ids];
@@ -765,13 +741,7 @@ static void *sysvipc_proc_start(struct s
 		return SEQ_START_TOKEN;
 
 	/* Find the (pos-1)th ipc */
-	for (p = *pos - 1; p <= ids->max_id; p++) {
-		if ((ipc = ipc_lock(ids, p)) != NULL) {
-			*pos = p + 1;
-			return ipc;
-		}
-	}
-	return NULL;
+	return sysvipc_find_ipc(ids, *pos - 1, pos);
 }
 
 static void sysvipc_proc_stop(struct seq_file *s, void *it)
diff -puN ipc/util.h~ipc-store-ipcs-into-idrs ipc/util.h
--- a/ipc/util.h~ipc-store-ipcs-into-idrs
+++ a/ipc/util.h
@@ -10,6 +10,8 @@
 #ifndef _IPC_UTIL_H
 #define _IPC_UTIL_H
 
+#include <linux/idr.h>
+
 #define USHRT_MAX 0xffff
 #define SEQ_MULTIPLIER	(IPCMNI)
 
@@ -25,24 +27,17 @@ void sem_exit_ns(struct ipc_namespace *n
 void msg_exit_ns(struct ipc_namespace *ns);
 void shm_exit_ns(struct ipc_namespace *ns);
 
-struct ipc_id_ary {
-	int size;
-	struct kern_ipc_perm *p[0];
-};
-
 struct ipc_ids {
 	int in_use;
-	int max_id;
 	unsigned short seq;
 	unsigned short seq_max;
 	struct mutex mutex;
-	struct ipc_id_ary nullentry;
-	struct ipc_id_ary* entries;
+	struct idr ipcs_idr;
 };
 
 struct seq_file;
 
-void ipc_init_ids(struct ipc_ids *ids, int size);
+void ipc_init_ids(struct ipc_ids *);
 #ifdef CONFIG_PROC_FS
 void __init ipc_init_proc_interface(const char *path, const char *header,
 		int ids, int (*show)(struct seq_file *, void *));
@@ -55,11 +50,12 @@ void __init ipc_init_proc_interface(cons
 #define IPC_SHM_IDS	2
 
 /* must be called with ids->mutex acquired.*/
-int ipc_findkey(struct ipc_ids* ids, key_t key);
-int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size);
+struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key);
+int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
+int ipc_get_maxid(struct ipc_ids *);
 
 /* must be called with both locks acquired. */
-struct kern_ipc_perm* ipc_rmid(struct ipc_ids* ids, int id);
+void ipc_rmid(struct ipc_ids *, struct kern_ipc_perm *);
 
 int ipcperms (struct kern_ipc_perm *ipcp, short flg);
 
@@ -79,18 +75,6 @@ void* ipc_rcu_alloc(int size);
 void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
-static inline void __ipc_fini_ids(struct ipc_ids *ids,
-		struct ipc_id_ary *entries)
-{
-	if (entries != &ids->nullentry)
-		ipc_rcu_putref(entries);
-}
-
-static inline void ipc_fini_ids(struct ipc_ids *ids)
-{
-	__ipc_fini_ids(ids, ids->entries);
-}
-
 struct kern_ipc_perm* ipc_get(struct ipc_ids* ids, int id);
 struct kern_ipc_perm* ipc_lock(struct ipc_ids* ids, int id);
 void ipc_lock_by_ptr(struct kern_ipc_perm *ipcp);
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
