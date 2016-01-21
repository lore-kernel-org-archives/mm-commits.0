From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:29:28 -0800
Message-ID: <56a169d8.1l/LfeauLyPzEIvM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbcAUX33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: give the kmem states more descriptive names
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: give the kmem states more descriptive names

On any given memcg, the kmem accounting feature has three separate states:
not initialized, structures allocated, and actively accounting slab
memory.  These are represented through a combination of the
kmem_acct_activated and kmem_acct_active flags, which is confusing.

Convert to a kmem_state enum with the states NONE, ALLOCATED, and ONLINE. 
Then rename the functions to modify the state accordingly.  This follows
the nomenclature of css object states more closely.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 ++++++----
 mm/memcontrol.c            |   52 ++++++++++++++++-------------------
 mm/slab_common.c           |    4 +-
 mm/vmscan.c                |    2 -
 4 files changed, 38 insertions(+), 35 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-give-the-kmem-states-more-descriptive-names include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-give-the-kmem-states-more-descriptive-names
+++ a/include/linux/memcontrol.h
@@ -152,6 +152,12 @@ struct mem_cgroup_thresholds {
 	struct mem_cgroup_threshold_ary *spare;
 };
 
+enum memcg_kmem_state {
+	KMEM_NONE,
+	KMEM_ALLOCATED,
+	KMEM_ONLINE,
+};
+
 /*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
@@ -233,8 +239,7 @@ struct mem_cgroup {
 #if defined(CONFIG_MEMCG_KMEM)
         /* Index in the kmem_cache->memcg_params.memcg_caches array */
 	int kmemcg_id;
-	bool kmem_acct_activated;
-	bool kmem_acct_active;
+	enum memcg_kmem_state kmem_state;
 #endif
 
 	int last_scanned_node;
@@ -750,9 +755,9 @@ static inline bool memcg_kmem_enabled(vo
 	return static_branch_unlikely(&memcg_kmem_enabled_key);
 }
 
-static inline bool memcg_kmem_is_active(struct mem_cgroup *memcg)
+static inline bool memcg_kmem_online(struct mem_cgroup *memcg)
 {
-	return memcg->kmem_acct_active;
+	return memcg->kmem_state == KMEM_ONLINE;
 }
 
 /*
@@ -850,7 +855,7 @@ static inline bool memcg_kmem_enabled(vo
 	return false;
 }
 
-static inline bool memcg_kmem_is_active(struct mem_cgroup *memcg)
+static inline bool memcg_kmem_online(struct mem_cgroup *memcg)
 {
 	return false;
 }
diff -puN mm/memcontrol.c~mm-memcontrol-give-the-kmem-states-more-descriptive-names mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-give-the-kmem-states-more-descriptive-names
+++ a/mm/memcontrol.c
@@ -2378,7 +2378,7 @@ int __memcg_kmem_charge_memcg(struct pag
 	struct page_counter *counter;
 	int ret;
 
-	if (!memcg_kmem_is_active(memcg))
+	if (!memcg_kmem_online(memcg))
 		return 0;
 
 	if (!page_counter_try_charge(&memcg->kmem, nr_pages, &counter))
@@ -2861,14 +2861,13 @@ static u64 mem_cgroup_read_u64(struct cg
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static int memcg_activate_kmem(struct mem_cgroup *memcg)
+static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	int err = 0;
 	int memcg_id;
 
 	BUG_ON(memcg->kmemcg_id >= 0);
-	BUG_ON(memcg->kmem_acct_activated);
-	BUG_ON(memcg->kmem_acct_active);
+	BUG_ON(memcg->kmem_state);
 
 	/*
 	 * For simplicity, we won't allow this to be disabled.  It also can't
@@ -2898,14 +2897,13 @@ static int memcg_activate_kmem(struct me
 
 	static_branch_inc(&memcg_kmem_enabled_key);
 	/*
-	 * A memory cgroup is considered kmem-active as soon as it gets
+	 * A memory cgroup is considered kmem-online as soon as it gets
 	 * kmemcg_id. Setting the id after enabling static branching will
 	 * guarantee no one starts accounting before all call sites are
 	 * patched.
 	 */
 	memcg->kmemcg_id = memcg_id;
-	memcg->kmem_acct_activated = true;
-	memcg->kmem_acct_active = true;
+	memcg->kmem_state = KMEM_ONLINE;
 out:
 	return err;
 }
@@ -2917,8 +2915,8 @@ static int memcg_update_kmem_limit(struc
 
 	mutex_lock(&memcg_limit_mutex);
 	/* Top-level cgroup doesn't propagate from root */
-	if (!memcg_kmem_is_active(memcg)) {
-		ret = memcg_activate_kmem(memcg);
+	if (!memcg_kmem_online(memcg)) {
+		ret = memcg_online_kmem(memcg);
 		if (ret)
 			goto out;
 	}
@@ -2938,11 +2936,12 @@ static int memcg_propagate_kmem(struct m
 
 	mutex_lock(&memcg_limit_mutex);
 	/*
-	 * If the parent cgroup is not kmem-active now, it cannot be activated
-	 * after this point, because it has at least one child already.
+	 * If the parent cgroup is not kmem-online now, it cannot be
+	 * onlined after this point, because it has at least one child
+	 * already.
 	 */
-	if (memcg_kmem_is_active(parent))
-		ret = memcg_activate_kmem(memcg);
+	if (memcg_kmem_online(parent))
+		ret = memcg_online_kmem(memcg);
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
@@ -3590,22 +3589,21 @@ static int memcg_init_kmem(struct mem_cg
 	return tcp_init_cgroup(memcg);
 }
 
-static void memcg_deactivate_kmem(struct mem_cgroup *memcg)
+static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *parent, *child;
 	int kmemcg_id;
 
-	if (!memcg->kmem_acct_active)
+	if (memcg->kmem_state != KMEM_ONLINE)
 		return;
-
 	/*
-	 * Clear the 'active' flag before clearing memcg_caches arrays entries.
-	 * Since we take the slab_mutex in memcg_deactivate_kmem_caches(), it
-	 * guarantees no cache will be created for this cgroup after we are
-	 * done (see memcg_create_kmem_cache()).
+	 * Clear the online state before clearing memcg_caches array
+	 * entries. The slab_mutex in memcg_deactivate_kmem_caches()
+	 * guarantees that no cache will be created for this cgroup
+	 * after we are done (see memcg_create_kmem_cache()).
 	 */
-	memcg->kmem_acct_active = false;
+	memcg->kmem_state = KMEM_ALLOCATED;
 
 	memcg_deactivate_kmem_caches(memcg);
 
@@ -3636,9 +3634,9 @@ static void memcg_deactivate_kmem(struct
 	memcg_free_cache_id(kmemcg_id);
 }
 
-static void memcg_destroy_kmem(struct mem_cgroup *memcg)
+static void memcg_free_kmem(struct mem_cgroup *memcg)
 {
-	if (memcg->kmem_acct_activated) {
+	if (memcg->kmem_state == KMEM_ALLOCATED) {
 		memcg_destroy_kmem_caches(memcg);
 		static_branch_dec(&memcg_kmem_enabled_key);
 		WARN_ON(page_counter_read(&memcg->kmem));
@@ -3651,11 +3649,11 @@ static int memcg_init_kmem(struct mem_cg
 	return 0;
 }
 
-static void memcg_deactivate_kmem(struct mem_cgroup *memcg)
+static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 }
 
-static void memcg_destroy_kmem(struct mem_cgroup *memcg)
+static void memcg_free_kmem(struct mem_cgroup *memcg)
 {
 }
 #endif
@@ -4308,7 +4306,7 @@ static void mem_cgroup_css_offline(struc
 
 	vmpressure_cleanup(&memcg->vmpressure);
 
-	memcg_deactivate_kmem(memcg);
+	memcg_offline_kmem(memcg);
 
 	wb_memcg_offline(memcg);
 }
@@ -4324,7 +4322,7 @@ static void mem_cgroup_css_free(struct c
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	memcg_destroy_kmem(memcg);
+	memcg_free_kmem(memcg);
 #ifdef CONFIG_INET
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
diff -puN mm/slab_common.c~mm-memcontrol-give-the-kmem-states-more-descriptive-names mm/slab_common.c
--- a/mm/slab_common.c~mm-memcontrol-give-the-kmem-states-more-descriptive-names
+++ a/mm/slab_common.c
@@ -503,10 +503,10 @@ void memcg_create_kmem_cache(struct mem_
 	mutex_lock(&slab_mutex);
 
 	/*
-	 * The memory cgroup could have been deactivated while the cache
+	 * The memory cgroup could have been offlined while the cache
 	 * creation work was pending.
 	 */
-	if (!memcg_kmem_is_active(memcg))
+	if (!memcg_kmem_online(memcg))
 		goto out_unlock;
 
 	idx = memcg_cache_id(memcg);
diff -puN mm/vmscan.c~mm-memcontrol-give-the-kmem-states-more-descriptive-names mm/vmscan.c
--- a/mm/vmscan.c~mm-memcontrol-give-the-kmem-states-more-descriptive-names
+++ a/mm/vmscan.c
@@ -411,7 +411,7 @@ static unsigned long shrink_slab(gfp_t g
 	struct shrinker *shrinker;
 	unsigned long freed = 0;
 
-	if (memcg && !memcg_kmem_is_active(memcg))
+	if (memcg && !memcg_kmem_online(memcg))
 		return 0;
 
 	if (nr_scanned == 0)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

