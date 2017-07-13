From: akpm@linux-foundation.org
Subject: [merged] ipc-shm-do-not-use-ipc_rcu_free.patch removed
 from -mm tree
Date: Thu, 13 Jul 2017 13:41:25 -0700
Message-ID: <20170713204125.K9ppvzXU4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUl0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: do not use ipc_rcu_free()
has been removed from the -mm tree.  Its filename was
     ipc-shm-do-not-use-ipc_rcu_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ipc/shm: do not use ipc_rcu_free()

Avoid using ipc_rcu_free, since it just re-finds the original structure
pointer.  For the pre-list-init failure path, there is no RCU needed,
since it was just allocated.  It can be directly freed.

Link: http://lkml.kernel.org/r/20170525185107.12869-7-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN ipc/shm.c~ipc-shm-do-not-use-ipc_rcu_free ipc/shm.c
--- a/ipc/shm.c~ipc-shm-do-not-use-ipc_rcu_free
+++ a/ipc/shm.c
@@ -172,6 +172,11 @@ static inline void shm_lock_by_ptr(struc
 	ipc_lock_object(&ipcp->shm_perm);
 }
 
+static void __shm_free(struct shmid_kernel *shp)
+{
+	kvfree(shp);
+}
+
 static void shm_rcu_free(struct rcu_head *head)
 {
 	struct kern_ipc_perm *ptr = container_of(head, struct kern_ipc_perm,
@@ -179,7 +184,7 @@ static void shm_rcu_free(struct rcu_head
 	struct shmid_kernel *shp = container_of(ptr, struct shmid_kernel,
 							shm_perm);
 	security_shm_free(shp);
-	ipc_rcu_free(head);
+	__shm_free(shp);
 }
 
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
@@ -557,7 +562,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_perm.security = NULL;
 	error = security_shm_alloc(shp);
 	if (error) {
-		ipc_rcu_putref(&shp->shm_perm, ipc_rcu_free);
+		__shm_free(shp);
 		return error;
 	}
 
_

Patches currently in -mm which might be from keescook@chromium.org are


