From: akpm@linux-foundation.org
Subject: [merged] cgroups-add-per-thread-subsystem-callbacks.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:38 -0700
Message-ID: <201105271955.p4RJtijY017484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756808Ab1E0T4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bblum@andrew.cmu.edu, ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, miaox@cn.fujitsu.com, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: add per-thread subsystem callbacks
has been removed from the -mm tree.  Its filename was
     cgroups-add-per-thread-subsystem-callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add per-thread subsystem callbacks
From: Ben Blum <bblum@andrew.cmu.edu>

Add cgroup subsystem callbacks for per-thread attachment in atomic contexts

Add can_attach_task(), pre_attach(), and attach_task() as new callbacks
for cgroups's subsystem interface.  Unlike can_attach and attach, these
are for per-thread operations, to be called potentially many times when
attaching an entire threadgroup.

Also, the old "bool threadgroup" interface is removed, as replaced by
this.  All subsystems are modified for the new interface - of note is
cpuset, which requires from/to nodemasks for attach to be globally scoped
(though per-cpuset would work too) to persist from its pre_attach to
attach_task and attach.

This is a pre-patch for cgroup-procs-writable.patch.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |   30 ++++++--
 block/blk-cgroup.c                |   18 +----
 include/linux/cgroup.h            |   10 +-
 kernel/cgroup.c                   |   17 ++++
 kernel/cgroup_freezer.c           |   26 ++-----
 kernel/cpuset.c                   |   96 +++++++++++++---------------
 kernel/sched.c                    |   38 -----------
 mm/memcontrol.c                   |   18 +----
 security/device_cgroup.c          |    3 
 9 files changed, 114 insertions(+), 142 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-add-per-thread-subsystem-callbacks Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-add-per-thread-subsystem-callbacks
+++ a/Documentation/cgroups/cgroups.txt
@@ -575,7 +575,7 @@ rmdir() will fail with it. From this beh
 called multiple times against a cgroup.
 
 int can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-	       struct task_struct *task, bool threadgroup)
+	       struct task_struct *task)
 (cgroup_mutex held by caller)
 
 Called prior to moving a task into a cgroup; if the subsystem
@@ -584,9 +584,14 @@ task is passed, then a successful result
 unspecified task can be moved into the cgroup. Note that this isn't
 called on a fork. If this method returns 0 (success) then this should
 remain valid while the caller holds cgroup_mutex and it is ensured that either
-attach() or cancel_attach() will be called in future. If threadgroup is
-true, then a successful result indicates that all threads in the given
-thread's threadgroup can be moved together.
+attach() or cancel_attach() will be called in future.
+
+int can_attach_task(struct cgroup *cgrp, struct task_struct *tsk);
+(cgroup_mutex held by caller)
+
+As can_attach, but for operations that must be run once per task to be
+attached (possibly many when using cgroup_attach_proc). Called after
+can_attach.
 
 void cancel_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	       struct task_struct *task, bool threadgroup)
@@ -598,15 +603,24 @@ function, so that the subsystem can impl
 This will be called only about subsystems whose can_attach() operation have
 succeeded.
 
+void pre_attach(struct cgroup *cgrp);
+(cgroup_mutex held by caller)
+
+For any non-per-thread attachment work that needs to happen before
+attach_task. Needed by cpuset.
+
 void attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-	    struct cgroup *old_cgrp, struct task_struct *task,
-	    bool threadgroup)
+	    struct cgroup *old_cgrp, struct task_struct *task)
 (cgroup_mutex held by caller)
 
 Called after the task has been attached to the cgroup, to allow any
 post-attachment activity that requires memory allocations or blocking.
-If threadgroup is true, the subsystem should take care of all threads
-in the specified thread's threadgroup. Currently does not support any
+
+void attach_task(struct cgroup *cgrp, struct task_struct *tsk);
+(cgroup_mutex held by caller)
+
+As attach, but for operations that must be run once per task to be attached,
+like can_attach_task. Called before attach. Currently does not support any
 subsystem that might need the old_cgrp for every thread in the group.
 
 void fork(struct cgroup_subsy *ss, struct task_struct *task)
diff -puN block/blk-cgroup.c~cgroups-add-per-thread-subsystem-callbacks block/blk-cgroup.c
--- a/block/blk-cgroup.c~cgroups-add-per-thread-subsystem-callbacks
+++ a/block/blk-cgroup.c
@@ -30,10 +30,8 @@ EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
 static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
 						  struct cgroup *);
-static int blkiocg_can_attach(struct cgroup_subsys *, struct cgroup *,
-			      struct task_struct *, bool);
-static void blkiocg_attach(struct cgroup_subsys *, struct cgroup *,
-			   struct cgroup *, struct task_struct *, bool);
+static int blkiocg_can_attach_task(struct cgroup *, struct task_struct *);
+static void blkiocg_attach_task(struct cgroup *, struct task_struct *);
 static void blkiocg_destroy(struct cgroup_subsys *, struct cgroup *);
 static int blkiocg_populate(struct cgroup_subsys *, struct cgroup *);
 
@@ -46,8 +44,8 @@ static int blkiocg_populate(struct cgrou
 struct cgroup_subsys blkio_subsys = {
 	.name = "blkio",
 	.create = blkiocg_create,
-	.can_attach = blkiocg_can_attach,
-	.attach = blkiocg_attach,
+	.can_attach_task = blkiocg_can_attach_task,
+	.attach_task = blkiocg_attach_task,
 	.destroy = blkiocg_destroy,
 	.populate = blkiocg_populate,
 #ifdef CONFIG_BLK_CGROUP
@@ -1616,9 +1614,7 @@ done:
  * of the main cic data structures.  For now we allow a task to change
  * its cgroup only if it's the only owner of its ioc.
  */
-static int blkiocg_can_attach(struct cgroup_subsys *subsys,
-				struct cgroup *cgroup, struct task_struct *tsk,
-				bool threadgroup)
+static int blkiocg_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
 	struct io_context *ioc;
 	int ret = 0;
@@ -1633,9 +1629,7 @@ static int blkiocg_can_attach(struct cgr
 	return ret;
 }
 
-static void blkiocg_attach(struct cgroup_subsys *subsys, struct cgroup *cgroup,
-				struct cgroup *prev, struct task_struct *tsk,
-				bool threadgroup)
+static void blkiocg_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
 	struct io_context *ioc;
 
diff -puN include/linux/cgroup.h~cgroups-add-per-thread-subsystem-callbacks include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-per-thread-subsystem-callbacks
+++ a/include/linux/cgroup.h
@@ -467,12 +467,14 @@ struct cgroup_subsys {
 	int (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	int (*can_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
-			  struct task_struct *tsk, bool threadgroup);
+			  struct task_struct *tsk);
+	int (*can_attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
 	void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
-			  struct task_struct *tsk, bool threadgroup);
+			      struct task_struct *tsk);
+	void (*pre_attach)(struct cgroup *cgrp);
+	void (*attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
-			struct cgroup *old_cgrp, struct task_struct *tsk,
-			bool threadgroup);
+		       struct cgroup *old_cgrp, struct task_struct *tsk);
 	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
 	void (*exit)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			struct cgroup *old_cgrp, struct task_struct *task);
