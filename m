From: akpm@linux-foundation.org
Subject: + ipc-semaphores-code-factorisation.patch added to -mm tree
Date: Tue, 12 Feb 2008 13:27:20 -0800
Message-ID: <200802122127.m1CLRKPl023023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbYBLV22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 16:28:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, serue@us.ibm.com


The patch titled
     IPC/semaphores: code factorisation
has been added to the -mm tree.  Its filename is
     ipc-semaphores-code-factorisation.patch

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
