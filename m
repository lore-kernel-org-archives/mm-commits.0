From: akpm@linux-foundation.org
Subject: - ipc-shared-memory-introduce-shmctl_down.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:09 -0700
Message-ID: <200804300544.m3U5i9uQ029381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757808AbYD3FpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:45:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     IPC/shared memory: introduce shmctl_down
has been removed from the -mm tree.  Its filename was
     ipc-shared-memory-introduce-shmctl_down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IPC/shared memory: introduce shmctl_down
From: Pierre Peiffer <pierre.peiffer@bull.net>

Currently, the way the different commands are handled in sys_shmctl introduces
some duplicated code.

This patch introduces the shmctl_down function to handle all the commands
requiring the rwmutex to be taken in write mode (ie IPC_SET and IPC_RMID for
now).  It is the equivalent function of semctl_down for shared memory.

This removes some duplicated code for handling these both commands and
harmonizes the way they are handled among all IPCs.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |  160 +++++++++++++++++++++++-----------------------------
 1 file changed, 72 insertions(+), 88 deletions(-)

diff -puN ipc/shm.c~ipc-shared-memory-introduce-shmctl_down ipc/shm.c
--- a/ipc/shm.c~ipc-shared-memory-introduce-shmctl_down
+++ a/ipc/shm.c
@@ -616,10 +616,78 @@ static void shm_get_stat(struct ipc_name
 	}
 }
 
-asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
+/*
+ * This function handles some shmctl commands which require the rw_mutex
+ * to be held in write mode.
+ * NOTE: no locks must be held, the rw_mutex is taken inside this function.
+ */
+static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
+		       struct shmid_ds __user *buf, int version)
 {
+	struct kern_ipc_perm *ipcp;
 	struct shm_setbuf setbuf;
 	struct shmid_kernel *shp;
+	int err;
+
+	if (cmd == IPC_SET) {
+		if (copy_shmid_from_user(&setbuf, buf, version))
+			return -EFAULT;
+	}
+
+	down_write(&shm_ids(ns).rw_mutex);
+	shp = shm_lock_check_down(ns, shmid);
+	if (IS_ERR(shp)) {
+		err = PTR_ERR(shp);
+		goto out_up;
+	}
+
+	ipcp = &shp->shm_perm;
+
+	err = audit_ipc_obj(ipcp);
+	if (err)
+		goto out_unlock;
+
+	if (cmd == IPC_SET) {
+		err = audit_ipc_set_perm(0, setbuf.uid,
+					 setbuf.gid, setbuf.mode);
+		if (err)
+			goto out_unlock;
+	}
+
+	if (current->euid != ipcp->uid &&
+	    current->euid != ipcp->cuid &&
+	    !capable(CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto out_unlock;
+	}
+
+	err = security_shm_shmctl(shp, cmd);
+	if (err)
+		goto out_unlock;
+	switch (cmd) {
+	case IPC_RMID:
+		do_shm_rmid(ns, ipcp);
+		goto out_up;
+	case IPC_SET:
+		ipcp->uid = setbuf.uid;
+		ipcp->gid = setbuf.gid;
+		ipcp->mode = (ipcp->mode & ~S_IRWXUGO)
+			| (setbuf.mode & S_IRWXUGO);
+		shp->shm_ctim = get_seconds();
+		break;
+	default:
+		err = -EINVAL;
+	}
+out_unlock:
+	shm_unlock(shp);
+out_up:
+	up_write(&shm_ids(ns).rw_mutex);
+	return err;
+}
+
+asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
+{
+	struct shmid_kernel *shp;
 	int err, version;
 	struct ipc_namespace *ns;
 
@@ -775,97 +843,13 @@ asmlinkage long sys_shmctl (int shmid, i
 		goto out;
 	}
 	case IPC_RMID:
-	{
-		/*
-		 *	We cannot simply remove the file. The SVID states
-		 *	that the block remains until the last person
-		 *	detaches from it, then is deleted. A shmat() on
-		 *	an RMID segment is legal in older Linux and if 
-		 *	we change it apps break...
-		 *
-		 *	Instead we set a destroyed flag, and then blow
-		 *	the name away when the usage hits zero.
-		 */
-		down_write(&shm_ids(ns).rw_mutex);
-		shp = shm_lock_check_down(ns, shmid);
-		if (IS_ERR(shp)) {
-			err = PTR_ERR(shp);
-			goto out_up;
-		}
-
-		err = audit_ipc_obj(&(shp->shm_perm));
-		if (err)
-			goto out_unlock_up;
-
-		if (current->euid != shp->shm_perm.uid &&
-		    current->euid != shp->shm_perm.cuid && 
-		    !capable(CAP_SYS_ADMIN)) {
-			err=-EPERM;
-			goto out_unlock_up;
-		}
-
-		err = security_shm_shmctl(shp, cmd);
-		if (err)
-			goto out_unlock_up;
-
-		do_shm_rmid(ns, &shp->shm_perm);
-		up_write(&shm_ids(ns).rw_mutex);
-		goto out;
-	}
-
 	case IPC_SET:
-	{
-		if (!buf) {
-			err = -EFAULT;
-			goto out;
-		}
-
-		if (copy_shmid_from_user (&setbuf, buf, version)) {
-			err = -EFAULT;
-			goto out;
-		}
-		down_write(&shm_ids(ns).rw_mutex);
-		shp = shm_lock_check_down(ns, shmid);
-		if (IS_ERR(shp)) {
-			err = PTR_ERR(shp);
-			goto out_up;
-		}
-		err = audit_ipc_obj(&(shp->shm_perm));
-		if (err)
-			goto out_unlock_up;
-		err = audit_ipc_set_perm(0, setbuf.uid, setbuf.gid, setbuf.mode);
-		if (err)
-			goto out_unlock_up;
-		err=-EPERM;
-		if (current->euid != shp->shm_perm.uid &&
-		    current->euid != shp->shm_perm.cuid && 
-		    !capable(CAP_SYS_ADMIN)) {
-			goto out_unlock_up;
-		}
-
-		err = security_shm_shmctl(shp, cmd);
-		if (err)
-			goto out_unlock_up;
-		
-		shp->shm_perm.uid = setbuf.uid;
-		shp->shm_perm.gid = setbuf.gid;
-		shp->shm_perm.mode = (shp->shm_perm.mode & ~S_IRWXUGO)
-			| (setbuf.mode & S_IRWXUGO);
-		shp->shm_ctim = get_seconds();
-		break;
-	}
