From: akpm@linux-foundation.org
Subject: + cgroup-remove-the-ns_cgroup.patch added to -mm tree
Date: Mon, 27 Sep 2010 12:56:11 -0700
Message-ID: <201009271956.o8RJuBe8013180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933522Ab0I0T5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 15:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.lezcano@free.fr, ebiederm@xmission.com, hadi@cyberus.ca, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, serge.hallyn@canonical.com


The patch titled
     cgroup: remove the ns_cgroup
has been added to the -mm tree.  Its filename is
     cgroup-remove-the-ns_cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: remove the ns_cgroup
From: Daniel Lezcano <daniel.lezcano@free.fr>

The ns_cgroup is an annoying cgroup at the namespace / cgroup frontier.

For example, a single process can not handle a big amount of namespaces
without interacting with this cgroup and falling in an exponential
creation time due to the nested cgroup directory depth (eg. 
/cgroup/<pid>/.../<pid>/...).

That was spotted when creating a single process using multiple network
namespaces, the objective was 4096 network namespaces, but at 820 netns,
the creation time was dramatically slow and the creation time for a
namespace increased from 10msec to 10sec.  After five hours, the expected
numbers of netns was not reached.  Without the ns_cgroup interaction, 4K
netns are created after 2 minutes.

In order to solve that, we have to mount the cgroup with all the
subsystems except the ns_cgroup, it's a little weird and hard to manage
from an administration pov because we have to know what are the cgroup
available on the system and we can't do a simple 'mount -t cgroup cgroup
/cgroup'.

With the previous patch which adds a 'clone_children' parameter to a
cgroup, we should be able to remove the ns_cgroup and manage manually the
creation + adding a task to the cgroup consistenly with the rest of the
subsystems.

This patch removes the ns_cgroup as suggested in the following thread:

https://lists.linux-foundation.org/pipermail/containers/2009-June/018616.html

The 'cgroup_clone' function is removed because it is no longer used.

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jamal Hadi Salim <hadi@cyberus.ca>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt      |    2 
 arch/arm/configs/tegra_defconfig       |    1 
 arch/mips/configs/bcm47xx_defconfig    |    1 
 arch/powerpc/configs/ppc6xx_defconfig  |    1 
 arch/powerpc/configs/pseries_defconfig |    1 
 arch/s390/defconfig                    |    1 
 arch/sh/configs/sdk7786_defconfig      |    1 
 arch/sh/configs/se7206_defconfig       |    1 
 arch/sh/configs/shx3_defconfig         |    1 
 arch/sh/configs/urquell_defconfig      |    1 
 arch/x86/configs/i386_defconfig        |    1 
 arch/x86/configs/x86_64_defconfig      |    1 
 include/linux/cgroup.h                 |    3 
 include/linux/cgroup_subsys.h          |    6 -
 include/linux/nsproxy.h                |    9 -
 init/Kconfig                           |    9 -
 kernel/Makefile                        |    1 
 kernel/cgroup.c                        |  116 -----------------------
 kernel/cpuset.c                        |    7 -
 kernel/fork.c                          |    6 -
 kernel/ns_cgroup.c                     |  110 ---------------------
 kernel/nsproxy.c                       |    4 
 22 files changed, 4 insertions(+), 280 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroup-remove-the-ns_cgroup Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroup-remove-the-ns_cgroup
+++ a/Documentation/cgroups/cgroups.txt
@@ -618,7 +618,7 @@ always handled well.
 void post_clone(struct cgroup_subsys *ss, struct cgroup *cgrp)
 (cgroup_mutex held by caller)
 
-Called at the end of cgroup_clone() to do any parameter
+Called during cgroup_create() to do any parameter
 initialization which might be required before a task could attach.  For
 example in cpusets, no task may attach before 'cpus' and 'mems' are set
 up.
diff -puN arch/arm/configs/tegra_defconfig~cgroup-remove-the-ns_cgroup arch/arm/configs/tegra_defconfig
--- a/arch/arm/configs/tegra_defconfig~cgroup-remove-the-ns_cgroup
+++ a/arch/arm/configs/tegra_defconfig
@@ -65,7 +65,6 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=17
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_DEBUG=y
-# CONFIG_CGROUP_NS is not set
 CONFIG_CGROUP_FREEZER=y
 # CONFIG_CGROUP_DEVICE is not set
 # CONFIG_CPUSETS is not set
