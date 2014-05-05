From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch added to -mm tree
Date: Mon, 05 May 2014 14:37:07 -0700
Message-ID: <53680483.NYKkVXfMOD+xnVZF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbaEEVhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 17:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nasa4836@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org

Subject: + mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch added to -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,nasa4836@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 14:37:07 -0700


The patch titled
     Subject: mm: memcontrol: remove unnecessary memcg argument from soft limit functions
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch

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
Subject: mm: memcontrol: remove unnecessary memcg argument from soft limit functions

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions
+++ a/mm/memcontrol.c
@@ -713,11 +713,9 @@ soft_limit_tree_from_page(struct page *p
 	return &soft_limit_tree.rb_tree_per_node[nid]->rb_tree_per_zone[zid];
 }
 
-static void
-__mem_cgroup_insert_exceeded(struct mem_cgroup *memcg,
-				struct mem_cgroup_per_zone *mz,
-				struct mem_cgroup_tree_per_zone *mctz,
-				unsigned long long new_usage_in_excess)
+static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_zone *mz,
+					 struct mem_cgroup_tree_per_zone *mctz,
+					 unsigned long long new_usage_in_excess)
 {
 	struct rb_node **p = &mctz->rb_root.rb_node;
 	struct rb_node *parent = NULL;
@@ -747,10 +745,8 @@ __mem_cgroup_insert_exceeded(struct mem_
 	mz->on_tree = true;
 }
 
-static void
-__mem_cgroup_remove_exceeded(struct mem_cgroup *memcg,
-				struct mem_cgroup_per_zone *mz,
-				struct mem_cgroup_tree_per_zone *mctz)
+static void __mem_cgroup_remove_exceeded(struct mem_cgroup_per_zone *mz,
+					 struct mem_cgroup_tree_per_zone *mctz)
 {
 	if (!mz->on_tree)
 		return;
@@ -758,13 +754,11 @@ __mem_cgroup_remove_exceeded(struct mem_
 	mz->on_tree = false;
 }
 
-static void
-mem_cgroup_remove_exceeded(struct mem_cgroup *memcg,
-				struct mem_cgroup_per_zone *mz,
-				struct mem_cgroup_tree_per_zone *mctz)
+static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_zone *mz,
+				       struct mem_cgroup_tree_per_zone *mctz)
 {
 	spin_lock(&mctz->lock);
-	__mem_cgroup_remove_exceeded(memcg, mz, mctz);
+	__mem_cgroup_remove_exceeded(mz, mctz);
 	spin_unlock(&mctz->lock);
 }
 
@@ -791,12 +785,12 @@ static void mem_cgroup_update_tree(struc
 			spin_lock(&mctz->lock);
 			/* if on-tree, remove it */
 			if (mz->on_tree)
-				__mem_cgroup_remove_exceeded(memcg, mz, mctz);
+				__mem_cgroup_remove_exceeded(mz, mctz);
 			/*
 			 * Insert again. mz->usage_in_excess will be updated.
 			 * If excess is 0, no tree ops.
 			 */
-			__mem_cgroup_insert_exceeded(memcg, mz, mctz, excess);
+			__mem_cgroup_insert_exceeded(mz, mctz, excess);
 			spin_unlock(&mctz->lock);
 		}
 	}
@@ -812,7 +806,7 @@ static void mem_cgroup_remove_from_trees
 		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 			mz = &memcg->nodeinfo[nid]->zoneinfo[zid];
 			mctz = soft_limit_tree_node_zone(nid, zid);
-			mem_cgroup_remove_exceeded(memcg, mz, mctz);
+			mem_cgroup_remove_exceeded(mz, mctz);
 		}
 	}
 }
@@ -835,7 +829,7 @@ retry:
 	 * we will to add it back at the end of reclaim to its correct
 	 * position in the tree.
 	 */
-	__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
+	__mem_cgroup_remove_exceeded(mz, mctz);
 	if (!res_counter_soft_limit_excess(&mz->memcg->res) ||
 		!css_tryget(&mz->memcg->css))
 		goto retry;
@@ -4645,7 +4639,7 @@ unsigned long mem_cgroup_soft_limit_recl
 					break;
 			} while (1);
 		}
-		__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
+		__mem_cgroup_remove_exceeded(mz, mctz);
 		excess = res_counter_soft_limit_excess(&mz->memcg->res);
 		/*
 		 * One school of thought says that we should not add
@@ -4656,7 +4650,7 @@ unsigned long mem_cgroup_soft_limit_recl
 		 * term TODO.
 		 */
 		/* If excess == 0, no tree ops */
-		__mem_cgroup_insert_exceeded(mz->memcg, mz, mctz, excess);
+		__mem_cgroup_insert_exceeded(mz, mctz, excess);
 		spin_unlock(&mctz->lock);
 		css_put(&mz->memcg->css);
 		loop++;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

slub-fix-memcg_propagate_slab_attrs.patch
mm-filemap-update-find_get_pages_tag-to-deal-with-shadow-entries.patch
revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-document-memorylow_limit_in_bytes.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
mm-introduce-kmemleak_update_trace.patch
lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

