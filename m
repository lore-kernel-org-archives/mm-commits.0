From: akpm@linux-foundation.org
Subject: [merged] ipc-shm-avoid-ipc_rcu_alloc.patch removed from
 -mm tree
Date: Thu, 13 Jul 2017 13:41:33 -0700
Message-ID: <20170713204133.AjiBYRBCe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59286 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUle (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: avoid ipc_rcu_alloc()
has been removed from the -mm tree.  Its filename was
     ipc-shm-avoid-ipc_rcu_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ipc/shm: avoid ipc_rcu_alloc()

Instead of using ipc_rcu_alloc() which only performs the refcount bump,
open code it.  This also allows for shmid_kernel structure layout to be
randomized in the future.

Link: http://lkml.kernel.org/r/20170525185107.12869-11-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN ipc/shm.c~ipc-shm-avoid-ipc_rcu_alloc ipc/shm.c
--- a/ipc/shm.c~ipc-shm-avoid-ipc_rcu_alloc
+++ a/ipc/shm.c
@@ -518,6 +518,19 @@ static const struct vm_operations_struct
 #endif
 };
 
+static struct shmid_kernel *shm_alloc(void)
+{
+	struct shmid_kernel *shp;
+
+	shp = kvmalloc(sizeof(*shp), GFP_KERNEL);
+	if (unlikely(!shp))
+		return NULL;
+
+	atomic_set(&shp->shm_perm.refcount, 1);
+
+	return shp;
+}
+
 /**
  * newseg - Create a new shared memory segment
  * @ns: namespace
@@ -548,10 +561,7 @@ static int newseg(struct ipc_namespace *
 			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
 
-	BUILD_BUG_ON(offsetof(struct shmid_kernel, shm_perm) != 0);
