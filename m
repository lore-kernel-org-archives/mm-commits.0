From: akpm@linux-foundation.org
Subject: - ipc-fix-error-case-when-idr-cache-is-empty-in-ipcget.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:58 -0700
Message-ID: <200710192253.l9JMrw1X024476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757764AbXJSXGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Pierre.Peiffer@bull.net, Nadia.Derbey@bull.net, pierre.peiffer@bull.net, mm-commits@vger.kernel.org


The patch titled
     IPC: fix error case when idr-cache is empty in ipcget()
has been removed from the -mm tree.  Its filename was
     ipc-fix-error-case-when-idr-cache-is-empty-in-ipcget.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPC: fix error case when idr-cache is empty in ipcget()
From: Pierre Peiffer <Pierre.Peiffer@bull.net>

With the use of idr to store the ipc, the case where the idr cache is
empty, when idr_get_new is called (this may happen even if we call
idr_pre_get() before), is not well handled: it lets
semget()/shmget()/msgget() return ENOSPC when this cache is empty, what 1. 
does not reflect the facts and 2.  does not conform to the man(s).

This patch fixes this by retrying the whole process of allocation in this case.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    4 ++--
 ipc/sem.c  |    4 ++--
 ipc/shm.c  |    5 +++--
 ipc/util.c |   16 +++++++++++-----
 4 files changed, 18 insertions(+), 11 deletions(-)

diff -puN ipc/msg.c~ipc-fix-error-case-when-idr-cache-is-empty-in-ipcget ipc/msg.c
--- a/ipc/msg.c~ipc-fix-error-case-when-idr-cache-is-empty-in-ipcget
+++ a/ipc/msg.c
@@ -203,10 +203,10 @@ static int newque(struct ipc_namespace *
 	 * ipc_addid() locks msq
 	 */
 	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
-	if (id == -1) {
+	if (id < 0) {
 		security_msg_queue_free(msq);
 		ipc_rcu_putref(msq);
-		return -ENOSPC;
+		return id;
 	}
 
 	msq->q_perm.id = msg_buildid(id, msq->q_perm.seq);
diff -puN ipc/sem.c~ipc-fix-error-case-when-idr-cache-is-empty-in-ipcget ipc/sem.c
--- a/ipc/sem.c~ipc-fix-error-case-when-idr-cache-is-empty-in-ipcget
+++ a/ipc/sem.c
@@ -283,10 +283,10 @@ static int newary(struct ipc_namespace *
 	}
 
 	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
-	if(id == -1) {
+	if (id < 0) {
 		security_sem_free(sma);
 		ipc_rcu_putref(sma);
-		return -ENOSPC;
+		return id;
 	}
 	ns->used_sems += nsems;
 
diff -puN ipc/shm.c~ipc-fix-error-case-when-idr-cache-is-empty-in-ipcget ipc/shm.c
--- a/ipc/shm.c~ipc-fix-error-case-when-idr-cache-is-empty-in-ipcget
+++ a/ipc/shm.c
@@ -433,10 +433,11 @@ static int newseg(struct ipc_namespace *
 	if (IS_ERR(file))
 		goto no_file;
 
-	error = -ENOSPC;
 	id = shm_addid(ns, shp);
-	if(id == -1) 
+	if (id < 0) {
+		error = id;
 		goto no_id;
+	}
 
 	shp->shm_cprid = task_tgid_vnr(current);
 	shp->shm_lprid = 0;
diff -puN ipc/util.c~ipc-fix-error-case-when-idr-cache-is-empty-in-ipcget ipc/util.c
--- a/ipc/util.c~ipc-fix-error-case-when-idr-cache-is-empty-in-ipcget
+++ a/ipc/util.c
@@ -262,7 +262,7 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	Add an entry 'new' to the IPC ids idr. The permissions object is
  *	initialised and the first free entry is set up and the id assigned
  *	is returned. The 'new' entry is returned in a locked state on success.
- *	On failure the entry is not locked and -1 is returned.
+ *	On failure the entry is not locked and a negative err-code is returned.
  *
  *	Called with ipc_ids.rw_mutex held as a writer.
  */
@@ -275,11 +275,11 @@ int ipc_addid(struct ipc_ids* ids, struc
 		size = IPCMNI;
 
 	if (ids->in_use >= size)
-		return -1;
+		return -ENOSPC;
 
 	err = idr_get_new(&ids->ipcs_idr, new, &id);
 	if (err)
-		return -1;
+		return err;
 
 	ids->in_use++;
 
@@ -311,7 +311,7 @@ int ipcget_new(struct ipc_namespace *ns,
 		struct ipc_ops *ops, struct ipc_params *params)
 {
 	int err;
-
+retry:
 	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
 
 	if (!err)
@@ -321,6 +321,9 @@ int ipcget_new(struct ipc_namespace *ns,
 	err = ops->getnew(ns, params);
 	up_write(&ids->rw_mutex);
 
+	if (err == -EAGAIN)
+		goto retry;
+
 	return err;
 }
 
@@ -374,7 +377,7 @@ int ipcget_public(struct ipc_namespace *
 	struct kern_ipc_perm *ipcp;
 	int flg = params->flg;
 	int err;
-
+retry:
 	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
 
 	/*
@@ -411,6 +414,9 @@ int ipcget_public(struct ipc_namespace *
 	}
 	up_write(&ids->rw_mutex);
 
+	if (err == -EAGAIN)
+		goto retry;
+
 	return err;
 }
 
_

Patches currently in -mm which might be from Pierre.Peiffer@bull.net are

origin.patch
