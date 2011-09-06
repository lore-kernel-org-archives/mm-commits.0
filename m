From: akpm@linux-foundation.org
Subject: + cgroups-add-a-task-counter-subsystem.patch added to -mm tree
Date: Tue, 06 Sep 2011 15:42:27 -0700
Message-ID: <201109062242.p86MgSK6008320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685Ab1IFWmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, adityakali@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org, kay.sievers@vrfy.org, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, tj@kernel.org


The patch titled
     cgroups: add a task counter subsystem
has been added to the -mm tree.  Its filename is
     cgroups-add-a-task-counter-subsystem.patch

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
Subject: cgroups: add a task counter subsystem
From: Frederic Weisbecker <fweisbec@gmail.com>

Add a new subsystem to limit the number of running tasks, similar to the
NR_PROC rlimit but in the scope of a cgroup.

This is a step to be able to isolate a bit more a cgroup against the rest
of the system and limit the global impact of a fork bomb inside a given
cgroup.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h        |    9 +
 include/linux/cgroup_subsys.h |    8 +
 init/Kconfig                  |    7 +
 kernel/Makefile               |    1 
 kernel/cgroup_task_counter.c  |  199 ++++++++++++++++++++++++++++++++
 kernel/fork.c                 |    4 
 6 files changed, 228 insertions(+)

diff -puN include/linux/cgroup.h~cgroups-add-a-task-counter-subsystem include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-a-task-counter-subsystem
+++ a/include/linux/cgroup.h
@@ -659,4 +659,13 @@ static inline int cgroup_attach_task_cur
 
 #endif /* !CONFIG_CGROUPS */
 
+#ifdef CONFIG_CGROUP_TASK_COUNTER
+int cgroup_task_counter_fork(struct task_struct *child);
+#else
+static inline int cgroup_task_counter_fork(struct task_struct *child)
+{
+	return 0;
+}
+#endif /* CONFIG_CGROUP_TASK_COUNTER */
+
 #endif /* _LINUX_CGROUP_H */
diff -puN include/linux/cgroup_subsys.h~cgroups-add-a-task-counter-subsystem include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~cgroups-add-a-task-counter-subsystem
+++ a/include/linux/cgroup_subsys.h
@@ -59,8 +59,16 @@ SUBSYS(net_cls)
 SUBSYS(blkio)
 #endif
 
+/* */
+
 #ifdef CONFIG_CGROUP_PERF
 SUBSYS(perf)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_TASK_COUNTER
+SUBSYS(tasks)
+#endif
+
+/* */
diff -puN init/Kconfig~cgroups-add-a-task-counter-subsystem init/Kconfig
--- a/init/Kconfig~cgroups-add-a-task-counter-subsystem
+++ a/init/Kconfig
@@ -690,6 +690,13 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
 	  select this option (if, for some reason, they need to disable it
 	  then swapaccount=0 does the trick).
 
+config CGROUP_TASK_COUNTER
+	bool "Control number of tasks in a cgroup"
+	depends on RESOURCE_COUNTERS
+	help
+	  Let the user set up an upper bound allowed number of tasks running
+	  in a cgroup.
+
 config CGROUP_PERF
 	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
 	depends on PERF_EVENTS && CGROUPS
