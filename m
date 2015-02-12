From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-simplify-soft-limit-tree-init-code.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:37:16 -0800
Message-ID: <54dd00ec.DCyN+U6c/X8QjDkk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbbBLThR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, cl@linux-foundation.org, linux@roeck-us.net, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: simplify soft limit tree init code
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-simplify-soft-limit-tree-init-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: simplify soft limit tree init code

- No need to test the node for N_MEMORY.  node_online() is enough for
  node fallback to work in slab, use NUMA_NO_NODE for everything else.

- Remove the BUG_ON() for allocation failure.  A NULL pointer crash is
  just as descriptive, and the absent return value check is obvious.

- Move local variables to the inner-most blocks.

- Point to the tree structure after its initialized, not before, it's
  just more logical that way.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-simplify-soft-limit-tree-init-code mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-simplify-soft-limit-tree-init-code
+++ a/mm/memcontrol.c
@@ -4509,24 +4509,23 @@ EXPORT_SYMBOL(parent_mem_cgroup);
 
 static void __init mem_cgroup_soft_limit_tree_init(void)
 {
-	struct mem_cgroup_tree_per_node *rtpn;
-	struct mem_cgroup_tree_per_zone *rtpz;
-	int tmp, node, zone;
+	int node;
 
 	for_each_node(node) {
-		tmp = node;
-		if (!node_state(node, N_NORMAL_MEMORY))
-			tmp = -1;
-		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
-		BUG_ON(!rtpn);
+		struct mem_cgroup_tree_per_node *rtpn;
+		int zone;
 
-		soft_limit_tree.rb_tree_per_node[node] = rtpn;
+		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
+				    node_online(node) ? node : NUMA_NO_NODE);
 
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+			struct mem_cgroup_tree_per_zone *rtpz;
+
 			rtpz = &rtpn->rb_tree_per_zone[zone];
 			rtpz->rb_root = RB_ROOT;
 			spin_lock_init(&rtpz->lock);
 		}
+		soft_limit_tree.rb_tree_per_node[node] = rtpn;
 	}
 }
 
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

