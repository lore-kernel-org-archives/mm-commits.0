From: akpm@linux-foundation.org
Subject: - cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:27 -0700
Message-ID: <200807252258.m6PMwRVT003293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755604AbYGYXHc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, balbir@in.ibm.com, danms@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, serge@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cgroup_clone: use pid of newly created task for new cgroup
has been removed from the -mm tree.  Its filename was
     cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup_clone: use pid of newly created task for new cgroup
From: "Serge E. Hallyn" <serue@us.ibm.com>

cgroup_clone creates a new cgroup with the pid of the task.  This works
correctly for unshare, but for clone cgroup_clone is called from
copy_namespaces inside copy_process, which happens before the new pid is
created.  As a result, the new cgroup was created with current's pid. 
This patch:

	1. Moves the call inside copy_process to after the new pid
	   is created
	2. Passes the struct pid into ns_cgroup_clone (as it is not
	   yet attached to the task)
	3. Passes a name from ns_cgroup_clone() into cgroup_clone()
	   so as to keep cgroup_clone() itself simpler
	4. Uses pid_vnr() to get the process id value, so that the
	   pid used to name the new cgroup is always the pid as it
	   would be known to the task which did the cloning or
	   unsharing.  I think that is the most intuitive thing to
	   do.  This way, task t1 does clone(CLONE_NEWPID) to get
	   t2, which does clone(CLONE_NEWPID) to get t3, then the
	   cgroup for t3 will be named for the pid by which t2 knows
	   t3.

(Thanks to Dan Smith for finding the main bug)

Changelog:
	June 11: Incorporate Paul Menage's feedback:  don't pass
	         NULL to ns_cgroup_clone from unshare, and reduce
		 patch size by using 'nodename' in cgroup_clone.
	June 10: Original version

[akpm@linux-foundation.org: build fix]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Serge Hallyn <serge@us.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Tested-by: Dan Smith <danms@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h  |    3 ++-
 include/linux/nsproxy.h |    7 +++++--
 kernel/cgroup.c         |    7 +++----
 kernel/fork.c           |    6 ++++++
 kernel/ns_cgroup.c      |    8 ++++++--
 kernel/nsproxy.c        |    8 +-------
 6 files changed, 23 insertions(+), 16 deletions(-)

diff -puN include/linux/cgroup.h~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup
+++ a/include/linux/cgroup.h
@@ -364,7 +364,8 @@ static inline struct cgroup* task_cgroup
 	return task_subsys_state(task, subsys_id)->cgroup;
 }
 
-int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *ss);
+int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *ss,
+							char *nodename);
 
 /* A cgroup_iter should be treated as an opaque object */
 struct cgroup_iter {
diff -puN include/linux/nsproxy.h~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup
+++ a/include/linux/nsproxy.h
@@ -82,9 +82,12 @@ static inline void get_nsproxy(struct ns
 }
 
 #ifdef CONFIG_CGROUP_NS
-int ns_cgroup_clone(struct task_struct *tsk);
+int ns_cgroup_clone(struct task_struct *tsk, struct pid *pid);
 #else
-static inline int ns_cgroup_clone(struct task_struct *tsk) { return 0; }
+static inline int ns_cgroup_clone(struct task_struct *tsk, struct pid *pid)
+{
+	return 0;
+}
 #endif
 
 #endif
diff -puN kernel/cgroup.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup
+++ a/kernel/cgroup.c
@@ -2848,16 +2848,17 @@ void cgroup_exit(struct task_struct *tsk
  * cgroup_clone - clone the cgroup the given subsystem is attached to
  * @tsk: the task to be moved
  * @subsys: the given subsystem
+ * @nodename: the name for the new cgroup
  *
  * Duplicate the current cgroup in the hierarchy that the given
  * subsystem is attached to, and move this task into the new
  * child.
  */
-int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys)
+int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
+							char *nodename)
 {
 	struct dentry *dentry;
 	int ret = 0;
-	char nodename[MAX_CGROUP_TYPE_NAMELEN];
 	struct cgroup *parent, *child;
 	struct inode *inode;
 	struct css_set *cg;
@@ -2882,8 +2883,6 @@ int cgroup_clone(struct task_struct *tsk
 	cg = tsk->cgroups;
 	parent = task_cgroup(tsk, subsys->subsys_id);
 
-	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "%d", tsk->pid);
-
 	/* Pin the hierarchy */
 	atomic_inc(&parent->root->sb->s_active);
 
diff -puN kernel/fork.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup kernel/fork.c
--- a/kernel/fork.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup
+++ a/kernel/fork.c
@@ -1107,6 +1107,12 @@ static struct task_struct *copy_process(
 	if (clone_flags & CLONE_THREAD)
 		p->tgid = current->tgid;
 
+	if (current->nsproxy != p->nsproxy) {
+		retval = ns_cgroup_clone(p, pid);
+		if (retval)
+			goto bad_fork_free_pid;
+	}
+
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
 	/*
 	 * Clear TID on mm_release()?
diff -puN kernel/ns_cgroup.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup kernel/ns_cgroup.c
--- a/kernel/ns_cgroup.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup
+++ a/kernel/ns_cgroup.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/cgroup.h>
 #include <linux/fs.h>
+#include <linux/proc_fs.h>
 #include <linux/slab.h>
 #include <linux/nsproxy.h>
 
@@ -24,9 +25,12 @@ static inline struct ns_cgroup *cgroup_t
 			    struct ns_cgroup, css);
 }
 
-int ns_cgroup_clone(struct task_struct *task)
+int ns_cgroup_clone(struct task_struct *task, struct pid *pid)
 {
-	return cgroup_clone(task, &ns_subsys);
+	char name[PROC_NUMBUF];
+
+	snprintf(name, PROC_NUMBUF, "%d", pid_vnr(pid));
+	return cgroup_clone(task, &ns_subsys, name);
 }
 
 /*
diff -puN kernel/nsproxy.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup kernel/nsproxy.c
--- a/kernel/nsproxy.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup
+++ a/kernel/nsproxy.c
@@ -157,12 +157,6 @@ int copy_namespaces(unsigned long flags,
 		goto out;
 	}
 
-	err = ns_cgroup_clone(tsk);
-	if (err) {
-		put_nsproxy(new_ns);
-		goto out;
-	}
