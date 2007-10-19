From: akpm@linux-foundation.org
Subject: - ipc-remove-the-ipc_get-routine.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:37 -0700
Message-ID: <200710192253.l9JMrbPe024439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765217AbXJSXFr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     ipc: remove the ipc_get() routine
has been removed from the -mm tree.  Its filename was
     ipc-remove-the-ipc_get-routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipc: remove the ipc_get() routine
From: Nadia Derbey <Nadia.Derbey@bull.net>

This is a trivial patch that removes the ipc_get() routine: it is replaced
by a call to idr_find().

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c  |   16 +++++++++++++---
 ipc/util.c |   19 -------------------
 ipc/util.h |    1 -
 3 files changed, 13 insertions(+), 23 deletions(-)

diff -puN ipc/shm.c~ipc-remove-the-ipc_get-routine ipc/shm.c
--- a/ipc/shm.c~ipc-remove-the-ipc_get-routine
+++ a/ipc/shm.c
@@ -63,8 +63,6 @@ static struct ipc_ids init_shm_ids;
 	((struct shmid_kernel*)ipc_lock(&shm_ids(ns),id))
 #define shm_unlock(shp)			\
 	ipc_unlock(&(shp)->shm_perm)
-#define shm_get(ns, id)			\
-	((struct shmid_kernel*)ipc_get(&shm_ids(ns),id))
 #define shm_buildid(ns, id, seq)	\
 	ipc_buildid(&shm_ids(ns), id, seq)
 
@@ -563,7 +561,19 @@ static void shm_get_stat(struct ipc_name
 		struct shmid_kernel *shp;
 		struct inode *inode;
 
-		shp = shm_get(ns, next_id);
+		/*
+		 * idr_find() is called via shm_get(), so with shm_ids.mutex
+		 * locked. Since ipc_addid() is also called with
+		 * shm_ids.mutex down, there is no need to add read barriers
+		 * here to gurantee the writes in ipc_addid() are seen in
+		 * order here (for Alpha).
+		 * However idr_find() itself does not necessary require
+		 * ipc_ids.mutex down. So if idr_find() is used by other
+		 * places without ipc_ids.mutex down, then it needs read
+		 * read memory barriers as ipc_lock() does.
+		 */
+
+		shp = idr_find(&shm_ids(ns).ipcs_idr, next_id);
 		if (shp == NULL)
 			continue;
 
diff -puN ipc/util.c~ipc-remove-the-ipc_get-routine ipc/util.c
--- a/ipc/util.c~ipc-remove-the-ipc_get-routine
+++ a/ipc/util.c
@@ -669,25 +669,6 @@ void ipc64_perm_to_ipc_perm (struct ipc6
 	out->seq	= in->seq;
 }
 
-/*
- * So far only shm_get_stat() calls ipc_get() via shm_get(), so ipc_get()
- * is called with shm_ids.mutex locked.  Since grow_ary() is also called with
- * shm_ids.mutex down(for Shared Memory), there is no need to add read
- * barriers here to gurantee the writes in grow_ary() are seen in order 
- * here (for Alpha).
- *
- * However ipc_get() itself does not necessary require ipc_ids.mutex down. So
- * if in the future ipc_get() is used by other places without ipc_ids.mutex
- * down, then ipc_get() needs read memery barriers as ipc_lock() does.
- */
-struct kern_ipc_perm *ipc_get(struct ipc_ids *ids, int id)
-{
-	struct kern_ipc_perm *out;
-	int lid = id % SEQ_MULTIPLIER;
-	out = idr_find(&ids->ipcs_idr, lid);
-	return out;
-}
-
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 {
 	struct kern_ipc_perm *out;
diff -puN ipc/util.h~ipc-remove-the-ipc_get-routine ipc/util.h
--- a/ipc/util.h~ipc-remove-the-ipc_get-routine
+++ a/ipc/util.h
@@ -103,7 +103,6 @@ void* ipc_rcu_alloc(int size);
 void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
-struct kern_ipc_perm* ipc_get(struct ipc_ids* ids, int id);
 struct kern_ipc_perm* ipc_lock(struct ipc_ids* ids, int id);
 void ipc_lock_by_ptr(struct kern_ipc_perm *ipcp);
 void ipc_unlock(struct kern_ipc_perm* perm);
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
