From: akpm@linux-foundation.org
Subject: [merged] memcg-split-part-of-memcg-creation-to-css_online.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:26 -0800
Message-ID: <20130225205326.CBFBF5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:48424 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759742Ab3BYUx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:28 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so159182yen.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: split part of memcg creation to css_online
has been removed from the -mm tree.  Its filename was
     memcg-split-part-of-memcg-creation-to-css_online.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: split part of memcg creation to css_online

This patch is a preparatory work for later locking rework to get rid of
big cgroup lock from memory controller code.

The memory controller uses some tunables to adjust its operation.  Those
tunables are inherited from parent to children upon children
intialization.  For most of them, the value cannot be changed after the
parent has a new children.

cgroup core splits initialization in two phases: css_alloc and css_online.
 After css_alloc, the memory allocation and basic initialization are done.
 But the new group is not yet visible anywhere, not even for cgroup core
code.  It is only somewhere between css_alloc and css_online that it is
inserted into the internal children lists.  Copying tunable values in
css_alloc will lead to inconsistent values: the children will copy the old
parent values, that can change between the copy and the moment in which
the groups is linked to any data structure that can indicate the presence
of children.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   62 +++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~memcg-split-part-of-memcg-creation-to-css_online mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-split-part-of-memcg-creation-to-css_online
+++ a/mm/memcontrol.c
@@ -6093,7 +6093,7 @@ err_cleanup:
 static struct cgroup_subsys_state * __ref
 mem_cgroup_css_alloc(struct cgroup *cont)
 {
-	struct mem_cgroup *memcg, *parent;
+	struct mem_cgroup *memcg;
 	long error = -ENOMEM;
 	int node;
 
@@ -6108,7 +6108,7 @@ mem_cgroup_css_alloc(struct cgroup *cont
 	/* root ? */
 	if (cont->parent == NULL) {
 		int cpu;
-		parent = NULL;
+
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
 		root_mem_cgroup = memcg;
@@ -6117,13 +6117,43 @@ mem_cgroup_css_alloc(struct cgroup *cont
 						&per_cpu(memcg_stock, cpu);
 			INIT_WORK(&stock->work, drain_local_stock);
 		}
-	} else {
-		parent = mem_cgroup_from_cont(cont->parent);
-		memcg->use_hierarchy = parent->use_hierarchy;
-		memcg->oom_kill_disable = parent->oom_kill_disable;
+
+		res_counter_init(&memcg->res, NULL);
+		res_counter_init(&memcg->memsw, NULL);
+		res_counter_init(&memcg->kmem, NULL);
 	}
 
-	if (parent && parent->use_hierarchy) {
+	memcg->last_scanned_node = MAX_NUMNODES;
+	INIT_LIST_HEAD(&memcg->oom_notify);
+	atomic_set(&memcg->refcnt, 1);
+	memcg->move_charge_at_immigrate = 0;
+	mutex_init(&memcg->thresholds_lock);
+	spin_lock_init(&memcg->move_lock);
+
+	return &memcg->css;
+
+free_out:
+	__mem_cgroup_free(memcg);
+	return ERR_PTR(error);
+}
+
+static int
+mem_cgroup_css_online(struct cgroup *cont)
+{
+	struct mem_cgroup *memcg, *parent;
+	int error = 0;
+
+	if (!cont->parent)
+		return 0;
+
+	memcg = mem_cgroup_from_cont(cont);
+	parent = mem_cgroup_from_cont(cont->parent);
+
+	memcg->use_hierarchy = parent->use_hierarchy;
+	memcg->oom_kill_disable = parent->oom_kill_disable;
+	memcg->swappiness = mem_cgroup_swappiness(parent);
+
+	if (parent->use_hierarchy) {
 		res_counter_init(&memcg->res, &parent->res);
 		res_counter_init(&memcg->memsw, &parent->memsw);
 		res_counter_init(&memcg->kmem, &parent->kmem);
@@ -6144,18 +6174,9 @@ mem_cgroup_css_alloc(struct cgroup *cont
 		 * much sense so let cgroup subsystem know about this
 		 * unfortunate state in our controller.
 		 */
-		if (parent && parent != root_mem_cgroup)
+		if (parent != root_mem_cgroup)
 			mem_cgroup_subsys.broken_hierarchy = true;
 	}
-	memcg->last_scanned_node = MAX_NUMNODES;
-	INIT_LIST_HEAD(&memcg->oom_notify);
-
-	if (parent)
-		memcg->swappiness = mem_cgroup_swappiness(parent);
-	atomic_set(&memcg->refcnt, 1);
-	memcg->move_charge_at_immigrate = 0;
-	mutex_init(&memcg->thresholds_lock);
-	spin_lock_init(&memcg->move_lock);
 
 	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
 	if (error) {
@@ -6165,12 +6186,8 @@ mem_cgroup_css_alloc(struct cgroup *cont
 		 * call __mem_cgroup_free, so return directly
 		 */
 		mem_cgroup_put(memcg);
-		return ERR_PTR(error);
 	}
-	return &memcg->css;
-free_out:
-	__mem_cgroup_free(memcg);
-	return ERR_PTR(error);
+	return error;
 }
 
 static void mem_cgroup_css_offline(struct cgroup *cont)
@@ -6780,6 +6797,7 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.name = "memory",
 	.subsys_id = mem_cgroup_subsys_id,
 	.css_alloc = mem_cgroup_css_alloc,
+	.css_online = mem_cgroup_css_online,
 	.css_offline = mem_cgroup_css_offline,
 	.css_free = mem_cgroup_css_free,
 	.can_attach = mem_cgroup_can_attach,
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

