From: akpm@linux-foundation.org
Subject: - make-access-to-tasks-nsproxy-lighter.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:50:59 -0700
Message-ID: <200710192250.l9JMoxXr024140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40591 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966979AbXJSXHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, clg@fr.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Make access to task's nsproxy lighter
has been removed from the -mm tree.  Its filename was
     make-access-to-tasks-nsproxy-lighter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make access to task's nsproxy lighter
From: Pavel Emelyanov <xemul@openvz.org>

When someone wants to deal with some other taks's namespaces it has to lock
the task and then to get the desired namespace if the one exists.  This is
slow on read-only paths and may be impossible in some cases.

E.g.  Oleg recently noticed a race between unshare() and the (sent for
review in cgroups) pid namespaces - when the task notifies the parent it
has to know the parent's namespace, but taking the task_lock() is
impossible there - the code is under write locked tasklist lock.

On the other hand switching the namespace on task (daemonize) and releasing
the namespace (after the last task exit) is rather rare operation and we
can sacrifice its speed to solve the issues above.

The access to other task namespaces is proposed to be performed
like this:

     rcu_read_lock();
     nsproxy = task_nsproxy(tsk);
     if (nsproxy != NULL) {
             / *
               * work with the namespaces here
               * e.g. get the reference on one of them
               * /
     } / *
         * NULL task_nsproxy() means that this task is
         * almost dead (zombie)
         * /
     rcu_read_unlock();

This patch has passed the review by Eric and Oleg :) and,
of course, tested.

[clg@fr.ibm.com: fix unshare()]
[ebiederm@xmission.com: Update get_net_ns_by_pid]
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |   27 +++++++++++++++--------
 include/linux/nsproxy.h |   43 ++++++++++++++++++++++++++++++--------
 kernel/exit.c           |    7 +++---
 kernel/fork.c           |   11 ++++-----
 kernel/nsproxy.c        |   40 +++++++++++++++++++++++------------
 net/core/rtnetlink.c    |    8 +++----
 6 files changed, 91 insertions(+), 45 deletions(-)

diff -puN fs/proc/base.c~make-access-to-tasks-nsproxy-lighter fs/proc/base.c
--- a/fs/proc/base.c~make-access-to-tasks-nsproxy-lighter
+++ a/fs/proc/base.c
@@ -350,18 +350,21 @@ struct proc_mounts {
 static int mounts_open(struct inode *inode, struct file *file)
 {
 	struct task_struct *task = get_proc_task(inode);
+	struct nsproxy *nsp;
 	struct mnt_namespace *ns = NULL;
 	struct proc_mounts *p;
 	int ret = -EINVAL;
 
 	if (task) {
-		task_lock(task);
-		if (task->nsproxy) {
-			ns = task->nsproxy->mnt_ns;
+		rcu_read_lock();
+		nsp = task_nsproxy(task);
+		if (nsp) {
+			ns = nsp->mnt_ns;
 			if (ns)
 				get_mnt_ns(ns);
 		}
-		task_unlock(task);
+		rcu_read_unlock();
+
 		put_task_struct(task);
 	}
 
@@ -424,16 +427,20 @@ static int mountstats_open(struct inode 
 
 	if (!ret) {
 		struct seq_file *m = file->private_data;
+		struct nsproxy *nsp;
 		struct mnt_namespace *mnt_ns = NULL;
 		struct task_struct *task = get_proc_task(inode);
 
 		if (task) {
-			task_lock(task);
-			if (task->nsproxy)
-				mnt_ns = task->nsproxy->mnt_ns;
-			if (mnt_ns)
-				get_mnt_ns(mnt_ns);
-			task_unlock(task);
+			rcu_read_lock();
+			nsp = task_nsproxy(task);
+			if (nsp) {
+				mnt_ns = nsp->mnt_ns;
+				if (mnt_ns)
+					get_mnt_ns(mnt_ns);
+			}
+			rcu_read_unlock();
+
 			put_task_struct(task);
 		}
 
diff -puN include/linux/nsproxy.h~make-access-to-tasks-nsproxy-lighter include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~make-access-to-tasks-nsproxy-lighter
+++ a/include/linux/nsproxy.h
@@ -32,8 +32,39 @@ struct nsproxy {
 };
 extern struct nsproxy init_nsproxy;
 
+/*
+ * the namespaces access rules are:
+ *
+ *  1. only current task is allowed to change tsk->nsproxy pointer or
+ *     any pointer on the nsproxy itself
+ *
+ *  2. when accessing (i.e. reading) current task's namespaces - no
+ *     precautions should be taken - just dereference the pointers
+ *
+ *  3. the access to other task namespaces is performed like this
+ *     rcu_read_lock();
+ *     nsproxy = task_nsproxy(tsk);
+ *     if (nsproxy != NULL) {
+ *             / *
+ *               * work with the namespaces here
+ *               * e.g. get the reference on one of them
+ *               * /
+ *     } / *
+ *         * NULL task_nsproxy() means that this task is
+ *         * almost dead (zombie)
+ *         * /
+ *     rcu_read_unlock();
+ *
+ */
+
+static inline struct nsproxy *task_nsproxy(struct task_struct *tsk)
+{
+	return rcu_dereference(tsk->nsproxy);
+}
+
 int copy_namespaces(unsigned long flags, struct task_struct *tsk);
-void get_task_namespaces(struct task_struct *tsk);
+void exit_task_namespaces(struct task_struct *tsk);
+void switch_task_namespaces(struct task_struct *tsk, struct nsproxy *new);
 void free_nsproxy(struct nsproxy *ns);
 int unshare_nsproxy_namespaces(unsigned long, struct nsproxy **,
 	struct fs_struct *);
@@ -45,15 +76,9 @@ static inline void put_nsproxy(struct ns
 	}
 }
 
-static inline void exit_task_namespaces(struct task_struct *p)
+static inline void get_nsproxy(struct nsproxy *ns)
 {
-	struct nsproxy *ns = p->nsproxy;
-	if (ns) {
-		task_lock(p);
-		p->nsproxy = NULL;
-		task_unlock(p);
-		put_nsproxy(ns);
-	}
+	atomic_inc(&ns->count);
 }
 
 #ifdef CONFIG_CGROUP_NS
diff -puN kernel/exit.c~make-access-to-tasks-nsproxy-lighter kernel/exit.c
--- a/kernel/exit.c~make-access-to-tasks-nsproxy-lighter
+++ a/kernel/exit.c
@@ -400,9 +400,10 @@ void daemonize(const char *name, ...)
 	current->fs = fs;
 	atomic_inc(&fs->count);
 
-	exit_task_namespaces(current);
-	current->nsproxy = init_task.nsproxy;
-	get_task_namespaces(current);
+	if (current->nsproxy != init_task.nsproxy) {
+		get_nsproxy(init_task.nsproxy);
+		switch_task_namespaces(current, init_task.nsproxy);
+	}
 
  	exit_files(current);
 	current->files = init_task.files;
diff -puN kernel/fork.c~make-access-to-tasks-nsproxy-lighter kernel/fork.c
--- a/kernel/fork.c~make-access-to-tasks-nsproxy-lighter
+++ a/kernel/fork.c
@@ -1632,7 +1632,7 @@ asmlinkage long sys_unshare(unsigned lon
 	struct mm_struct *mm, *new_mm = NULL, *active_mm = NULL;
 	struct files_struct *fd, *new_fd = NULL;
 	struct sem_undo_list *new_ulist = NULL;
-	struct nsproxy *new_nsproxy = NULL, *old_nsproxy = NULL;
+	struct nsproxy *new_nsproxy = NULL;
 
 	check_unshare_flags(&unshare_flags);
 
@@ -1662,14 +1662,13 @@ asmlinkage long sys_unshare(unsigned lon
 
 	if (new_fs ||  new_mm || new_fd || new_ulist || new_nsproxy) {
 
-		task_lock(current);
-
 		if (new_nsproxy) {
-			old_nsproxy = current->nsproxy;
-			current->nsproxy = new_nsproxy;
-			new_nsproxy = old_nsproxy;
+			switch_task_namespaces(current, new_nsproxy);
+			new_nsproxy = NULL;
 		}
 
+		task_lock(current);
+
 		if (new_fs) {
 			fs = current->fs;
 			current->fs = new_fs;
diff -puN kernel/nsproxy.c~make-access-to-tasks-nsproxy-lighter kernel/nsproxy.c
--- a/kernel/nsproxy.c~make-access-to-tasks-nsproxy-lighter
+++ a/kernel/nsproxy.c
@@ -26,19 +26,6 @@ static struct kmem_cache *nsproxy_cachep
 
 struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
 
-static inline void get_nsproxy(struct nsproxy *ns)
-{
-	atomic_inc(&ns->count);
-}
-
-void get_task_namespaces(struct task_struct *tsk)
-{
-	struct nsproxy *ns = tsk->nsproxy;
-	if (ns) {
-		get_nsproxy(ns);
-	}
-}
-
 /*
  * creates a copy of "orig" with refcount 1.
  */
@@ -216,6 +203,33 @@ out:
 	return err;
 }
 
+void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
+{
+	struct nsproxy *ns;
+
+	might_sleep();
+
+	ns = p->nsproxy;
+
+	rcu_assign_pointer(p->nsproxy, new);
+
+	if (ns && atomic_dec_and_test(&ns->count)) {
+		/*
+		 * wait for others to get what they want from this nsproxy.
+		 *
+		 * cannot release this nsproxy via the call_rcu() since
+		 * put_mnt_ns() will want to sleep
+		 */
+		synchronize_rcu();
+		free_nsproxy(ns);
+	}
+}
+
+void exit_task_namespaces(struct task_struct *p)
+{
+	switch_task_namespaces(p, NULL);
+}
+
 static int __init nsproxy_cache_init(void)
 {
 	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
diff -puN net/core/rtnetlink.c~make-access-to-tasks-nsproxy-lighter net/core/rtnetlink.c
--- a/net/core/rtnetlink.c~make-access-to-tasks-nsproxy-lighter
+++ a/net/core/rtnetlink.c
@@ -744,10 +744,10 @@ static struct net *get_net_ns_by_pid(pid
 	rcu_read_lock();
 	tsk = find_task_by_pid(pid);
 	if (tsk) {
-		task_lock(tsk);
-		if (tsk->nsproxy)
-			net = get_net(tsk->nsproxy->net_ns);
-		task_unlock(tsk);
+		struct nsproxy *nsproxy;
+		nsproxy = task_nsproxy(tsk);
+		if (nsproxy)
+			net = get_net(nsproxy->net_ns);
 	}
 	rcu_read_unlock();
 	return net;
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
