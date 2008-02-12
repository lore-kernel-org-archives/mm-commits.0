From: akpm@linux-foundation.org
Subject: + ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch added to -mm tree
Date: Tue, 12 Feb 2008 13:28:13 -0800
Message-ID: <200802122128.m1CLSET6023077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53654 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYBLV3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 16:29:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, serue@us.ibm.com


The patch titled
     IPC/semaphores: move the rwmutex handling inside semctl_down
has been added to the -mm tree.  Its filename is
     ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch

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
