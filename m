From: akpm@linux-foundation.org
Subject: [obsolete] cgroups-allow-subsystems-to-cancel-a-fork.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:06:42 -0800
Message-ID: <20111214200643.13D2510004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:55233 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab1LNUGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:06:44 -0500
Received: by mail-yw0-f74.google.com with SMTP id j51so241097yhj.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:06:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, kirill@shutemov.name, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: allow subsystems to cancel a fork
has been removed from the -mm tree.  Its filename was
     cgroups-allow-subsystems-to-cancel-a-fork.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: cgroups: allow subsystems to cancel a fork

Let the subsystem's fork callback return an error value so that they can
cancel a fork.  This is going to be used by the task counter subsystem to
implement the limit.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h  |   20 ++++++++++++++------
 kernel/cgroup.c         |   23 +++++++++++++++++++----
 kernel/cgroup_freezer.c |    6 ++++--
 kernel/exit.c           |    2 +-
 kernel/fork.c           |    7 +++++--
 5 files changed, 43 insertions(+), 15 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-allow-subsystems-to-cancel-a-fork include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-allow-subsystems-to-cancel-a-fork
+++ a/include/linux/cgroup.h
@@ -17,10 +17,11 @@
 #include <linux/rwsem.h>
 #include <linux/idr.h>
 
+struct cgroup_subsys;
+
 #ifdef CONFIG_CGROUPS
 
 struct cgroupfs_root;
-struct cgroup_subsys;
 struct inode;
 struct cgroup;
 struct css_id;
@@ -32,9 +33,11 @@ extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_fork_callbacks(struct task_struct *p);
+extern int cgroup_fork_callbacks(struct task_struct *p,
+				 struct cgroup_subsys **failed_ss);
 extern void cgroup_post_fork(struct task_struct *p);
-extern void cgroup_exit(struct task_struct *p, int run_callbacks);
+extern void cgroup_exit(struct task_struct *p, int run_callbacks,
+			struct cgroup_subsys *failed_ss);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
 extern int cgroup_load_subsys(struct cgroup_subsys *ss);
@@ -479,7 +482,7 @@ struct cgroup_subsys {
 			    struct task_struct *tsk);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		       struct cgroup *old_cgrp, struct task_struct *tsk);
