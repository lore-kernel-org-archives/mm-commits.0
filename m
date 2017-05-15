From: akpm@linux-foundation.org
Subject: + ipc-merge-ipc_rcu-and-kern_ipc_perm.patch added to -mm tree
Date: Mon, 15 May 2017 13:10:07 -0700
Message-ID: <591a0b1f.QRljq5i84lEzqEEK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39324 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966591AbdEOUKI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 16:10:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, 1vier1@web.de, dave@stgolabs.net, fabf@skynet.be, keescook@chromium.org, mingo@kernel.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: merge ipc_rcu and kern_ipc_perm
has been added to the -mm tree.  Its filename is
     ipc-merge-ipc_rcu-and-kern_ipc_perm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-merge-ipc_rcu-and-kern_ipc_perm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-merge-ipc_rcu-and-kern_ipc_perm.patch

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
Subject: ipc: merge ipc_rcu and kern_ipc_perm

ipc has two management structures that exist for every id:
- struct kern_ipc_perm, it contains e.g. the permissions.
- struct ipc_rcu, it contains the rcu head for rcu handling and
  the refcount.

The patch merges both structures.

As a bonus, we may save one cacheline, because both structures are
cacheline aligned.

In addition, it reduces the number of casts, instead most codepaths can
use container_of.

Link: http://lkml.kernel.org/r/20170515171912.6298-3-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: <1vier1@web.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h |    3 +++
 ipc/msg.c           |   22 ++++++++++++++--------
 ipc/sem.c           |   35 ++++++++++++++++++++---------------
 ipc/shm.c           |   21 ++++++++++++++-------
 ipc/util.c          |   33 +++++++++++++++------------------
 ipc/util.h          |   18 +++++++-----------
 6 files changed, 73 insertions(+), 59 deletions(-)

diff -puN include/linux/ipc.h~ipc-merge-ipc_rcu-and-kern_ipc_perm include/linux/ipc.h
--- a/include/linux/ipc.h~ipc-merge-ipc_rcu-and-kern_ipc_perm
+++ a/include/linux/ipc.h
@@ -20,6 +20,9 @@ struct kern_ipc_perm {
 	umode_t		mode;
 	unsigned long	seq;
 	void		*security;
+
+	struct rcu_head rcu;
+	atomic_t refcount;
 } ____cacheline_aligned_in_smp;
 
 #endif /* _LINUX_IPC_H */
diff -puN ipc/msg.c~ipc-merge-ipc_rcu-and-kern_ipc_perm ipc/msg.c
--- a/ipc/msg.c~ipc-merge-ipc_rcu-and-kern_ipc_perm
+++ a/ipc/msg.c
@@ -97,8 +97,8 @@ static inline void msg_rmid(struct ipc_n
 
 static void msg_rcu_free(struct rcu_head *head)
 {
-	struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
-	struct msg_queue *msq = ipc_rcu_to_struct(p);
+	struct kern_ipc_perm *p = container_of(head, struct kern_ipc_perm, rcu);
+	struct msg_queue *msq = container_of(p, struct msg_queue, q_perm);
 
 	security_msg_queue_free(msq);
 	ipc_rcu_free(head);
@@ -118,7 +118,13 @@ static int newque(struct ipc_namespace *
 	key_t key = params->key;
 	int msgflg = params->flg;
 
-	msq = ipc_rcu_alloc(sizeof(*msq));
+	if (offsetof(struct msg_queue, q_perm) != 0) {
+		pr_err("Invalid struct sem_perm, failing msgget().\n");
+		return -ENOMEM;
+	}
+
+	msq = container_of(ipc_rcu_alloc(sizeof(*msq)), struct msg_queue,
+				q_perm);
 	if (!msq)
 		return -ENOMEM;
 
@@ -128,7 +134,7 @@ static int newque(struct ipc_namespace *
 	msq->q_perm.security = NULL;
 	retval = security_msg_queue_alloc(msq);
 	if (retval) {
-		ipc_rcu_putref(msq, ipc_rcu_free);
+		ipc_rcu_putref(&msq->q_perm, ipc_rcu_free);
 		return retval;
 	}
 
@@ -144,7 +150,7 @@ static int newque(struct ipc_namespace *
 	/* ipc_addid() locks msq upon success. */
 	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
 	if (id < 0) {
-		ipc_rcu_putref(msq, msg_rcu_free);
+		ipc_rcu_putref(&msq->q_perm, msg_rcu_free);
 		return id;
 	}
 
@@ -249,7 +255,7 @@ static void freeque(struct ipc_namespace
 		free_msg(msg);
 	}
 	atomic_sub(msq->q_cbytes, &ns->msg_bytes);
-	ipc_rcu_putref(msq, msg_rcu_free);
+	ipc_rcu_putref(&msq->q_perm, msg_rcu_free);
 }
 
 /*
@@ -688,7 +694,7 @@ long do_msgsnd(int msqid, long mtype, vo
 		/* enqueue the sender and prepare to block */
 		ss_add(msq, &s, msgsz);
 
-		if (!ipc_rcu_getref(msq)) {
+		if (!ipc_rcu_getref(&msq->q_perm)) {
 			err = -EIDRM;
 			goto out_unlock0;
 		}
@@ -700,7 +706,7 @@ long do_msgsnd(int msqid, long mtype, vo
 		rcu_read_lock();
 		ipc_lock_object(&msq->q_perm);
 
-		ipc_rcu_putref(msq, msg_rcu_free);
+		ipc_rcu_putref(&msq->q_perm, msg_rcu_free);
 		/* raced with RMID? */
 		if (!ipc_valid_object(&msq->q_perm)) {
 			err = -EIDRM;
diff -puN ipc/sem.c~ipc-merge-ipc_rcu-and-kern_ipc_perm ipc/sem.c
--- a/ipc/sem.c~ipc-merge-ipc_rcu-and-kern_ipc_perm
+++ a/ipc/sem.c
@@ -260,8 +260,8 @@ static void merge_queues(struct sem_arra
 
 static void sem_rcu_free(struct rcu_head *head)
 {
-	struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
-	struct sem_array *sma = ipc_rcu_to_struct(p);
+	struct kern_ipc_perm *p = container_of(head, struct kern_ipc_perm, rcu);
+	struct sem_array *sma = container_of(p, struct sem_array, sem_perm);
 
 	security_sem_free(sma);
 	ipc_rcu_free(head);
@@ -438,7 +438,7 @@ static inline struct sem_array *sem_obta
 static inline void sem_lock_and_putref(struct sem_array *sma)
 {
 	sem_lock(sma, NULL, -1);
-	ipc_rcu_putref(sma, sem_rcu_free);
+	ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 }
 
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
@@ -469,8 +469,13 @@ static int newary(struct ipc_namespace *
 	if (ns->used_sems + nsems > ns->sc_semmns)
 		return -ENOSPC;
 
+	if (offsetof(struct sem_array, sem_perm) != 0) {
+		pr_err("Invalid struct sem_perm, failing semget().\n");
+		return -ENOMEM;
+	}
+
 	size = sizeof(*sma) + nsems * sizeof(sma->sems[0]);
-	sma = ipc_rcu_alloc(size);
+	sma = container_of(ipc_rcu_alloc(size), struct sem_array, sem_perm);
 	if (!sma)
 		return -ENOMEM;
 
@@ -482,7 +487,7 @@ static int newary(struct ipc_namespace *
 	sma->sem_perm.security = NULL;
 	retval = security_sem_alloc(sma);
 	if (retval) {
-		ipc_rcu_putref(sma, ipc_rcu_free);
+		ipc_rcu_putref(&sma->sem_perm, ipc_rcu_free);
 		return retval;
 	}
 
@@ -502,7 +507,7 @@ static int newary(struct ipc_namespace *
 
 	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
 	if (id < 0) {
-		ipc_rcu_putref(sma, sem_rcu_free);
+		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 		return id;
 	}
 	ns->used_sems += nsems;
@@ -1122,7 +1127,7 @@ static void freeary(struct ipc_namespace
 
 	wake_up_q(&wake_q);
 	ns->used_sems -= sma->sem_nsems;
-	ipc_rcu_putref(sma, sem_rcu_free);
+	ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 }
 
 static unsigned long copy_semid_to_user(void __user *buf, struct semid64_ds *in, int version)
@@ -1362,7 +1367,7 @@ static int semctl_main(struct ipc_namesp
 			goto out_unlock;
 		}
 		if (nsems > SEMMSL_FAST) {
-			if (!ipc_rcu_getref(sma)) {
+			if (!ipc_rcu_getref(&sma->sem_perm)) {
 				err = -EIDRM;
 				goto out_unlock;
 			}
@@ -1370,7 +1375,7 @@ static int semctl_main(struct ipc_namesp
 			rcu_read_unlock();
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if (sem_io == NULL) {
-				ipc_rcu_putref(sma, sem_rcu_free);
+				ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 				return -ENOMEM;
 			}
 
@@ -1395,7 +1400,7 @@ static int semctl_main(struct ipc_namesp
 		int i;
 		struct sem_undo *un;
 
-		if (!ipc_rcu_getref(sma)) {
+		if (!ipc_rcu_getref(&sma->sem_perm)) {
 			err = -EIDRM;
 			goto out_rcu_wakeup;
 		}
@@ -1404,20 +1409,20 @@ static int semctl_main(struct ipc_namesp
 		if (nsems > SEMMSL_FAST) {
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if (sem_io == NULL) {
-				ipc_rcu_putref(sma, sem_rcu_free);
+				ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 				return -ENOMEM;
 			}
 		}
 
 		if (copy_from_user(sem_io, p, nsems*sizeof(ushort))) {
-			ipc_rcu_putref(sma, sem_rcu_free);
+			ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 			err = -EFAULT;
 			goto out_free;
 		}
 
 		for (i = 0; i < nsems; i++) {
 			if (sem_io[i] > SEMVMX) {
-				ipc_rcu_putref(sma, sem_rcu_free);
+				ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 				err = -ERANGE;
 				goto out_free;
 			}
@@ -1699,7 +1704,7 @@ static struct sem_undo *find_alloc_undo(
 	}
 
 	nsems = sma->sem_nsems;
-	if (!ipc_rcu_getref(sma)) {
+	if (!ipc_rcu_getref(&sma->sem_perm)) {
 		rcu_read_unlock();
 		un = ERR_PTR(-EIDRM);
 		goto out;
@@ -1709,7 +1714,7 @@ static struct sem_undo *find_alloc_undo(
 	/* step 2: allocate new undo structure */
 	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
 	if (!new) {
-		ipc_rcu_putref(sma, sem_rcu_free);
+		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 		return ERR_PTR(-ENOMEM);
 	}
 
diff -puN ipc/shm.c~ipc-merge-ipc_rcu-and-kern_ipc_perm ipc/shm.c
--- a/ipc/shm.c~ipc-merge-ipc_rcu-and-kern_ipc_perm
+++ a/ipc/shm.c
@@ -174,9 +174,10 @@ static inline void shm_lock_by_ptr(struc
 
 static void shm_rcu_free(struct rcu_head *head)
 {
-	struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
-	struct shmid_kernel *shp = ipc_rcu_to_struct(p);
-
+	struct kern_ipc_perm *ptr = container_of(head, struct kern_ipc_perm,
+							rcu);
+	struct shmid_kernel *shp = container_of(ptr, struct shmid_kernel,
+							shm_perm);
 	security_shm_free(shp);
 	ipc_rcu_free(head);
 }
@@ -241,7 +242,7 @@ static void shm_destroy(struct ipc_names
 		user_shm_unlock(i_size_read(file_inode(shm_file)),
 				shp->mlock_user);
 	fput(shm_file);
-	ipc_rcu_putref(shp, shm_rcu_free);
+	ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
 }
 
 /*
@@ -542,7 +543,13 @@ static int newseg(struct ipc_namespace *
 			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
 
-	shp = ipc_rcu_alloc(sizeof(*shp));
+	if (offsetof(struct shmid_kernel, shm_perm) != 0) {
+		pr_err("Invalid struct sem_perm, failing msgget().\n");
+		return -ENOMEM;
+	}
+
+	shp = container_of(ipc_rcu_alloc(sizeof(*shp)), struct shmid_kernel,
+				shm_perm);
 	if (!shp)
 		return -ENOMEM;
 
@@ -553,7 +560,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_perm.security = NULL;
 	error = security_shm_alloc(shp);
 	if (error) {
-		ipc_rcu_putref(shp, ipc_rcu_free);
+		ipc_rcu_putref(&shp->shm_perm, ipc_rcu_free);
 		return error;
 	}
 
@@ -624,7 +631,7 @@ no_id:
 		user_shm_unlock(size, shp->mlock_user);
 	fput(file);
 no_file:
-	ipc_rcu_putref(shp, shm_rcu_free);
+	ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
 	return error;
 }
 
diff -puN ipc/util.c~ipc-merge-ipc_rcu-and-kern_ipc_perm ipc/util.c
--- a/ipc/util.c~ipc-merge-ipc_rcu-and-kern_ipc_perm
+++ a/ipc/util.c
@@ -418,46 +418,43 @@ void ipc_free(void *ptr)
 }
 
 /**
- * ipc_rcu_alloc - allocate ipc and rcu space
+ * ipc_rcu_alloc - allocate ipc space
  * @size: size desired
  *
- * Allocate memory for the rcu header structure +  the object.
- * Returns the pointer to the object or NULL upon failure.
+ * Allocate memory for an ipc object.
+ * The first member must be struct kern_ipc_perm.
  */
-void *ipc_rcu_alloc(int size)
+struct kern_ipc_perm *ipc_rcu_alloc(int size)
 {
 	/*
 	 * We prepend the allocation with the rcu struct
 	 */
-	struct ipc_rcu *out = ipc_alloc(sizeof(struct ipc_rcu) + size);
+	struct kern_ipc_perm *out = ipc_alloc(size);
 	if (unlikely(!out))
 		return NULL;
 	atomic_set(&out->refcount, 1);
-	return out + 1;
+	return out;
 }
 
-int ipc_rcu_getref(void *ptr)
+int ipc_rcu_getref(struct kern_ipc_perm *ptr)
 {
-	struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;
-
-	return atomic_inc_not_zero(&p->refcount);
+	return atomic_inc_not_zero(&ptr->refcount);
 }
 
-void ipc_rcu_putref(void *ptr, void (*func)(struct rcu_head *head))
+void ipc_rcu_putref(struct kern_ipc_perm *ptr,
+			void (*func)(struct rcu_head *head))
 {
-	struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;
-
-	if (!atomic_dec_and_test(&p->refcount))
+	if (!atomic_dec_and_test(&ptr->refcount))
 		return;
 
-	call_rcu(&p->rcu, func);
+	call_rcu(&ptr->rcu, func);
 }
 
-void ipc_rcu_free(struct rcu_head *head)
+void ipc_rcu_free(struct rcu_head *h)
 {
-	struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
+	struct kern_ipc_perm *ptr = container_of(h, struct kern_ipc_perm, rcu);
 
-	kvfree(p);
+	kvfree(ptr);
 }
 
 /**
diff -puN ipc/util.h~ipc-merge-ipc_rcu-and-kern_ipc_perm ipc/util.h
--- a/ipc/util.h~ipc-merge-ipc_rcu-and-kern_ipc_perm
+++ a/ipc/util.h
@@ -47,13 +47,6 @@ static inline void msg_exit_ns(struct ip
 static inline void shm_exit_ns(struct ipc_namespace *ns) { }
 #endif
 
-struct ipc_rcu {
-	struct rcu_head rcu;
-	atomic_t refcount;
-} ____cacheline_aligned_in_smp;
-
-#define ipc_rcu_to_struct(p)  ((void *)(p+1))
-
 /*
  * Structure that holds the parameters needed by the ipc operations
  * (see after)
@@ -125,11 +118,14 @@ void ipc_free(void *ptr);
  * Objects are reference counted, they start with reference count 1.
  * getref increases the refcount, the putref call that reduces the recount
  * to 0 schedules the rcu destruction. Caller must guarantee locking.
+ *
+ * struct kern_ipc_perm must be the first member in the allocated structure.
  */
-void *ipc_rcu_alloc(int size);
-int ipc_rcu_getref(void *ptr);
-void ipc_rcu_putref(void *ptr, void (*func)(struct rcu_head *head));
-void ipc_rcu_free(struct rcu_head *head);
+struct kern_ipc_perm *ipc_rcu_alloc(int size);
+int ipc_rcu_getref(struct kern_ipc_perm *ptr);
+void ipc_rcu_putref(struct kern_ipc_perm *ptr,
+			void (*func)(struct rcu_head *head));
+void ipc_rcu_free(struct rcu_head *h);
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
 struct kern_ipc_perm *ipc_obtain_object_idr(struct ipc_ids *ids, int id);
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-remove-sem_base-embed-struct-sem.patch
ipc-merge-ipc_rcu-and-kern_ipc_perm.patch
include-linux-semh-correctly-document-sem_ctime.patch

