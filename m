From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch added to
 -mm tree
Date: Fri, 11 Dec 2015 15:52:44 -0800
Message-ID: <566b61cc.tHv6ORgBqBusIrSZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbLKXwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Dec 2015 18:52:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: clean up alloc, online, offline, free functions
has been added to the -mm tree.  Its filename is
     mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: clean up alloc, online, offline, free functions

The creation and teardown of struct mem_cgroup is fairly messy and
that has attracted mistakes and subtle bugs before.

The main cause for this is that there is no clear model about what
needs to happen when, and that attracts more chaos. So create one:

1. mem_cgroup_alloc() should allocate struct mem_cgroup and its
   auxiliary members and initialize work items, locks etc. so that the
   object it returns is fully initialized and in a neutral state.

2. mem_cgroup_css_alloc() will use mem_cgroup_alloc() to obtain a new
   memcg object and configure it and the system according to the role
   of the new memory-controlled cgroup in the hierarchy.

3. mem_cgroup_css_online() is no longer needed to synchronize with
   iterators, but it verifies css->id which isn't available earlier.

4. mem_cgroup_css_offline() implements stuff that needs to happen upon
   the user-visible destruction of a cgroup, which includes stopping
   all user interfacing as well as releasing certain structures when
   continued memory consumption would be unexpected at that point.

5. mem_cgroup_css_free() prepares the system and the memcg object for
   the object's disappearance, neutralizes its state, and then gives
   it back to mem_cgroup_free().

6. mem_cgroup_free() releases struct mem_cgroup and auxiliary memory.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 
 mm/memcontrol.c            |  225 +++++++++++------------------------
 2 files changed, 75 insertions(+), 153 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-clean-up-alloc-online-offline-free-functions include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-clean-up-alloc-online-offline-free-functions
+++ a/include/linux/memcontrol.h
@@ -181,9 +181,6 @@ struct mem_cgroup {
 	/* vmpressure notifications */
 	struct vmpressure vmpressure;
 
-	/* css_online() has been completed */
-	int initialized;
-
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
diff -puN mm/memcontrol.c~mm-memcontrol-clean-up-alloc-online-offline-free-functions mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-clean-up-alloc-online-offline-free-functions
+++ a/mm/memcontrol.c
@@ -896,17 +896,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		if (css == &root->css)
 			break;
 
-		if (css_tryget(css)) {
-			/*
-			 * Make sure the memcg is initialized:
-			 * mem_cgroup_css_online() orders the the
-			 * initialization against setting the flag.
-			 */
-			if (smp_load_acquire(&memcg->initialized))
-				break;
-
-			css_put(css);
-		}
+		if (css_tryget(css))
+			break;
 
 		memcg = NULL;
 	}
@@ -2851,37 +2842,14 @@ static u64 mem_cgroup_read_u64(struct cg
 #ifndef CONFIG_SLOB
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
-	int err = 0;
 	int memcg_id;
 
 	BUG_ON(memcg->kmemcg_id >= 0);
 	BUG_ON(memcg->kmem_state);
 
-	/*
-	 * For simplicity, we won't allow this to be disabled.  It also can't
-	 * be changed if the cgroup has children already, or if tasks had
-	 * already joined.
-	 *
-	 * If tasks join before we set the limit, a person looking at
-	 * kmem.usage_in_bytes will have no way to determine when it took
-	 * place, which makes the value quite meaningless.
-	 *
-	 * After it first became limited, changes in the value of the limit are
-	 * of course permitted.
-	 */
-	mutex_lock(&memcg_create_mutex);
-	if (cgroup_is_populated(memcg->css.cgroup) ||
-	    (memcg->use_hierarchy && memcg_has_children(memcg)))
-		err = -EBUSY;
-	mutex_unlock(&memcg_create_mutex);
-	if (err)
-		goto out;
-
 	memcg_id = memcg_alloc_cache_id();
-	if (memcg_id < 0) {
-		err = memcg_id;
-		goto out;
-	}
+	if (memcg_id < 0)
+		return memcg_id;
 
 	static_branch_inc(&memcg_kmem_enabled_key);
 	/*
@@ -2892,17 +2860,14 @@ static int memcg_online_kmem(struct mem_
 	 */
 	memcg->kmemcg_id = memcg_id;
 	memcg->kmem_state = KMEM_ONLINE;
-out:
-	return err;
+
+	return 0;
 }
 
-static int memcg_propagate_kmem(struct mem_cgroup *memcg)
+static int memcg_propagate_kmem(struct mem_cgroup *parent,
+				struct mem_cgroup *memcg)
 {
 	int ret = 0;
-	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
-
-	if (!parent)
-		return 0;
 
 	mutex_lock(&memcg_limit_mutex);
 	/*
@@ -2986,11 +2951,18 @@ static void memcg_free_kmem(struct mem_c
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
 {
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&memcg_limit_mutex);
 	/* Top-level cgroup doesn't propagate from root */
 	if (!memcg_kmem_online(memcg)) {
+		mutex_lock(&memcg_create_mutex);
+		if (cgroup_is_populated(memcg->css.cgroup) ||
+		    (memcg->use_hierarchy && memcg_has_children(memcg)))
+			ret = -EBUSY;
+		mutex_unlock(&memcg_create_mutex);
+		if (ret)
+			goto out;
 		ret = memcg_online_kmem(memcg);
 		if (ret)
 			goto out;
@@ -4145,90 +4117,44 @@ static void free_mem_cgroup_per_zone_inf
 	kfree(memcg->nodeinfo[node]);
 }
 
-static struct mem_cgroup *mem_cgroup_alloc(void)
-{
-	struct mem_cgroup *memcg;
-	size_t size;
-
-	size = sizeof(struct mem_cgroup);
-	size += nr_node_ids * sizeof(struct mem_cgroup_per_node *);
-
-	memcg = kzalloc(size, GFP_KERNEL);
-	if (!memcg)
-		return NULL;
-
-	memcg->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
-	if (!memcg->stat)
-		goto out_free;
-
-	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
-		goto out_free_stat;
-
-	return memcg;
-
-out_free_stat:
-	free_percpu(memcg->stat);
-out_free:
-	kfree(memcg);
-	return NULL;
-}
-
-/*
- * At destroying mem_cgroup, references from swap_cgroup can remain.
- * (scanning all at force_empty is too costly...)
- *
- * Instead of clearing all references at force_empty, we remember
- * the number of reference from swap_cgroup and free mem_cgroup when
- * it goes down to 0.
- *
- * Removal of cgroup itself succeeds regardless of refs from swap.
- */
-
-static void __mem_cgroup_free(struct mem_cgroup *memcg)
+static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	int node;
 
-	cancel_work_sync(&memcg->high_work);
-
-	mem_cgroup_remove_from_trees(memcg);
-
+	memcg_wb_domain_exit(memcg);
 	for_each_node(node)
 		free_mem_cgroup_per_zone_info(memcg, node);
-
 	free_percpu(memcg->stat);
-	memcg_wb_domain_exit(memcg);
 	kfree(memcg);
 }
 
-static struct cgroup_subsys_state * __ref
-mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
+static struct mem_cgroup *mem_cgroup_alloc(void)
 {
 	struct mem_cgroup *memcg;
-	long error = -ENOMEM;
+	size_t size;
 	int node;
 
-	memcg = mem_cgroup_alloc();
+	size = sizeof(struct mem_cgroup);
+	size += nr_node_ids * sizeof(struct mem_cgroup_per_node *);
+
+	memcg = kzalloc(size, GFP_KERNEL);
 	if (!memcg)
-		return ERR_PTR(error);
+		return NULL;
+
+	memcg->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
+	if (!memcg->stat)
+		goto fail;
 
 	for_each_node(node)
 		if (alloc_mem_cgroup_per_zone_info(memcg, node))
-			goto free_out;
+			goto fail;
 
-	/* root ? */
-	if (parent_css == NULL) {
-		root_mem_cgroup = memcg;
-		page_counter_init(&memcg->memory, NULL);
-		memcg->high = PAGE_COUNTER_MAX;
-		memcg->soft_limit = PAGE_COUNTER_MAX;
-		page_counter_init(&memcg->memsw, NULL);
-		page_counter_init(&memcg->kmem, NULL);
-	}
+	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
+		goto fail;
 
 	INIT_WORK(&memcg->high_work, high_work_func);
 	memcg->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&memcg->oom_notify);
-	memcg->move_charge_at_immigrate = 0;
 	mutex_init(&memcg->thresholds_lock);
 	spin_lock_init(&memcg->move_lock);
 	vmpressure_init(&memcg->vmpressure);
@@ -4241,48 +4167,37 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 #endif
-	return &memcg->css;
-
-free_out:
-	__mem_cgroup_free(memcg);
-	return ERR_PTR(error);
+	return memcg;
+fail:
+	mem_cgroup_free(memcg);
+	return NULL;
 }
 
-static int
-mem_cgroup_css_online(struct cgroup_subsys_state *css)
+static struct cgroup_subsys_state * __ref
+mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 {
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct mem_cgroup *parent = mem_cgroup_from_css(css->parent);
-	int ret;
-
-	if (css->id > MEM_CGROUP_ID_MAX)
-		return -ENOSPC;
+	struct mem_cgroup *parent = mem_cgroup_from_css(parent_css);
+	struct mem_cgroup *memcg;
+	long error = -ENOMEM;
 
-	if (!parent)
-		return 0;
+	memcg = mem_cgroup_alloc();
+	if (!memcg)
+		return ERR_PTR(error);
 
 	mutex_lock(&memcg_create_mutex);
-
-	memcg->use_hierarchy = parent->use_hierarchy;
-	memcg->oom_kill_disable = parent->oom_kill_disable;
-	memcg->swappiness = mem_cgroup_swappiness(parent);
-
-	if (parent->use_hierarchy) {
+	memcg->high = PAGE_COUNTER_MAX;
+	memcg->soft_limit = PAGE_COUNTER_MAX;
+	if (parent)
+		memcg->swappiness = mem_cgroup_swappiness(parent);
+	if (parent && parent->use_hierarchy) {
+		memcg->use_hierarchy = true;
+		memcg->oom_kill_disable = parent->oom_kill_disable;
 		page_counter_init(&memcg->memory, &parent->memory);
-		memcg->high = PAGE_COUNTER_MAX;
-		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, &parent->memsw);
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
-
-		/*
-		 * No need to take a reference to the parent because cgroup
-		 * core guarantees its existence.
-		 */
 	} else {
 		page_counter_init(&memcg->memory, NULL);
-		memcg->high = PAGE_COUNTER_MAX;
-		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
 		page_counter_init(&memcg->tcpmem, NULL);
@@ -4296,19 +4211,30 @@ mem_cgroup_css_online(struct cgroup_subs
 	}
 	mutex_unlock(&memcg_create_mutex);
 
-	ret = memcg_propagate_kmem(memcg);
-	if (ret)
-		return ret;
+	/* The following stuff does not apply to the root */
+	if (!parent) {
+		root_mem_cgroup = memcg;
+		return &memcg->css;
+	}
+
+	error = memcg_propagate_kmem(parent, memcg);
+	if (error)
+		goto fail;
 
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_inc(&memcg_sockets_enabled_key);
 
-	/*
-	 * Make sure the memcg is initialized: mem_cgroup_iter()
-	 * orders reading memcg->initialized against its callers
-	 * reading the memcg members.
-	 */
-	smp_store_release(&memcg->initialized, 1);
+	return &memcg->css;
+fail:
+	mem_cgroup_free(memcg);
+	return NULL;
+}
+
+static int
+mem_cgroup_css_online(struct cgroup_subsys_state *css)
+{
+	if (css->id > MEM_CGROUP_ID_MAX)
+		return -ENOSPC;
 
 	return 0;
 }
@@ -4330,10 +4256,7 @@ static void mem_cgroup_css_offline(struc
 	}
 	spin_unlock(&memcg->event_list_lock);
 
-	vmpressure_cleanup(&memcg->vmpressure);
-
 	memcg_offline_kmem(memcg);
-
 	wb_memcg_offline(memcg);
 }
 
@@ -4347,9 +4270,11 @@ static void mem_cgroup_css_free(struct c
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_active)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
+	vmpressure_cleanup(&memcg->vmpressure);
+	cancel_work_sync(&memcg->high_work);
+	mem_cgroup_remove_from_trees(memcg);
 	memcg_free_kmem(memcg);
-
-	__mem_cgroup_free(memcg);
+	mem_cgroup_free(memcg);
 }
 
 /**
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-memcontrol-export-root_mem_cgroup.patch
net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch

