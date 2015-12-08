From: akpm@linux-foundation.org
Subject: + mm-memcontrol-group-kmem-init-and-exit-functions-together.patch added to -mm tree
Date: Tue, 08 Dec 2015 15:06:42 -0800
Message-ID: <56676282.f99Ql/8FcyijJ06G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbLHXGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 18:06:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: group kmem init and exit functions together
has been added to the -mm tree.  Its filename is
     mm-memcontrol-group-kmem-init-and-exit-functions-together.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-group-kmem-init-and-exit-functions-together.patch

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
Subject: mm: memcontrol: group kmem init and exit functions together

Put all the related code to setup and teardown the kmem accounting state
into the same location.  No functional change intended.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  157 ++++++++++++++++++++++------------------------
 1 file changed, 76 insertions(+), 81 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-group-kmem-init-and-exit-functions-together mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-group-kmem-init-and-exit-functions-together
+++ a/mm/memcontrol.c
@@ -2924,12 +2924,88 @@ static int memcg_propagate_kmem(struct m
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
@@ -3555,87 +3631,6 @@ static int mem_cgroup_oom_control_write(
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
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 struct list_head *mem_cgroup_cgwb_list(struct mem_cgroup *memcg)
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
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch

