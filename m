From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-remove-private-structures-from-public-header-file.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:28:03 -0800
Message-ID: <201111072028.pA7KS3QQ023535@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5525 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1KGU2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:28:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: remove private structures from public header file
has been removed from the -mm tree.  Its filename was
     ipc-semc-remove-private-structures-from-public-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: remove private structures from public header file

include/linux/sem.h contains several structures that are only used within
ipc/sem.c.

The patch moves them into ipc/sem.c - there is no need to expose the
structures to the whole kernel.

No functional changes, only whitespace cleanups and 80-char per line
fixes.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |   42 --------------------------------------
 ipc/sem.c           |   46 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 42 deletions(-)

diff -puN include/linux/sem.h~ipc-semc-remove-private-structures-from-public-header-file include/linux/sem.h
--- a/include/linux/sem.h~ipc-semc-remove-private-structures-from-public-header-file
+++ a/include/linux/sem.h
@@ -83,13 +83,6 @@ struct  seminfo {
 
 struct task_struct;
 
-/* One semaphore structure for each semaphore in the system. */
-struct sem {
-	int	semval;		/* current value */
-	int	sempid;		/* pid of last operation */
-	struct list_head sem_pending; /* pending single-sop operations */
-};
-
 /* One sem_array data structure for each set of semaphores in the system. */
 struct sem_array {
 	struct kern_ipc_perm	____cacheline_aligned_in_smp
@@ -103,41 +96,6 @@ struct sem_array {
 	int			complex_count;	/* pending complex operations */
 };
 
-/* One queue for each sleeping process in the system. */
-struct sem_queue {
-	struct list_head	simple_list; /* queue of pending operations */
-	struct list_head	list;	 /* queue of pending operations */
-	struct task_struct	*sleeper; /* this process */
-	struct sem_undo		*undo;	 /* undo structure */
-	int    			pid;	 /* process id of requesting process */
-	int    			status;	 /* completion status of operation */
-	struct sembuf		*sops;	 /* array of pending operations */
-	int			nsops;	 /* number of operations */
-	int			alter;   /* does the operation alter the array? */
-};
-
-/* Each task has a list of undo requests. They are executed automatically
- * when the process exits.
- */
-struct sem_undo {
-	struct list_head	list_proc;	/* per-process list: all undos from one process. */
-						/* rcu protected */
-	struct rcu_head		rcu;		/* rcu struct for sem_undo() */
-	struct sem_undo_list	*ulp;		/* sem_undo_list for the process */
-	struct list_head	list_id;	/* per semaphore array list: all undos for one array */
-	int			semid;		/* semaphore set identifier */
-	short *			semadj;		/* array of adjustments, one per semaphore */
-};
-
-/* sem_undo_list controls shared access to the list of sem_undo structures
- * that may be shared among all a CLONE_SYSVSEM task group.
- */ 
-struct sem_undo_list {
-	atomic_t		refcnt;
-	spinlock_t		lock;
-	struct list_head	list_proc;
-};
-
 struct sysv_sem {
 	struct sem_undo_list *undo_list;
 };
diff -puN ipc/sem.c~ipc-semc-remove-private-structures-from-public-header-file ipc/sem.c
--- a/ipc/sem.c~ipc-semc-remove-private-structures-from-public-header-file
+++ a/ipc/sem.c
@@ -90,6 +90,52 @@
 #include <asm/uaccess.h>
 #include "util.h"
 
+/* One semaphore structure for each semaphore in the system. */
+struct sem {
+	int	semval;		/* current value */
+	int	sempid;		/* pid of last operation */
+	struct list_head sem_pending; /* pending single-sop operations */
+};
+
+/* One queue for each sleeping process in the system. */
+struct sem_queue {
+	struct list_head	simple_list; /* queue of pending operations */
+	struct list_head	list;	 /* queue of pending operations */
+	struct task_struct	*sleeper; /* this process */
+	struct sem_undo		*undo;	 /* undo structure */
+	int			pid;	 /* process id of requesting process */
+	int			status;	 /* completion status of operation */
+	struct sembuf		*sops;	 /* array of pending operations */
+	int			nsops;	 /* number of operations */
+	int			alter;	 /* does *sops alter the array? */
+};
+
+/* Each task has a list of undo requests. They are executed automatically
+ * when the process exits.
+ */
+struct sem_undo {
+	struct list_head	list_proc;	/* per-process list: *
+						 * all undos from one process
+						 * rcu protected */
+	struct rcu_head		rcu;		/* rcu struct for sem_undo */
+	struct sem_undo_list	*ulp;		/* back ptr to sem_undo_list */
+	struct list_head	list_id;	/* per semaphore array list:
+						 * all undos for one array */
+	int			semid;		/* semaphore set identifier */
+	short			*semadj;	/* array of adjustments */
+						/* one per semaphore */
+};
+
+/* sem_undo_list controls shared access to the list of sem_undo structures
+ * that may be shared among all a CLONE_SYSVSEM task group.
+ */
+struct sem_undo_list {
+	atomic_t		refcnt;
+	spinlock_t		lock;
+	struct list_head	list_proc;
+};
+
+
 #define sem_ids(ns)	((ns)->ids[IPC_SEM_IDS])
 
 #define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
ipc-semc-alternatives-to-preempt_disable.patch
slab-leaks3-default-y.patch

