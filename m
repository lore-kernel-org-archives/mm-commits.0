From: akpm@linux-foundation.org
Subject: [merged] memcg-fast-hierarchy-aware-child-test.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:29 -0800
Message-ID: <20130225205329.C8D2D31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:57470 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759742Ab3BYUxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:31 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so348086yhr.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fast hierarchy-aware child test
has been removed from the -mm tree.  Its filename was
     memcg-fast-hierarchy-aware-child-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: fast hierarchy-aware child test

Currently, we use cgroups' provided list of children to verify if it is
safe to proceed with any value change that is dependent on the cgroup
being empty.

This is less than ideal, because it enforces a dependency over cgroup core
that we would be better off without.  The solution proposed here is to
iterate over the child cgroups and if any is found that is already online,
we bounce and return: we don't really care how many children we have, only
if we have any.

This is also made to be hierarchy aware.  IOW, cgroups with hierarchy
disabled, while they still exist, will be considered for the purpose of
this interface as having no children.

[akpm@linux-foundation.org: tweak comments]
Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-fast-hierarchy-aware-child-test mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fast-hierarchy-aware-child-test
+++ a/mm/memcontrol.c
@@ -4763,6 +4763,33 @@ static void mem_cgroup_reparent_charges(
 }
 
 /*
+ * This mainly exists for tests during the setting of set of use_hierarchy.
+ * Since this is the very setting we are changing, the current hierarchy value
+ * is meaningless
+ */
+static inline bool __memcg_has_children(struct mem_cgroup *memcg)
+{
+	struct cgroup *pos;
+
+	/* bounce at first found */
+	cgroup_for_each_child(pos, memcg->css.cgroup)
+		return true;
+	return false;
+}
+
+/*
+ * Must be called with cgroup_lock held, unless the cgroup is guaranteed to be
+ * already dead (in mem_cgroup_force_empty(), for instance).  This is different
+ * from mem_cgroup_count_children(), in the sense that we don't really care how
+ * many children we have; we only need to know if we have any.  It also counts
+ * any memcg without hierarchy as infertile.
+ */
+static inline bool memcg_has_children(struct mem_cgroup *memcg)
+{
+	return memcg->use_hierarchy && __memcg_has_children(memcg);
+}
+
+/*
  * Reclaims as many pages from the given memcg as possible and moves
  * the rest to the parent.
  *
@@ -4847,7 +4874,7 @@ static int mem_cgroup_hierarchy_write(st
 	 */
 	if ((!parent_memcg || !parent_memcg->use_hierarchy) &&
 				(val == 1 || val == 0)) {
-		if (list_empty(&cont->children))
+		if (!__memcg_has_children(memcg))
 			memcg->use_hierarchy = val;
 		else
 			retval = -EBUSY;
@@ -4964,8 +4991,7 @@ static int memcg_update_kmem_limit(struc
 	cgroup_lock();
 	mutex_lock(&set_limit_mutex);
 	if (!memcg->kmem_account_flags && val != RESOURCE_MAX) {
-		if (cgroup_task_count(cont) || (memcg->use_hierarchy &&
-						!list_empty(&cont->children))) {
+		if (cgroup_task_count(cont) || memcg_has_children(memcg)) {
 			ret = -EBUSY;
 			goto out;
 		}
@@ -5373,8 +5399,7 @@ static int mem_cgroup_swappiness_write(s
 	cgroup_lock();
 
 	/* If under hierarchy, only empty-root can set this value */
-	if ((parent->use_hierarchy) ||
-	    (memcg->use_hierarchy && !list_empty(&cgrp->children))) {
+	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
 		cgroup_unlock();
 		return -EINVAL;
 	}
@@ -5709,8 +5734,7 @@ static int mem_cgroup_oom_control_write(
 
 	cgroup_lock();
 	/* oom-kill-disable is a flag for subhierarchy. */
-	if ((parent->use_hierarchy) ||
-	    (memcg->use_hierarchy && !list_empty(&cgrp->children))) {
+	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
 		cgroup_unlock();
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

