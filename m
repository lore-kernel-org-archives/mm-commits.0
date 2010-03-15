From: akpm@linux-foundation.org
Subject: [merged] cgroup-introduce-cancel_attach.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:07 -0400
Message-ID: <201003150658.o2F6wel8016474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247Ab0COG7K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: introduce cancel_attach()
has been removed from the -mm tree.  Its filename was
     cgroup-introduce-cancel_attach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: introduce cancel_attach()
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Add cancel_attach() operation to struct cgroup_subsys.  cancel_attach()
can be used when can_attach() operation prepares something for the subsys,
but we should rollback what can_attach() operation has prepared if attach
task fails after we've succeeded in can_attach().

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |   13 ++++++++-
 include/linux/cgroup.h            |    2 +
 kernel/cgroup.c                   |   40 +++++++++++++++++++++++-----
 3 files changed, 47 insertions(+), 8 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroup-introduce-cancel_attach Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroup-introduce-cancel_attach
+++ a/Documentation/cgroups/cgroups.txt
@@ -536,10 +536,21 @@ returns an error, this will abort the at
 task is passed, then a successful result indicates that *any*
 unspecified task can be moved into the cgroup. Note that this isn't
 called on a fork. If this method returns 0 (success) then this should
-remain valid while the caller holds cgroup_mutex. If threadgroup is
+remain valid while the caller holds cgroup_mutex and it is ensured that either
+attach() or cancel_attach() will be called in future. If threadgroup is
 true, then a successful result indicates that all threads in the given
 thread's threadgroup can be moved together.
 
+void cancel_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
+	       struct task_struct *task, bool threadgroup)
+(cgroup_mutex held by caller)
+
+Called when a task attach operation has failed after can_attach() has succeeded.
+A subsystem whose can_attach() has some side-effects should provide this
+function, so that the subsytem can implement a rollback. If not, not necessary.
+This will be called only about subsystems whose can_attach() operation have
+succeeded.
+
 void attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	    struct cgroup *old_cgrp, struct task_struct *task,
 	    bool threadgroup)
diff -puN include/linux/cgroup.h~cgroup-introduce-cancel_attach include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-introduce-cancel_attach
+++ a/include/linux/cgroup.h
@@ -428,6 +428,8 @@ struct cgroup_subsys {
 	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	int (*can_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			  struct task_struct *tsk, bool threadgroup);
+	void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			  struct task_struct *tsk, bool threadgroup);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			struct cgroup *old_cgrp, struct task_struct *tsk,
 			bool threadgroup);
diff -puN kernel/cgroup.c~cgroup-introduce-cancel_attach kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-introduce-cancel_attach
+++ a/kernel/cgroup.c
@@ -1554,7 +1554,7 @@ int cgroup_path(const struct cgroup *cgr
 int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
 	int retval = 0;
-	struct cgroup_subsys *ss;
+	struct cgroup_subsys *ss, *failed_ss = NULL;
 	struct cgroup *oldcgrp;
 	struct css_set *cg;
 	struct css_set *newcg;
@@ -1568,8 +1568,16 @@ int cgroup_attach_task(struct cgroup *cg
 	for_each_subsys(root, ss) {
 		if (ss->can_attach) {
 			retval = ss->can_attach(ss, cgrp, tsk, false);
-			if (retval)
-				return retval;
+			if (retval) {
+				/*
+				 * Remember on which subsystem the can_attach()
+				 * failed, so that we only call cancel_attach()
+				 * against the subsystems whose can_attach()
+				 * succeeded. (See below)
+				 */
+				failed_ss = ss;
+				goto out;
+			}
 		}
 	}
 
@@ -1583,14 +1591,17 @@ int cgroup_attach_task(struct cgroup *cg
 	 */
 	newcg = find_css_set(cg, cgrp);
 	put_css_set(cg);
-	if (!newcg)
-		return -ENOMEM;
+	if (!newcg) {
+		retval = -ENOMEM;
+		goto out;
+	}
 
 	task_lock(tsk);
 	if (tsk->flags & PF_EXITING) {
 		task_unlock(tsk);
 		put_css_set(newcg);
-		return -ESRCH;
+		retval = -ESRCH;
+		goto out;
 	}
 	rcu_assign_pointer(tsk->cgroups, newcg);
 	task_unlock(tsk);
@@ -1616,7 +1627,22 @@ int cgroup_attach_task(struct cgroup *cg
 	 * is no longer empty.
 	 */
 	cgroup_wakeup_rmdir_waiter(cgrp);
-	return 0;
+out:
+	if (retval) {
+		for_each_subsys(root, ss) {
+			if (ss == failed_ss)
+				/*
+				 * This subsystem was the one that failed the
+				 * can_attach() check earlier, so we don't need
+				 * to call cancel_attach() against it or any
+				 * remaining subsystems.
+				 */
+				break;
+			if (ss->cancel_attach)
+				ss->cancel_attach(ss, cgrp, tsk, false);
+		}
+	}
+	return retval;
 }
 
 /*
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch

