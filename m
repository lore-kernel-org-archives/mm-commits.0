From: akpm@linux-foundation.org
Subject: - ipc-semaphores-code-factorisation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:07 -0700
Message-ID: <200804300544.m3U5i70s029378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760732AbYD3GMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     IPC/semaphores: code factorisation
has been removed from the -mm tree.  Its filename was
     ipc-semaphores-code-factorisation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IPC/semaphores: code factorisation
From: Pierre Peiffer <pierre.peiffer@bull.net>

Trivial patch which adds some small locking functions and makes use of them to
factorize some part of the code and to make it cleaner.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   61 ++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff -puN ipc/sem.c~ipc-semaphores-code-factorisation ipc/sem.c
--- a/ipc/sem.c~ipc-semaphores-code-factorisation
+++ a/ipc/sem.c
@@ -180,6 +180,25 @@ static inline struct sem_array *sem_lock
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
+static inline void sem_lock_and_putref(struct sem_array *sma)
+{
+	ipc_lock_by_ptr(&sma->sem_perm);
+	ipc_rcu_putref(sma);
+}
+
+static inline void sem_getref_and_unlock(struct sem_array *sma)
+{
+	ipc_rcu_getref(sma);
+	ipc_unlock(&(sma)->sem_perm);
+}
+
+static inline void sem_putref(struct sem_array *sma)
+{
+	ipc_lock_by_ptr(&sma->sem_perm);
+	ipc_rcu_putref(sma);
+	ipc_unlock(&(sma)->sem_perm);
+}
+
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
 {
 	ipc_rmid(&sem_ids(ns), &s->sem_perm);
@@ -698,19 +717,15 @@ static int semctl_main(struct ipc_namesp
 		int i;
 
 		if(nsems > SEMMSL_FAST) {
-			ipc_rcu_getref(sma);
-			sem_unlock(sma);			
+			sem_getref_and_unlock(sma);
 
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if(sem_io == NULL) {
-				ipc_lock_by_ptr(&sma->sem_perm);
-				ipc_rcu_putref(sma);
-				sem_unlock(sma);
+				sem_putref(sma);
 				return -ENOMEM;
 			}
 
-			ipc_lock_by_ptr(&sma->sem_perm);
-			ipc_rcu_putref(sma);
+			sem_lock_and_putref(sma);
 			if (sma->sem_perm.deleted) {
 				sem_unlock(sma);
 				err = -EIDRM;
@@ -731,38 +746,30 @@ static int semctl_main(struct ipc_namesp
 		int i;
 		struct sem_undo *un;
 
-		ipc_rcu_getref(sma);
-		sem_unlock(sma);
+		sem_getref_and_unlock(sma);
 
 		if(nsems > SEMMSL_FAST) {
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if(sem_io == NULL) {
-				ipc_lock_by_ptr(&sma->sem_perm);
-				ipc_rcu_putref(sma);
-				sem_unlock(sma);
+				sem_putref(sma);
 				return -ENOMEM;
 			}
 		}
 
 		if (copy_from_user (sem_io, arg.array, nsems*sizeof(ushort))) {
-			ipc_lock_by_ptr(&sma->sem_perm);
-			ipc_rcu_putref(sma);
-			sem_unlock(sma);
+			sem_putref(sma);
 			err = -EFAULT;
 			goto out_free;
 		}
 
 		for (i = 0; i < nsems; i++) {
 			if (sem_io[i] > SEMVMX) {
-				ipc_lock_by_ptr(&sma->sem_perm);
-				ipc_rcu_putref(sma);
-				sem_unlock(sma);
+				sem_putref(sma);
 				err = -ERANGE;
 				goto out_free;
 			}
 		}
-		ipc_lock_by_ptr(&sma->sem_perm);
-		ipc_rcu_putref(sma);
+		sem_lock_and_putref(sma);
 		if (sma->sem_perm.deleted) {
 			sem_unlock(sma);
 			err = -EIDRM;
@@ -1042,14 +1049,11 @@ static struct sem_undo *find_undo(struct
 		return ERR_PTR(PTR_ERR(sma));
 
 	nsems = sma->sem_nsems;
-	ipc_rcu_getref(sma);
-	sem_unlock(sma);
+	sem_getref_and_unlock(sma);
 
 	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
 	if (!new) {
-		ipc_lock_by_ptr(&sma->sem_perm);
-		ipc_rcu_putref(sma);
-		sem_unlock(sma);
+		sem_putref(sma);
 		return ERR_PTR(-ENOMEM);
 	}
 	new->semadj = (short *) &new[1];
@@ -1060,13 +1064,10 @@ static struct sem_undo *find_undo(struct
 	if (un) {
 		spin_unlock(&ulp->lock);
 		kfree(new);
-		ipc_lock_by_ptr(&sma->sem_perm);
-		ipc_rcu_putref(sma);
-		sem_unlock(sma);
+		sem_putref(sma);
 		goto out;
 	}
-	ipc_lock_by_ptr(&sma->sem_perm);
-	ipc_rcu_putref(sma);
+	sem_lock_and_putref(sma);
 	if (sma->sem_perm.deleted) {
 		sem_unlock(sma);
 		spin_unlock(&ulp->lock);
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

origin.patch

