From: akpm@linux-foundation.org
Subject: [obsolete] cgroups-add-a-task-counter-subsystem.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:06:45 -0800
Message-ID: <20111214200646.39BF91E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:38970 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1LNUGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:06:47 -0500
Received: by mail-gy0-f202.google.com with SMTP id f20so133516ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:06:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, kirill@shutemov.name, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: add a task counter subsystem
has been removed from the -mm tree.  Its filename was
     cgroups-add-a-task-counter-subsystem.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: cgroups: add a task counter subsystem

Add a new subsystem to limit the number of running tasks, similar to the
NR_PROC rlimit but in the scope of a cgroup.

The user can set an upper bound limit that is checked every time a task
forks in a cgroup or is moved into a cgroup with that subsystem binded.

The primary goal is to protect against forkbombs that explode inside a
container.  The traditional NR_PROC rlimit is not efficient in that case
because if we run containers in parallel under the same user, one of these
could starve all the others by spawning a high number of tasks close to
the user wide limit.

This is a prevention against forkbombs, so it's not deemed to cure the
effects of a forkbomb when the system is in a state where it's not
responsive.  It's aimed at preventing from ever reaching that state and
stop the spreading of tasks early.  While defining the limit on the
allowed number of tasks, it's up to the user to find the right balance
between the resource its containers may need and what it can afford to
provide.

As it's totally dissociated from the rlimit NR_PROC, both can be
complementary: the cgroup task counter can set an upper bound per
container and the rlmit can be an upper bound on the overall set of
containers.

Also this subsystem can be used to kill all the tasks in a cgroup without
races against concurrent forks, by setting the limit of tasks to 0, any
further forks can be rejected.  This is a good way to kill a forkbomb in a
container, or simply kill any container without the need to retry an
unbound number of times.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/task_counter.txt |  153 ++++++++++++++
 include/linux/cgroup_subsys.h          |    6 
 init/Kconfig                           |    9 
 kernel/Makefile                        |    1 
 kernel/cgroup_task_counter.c           |  239 +++++++++++++++++++++++
 5 files changed, 408 insertions(+)