-	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
+	int (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
 	void (*exit)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			struct cgroup *old_cgrp, struct task_struct *task);
 	int (*populate)(struct cgroup_subsys *ss,
@@ -636,9 +639,14 @@ struct cgroup_subsys_state *cgroup_css_f
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
-static inline void cgroup_fork_callbacks(struct task_struct *p) {}
+static inline int cgroup_fork_callbacks(struct task_struct *p,
+					struct cgroup_subsys **failed_ss)
+{
+	return 0;
+}
 static inline void cgroup_post_fork(struct task_struct *p) {}
-static inline void cgroup_exit(struct task_struct *p, int callbacks) {}
+static inline void cgroup_exit(struct task_struct *p, int callbacks,
+			       struct cgroup_subsys *failed_ss) {}
 
 static inline void cgroup_lock(void) {}
 static inline void cgroup_unlock(void) {}
diff -puN kernel/cgroup.c~cgroups-allow-subsystems-to-cancel-a-fork kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-allow-subsystems-to-cancel-a-fork
+++ a/kernel/cgroup.c
@@ -4540,8 +4540,11 @@ void cgroup_fork(struct task_struct *chi
  * tasklist. No need to take any locks since no-one can
  * be operating on this task.
  */
-void cgroup_fork_callbacks(struct task_struct *child)
+int cgroup_fork_callbacks(struct task_struct *child,
+			  struct cgroup_subsys **failed_ss)
 {
+	int err;
+
 	if (need_forkexit_callback) {
 		int i;
 		/*
@@ -4551,10 +4554,17 @@ void cgroup_fork_callbacks(struct task_s
 		 */
 		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
-			if (ss->fork)
-				ss->fork(ss, child);
+			if (ss->fork) {
+				err = ss->fork(ss, child);
+				if (err) {
+					*failed_ss = ss;
+					return err;
+				}
+			}
 		}
 	}
+
+	return 0;
 }
 
 /**
@@ -4612,7 +4622,8 @@ void cgroup_post_fork(struct task_struct
  *    which wards off any cgroup_attach_task() attempts, or task is a failed
  *    fork, never visible to cgroup_attach_task.
  */
-void cgroup_exit(struct task_struct *tsk, int run_callbacks)
+void cgroup_exit(struct task_struct *tsk, int run_callbacks,
+		 struct cgroup_subsys *failed_ss)
 {
 	struct css_set *cg;
 	int i;
@@ -4641,6 +4652,10 @@ void cgroup_exit(struct task_struct *tsk
 		 */
 		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
+
+			if (ss == failed_ss)
+				break;
+
 			if (ss->exit) {
 				struct cgroup *old_cgrp =
 					rcu_dereference_raw(cg->subsys[i])->cgroup;
diff -puN kernel/cgroup_freezer.c~cgroups-allow-subsystems-to-cancel-a-fork kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~cgroups-allow-subsystems-to-cancel-a-fork
+++ a/kernel/cgroup_freezer.c
@@ -187,7 +187,7 @@ static int freezer_can_attach_task(struc
 	return cgroup_freezing(tsk) ? -EBUSY : 0;
 }
 
-static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
+static int freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 {
 	struct freezer *freezer;
 
@@ -207,7 +207,7 @@ static void freezer_fork(struct cgroup_s
 	 * following check.
 	 */
 	if (!freezer->css.cgroup->parent)
-		return;
+		return 0;
 
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state == CGROUP_FROZEN);
@@ -216,6 +216,8 @@ static void freezer_fork(struct cgroup_s
 	if (freezer->state == CGROUP_FREEZING)
 		freeze_task(task);
 	spin_unlock_irq(&freezer->lock);
+
+	return 0;
 }
 
 /*
diff -puN kernel/exit.c~cgroups-allow-subsystems-to-cancel-a-fork kernel/exit.c
--- a/kernel/exit.c~cgroups-allow-subsystems-to-cancel-a-fork
+++ a/kernel/exit.c
@@ -990,7 +990,7 @@ void do_exit(long code)
 	 */
 	perf_event_exit_task(tsk);
 
-	cgroup_exit(tsk, 1);
+	cgroup_exit(tsk, 1, NULL);
 
 	if (group_dead)
 		disassociate_ctty(1);
diff -puN kernel/fork.c~cgroups-allow-subsystems-to-cancel-a-fork kernel/fork.c
--- a/kernel/fork.c~cgroups-allow-subsystems-to-cancel-a-fork
+++ a/kernel/fork.c
@@ -1061,6 +1061,7 @@ static struct task_struct *copy_process(
 	int retval;
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
+	struct cgroup_subsys *cgroup_failed_ss = NULL;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1318,8 +1319,10 @@ static struct task_struct *copy_process(
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
-	cgroup_fork_callbacks(p);
+	retval = cgroup_fork_callbacks(p, &cgroup_failed_ss);
 	cgroup_callbacks_done = 1;
+	if (retval)
+		goto bad_fork_free_pid;
 
 	/* Need tasklist lock for parent etc handling! */
 	write_lock_irq(&tasklist_lock);
@@ -1420,7 +1423,7 @@ bad_fork_cleanup_cgroup:
 #endif
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_fork_read_unlock(current);
-	cgroup_exit(p, cgroup_callbacks_done);
+	cgroup_exit(p, cgroup_callbacks_done, cgroup_failed_ss);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
reiserfs-delay-reiserfs-lock-until-journal-initialization.patch
reiserfs-dont-lock-journal_init.patch
reiserfs-dont-lock-root-inode-searching.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-a-task-counter-subsystem-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
selftests-new-x86-breakpoints-selftest.patch

