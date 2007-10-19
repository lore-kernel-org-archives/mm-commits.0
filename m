From: akpm@linux-foundation.org
Subject: - task-containersv11-add-container_clone-interface.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:50:10 -0700
Message-ID: <200710192250.l9JMoAoO024054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765293AbXJSXHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, clg@fr.ibm.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, pj@sgi.com, serue@us.ibm.com, vatsa@in.ibm.com


The patch titled
     Task Control Groups:  add cgroup_clone() interface
has been removed from the -mm tree.  Its filename was
     task-containersv11-add-container_clone-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Task Control Groups:  add cgroup_clone() interface
From: Paul Menage <menage@google.com>

Add support for cgroup_clone(), a way to create new cgroups intended to
be used for systems such as namespace unsharing.  A new subsystem callback,
post_clone(), is added to allow subsystems to automatically configure cloned
cgroups.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups.txt |    7 +
 include/linux/cgroup.h    |    3 
 kernel/cgroup.c           |  135 ++++++++++++++++++++++++++++++++++++
 3 files changed, 145 insertions(+)

diff -puN Documentation/cgroups.txt~task-containersv11-add-container_clone-interface Documentation/cgroups.txt
--- a/Documentation/cgroups.txt~task-containersv11-add-container_clone-interface
+++ a/Documentation/cgroups.txt
@@ -504,6 +504,13 @@ include/linux/cgroup.h for details).  No
 method can return an error code, the error code is currently not
 always handled well.
 
+void post_clone(struct cgroup_subsys *ss, struct cgroup *cont)
+
+Called at the end of cgroup_clone() to do any paramater
+initialization which might be required before a task could attach.  For
+example in cpusets, no task may attach before 'cpus' and 'mems' are set
+up.
+
 void bind(struct cgroup_subsys *ss, struct cgroup *root)
 LL=callback_mutex
 
diff -puN include/linux/cgroup.h~task-containersv11-add-container_clone-interface include/linux/cgroup.h
--- a/include/linux/cgroup.h~task-containersv11-add-container_clone-interface
+++ a/include/linux/cgroup.h
@@ -182,6 +182,7 @@ struct cgroup_subsys {
 	void (*exit)(struct cgroup_subsys *ss, struct task_struct *task);
 	int (*populate)(struct cgroup_subsys *ss,
 			struct cgroup *cont);
+	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cont);
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
 	int subsys_id;
 	int active;
@@ -221,6 +222,8 @@ static inline struct cgroup* task_cgroup
 
 int cgroup_path(const struct cgroup *cont, char *buf, int buflen);
 
+int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *ss);
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
diff -puN kernel/cgroup.c~task-containersv11-add-container_clone-interface kernel/cgroup.c
--- a/kernel/cgroup.c~task-containersv11-add-container_clone-interface
+++ a/kernel/cgroup.c
@@ -1708,3 +1708,138 @@ void cgroup_exit(struct task_struct *tsk
 	tsk->cgroups = init_task.cgroups;
 	task_unlock(tsk);
 }
+
+/**
+ * cgroup_clone - duplicate the current cgroup in the hierarchy
+ * that the given subsystem is attached to, and move this task into
+ * the new child
+ */
+int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys)
+{
+	struct dentry *dentry;
+	int ret = 0;
+	char nodename[MAX_CGROUP_TYPE_NAMELEN];
+	struct cgroup *parent, *child;
+	struct inode *inode;
+	struct css_set *cg;
+	struct cgroupfs_root *root;
+	struct cgroup_subsys *ss;
+
+	/* We shouldn't be called by an unregistered subsystem */
+	BUG_ON(!subsys->active);
+
+	/* First figure out what hierarchy and cgroup we're dealing
+	 * with, and pin them so we can drop cgroup_mutex */
+	mutex_lock(&cgroup_mutex);
+ again:
+	root = subsys->root;
+	if (root == &rootnode) {
+		printk(KERN_INFO
+		       "Not cloning cgroup for unused subsystem %s\n",
+		       subsys->name);
+		mutex_unlock(&cgroup_mutex);
+		return 0;
+	}
+	cg = &tsk->cgroups;
+	parent = task_cgroup(tsk, subsys->subsys_id);
+
+	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "node_%d", tsk->pid);
+
+	/* Pin the hierarchy */
+	atomic_inc(&parent->root->sb->s_active);
+
+	mutex_unlock(&cgroup_mutex);
+
+	/* Now do the VFS work to create a cgroup */
+	inode = parent->dentry->d_inode;
+
+	/* Hold the parent directory mutex across this operation to
+	 * stop anyone else deleting the new cgroup */
+	mutex_lock(&inode->i_mutex);
+	dentry = lookup_one_len(nodename, parent->dentry, strlen(nodename));
+	if (IS_ERR(dentry)) {
+		printk(KERN_INFO
+		       "Couldn't allocate dentry for %s: %ld\n", nodename,
+		       PTR_ERR(dentry));
+		ret = PTR_ERR(dentry);
+		goto out_release;
+	}
+
+	/* Create the cgroup directory, which also creates the cgroup */
+	ret = vfs_mkdir(inode, dentry, S_IFDIR | 0755);
+	child = __d_cont(dentry);
+	dput(dentry);
+	if (ret) {
+		printk(KERN_INFO
+		       "Failed to create cgroup %s: %d\n", nodename,
+		       ret);
+		goto out_release;
+	}
+
+	if (!child) {
+		printk(KERN_INFO
+		       "Couldn't find new cgroup %s\n", nodename);
+		ret = -ENOMEM;
+		goto out_release;
+	}
+
+	/* The cgroup now exists. Retake cgroup_mutex and check
+	 * that we're still in the same state that we thought we
+	 * were. */
+	mutex_lock(&cgroup_mutex);
+	if ((root != subsys->root) ||
+	    (parent != task_cgroup(tsk, subsys->subsys_id))) {
+		/* Aargh, we raced ... */
+		mutex_unlock(&inode->i_mutex);
+
+		deactivate_super(parent->root->sb);
+		/* The cgroup is still accessible in the VFS, but
+		 * we're not going to try to rmdir() it at this
+		 * point. */
+		printk(KERN_INFO
+		       "Race in cgroup_clone() - leaking cgroup %s\n",
+		       nodename);
+		goto again;
+	}
+
+	/* do any required auto-setup */
+	for_each_subsys(root, ss) {
+		if (ss->post_clone)
+			ss->post_clone(ss, child);
+	}
+
+	/* All seems fine. Finish by moving the task into the new cgroup */
+	ret = attach_task(child, tsk);
+	mutex_unlock(&cgroup_mutex);
+
+ out_release:
+	mutex_unlock(&inode->i_mutex);
+	deactivate_super(parent->root->sb);
+	return ret;
+}
+
+/*
+ * See if "cont" is a descendant of the current task's cgroup in
+ * the appropriate hierarchy
+ *
+ * If we are sending in dummytop, then presumably we are creating
+ * the top cgroup in the subsystem.
+ *
+ * Called only by the ns (nsproxy) cgroup.
+ */
+int cgroup_is_descendant(const struct cgroup *cont)
+{
+	int ret;
+	struct cgroup *target;
+	int subsys_id;
+
+	if (cont == dummytop)
+		return 1;
+
+	get_first_subsys(cont, NULL, &subsys_id);
+	target = task_cgroup(current, subsys_id);
+	while (cont != target && cont!= cont->top_cgroup)
+		cont = cont->parent;
+	ret = (cont == target);
+	return ret;
+}
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
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
add-a-refcount-check-in-dput.patch
