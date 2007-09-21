From: akpm@linux-foundation.org
Subject: + ipc_fix_wrong_comments.patch added to -mm tree
Date: Fri, 21 Sep 2007 02:43:45 -0700
Message-ID: <200709210943.l8L9hj7R029387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40514 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbXIUJo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 05:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net


The patch titled
     ipc: fix wrong comments
has been added to the -mm tree.  Its filename is
     ipc_fix_wrong_comments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ipc: fix wrong comments
From: Nadia Derbey <Nadia.Derbey@bull.net>

This patch fixes the wrong / obsolete comments in the ipc code.  Also adds
a missing lock around ipc_get_maxid() in shm_get_stat().

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |   14 +++++++--
 ipc/sem.c  |   14 +++++++++
 ipc/shm.c  |   39 +++++++++++++++++--------
 ipc/util.c |   78 ++++++++++++++++++++++++++++++++-------------------
 ipc/util.h |   18 ++++++++++-
 5 files changed, 118 insertions(+), 45 deletions(-)

diff -puN ipc/msg.c~ipc_fix_wrong_comments ipc/msg.c
--- a/ipc/msg.c~ipc_fix_wrong_comments
+++ a/ipc/msg.c
@@ -156,6 +156,13 @@ static inline void msg_rmid(struct ipc_n
 	ipc_rmid(&msg_ids(ns), &s->q_perm);
 }
 
