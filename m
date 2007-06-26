From: akpm@linux-foundation.org
Subject: + containers-implement-subsys-post_clone.patch added to -mm tree
Date: Tue, 26 Jun 2007 14:58:45 -0700
Message-ID: <200706262158.l5QLwkb3003000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbXFZV77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 17:59:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, balbir@in.ibm.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, menage@google.com, pj@sgi.com, vatsa@in.ibm.com


The patch titled
     containers: implement subsys->post_clone()
has been added to the -mm tree.  Its filename is
     containers-implement-subsys-post_clone.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: containers: implement subsys->post_clone()
From: "Serge E. Hallyn" <serue@us.ibm.com>

container_clone() in one step creates a new container and moves the current
task into it.  Since cpusets do not automatically fill in the allowed cpus and
mems, and do not allow a task to be attached without these filled in,
composing the ns subsystem, which uses container_clone(), and the cpuset
subsystem, results in sys_unshare() (and clone(CLONE_NEWNS)) always being
denied.

To allow the two subsystems to be meaningfully composed, implement
subsystem->post_clone(), called from container_clone() after creating the new
container.

Only the cpuset_post_clone() is currently implemented.  If any sibling
containers have exclusive cpus or mems, then the cpus and mems are not filled
in for the new container, meaning that unshare/clone(CLONE_NEWNS) will be
denied.  However so long as no siblings have exclusive cpus or mems, the new
container's cpus and mems are inherited from the parent container.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/containers.txt |    7 ++++++
 include/linux/container.h    |    1 
 kernel/container.c           |    7 ++++++
 kernel/cpuset.c              |   37 +++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+)

diff -puN Documentation/containers.txt~containers-implement-subsys-post_clone Documentation/containers.txt
--- a/Documentation/containers.txt~containers-implement-subsys-post_clone
+++ a/Documentation/containers.txt
@@ -514,6 +514,13 @@ include/linux/container.h for details). 
 method can return an error code, the error code is currently not
 always handled well.
 
+void post_clone(struct container_subsys *ss, struct container *cont)
+
+Called at the end of container_clone() to do any paramater
+initialization which might be required before a task could attach.  For
+example in cpusets, no task may attach before 'cpus' and 'mems' are set
+up.
+
 void bind(struct container_subsys *ss, struct container *root)
 LL=callback_mutex
 
diff -puN include/linux/container.h~containers-implement-subsys-post_clone include/linux/container.h
--- a/include/linux/container.h~containers-implement-subsys-post_clone
+++ a/include/linux/container.h
@@ -216,6 +216,7 @@ struct container_subsys {
 	void (*exit)(struct container_subsys *ss, struct task_struct *task);
 	int (*populate)(struct container_subsys *ss,
 			struct container *cont);
+	void (*post_clone)(struct container_subsys *ss, struct container *cont);
 	void (*bind)(struct container_subsys *ss, struct container *root);
 	int subsys_id;
 	int active;
diff -puN kernel/container.c~containers-implement-subsys-post_clone kernel/container.c
--- a/kernel/container.c~containers-implement-subsys-post_clone
+++ a/kernel/container.c
@@ -2375,6 +2375,7 @@ int container_clone(struct task_struct *
 	struct inode *inode;
 	struct css_group *cg;
 	struct containerfs_root *root;
+	struct container_subsys *ss;
 
 	/* We shouldn't be called by an unregistered subsystem */
 	BUG_ON(!subsys->active);
@@ -2454,6 +2455,12 @@ int container_clone(struct task_struct *
 		goto again;
 	}
 
+	/* do any required auto-setup */
+	for_each_subsys(root, ss) {
+		if (ss->post_clone)
+			ss->post_clone(ss, child);
+	}
+
 	/* All seems fine. Finish by moving the task into the new container */
 	ret = attach_task(child, tsk);
 	mutex_unlock(&container_mutex);
diff -puN kernel/cpuset.c~containers-implement-subsys-post_clone kernel/cpuset.c
--- a/kernel/cpuset.c~containers-implement-subsys-post_clone
+++ a/kernel/cpuset.c
@@ -1190,6 +1190,42 @@ int cpuset_populate(struct container_sub
 }
 
 /*
+ * post_clone() is called at the end of container_clone().
+ * 'container' was just created automatically as a result of
+ * a container_clone(), and the current task is about to
+ * be moved into 'container'.
+ *
+ * Currently we refuse to set up the container - thereby
+ * refusing the task to be entered, and as a result refusing
+ * the sys_unshare() or clone() which initiated it - if any
+ * sibling cpusets have exclusive cpus or mem.
+ *
+ * If this becomes a problem for some users who wish to
+ * allow that scenario, then cpuset_post_clone() could be
+ * changed to grant parent->cpus_allowed-sibling_cpus_exclusive
+ * (and likewise for mems) to the new container.
+ */
+void cpuset_post_clone(struct container_subsys *ss,
+		struct container *container)
+{
+	struct container *parent, *child;
+	struct cpuset *cs, *parent_cs;
+
+	parent = container->parent;
+	list_for_each_entry(child, &parent->children, sibling) {
+		cs = container_cs(child);
+		if (is_mem_exclusive(cs) || is_cpu_exclusive(cs))
+			return;
+	}
+	cs = container_cs(container);
+	parent_cs = container_cs(parent);
+
+	cs->mems_allowed = parent_cs->mems_allowed;
+	cs->cpus_allowed = parent_cs->cpus_allowed;
+	return;
+}
+
+/*
  *	cpuset_create - create a cpuset
  *	parent:	cpuset that will be parent of the new cpuset.
  *	name:		name of the new cpuset. Will be strcpy'ed.
@@ -1249,6 +1285,7 @@ struct container_subsys cpuset_subsys = 
 	.can_attach = cpuset_can_attach,
 	.attach = cpuset_attach,
 	.populate = cpuset_populate,
+	.post_clone = cpuset_post_clone,
 	.subsys_id = cpuset_subsys_id,
 	.early_init = 1,
 };
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
