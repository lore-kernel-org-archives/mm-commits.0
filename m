From: akpm@linux-foundation.org
Subject: - cgroups-relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch removed from -mm tree
Date: Fri, 19 Dec 2008 15:16:58 -0800
Message-ID: <200812192316.mBJNGxbW012070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbYLSXRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Dec 2008 18:17:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: root@localdomain.pl, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: relax ns_can_attach checks to allow attaching to grandchild cgroups
has been removed from the -mm tree.  Its filename was
     cgroups-relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch

This patch was dropped because an updated version will be merged

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

Signed-off-by: Grzegorz Nosek <root@localdomain.pl>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    4 ++--
 kernel/cgroup.c        |   12 +++++++-----
 kernel/ns_cgroup.c     |    9 +++------
 3 files changed, 12 insertions(+), 13 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups
+++ a/include/linux/cgroup.h
@@ -309,8 +309,8 @@ int cgroup_path(const struct cgroup *cgr
 
 int cgroup_task_count(const struct cgroup *cgrp);
 
-/* Return true if the cgroup is a descendant of the current cgroup */
-int cgroup_is_descendant(const struct cgroup *cgrp);
+/* Return true if cgrp is a descendant of the task's cgroup */
+int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task);
 
 /* Control Group subsystem type. See Documentation/cgroups.txt for details */
 
diff -puN kernel/cgroup.c~cgroups-relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups
+++ a/kernel/cgroup.c
@@ -3024,18 +3024,19 @@ int cgroup_clone(struct task_struct *tsk
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
@@ -3045,7 +3046,8 @@ int cgroup_is_descendant(const struct cg
 		return 1;
 
 	get_first_subsys(cgrp, NULL, &subsys_id);
-	target = task_cgroup(current, subsys_id);
+	target = task_cgroup(task, subsys_id);
+
 	while (cgrp != target && cgrp!= cgrp->top_cgroup)
 		cgrp = cgrp->parent;
 	ret = (cgrp == target);
diff -puN kernel/ns_cgroup.c~cgroups-relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups kernel/ns_cgroup.c
--- a/kernel/ns_cgroup.c~cgroups-relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups
+++ a/kernel/ns_cgroup.c
@@ -46,21 +46,18 @@ int ns_cgroup_clone(struct task_struct *
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
 
 	if (atomic_read(&new_cgroup->count) != 0)
 		return -EPERM;
 
-	orig = task_cgroup(task, ns_subsys_id);
-	if (orig && orig != new_cgroup->parent)
+	if (!cgroup_is_descendant(new_cgroup, task))
 		return -EPERM;
 
 	return 0;
@@ -78,7 +75,7 @@ static struct cgroup_subsys_state *ns_cr
 
 	if (!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
-	if (!cgroup_is_descendant(cgroup))
+	if (!cgroup_is_descendant(cgroup, current))
 		return ERR_PTR(-EPERM);
 
 	ns_cgroup = kzalloc(sizeof(*ns_cgroup), GFP_KERNEL);
_

Patches currently in -mm which might be from root@localdomain.pl are

cgroups-relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch

