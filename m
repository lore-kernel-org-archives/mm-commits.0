From: akpm@linux-foundation.org
Subject: [patch 48/96] ipc/shm: remove special shm_alloc/free
Date: Wed, 12 Jul 2017 14:35:25 -0700
Message-ID: <20170712213525.hoP9DmKob%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53648 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753252AbdGLVf0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:35:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
