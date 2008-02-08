From: akpm@linux-foundation.org
Subject: - ipc-semaphores-consolidate-sem_stat-and.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:13 -0800
Message-ID: <200802082012.m18KCsmA010242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35016 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756400AbYBHUvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:51:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     IPC/semaphores: consolidate SEM_STAT and IPC_STAT commands
has been removed from the -mm tree.  Its filename was
     ipc-semaphores-consolidate-sem_stat-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IPC/semaphores: consolidate SEM_STAT and IPC_STAT commands
From: Pierre Peiffer <pierre.peiffer@bull.net>

These commands (SEM_STAT and IPC_STAT) are rather doing the same things
(only the meaning of the id given as input and the return value differ). 
However, for the semaphores, they are handled in two different places (two
different functions).

This patch consolidates this for clarification by handling these both
commands in the same place in semctl_nolock().  It also removes one unused
parameter for this function.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff -puN ipc/sem.c~ipc-semaphores-consolidate-sem_stat-and ipc/sem.c
--- a/ipc/sem.c~ipc-semaphores-consolidate-sem_stat-and
+++ a/ipc/sem.c
@@ -617,8 +617,8 @@ static unsigned long copy_semid_to_user(
 	}
 }
 
-static int semctl_nolock(struct ipc_namespace *ns, int semid, int semnum,
-		int cmd, int version, union semun arg)
+static int semctl_nolock(struct ipc_namespace *ns, int semid,
+			 int cmd, int version, union semun arg)
 {
 	int err = -EINVAL;
 	struct sem_array *sma;
@@ -657,14 +657,23 @@ static int semctl_nolock(struct ipc_name
 			return -EFAULT;
 		return (max_id < 0) ? 0: max_id;
 	}
+	case IPC_STAT:
 	case SEM_STAT:
 	{
 		struct semid64_ds tbuf;
 		int id;
 
-		sma = sem_lock(ns, semid);
-		if (IS_ERR(sma))
-			return PTR_ERR(sma);
+		if (cmd == SEM_STAT) {
+			sma = sem_lock(ns, semid);
+			if (IS_ERR(sma))
+				return PTR_ERR(sma);
+			id = sma->sem_perm.id;
+		} else {
+			sma = sem_lock_check(ns, semid);
+			if (IS_ERR(sma))
+				return PTR_ERR(sma);
+			id = 0;
+		}
 
 		err = -EACCES;
 		if (ipcperms (&sma->sem_perm, S_IRUGO))
@@ -674,8 +683,6 @@ static int semctl_nolock(struct ipc_name
 		if (err)
 			goto out_unlock;
 
-		id = sma->sem_perm.id;
-
 		memset(&tbuf, 0, sizeof(tbuf));
 
 		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
@@ -810,19 +817,6 @@ static int semctl_main(struct ipc_namesp
 		err = 0;
 		goto out_unlock;
 	}
-	case IPC_STAT:
-	{
-		struct semid64_ds tbuf;
-		memset(&tbuf,0,sizeof(tbuf));
-		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
-		tbuf.sem_otime  = sma->sem_otime;
-		tbuf.sem_ctime  = sma->sem_ctime;
-		tbuf.sem_nsems  = sma->sem_nsems;
-		sem_unlock(sma);
-		if (copy_semid_to_user (arg.buf, &tbuf, version))
-			return -EFAULT;
-		return 0;
-	}
 	/* GETVAL, GETPID, GETNCTN, GETZCNT, SETVAL: fall-through */
 	}
 	err = -EINVAL;
@@ -989,15 +983,15 @@ asmlinkage long sys_semctl (int semid, i
 	switch(cmd) {
 	case IPC_INFO:
 	case SEM_INFO:
+	case IPC_STAT:
 	case SEM_STAT:
-		err = semctl_nolock(ns,semid,semnum,cmd,version,arg);
+		err = semctl_nolock(ns, semid, cmd, version, arg);
 		return err;
 	case GETALL:
 	case GETVAL:
 	case GETPID:
 	case GETNCNT:
 	case GETZCNT:
-	case IPC_STAT:
 	case SETVAL:
 	case SETALL:
 		err = semctl_main(ns,semid,semnum,cmd,version,arg);
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

origin.patch
