From: akpm@linux-foundation.org
Subject: + fix-idr_find-locking.patch added to -mm tree
Date: Thu, 27 Sep 2007 16:34:59 -0700
Message-ID: <200709272334.l8RNYxqW000909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759342AbXI0Xff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 19:35:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net


The patch titled
     fix idr_find() locking
has been added to the -mm tree.  Its filename is
     fix-idr_find-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix idr_find() locking
From: Nadia Derbey <Nadia.Derbey@bull.net>

This is a patch that fixes the way idr_find() used to be called in ipc_lock():
in all the paths that don't imply an update of the ipcs idr, it was called
without the idr tree being locked.

The changes are:
  . in ipc_ids, the mutex has been changed into a reader/writer semaphore.
  . ipc_lock() now takes the mutex as a reader during the idr_find().
  . a new routine ipc_lock_down() has been defined: it doesn't take the
    mutex, assuming that it is being held by the caller. This is the routine
    that is now called in all the update paths.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN ipc/msg.c~fix-idr_find-locking ipc/msg.c
--- a/ipc/msg.c~fix-idr_find-locking
+++ a/ipc/msg.c
@@ -34,7 +34,7 @@
 #include <linux/syscalls.h>
 #include <linux/audit.h>
 #include <linux/seq_file.h>
-#include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 
 #include <asm/current.h>
@@ -110,7 +110,7 @@ void msg_exit_ns(struct ipc_namespace *n
 	int next_id;
 	int total, in_use;
 
-	mutex_lock(&msg_ids(ns).mutex);
+	down_write(&msg_ids(ns).rw_mutex);
 
 	in_use = msg_ids(ns).in_use;
 
@@ -122,7 +122,8 @@ void msg_exit_ns(struct ipc_namespace *n
 		freeque(ns, msq);
 		total++;
 	}
-	mutex_unlock(&msg_ids(ns).mutex);
+
+	up_write(&msg_ids(ns).rw_mutex);
 
 	kfree(ns->ids[IPC_MSG_IDS]);
 	ns->ids[IPC_MSG_IDS] = NULL;
@@ -136,6 +137,22 @@ void __init msg_init(void)
 				IPC_MSG_IDS, sysvipc_msg_proc_show);
 }
 
