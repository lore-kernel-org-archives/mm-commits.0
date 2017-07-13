From: akpm@linux-foundation.org
Subject: [merged] ipc-drop-non-rcu-allocation.patch removed from
 -mm tree
Date: Thu, 13 Jul 2017 13:41:21 -0700
Message-ID: <20170713204121.SG8EMdXiH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59170 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753095AbdGMUlW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: drop non-RCU allocation
has been removed from the -mm tree.  Its filename was
     ipc-drop-non-rcu-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ipc: drop non-RCU allocation

The only users of ipc_alloc() were ipc_rcu_alloc() and the on-heap sem_io
fall-back memory.  Better to just open-code these to make things easier to
read.

[manfred@colorfullife.com: Rediff due to inclusion of memset() into ipc_rcu_alloc()]
Link: http://lkml.kernel.org/r/20170525185107.12869-5-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c  |    8 +++++---
 ipc/util.c |   25 +------------------------
 ipc/util.h |    6 ------
 3 files changed, 6 insertions(+), 33 deletions(-)

diff -puN ipc/sem.c~ipc-drop-non-rcu-allocation ipc/sem.c
--- a/ipc/sem.c~ipc-drop-non-rcu-allocation
+++ a/ipc/sem.c
@@ -1368,7 +1368,8 @@ static int semctl_main(struct ipc_namesp
 			}
 			sem_unlock(sma, -1);
 			rcu_read_unlock();
-			sem_io = ipc_alloc(sizeof(ushort)*nsems);
+			sem_io = kvmalloc_array(nsems, sizeof(ushort),
+						GFP_KERNEL);
 			if (sem_io == NULL) {
 				ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 				return -ENOMEM;
@@ -1402,7 +1403,8 @@ static int semctl_main(struct ipc_namesp
 		rcu_read_unlock();
 
 		if (nsems > SEMMSL_FAST) {
-			sem_io = ipc_alloc(sizeof(ushort)*nsems);
+			sem_io = kvmalloc_array(nsems, sizeof(ushort),
+						GFP_KERNEL);
 			if (sem_io == NULL) {
 				ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 				return -ENOMEM;
@@ -1480,7 +1482,7 @@ out_rcu_wakeup:
 	wake_up_q(&wake_q);
 out_free:
 	if (sem_io != fast_sem_io)
-		ipc_free(sem_io);
+		kvfree(sem_io);
 	return err;
 }
 
diff -puN ipc/util.c~ipc-drop-non-rcu-allocation ipc/util.c
--- a/ipc/util.c~ipc-drop-non-rcu-allocation
+++ a/ipc/util.c
@@ -395,29 +395,6 @@ void ipc_rmid(struct ipc_ids *ids, struc
 }
 
 /**
- * ipc_alloc -	allocate ipc space
- * @size: size desired
- *
- * Allocate memory from the appropriate pools and return a pointer to it.
- * NULL is returned if the allocation fails
- */
-void *ipc_alloc(int size)
-{
-	return kvmalloc(size, GFP_KERNEL);
-}
-
-/**
- * ipc_free - free ipc space
- * @ptr: pointer returned by ipc_alloc
- *
- * Free a block created with ipc_alloc().
- */
-void ipc_free(void *ptr)
-{
-	kvfree(ptr);
-}
-
-/**
  * ipc_rcu_alloc - allocate ipc space
  * @size: size desired
  *
@@ -429,7 +406,7 @@ struct kern_ipc_perm *ipc_rcu_alloc(int
 	/*
 	 * We prepend the allocation with the rcu struct
 	 */
-	struct kern_ipc_perm *out = ipc_alloc(size);
+	struct kern_ipc_perm *out = kvmalloc(size, GFP_KERNEL);
 	if (unlikely(!out))
 		return NULL;
 
diff -puN ipc/util.h~ipc-drop-non-rcu-allocation ipc/util.h
--- a/ipc/util.h~ipc-drop-non-rcu-allocation
+++ a/ipc/util.h
@@ -107,12 +107,6 @@ void ipc_rmid(struct ipc_ids *, struct k
 /* must be called with ipcp locked */
 int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flg);
 
-/* for rare, potentially huge allocations.
- * both function can sleep
- */
-void *ipc_alloc(int size);
-void ipc_free(void *ptr);
