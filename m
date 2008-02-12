From: akpm@linux-foundation.org
Subject: + ipc-shared-memory-introduce-shmctl_down.patch added to -mm tree
Date: Tue, 12 Feb 2008 13:27:53 -0800
Message-ID: <200802122127.m1CLRrxo023060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbYBLVec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 16:34:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, serue@us.ibm.com


The patch titled
     IPC/shared memory: introduce shmctl_down
has been added to the -mm tree.  Its filename is
     ipc-shared-memory-introduce-shmctl_down.patch

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
@@ -617,10 +617,78 @@ static void shm_get_stat(struct ipc_name
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
 
@@ -776,97 +844,13 @@ asmlinkage long sys_shmctl (int shmid, i
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
-
+		err = shmctl_down(ns, shmid, cmd, buf, version);
+		return err;
 	default:
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
-	err = 0;
-out_unlock_up:
-	shm_unlock(shp);
-out_up:
-	up_write(&shm_ids(ns).rw_mutex);
-	goto out;
 out_unlock:
 	shm_unlock(shp);
 out:
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

origin.patch
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
ipc-semaphores-code-factorisation.patch
ipc-shared-memory-introduce-shmctl_down.patch
ipc-message-queues-introduce-msgctl_down.patch
ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
ipc-get-rid-of-the-use-_setbuf-structure.patch
ipc-introduce-ipc_update_perm.patch
ipc-consolidate-all-xxxctl_down-functions.patch
