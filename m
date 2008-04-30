From: akpm@linux-foundation.org
Subject: - ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:13 -0700
Message-ID: <200804300544.m3U5iDB1029387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758204AbYD3GMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     IPC/semaphores: move the rwmutex handling inside semctl_down
has been removed from the -mm tree.  Its filename was
     ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IPC/semaphores: move the rwmutex handling inside semctl_down
From: Pierre Peiffer <pierre.peiffer@bull.net>

semctl_down is called with the rwmutex (the one which protects the list of
ipcs) taken in write mode.

This patch moves this rwmutex taken in write-mode inside semctl_down.

This has the advantages of reducing a little bit the window during which this
rwmutex is taken, clarifying sys_semctl, and finally of having a coherent
behaviour with [shm|msg]ctl_down

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN ipc/sem.c~ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down ipc/sem.c
--- a/ipc/sem.c~ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down
+++ a/ipc/sem.c
@@ -875,6 +875,11 @@ static inline unsigned long copy_semid_f
 	}
 }
 
+/*
+ * This function handles some semctl commands which require the rw_mutex
+ * to be held in write mode.
+ * NOTE: no locks must be held, the rw_mutex is taken inside this function.
+ */
 static int semctl_down(struct ipc_namespace *ns, int semid, int semnum,
 		int cmd, int version, union semun arg)
 {
@@ -887,9 +892,12 @@ static int semctl_down(struct ipc_namesp
 		if(copy_semid_from_user (&setbuf, arg.buf, version))
 			return -EFAULT;
 	}
+	down_write(&sem_ids(ns).rw_mutex);
 	sma = sem_lock_check_down(ns, semid);
-	if (IS_ERR(sma))
-		return PTR_ERR(sma);
+	if (IS_ERR(sma)) {
+		err = PTR_ERR(sma);
+		goto out_up;
+	}
 
 	ipcp = &sma->sem_perm;
 
@@ -915,26 +923,22 @@ static int semctl_down(struct ipc_namesp
 	switch(cmd){
 	case IPC_RMID:
 		freeary(ns, ipcp);
-		err = 0;
-		break;
+		goto out_up;
 	case IPC_SET:
 		ipcp->uid = setbuf.uid;
 		ipcp->gid = setbuf.gid;
 		ipcp->mode = (ipcp->mode & ~S_IRWXUGO)
 				| (setbuf.mode & S_IRWXUGO);
 		sma->sem_ctime = get_seconds();
-		sem_unlock(sma);
-		err = 0;
 		break;
 	default:
-		sem_unlock(sma);
 		err = -EINVAL;
-		break;
 	}
-	return err;
 
 out_unlock:
 	sem_unlock(sma);
+out_up:
+	up_write(&sem_ids(ns).rw_mutex);
 	return err;
 }
 
@@ -968,9 +972,7 @@ asmlinkage long sys_semctl (int semid, i
 		return err;
 	case IPC_RMID:
 	case IPC_SET:
-		down_write(&sem_ids(ns).rw_mutex);
 		err = semctl_down(ns,semid,semnum,cmd,version,arg);
-		up_write(&sem_ids(ns).rw_mutex);
 		return err;
 	default:
 		return -EINVAL;
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

origin.patch