diff -puN kernel/cgroup.c~cgroups-add-per-thread-subsystem-callbacks kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-per-thread-subsystem-callbacks
+++ a/kernel/cgroup.c
@@ -1759,7 +1759,7 @@ int cgroup_attach_task(struct cgroup *cg
 
 	for_each_subsys(root, ss) {
 		if (ss->can_attach) {
-			retval = ss->can_attach(ss, cgrp, tsk, false);
+			retval = ss->can_attach(ss, cgrp, tsk);
 			if (retval) {
 				/*
 				 * Remember on which subsystem the can_attach()
@@ -1771,6 +1771,13 @@ int cgroup_attach_task(struct cgroup *cg
 				goto out;
 			}
 		}
+		if (ss->can_attach_task) {
+			retval = ss->can_attach_task(cgrp, tsk);
+			if (retval) {
+				failed_ss = ss;
+				goto out;
+			}
+		}
 	}
 
 	task_lock(tsk);
@@ -1805,8 +1812,12 @@ int cgroup_attach_task(struct cgroup *cg
 	write_unlock(&css_set_lock);
 
 	for_each_subsys(root, ss) {
+		if (ss->pre_attach)
+			ss->pre_attach(cgrp);
+		if (ss->attach_task)
+			ss->attach_task(cgrp, tsk);
 		if (ss->attach)
-			ss->attach(ss, cgrp, oldcgrp, tsk, false);
+			ss->attach(ss, cgrp, oldcgrp, tsk);
 	}
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
 	synchronize_rcu();
@@ -1829,7 +1840,7 @@ out:
 				 */
 				break;
 			if (ss->cancel_attach)
-				ss->cancel_attach(ss, cgrp, tsk, false);
+				ss->cancel_attach(ss, cgrp, tsk);
 		}
 	}
 	return retval;
diff -puN kernel/cgroup_freezer.c~cgroups-add-per-thread-subsystem-callbacks kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~cgroups-add-per-thread-subsystem-callbacks
+++ a/kernel/cgroup_freezer.c
@@ -160,7 +160,7 @@ static void freezer_destroy(struct cgrou
  */
 static int freezer_can_attach(struct cgroup_subsys *ss,
 			      struct cgroup *new_cgroup,
-			      struct task_struct *task, bool threadgroup)
+			      struct task_struct *task)
 {
 	struct freezer *freezer;
 
@@ -172,26 +172,17 @@ static int freezer_can_attach(struct cgr
 	if (freezer->state != CGROUP_THAWED)
 		return -EBUSY;
 
+	return 0;
+}
+
+static int freezer_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+{
 	rcu_read_lock();
-	if (__cgroup_freezing_or_frozen(task)) {
+	if (__cgroup_freezing_or_frozen(tsk)) {
 		rcu_read_unlock();
 		return -EBUSY;
 	}
 	rcu_read_unlock();
-
-	if (threadgroup) {
-		struct task_struct *c;
-
-		rcu_read_lock();
-		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
-			if (__cgroup_freezing_or_frozen(c)) {
-				rcu_read_unlock();
-				return -EBUSY;
-			}
-		}
-		rcu_read_unlock();
-	}
-
 	return 0;
 }
 
@@ -390,6 +381,9 @@ struct cgroup_subsys freezer_subsys = {
 	.populate	= freezer_populate,
 	.subsys_id	= freezer_subsys_id,
 	.can_attach	= freezer_can_attach,
+	.can_attach_task = freezer_can_attach_task,
+	.pre_attach	= NULL,
+	.attach_task	= NULL,
 	.attach		= NULL,
 	.fork		= freezer_fork,
 	.exit		= NULL,
diff -puN kernel/cpuset.c~cgroups-add-per-thread-subsystem-callbacks kernel/cpuset.c
--- a/kernel/cpuset.c~cgroups-add-per-thread-subsystem-callbacks
+++ a/kernel/cpuset.c
@@ -1367,14 +1367,10 @@ static int fmeter_getrate(struct fmeter 
 	return val;
 }
 
-/* Protected by cgroup_lock */
-static cpumask_var_t cpus_attach;
-
 /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
 static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
-			     struct task_struct *tsk, bool threadgroup)
+			     struct task_struct *tsk)
 {
-	int ret;
 	struct cpuset *cs = cgroup_cs(cont);
 
 	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
@@ -1391,29 +1387,42 @@ static int cpuset_can_attach(struct cgro
 	if (tsk->flags & PF_THREAD_BOUND)
 		return -EINVAL;
 
-	ret = security_task_setscheduler(tsk);
-	if (ret)
-		return ret;
-	if (threadgroup) {
-		struct task_struct *c;
-
-		rcu_read_lock();
-		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
-			ret = security_task_setscheduler(c);
-			if (ret) {
-				rcu_read_unlock();
-				return ret;
-			}
-		}
-		rcu_read_unlock();
-	}
 	return 0;
 }
 
-static void cpuset_attach_task(struct task_struct *tsk, nodemask_t *to,
-			       struct cpuset *cs)
+static int cpuset_can_attach_task(struct cgroup *cgrp, struct task_struct *task)
+{
+	return security_task_setscheduler(task);
+}
+
+/*
+ * Protected by cgroup_lock. The nodemasks must be stored globally because
+ * dynamically allocating them is not allowed in pre_attach, and they must
+ * persist among pre_attach, attach_task, and attach.
+ */
+static cpumask_var_t cpus_attach;
+static nodemask_t cpuset_attach_nodemask_from;
+static nodemask_t cpuset_attach_nodemask_to;
+
+/* Set-up work for before attaching each task. */
+static void cpuset_pre_attach(struct cgroup *cont)
+{
+	struct cpuset *cs = cgroup_cs(cont);
+
+	if (cs == &top_cpuset)
+		cpumask_copy(cpus_attach, cpu_possible_mask);
+	else
+		guarantee_online_cpus(cs, cpus_attach);
+
+	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
+}
+
+/* Per-thread attachment work. */
+static void cpuset_attach_task(struct cgroup *cont, struct task_struct *tsk)
 {
 	int err;
+	struct cpuset *cs = cgroup_cs(cont);
+
 	/*
 	 * can_attach beforehand should guarantee that this doesn't fail.
 	 * TODO: have a better way to handle failure here
@@ -1421,45 +1430,29 @@ static void cpuset_attach_task(struct ta
 	err = set_cpus_allowed_ptr(tsk, cpus_attach);
 	WARN_ON_ONCE(err);
 
-	cpuset_change_task_nodemask(tsk, to);
+	cpuset_change_task_nodemask(tsk, &cpuset_attach_nodemask_to);
 	cpuset_update_task_spread_flag(cs, tsk);
-
 }
 
 static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
-			  struct cgroup *oldcont, struct task_struct *tsk,
-			  bool threadgroup)
+			  struct cgroup *oldcont, struct task_struct *tsk)
 {
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
-	static nodemask_t to;		/* protected by cgroup_mutex */
 
-	if (cs == &top_cpuset) {
-		cpumask_copy(cpus_attach, cpu_possible_mask);
-	} else {
-		guarantee_online_cpus(cs, cpus_attach);
-	}
-	guarantee_online_mems(cs, &to);
-
-	/* do per-task migration stuff possibly for each in the threadgroup */
-	cpuset_attach_task(tsk, &to, cs);
-	if (threadgroup) {
-		struct task_struct *c;
-		rcu_read_lock();
-		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
-			cpuset_attach_task(c, &to, cs);
-		}
-		rcu_read_unlock();
-	}
-
-	/* change mm; only needs to be done once even if threadgroup */
-	to = cs->mems_allowed;
+	/*
+	 * Change mm, possibly for multiple threads in a threadgroup. This is
+	 * expensive and may sleep.
+	 */
+	cpuset_attach_nodemask_from = oldcs->mems_allowed;
+	cpuset_attach_nodemask_to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
 	if (mm) {
-		mpol_rebind_mm(mm, &to);
+		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
 		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, &oldcs->mems_allowed, &to);
+			cpuset_migrate_mm(mm, &cpuset_attach_nodemask_from,
+					  &cpuset_attach_nodemask_to);
 		mmput(mm);
 	}
 }
@@ -1911,6 +1904,9 @@ struct cgroup_subsys cpuset_subsys = {
 	.create = cpuset_create,
 	.destroy = cpuset_destroy,
 	.can_attach = cpuset_can_attach,
+	.can_attach_task = cpuset_can_attach_task,
+	.pre_attach = cpuset_pre_attach,
+	.attach_task = cpuset_attach_task,
 	.attach = cpuset_attach,
 	.populate = cpuset_populate,
 	.post_clone = cpuset_post_clone,
diff -puN kernel/sched.c~cgroups-add-per-thread-subsystem-callbacks kernel/sched.c
--- a/kernel/sched.c~cgroups-add-per-thread-subsystem-callbacks
+++ a/kernel/sched.c
@@ -8764,42 +8764,10 @@ cpu_cgroup_can_attach_task(struct cgroup
 	return 0;
 }
 
-static int
-cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		      struct task_struct *tsk, bool threadgroup)
-{
-	int retval = cpu_cgroup_can_attach_task(cgrp, tsk);
-	if (retval)
-		return retval;
-	if (threadgroup) {
-		struct task_struct *c;
-		rcu_read_lock();
-		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
-			retval = cpu_cgroup_can_attach_task(cgrp, c);
-			if (retval) {
-				rcu_read_unlock();
-				return retval;
-			}
-		}
-		rcu_read_unlock();
-	}
-	return 0;
-}
-
 static void
-cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		  struct cgroup *old_cont, struct task_struct *tsk,
-		  bool threadgroup)
+cpu_cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
 	sched_move_task(tsk);
-	if (threadgroup) {
-		struct task_struct *c;
-		rcu_read_lock();
-		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
-			sched_move_task(c);
-		}
-		rcu_read_unlock();
-	}
 }
 
 static void
@@ -8887,8 +8855,8 @@ struct cgroup_subsys cpu_cgroup_subsys =
 	.name		= "cpu",
 	.create		= cpu_cgroup_create,
 	.destroy	= cpu_cgroup_destroy,
-	.can_attach	= cpu_cgroup_can_attach,
-	.attach		= cpu_cgroup_attach,
+	.can_attach_task = cpu_cgroup_can_attach_task,
+	.attach_task	= cpu_cgroup_attach_task,
 	.exit		= cpu_cgroup_exit,
 	.populate	= cpu_cgroup_populate,
 	.subsys_id	= cpu_cgroup_subsys_id,
diff -puN mm/memcontrol.c~cgroups-add-per-thread-subsystem-callbacks mm/memcontrol.c
--- a/mm/memcontrol.c~cgroups-add-per-thread-subsystem-callbacks
+++ a/mm/memcontrol.c
@@ -4953,8 +4953,7 @@ static void mem_cgroup_clear_mc(void)
 
 static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
 				struct cgroup *cgroup,
-				struct task_struct *p,
-				bool threadgroup)
+				struct task_struct *p)
 {
 	int ret = 0;
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cgroup);
@@ -4993,8 +4992,7 @@ static int mem_cgroup_can_attach(struct 
 
 static void mem_cgroup_cancel_attach(struct cgroup_subsys *ss,
 				struct cgroup *cgroup,
-				struct task_struct *p,
-				bool threadgroup)
+				struct task_struct *p)
 {
 	mem_cgroup_clear_mc();
 }
@@ -5112,8 +5110,7 @@ retry:
 static void mem_cgroup_move_task(struct cgroup_subsys *ss,
 				struct cgroup *cont,
 				struct cgroup *old_cont,
-				struct task_struct *p,
-				bool threadgroup)
+				struct task_struct *p)
 {
 	struct mm_struct *mm;
 
@@ -5131,22 +5128,19 @@ static void mem_cgroup_move_task(struct 
 #else	/* !CONFIG_MMU */
 static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
 				struct cgroup *cgroup,
-				struct task_struct *p,
-				bool threadgroup)
+				struct task_struct *p)
 {
 	return 0;
 }
 static void mem_cgroup_cancel_attach(struct cgroup_subsys *ss,
 				struct cgroup *cgroup,
-				struct task_struct *p,
-				bool threadgroup)
+				struct task_struct *p)
 {
 }
 static void mem_cgroup_move_task(struct cgroup_subsys *ss,
 				struct cgroup *cont,
 				struct cgroup *old_cont,
-				struct task_struct *p,
-				bool threadgroup)
+				struct task_struct *p)
 {
 }
 #endif
diff -puN security/device_cgroup.c~cgroups-add-per-thread-subsystem-callbacks security/device_cgroup.c
--- a/security/device_cgroup.c~cgroups-add-per-thread-subsystem-callbacks
+++ a/security/device_cgroup.c
@@ -62,8 +62,7 @@ static inline struct dev_cgroup *task_de
 struct cgroup_subsys devices_subsys;
 
 static int devcgroup_can_attach(struct cgroup_subsys *ss,
-		struct cgroup *new_cgroup, struct task_struct *task,
-		bool threadgroup)
+		struct cgroup *new_cgroup, struct task_struct *task)
 {
 	if (current != task && !capable(CAP_SYS_ADMIN))
 			return -EPERM;
_

Patches currently in -mm which might be from bblum@andrew.cmu.edu are

origin.patch