diff -puN kernel/Makefile~cgroups-add-a-task-counter-subsystem kernel/Makefile
--- a/kernel/Makefile~cgroups-add-a-task-counter-subsystem
+++ a/kernel/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_BACKTRACE_SELF_TEST) += bac
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
+obj-$(CONFIG_CGROUP_TASK_COUNTER) += cgroup_task_counter.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
diff -puN /dev/null kernel/cgroup_task_counter.c
--- /dev/null
+++ a/kernel/cgroup_task_counter.c
@@ -0,0 +1,199 @@
+/*
+ * Limits on number of tasks subsystem for cgroups
+ *
+ * Copyright (C) 2011 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
+ *
+ * Thanks to Andrew Morton, Johannes Weiner, Li Zefan, Oleg Nesterov and Paul Menage
+ * for their suggestions.
+ *
+ */
+
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+#include <linux/res_counter.h>
+
+
+struct task_counter {
+	struct res_counter		res;
+	struct cgroup_subsys_state	css;
+};
+
+/*
+ * The root task counter doesn't exist as it's not part of the
+ * whole task counting in order to optimize the trivial case
+ * of only one root cgroup living.
+ */
+static struct cgroup_subsys_state root_css;
+
+
+static inline struct task_counter *cgroup_task_counter(struct cgroup *cgrp)
+{
+	if (!cgrp->parent)
+		return NULL;
+
+	return container_of(cgroup_subsys_state(cgrp, tasks_subsys_id),
+			    struct task_counter, css);
+}
+
+static inline struct res_counter *cgroup_task_counter_res(struct cgroup *cgrp)
+{
+	struct task_counter *cnt;
+
+	cnt = cgroup_task_counter(cgrp);
+	if (!cnt)
+		return NULL;
+
+	return &cnt->res;
+}
+
+static struct cgroup_subsys_state *
+task_counter_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct task_counter *cnt;
+	struct res_counter *parent_res;
+
+	if (!cgrp->parent)
+		return &root_css;
+
+	cnt = kzalloc(sizeof(*cnt), GFP_KERNEL);
+	if (!cnt)
+		return ERR_PTR(-ENOMEM);
+
+	parent_res = cgroup_task_counter_res(cgrp->parent);
+
+	res_counter_init(&cnt->res, parent_res);
+
+	return &cnt->css;
+}
+
+static void task_counter_post_clone(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	/* cgrp can't be root, so cgroup_task_counter_res() can't return NULL */
+	res_counter_inherit(cgroup_task_counter_res(cgrp), RES_LIMIT);
+}
+
+static void task_counter_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct task_counter *cnt = cgroup_task_counter(cgrp);
+
+	kfree(cnt);
+}
+
+static void task_counter_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			      struct cgroup *old_cgrp, struct task_struct *task)
+{
+	/* Optimize for the root cgroup case */
+	if (old_cgrp->parent)
+		res_counter_uncharge(cgroup_task_counter_res(old_cgrp), 1);
+}
+
+/* Protected amongst can_attach_task/attach_task/cancel_attach_task by cgroup mutex */
+static struct res_counter *common_ancestor;
+
+static int task_counter_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+					struct task_struct *tsk)
+{
+	struct res_counter *res = cgroup_task_counter_res(cgrp);
+	struct res_counter *old_res = cgroup_task_counter_res(old_cgrp);
+	int err;
+
+	/*
+	 * When moving a task from a cgroup to another, we don't want
+	 * to charge the common ancestors, even though they will be
+	 * uncharged later from attach_task(), because during that
+	 * short window between charge and uncharge, a task could fork
+	 * in the ancestor and spuriously fail due to the temporary
+	 * charge.
+	 */
+	common_ancestor = res_counter_common_ancestor(res, old_res);
+
+	/*
+	 * If cgrp is the root then res is NULL, however in this case
+	 * the common ancestor is NULL as well, making the below a NOP.
+	 */
+	err = res_counter_charge_until(res, common_ancestor, 1, NULL);
+	if (err)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void task_counter_cancel_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+{
+	res_counter_uncharge_until(cgroup_task_counter_res(cgrp), common_ancestor, 1);
+}
+
+static void task_counter_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				     struct task_struct *tsk)
+{
+	res_counter_uncharge_until(cgroup_task_counter_res(old_cgrp), common_ancestor, 1);
+}
+
+static u64 task_counter_read_u64(struct cgroup *cgrp, struct cftype *cft)
+{
+	int type = cft->private;
+
+	return res_counter_read_u64(cgroup_task_counter_res(cgrp), type);
+}
+
+static int task_counter_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	int type = cft->private;
+
+	res_counter_write_u64(cgroup_task_counter_res(cgrp), type, val);
+
+	return 0;
+}
+
+static struct cftype files[] = {
+	{
+		.name		= "limit",
+		.read_u64	= task_counter_read_u64,
+		.write_u64	= task_counter_write_u64,
+		.private	= RES_LIMIT,
+	},
+
+	{
+		.name		= "usage",
+		.read_u64	= task_counter_read_u64,
+		.private	= RES_USAGE,
+	},
+};
+
+static int task_counter_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	if (!cgrp->parent)
+		return 0;
+
+	return cgroup_add_files(cgrp, ss, files, ARRAY_SIZE(files));
+}
+
+int cgroup_task_counter_fork(struct task_struct *child)
+{
+	struct cgroup_subsys_state *css = child->cgroups->subsys[tasks_subsys_id];
+	struct cgroup *cgrp = css->cgroup;
+	int err;
+
+	/* Optimize for the root cgroup case, which doesn't have a limit */
+	if (!cgrp->parent)
+		return 0;
+
+	err = res_counter_charge(cgroup_task_counter_res(cgrp), 1, NULL);
+	if (err)
+		return -EAGAIN;
+
+	return 0;
+}
+
+struct cgroup_subsys tasks_subsys = {
+	.name			= "tasks",
+	.subsys_id		= tasks_subsys_id,
+	.create			= task_counter_create,
+	.post_clone		= task_counter_post_clone,
+	.destroy		= task_counter_destroy,
+	.exit			= task_counter_exit,
+	.can_attach_task	= task_counter_can_attach_task,
+	.cancel_attach_task	= task_counter_cancel_attach_task,
+	.attach_task		= task_counter_attach_task,
+	.populate		= task_counter_populate,
+};
diff -puN kernel/fork.c~cgroups-add-a-task-counter-subsystem kernel/fork.c
--- a/kernel/fork.c~cgroups-add-a-task-counter-subsystem
+++ a/kernel/fork.c
@@ -1334,6 +1334,10 @@ static struct task_struct *copy_process(
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
 
+	retval = cgroup_task_counter_fork(p);
+	if (retval)
+		goto bad_fork_free_pid;
+
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
tracex86-add-tracepoint-to-x86-timer-interrupt-handler.patch
tracex86-add-x86-irq-vector-entry-exit-tracepoints.patch
cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-new-cancel_attach_task-subsystem-callback-fix.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
cgroups-add-res-counter-common-ancestor-searching-fix.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-documentation-for-task-counter-subsystem.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-convert-task-counter-to-use-the-subsys-fork-callback.patch

