From: akpm@linux-foundation.org
Subject: [merged] memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:32 -0800
Message-ID: <20130225205332.B577631C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:53279 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759747Ab3BYUxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:34 -0500
Received: by mail-qe0-f73.google.com with SMTP id 3so70565qea.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: replace cgroup_lock with memcg specific memcg_lock
has been removed from the -mm tree.  Its filename was
     memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: replace cgroup_lock with memcg specific memcg_lock

After the preparation work done in earlier patches, the cgroup_lock can be
trivially replaced with a memcg-specific lock.  This is an automatic
translation at every site where the values involved were queried.

The sites where values are written, however, used to be naturally called
under cgroup_lock.  This is the case for instance in the css_online
callback.  For those, we now need to explicitly add the memcg lock.

With this, all the calls to cgroup_lock outside cgroup core are gone.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff -puN mm/memcontrol.c~memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock
+++ a/mm/memcontrol.c
@@ -488,6 +488,13 @@ enum res_type {
 #define MEM_CGROUP_RECLAIM_SHRINK_BIT	0x1
 #define MEM_CGROUP_RECLAIM_SHRINK	(1 << MEM_CGROUP_RECLAIM_SHRINK_BIT)
 
+/*
+ * The memcg_create_mutex will be held whenever a new cgroup is created.
+ * As a consequence, any change that needs to protect against new child cgroups
+ * appearing has to hold it as well.
+ */
+static DEFINE_MUTEX(memcg_create_mutex);
+
 static void mem_cgroup_get(struct mem_cgroup *memcg);
 static void mem_cgroup_put(struct mem_cgroup *memcg);
 
@@ -4778,8 +4785,8 @@ static inline bool __memcg_has_children(
 }
 
 /*
- * Must be called with cgroup_lock held, unless the cgroup is guaranteed to be
- * already dead (in mem_cgroup_force_empty(), for instance).  This is different
+ * Must be called with memcg_create_mutex held, unless the cgroup is guaranteed
+ * to be already dead (as in mem_cgroup_force_empty, for instance).  This is
  * from mem_cgroup_count_children(), in the sense that we don't really care how
  * many children we have; we only need to know if we have any.  It also counts
  * any memcg without hierarchy as infertile.
@@ -4859,7 +4866,7 @@ static int mem_cgroup_hierarchy_write(st
 	if (parent)
 		parent_memcg = mem_cgroup_from_cont(parent);
 
-	cgroup_lock();
+	mutex_lock(&memcg_create_mutex);
 
 	if (memcg->use_hierarchy == val)
 		goto out;
@@ -4882,7 +4889,7 @@ static int mem_cgroup_hierarchy_write(st
 		retval = -EINVAL;
 
 out:
-	cgroup_unlock();
+	mutex_unlock(&memcg_create_mutex);
 
 	return retval;
 }
@@ -4981,14 +4988,8 @@ static int memcg_update_kmem_limit(struc
 	 *
 	 * After it first became limited, changes in the value of the limit are
 	 * of course permitted.
-	 *
-	 * Taking the cgroup_lock is really offensive, but it is so far the only
-	 * way to guarantee that no children will appear. There are plenty of
-	 * other offenders, and they should all go away. Fine grained locking
-	 * is probably the way to go here. When we are fully hierarchical, we
-	 * can also get rid of the use_hierarchy check.
 	 */
-	cgroup_lock();
+	mutex_lock(&memcg_create_mutex);
 	mutex_lock(&set_limit_mutex);
 	if (!memcg->kmem_account_flags && val != RESOURCE_MAX) {
 		if (cgroup_task_count(cont) || memcg_has_children(memcg)) {
@@ -5015,7 +5016,7 @@ static int memcg_update_kmem_limit(struc
 		ret = res_counter_set_limit(&memcg->kmem, val);
 out:
 	mutex_unlock(&set_limit_mutex);
-	cgroup_unlock();
+	mutex_unlock(&memcg_create_mutex);
 
 	/*
 	 * We are by now familiar with the fact that we can't inc the static
@@ -5396,17 +5397,17 @@ static int mem_cgroup_swappiness_write(s
 
 	parent = mem_cgroup_from_cont(cgrp->parent);
 
-	cgroup_lock();
+	mutex_lock(&memcg_create_mutex);
 
 	/* If under hierarchy, only empty-root can set this value */
 	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
-		cgroup_unlock();
+		mutex_unlock(&memcg_create_mutex);
 		return -EINVAL;
 	}
 
 	memcg->swappiness = val;
 
-	cgroup_unlock();
+	mutex_unlock(&memcg_create_mutex);
 
 	return 0;
 }
@@ -5732,16 +5733,16 @@ static int mem_cgroup_oom_control_write(
 
 	parent = mem_cgroup_from_cont(cgrp->parent);
 
-	cgroup_lock();
+	mutex_lock(&memcg_create_mutex);
 	/* oom-kill-disable is a flag for subhierarchy. */
 	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
-		cgroup_unlock();
+		mutex_unlock(&memcg_create_mutex);
 		return -EINVAL;
 	}
 	memcg->oom_kill_disable = val;
 	if (!val)
 		memcg_oom_recover(memcg);
-	cgroup_unlock();
+	mutex_unlock(&memcg_create_mutex);
 	return 0;
 }
 
@@ -6170,6 +6171,7 @@ mem_cgroup_css_online(struct cgroup *con
 	if (!cont->parent)
 		return 0;
 
+	mutex_lock(&memcg_create_mutex);
 	memcg = mem_cgroup_from_cont(cont);
 	parent = mem_cgroup_from_cont(cont->parent);
 
@@ -6203,6 +6205,7 @@ mem_cgroup_css_online(struct cgroup *con
 	}
 
 	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
+	mutex_unlock(&memcg_create_mutex);
 	if (error) {
 		/*
 		 * We call put now because our (and parent's) refcnts
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