diff -puN arch/mips/configs/bcm47xx_defconfig~cgroup-remove-the-ns_cgroup arch/mips/configs/bcm47xx_defconfig
--- a/arch/mips/configs/bcm47xx_defconfig~cgroup-remove-the-ns_cgroup
+++ a/arch/mips/configs/bcm47xx_defconfig
@@ -16,7 +16,6 @@ CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
 CONFIG_TINY_RCU=y
 CONFIG_CGROUPS=y
-CONFIG_CGROUP_NS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
diff -puN arch/powerpc/configs/ppc6xx_defconfig~cgroup-remove-the-ns_cgroup arch/powerpc/configs/ppc6xx_defconfig
--- a/arch/powerpc/configs/ppc6xx_defconfig~cgroup-remove-the-ns_cgroup
+++ a/arch/powerpc/configs/ppc6xx_defconfig
@@ -10,7 +10,6 @@ CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
 CONFIG_CGROUPS=y
-CONFIG_CGROUP_NS=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
diff -puN arch/powerpc/configs/pseries_defconfig~cgroup-remove-the-ns_cgroup arch/powerpc/configs/pseries_defconfig
--- a/arch/powerpc/configs/pseries_defconfig~cgroup-remove-the-ns_cgroup
+++ a/arch/powerpc/configs/pseries_defconfig
@@ -15,7 +15,6 @@ CONFIG_AUDITSYSCALL=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
-CONFIG_CGROUP_NS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
diff -puN arch/s390/defconfig~cgroup-remove-the-ns_cgroup arch/s390/defconfig
--- a/arch/s390/defconfig~cgroup-remove-the-ns_cgroup
+++ a/arch/s390/defconfig
@@ -5,7 +5,6 @@ CONFIG_AUDIT=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
-CONFIG_CGROUP_NS=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_UTS_NS=y
 CONFIG_IPC_NS=y
diff -puN arch/sh/configs/sdk7786_defconfig~cgroup-remove-the-ns_cgroup arch/sh/configs/sdk7786_defconfig
--- a/arch/sh/configs/sdk7786_defconfig~cgroup-remove-the-ns_cgroup
+++ a/arch/sh/configs/sdk7786_defconfig
@@ -12,7 +12,6 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_DEBUG=y
-CONFIG_CGROUP_NS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
diff -puN arch/sh/configs/se7206_defconfig~cgroup-remove-the-ns_cgroup arch/sh/configs/se7206_defconfig
--- a/arch/sh/configs/se7206_defconfig~cgroup-remove-the-ns_cgroup
+++ a/arch/sh/configs/se7206_defconfig
@@ -8,7 +8,6 @@ CONFIG_RCU_TRACE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_DEBUG=y
-CONFIG_CGROUP_NS=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
diff -puN arch/sh/configs/shx3_defconfig~cgroup-remove-the-ns_cgroup arch/sh/configs/shx3_defconfig
--- a/arch/sh/configs/shx3_defconfig~cgroup-remove-the-ns_cgroup
+++ a/arch/sh/configs/shx3_defconfig
@@ -9,7 +9,6 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CGROUPS=y
-CONFIG_CGROUP_NS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
diff -puN arch/sh/configs/urquell_defconfig~cgroup-remove-the-ns_cgroup arch/sh/configs/urquell_defconfig
--- a/arch/sh/configs/urquell_defconfig~cgroup-remove-the-ns_cgroup
+++ a/arch/sh/configs/urquell_defconfig
@@ -9,7 +9,6 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_DEBUG=y
-CONFIG_CGROUP_NS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
diff -puN arch/x86/configs/i386_defconfig~cgroup-remove-the-ns_cgroup arch/x86/configs/i386_defconfig
--- a/arch/x86/configs/i386_defconfig~cgroup-remove-the-ns_cgroup
+++ a/arch/x86/configs/i386_defconfig
@@ -10,7 +10,6 @@ CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_CGROUPS=y
-CONFIG_CGROUP_NS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
diff -puN arch/x86/configs/x86_64_defconfig~cgroup-remove-the-ns_cgroup arch/x86/configs/x86_64_defconfig
--- a/arch/x86/configs/x86_64_defconfig~cgroup-remove-the-ns_cgroup
+++ a/arch/x86/configs/x86_64_defconfig
@@ -11,7 +11,6 @@ CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_CGROUPS=y
-CONFIG_CGROUP_NS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
diff -puN include/linux/cgroup.h~cgroup-remove-the-ns_cgroup include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-remove-the-ns_cgroup
+++ a/include/linux/cgroup.h
@@ -552,9 +552,6 @@ static inline struct cgroup* task_cgroup
 	return task_subsys_state(task, subsys_id)->cgroup;
 }
 
