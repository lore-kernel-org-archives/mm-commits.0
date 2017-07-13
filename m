From: akpm@linux-foundation.org
Subject: [merged] ipc-shm-remove-special-shm_alloc-free.patch
 removed from -mm tree
Date: Thu, 13 Jul 2017 13:41:47 -0700
Message-ID: <20170713204147.4kRe5L8P9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59342 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUls (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: remove special shm_alloc/free
has been removed from the -mm tree.  Its filename was
     ipc-shm-remove-special-shm_alloc-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ipc/shm: remove special shm_alloc/free

There is nothing special about the shm_alloc/free routines any more, so
remove them to make code more readable.

[manfred@colorfullife.com: Rediff, to continue to keep rcu for free calls after a successful security_shm_alloc()]
Link: http://lkml.kernel.org/r/20170525185107.12869-18-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff -puN ipc/shm.c~ipc-shm-remove-special-shm_alloc-free ipc/shm.c
--- a/ipc/shm.c~ipc-shm-remove-special-shm_alloc-free
+++ a/ipc/shm.c
@@ -172,11 +172,6 @@ static inline void shm_lock_by_ptr(struc
 	ipc_lock_object(&ipcp->shm_perm);
 }
 
-static void __shm_free(struct shmid_kernel *shp)
-{
-	kvfree(shp);
-}
-
 static void shm_rcu_free(struct rcu_head *head)
 {
 	struct kern_ipc_perm *ptr = container_of(head, struct kern_ipc_perm,
@@ -184,7 +179,7 @@ static void shm_rcu_free(struct rcu_head
 	struct shmid_kernel *shp = container_of(ptr, struct shmid_kernel,
 							shm_perm);
 	security_shm_free(shp);
-	__shm_free(shp);
+	kvfree(shp);
 }
 
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
@@ -518,17 +513,6 @@ static const struct vm_operations_struct
 #endif
 };
 
-static struct shmid_kernel *shm_alloc(void)
-{
-	struct shmid_kernel *shp;
-
-	shp = kvmalloc(sizeof(*shp), GFP_KERNEL);
-	if (unlikely(!shp))
-		return NULL;
-
-	return shp;
-}
-
 /**
  * newseg - Create a new shared memory segment
  * @ns: namespace
@@ -558,8 +542,8 @@ static int newseg(struct ipc_namespace *
 			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
 
-	shp = shm_alloc();
-	if (!shp)
+	shp = kvmalloc(sizeof(*shp), GFP_KERNEL);
+	if (unlikely(!shp))
 		return -ENOMEM;
 
 	shp->shm_perm.key = key;
@@ -569,7 +553,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_perm.security = NULL;
 	error = security_shm_alloc(shp);
 	if (error) {
-		__shm_free(shp);
+		kvfree(shp);
 		return error;
 	}
 
_

Patches currently in -mm which might be from keescook@chromium.org are


