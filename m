From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-consolidate-memory-controller-initialization.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:37:18 -0800
Message-ID: <54dd00ee.3Jt5t4jis1Lbv/MN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbbBLThT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: consolidate memory controller initialization
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-consolidate-memory-controller-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: consolidate memory controller initialization

The initialization code for the per-cpu charge stock and the soft
limit tree is compact enough to inline it into mem_cgroup_init().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   60 +++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-consolidate-memory-controller-initialization mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-consolidate-memory-controller-initialization
+++ a/mm/memcontrol.c
@@ -2138,17 +2138,6 @@ static void drain_local_stock(struct wor
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 }
 
-static void __init memcg_stock_init(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct memcg_stock_pcp *stock =
-					&per_cpu(memcg_stock, cpu);
-		INIT_WORK(&stock->work, drain_local_stock);
-	}
-}
-
 /*
  * Cache charges(val) to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
@@ -4507,28 +4496,6 @@ struct mem_cgroup *parent_mem_cgroup(str
 }
 EXPORT_SYMBOL(parent_mem_cgroup);
 
-static void __init mem_cgroup_soft_limit_tree_init(void)
-{
-	int node;
-
-	for_each_node(node) {
-		struct mem_cgroup_tree_per_node *rtpn;
-		int zone;
-
-		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
-				    node_online(node) ? node : NUMA_NO_NODE);
-
-		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
-			struct mem_cgroup_tree_per_zone *rtpz;
-
-			rtpz = &rtpn->rb_tree_per_zone[zone];
-			rtpz->rb_root = RB_ROOT;
-			spin_lock_init(&rtpz->lock);
-		}
-		soft_limit_tree.rb_tree_per_node[node] = rtpn;
-	}
-}
-
 static struct cgroup_subsys_state * __ref
 mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 {
@@ -5905,10 +5872,33 @@ void mem_cgroup_migrate(struct page *old
  */
 static int __init mem_cgroup_init(void)
 {
+	int cpu, node;
+
 	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
+
+	for_each_possible_cpu(cpu)
+		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
+			  drain_local_stock);
+
+	for_each_node(node) {
+		struct mem_cgroup_tree_per_node *rtpn;
+		int zone;
+
+		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
+				    node_online(node) ? node : NUMA_NO_NODE);
+
+		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+			struct mem_cgroup_tree_per_zone *rtpz;
+
+			rtpz = &rtpn->rb_tree_per_zone[zone];
+			rtpz->rb_root = RB_ROOT;
+			spin_lock_init(&rtpz->lock);
+		}
+		soft_limit_tree.rb_tree_per_node[node] = rtpn;
+	}
+
 	enable_swap_cgroup();
-	mem_cgroup_soft_limit_tree_init();
-	memcg_stock_init();
+
 	return 0;
 }
 subsys_initcall(mem_cgroup_init);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
memcg-cleanup-static-keys-decrement.patch
documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch

