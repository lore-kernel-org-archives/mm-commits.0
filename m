From: akpm@linux-foundation.org
Subject: + vmscan-force-scan-offline-memory-cgroups.patch added to -mm
 tree
Date: Fri, 09 Jan 2015 16:25:48 -0800
Message-ID: <54b0718c.I28li6I56GJJQ+cy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAJAZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 19:25:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: force scan offline memory cgroups
has been added to the -mm tree.  Its filename is
     vmscan-force-scan-offline-memory-cgroups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-force-scan-offline-memory-cgroups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-force-scan-offline-memory-cgroups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 
+bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
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
@@ -1379,6 +1379,20 @@ int mem_cgroup_inactive_anon_is_low(stru
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
@@ -1941,8 +1941,12 @@ static void get_scan_count(struct lruvec
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

mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch
memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
mm-vmscan-prevent-kswapd-livelock-due-to-pfmemalloc-throttled-process-being-killed.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
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

