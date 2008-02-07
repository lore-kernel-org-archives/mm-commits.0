From: akpm@linux-foundation.org
Subject: - ipc-fix-error-check-in-all-new-xxx_lock-and.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:00 -0800
Message-ID: <200802070020.m170Kf2t006176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934025AbYBGAVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:21:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     IPC: fix error check in all new xxx_lock() and xxx_exit_ns() functions
has been removed from the -mm tree.  Its filename was
     ipc-fix-error-check-in-all-new-xxx_lock-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IPC: fix error check in all new xxx_lock() and xxx_exit_ns() functions
From: Pierre Peiffer <pierre.peiffer@bull.net>

In the new implementation of the [sem|shm|msg]_lock[_check]() routines, we
use the return value of ipc_lock() in container_of() without any check. 
But ipc_lock may return a errcode.  The use of this errcode in
container_of() may alter this errcode, and we don't want this.

And in xxx_exit_ns, the pointer return by idr_find is of type 'struct
kern_ipc_per'...

Today, the code will work as is because the member used in these
container_of() is the first member of its container (offset == 0), the
errcode isn't changed then.  But in the general case, we can't count on
this assumption and this may lead later to a real bug if we don't correct
this.

Again, the proposed solution is simple and correct.  But, as pointed by
Nadia, with this solution, the same check will be done several times (in
all sub-callers...), what is not very funny/optimal...

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   17 ++++++++++++++---
 ipc/sem.c |   17 ++++++++++++++---
 ipc/shm.c |   20 +++++++++++++++++---
 3 files changed, 45 insertions(+), 9 deletions(-)

diff -puN ipc/msg.c~ipc-fix-error-check-in-all-new-xxx_lock-and ipc/msg.c
--- a/ipc/msg.c~ipc-fix-error-check-in-all-new-xxx_lock-and
+++ a/ipc/msg.c
@@ -105,6 +105,7 @@ int msg_init_ns(struct ipc_namespace *ns
 void msg_exit_ns(struct ipc_namespace *ns)
 {
 	struct msg_queue *msq;
+	struct kern_ipc_perm *perm;
 	int next_id;
 	int total, in_use;
 
@@ -113,10 +114,11 @@ void msg_exit_ns(struct ipc_namespace *n
 	in_use = msg_ids(ns).in_use;
 
 	for (total = 0, next_id = 0; total < in_use; next_id++) {
-		msq = idr_find(&msg_ids(ns).ipcs_idr, next_id);
-		if (msq == NULL)
+		perm = idr_find(&msg_ids(ns).ipcs_idr, next_id);
+		if (perm == NULL)
 			continue;
-		ipc_lock_by_ptr(&msq->q_perm);
+		ipc_lock_by_ptr(perm);
+		msq = container_of(perm, struct msg_queue, q_perm);
 		freeque(ns, msq);
 		total++;
 	}
@@ -144,6 +146,9 @@ static inline struct msg_queue *msg_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check_down(&msg_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct msg_queue *)ipcp;
+
 	return container_of(ipcp, struct msg_queue, q_perm);
 }
 
@@ -155,6 +160,9 @@ static inline struct msg_queue *msg_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&msg_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct msg_queue *)ipcp;
+
 	return container_of(ipcp, struct msg_queue, q_perm);
 }
 
@@ -163,6 +171,9 @@ static inline struct msg_queue *msg_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check(&msg_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct msg_queue *)ipcp;
+
 	return container_of(ipcp, struct msg_queue, q_perm);
 }
 
diff -puN ipc/sem.c~ipc-fix-error-check-in-all-new-xxx_lock-and ipc/sem.c
--- a/ipc/sem.c~ipc-fix-error-check-in-all-new-xxx_lock-and
+++ a/ipc/sem.c
@@ -143,6 +143,7 @@ int sem_init_ns(struct ipc_namespace *ns
 void sem_exit_ns(struct ipc_namespace *ns)
 {
 	struct sem_array *sma;
+	struct kern_ipc_perm *perm;
 	int next_id;
 	int total, in_use;
 
@@ -151,10 +152,11 @@ void sem_exit_ns(struct ipc_namespace *n
 	in_use = sem_ids(ns).in_use;
 
 	for (total = 0, next_id = 0; total < in_use; next_id++) {
-		sma = idr_find(&sem_ids(ns).ipcs_idr, next_id);
-		if (sma == NULL)
+		perm = idr_find(&sem_ids(ns).ipcs_idr, next_id);
+		if (perm == NULL)
 			continue;
-		ipc_lock_by_ptr(&sma->sem_perm);
+		ipc_lock_by_ptr(perm);
+		sma = container_of(perm, struct sem_array, sem_perm);
 		freeary(ns, sma);
 		total++;
 	}
@@ -181,6 +183,9 @@ static inline struct sem_array *sem_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check_down(&sem_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct sem_array *)ipcp;
+
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
@@ -192,6 +197,9 @@ static inline struct sem_array *sem_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&sem_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct sem_array *)ipcp;
+
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
@@ -200,6 +208,9 @@ static inline struct sem_array *sem_lock
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check(&sem_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct sem_array *)ipcp;
+
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
diff -puN ipc/shm.c~ipc-fix-error-check-in-all-new-xxx_lock-and ipc/shm.c
--- a/ipc/shm.c~ipc-fix-error-check-in-all-new-xxx_lock-and
+++ a/ipc/shm.c
@@ -111,6 +111,7 @@ int shm_init_ns(struct ipc_namespace *ns
 void shm_exit_ns(struct ipc_namespace *ns)
 {
 	struct shmid_kernel *shp;
+	struct kern_ipc_perm *perm;
 	int next_id;
 	int total, in_use;
 
@@ -119,10 +120,11 @@ void shm_exit_ns(struct ipc_namespace *n
 	in_use = shm_ids(ns).in_use;
 
 	for (total = 0, next_id = 0; total < in_use; next_id++) {
-		shp = idr_find(&shm_ids(ns).ipcs_idr, next_id);
-		if (shp == NULL)
+		perm = idr_find(&shm_ids(ns).ipcs_idr, next_id);
+		if (perm == NULL)
 			continue;
-		ipc_lock_by_ptr(&shp->shm_perm);
+		ipc_lock_by_ptr(perm);
+		shp = container_of(perm, struct shmid_kernel, shm_perm);
 		do_shm_rmid(ns, shp);
 		total++;
 	}
@@ -149,6 +151,9 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_down(&shm_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct shmid_kernel *)ipcp;
+
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
@@ -158,6 +163,9 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check_down(&shm_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct shmid_kernel *)ipcp;
+
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
@@ -169,6 +177,9 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&shm_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct shmid_kernel *)ipcp;
+
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
@@ -177,6 +188,9 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock_check(&shm_ids(ns), id);
 
+	if (IS_ERR(ipcp))
+		return (struct shmid_kernel *)ipcp;
+
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

origin.patch
ipc-semaphores-consolidate-sem_stat-and.patch
ipc-make-struct-ipc_ids-static-in-ipc_namespace.patch
ipc-consolidate-sem_exit_ns-msg_exit_ns-and-shm_exit_ns.patch
