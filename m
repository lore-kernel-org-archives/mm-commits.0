From: akpm@linux-foundation.org
Subject: [merged] relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:04 -0700
Message-ID: <200904061934.n36JY4Xo011365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756396AbZDFThr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: root@localdomain.pl, lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: relax ns_can_attach checks to allow attaching to grandchild cgroups
has been removed from the -mm tree.  Its filename was
     relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: relax ns_can_attach checks to allow attaching to grandchild cgroups
From: Grzegorz Nosek <root@localdomain.pl>

The ns_proxy cgroup allows moving processes to child cgroups only one
level deep at a time.  This commit relaxes this restriction and makes it
possible to attach tasks directly to grandchild cgroups, e.g.:

($pid is in the root cgroup)
echo $pid > /cgroup/CG1/CG2/tasks

Previously this operation would fail with -EPERM and would have to be
performed as two steps:
echo $pid > /cgroup/CG1/tasks
echo $pid > /cgroup/CG1/CG2/tasks

Also, the target cgroup no longer needs to be empty to move a task there.

Signed-off-by: Grzegorz Nosek <root@localdomain.pl>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    4 ++--
 kernel/cgroup.c        |   11 ++++++-----
 kernel/ns_cgroup.c     |   14 ++++----------
 3 files changed, 12 insertions(+), 17 deletions(-)

diff -puN include/linux/cgroup.h~relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups include/linux/cgroup.h
--- a/include/linux/cgroup.h~relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups
+++ a/include/linux/cgroup.h
@@ -348,8 +348,8 @@ int cgroup_path(const struct cgroup *cgr
 
 int cgroup_task_count(const struct cgroup *cgrp);
 
-/* Return true if the cgroup is a descendant of the current cgroup */
-int cgroup_is_descendant(const struct cgroup *cgrp);
+/* Return true if cgrp is a descendant of the task's cgroup */
+int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task);
 
 /* Control Group subsystem type. See Documentation/cgroups.txt for details */
 
diff -puN kernel/cgroup.c~relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups kernel/cgroup.c
--- a/kernel/cgroup.c~relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups
+++ a/kernel/cgroup.c
@@ -3084,18 +3084,19 @@ int cgroup_clone(struct task_struct *tsk
 }
 
 /**
- * cgroup_is_descendant - see if @cgrp is a descendant of current task's cgrp
+ * cgroup_is_descendant - see if @cgrp is a descendant of @task's cgrp
  * @cgrp: the cgroup in question
+ * @task: the task in question
  *
- * See if @cgrp is a descendant of the current task's cgroup in
- * the appropriate hierarchy.
+ * See if @cgrp is a descendant of @task's cgroup in the appropriate
+ * hierarchy.
  *
  * If we are sending in dummytop, then presumably we are creating
  * the top cgroup in the subsystem.
  *
  * Called only by the ns (nsproxy) cgroup.
  */
-int cgroup_is_descendant(const struct cgroup *cgrp)
+int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task)
 {
 	int ret;
 	struct cgroup *target;
@@ -3105,7 +3106,7 @@ int cgroup_is_descendant(const struct cg
 		return 1;
 
 	get_first_subsys(cgrp, NULL, &subsys_id);
-	target = task_cgroup(current, subsys_id);
+	target = task_cgroup(task, subsys_id);
 	while (cgrp != target && cgrp!= cgrp->top_cgroup)
 		cgrp = cgrp->parent;
 	ret = (cgrp == target);
diff -puN kernel/ns_cgroup.c~relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups kernel/ns_cgroup.c
--- a/kernel/ns_cgroup.c~relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups
+++ a/kernel/ns_cgroup.c
@@ -34,7 +34,7 @@ int ns_cgroup_clone(struct task_struct *
 
 /*
  * Rules:
- *   1. you can only enter a cgroup which is a child of your current
+ *   1. you can only enter a cgroup which is a descendant of your current
  *     cgroup
  *   2. you can only place another process into a cgroup if
  *     a. you have CAP_SYS_ADMIN
@@ -45,21 +45,15 @@ int ns_cgroup_clone(struct task_struct *
 static int ns_can_attach(struct cgroup_subsys *ss,
 		struct cgroup *new_cgroup, struct task_struct *task)
 {
-	struct cgroup *orig;
-
 	if (current != task) {
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		if (!cgroup_is_descendant(new_cgroup))
+		if (!cgroup_is_descendant(new_cgroup, current))
 			return -EPERM;
 	}
 
-	if (atomic_read(&new_cgroup->count) != 0)
-		return -EPERM;
