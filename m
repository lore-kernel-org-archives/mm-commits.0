From: akpm@linux-foundation.org
Subject: - ipc-remove-unneeded-parameters.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:52 -0700
Message-ID: <200710192253.l9JMrqOQ024460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45433 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966659AbXJSXFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     ipc: remove unneeded parameters
has been removed from the -mm tree.  Its filename was
     ipc-remove-unneeded-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipc: remove unneeded parameters
From: Nadia Derbey <Nadia.Derbey@bull.net>

Remvoe the unneeded parameters from ipc_checkid() and ipc_buildid()
interfaces.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    5 ++---
 ipc/sem.c  |   10 ++++------
 ipc/shm.c  |    5 ++---
 ipc/util.h |    9 ++++-----
 4 files changed, 12 insertions(+), 17 deletions(-)

diff -puN ipc/msg.c~ipc-remove-unneeded-parameters ipc/msg.c
--- a/ipc/msg.c~ipc-remove-unneeded-parameters
+++ a/ipc/msg.c
@@ -74,8 +74,7 @@ static struct ipc_ids init_msg_ids;
 #define msg_ids(ns)	(*((ns)->ids[IPC_MSG_IDS]))
 
 #define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
-#define msg_buildid(ns, id, seq) \
-	ipc_buildid(&msg_ids(ns), id, seq)
+#define msg_buildid(id, seq)	ipc_buildid(id, seq)
 
 static void freeque(struct ipc_namespace *, struct msg_queue *);
 static int newque(struct ipc_namespace *, struct ipc_params *);
@@ -211,7 +210,7 @@ static int newque(struct ipc_namespace *
 		return -ENOSPC;
 	}
 
-	msq->q_perm.id = msg_buildid(ns, id, msq->q_perm.seq);
+	msq->q_perm.id = msg_buildid(id, msq->q_perm.seq);
 	msq->q_stime = msq->q_rtime = 0;
 	msq->q_ctime = get_seconds();
 	msq->q_cbytes = msq->q_qnum = 0;
diff -puN ipc/sem.c~ipc-remove-unneeded-parameters ipc/sem.c
--- a/ipc/sem.c~ipc-remove-unneeded-parameters
+++ a/ipc/sem.c
@@ -89,10 +89,8 @@
 #define sem_ids(ns)	(*((ns)->ids[IPC_SEM_IDS]))
 
 #define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
-#define sem_checkid(ns, sma, semid)	\
-	ipc_checkid(&sem_ids(ns),&sma->sem_perm,semid)
-#define sem_buildid(ns, id, seq) \
-	ipc_buildid(&sem_ids(ns), id, seq)
+#define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
+#define sem_buildid(id, seq)	ipc_buildid(id, seq)
 
 static struct ipc_ids init_sem_ids;
 
@@ -292,7 +290,7 @@ static int newary(struct ipc_namespace *
 	}
 	ns->used_sems += nsems;
 
-	sma->sem_perm.id = sem_buildid(ns, id, sma->sem_perm.seq);
+	sma->sem_perm.id = sem_buildid(id, sma->sem_perm.seq);
 	sma->sem_base = (struct sem *) &sma[1];
 	/* sma->sem_pending = NULL; */
 	sma->sem_pending_last = &sma->sem_pending;
@@ -1386,7 +1384,7 @@ void exit_sem(struct task_struct *tsk)
 		if (u->semid == -1)
 			goto next_entry;
 
-		BUG_ON(sem_checkid(ns,sma,u->semid));
+		BUG_ON(sem_checkid(sma, u->semid));
 
 		/* remove u from the sma->undo list */
 		for (unp = &sma->undo; (un = *unp); unp = &un->id_next) {
diff -puN ipc/shm.c~ipc-remove-unneeded-parameters ipc/shm.c
--- a/ipc/shm.c~ipc-remove-unneeded-parameters
+++ a/ipc/shm.c
@@ -61,8 +61,7 @@ static struct ipc_ids init_shm_ids;
 
 #define shm_unlock(shp)			\
 	ipc_unlock(&(shp)->shm_perm)
-#define shm_buildid(ns, id, seq)	\
-	ipc_buildid(&shm_ids(ns), id, seq)
+#define shm_buildid(id, seq)	ipc_buildid(id, seq)
 
 static int newseg(struct ipc_namespace *, struct ipc_params *);
 static void shm_open(struct vm_area_struct *vma);
@@ -445,7 +444,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_ctim = get_seconds();
 	shp->shm_segsz = size;
 	shp->shm_nattch = 0;
-	shp->shm_perm.id = shm_buildid(ns, id, shp->shm_perm.seq);
+	shp->shm_perm.id = shm_buildid(id, shp->shm_perm.seq);
 	shp->shm_file = file;
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
diff -puN ipc/util.h~ipc-remove-unneeded-parameters ipc/util.h
--- a/ipc/util.h~ipc-remove-unneeded-parameters
+++ a/ipc/util.h
@@ -134,7 +134,7 @@ extern int ipcget_new(struct ipc_namespa
 extern int ipcget_public(struct ipc_namespace *, struct ipc_ids *,
 			struct ipc_ops *, struct ipc_params *);
 
-static inline int ipc_buildid(struct ipc_ids *ids, int id, int seq)
+static inline int ipc_buildid(int id, int seq)
 {
 	return SEQ_MULTIPLIER * seq + id;
 }
@@ -142,8 +142,7 @@ static inline int ipc_buildid(struct ipc
 /*
  * Must be called with ipcp locked
  */
-static inline int ipc_checkid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp,
-				int uid)
+static inline int ipc_checkid(struct kern_ipc_perm *ipcp, int uid)
 {
 	if (uid / SEQ_MULTIPLIER != ipcp->seq)
 		return 1;
@@ -171,7 +170,7 @@ static inline struct kern_ipc_perm *ipc_
 	if (IS_ERR(out))
 		return out;
 
-	if (ipc_checkid(ids, out, id)) {
+	if (ipc_checkid(out, id)) {
 		ipc_unlock(out);
 		return ERR_PTR(-EIDRM);
 	}
@@ -188,7 +187,7 @@ static inline struct kern_ipc_perm *ipc_
 	if (IS_ERR(out))
 		return out;
 
-	if (ipc_checkid(ids, out, id)) {
+	if (ipc_checkid(out, id)) {
 		ipc_unlock(out);
 		return ERR_PTR(-EIDRM);
 	}
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
