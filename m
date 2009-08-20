From: akpm@linux-foundation.org
Subject: + cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:14:19 -0700
Message-ID: <200908202114.n7KLEJDY026442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754457AbZHTVPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:15:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bblum@google.com, a.p.zijlstra@chello.nl, ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, mingo@elte.hu, oleg@redhat.com


The patch titled
     cgroups: let ss->can_attach and ss->attach do whole threadgroups at a time
has been added to the -mm tree.  Its filename is
     cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch

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
Subject: cgroups: let ss->can_attach and ss->attach do whole threadgroups at a time
From: Ben Blum <bblum@google.com>

Alter the ss->can_attach and ss->attach functions to be able to deal with
a whole threadgroup at a time, for use in cgroup_attach_proc.  (This is a
pre-patch to cgroup-procs-writable.patch.)

Currently, new mode of the attach function can only tell the subsystem
about the old cgroup of the threadgroup leader.  No subsystem currently
needs that information for each thread that's being moved, but if one were
to be added (for example, one that counts tasks within a group) this bit
would need to be reworked a bit to tell the subsystem the right
information.

Signed-off-by: Ben Blum <bblum@google.com>
Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |   12 +++--
 include/linux/cgroup.h            |    7 +-
 kernel/cgroup.c                   |    4 -
 kernel/cgroup_freezer.c           |   15 +++++-
 kernel/cpuset.c                   |   66 ++++++++++++++++++++++------
 kernel/ns_cgroup.c                |   16 +++++-
 kernel/sched.c                    |   35 +++++++++++++-
 mm/memcontrol.c                   |    3 -
 security/device_cgroup.c          |    3 -
 9 files changed, 131 insertions(+), 30 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time
+++ a/Documentation/cgroups/cgroups.txt
@@ -521,7 +521,7 @@ rmdir() will fail with it. From this beh
 called multiple times against a cgroup.
 
 int can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-	       struct task_struct *task)
+	       struct task_struct *task, bool threadgroup)
 (cgroup_mutex held by caller)
 
 Called prior to moving a task into a cgroup; if the subsystem
@@ -529,14 +529,20 @@ returns an error, this will abort the at
 task is passed, then a successful result indicates that *any*
 unspecified task can be moved into the cgroup. Note that this isn't
 called on a fork. If this method returns 0 (success) then this should
-remain valid while the caller holds cgroup_mutex.
+remain valid while the caller holds cgroup_mutex. If threadgroup is
+true, then a successful result indicates that all threads in the given
+thread's threadgroup can be moved together.
 
 void attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-	    struct cgroup *old_cgrp, struct task_struct *task)
+	    struct cgroup *old_cgrp, struct task_struct *task,
+	    bool threadgroup)
 (cgroup_mutex held by caller)
 
 Called after the task has been attached to the cgroup, to allow any
 post-attachment activity that requires memory allocations or blocking.
+If threadgroup is true, the subsystem should take care of all threads
+in the specified thread's threadgroup. Currently does not support any
+subsystem that might need the old_cgrp for every thread in the group.
 
 void fork(struct cgroup_subsy *ss, struct task_struct *task)
 
