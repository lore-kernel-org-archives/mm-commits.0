From: akpm@linux-foundation.org
Subject: + ipc-get-rid-of-ipc_lock_down.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:01:20 -0700
Message-ID: <200804291901.m3TJ1KBa004477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764256AbYD2TKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:10:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     ipc: get rid of ipc_lock_down()
has been added to the -mm tree.  Its filename is
     ipc-get-rid-of-ipc_lock_down.patch

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
Subject: ipc: get rid of ipc_lock_down()
From: Nadia Derbey <Nadia.Derbey@bull.net>

With the previous patch ipc_lock() becomes lockless.  So there is no need
anymore for ipc_lock_down()-like routines.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c  |   21 ++------------------
 ipc/util.c |   52 ---------------------------------------------------
 ipc/util.h |    6 -----
 3 files changed, 4 insertions(+), 75 deletions(-)

diff -puN ipc/shm.c~ipc-get-rid-of-ipc_lock_down ipc/shm.c
--- a/ipc/shm.c~ipc-get-rid-of-ipc_lock_down
+++ a/ipc/shm.c
@@ -112,23 +112,8 @@ void __init shm_init (void)
 }
 
 /*
- * shm_lock_(check_)down routines are called in the paths where the rw_mutex
- * is held to protect access to the idr tree.
- */
-static inline struct shmid_kernel *shm_lock_down(struct ipc_namespace *ns,
-						int id)
-{
-	struct kern_ipc_perm *ipcp = ipc_lock_down(&shm_ids(ns), id);
-
-	if (IS_ERR(ipcp))
-		return (struct shmid_kernel *)ipcp;
-
-	return container_of(ipcp, struct shmid_kernel, shm_perm);
-}
-
-/*
  * shm_lock_(check_) routines are called in the paths where the rw_mutex
- * is not held.
+ * is not necessarily held.
  */
 static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
 {
@@ -211,7 +196,7 @@ static void shm_close(struct vm_area_str
 
 	down_write(&shm_ids(ns).rw_mutex);
 	/* remove from the list of attaches of the shm segment */
-	shp = shm_lock_down(ns, sfd->id);
+	shp = shm_lock(ns, sfd->id);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_dtim = get_seconds();
@@ -933,7 +918,7 @@ invalid:
 
 out_nattch:
 	down_write(&shm_ids(ns).rw_mutex);
-	shp = shm_lock_down(ns, shmid);
+	shp = shm_lock(ns, shmid);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_nattch--;
 	if(shp->shm_nattch == 0 &&
diff -puN ipc/util.c~ipc-get-rid-of-ipc_lock_down ipc/util.c
--- a/ipc/util.c~ipc-get-rid-of-ipc_lock_down
+++ a/ipc/util.c
@@ -716,56 +716,6 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	return out;
 }
 
-/**
- * ipc_lock_down - Lock an ipc structure with rw_sem held
- * @ids: IPC identifier set
- * @id: ipc id to look for
- *
- * Look for an id in the ipc ids ridr and lock the associated ipc object.
- *
- * The ipc object is locked on exit.
- *
- * This is the routine that should be called when the rw_mutex is already
- * held, i.e. ridr tree protected.
- */
-
-struct kern_ipc_perm *ipc_lock_down(struct ipc_ids *ids, int id)
-{
-	struct kern_ipc_perm *out;
-	int lid = ipcid_to_idx(id);
-
-	rcu_read_lock();
-	out = ridr_find(&ids->ipcs_ridr, lid);
-	if (out == NULL) {
-		rcu_read_unlock();
-		return ERR_PTR(-EINVAL);
-	}
-
-	spin_lock(&out->lock);
-
-	/*
-	 * No need to verify that the structure is still valid since the
-	 * rw_mutex is held.
-	 */
-	return out;
-}
-
-struct kern_ipc_perm *ipc_lock_check_down(struct ipc_ids *ids, int id)
-{
-	struct kern_ipc_perm *out;
-
-	out = ipc_lock_down(ids, id);
-	if (IS_ERR(out))
-		return out;
-
-	if (ipc_checkid(out, id)) {
-		ipc_unlock(out);
-		return ERR_PTR(-EIDRM);
-	}
-
-	return out;
-}
-
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id)
 {
 	struct kern_ipc_perm *out;
@@ -837,7 +787,7 @@ struct kern_ipc_perm *ipcctl_pre_down(st
 	int err;
 
 	down_write(&ids->rw_mutex);
-	ipcp = ipc_lock_check_down(ids, id);
+	ipcp = ipc_lock_check(ids, id);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
 		goto out_up;
diff -puN ipc/util.h~ipc-get-rid-of-ipc_lock_down ipc/util.h
--- a/ipc/util.h~ipc-get-rid-of-ipc_lock_down
+++ a/ipc/util.h
@@ -102,11 +102,6 @@ void* ipc_rcu_alloc(int size);
 void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
-/*
- * ipc_lock_down: called with rw_mutex held
- * ipc_lock: called without that lock held
- */
-struct kern_ipc_perm *ipc_lock_down(struct ipc_ids *, int);
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
@@ -155,7 +150,6 @@ static inline void ipc_unlock(struct ker
 	rcu_read_unlock();
 }
 
-struct kern_ipc_perm *ipc_lock_check_down(struct ipc_ids *ids, int id);
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

ipc-use-ipc_buildid-directly-from-ipc_addid.patch
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
ipc-add-definitions-of-ushort_max-and-others.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
idr-fix-idr_remove.patch
idr-introduce-the-ridr-structure.patch
idr-introduce-ridr_pre_get.patch
idr-introduce-ridr_init.patch
idr-introduce-ridr_get_new_above.patch
idr-introduce-ridr_get_new.patch
idr-introduce-ridr_find.patch
idr-introduce-ridr_remove.patch
ipc-integrate-the-ridr-code-into-ipc-code.patch
ipc-get-rid-of-ipc_lock_down.patch

