From: akpm@linux-foundation.org
Subject: - storing-ipcs-into-idrs.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:41 -0700
Message-ID: <200710192253.l9JMrf0s024445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45281 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763772AbXJSXFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     Storing ipcs into IDRs
has been removed from the -mm tree.  Its filename was
     storing-ipcs-into-idrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Storing ipcs into IDRs
From: Nadia Derbey <Nadia.Derbey@bull.net>

This patch converts casts of struct kern_ipc_perm to
   . struct msg_queue
   . struct sem_array
   . struct shmid_kernel
into the equivalent container_of() macro. It improves code maintenance
because the code need not change if kern_ipc_perm is no longer at the
beginning of the containing struct.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |   14 ++++++++++----
 ipc/sem.c  |   23 +++++++++++++++++------
 ipc/shm.c  |   23 +++++++++++++++++------
 ipc/util.h |    4 ++--
 4 files changed, 46 insertions(+), 18 deletions(-)

diff -puN ipc/msg.c~storing-ipcs-into-idrs ipc/msg.c
--- a/ipc/msg.c~storing-ipcs-into-idrs
+++ a/ipc/msg.c
@@ -138,13 +138,17 @@ void __init msg_init(void)
 
 static inline struct msg_queue *msg_lock(struct ipc_namespace *ns, int id)
 {
-	return (struct msg_queue *) ipc_lock(&msg_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock(&msg_ids(ns), id);
+
+	return container_of(ipcp, struct msg_queue, q_perm);
 }
 
 static inline struct msg_queue *msg_lock_check(struct ipc_namespace *ns,
 						int id)
 {
-	return (struct msg_queue *) ipc_lock_check(&msg_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock_check(&msg_ids(ns), id);
+
+	return container_of(ipcp, struct msg_queue, q_perm);
 }
 
 static inline void msg_rmid(struct ipc_namespace *ns, struct msg_queue *s)
@@ -274,9 +278,11 @@ static void freeque(struct ipc_namespace
 	ipc_rcu_putref(msq);
 }
 
-static inline int msg_security(void *msq, int msgflg)
+static inline int msg_security(struct kern_ipc_perm *ipcp, int msgflg)
 {
-	return security_msg_queue_associate((struct msg_queue *) msq, msgflg);
+	struct msg_queue *msq = container_of(ipcp, struct msg_queue, q_perm);
+
+	return security_msg_queue_associate(msq, msgflg);
 }
 
 asmlinkage long sys_msgget(key_t key, int msgflg)
diff -puN ipc/sem.c~storing-ipcs-into-idrs ipc/sem.c
--- a/ipc/sem.c~storing-ipcs-into-idrs
+++ a/ipc/sem.c
@@ -176,13 +176,17 @@ void __init sem_init (void)
 
 static inline struct sem_array *sem_lock(struct ipc_namespace *ns, int id)
 {
-	return (struct sem_array *) ipc_lock(&sem_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock(&sem_ids(ns), id);
+
+	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
 static inline struct sem_array *sem_lock_check(struct ipc_namespace *ns,
 						int id)
 {
-	return (struct sem_array *) ipc_lock_check(&sem_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock_check(&sem_ids(ns), id);
+
+	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
@@ -277,14 +281,21 @@ static int newary(struct ipc_namespace *
 }
 
 
-static inline int sem_security(void *sma, int semflg)
+static inline int sem_security(struct kern_ipc_perm *ipcp, int semflg)
 {
-	return security_sem_associate((struct sem_array *) sma, semflg);
+	struct sem_array *sma;
+
+	sma = container_of(ipcp, struct sem_array, sem_perm);
+	return security_sem_associate(sma, semflg);
 }
 
-static inline int sem_more_checks(void *sma, struct ipc_params *params)
+static inline int sem_more_checks(struct kern_ipc_perm *ipcp,
+				struct ipc_params *params)
 {
-	if (params->u.nsems > ((struct sem_array *)sma)->sem_nsems)
+	struct sem_array *sma;
+
+	sma = container_of(ipcp, struct sem_array, sem_perm);
+	if (params->u.nsems > sma->sem_nsems)
 		return -EINVAL;
 
 	return 0;
diff -puN ipc/shm.c~storing-ipcs-into-idrs ipc/shm.c
--- a/ipc/shm.c~storing-ipcs-into-idrs
+++ a/ipc/shm.c
@@ -139,13 +139,17 @@ void __init shm_init (void)
 
 static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
 {
-	return (struct shmid_kernel *) ipc_lock(&shm_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock(&shm_ids(ns), id);
+
+	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
 static inline struct shmid_kernel *shm_lock_check(struct ipc_namespace *ns,
 						int id)
 {
-	return (struct shmid_kernel *) ipc_lock_check(&shm_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_lock_check(&shm_ids(ns), id);
+
+	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
@@ -424,14 +428,21 @@ no_file:
 	return error;
 }
 
-static inline int shm_security(void *shp, int shmflg)
+static inline int shm_security(struct kern_ipc_perm *ipcp, int shmflg)
 {
-	return security_shm_associate((struct shmid_kernel *) shp, shmflg);
+	struct shmid_kernel *shp;
+
+	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
+	return security_shm_associate(shp, shmflg);
 }
 
-static inline int shm_more_checks(void *shp, struct ipc_params *params)
+static inline int shm_more_checks(struct kern_ipc_perm *ipcp,
+				struct ipc_params *params)
 {
-	if (((struct shmid_kernel *)shp)->shm_segsz < params->u.size)
+	struct shmid_kernel *shp;
+
+	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
+	if (shp->shm_segsz < params->u.size)
 		return -EINVAL;
 
 	return 0;
diff -puN ipc/util.h~storing-ipcs-into-idrs ipc/util.h
--- a/ipc/util.h~storing-ipcs-into-idrs
+++ a/ipc/util.h
@@ -61,8 +61,8 @@ struct ipc_params {
  */
 struct ipc_ops {
 	int (*getnew) (struct ipc_namespace *, struct ipc_params *);
-	int (*associate) (void *, int);
-	int (*more_checks) (void *, struct ipc_params *);
+	int (*associate) (struct kern_ipc_perm *, int);
+	int (*more_checks) (struct kern_ipc_perm *, struct ipc_params *);
 };
 
 struct seq_file;
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