diff -puN include/linux/cgroup.h~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time
+++ a/include/linux/cgroup.h
@@ -425,10 +425,11 @@ struct cgroup_subsys {
 						  struct cgroup *cgrp);
 	int (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
-	int (*can_attach)(struct cgroup_subsys *ss,
-			  struct cgroup *cgrp, struct task_struct *tsk);
+	int (*can_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			  struct task_struct *tsk, bool threadgroup);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
-			struct cgroup *old_cgrp, struct task_struct *tsk);
+			struct cgroup *old_cgrp, struct task_struct *tsk,
+			bool threadgroup);
 	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
 	void (*exit)(struct cgroup_subsys *ss, struct task_struct *task);
 	int (*populate)(struct cgroup_subsys *ss,
diff -puN kernel/cgroup.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time
+++ a/kernel/cgroup.c
@@ -1552,7 +1552,7 @@ int cgroup_attach_task(struct cgroup *cg
 
 	for_each_subsys(root, ss) {
 		if (ss->can_attach) {
-			retval = ss->can_attach(ss, cgrp, tsk);
+			retval = ss->can_attach(ss, cgrp, tsk, false);
 			if (retval)
 				return retval;
 		}
@@ -1590,7 +1590,7 @@ int cgroup_attach_task(struct cgroup *cg
 
 	for_each_subsys(root, ss) {
 		if (ss->attach)
-			ss->attach(ss, cgrp, oldcgrp, tsk);
+			ss->attach(ss, cgrp, oldcgrp, tsk, false);
 	}
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
 	synchronize_rcu();
diff -puN kernel/cgroup_freezer.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time
+++ a/kernel/cgroup_freezer.c
@@ -159,7 +159,7 @@ static bool is_task_frozen_enough(struct
  */
 static int freezer_can_attach(struct cgroup_subsys *ss,
 			      struct cgroup *new_cgroup,
-			      struct task_struct *task)
+			      struct task_struct *task, bool threadgroup)
 {
 	struct freezer *freezer;
 
@@ -177,6 +177,19 @@ static int freezer_can_attach(struct cgr
 	if (freezer->state == CGROUP_FROZEN)
 		return -EBUSY;
 
+	if (threadgroup) {
+		struct task_struct *c;
+
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
+			if (is_task_frozen_enough(c)) {
+				rcu_read_unlock();
+				return -EBUSY;
+			}
+		}
+		rcu_read_unlock();
+	}
+
 	return 0;
 }
 
diff -puN kernel/cpuset.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time kernel/cpuset.c
--- a/kernel/cpuset.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time
+++ a/kernel/cpuset.c
@@ -1324,9 +1324,10 @@ static int fmeter_getrate(struct fmeter 
 static cpumask_var_t cpus_attach;
 
 /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
-static int cpuset_can_attach(struct cgroup_subsys *ss,
-			     struct cgroup *cont, struct task_struct *tsk)
+static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
+			     struct task_struct *tsk, bool threadgroup)
 {
+	int ret;
 	struct cpuset *cs = cgroup_cs(cont);
 
 	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
@@ -1343,18 +1344,51 @@ static int cpuset_can_attach(struct cgro
 	if (tsk->flags & PF_THREAD_BOUND)
 		return -EINVAL;
 
-	return security_task_setscheduler(tsk, 0, NULL);
+	ret = security_task_setscheduler(tsk, 0, NULL);
+	if (ret)
+		return ret;
+	if (threadgroup) {
+		struct task_struct *c;
+
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
+			ret = security_task_setscheduler(c, 0, NULL);
+			if (ret) {
+				rcu_read_unlock();
+				return ret;
+			}
+		}
+		rcu_read_unlock();
+	}
+	return 0;
 }
 
-static void cpuset_attach(struct cgroup_subsys *ss,
-			  struct cgroup *cont, struct cgroup *oldcont,
-			  struct task_struct *tsk)
+static void cpuset_attach_task(struct task_struct *tsk, nodemask_t *to,
+			       struct cpuset *cs)
+{
+	int err;
+	/*
+	 * can_attach beforehand should guarantee that this doesn't fail.
+	 * TODO: have a better way to handle failure here
+	 */
+	err = set_cpus_allowed_ptr(tsk, cpus_attach);
+	WARN_ON_ONCE(err);
+
+	task_lock(tsk);
+	cpuset_change_task_nodemask(tsk, to);
+	task_unlock(tsk);
+	cpuset_update_task_spread_flag(cs, tsk);
+
+}
+
+static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
+			  struct cgroup *oldcont, struct task_struct *tsk,
+			  bool threadgroup)
 {
 	nodemask_t from, to;
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
-	int err;
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
@@ -1363,15 +1397,19 @@ static void cpuset_attach(struct cgroup_
 		guarantee_online_cpus(cs, cpus_attach);
 		guarantee_online_mems(cs, &to);
 	}
-	err = set_cpus_allowed_ptr(tsk, cpus_attach);
-	if (err)
-		return;
 
-	task_lock(tsk);
-	cpuset_change_task_nodemask(tsk, &to);
-	task_unlock(tsk);
-	cpuset_update_task_spread_flag(cs, tsk);
+	/* do per-task migration stuff possibly for each in the threadgroup */
+	cpuset_attach_task(tsk, &to, cs);
+	if (threadgroup) {
+		struct task_struct *c;
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
+			cpuset_attach_task(c, &to, cs);
+		}
+		rcu_read_unlock();
+	}
 
+	/* change mm; only needs to be done once even if threadgroup */
 	from = oldcs->mems_allowed;
 	to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
diff -puN kernel/ns_cgroup.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time kernel/ns_cgroup.c
--- a/kernel/ns_cgroup.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time
+++ a/kernel/ns_cgroup.c
@@ -42,8 +42,8 @@ int ns_cgroup_clone(struct task_struct *
  *       (hence either you are in the same cgroup as task, or in an
  *        ancestor cgroup thereof)
  */
-static int ns_can_attach(struct cgroup_subsys *ss,
-		struct cgroup *new_cgroup, struct task_struct *task)
+static int ns_can_attach(struct cgroup_subsys *ss, struct cgroup *new_cgroup,
+			 struct task_struct *task, bool threadgroup)
 {
 	if (current != task) {
 		if (!capable(CAP_SYS_ADMIN))
@@ -56,6 +56,18 @@ static int ns_can_attach(struct cgroup_s
 	if (!cgroup_is_descendant(new_cgroup, task))
 		return -EPERM;
 
+	if (threadgroup) {
+		struct task_struct *c;
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
+			if (!cgroup_is_descendant(new_cgroup, c)) {
+				rcu_read_unlock();
+				return -EPERM;
+			}
+		}
+		rcu_read_unlock();
+	}
+
 	return 0;
 }
 
diff -puN kernel/sched.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time kernel/sched.c
--- a/kernel/sched.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time
+++ a/kernel/sched.c
@@ -10411,8 +10411,7 @@ cpu_cgroup_destroy(struct cgroup_subsys 
 }
 
 static int
-cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		      struct task_struct *tsk)
+cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
@@ -10422,15 +10421,45 @@ cpu_cgroup_can_attach(struct cgroup_subs
 	if (tsk->sched_class != &fair_sched_class)
 		return -EINVAL;
 #endif
+	return 0;
+}
 
+static int
+cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
+		      struct task_struct *tsk, bool threadgroup)
+{
+	int retval = cpu_cgroup_can_attach_task(cgrp, tsk);
+	if (retval)
+		return retval;
+	if (threadgroup) {
+		struct task_struct *c;
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
+			retval = cpu_cgroup_can_attach_task(cgrp, c);
+			if (retval) {
+				rcu_read_unlock();
+				return retval;
+			}
+		}
+		rcu_read_unlock();
+	}
 	return 0;
 }
 
 static void
 cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-			struct cgroup *old_cont, struct task_struct *tsk)
+		  struct cgroup *old_cont, struct task_struct *tsk
+		  bool threadgroup)
 {
 	sched_move_task(tsk);
+	if (threadgroup) {
+		struct task_struct *c;
+		rcu_read_lock();
+		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
+			sched_move_task(c);
+		}
+		rcu_read_unlock();
+	}
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff -puN mm/memcontrol.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time mm/memcontrol.c
--- a/mm/memcontrol.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time
+++ a/mm/memcontrol.c
@@ -2612,7 +2612,8 @@ static int mem_cgroup_populate(struct cg
 static void mem_cgroup_move_task(struct cgroup_subsys *ss,
 				struct cgroup *cont,
 				struct cgroup *old_cont,
-				struct task_struct *p)
+				struct task_struct *p,
+				bool threadgroup)
 {
 	mutex_lock(&memcg_tasklist);
 	/*
diff -puN security/device_cgroup.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time security/device_cgroup.c
--- a/security/device_cgroup.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time
+++ a/security/device_cgroup.c
@@ -61,7 +61,8 @@ static inline struct dev_cgroup *task_de
 struct cgroup_subsys devices_subsys;
 
 static int devcgroup_can_attach(struct cgroup_subsys *ss,
-		struct cgroup *new_cgroup, struct task_struct *task)
+		struct cgroup *new_cgroup, struct task_struct *task,
+		bool threadgroup)
 {
 	if (current != task && !capable(CAP_SYS_ADMIN))
 			return -EPERM;
_

Patches currently in -mm which might be from bblum@google.com are

cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch

