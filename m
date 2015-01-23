From: akpm@linux-foundation.org
Subject: + mm-memcontrol-simplify-soft-limit-tree-init-code.patch added to -mm tree
Date: Fri, 23 Jan 2015 14:38:02 -0800
Message-ID: <54c2cd4a.MOZKhX41Wi/CFCLq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbAWWiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jan 2015 17:38:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, cl@linux-foundation.org, linux@roeck-us.net, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: simplify soft limit tree init code
has been added to the -mm tree.  Its filename is
     mm-memcontrol-simplify-soft-limit-tree-init-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-simplify-soft-limit-tree-init-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-simplify-soft-limit-tree-init-code.patch

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
@@ -4537,24 +4537,23 @@ EXPORT_SYMBOL(parent_mem_cgroup);
 
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

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
memcg-remove-extra-newlines-from-memcg-oom-kill-log.patch
mm-vmscan-fix-highidx-argument-type.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-memcontrol-track-move_lock-state-internally-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-memcontrol-simplify-soft-limit-tree-init-code.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
memcg-cleanup-preparation-for-page-table-walk.patch
mincore-apply-page-table-walker-on-do_mincore.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch
linux-next.patch

