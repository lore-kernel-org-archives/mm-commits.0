From: akpm@linux-foundation.org
Subject: - containersv10-add-container_clone-interface.patch removed from -mm tree
Date: Fri, 20 Jul 2007 13:29:23 -0700
Message-ID: <200707202029.l6KKTNoM014876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763872AbXGTUae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, pj@sgi.com, serue@us.ibm.com, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Containers: add container_clone() interface
has been removed from the -mm tree.  Its filename was
     containersv10-add-container_clone-interface.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Containers: add container_clone() interface
From: Paul Menage <menage@google.com>

This patch adds support for container_clone(), a speculative interface to
creating new containers intended to be used for systems such as namespace
unsharing.

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/container.h |    2 
 kernel/container.c        |  123 ++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

diff -puN include/linux/container.h~containersv10-add-container_clone-interface include/linux/container.h
--- a/include/linux/container.h~containersv10-add-container_clone-interface
+++ a/include/linux/container.h
@@ -195,6 +195,8 @@ static inline struct container* task_con
 
 int container_path(const struct container *cont, char *buf, int buflen);
 
+int container_clone(struct task_struct *tsk, struct container_subsys *ss);
+
 #else /* !CONFIG_CONTAINERS */
 
 static inline int container_init_early(void) { return 0; }
diff -puN kernel/container.c~containersv10-add-container_clone-interface kernel/container.c
--- a/kernel/container.c~containersv10-add-container_clone-interface
+++ a/kernel/container.c
@@ -1608,3 +1608,126 @@ void container_exit(struct task_struct *
 	tsk->containers = init_task.containers;
 	task_unlock(tsk);
 }
+
+static atomic_t namecnt;
+static void get_unused_name(char *buf)
+{
+	sprintf(buf, "node%d", atomic_inc_return(&namecnt));
+}
+
+/**
+ * container_clone - duplicate the current container in the hierarchy
+ * that the given subsystem is attached to, and move this task into
+ * the new child
+ */
+int container_clone(struct task_struct *tsk, struct container_subsys *subsys)
+{
+	struct dentry *dentry;
+	int ret = 0;
+	char nodename[32];
+	struct container *parent, *child;
+	struct inode *inode;
+	struct css_group *cg;
+	struct containerfs_root *root;
+
+	/* We shouldn't be called by an unregistered subsystem */
+	BUG_ON(!subsys->active);
+
+	/* First figure out what hierarchy and container we're dealing
+	 * with, and pin them so we can drop container_mutex */
+	mutex_lock(&container_mutex);
+ again:
+	root = subsys->root;
+	if (root == &rootnode) {
+		printk(KERN_INFO
+		       "Not cloning container for unused subsystem %s\n",
+		       subsys->name);
+		mutex_unlock(&container_mutex);
+		return 0;
+	}
+	cg = &tsk->containers;
+	parent = task_container(tsk, subsys->subsys_id);
+	/* Pin the hierarchy */
+	atomic_inc(&parent->root->sb->s_active);
+
+	mutex_unlock(&container_mutex);
+
+	/* Now do the VFS work to create a container */
+	get_unused_name(nodename);
+	inode = parent->dentry->d_inode;
+
+	/* Hold the parent directory mutex across this operation to
+	 * stop anyone else deleting the new container */
+	mutex_lock(&inode->i_mutex);
+	dentry = container_get_dentry(parent->dentry, nodename);
+	if (IS_ERR(dentry)) {
+		printk(KERN_INFO
+		       "Couldn't allocate dentry for %s: %ld\n", nodename,
+		       PTR_ERR(dentry));
+		ret = PTR_ERR(dentry);
+		goto out_release;
+	}
+
+	/* Create the container directory, which also creates the container */
+	ret = vfs_mkdir(inode, dentry, S_IFDIR | 0755);
+	child = __d_cont(dentry);
+	dput(dentry);
+	if (ret) {
+		printk(KERN_INFO
+		       "Failed to create container %s: %d\n", nodename,
+		       ret);
+		goto out_release;
+	}
+
+	if (!child) {
+		printk(KERN_INFO
+		       "Couldn't find new container %s\n", nodename);
+		ret = -ENOMEM;
+		goto out_release;
+	}
+
+	/* The container now exists. Retake container_mutex and check
+	 * that we're still in the same state that we thought we
+	 * were. */
+	mutex_lock(&container_mutex);
+	if ((root != subsys->root) ||
+	    (parent != task_container(tsk, subsys->subsys_id))) {
+		/* Aargh, we raced ... */
+		mutex_unlock(&inode->i_mutex);
+
+		deactivate_super(parent->root->sb);
+		/* The container is still accessible in the VFS, but
+		 * we're not going to try to rmdir() it at this
+		 * point. */
+		printk(KERN_INFO
+		       "Race in container_clone() - leaking container %s\n",
+		       nodename);
+		goto again;
+	}
+
+	/* All seems fine. Finish by moving the task into the new container */
+	ret = attach_task(child, tsk);
+	mutex_unlock(&container_mutex);
+
+ out_release:
+	mutex_unlock(&inode->i_mutex);
+	deactivate_super(parent->root->sb);
+	return ret;
+}
+
+/* See if "cont" is a descendant of the current task's container in
+ * the appropriate hierarchy */
+
+int container_is_descendant(const struct container *cont)
+{
+	int ret;
+	struct container *target;
+	int subsys_id;
+	get_first_subsys(cont, NULL, &subsys_id);
+	target = task_container(current, subsys_id);
+	while (cont != target && cont!= cont->top_container) {
+		cont = cont->parent;
+	}
+	ret = (cont == target);
+	return ret;
+}
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-make-cpusets-a-client-of-containers-whitespace.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containersv10-support-for-automatic-userspace-release-agents-whitespace.patch
add-containerstats-v3.patch
add-containerstats-v3-fix.patch
update-getdelays-to-become-containerstats-aware.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
