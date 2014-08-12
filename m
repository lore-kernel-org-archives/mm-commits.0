From: akpm@linux-foundation.org
Subject: [merged]
 shm-make-exit_shm-work-proportional-to-task-activity.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:30 -0700
Message-ID: <53ea6dea.siuZ6MGVsagGFjlx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:53343 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbaHLTlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:31 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so1309331ykq.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: millerjo@us.ibm.com, anton@samba.org, davidlohr@hp.com, manfred@colorfullife.com, miltonm@bga.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shm: make exit_shm work proportional to task activity
has been removed from the -mm tree.  Its filename was
     shm-make-exit_shm-work-proportional-to-task-activity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jack Miller <millerjo@us.ibm.com>
Subject: shm: make exit_shm work proportional to task activity

This is small set of patches our team has had kicking around for a few
versions internally that fixes tasks getting hung on shm_exit when there
are many threads hammering it at once.

Anton wrote a simple test to cause the issue:

http://ozlabs.org/~anton/junkcode/bust_shm_exit.c

Before applying this patchset, this test code will cause either hanging
tracebacks or pthread out of memory errors.

After this patchset, it will still produce output like:

root@somehost:~# ./bust_shm_exit 1024 160
...
INFO: rcu_sched detected stalls on CPUs/tasks: {} (detected by 116, t=2111
jiffies, g=241, c=240, q=7113)
INFO: Stall ended before state dump start
...
But the task will continue to run along happily, so we consider this an
improvement over hanging, even if it's a bit noisy.



This patch (of 3):

exit_shm obtains the ipc_ns shm rwsem for write and holds it while it
walks every shared memory segment in the namespace.  Thus the amount of
work is related to the number of shm segments in the namespace not the
number of segments that might need to be cleaned.

In addition, this occurs after the task has been notified the thread has
exited, so the number of tasks waiting for the ns shm rwsem can grow
without bound until memory is exausted.

Add a list to the task struct of all shmids allocated by this task.  Init
the list head in copy_process.  Use the ns->rwsem for locking.  Add
segments after id is added, remove before removing from id.

On unshare of NEW_IPCNS orphan any ids as if the task had exited, similar
to handling of semaphore undo.

I chose a define for the init sequence since its a simple list init,
otherwise it would require a function call to avoid include loops between
the semaphore code and the task struct.  Converting the list_del to
list_del_init for the unshare cases would remove the exit followed by
init, but I left it blow up if not inited.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Jack Miller <millerjo@us.ibm.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 ++
 include/linux/shm.h   |   16 +++++++++++++++-
 ipc/shm.c             |   22 +++++++++++-----------
 kernel/fork.c         |    6 ++++++
 4 files changed, 34 insertions(+), 12 deletions(-)

diff -puN include/linux/sched.h~shm-make-exit_shm-work-proportional-to-task-activity include/linux/sched.h
--- a/include/linux/sched.h~shm-make-exit_shm-work-proportional-to-task-activity
+++ a/include/linux/sched.h
@@ -33,6 +33,7 @@ struct sched_param {
 
 #include <linux/smp.h>
 #include <linux/sem.h>
+#include <linux/shm.h>
 #include <linux/signal.h>
 #include <linux/compiler.h>
 #include <linux/completion.h>
@@ -1385,6 +1386,7 @@ struct task_struct {
 #ifdef CONFIG_SYSVIPC
 /* ipc stuff */
 	struct sysv_sem sysvsem;
+	struct sysv_shm sysvshm;
 #endif
 #ifdef CONFIG_DETECT_HUNG_TASK
 /* hung task detection */
diff -puN include/linux/shm.h~shm-make-exit_shm-work-proportional-to-task-activity include/linux/shm.h
--- a/include/linux/shm.h~shm-make-exit_shm-work-proportional-to-task-activity
+++ a/include/linux/shm.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_SHM_H_
 #define _LINUX_SHM_H_
 
+#include <linux/list.h>
 #include <asm/page.h>
 #include <uapi/linux/shm.h>
 #include <asm/shmparam.h>
@@ -20,6 +21,7 @@ struct shmid_kernel /* private to the ke
 
 	/* The task created the shm object.  NULL if the task is dead. */
 	struct task_struct	*shm_creator;
+	struct list_head	shm_clist;	/* list by creator */
 };
 
 /* shm_mode upper byte flags */
@@ -44,11 +46,20 @@ struct shmid_kernel /* private to the ke
 #define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)
 
 #ifdef CONFIG_SYSVIPC
+struct sysv_shm {
+	struct list_head shm_clist;
+};
+
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
 	      unsigned long shmlba);
 extern int is_file_shm_hugepages(struct file *file);
-extern void exit_shm(struct task_struct *task);
+void exit_shm(struct task_struct *task);
+#define shm_init_task(task) INIT_LIST_HEAD(&(task)->sysvshm.shm_clist)
 #else
+struct sysv_shm {
+	/* empty */
+};
+
 static inline long do_shmat(int shmid, char __user *shmaddr,
 			    int shmflg, unsigned long *addr,
 			    unsigned long shmlba)
@@ -62,6 +73,9 @@ static inline int is_file_shm_hugepages(
 static inline void exit_shm(struct task_struct *task)
 {
 }
+static inline void shm_init_task(struct task_struct *task)
+{
+}
 #endif
 
 #endif /* _LINUX_SHM_H_ */
diff -puN ipc/shm.c~shm-make-exit_shm-work-proportional-to-task-activity ipc/shm.c
--- a/ipc/shm.c~shm-make-exit_shm-work-proportional-to-task-activity
+++ a/ipc/shm.c
@@ -178,6 +178,7 @@ static void shm_rcu_free(struct rcu_head
 
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
 {
+	list_del(&s->shm_clist);
 	ipc_rmid(&shm_ids(ns), &s->shm_perm);
 }
 
@@ -268,14 +269,10 @@ static void shm_close(struct vm_area_str
 }
 
 /* Called with ns->shm_ids(ns).rwsem locked */
-static int shm_try_destroy_current(int id, void *p, void *data)
+static void shm_mark_orphan(struct shmid_kernel *shp, struct ipc_namespace *ns)
 {
-	struct ipc_namespace *ns = data;
-	struct kern_ipc_perm *ipcp = p;
-	struct shmid_kernel *shp = container_of(ipcp, struct shmid_kernel, shm_perm);
-
-	if (shp->shm_creator != current)
-		return 0;
+	if (WARN_ON(shp->shm_creator != current)) /* Remove me when it works */
+		return;
 
 	/*
 	 * Mark it as orphaned to destroy the segment when
@@ -289,13 +286,12 @@ static int shm_try_destroy_current(int i
 	 * is not set, it shouldn't be deleted here.
 	 */
 	if (!ns->shm_rmid_forced)
-		return 0;
+		return;
 
 	if (shm_may_destroy(ns, shp)) {
 		shm_lock_by_ptr(shp);
 		shm_destroy(ns, shp);
 	}
-	return 0;
 }
 
 /* Called with ns->shm_ids(ns).rwsem locked */
@@ -333,14 +329,17 @@ void shm_destroy_orphaned(struct ipc_nam
 void exit_shm(struct task_struct *task)
 {
 	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
+	struct shmid_kernel *shp, *n;
 
 	if (shm_ids(ns).in_use == 0)
 		return;
 
 	/* Destroy all already created segments, but not mapped yet */
 	down_write(&shm_ids(ns).rwsem);
-	if (shm_ids(ns).in_use)
-		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
+	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist)
+		shm_mark_orphan(shp, ns);
+	/* remove the list head from any segments still attached */
+	list_del(&task->sysvshm.shm_clist);
 	up_write(&shm_ids(ns).rwsem);
 }
 
@@ -561,6 +560,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_nattch = 0;
 	shp->shm_file = file;
 	shp->shm_creator = current;
+	list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
 
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
diff -puN kernel/fork.c~shm-make-exit_shm-work-proportional-to-task-activity kernel/fork.c
--- a/kernel/fork.c~shm-make-exit_shm-work-proportional-to-task-activity
+++ a/kernel/fork.c
@@ -1362,6 +1362,7 @@ static struct task_struct *copy_process(
 	if (retval)
 		goto bad_fork_cleanup_policy;
 	/* copy all the process information */
+	shm_init_task(p);
 	retval = copy_semundo(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_audit;
@@ -1913,6 +1914,11 @@ SYSCALL_DEFINE1(unshare, unsigned long,
 			 */
 			exit_sem(current);
 		}
+		if (unshare_flags & CLONE_NEWIPC) {
+			/* Orphan segments in old ns (see sem above). */
+			exit_shm(current);
+			shm_init_task(current);
+		}
 
 		if (new_nsproxy)
 			switch_task_namespaces(current, new_nsproxy);
_

Patches currently in -mm which might be from millerjo@us.ibm.com are

origin.patch