-int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *ss,
-							char *nodename);
-
 /* A cgroup_iter should be treated as an opaque object */
 struct cgroup_iter {
 	struct list_head *cg_link;
diff -puN include/linux/cgroup_subsys.h~cgroup-remove-the-ns_cgroup include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~cgroup-remove-the-ns_cgroup
+++ a/include/linux/cgroup_subsys.h
@@ -19,12 +19,6 @@ SUBSYS(debug)
 
 /* */
 
-#ifdef CONFIG_CGROUP_NS
-SUBSYS(ns)
-#endif
-
-/* */
-
 #ifdef CONFIG_CGROUP_SCHED
 SUBSYS(cpu_cgroup)
 #endif
diff -puN include/linux/nsproxy.h~cgroup-remove-the-ns_cgroup include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~cgroup-remove-the-ns_cgroup
+++ a/include/linux/nsproxy.h
@@ -81,13 +81,4 @@ static inline void get_nsproxy(struct ns
 	atomic_inc(&ns->count);
 }
 
-#ifdef CONFIG_CGROUP_NS
-int ns_cgroup_clone(struct task_struct *tsk, struct pid *pid);
-#else
-static inline int ns_cgroup_clone(struct task_struct *tsk, struct pid *pid)
-{
-	return 0;
-}
-#endif
-
 #endif
diff -puN init/Kconfig~cgroup-remove-the-ns_cgroup init/Kconfig
--- a/init/Kconfig~cgroup-remove-the-ns_cgroup
+++ a/init/Kconfig
@@ -518,15 +518,6 @@ config CGROUP_DEBUG
 
 	  Say N if unsure.
 
-config CGROUP_NS
-	bool "Namespace cgroup subsystem"
-	depends on CGROUPS
-	help
-	  Provides a simple namespace cgroup subsystem to
-	  provide hierarchical naming of sets of namespaces,
-	  for instance virtual servers and checkpoint/restart
-	  jobs.
-
 config CGROUP_FREEZER
 	bool "Freezer cgroup subsystem"
 	depends on CGROUPS
diff -puN kernel/Makefile~cgroup-remove-the-ns_cgroup kernel/Makefile
--- a/kernel/Makefile~cgroup-remove-the-ns_cgroup
+++ a/kernel/Makefile
@@ -61,7 +61,6 @@ obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
-obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
diff -puN kernel/cgroup.c~cgroup-remove-the-ns_cgroup kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-remove-the-ns_cgroup
+++ a/kernel/cgroup.c
@@ -4242,122 +4242,6 @@ void cgroup_exit(struct task_struct *tsk
 }
 
 /**
- * cgroup_clone - clone the cgroup the given subsystem is attached to
- * @tsk: the task to be moved
- * @subsys: the given subsystem
- * @nodename: the name for the new cgroup
- *
- * Duplicate the current cgroup in the hierarchy that the given
- * subsystem is attached to, and move this task into the new
- * child.
- */
-int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
-							char *nodename)
-{
-	struct dentry *dentry;
-	int ret = 0;
-	struct cgroup *parent, *child;
-	struct inode *inode;
-	struct css_set *cg;
-	struct cgroupfs_root *root;
-	struct cgroup_subsys *ss;
-
-	/* We shouldn't be called by an unregistered subsystem */
-	BUG_ON(!subsys->active);
-
-	/* First figure out what hierarchy and cgroup we're dealing
-	 * with, and pin them so we can drop cgroup_mutex */
-	mutex_lock(&cgroup_mutex);
- again:
-	root = subsys->root;
-	if (root == &rootnode) {
-		mutex_unlock(&cgroup_mutex);
-		return 0;
-	}
-
-	/* Pin the hierarchy */
-	if (!atomic_inc_not_zero(&root->sb->s_active)) {
-		/* We race with the final deactivate_super() */
-		mutex_unlock(&cgroup_mutex);
-		return 0;
-	}
-
-	/* Keep the cgroup alive */
-	task_lock(tsk);
-	parent = task_cgroup(tsk, subsys->subsys_id);
-	cg = tsk->cgroups;
-	get_css_set(cg);
-	task_unlock(tsk);
-
-	mutex_unlock(&cgroup_mutex);
-
-	/* Now do the VFS work to create a cgroup */
-	inode = parent->dentry->d_inode;
-
-	/* Hold the parent directory mutex across this operation to
-	 * stop anyone else deleting the new cgroup */
-	mutex_lock(&inode->i_mutex);
-	dentry = lookup_one_len(nodename, parent->dentry, strlen(nodename));
-	if (IS_ERR(dentry)) {
-		printk(KERN_INFO
-		       "cgroup: Couldn't allocate dentry for %s: %ld\n", nodename,
-		       PTR_ERR(dentry));
-		ret = PTR_ERR(dentry);
-		goto out_release;
-	}
-
-	/* Create the cgroup directory, which also creates the cgroup */
-	ret = vfs_mkdir(inode, dentry, 0755);
-	child = __d_cgrp(dentry);
-	dput(dentry);
-	if (ret) {
-		printk(KERN_INFO
-		       "Failed to create cgroup %s: %d\n", nodename,
-		       ret);
-		goto out_release;
-	}
-
-	/* The cgroup now exists. Retake cgroup_mutex and check
-	 * that we're still in the same state that we thought we
-	 * were. */
-	mutex_lock(&cgroup_mutex);
-	if ((root != subsys->root) ||
-	    (parent != task_cgroup(tsk, subsys->subsys_id))) {
-		/* Aargh, we raced ... */
-		mutex_unlock(&inode->i_mutex);
-		put_css_set(cg);
-
-		deactivate_super(root->sb);
-		/* The cgroup is still accessible in the VFS, but
-		 * we're not going to try to rmdir() it at this
-		 * point. */
-		printk(KERN_INFO
-		       "Race in cgroup_clone() - leaking cgroup %s\n",
-		       nodename);
-		goto again;
-	}
-
-	/* do any required auto-setup */
-	for_each_subsys(root, ss) {
-		if (ss->post_clone)
-			ss->post_clone(ss, child);
-	}
-
-	/* All seems fine. Finish by moving the task into the new cgroup */
-	ret = cgroup_attach_task(child, tsk);
-	mutex_unlock(&cgroup_mutex);
-
- out_release:
-	mutex_unlock(&inode->i_mutex);
-
-	mutex_lock(&cgroup_mutex);
-	put_css_set(cg);
-	mutex_unlock(&cgroup_mutex);
-	deactivate_super(root->sb);
-	return ret;
-}
-
-/**
  * cgroup_is_descendant - see if @cgrp is a descendant of @task's cgrp
  * @cgrp: the cgroup in question
  * @task: the task in question
diff -puN kernel/cpuset.c~cgroup-remove-the-ns_cgroup kernel/cpuset.c
--- a/kernel/cpuset.c~cgroup-remove-the-ns_cgroup
+++ a/kernel/cpuset.c
@@ -1829,10 +1829,9 @@ static int cpuset_populate(struct cgroup
 }
 
 /*
- * post_clone() is called at the end of cgroup_clone().
- * 'cgroup' was just created automatically as a result of
- * a cgroup_clone(), and the current task is about to
- * be moved into 'cgroup'.
+ * post_clone() is called during cgroup_create() when the
+ * clone_children mount argument was specified.  The cgroup
+ * can not yet have any tasks.
  *
  * Currently we refuse to set up the cgroup - thereby
  * refusing the task to be entered, and as a result refusing
diff -puN kernel/fork.c~cgroup-remove-the-ns_cgroup kernel/fork.c
--- a/kernel/fork.c~cgroup-remove-the-ns_cgroup
+++ a/kernel/fork.c
@@ -1175,12 +1175,6 @@ static struct task_struct *copy_process(
 	if (clone_flags & CLONE_THREAD)
 		p->tgid = current->tgid;
 
-	if (current->nsproxy != p->nsproxy) {
-		retval = ns_cgroup_clone(p, pid);
-		if (retval)
-			goto bad_fork_free_pid;
-	}
-
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
 	/*
 	 * Clear TID on mm_release()?
diff -puN kernel/ns_cgroup.c~cgroup-remove-the-ns_cgroup /dev/null
--- a/kernel/ns_cgroup.c
+++ /dev/null
@@ -1,110 +0,0 @@
-/*
- * ns_cgroup.c - namespace cgroup subsystem
- *
- * Copyright 2006, 2007 IBM Corp
- */
-
-#include <linux/module.h>
-#include <linux/cgroup.h>
-#include <linux/fs.h>
-#include <linux/proc_fs.h>
-#include <linux/slab.h>
-#include <linux/nsproxy.h>
-
-struct ns_cgroup {
-	struct cgroup_subsys_state css;
-};
-
-struct cgroup_subsys ns_subsys;
-
-static inline struct ns_cgroup *cgroup_to_ns(
-		struct cgroup *cgroup)
-{
-	return container_of(cgroup_subsys_state(cgroup, ns_subsys_id),
-			    struct ns_cgroup, css);
-}
-
-int ns_cgroup_clone(struct task_struct *task, struct pid *pid)
-{
-	char name[PROC_NUMBUF];
-
-	snprintf(name, PROC_NUMBUF, "%d", pid_vnr(pid));
-	return cgroup_clone(task, &ns_subsys, name);
-}
-
-/*
- * Rules:
- *   1. you can only enter a cgroup which is a descendant of your current
- *     cgroup
- *   2. you can only place another process into a cgroup if
- *     a. you have CAP_SYS_ADMIN
- *     b. your cgroup is an ancestor of task's destination cgroup
- *       (hence either you are in the same cgroup as task, or in an
- *        ancestor cgroup thereof)
- */
-static int ns_can_attach(struct cgroup_subsys *ss, struct cgroup *new_cgroup,
-			 struct task_struct *task, bool threadgroup)
-{
-	if (current != task) {
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (!cgroup_is_descendant(new_cgroup, current))
-			return -EPERM;
-	}
-
-	if (!cgroup_is_descendant(new_cgroup, task))
-		return -EPERM;
-
-	if (threadgroup) {
-		struct task_struct *c;
-		rcu_read_lock();
-		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
-			if (!cgroup_is_descendant(new_cgroup, c)) {
-				rcu_read_unlock();
-				return -EPERM;
-			}
-		}
-		rcu_read_unlock();
-	}
-
-	return 0;
-}
-
-/*
- * Rules: you can only create a cgroup if
- *     1. you are capable(CAP_SYS_ADMIN)
- *     2. the target cgroup is a descendant of your own cgroup
- */
-static struct cgroup_subsys_state *ns_create(struct cgroup_subsys *ss,
-						struct cgroup *cgroup)
-{
-	struct ns_cgroup *ns_cgroup;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return ERR_PTR(-EPERM);
-	if (!cgroup_is_descendant(cgroup, current))
-		return ERR_PTR(-EPERM);
-
-	ns_cgroup = kzalloc(sizeof(*ns_cgroup), GFP_KERNEL);
-	if (!ns_cgroup)
-		return ERR_PTR(-ENOMEM);
-	return &ns_cgroup->css;
-}
-
-static void ns_destroy(struct cgroup_subsys *ss,
-			struct cgroup *cgroup)
-{
-	struct ns_cgroup *ns_cgroup;
-
-	ns_cgroup = cgroup_to_ns(cgroup);
-	kfree(ns_cgroup);
-}
-
-struct cgroup_subsys ns_subsys = {
-	.name = "ns",
-	.can_attach = ns_can_attach,
-	.create = ns_create,
-	.destroy  = ns_destroy,
-	.subsys_id = ns_subsys_id,
-};
diff -puN kernel/nsproxy.c~cgroup-remove-the-ns_cgroup kernel/nsproxy.c
--- a/kernel/nsproxy.c~cgroup-remove-the-ns_cgroup
+++ a/kernel/nsproxy.c
@@ -198,10 +198,6 @@ int unshare_nsproxy_namespaces(unsigned 
 		goto out;
 	}
 
-	err = ns_cgroup_clone(current, task_pid(current));
-	if (err)
-		put_nsproxy(*new_nsp);