diff -puN /dev/null Documentation/cgroups/task_counter.txt
--- /dev/null
+++ a/Documentation/cgroups/task_counter.txt
@@ -0,0 +1,153 @@
+Task counter subsystem
+
+1. Description
+
+The task counter subsystem limits the number of tasks running
+inside a given cgroup. It behaves like the NR_PROC rlimit but in
+the scope of a cgroup instead of a user.
+
+It has two typical usecases, although more can probably be found:
+
+1.1 Protection against forkbomb in a container
+
+One usecase is to protect against forkbombs that explode inside
+a container when that container is implemented using a cgroup. The
+NR_PROC rlimit is known to be a working protection against this type
+of attack but is not suitable anymore when we run containers in
+parallel under the same user. One container could starve all the
+others by spawning a high number of tasks close to the rlimit
+boundary. So in this case we need this limitation to be done in a
+per cgroup granularity.
+
+Note this works by preventing forkbombs propagation. It doesn't cure
+the forkbomb effects when it has already grown up enough to make
+the system hardly responsive. While defining the limit on the number
+of tasks, it's up to the admin to find the right balance between the
+possible needs of a container and the resources the system can afford
+to provide.
+
+Also the NR_PROC rlimit and this cgroup subsystem are totally
+dissociated. But they can be complementary. The task counter limits
+the containers and the rlimit can provide an upper bound on the whole
+set of containers.
+
+
+1.2 Kill tasks inside a cgroup
+
+An other usecase comes along the forkbomb prevention: it brings
+the ability to kill all tasks inside a cgroup without races. By
+setting the limit of running tasks to 0, one can prevent from any
+further fork inside a cgroup and then kill all of its tasks without
+the need to retry an unbound amount of time due to races between
+kills and forks running in parallel (more details in "Kill a cgroup
+safely" paragraph).
+
+This is useful to kill a forkbomb for example. When its gazillion
+of forks are competing with the kills, one need to ensure this
+operation won't run in a nearly endless loop of retry.
+
+And more generally it is useful to kill a cgroup in a bound amount
+of pass.
+
+
+2. Interface
+
+When a hierarchy is mounted with the task counter subsystem binded, it
+adds two files into the cgroups directories, except the root one:
+
+- tasks.usage contains the number of tasks running inside a cgroup and
+its children in the hierarchy (see paragraph about Inheritance).
+
+- tasks.limit contains the maximum number of tasks that can run inside
+a cgroup. We check this limit when a task forks or when it is migrated
+to a cgroup.
+
+Note that the tasks.limit value can be forced below tasks.usage, in which
+case any new task in the cgroup will be rejected until the tasks.usage
+value goes below tasks.limit.
+
+For optimization reasons, the root directory of a hierarchy doesn't have
+a task counter.
+
+
+3. Inheritance
+
+When a task is added to a cgroup, by way of a cgroup migration or a fork,
+it increases the task counter of that cgroup and of all its ancestors.
+Hence a cgroup is also subject to the limit of its ancestors.
+
+In the following hierarchy:
+
+
+             A
+             |
+             B
+           /   \
+          C     D
+
+
+We have 1 task running in B, one running in C and none running in D.
+It means we have tasks.usage = 1 in C and tasks.usage = 2 in B because
+B counts its task and those of its children.
+
+Now lets set tasks.limit = 2 in B and tasks.limit = 1 in D.
+If we move a new task in D, it will be refused because the limit in B has
+been reached already.
+
+
+4. Kill a cgroup safely
+
+As explained in the description, this subsystem is also helpful to
+kill all tasks in a cgroup safely, after setting tasks.limit to 0,
+so that we don't race against parallel forks in an unbound numbers
+of kill iterations.
+
+But there is a small detail to be aware of to use this feature that
+way.
+
+Some typical way to proceed would be:
+
+	echo 0 > tasks.limit
+	for TASK in $(cat cgroup.procs)
+	do
+		kill -KILL $TASK
+	done
+
+However there is a small race window where a task can be in the way to
+be forked but hasn't enough completed the fork to have the PID of the
+fork appearing in the cgroup.procs file.
+
+The only way to get it right is to run a loop that reads tasks.usage, kill
+all the tasks in cgroup.procs and exit the loop only if the value in
+tasks.usage was the same than the number of tasks that were in cgroup.procs,
+ie: the number of tasks that were killed.
+
+It works because the new child appears in tasks.usage right before we check,
+in the fork path, whether the parent has a pending signal, in which case the
+fork is cancelled anyway. So relying on tasks.usage is fine and non-racy.
+
+This race window is tiny and unlikely to happen, so most of the time a single
+kill iteration should be enough. But it's worth knowing about that corner
+case spotted by Oleg Nesterov.
+
+Example of safe use would be:
+
+	echo 0 > tasks.limit
+	END=false
+
+	while [ $END == false ]
+	do
+		NR_TASKS=$(cat tasks.usage)
+		NR_KILLED=0
+
+		for TASK in $(cat cgroup.procs)
+		do
+			let NR_KILLED=NR_KILLED+1
+			kill -KILL $TASK
+		done
+
+		if [ "$NR_TASKS" = "$NR_KILLED" ]
+		then
+			END=true
+		fi
+	done
diff -puN include/linux/cgroup_subsys.h~cgroups-add-a-task-counter-subsystem include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~cgroups-add-a-task-counter-subsystem
+++ a/include/linux/cgroup_subsys.h
@@ -72,3 +72,9 @@ SUBSYS(net_prio)
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
@@ -690,6 +690,15 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
 	  select this option (if, for some reason, they need to disable it
 	  then swapaccount=0 does the trick).
 
+config CGROUP_TASK_COUNTER
+	bool "Control number of tasks in a cgroup"
+	depends on RESOURCE_COUNTERS
+	help
+	  Let the user set up an upper boundary of the allowed number of tasks
+	  running in a cgroup. When a task forks or is migrated to a cgroup that
+	  has this subsystem binded, the limit is checked to either accept or
+	  reject the fork/migration.
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
@@ -0,0 +1,239 @@
+/*
+ * Limits on number of tasks subsystem for cgroups
+ *
+ * Copyright (C) 2011 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
+ *
+ * Thanks to Andrew Morton, Johannes Weiner, Li Zefan, Oleg Nesterov and
+ * Paul Menage for their suggestions.
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
+ * The root task counter doesn't exist because it's not part of the
+ * whole task counting. We want to optimize the trivial case of only
+ * one root cgroup living.
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
+static inline struct res_counter *cgroup_task_res_counter(struct cgroup *cgrp)
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
+	parent_res = cgroup_task_res_counter(cgrp->parent);
+
+	res_counter_init(&cnt->res, parent_res);
+
+	return &cnt->css;
+}
+
+/*
+ * Inherit the limit value of the parent. This is not really to enforce
+ * a limit below or equal to the one of the parent which can be changed
+ * concurrently anyway. This is just to honour the clone flag.
+ */
+static void task_counter_post_clone(struct cgroup_subsys *ss,
+				    struct cgroup *cgrp)
+{
+	/* cgrp can't be root, so cgroup_task_res_counter() can't return NULL */
+	res_counter_inherit(cgroup_task_res_counter(cgrp), RES_LIMIT);
+}
+
+static void task_counter_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct task_counter *cnt = cgroup_task_counter(cgrp);
+
+	kfree(cnt);
+}
+
+/* Uncharge the cgroup the task was attached to */
+static void task_counter_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			      struct cgroup *old_cgrp, struct task_struct *task)
+{
+	/* Optimize for the root cgroup case */
+	if (old_cgrp->parent)
+		res_counter_uncharge(cgroup_task_res_counter(old_cgrp), 1);
+}
+
+/*
+ * Protected amongst can_attach_task/attach_task/cancel_attach_task by
+ * cgroup mutex
+ */
+static struct res_counter *common_ancestor;
+
+/*
+ * This does more than just probing the ability to attach to the dest cgroup.
+ * We can not just _check_ if we can attach to the destination and do the real
+ * attachment later in task_counter_attach_task() because a task in the dest
+ * cgroup can fork before and steal the last remaining count.
+ * Thus we need to charge the dest cgroup right now.
+ */
+static int task_counter_can_attach_task(struct cgroup *cgrp,
+					struct cgroup *old_cgrp,
+					struct task_struct *tsk)
+{
+	struct res_counter *res = cgroup_task_res_counter(cgrp);
+	struct res_counter *old_res = cgroup_task_res_counter(old_cgrp);
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
+/* Uncharge the dest cgroup that we charged in task_counter_can_attach_task() */
+static void task_counter_cancel_attach_task(struct cgroup *cgrp,
+					    struct task_struct *tsk)
+{
+	res_counter_uncharge_until(cgroup_task_res_counter(cgrp),
+				   common_ancestor, 1);
+}
+
+/*
+ * This uncharge the old cgroup. We can do that now that we are sure the
+ * attachment can't cancelled anymore, because this uncharge operation
+ * couldn't be reverted later: a task in the old cgroup could fork after
+ * we uncharge and reach the task counter limit, making our return there
+ * not possible.
+ */
+static void task_counter_attach_task(struct cgroup *cgrp,
+				     struct cgroup *old_cgrp,
+				     struct task_struct *tsk)
+{
+	res_counter_uncharge_until(cgroup_task_res_counter(old_cgrp),
+				   common_ancestor, 1);
+}
+
+static u64 task_counter_read_u64(struct cgroup *cgrp, struct cftype *cft)
+{
+	int type = cft->private;
+
+	return res_counter_read_u64(cgroup_task_res_counter(cgrp), type);
+}
+
+static int task_counter_write_u64(struct cgroup *cgrp, struct cftype *cft,
+				  u64 val)
+{
+	int type = cft->private;
+
+	res_counter_write_u64(cgroup_task_res_counter(cgrp), type, val);
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
+/*
+ * Charge the task counter with the new child coming, or reject it if we
+ * reached the limit.
+ */
+static int task_counter_fork(struct cgroup_subsys *ss,
+			     struct task_struct *child)
+{
+	struct cgroup_subsys_state *css;
+	struct cgroup *cgrp;
+	int err;
+
+	css = child->cgroups->subsys[tasks_subsys_id];
+	cgrp = css->cgroup;
+
+	/* Optimize for the root cgroup case, which doesn't have a limit */
+	if (!cgrp->parent)
+		return 0;
+
+	err = res_counter_charge(cgroup_task_res_counter(cgrp), 1, NULL);
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
+	.fork			= task_counter_fork,
+	.populate		= task_counter_populate,
+};
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
reiserfs-delay-reiserfs-lock-until-journal-initialization.patch
reiserfs-dont-lock-journal_init.patch
reiserfs-dont-lock-root-inode-searching.patch
cgroups-add-a-task-counter-subsystem-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
selftests-new-x86-breakpoints-selftest.patch

