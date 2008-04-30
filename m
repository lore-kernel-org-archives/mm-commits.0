From: akpm@linux-foundation.org
Subject: - ipc-use-ipc_buildid-directly-from-ipc_addid.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:46 -0700
Message-ID: <200804300543.m3U5hkFE029341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758355AbYD3Fos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:44:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     IPC: use ipc_buildid() directly from ipc_addid()
has been removed from the -mm tree.  Its filename was
     ipc-use-ipc_buildid-directly-from-ipc_addid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IPC: use ipc_buildid() directly from ipc_addid()
From: Pierre Peiffer <pierre.peiffer@bull.net>

By continuing to consolidate a little the IPC code, each id can be built
directly in ipc_addid() instead of having it built from each callers of
ipc_addid()

And I also remove shm_addid() in order to have, as much as possible, the
same code for shm/sem/msg.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    2 --
 ipc/sem.c  |    2 --
 ipc/shm.c  |   10 +---------
 ipc/util.c |    1 +
 4 files changed, 2 insertions(+), 13 deletions(-)

diff -puN ipc/msg.c~ipc-use-ipc_buildid-directly-from-ipc_addid ipc/msg.c
--- a/ipc/msg.c~ipc-use-ipc_buildid-directly-from-ipc_addid
+++ a/ipc/msg.c
@@ -70,7 +70,6 @@ struct msg_sender {
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
 #define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
-#define msg_buildid(id, seq)	ipc_buildid(id, seq)
 
 static void freeque(struct ipc_namespace *, struct kern_ipc_perm *);
 static int newque(struct ipc_namespace *, struct ipc_params *);
@@ -186,7 +185,6 @@ static int newque(struct ipc_namespace *
 		return id;
 	}
 
-	msq->q_perm.id = msg_buildid(id, msq->q_perm.seq);
 	msq->q_stime = msq->q_rtime = 0;
 	msq->q_ctime = get_seconds();
 	msq->q_cbytes = msq->q_qnum = 0;
diff -puN ipc/sem.c~ipc-use-ipc_buildid-directly-from-ipc_addid ipc/sem.c
--- a/ipc/sem.c~ipc-use-ipc_buildid-directly-from-ipc_addid
+++ a/ipc/sem.c
@@ -91,7 +91,6 @@
 
 #define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
 #define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
-#define sem_buildid(id, seq)	ipc_buildid(id, seq)
 
 static int newary(struct ipc_namespace *, struct ipc_params *);
 static void freeary(struct ipc_namespace *, struct kern_ipc_perm *);
@@ -268,7 +267,6 @@ static int newary(struct ipc_namespace *
 	}
 	ns->used_sems += nsems;
 
-	sma->sem_perm.id = sem_buildid(id, sma->sem_perm.seq);
 	sma->sem_base = (struct sem *) &sma[1];
 	/* sma->sem_pending = NULL; */
 	sma->sem_pending_last = &sma->sem_pending;
diff -puN ipc/shm.c~ipc-use-ipc_buildid-directly-from-ipc_addid ipc/shm.c
--- a/ipc/shm.c~ipc-use-ipc_buildid-directly-from-ipc_addid
+++ a/ipc/shm.c
@@ -60,7 +60,6 @@ static struct vm_operations_struct shm_v
 
 #define shm_unlock(shp)			\
 	ipc_unlock(&(shp)->shm_perm)
-#define shm_buildid(id, seq)	ipc_buildid(id, seq)
 
 static int newseg(struct ipc_namespace *, struct ipc_params *);
 static void shm_open(struct vm_area_struct *vma);
@@ -169,12 +168,6 @@ static inline void shm_rmid(struct ipc_n
 	ipc_rmid(&shm_ids(ns), &s->shm_perm);
 }
 
-static inline int shm_addid(struct ipc_namespace *ns, struct shmid_kernel *shp)
-{
-	return ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
-}
-
-
 
 /* This is called by fork, once for every shm attach. */
 static void shm_open(struct vm_area_struct *vma)
@@ -416,7 +409,7 @@ static int newseg(struct ipc_namespace *
 	if (IS_ERR(file))
 		goto no_file;
 
-	id = shm_addid(ns, shp);
+	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (id < 0) {
 		error = id;
 		goto no_id;
@@ -428,7 +421,6 @@ static int newseg(struct ipc_namespace *
 	shp->shm_ctim = get_seconds();
 	shp->shm_segsz = size;
 	shp->shm_nattch = 0;
-	shp->shm_perm.id = shm_buildid(id, shp->shm_perm.seq);
 	shp->shm_file = file;
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
diff -puN ipc/util.c~ipc-use-ipc_buildid-directly-from-ipc_addid ipc/util.c
--- a/ipc/util.c~ipc-use-ipc_buildid-directly-from-ipc_addid
+++ a/ipc/util.c
@@ -231,6 +231,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 	if(ids->seq > ids->seq_max)
 		ids->seq = 0;
 
+	new->id = ipc_buildid(id, new->seq);
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
 	rcu_read_lock();
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

origin.patch

