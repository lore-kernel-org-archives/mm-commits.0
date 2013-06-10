From: akpm@linux-foundation.org
Subject: + memcg-clean-up-memcg-nodeinfo.patch added to -mm tree
Date: Mon, 10 Jun 2013 14:23:53 -0700
Message-ID: <51b643e9.OzRQsJGTdDQwasCb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3FJVXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 17:23:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, glommer@openvz.org, hannes@cmpxchg.org

Subject: + memcg-clean-up-memcg-nodeinfo.patch added to -mm tree
To: hannes@cmpxchg.org,glommer@openvz.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 14:23:53 -0700


The patch titled
     Subject: memcg: clean up memcg->nodeinfo
has been added to the -mm tree.  Its filename is
     memcg-clean-up-memcg-nodeinfo.patch

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
Subject: memcg: clean up memcg->nodeinfo

Remove struct mem_cgroup_lru_info and fold its single member, the variably
sized nodeinfo[0], directly into struct mem_cgroup.  This should make it
more obvious why it has to be the last member there.

Also move the comment that's above that special last member below it, so
it is more visible to somebody that considers appending to the struct
mem_cgroup.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-memcg-nodeinfo mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-memcg-nodeinfo
+++ a/mm/memcontrol.c
@@ -187,10 +187,6 @@ struct mem_cgroup_per_node {
 	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
 };
 
-struct mem_cgroup_lru_info {
-	struct mem_cgroup_per_node *nodeinfo[0];
-};
-
 /*
  * Cgroups above their limits are maintained in a RB-Tree, independent of
  * their hierarchy representation
@@ -366,14 +362,8 @@ struct mem_cgroup {
 	atomic_t	numainfo_updating;
 #endif
 
-	/*
-	 * Per cgroup active and inactive list, similar to the
-	 * per zone LRU lists.
-	 *
-	 * WARNING: This has to be the last element of the struct. Don't
-	 * add new fields after this point.
-	 */
-	struct mem_cgroup_lru_info info;
+	struct mem_cgroup_per_node *nodeinfo[0];
+	/* WARNING: nodeinfo must be the last member here */
 };
 
 static size_t memcg_size(void)
@@ -683,7 +673,7 @@ static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *memcg, int nid, int zid)
 {
 	VM_BUG_ON((unsigned)nid >= nr_node_ids);
-	return &memcg->info.nodeinfo[nid]->zoneinfo[zid];
+	return &memcg->nodeinfo[nid]->zoneinfo[zid];
 }
 
 struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
@@ -6087,13 +6077,13 @@ static int alloc_mem_cgroup_per_zone_inf
 		mz->on_tree = false;
 		mz->memcg = memcg;
 	}
-	memcg->info.nodeinfo[node] = pn;
+	memcg->nodeinfo[node] = pn;
 	return 0;
 }
 
 static void free_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 {
-	kfree(memcg->info.nodeinfo[node]);
+	kfree(memcg->nodeinfo[node]);
 }
 
 static struct mem_cgroup *mem_cgroup_alloc(void)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
swap-avoid-read_swap_cache_async-race-to-deadlock-while-waiting-on-discard-i-o-completion.patch
mm-memcontrol-fix-lockless-reclaim-hierarchy-iterator.patch
mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered-v3.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch
mm-vmscan-set-zone-flags-before-blocking.patch
mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch
memcg-update-todo-list-in-documentation.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
memcg-kconfig-info-update.patch
mm-kill-free_all_bootmem_node.patch
mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating.patch
memcg-clean-up-memcg-nodeinfo.patch
mm-memmap_init_zone-performance-improvement.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

