From: akpm@linux-foundation.org
Subject: + ipc-get-rid-of-ipc_lock_down.patch added to -mm tree
Date: Wed, 07 May 2008 13:40:38 -0700
Message-ID: <200805072040.m47Kecjh015483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754625AbYEGUrJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 16:47:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, peifferp@gmail.com


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

Remove the ipc_lock_down() routines: they used to call idr_find() locklessly
(given that the ipc ids lock was already held), so they are not needed
anymore.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
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
@@ -113,23 +113,8 @@ void __init shm_init (void)
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
@@ -212,7 +197,7 @@ static void shm_close(struct vm_area_str
 
 	down_write(&shm_ids(ns).rw_mutex);
 	/* remove from the list of attaches of the shm segment */
-	shp = shm_lock_down(ns, sfd->id);
+	shp = shm_lock(ns, sfd->id);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_dtim = get_seconds();
@@ -937,7 +922,7 @@ invalid:
 
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
- * Look for an id in the ipc ids idr and lock the associated ipc object.
- *
- * The ipc object is locked on exit.
- *
- * This is the routine that should be called when the rw_mutex is already
- * held, i.e. idr tree protected.
- */
-
-struct kern_ipc_perm *ipc_lock_down(struct ipc_ids *ids, int id)
-{
-	struct kern_ipc_perm *out;
-	int lid = ipcid_to_idx(id);
-
-	rcu_read_lock();
-	out = idr_find(&ids->ipcs_idr, lid);
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

idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch

