From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-group-kmem-init-and-exit-functions-together.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:29:30 -0800
Message-ID: <56a169da.4HP0GQL7+NAztiGC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbcAUX3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: group kmem init and exit functions together
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-group-kmem-init-and-exit-functions-together.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: group kmem init and exit functions together

Put all the related code to setup and teardown the kmem accounting state
into the same location.  No functional change intended.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  157 ++++++++++++++++++++++------------------------
 1 file changed, 76 insertions(+), 81 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-group-kmem-init-and-exit-functions-together mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-group-kmem-init-and-exit-functions-together
+++ a/mm/memcontrol.c
@@ -2945,12 +2945,88 @@ static int memcg_propagate_kmem(struct m
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
+
+static int memcg_init_kmem(struct mem_cgroup *memcg)
+{
+	int ret;
+
+	ret = memcg_propagate_kmem(memcg);
+	if (ret)
+		return ret;
+
+	return tcp_init_cgroup(memcg);
+}
+
+static void memcg_offline_kmem(struct mem_cgroup *memcg)
+{
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *parent, *child;
+	int kmemcg_id;
+
+	if (memcg->kmem_state != KMEM_ONLINE)
+		return;
+	/*
+	 * Clear the online state before clearing memcg_caches array
+	 * entries. The slab_mutex in memcg_deactivate_kmem_caches()
+	 * guarantees that no cache will be created for this cgroup
+	 * after we are done (see memcg_create_kmem_cache()).
+	 */
+	memcg->kmem_state = KMEM_ALLOCATED;
+
+	memcg_deactivate_kmem_caches(memcg);
+
+	kmemcg_id = memcg->kmemcg_id;
+	BUG_ON(kmemcg_id < 0);
+
+	parent = parent_mem_cgroup(memcg);
+	if (!parent)
+		parent = root_mem_cgroup;
+
+	/*
+	 * Change kmemcg_id of this cgroup and all its descendants to the
+	 * parent's id, and then move all entries from this cgroup's list_lrus
+	 * to ones of the parent. After we have finished, all list_lrus
+	 * corresponding to this cgroup are guaranteed to remain empty. The
+	 * ordering is imposed by list_lru_node->lock taken by
+	 * memcg_drain_all_list_lrus().
+	 */
+	css_for_each_descendant_pre(css, &memcg->css) {
+		child = mem_cgroup_from_css(css);
+		BUG_ON(child->kmemcg_id != kmemcg_id);
+		child->kmemcg_id = parent->kmemcg_id;
+		if (!memcg->use_hierarchy)
+			break;
+	}
+	memcg_drain_all_list_lrus(kmemcg_id, parent->kmemcg_id);
+
+	memcg_free_cache_id(kmemcg_id);
+}
+
+static void memcg_free_kmem(struct mem_cgroup *memcg)
+{
+	if (memcg->kmem_state == KMEM_ALLOCATED) {
+		memcg_destroy_kmem_caches(memcg);
+		static_branch_dec(&memcg_kmem_enabled_key);
+		WARN_ON(page_counter_read(&memcg->kmem));
+	}
+	tcp_destroy_cgroup(memcg);
+}
 #else
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
 {
 	return -EINVAL;
 }
+static int memcg_init_kmem(struct mem_cgroup *memcg)
+{
+	return 0;
+}
+static void memcg_offline_kmem(struct mem_cgroup *memcg)
+{
+}
+static void memcg_free_kmem(struct mem_cgroup *memcg)
+{
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 /*
@@ -3577,87 +3653,6 @@ static int mem_cgroup_oom_control_write(
 	return 0;
 }
 
-#ifdef CONFIG_MEMCG_KMEM
-static int memcg_init_kmem(struct mem_cgroup *memcg)
-{
-	int ret;
-
-	ret = memcg_propagate_kmem(memcg);
-	if (ret)
-		return ret;
-
-	return tcp_init_cgroup(memcg);
-}
-
-static void memcg_offline_kmem(struct mem_cgroup *memcg)
-{
-	struct cgroup_subsys_state *css;
-	struct mem_cgroup *parent, *child;
-	int kmemcg_id;
-
-	if (memcg->kmem_state != KMEM_ONLINE)
-		return;
-	/*
-	 * Clear the online state before clearing memcg_caches array
-	 * entries. The slab_mutex in memcg_deactivate_kmem_caches()
-	 * guarantees that no cache will be created for this cgroup
-	 * after we are done (see memcg_create_kmem_cache()).
-	 */
-	memcg->kmem_state = KMEM_ALLOCATED;
-
-	memcg_deactivate_kmem_caches(memcg);
-
-	kmemcg_id = memcg->kmemcg_id;
-	BUG_ON(kmemcg_id < 0);
-
-	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
-	/*
-	 * Change kmemcg_id of this cgroup and all its descendants to the
-	 * parent's id, and then move all entries from this cgroup's list_lrus
-	 * to ones of the parent. After we have finished, all list_lrus
-	 * corresponding to this cgroup are guaranteed to remain empty. The
-	 * ordering is imposed by list_lru_node->lock taken by
-	 * memcg_drain_all_list_lrus().
-	 */
-	css_for_each_descendant_pre(css, &memcg->css) {
-		child = mem_cgroup_from_css(css);
-		BUG_ON(child->kmemcg_id != kmemcg_id);
-		child->kmemcg_id = parent->kmemcg_id;
-		if (!memcg->use_hierarchy)
-			break;
-	}
-	memcg_drain_all_list_lrus(kmemcg_id, parent->kmemcg_id);
-
-	memcg_free_cache_id(kmemcg_id);
-}
-
-static void memcg_free_kmem(struct mem_cgroup *memcg)
-{
-	if (memcg->kmem_state == KMEM_ALLOCATED) {
-		memcg_destroy_kmem_caches(memcg);
-		static_branch_dec(&memcg_kmem_enabled_key);
-		WARN_ON(page_counter_read(&memcg->kmem));
-	}
-	tcp_destroy_cgroup(memcg);
-}
-#else
-static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
-{
-	return 0;
-}
-
-static void memcg_offline_kmem(struct mem_cgroup *memcg)
-{
-}
-
-static void memcg_free_kmem(struct mem_cgroup *memcg)
-{
-}
-#endif
