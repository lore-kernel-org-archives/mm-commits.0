From: akpm@linux-foundation.org
Subject: + ipc-integrate-the-ridr-code-into-ipc-code.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:01:18 -0700
Message-ID: <200804291901.m3TJ1IKB004474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758732AbYD2TC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:02:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     ipc: integrate the ridr code into IPC code
has been added to the -mm tree.  Its filename is
     ipc-integrate-the-ridr-code-into-ipc-code.patch

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
Subject: ipc: integrate the ridr code into IPC code
From: Nadia Derbey <Nadia.Derbey@bull.net>

Make the ipc code use the ridr API.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    4 +--
 ipc/namespace.c               |    2 -
 ipc/shm.c                     |    2 -
 ipc/util.c                    |   41 ++++++++++++--------------------
 4 files changed, 20 insertions(+), 29 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-integrate-the-ridr-code-into-ipc-code include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-integrate-the-ridr-code-into-ipc-code
+++ a/include/linux/ipc_namespace.h
@@ -2,7 +2,7 @@
 #define __IPC_NAMESPACE_H__
 
 #include <linux/err.h>
-#include <linux/idr.h>
+#include <linux/ridr.h>
 #include <linux/rwsem.h>
 #include <linux/notifier.h>
 
@@ -21,7 +21,7 @@ struct ipc_ids {
 	unsigned short seq;
 	unsigned short seq_max;
 	struct rw_semaphore rw_mutex;
-	struct idr ipcs_idr;
+	struct ridr ipcs_ridr;
 };
 
 struct ipc_namespace {
diff -puN ipc/namespace.c~ipc-integrate-the-ridr-code-into-ipc-code ipc/namespace.c
--- a/ipc/namespace.c~ipc-integrate-the-ridr-code-into-ipc-code
+++ a/ipc/namespace.c
@@ -74,7 +74,7 @@ void free_ipcs(struct ipc_namespace *ns,
 	in_use = ids->in_use;
 
 	for (total = 0, next_id = 0; total < in_use; next_id++) {
-		perm = idr_find(&ids->ipcs_idr, next_id);
+		perm = ridr_find(&ids->ipcs_ridr, next_id);
 		if (perm == NULL)
 			continue;
 		ipc_lock_by_ptr(perm);
diff -puN ipc/shm.c~ipc-integrate-the-ridr-code-into-ipc-code ipc/shm.c
--- a/ipc/shm.c~ipc-integrate-the-ridr-code-into-ipc-code
+++ a/ipc/shm.c
@@ -569,7 +569,7 @@ static void shm_get_stat(struct ipc_name
 		struct shmid_kernel *shp;
 		struct inode *inode;
 
-		shp = idr_find(&shm_ids(ns).ipcs_idr, next_id);
+		shp = ridr_find(&shm_ids(ns).ipcs_ridr, next_id);
 		if (shp == NULL)
 			continue;
 
diff -puN ipc/util.c~ipc-integrate-the-ridr-code-into-ipc-code ipc/util.c
--- a/ipc/util.c~ipc-integrate-the-ridr-code-into-ipc-code
+++ a/ipc/util.c
@@ -122,7 +122,7 @@ __initcall(ipc_init);
  *	@ids: Identifier set
  *
  *	Set up the sequence range to use for the ipc identifier range (limited
- *	below IPCMNI) then initialise the ids idr.
+ *	below IPCMNI) then initialise the ids ridr.
  */
  
 void ipc_init_ids(struct ipc_ids *ids)
@@ -139,7 +139,7 @@ void ipc_init_ids(struct ipc_ids *ids)
 		 	ids->seq_max = seq_limit;
 	}
 
-	idr_init(&ids->ipcs_idr);
+	ridr_init(&ids->ipcs_ridr);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -194,7 +194,7 @@ static struct kern_ipc_perm *ipc_findkey
 	int total;
 
 	for (total = 0, next_id = 0; total < ids->in_use; next_id++) {
-		ipc = idr_find(&ids->ipcs_idr, next_id);
+		ipc = ridr_find(&ids->ipcs_ridr, next_id);
 
 		if (ipc == NULL)
 			continue;
@@ -233,7 +233,7 @@ int ipc_get_maxid(struct ipc_ids *ids)
 	/* Look for the last assigned id */
 	total = 0;
 	for (id = 0; id < IPCMNI && total < ids->in_use; id++) {
-		ipc = idr_find(&ids->ipcs_idr, id);
+		ipc = ridr_find(&ids->ipcs_ridr, id);
 		if (ipc != NULL) {
 			max_id = id;
 			total++;
@@ -248,7 +248,7 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	@new: new IPC permission set
  *	@size: limit for the number of used ids
  *
- *	Add an entry 'new' to the IPC ids idr. The permissions object is
+ *	Add an entry 'new' to the IPC ids ridr. The permissions object is
  *	initialised and the first free entry is set up and the id assigned
  *	is returned. The 'new' entry is returned in a locked state on success.
  *	On failure the entry is not locked and a negative err-code is returned.
@@ -266,7 +266,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
-	err = idr_get_new(&ids->ipcs_idr, new, &id);
+	err = ridr_get_new(&ids->ipcs_ridr, new, &id);
 	if (err)
 		return err;
 
@@ -302,7 +302,7 @@ static int ipcget_new(struct ipc_namespa
 {
 	int err;
 retry:
-	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
+	err = ridr_pre_get(&ids->ipcs_ridr, GFP_KERNEL);
 
 	if (!err)
 		return -ENOMEM;
@@ -368,7 +368,7 @@ static int ipcget_public(struct ipc_name
 	int flg = params->flg;
 	int err;
 retry:
-	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
+	err = ridr_pre_get(&ids->ipcs_ridr, GFP_KERNEL);
 
 	/*
 	 * Take the lock as a writer since we are potentially going to add
@@ -424,7 +424,7 @@ void ipc_rmid(struct ipc_ids *ids, struc
 {
 	int lid = ipcid_to_idx(ipcp->id);
 
-	idr_remove(&ids->ipcs_idr, lid);
+	ridr_remove(&ids->ipcs_ridr, lid);
 
 	ids->in_use--;
 
@@ -685,13 +685,9 @@ void ipc64_perm_to_ipc_perm (struct ipc6
  * @ids: IPC identifier set
  * @id: ipc id to look for
  *
- * Look for an id in the ipc ids idr and lock the associated ipc object.
+ * Look for an id in the ipc ids ridr and lock the associated ipc object.
  *
  * The ipc object is locked on exit.
- *
- * This is the routine that should be called when the rw_mutex is not already
- * held, i.e. idr tree not protected: it protects the idr tree in read mode
- * during the idr_find().
  */
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
@@ -699,18 +695,13 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	struct kern_ipc_perm *out;
 	int lid = ipcid_to_idx(id);
 
-	down_read(&ids->rw_mutex);
-
 	rcu_read_lock();
-	out = idr_find(&ids->ipcs_idr, lid);
+	out = ridr_find(&ids->ipcs_ridr, lid);
 	if (out == NULL) {
 		rcu_read_unlock();
-		up_read(&ids->rw_mutex);
 		return ERR_PTR(-EINVAL);
 	}
 
-	up_read(&ids->rw_mutex);
-
 	spin_lock(&out->lock);
 	
 	/* ipc_rmid() may have already freed the ID while ipc_lock
@@ -730,12 +721,12 @@ struct kern_ipc_perm *ipc_lock(struct ip
  * @ids: IPC identifier set
  * @id: ipc id to look for
  *
- * Look for an id in the ipc ids idr and lock the associated ipc object.
+ * Look for an id in the ipc ids ridr and lock the associated ipc object.
  *
  * The ipc object is locked on exit.
  *
  * This is the routine that should be called when the rw_mutex is already
- * held, i.e. idr tree protected.
+ * held, i.e. ridr tree protected.
  */
 
 struct kern_ipc_perm *ipc_lock_down(struct ipc_ids *ids, int id)
@@ -744,7 +735,7 @@ struct kern_ipc_perm *ipc_lock_down(stru
 	int lid = ipcid_to_idx(id);
 
 	rcu_read_lock();
-	out = idr_find(&ids->ipcs_idr, lid);
+	out = ridr_find(&ids->ipcs_ridr, lid);
 	if (out == NULL) {
 		rcu_read_unlock();
 		return ERR_PTR(-EINVAL);
@@ -915,7 +906,7 @@ static struct kern_ipc_perm *sysvipc_fin
 
 	total = 0;
 	for (id = 0; id < pos && total < ids->in_use; id++) {
-		ipc = idr_find(&ids->ipcs_idr, id);
+		ipc = ridr_find(&ids->ipcs_ridr, id);
 		if (ipc != NULL)
 			total++;
 	}
@@ -924,7 +915,7 @@ static struct kern_ipc_perm *sysvipc_fin
 		return NULL;
 
 	for ( ; pos < IPCMNI; pos++) {
-		ipc = idr_find(&ids->ipcs_idr, pos);
+		ipc = ridr_find(&ids->ipcs_ridr, pos);
 		if (ipc != NULL) {
 			*new_pos = pos + 1;
 			ipc_lock_by_ptr(ipc);
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