+/**
+ * newque - Create a new msg queue
+ * @ns: namespace
+ * @params: ptr to the structure that contains the key and msgflg
+ *
+ * Called with msg_ids.mutex held
+ */
 static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 {
 	struct msg_queue *msq;
@@ -250,8 +257,8 @@ static void expunge_all(struct msg_queue
 
 /*
  * freeque() wakes up waiters on the sender and receiver waiting queue,
- * removes the message queue from message queue ID
- * IDR, and cleans up all the messages associated with this queue.
+ * removes the message queue from message queue ID IDR, and cleans up all the
+ * messages associated with this queue.
  *
  * msg_ids.mutex and the spinlock for this message queue are held
  * before freeque() is called. msg_ids.mutex remains locked on exit.
@@ -278,6 +285,9 @@ static void freeque(struct ipc_namespace
 	ipc_rcu_putref(msq);
 }
 
+/*
+ * Called with msg_ids.mutex and ipcp locked.
+ */
 static inline int msg_security(struct kern_ipc_perm *ipcp, int msgflg)
 {
 	struct msg_queue *msq = container_of(ipcp, struct msg_queue, q_perm);
diff -puN ipc/sem.c~ipc_fix_wrong_comments ipc/sem.c
--- a/ipc/sem.c~ipc_fix_wrong_comments
+++ a/ipc/sem.c
@@ -228,6 +228,14 @@ static inline void sem_rmid(struct ipc_n
  */
 #define IN_WAKEUP	1
 
+/**
+ * newary - Create a new semaphore set
+ * @ns: namespace
+ * @params: ptr to the structure that contains key, semflg and nsems
+ *
+ * Called with sem_ids.mutex held
+ */
+
 static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 {
 	int id;
@@ -281,6 +289,9 @@ static int newary(struct ipc_namespace *
 }
 
 
+/*
+ * Called with sem_ids.mutex and ipcp locked.
+ */
 static inline int sem_security(struct kern_ipc_perm *ipcp, int semflg)
 {
 	struct sem_array *sma;
@@ -289,6 +300,9 @@ static inline int sem_security(struct ke
 	return security_sem_associate(sma, semflg);
 }
 
+/*
+ * Called with sem_ids.mutex and ipcp locked.
+ */
 static inline int sem_more_checks(struct kern_ipc_perm *ipcp,
 				struct ipc_params *params)
 {
diff -puN ipc/shm.c~ipc_fix_wrong_comments ipc/shm.c
--- a/ipc/shm.c~ipc_fix_wrong_comments
+++ a/ipc/shm.c
@@ -82,6 +82,10 @@ static void __shm_init_ns(struct ipc_nam
 	ipc_init_ids(ids);
 }
 
+/*
+ * Called with shm_ids.mutex and the shp structure locked.
+ * Only shm_ids.mutex remains locked on exit.
+ */
 static void do_shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *shp)
 {
 	if (shp->shm_nattch){
@@ -182,6 +186,7 @@ static void shm_open(struct vm_area_stru
 /*
  * shm_destroy - free the struct shmid_kernel
  *
+ * @ns: namespace
  * @shp: struct to free
  *
  * It has to be called with shp and shm_ids.mutex locked,
@@ -343,6 +348,14 @@ static struct vm_operations_struct shm_v
 #endif
 };
 
+/**
+ * newseg - Create a new shared memory segment
+ * @ns: namespace
+ * @params: ptr to the structure that contains key, size and shmflg
+ *
+ * Called with shm_ids.mutex held
+ */
+
 static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 {
 	key_t key = params->key;
@@ -428,6 +441,9 @@ no_file:
 	return error;
 }
 
+/*
+ * Called with shm_ids.mutex and ipcp locked.
+ */
 static inline int shm_security(struct kern_ipc_perm *ipcp, int shmflg)
 {
 	struct shmid_kernel *shp;
@@ -436,6 +452,9 @@ static inline int shm_security(struct ke
 	return security_shm_associate(shp, shmflg);
 }
 
+/*
+ * Called with shm_ids.mutex and ipcp locked.
+ */
 static inline int shm_more_checks(struct kern_ipc_perm *ipcp,
 				struct ipc_params *params)
 {
@@ -558,6 +577,9 @@ static inline unsigned long copy_shminfo
 	}
 }
 
+/*
+ * Called with shm_ids.mutex held
+ */
 static void shm_get_stat(struct ipc_namespace *ns, unsigned long *rss,
 		unsigned long *swp)
 {
@@ -573,18 +595,6 @@ static void shm_get_stat(struct ipc_name
 		struct shmid_kernel *shp;
 		struct inode *inode;
 
-		/*
-		 * idr_find() is called via shm_get(), so with shm_ids.mutex
-		 * locked. Since ipc_addid() is also called with
-		 * shm_ids.mutex down, there is no need to add read barriers
-		 * here to gurantee the writes in ipc_addid() are seen in
-		 * order here (for Alpha).
-		 * However idr_find() itself does not necessary require
-		 * ipc_ids.mutex down. So if idr_find() is used by other
-		 * places without ipc_ids.mutex down, then it needs read
-		 * read memory barriers as ipc_lock() does.
-		 */
-
 		shp = idr_find(&shm_ids(ns).ipcs_idr, next_id);
 		if (shp == NULL)
 			continue;
@@ -638,8 +648,11 @@ asmlinkage long sys_shmctl (int shmid, i
 		shminfo.shmmin = SHMMIN;
 		if(copy_shminfo_to_user (buf, &shminfo, version))
 			return -EFAULT;
-		/* reading a integer is always atomic */
+
+		mutex_lock(&shm_ids(ns).mutex);
 		err = ipc_get_maxid(&shm_ids(ns));
+		mutex_unlock(&shm_ids(ns).mutex);
+
 		if(err<0)
 			err = 0;
 		goto out;
diff -puN ipc/util.c~ipc_fix_wrong_comments ipc/util.c
--- a/ipc/util.c~ipc_fix_wrong_comments
+++ a/ipc/util.c
@@ -194,7 +194,7 @@ void __init ipc_init_proc_interface(cons
  *	Requires ipc_ids.mutex locked.
  *	Returns the LOCKED pointer to the ipc structure if found or NULL
  *	if not.
- *	If key is found ipc contains its ipc structure
+ *	If key is found ipc points to the owning ipc structure
  */
  
 static struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
@@ -258,10 +258,10 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	@new: new IPC permission set
  *	@size: limit for the number of used ids
  *
- *	Add an entry 'new' to the IPC idr. The permissions object is
+ *	Add an entry 'new' to the IPC ids idr. The permissions object is
  *	initialised and the first free entry is set up and the id assigned
- *	is returned. The list is returned in a locked state on success.
- *	On failure the list is not locked and -1 is returned.
+ *	is returned. The 'new' entry is returned in a locked state on success.
+ *	On failure the entry is not locked and -1 is returned.
  *
  *	Called with ipc_ids.mutex held.
  */
@@ -270,10 +270,6 @@ int ipc_addid(struct ipc_ids* ids, struc
 {
 	int id, err;
 
-	/*
-	 * rcu_dereference()() is not needed here since
-	 * ipc_ids.mutex is held
-	 */
 	if (size > IPCMNI)
 		size = IPCMNI;
 
@@ -303,12 +299,12 @@ int ipc_addid(struct ipc_ids* ids, struc
 /**
  *	ipcget_new	-	create a new ipc object
  *	@ns: namespace
- *	@ids: identifer set
+ *	@ids: IPC identifer set
  *	@ops: the actual creation routine to call
  *	@params: its parameters
  *
- *	This routine is called sys_msgget, sys_semget() and sys_shmget() when
- *	the key is IPC_PRIVATE
+ *	This routine is called by sys_msgget, sys_semget() and sys_shmget()
+ *	when the key is IPC_PRIVATE.
  */
 int ipcget_new(struct ipc_namespace *ns, struct ipc_ids *ids,
 		struct ipc_ops *ops, struct ipc_params *params)
@@ -330,9 +326,16 @@ int ipcget_new(struct ipc_namespace *ns,
 /**
  *	ipc_check_perms	-	check security and permissions for an IPC
  *	@ipcp: ipc permission set
- *	@ids: identifer set
  *	@ops: the actual security routine to call
  *	@params: its parameters
+ *
+ *	This routine is called by sys_msgget(), sys_semget() and sys_shmget()
+ *      when the key is not IPC_PRIVATE and that key already exists in the
+ *      ids IDR.
+ *
+ *	On success, the IPC id is returned.
+ *
+ *	It is called with ipc_ids.mutex and ipcp->lock held.
  */
 static int ipc_check_perms(struct kern_ipc_perm *ipcp, struct ipc_ops *ops,
 			struct ipc_params *params)
@@ -353,12 +356,16 @@ static int ipc_check_perms(struct kern_i
 /**
  *	ipcget_public	-	get an ipc object or create a new one
  *	@ns: namespace
- *	@ids: identifer set
+ *	@ids: IPC identifer set
  *	@ops: the actual creation routine to call
  *	@params: its parameters
  *
- *	This routine is called sys_msgget, sys_semget() and sys_shmget() when
- *	the key is not IPC_PRIVATE
+ *	This routine is called by sys_msgget, sys_semget() and sys_shmget()
+ *	when the key is not IPC_PRIVATE.
+ *	It adds a new entry if the key is not found and does some permission
+ *      / security checkings if the key is found.
+ *
+ *	On success, the ipc id is returned.
  */
 int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
 		struct ipc_ops *ops, struct ipc_params *params)
@@ -389,6 +396,10 @@ int ipcget_public(struct ipc_namespace *
 			if (ops->more_checks)
 				err = ops->more_checks(ipcp, params);
 			if (!err)
+				/*
+				 * ipc_check_perms returns the IPC id on
+				 * success
+				 */
 				err = ipc_check_perms(ipcp, ops, params);
 		}
 		ipc_unlock(ipcp);
@@ -401,12 +412,9 @@ int ipcget_public(struct ipc_namespace *
 
 /**
  *	ipc_rmid	-	remove an IPC identifier
- *	@ids: identifier set
- *	@id: ipc perm structure containing the identifier to remove
+ *	@ids: IPC identifier set
+ *	@ipcp: ipc perm structure containing the identifier to remove
  *
- *	The identifier must be valid, and in use. The kernel will panic if
- *	fed an invalid identifier. The entry is removed and internal
- *	variables recomputed.
  *	ipc_ids.mutex and the spinlock for this ID are held before this
  *	function is called, and remain locked on the exit.
  */
@@ -558,10 +566,12 @@ static void ipc_do_vfree(struct work_str
  */
 static void ipc_schedule_free(struct rcu_head *head)
 {
-	struct ipc_rcu_grace *grace =
-		container_of(head, struct ipc_rcu_grace, rcu);
-	struct ipc_rcu_sched *sched =
-			container_of(&(grace->data[0]), struct ipc_rcu_sched, data[0]);
+	struct ipc_rcu_grace *grace;
+	struct ipc_rcu_sched *sched;
+
+	grace = container_of(head, struct ipc_rcu_grace, rcu);
+	sched = container_of(&(grace->data[0]), struct ipc_rcu_sched,
+				data[0]);
 
 	INIT_WORK(&sched->work, ipc_do_vfree);
 	schedule_work(&sched->work);
@@ -650,7 +660,7 @@ void kernel_to_ipc64_perm (struct kern_i
 }
 
 /**
- *	ipc64_perm_to_ipc_perm	-	convert old ipc permissions to new
+ *	ipc64_perm_to_ipc_perm	-	convert new ipc permissions to old
  *	@in: new style IPC permissions
  *	@out: old style IPC permissions
  *
@@ -669,6 +679,18 @@ void ipc64_perm_to_ipc_perm (struct ipc6
 	out->seq	= in->seq;
 }
 
+/**
+ * ipc_lock - Lock an ipc structure
+ * @ids: IPC identifier set
+ * @id: ipc id to look for
+ *
+ * Look for an id in the ipc ids idr and lock the associated ipc object.
+ *
+ * ipc_ids.mutex is not necessarily held before this function is called,
+ * that's why we enter a RCU read section.
+ * The ipc object is locked on exit.
+ */
+
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 {
 	struct kern_ipc_perm *out;
@@ -771,8 +793,8 @@ static void *sysvipc_proc_next(struct se
 }
 
 /*
- * File positions: pos 0 -> header, pos n -> ipc id + 1.
- * SeqFile iterator: iterator value locked shp or SEQ_TOKEN_START.
+ * File positions: pos 0 -> header, pos n -> ipc id = n - 1.
+ * SeqFile iterator: iterator value locked ipc pointer or SEQ_TOKEN_START.
  */
 static void *sysvipc_proc_start(struct seq_file *s, loff_t *pos)
 {
@@ -807,7 +829,7 @@ static void sysvipc_proc_stop(struct seq
 	struct ipc_proc_iface *iface = iter->iface;
 	struct ipc_ids *ids;
 
-	/* If we had a locked segment, release it */
+	/* If we had a locked structure, release it */
 	if (ipc && ipc != SEQ_START_TOKEN)
 		ipc_unlock(ipc);
 
diff -puN ipc/util.h~ipc_fix_wrong_comments ipc/util.h
--- a/ipc/util.h~ipc_fix_wrong_comments
+++ a/ipc/util.h
@@ -54,7 +54,7 @@ struct ipc_params {
  * the calls to sys_msgget(), sys_semget(), sys_shmget()
  *      . routine to call to create a new ipc object. Can be one of newque,
  *        newary, newseg
- *      . routine to call to call to check permissions for a new ipc object.
+ *      . routine to call to check permissions for a new ipc object.
  *        Can be one of security_msg_associate, security_sem_associate,
  *        security_shm_associate
  *      . routine to call for an extra check if needed
@@ -88,7 +88,8 @@ int ipc_get_maxid(struct ipc_ids *);
 /* must be called with both locks acquired. */
 void ipc_rmid(struct ipc_ids *, struct kern_ipc_perm *);
 
-int ipcperms (struct kern_ipc_perm *ipcp, short flg);
+/* must be called with ipcp locked */
+int ipcperms(struct kern_ipc_perm *ipcp, short flg);
 
 /* for rare, potentially huge allocations.
  * both function can sleep
@@ -131,6 +132,9 @@ static inline int ipc_buildid(struct ipc
 	return SEQ_MULTIPLIER * seq + id;
 }
 
+/*
+ * Must be called with ipcp locked
+ */
 static inline int ipc_checkid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp,
 				int uid)
 {
@@ -168,6 +172,16 @@ static inline struct kern_ipc_perm *ipc_
 	return out;
 }
 
+/**
+ * ipcget - Common sys_*get() code
+ * @ns : namsepace
+ * @ids : IPC identifier set
+ * @ops : operations to be called on ipc object creation, permission checks
+ *        and further checks
+ * @params : the parameters needed by the previous operations.
+ *
+ * Common routine called by sys_msgget(), sys_semget() and sys_shmget().
+ */
 static inline int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params)
 {
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

ipc-store-ipcs-into-idrs.patch
ipc-unify-the-syscalls-code.patch
ipc-remove-the-ipc_get-routine.patch
ipc-integrate-ipc_checkid-into-ipc_lock.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-3.patch
storing-ipcs-into-idrs.patch
ipc-introduce-the-ipcid_to_idx-macro.patch
ipc-inline-ipc_buildid.patch
ipc_fix_wrong_comments.patch
