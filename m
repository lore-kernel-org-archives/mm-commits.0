From: akpm@linux-foundation.org
Subject: [merged] vmscan-force-scan-offline-memory-cgroups.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:36:48 -0800
Message-ID: <54dd00d0.uJyXKp4pwJMOFKaf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbBLTgt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: force scan offline memory cgroups
has been removed from the -mm tree.  Its filename was
     vmscan-force-scan-offline-memory-cgroups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: vmscan: force scan offline memory cgroups

Since commit b2052564e66d ("mm: memcontrol: continue cache reclaim from
offlined groups") pages charged to a memory cgroup are not reparented when
the cgroup is removed.  Instead, they are supposed to be reclaimed in a
regular way, along with pages accounted to online memory cgroups.

However, an lruvec of an offline memory cgroup will sooner or later get so
small that it will be scanned only at low scan priorities (see
get_scan_count()).  Therefore, if there are enough reclaimable pages in
big lruvecs, pages accounted to offline memory cgroups will never be
scanned at all, wasting memory.

Fix this by unconditionally forcing scanning dead lruvecs from kswapd.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++++
 mm/memcontrol.c            |   14 ++++++++++++++
 mm/vmscan.c                |    8 ++++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~vmscan-force-scan-offline-memory-cgroups include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-force-scan-offline-memory-cgroups
+++ a/include/linux/memcontrol.h
@@ -102,6 +102,7 @@ void mem_cgroup_iter_break(struct mem_cg
  * For memory reclaim.
  */
 int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec);
+bool mem_cgroup_lruvec_online(struct lruvec *lruvec);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list);
 void mem_cgroup_update_lru_size(struct lruvec *, enum lru_list, int);
@@ -266,6 +267,11 @@ mem_cgroup_inactive_anon_is_low(struct l
 	return 1;
 }
 
+static inline bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
+{
+	return true;
+}
+
 static inline unsigned long
 mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
diff -puN mm/memcontrol.c~vmscan-force-scan-offline-memory-cgroups mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-force-scan-offline-memory-cgroups
+++ a/mm/memcontrol.c
@@ -1367,6 +1367,20 @@ int mem_cgroup_inactive_anon_is_low(stru
 	return inactive * inactive_ratio < active;
 }
 
+bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
+{
+	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup *memcg;
+
+	if (mem_cgroup_disabled())
+		return true;
+
+	mz = container_of(lruvec, struct mem_cgroup_per_zone, lruvec);
+	memcg = mz->memcg;
+
+	return !!(memcg->css.flags & CSS_ONLINE);
+}
+
 #define mem_cgroup_from_counter(counter, member)	\
 	container_of(counter, struct mem_cgroup, member)
 
diff -puN mm/vmscan.c~vmscan-force-scan-offline-memory-cgroups mm/vmscan.c
--- a/mm/vmscan.c~vmscan-force-scan-offline-memory-cgroups
+++ a/mm/vmscan.c
@@ -1903,8 +1903,12 @@ static void get_scan_count(struct lruvec
 	 * latencies, so it's better to scan a minimum amount there as
 	 * well.
 	 */
-	if (current_is_kswapd() && !zone_reclaimable(zone))
-		force_scan = true;
+	if (current_is_kswapd()) {
+		if (!zone_reclaimable(zone))
+			force_scan = true;
+		if (!mem_cgroup_lruvec_online(lruvec))
+			force_scan = true;
+	}
 	if (!global_reclaim(sc))
 		force_scan = true;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

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
slab-embed-memcg_cache_params-to-kmem_cache-fix.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-never-fail-to-shrink-cache-init-discard-list-after-freeing-slabs.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
memcg-cleanup-static-keys-decrement.patch

