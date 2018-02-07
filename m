From: akpm@linux-foundation.org
Subject: [merged] ipc-fix-ipc-data-structures-inconsistency.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:59:17 -0800
Message-ID: <20180207195917.2CmT0IFJ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754411AbeBGT7S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org, philippe.mikoyan@skat.systems, viro@zeniv.linux.org.uk


The patch titled
     Subject: ipc: fix ipc data structures inconsistency
has been removed from the -mm tree.  Its filename was
     ipc-fix-ipc-data-structures-inconsistency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Philippe Mikoyan <philippe.mikoyan@skat.systems>
Subject: ipc: fix ipc data structures inconsistency

As described in the title, this patch fixes <ipc>id_ds inconsistency when
<ipc>ctl_stat executes concurrently with some ds-changing function, e.g. 
shmat, msgsnd or whatever.

For instance, if shmctl(IPC_STAT) is running concurrently
with shmat, following data structure can be returned:
{... shm_lpid = 0, shm_nattch = 1, ...}

Link: http://lkml.kernel.org/r/20171202153456.6514-1-philippe.mikoyan@skat.systems
Signed-off-by: Philippe Mikoyan <philippe.mikoyan@skat.systems>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |   20 ++++++++++++++------
 ipc/sem.c  |   10 ++++++++++
 ipc/shm.c  |   20 +++++++++++++++-----
 ipc/util.c |    5 ++++-
 4 files changed, 43 insertions(+), 12 deletions(-)

diff -puN ipc/msg.c~ipc-fix-ipc-data-structures-inconsistency ipc/msg.c
--- a/ipc/msg.c~ipc-fix-ipc-data-structures-inconsistency
+++ a/ipc/msg.c
@@ -476,9 +476,9 @@ static int msgctl_info(struct ipc_namesp
 static int msgctl_stat(struct ipc_namespace *ns, int msqid,
 			 int cmd, struct msqid64_ds *p)
 {
-	int err;
 	struct msg_queue *msq;
-	int success_return;
+	int id = 0;
+	int err;
 
 	memset(p, 0, sizeof(*p));
 
@@ -489,14 +489,13 @@ static int msgctl_stat(struct ipc_namesp
 			err = PTR_ERR(msq);
 			goto out_unlock;
 		}
-		success_return = msq->q_perm.id;
+		id = msq->q_perm.id;
 	} else {
 		msq = msq_obtain_object_check(ns, msqid);
 		if (IS_ERR(msq)) {
 			err = PTR_ERR(msq);
 			goto out_unlock;
 		}
-		success_return = 0;
 	}
 
 	err = -EACCES;
@@ -507,6 +506,14 @@ static int msgctl_stat(struct ipc_namesp
 	if (err)
 		goto out_unlock;
 
+	ipc_lock_object(&msq->q_perm);
+
+	if (!ipc_valid_object(&msq->q_perm)) {
+		ipc_unlock_object(&msq->q_perm);
+		err = -EIDRM;
+		goto out_unlock;
+	}
+
 	kernel_to_ipc64_perm(&msq->q_perm, &p->msg_perm);
 	p->msg_stime  = msq->q_stime;
 	p->msg_rtime  = msq->q_rtime;
@@ -516,9 +523,10 @@ static int msgctl_stat(struct ipc_namesp
 	p->msg_qbytes = msq->q_qbytes;
 	p->msg_lspid  = msq->q_lspid;
 	p->msg_lrpid  = msq->q_lrpid;
-	rcu_read_unlock();
 
-	return success_return;
+	ipc_unlock_object(&msq->q_perm);
+	rcu_read_unlock();
+	return id;
 
 out_unlock:
 	rcu_read_unlock();
diff -puN ipc/sem.c~ipc-fix-ipc-data-structures-inconsistency ipc/sem.c
--- a/ipc/sem.c~ipc-fix-ipc-data-structures-inconsistency
+++ a/ipc/sem.c
@@ -1213,10 +1213,20 @@ static int semctl_stat(struct ipc_namesp
 	if (err)
 		goto out_unlock;
 
+	ipc_lock_object(&sma->sem_perm);
+
+	if (!ipc_valid_object(&sma->sem_perm)) {
+		ipc_unlock_object(&sma->sem_perm);
+		err = -EIDRM;
+		goto out_unlock;
+	}
+
 	kernel_to_ipc64_perm(&sma->sem_perm, &semid64->sem_perm);
 	semid64->sem_otime = get_semotime(sma);
 	semid64->sem_ctime = sma->sem_ctime;
 	semid64->sem_nsems = sma->sem_nsems;
+
+	ipc_unlock_object(&sma->sem_perm);
 	rcu_read_unlock();
 	return id;
 
diff -puN ipc/shm.c~ipc-fix-ipc-data-structures-inconsistency ipc/shm.c
--- a/ipc/shm.c~ipc-fix-ipc-data-structures-inconsistency
+++ a/ipc/shm.c
@@ -909,9 +909,11 @@ static int shmctl_stat(struct ipc_namesp
 			int cmd, struct shmid64_ds *tbuf)
 {
 	struct shmid_kernel *shp;
-	int result;
+	int id = 0;
 	int err;
 
+	memset(tbuf, 0, sizeof(*tbuf));
+
 	rcu_read_lock();
 	if (cmd == SHM_STAT) {
 		shp = shm_obtain_object(ns, shmid);
@@ -919,14 +921,13 @@ static int shmctl_stat(struct ipc_namesp
 			err = PTR_ERR(shp);
 			goto out_unlock;
 		}
-		result = shp->shm_perm.id;
+		id = shp->shm_perm.id;
 	} else {
 		shp = shm_obtain_object_check(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
 			goto out_unlock;
 		}
-		result = 0;
 	}
 
 	err = -EACCES;
@@ -937,7 +938,14 @@ static int shmctl_stat(struct ipc_namesp
 	if (err)
 		goto out_unlock;
 
-	memset(tbuf, 0, sizeof(*tbuf));
+	ipc_lock_object(&shp->shm_perm);
+
+	if (!ipc_valid_object(&shp->shm_perm)) {
+		ipc_unlock_object(&shp->shm_perm);
+		err = -EIDRM;
+		goto out_unlock;
+	}
+
 	kernel_to_ipc64_perm(&shp->shm_perm, &tbuf->shm_perm);
 	tbuf->shm_segsz	= shp->shm_segsz;
 	tbuf->shm_atime	= shp->shm_atim;
@@ -946,8 +954,10 @@ static int shmctl_stat(struct ipc_namesp
 	tbuf->shm_cpid	= shp->shm_cprid;
 	tbuf->shm_lpid	= shp->shm_lprid;
 	tbuf->shm_nattch = shp->shm_nattch;
+
+	ipc_unlock_object(&shp->shm_perm);
 	rcu_read_unlock();
-	return result;
+	return id;
 
 out_unlock:
 	rcu_read_unlock();
diff -puN ipc/util.c~ipc-fix-ipc-data-structures-inconsistency ipc/util.c
--- a/ipc/util.c~ipc-fix-ipc-data-structures-inconsistency
+++ a/ipc/util.c
@@ -23,9 +23,12 @@
  *	    tree.
  *	    - perform initial checks (capabilities, auditing and permission,
  *	      etc).
- *	    - perform read-only operations, such as STAT, INFO commands.
+ *	    - perform read-only operations, such as INFO command, that
+ *	      do not demand atomicity
  *	      acquire the ipc lock (kern_ipc_perm.lock) through
  *	      ipc_lock_object()
+ *		- perform read-only operations that demand atomicity,
+ *		  such as STAT command.
  *		- perform data updates, such as SET, RMID commands and
  *		  mechanism-specific operations (semop/semtimedop,
  *		  msgsnd/msgrcv, shmat/shmdt).
_

Patches currently in -mm which might be from philippe.mikoyan@skat.systems are