+/*
+ * This routine is called in the paths where the rw_mutex is held to protect
+ * access to the idr tree.
+ */
+static inline struct msg_queue *msg_lock_check_down(struct ipc_namespace *ns,
+						int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_lock_check_down(&msg_ids(ns), id);
+
+	return container_of(ipcp, struct msg_queue, q_perm);
+}
+
+/*
+ * msg_lock_(check_) routines are called in the paths where the rw_mutex
+ * is not held.
+ */
 static inline struct msg_queue *msg_lock(struct ipc_namespace *ns, int id)
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&msg_ids(ns), id);
@@ -161,7 +178,7 @@ static inline void msg_rmid(struct ipc_n
  * @ns: namespace
  * @params: ptr to the structure that contains the key and msgflg
  *
- * Called with msg_ids.mutex held
+ * Called with msg_ids.rw_mutex held (writer)
  */
 static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 {
@@ -260,8 +277,8 @@ static void expunge_all(struct msg_queue
  * removes the message queue from message queue ID IDR, and cleans up all the
  * messages associated with this queue.
  *
- * msg_ids.mutex and the spinlock for this message queue are held
- * before freeque() is called. msg_ids.mutex remains locked on exit.
+ * msg_ids.rw_mutex (writer) and the spinlock for this message queue are held
+ * before freeque() is called. msg_ids.rw_mutex remains locked on exit.
  */
 static void freeque(struct ipc_namespace *ns, struct msg_queue *msq)
 {
@@ -286,7 +303,7 @@ static void freeque(struct ipc_namespace
 }
 
 /*
- * Called with msg_ids.mutex and ipcp locked.
+ * Called with msg_ids.rw_mutex and ipcp locked.
  */
 static inline int msg_security(struct kern_ipc_perm *ipcp, int msgflg)
 {
@@ -444,7 +461,7 @@ asmlinkage long sys_msgctl(int msqid, in
 		msginfo.msgmnb = ns->msg_ctlmnb;
 		msginfo.msgssz = MSGSSZ;
 		msginfo.msgseg = MSGSEG;
-		mutex_lock(&msg_ids(ns).mutex);
+		down_read(&msg_ids(ns).rw_mutex);
 		if (cmd == MSG_INFO) {
 			msginfo.msgpool = msg_ids(ns).in_use;
 			msginfo.msgmap = atomic_read(&msg_hdrs);
@@ -455,7 +472,7 @@ asmlinkage long sys_msgctl(int msqid, in
 			msginfo.msgtql = MSGTQL;
 		}
 		max_id = ipc_get_maxid(&msg_ids(ns));
-		mutex_unlock(&msg_ids(ns).mutex);
+		up_read(&msg_ids(ns).rw_mutex);
 		if (copy_to_user(buf, &msginfo, sizeof(struct msginfo)))
 			return -EFAULT;
 		return (max_id < 0) ? 0 : max_id;
@@ -516,8 +533,8 @@ asmlinkage long sys_msgctl(int msqid, in
 		return  -EINVAL;
 	}
 
-	mutex_lock(&msg_ids(ns).mutex);
-	msq = msg_lock_check(ns, msqid);
+	down_write(&msg_ids(ns).rw_mutex);
+	msq = msg_lock_check_down(ns, msqid);
 	if (IS_ERR(msq)) {
 		err = PTR_ERR(msq);
 		goto out_up;
@@ -576,7 +593,7 @@ asmlinkage long sys_msgctl(int msqid, in
 	}
 	err = 0;
 out_up:
-	mutex_unlock(&msg_ids(ns).mutex);
+	up_write(&msg_ids(ns).rw_mutex);
 	return err;
 out_unlock_up:
 	msg_unlock(msq);
diff -puN ipc/sem.c~fix-idr_find-locking ipc/sem.c
--- a/ipc/sem.c~fix-idr_find-locking
+++ a/ipc/sem.c
@@ -80,7 +80,7 @@
 #include <linux/audit.h>
 #include <linux/capability.h>
 #include <linux/seq_file.h>
-#include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 
 #include <asm/uaccess.h>
@@ -148,7 +148,7 @@ void sem_exit_ns(struct ipc_namespace *n
 	int next_id;
 	int total, in_use;
 
-	mutex_lock(&sem_ids(ns).mutex);
+	down_write(&sem_ids(ns).rw_mutex);
 
 	in_use = sem_ids(ns).in_use;
 
@@ -160,7 +160,7 @@ void sem_exit_ns(struct ipc_namespace *n
 		freeary(ns, sma);
 		total++;
 	}
-	mutex_unlock(&sem_ids(ns).mutex);
+	up_write(&sem_ids(ns).rw_mutex);
 
 	kfree(ns->ids[IPC_SEM_IDS]);
 	ns->ids[IPC_SEM_IDS] = NULL;
@@ -174,6 +174,22 @@ void __init sem_init (void)
 				IPC_SEM_IDS, sysvipc_sem_proc_show);
 }
 
+/*
+ * This routine is called in the paths where the rw_mutex is held to protect
+ * access to the idr tree.
+ */
+static inline struct sem_array *sem_lock_check_down(struct ipc_namespace *ns,
+						int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_lock_check_down(&sem_ids(ns), id);
+
+	return container_of(ipcp, struct sem_array, sem_perm);
+}
+
+/*
+ * sem_lock_(check_) routines are called in the paths where the rw_mutex
+ * is not held.
+ */
 static inline struct sem_array *sem_lock(struct ipc_namespace *ns, int id)
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&sem_ids(ns), id);
@@ -233,7 +249,7 @@ static inline void sem_rmid(struct ipc_n
  * @ns: namespace
  * @params: ptr to the structure that contains key, semflg and nsems
  *
- * Called with sem_ids.mutex held
+ * Called with sem_ids.rw_mutex held (as a writer)
  */
 
 static int newary(struct ipc_namespace *ns, struct ipc_params *params)
@@ -290,7 +306,7 @@ static int newary(struct ipc_namespace *
 
 
 /*
- * Called with sem_ids.mutex and ipcp locked.
+ * Called with sem_ids.rw_mutex and ipcp locked.
  */
 static inline int sem_security(struct kern_ipc_perm *ipcp, int semflg)
 {
@@ -301,7 +317,7 @@ static inline int sem_security(struct ke
 }
 
 /*
- * Called with sem_ids.mutex and ipcp locked.
+ * Called with sem_ids.rw_mutex and ipcp locked.
  */
 static inline int sem_more_checks(struct kern_ipc_perm *ipcp,
 				struct ipc_params *params)
@@ -528,9 +544,9 @@ static int count_semzcnt (struct sem_arr
 	return semzcnt;
 }
 
-/* Free a semaphore set. freeary() is called with sem_ids.mutex locked and
- * the spinlock for this semaphore set hold. sem_ids.mutex remains locked
- * on exit.
+/* Free a semaphore set. freeary() is called with sem_ids.rw_mutex locked
+ * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
+ * remains locked on exit.
  */
 static void freeary(struct ipc_namespace *ns, struct sem_array *sma)
 {
@@ -615,7 +631,7 @@ static int semctl_nolock(struct ipc_name
 		seminfo.semmnu = SEMMNU;
 		seminfo.semmap = SEMMAP;
 		seminfo.semume = SEMUME;
-		mutex_lock(&sem_ids(ns).mutex);
+		down_read(&sem_ids(ns).rw_mutex);
 		if (cmd == SEM_INFO) {
 			seminfo.semusz = sem_ids(ns).in_use;
 			seminfo.semaem = ns->used_sems;
@@ -624,7 +640,7 @@ static int semctl_nolock(struct ipc_name
 			seminfo.semaem = SEMAEM;
 		}
 		max_id = ipc_get_maxid(&sem_ids(ns));
-		mutex_unlock(&sem_ids(ns).mutex);
+		up_read(&sem_ids(ns).rw_mutex);
 		if (copy_to_user (arg.__buf, &seminfo, sizeof(struct seminfo))) 
 			return -EFAULT;
 		return (max_id < 0) ? 0: max_id;
@@ -895,7 +911,7 @@ static int semctl_down(struct ipc_namesp
 		if(copy_semid_from_user (&setbuf, arg.buf, version))
 			return -EFAULT;
 	}
-	sma = sem_lock_check(ns, semid);
+	sma = sem_lock_check_down(ns, semid);
 	if (IS_ERR(sma))
 		return PTR_ERR(sma);
 
@@ -976,9 +992,9 @@ asmlinkage long sys_semctl (int semid, i
 		return err;
 	case IPC_RMID:
 	case IPC_SET:
-		mutex_lock(&sem_ids(ns).mutex);
+		down_write(&sem_ids(ns).rw_mutex);
 		err = semctl_down(ns,semid,semnum,cmd,version,arg);
-		mutex_unlock(&sem_ids(ns).mutex);
+		up_write(&sem_ids(ns).rw_mutex);
 		return err;
 	default:
 		return -EINVAL;
diff -puN ipc/shm.c~fix-idr_find-locking ipc/shm.c
--- a/ipc/shm.c~fix-idr_find-locking
+++ a/ipc/shm.c
@@ -35,7 +35,7 @@
 #include <linux/capability.h>
 #include <linux/ptrace.h>
 #include <linux/seq_file.h>
-#include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 #include <linux/mount.h>
 
@@ -83,8 +83,8 @@ static void __shm_init_ns(struct ipc_nam
 }
 
 /*
- * Called with shm_ids.mutex and the shp structure locked.
- * Only shm_ids.mutex remains locked on exit.
+ * Called with shm_ids.rw_mutex (writer) and the shp structure locked.
+ * Only shm_ids.rw_mutex remains locked on exit.
  */
 static void do_shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *shp)
 {
@@ -115,7 +115,7 @@ void shm_exit_ns(struct ipc_namespace *n
 	int next_id;
 	int total, in_use;
 
-	mutex_lock(&shm_ids(ns).mutex);
+	down_write(&shm_ids(ns).rw_mutex);
 
 	in_use = shm_ids(ns).in_use;
 
@@ -127,7 +127,7 @@ void shm_exit_ns(struct ipc_namespace *n
 		do_shm_rmid(ns, shp);
 		total++;
 	}
-	mutex_unlock(&shm_ids(ns).mutex);
+	up_write(&shm_ids(ns).rw_mutex);
 
 	kfree(ns->ids[IPC_SHM_IDS]);
 	ns->ids[IPC_SHM_IDS] = NULL;
@@ -141,6 +141,31 @@ void __init shm_init (void)
 				IPC_SHM_IDS, sysvipc_shm_proc_show);
 }
 
+/*
+ * shm_lock_(check_)down routines are called in the paths where the rw_mutex
+ * is held to protect access to the idr tree.
+ */
+static inline struct shmid_kernel *shm_lock_down(struct ipc_namespace *ns,
+						int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_lock_down(&shm_ids(ns), id);
+
+	return container_of(ipcp, struct shmid_kernel, shm_perm);
+}
+
+static inline struct shmid_kernel *shm_lock_check_down(
+						struct ipc_namespace *ns,
+						int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_lock_check_down(&shm_ids(ns), id);
+
+	return container_of(ipcp, struct shmid_kernel, shm_perm);
+}
+
+/*
+ * shm_lock_(check_) routines are called in the paths where the rw_mutex
+ * is not held.
+ */
 static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&shm_ids(ns), id);
@@ -189,7 +214,7 @@ static void shm_open(struct vm_area_stru
  * @ns: namespace
  * @shp: struct to free
  *
- * It has to be called with shp and shm_ids.mutex locked,
+ * It has to be called with shp and shm_ids.rw_mutex (writer) locked,
  * but returns with shp unlocked and freed.
  */
 static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
@@ -220,9 +245,9 @@ static void shm_close(struct vm_area_str
 	struct shmid_kernel *shp;
 	struct ipc_namespace *ns = sfd->ns;
 
-	mutex_lock(&shm_ids(ns).mutex);
+	down_write(&shm_ids(ns).rw_mutex);
 	/* remove from the list of attaches of the shm segment */
-	shp = shm_lock(ns, sfd->id);
+	shp = shm_lock_down(ns, sfd->id);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_dtim = get_seconds();
@@ -232,7 +257,7 @@ static void shm_close(struct vm_area_str
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
-	mutex_unlock(&shm_ids(ns).mutex);
+	up_write(&shm_ids(ns).rw_mutex);
 }
 
 static int shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
@@ -353,7 +378,7 @@ static struct vm_operations_struct shm_v
  * @ns: namespace
  * @params: ptr to the structure that contains key, size and shmflg
  *
- * Called with shm_ids.mutex held
+ * Called with shm_ids.rw_mutex held as a writer.
  */
 
 static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
@@ -442,7 +467,7 @@ no_file:
 }
 
 /*
- * Called with shm_ids.mutex and ipcp locked.
+ * Called with shm_ids.rw_mutex and ipcp locked.
  */
 static inline int shm_security(struct kern_ipc_perm *ipcp, int shmflg)
 {
@@ -453,7 +478,7 @@ static inline int shm_security(struct ke
 }
 
 /*
- * Called with shm_ids.mutex and ipcp locked.
+ * Called with shm_ids.rw_mutex and ipcp locked.
  */
 static inline int shm_more_checks(struct kern_ipc_perm *ipcp,
 				struct ipc_params *params)
@@ -578,7 +603,7 @@ static inline unsigned long copy_shminfo
 }
 
 /*
- * Called with shm_ids.mutex held
+ * Called with shm_ids.rw_mutex held as a reader
  */
 static void shm_get_stat(struct ipc_namespace *ns, unsigned long *rss,
 		unsigned long *swp)
@@ -649,9 +674,9 @@ asmlinkage long sys_shmctl (int shmid, i
 		if(copy_shminfo_to_user (buf, &shminfo, version))
 			return -EFAULT;
 
-		mutex_lock(&shm_ids(ns).mutex);
+		down_read(&shm_ids(ns).rw_mutex);
 		err = ipc_get_maxid(&shm_ids(ns));
-		mutex_unlock(&shm_ids(ns).mutex);
+		up_read(&shm_ids(ns).rw_mutex);
 
 		if(err<0)
 			err = 0;
@@ -666,14 +691,14 @@ asmlinkage long sys_shmctl (int shmid, i
 			return err;
 
 		memset(&shm_info,0,sizeof(shm_info));
-		mutex_lock(&shm_ids(ns).mutex);
+		down_read(&shm_ids(ns).rw_mutex);
 		shm_info.used_ids = shm_ids(ns).in_use;
 		shm_get_stat (ns, &shm_info.shm_rss, &shm_info.shm_swp);
 		shm_info.shm_tot = ns->shm_tot;
 		shm_info.swap_attempts = 0;
 		shm_info.swap_successes = 0;
 		err = ipc_get_maxid(&shm_ids(ns));
-		mutex_unlock(&shm_ids(ns).mutex);
+		up_read(&shm_ids(ns).rw_mutex);
 		if(copy_to_user (buf, &shm_info, sizeof(shm_info))) {
 			err = -EFAULT;
 			goto out;
@@ -786,8 +811,8 @@ asmlinkage long sys_shmctl (int shmid, i
 		 *	Instead we set a destroyed flag, and then blow
 		 *	the name away when the usage hits zero.
 		 */
-		mutex_lock(&shm_ids(ns).mutex);
-		shp = shm_lock_check(ns, shmid);
+		down_write(&shm_ids(ns).rw_mutex);
+		shp = shm_lock_check_down(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
 			goto out_up;
@@ -809,7 +834,7 @@ asmlinkage long sys_shmctl (int shmid, i
 			goto out_unlock_up;
 
 		do_shm_rmid(ns, shp);
-		mutex_unlock(&shm_ids(ns).mutex);
+		up_write(&shm_ids(ns).rw_mutex);
 		goto out;
 	}
 
@@ -824,8 +849,8 @@ asmlinkage long sys_shmctl (int shmid, i
 			err = -EFAULT;
 			goto out;
 		}
-		mutex_lock(&shm_ids(ns).mutex);
-		shp = shm_lock_check(ns, shmid);
+		down_write(&shm_ids(ns).rw_mutex);
+		shp = shm_lock_check_down(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
 			goto out_up;
@@ -864,7 +889,7 @@ asmlinkage long sys_shmctl (int shmid, i
 out_unlock_up:
 	shm_unlock(shp);
 out_up:
-	mutex_unlock(&shm_ids(ns).mutex);
+	up_write(&shm_ids(ns).rw_mutex);
 	goto out;
 out_unlock:
 	shm_unlock(shp);
@@ -998,8 +1023,8 @@ invalid:
 	fput(file);
 
 out_nattch:
-	mutex_lock(&shm_ids(ns).mutex);
-	shp = shm_lock(ns, shmid);
+	down_write(&shm_ids(ns).rw_mutex);
+	shp = shm_lock_down(ns, shmid);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_nattch--;
 	if(shp->shm_nattch == 0 &&
@@ -1007,7 +1032,7 @@ out_nattch:
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
-	mutex_unlock(&shm_ids(ns).mutex);
+	up_write(&shm_ids(ns).rw_mutex);
 
 out:
 	return err;
diff -puN ipc/util.c~fix-idr_find-locking ipc/util.c
--- a/ipc/util.c~fix-idr_find-locking
+++ a/ipc/util.c
@@ -32,6 +32,7 @@
 #include <linux/proc_fs.h>
 #include <linux/audit.h>
 #include <linux/nsproxy.h>
+#include <linux/rwsem.h>
 
 #include <asm/unistd.h>
 
@@ -136,7 +137,7 @@ __initcall(ipc_init);
  
 void ipc_init_ids(struct ipc_ids *ids)
 {
-	mutex_init(&ids->mutex);
+	init_rwsem(&ids->rw_mutex);
 
 	ids->in_use = 0;
 	ids->seq = 0;
@@ -191,7 +192,7 @@ void __init ipc_init_proc_interface(cons
  *	@ids: Identifier set
  *	@key: The key to find
  *	
- *	Requires ipc_ids.mutex locked.
+ *	Requires ipc_ids.rw_mutex locked.
  *	Returns the LOCKED pointer to the ipc structure if found or NULL
  *	if not.
  *	If key is found ipc points to the owning ipc structure
@@ -225,7 +226,7 @@ static struct kern_ipc_perm *ipc_findkey
  *	ipc_get_maxid 	-	get the last assigned id
  *	@ids: IPC identifier set
  *
- *	Called with ipc_ids.mutex held.
+ *	Called with ipc_ids.rw_mutex held.
  */
 
 int ipc_get_maxid(struct ipc_ids *ids)
@@ -263,7 +264,7 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	is returned. The 'new' entry is returned in a locked state on success.
  *	On failure the entry is not locked and -1 is returned.
  *
- *	Called with ipc_ids.mutex held.
+ *	Called with ipc_ids.rw_mutex held as a writer.
  */
  
 int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
@@ -316,9 +317,9 @@ int ipcget_new(struct ipc_namespace *ns,
 	if (!err)
 		return -ENOMEM;
 
-	mutex_lock(&ids->mutex);
+	down_write(&ids->rw_mutex);
 	err = ops->getnew(ns, params);
-	mutex_unlock(&ids->mutex);
+	up_write(&ids->rw_mutex);
 
 	return err;
 }
@@ -335,7 +336,7 @@ int ipcget_new(struct ipc_namespace *ns,
  *
  *	On success, the IPC id is returned.
  *
- *	It is called with ipc_ids.mutex and ipcp->lock held.
+ *	It is called with ipc_ids.rw_mutex and ipcp->lock held.
  */
 static int ipc_check_perms(struct kern_ipc_perm *ipcp, struct ipc_ops *ops,
 			struct ipc_params *params)
@@ -376,7 +377,11 @@ int ipcget_public(struct ipc_namespace *
 
 	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
 
-	mutex_lock(&ids->mutex);
+	/*
+	 * Take the lock as a writer since we are potentially going to add
+	 * a new entry + read locks are not "upgradable"
+	 */
+	down_write(&ids->rw_mutex);
 	ipcp = ipc_findkey(ids, params->key);
 	if (ipcp == NULL) {
 		/* key not used */
@@ -404,7 +409,7 @@ int ipcget_public(struct ipc_namespace *
 		}
 		ipc_unlock(ipcp);
 	}
-	mutex_unlock(&ids->mutex);
+	up_write(&ids->rw_mutex);
 
 	return err;
 }
@@ -415,8 +420,8 @@ int ipcget_public(struct ipc_namespace *
  *	@ids: IPC identifier set
  *	@ipcp: ipc perm structure containing the identifier to remove
  *
- *	ipc_ids.mutex and the spinlock for this ID are held before this
- *	function is called, and remain locked on the exit.
+ *	ipc_ids.rw_mutex (as a writer) and the spinlock for this ID are held
+ *	before this function is called, and remain locked on the exit.
  */
  
 void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
@@ -680,15 +685,17 @@ void ipc64_perm_to_ipc_perm (struct ipc6
 }
 
 /**
- * ipc_lock - Lock an ipc structure
+ * ipc_lock - Lock an ipc structure without rw_mutex held
  * @ids: IPC identifier set
  * @id: ipc id to look for
  *
  * Look for an id in the ipc ids idr and lock the associated ipc object.
  *
- * ipc_ids.mutex is not necessarily held before this function is called,
- * that's why we enter a RCU read section.
  * The ipc object is locked on exit.
+ *
+ * This is the routine that should be called when the rw_mutex is not already
+ * held, i.e. idr tree not protected: it protects the idr tree in read mode
+ * during the idr_find().
  */
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
@@ -696,13 +703,18 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	struct kern_ipc_perm *out;
 	int lid = ipcid_to_idx(id);
 
+	down_read(&ids->rw_mutex);
+
 	rcu_read_lock();
 	out = idr_find(&ids->ipcs_idr, lid);
 	if (out == NULL) {
 		rcu_read_unlock();
+		up_read(&ids->rw_mutex);
 		return ERR_PTR(-EINVAL);
 	}
 
+	up_read(&ids->rw_mutex);
+
 	spin_lock(&out->lock);
 	
 	/* ipc_rmid() may have already freed the ID while ipc_lock
@@ -717,6 +729,40 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	return out;
 }
 
+/**
+ * ipc_lock_down - Lock an ipc structure with rw_sem held
+ * @ids: IPC identifier set
+ * @id: ipc id to look for
+ *
+ * Look for an id in the ipc ids idr and lock the associated ipc object.
+ *
+ * The ipc object is locked on exit.
+ *
+ * This is the routine that should be called when the rw_mutex is already
+ * held, i.e. idr tree protected.
+ */
+
+struct kern_ipc_perm *ipc_lock_down(struct ipc_ids *ids, int id)
+{
+	struct kern_ipc_perm *out;
+	int lid = ipcid_to_idx(id);
+
+	rcu_read_lock();
+	out = idr_find(&ids->ipcs_idr, lid);
+	if (out == NULL) {
+		rcu_read_unlock();
+		return ERR_PTR(-EINVAL);
+	}
+
+	spin_lock(&out->lock);
+
+	/*
+	 * No need to verify that the structure is still valid since the
+	 * rw_mutex is held.
+	 */
+	return out;
+}
+
 #ifdef __ARCH_WANT_IPC_PARSE_VERSION
 
 
@@ -808,7 +854,7 @@ static void *sysvipc_proc_start(struct s
 	 * Take the lock - this will be released by the corresponding
 	 * call to stop().
 	 */
-	mutex_lock(&ids->mutex);
+	down_read(&ids->rw_mutex);
 
 	/* pos < 0 is invalid */
 	if (*pos < 0)
@@ -835,7 +881,7 @@ static void sysvipc_proc_stop(struct seq
 
 	ids = iter->ns->ids[iface->ids];
 	/* Release the lock we took in start() */
-	mutex_unlock(&ids->mutex);
+	up_read(&ids->rw_mutex);
 }
 
 static int sysvipc_proc_show(struct seq_file *s, void *it)
diff -puN ipc/util.h~fix-idr_find-locking ipc/util.h
--- a/ipc/util.h~fix-idr_find-locking
+++ a/ipc/util.h
@@ -32,7 +32,7 @@ struct ipc_ids {
 	int in_use;
 	unsigned short seq;
 	unsigned short seq_max;
-	struct mutex mutex;
+	struct rw_semaphore rw_mutex;
 	struct idr ipcs_idr;
 };
 
@@ -81,8 +81,10 @@ void __init ipc_init_proc_interface(cons
 
 #define ipcid_to_idx(id) ((id) % SEQ_MULTIPLIER)
 
-/* must be called with ids->mutex acquired.*/
+/* must be called with ids->rw_mutex acquired for writing */
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
+
+/* must be called with ids->rw_mutex acquired for reading */
 int ipc_get_maxid(struct ipc_ids *);
 
 /* must be called with both locks acquired. */
@@ -107,6 +109,11 @@ void* ipc_rcu_alloc(int size);
 void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
+/*
+ * ipc_lock_down: called with rw_mutex held
+ * ipc_lock: called without that lock held
+ */
+struct kern_ipc_perm *ipc_lock_down(struct ipc_ids *, int);
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
@@ -155,6 +162,23 @@ static inline void ipc_unlock(struct ker
 	rcu_read_unlock();
 }
 
+static inline struct kern_ipc_perm *ipc_lock_check_down(struct ipc_ids *ids,
+						int id)
+{
+	struct kern_ipc_perm *out;
+
+	out = ipc_lock_down(ids, id);
+	if (IS_ERR(out))
+		return out;
+
+	if (ipc_checkid(ids, out, id)) {
+		ipc_unlock(out);
+		return ERR_PTR(-EIDRM);
+	}
+
+	return out;
+}
+
 static inline struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids,
 						int id)
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
fix-idr_find-locking.patch
removing-unneeded-parameters.patch
