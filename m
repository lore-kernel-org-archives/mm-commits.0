From: akpm@linux-foundation.org
Subject: + memcg-get-rid-of-soft-limit-tree-infrastructure.patch added to
 -mm tree
Date: Tue, 30 Jul 2013 15:33:54 -0700
Message-ID: <51f83f52.izOfLOz4jqDcWZlj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3G3Wdz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 18:33:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghan@google.com, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, bsingharora@gmail.com, mhocko@suse.cz

Subject: + memcg-get-rid-of-soft-limit-tree-infrastructure.patch added to -mm tree
To: mhocko@suse.cz,bsingharora@gmail.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com,yinghan@google.com
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 15:33:54 -0700


The patch titled
     Subject: memcg: get rid of soft-limit tree infrastructure
has been added to the -mm tree.  Its filename is
     memcg-get-rid-of-soft-limit-tree-infrastructure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-get-rid-of-soft-limit-tree-infrastructure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-get-rid-of-soft-limit-tree-infrastructure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: get rid of soft-limit tree infrastructure

Now that the soft limit is integrated to the reclaim directly the whole
soft-limit tree infrastructure is not needed anymore.  Rip it out.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Glauber Costa <glommer@openvz.org>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  265 ----------------------------------------------
 1 file changed, 2 insertions(+), 263 deletions(-)

diff -puN mm/memcontrol.c~memcg-get-rid-of-soft-limit-tree-infrastructure mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-get-rid-of-soft-limit-tree-infrastructure
+++ a/mm/memcontrol.c
@@ -39,7 +39,6 @@
 #include <linux/limits.h>
 #include <linux/export.h>
 #include <linux/mutex.h>
-#include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
@@ -139,7 +138,6 @@ static const char * const mem_cgroup_lru
  */
 enum mem_cgroup_events_target {
 	MEM_CGROUP_TARGET_THRESH,
-	MEM_CGROUP_TARGET_SOFTLIMIT,
 	MEM_CGROUP_TARGET_NUMAINFO,
 	MEM_CGROUP_NTARGETS,
 };
@@ -175,10 +173,6 @@ struct mem_cgroup_per_zone {
 
 	struct mem_cgroup_reclaim_iter reclaim_iter[DEF_PRIORITY + 1];
 
-	struct rb_node		tree_node;	/* RB tree node */
-	unsigned long long	usage_in_excess;/* Set to the value by which */
-						/* the soft limit is exceeded*/
-	bool			on_tree;
 	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
 						/* use container_of	   */
 };
@@ -187,26 +181,6 @@ struct mem_cgroup_per_node {
 	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
 };
 
-/*
- * Cgroups above their limits are maintained in a RB-Tree, independent of
- * their hierarchy representation
- */
-
-struct mem_cgroup_tree_per_zone {
-	struct rb_root rb_root;
-	spinlock_t lock;
-};
-
-struct mem_cgroup_tree_per_node {
-	struct mem_cgroup_tree_per_zone rb_tree_per_zone[MAX_NR_ZONES];
-};
-
-struct mem_cgroup_tree {
-	struct mem_cgroup_tree_per_node *rb_tree_per_node[MAX_NUMNODES];
-};
-
-static struct mem_cgroup_tree soft_limit_tree __read_mostly;
-
 struct mem_cgroup_threshold {
 	struct eventfd_ctx *eventfd;
 	u64 threshold;
@@ -444,7 +418,6 @@ static bool move_file(void)
  * limit reclaim to prevent infinite loops, if they ever occur.
  */
 #define	MEM_CGROUP_MAX_RECLAIM_LOOPS		100
-#define	MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS	2
 
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
@@ -672,164 +645,6 @@ page_cgroup_zoneinfo(struct mem_cgroup *
 	return mem_cgroup_zoneinfo(memcg, nid, zid);
 }
 
-static struct mem_cgroup_tree_per_zone *
-soft_limit_tree_node_zone(int nid, int zid)
-{
-	return &soft_limit_tree.rb_tree_per_node[nid]->rb_tree_per_zone[zid];
-}
-
-static struct mem_cgroup_tree_per_zone *
-soft_limit_tree_from_page(struct page *page)
-{
-	int nid = page_to_nid(page);
-	int zid = page_zonenum(page);
-
-	return &soft_limit_tree.rb_tree_per_node[nid]->rb_tree_per_zone[zid];
-}
-
-static void
-__mem_cgroup_insert_exceeded(struct mem_cgroup *memcg,
-				struct mem_cgroup_per_zone *mz,
-				struct mem_cgroup_tree_per_zone *mctz,
-				unsigned long long new_usage_in_excess)
-{
-	struct rb_node **p = &mctz->rb_root.rb_node;
-	struct rb_node *parent = NULL;
-	struct mem_cgroup_per_zone *mz_node;
-
-	if (mz->on_tree)
-		return;
-
-	mz->usage_in_excess = new_usage_in_excess;
-	if (!mz->usage_in_excess)
-		return;
-	while (*p) {
-		parent = *p;
-		mz_node = rb_entry(parent, struct mem_cgroup_per_zone,
-					tree_node);
-		if (mz->usage_in_excess < mz_node->usage_in_excess)
-			p = &(*p)->rb_left;
-		/*
-		 * We can't avoid mem cgroups that are over their soft
-		 * limit by the same amount
-		 */
-		else if (mz->usage_in_excess >= mz_node->usage_in_excess)
-			p = &(*p)->rb_right;
-	}
-	rb_link_node(&mz->tree_node, parent, p);
-	rb_insert_color(&mz->tree_node, &mctz->rb_root);
-	mz->on_tree = true;
-}
-
-static void
-__mem_cgroup_remove_exceeded(struct mem_cgroup *memcg,
-				struct mem_cgroup_per_zone *mz,
-				struct mem_cgroup_tree_per_zone *mctz)
-{
-	if (!mz->on_tree)
-		return;
-	rb_erase(&mz->tree_node, &mctz->rb_root);
-	mz->on_tree = false;
-}
-
-static void
-mem_cgroup_remove_exceeded(struct mem_cgroup *memcg,
-				struct mem_cgroup_per_zone *mz,
-				struct mem_cgroup_tree_per_zone *mctz)
-{
-	spin_lock(&mctz->lock);
-	__mem_cgroup_remove_exceeded(memcg, mz, mctz);
-	spin_unlock(&mctz->lock);
-}
-
-
-static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
-{
-	unsigned long long excess;
-	struct mem_cgroup_per_zone *mz;
-	struct mem_cgroup_tree_per_zone *mctz;
-	int nid = page_to_nid(page);
-	int zid = page_zonenum(page);
-	mctz = soft_limit_tree_from_page(page);
-
-	/*
-	 * Necessary to update all ancestors when hierarchy is used.
-	 * because their event counter is not touched.
-	 */
-	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		mz = mem_cgroup_zoneinfo(memcg, nid, zid);
-		excess = res_counter_soft_limit_excess(&memcg->res);
-		/*
-		 * We have to update the tree if mz is on RB-tree or
-		 * mem is over its softlimit.
-		 */
-		if (excess || mz->on_tree) {
-			spin_lock(&mctz->lock);
-			/* if on-tree, remove it */
-			if (mz->on_tree)
-				__mem_cgroup_remove_exceeded(memcg, mz, mctz);
-			/*
-			 * Insert again. mz->usage_in_excess will be updated.
-			 * If excess is 0, no tree ops.
-			 */
-			__mem_cgroup_insert_exceeded(memcg, mz, mctz, excess);
-			spin_unlock(&mctz->lock);
-		}
-	}
-}
-
-static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
-{
-	int node, zone;
-	struct mem_cgroup_per_zone *mz;
-	struct mem_cgroup_tree_per_zone *mctz;
-
-	for_each_node(node) {
-		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
-			mz = mem_cgroup_zoneinfo(memcg, node, zone);
-			mctz = soft_limit_tree_node_zone(node, zone);
-			mem_cgroup_remove_exceeded(memcg, mz, mctz);
-		}
-	}
-}
-
-static struct mem_cgroup_per_zone *
-__mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
-{
-	struct rb_node *rightmost = NULL;
-	struct mem_cgroup_per_zone *mz;
-
-retry:
-	mz = NULL;
-	rightmost = rb_last(&mctz->rb_root);
-	if (!rightmost)
-		goto done;		/* Nothing to reclaim from */
-
-	mz = rb_entry(rightmost, struct mem_cgroup_per_zone, tree_node);
-	/*
-	 * Remove the node now but someone else can add it back,
-	 * we will to add it back at the end of reclaim to its correct
-	 * position in the tree.
-	 */
-	__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
-	if (!res_counter_soft_limit_excess(&mz->memcg->res) ||
-		!css_tryget(&mz->memcg->css))
-		goto retry;
-done:
-	return mz;
-}
-
-static struct mem_cgroup_per_zone *
-mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
-{
-	struct mem_cgroup_per_zone *mz;
-
-	spin_lock(&mctz->lock);
-	mz = __mem_cgroup_largest_soft_limit_node(mctz);
-	spin_unlock(&mctz->lock);
-	return mz;
-}
-
 /*
  * Implementation Note: reading percpu statistics for memcg.
  *
@@ -988,9 +803,6 @@ static bool mem_cgroup_event_ratelimit(s
 		case MEM_CGROUP_TARGET_THRESH:
 			next = val + THRESHOLDS_EVENTS_TARGET;
 			break;
-		case MEM_CGROUP_TARGET_SOFTLIMIT:
-			next = val + SOFTLIMIT_EVENTS_TARGET;
-			break;
 		case MEM_CGROUP_TARGET_NUMAINFO:
 			next = val + NUMAINFO_EVENTS_TARGET;
 			break;
@@ -1013,11 +825,8 @@ static void memcg_check_events(struct me
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
-		bool do_softlimit;
 		bool do_numainfo __maybe_unused;
 
-		do_softlimit = mem_cgroup_event_ratelimit(memcg,
-						MEM_CGROUP_TARGET_SOFTLIMIT);
 #if MAX_NUMNODES > 1
 		do_numainfo = mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_NUMAINFO);
@@ -1025,8 +834,6 @@ static void memcg_check_events(struct me
 		preempt_enable();
 
 		mem_cgroup_threshold(memcg);
-		if (unlikely(do_softlimit))
-			mem_cgroup_update_tree(memcg, page);
 #if MAX_NUMNODES > 1
 		if (unlikely(do_numainfo))
 			atomic_inc(&memcg->numainfo_events);
@@ -1886,6 +1693,7 @@ static unsigned long mem_cgroup_reclaim(
 	return total;
 }
 
+#if MAX_NUMNODES > 1
 /**
  * test_mem_cgroup_node_reclaimable
  * @memcg: the target memcg
@@ -1908,7 +1716,6 @@ static bool test_mem_cgroup_node_reclaim
 	return false;
 
 }
-#if MAX_NUMNODES > 1
 
 /*
  * Always updating the nodemask is not very good - even if we have an empty
@@ -1976,51 +1783,12 @@ int mem_cgroup_select_victim_node(struct
 	return node;
 }
 
-/*
- * Check all nodes whether it contains reclaimable pages or not.
- * For quick scan, we make use of scan_nodes. This will allow us to skip
- * unused nodes. But scan_nodes is lazily updated and may not cotain
- * enough new information. We need to do double check.
- */
-static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
-{
-	int nid;
-
-	/*
-	 * quick check...making use of scan_node.
-	 * We can skip unused nodes.
-	 */
-	if (!nodes_empty(memcg->scan_nodes)) {
-		for (nid = first_node(memcg->scan_nodes);
-		     nid < MAX_NUMNODES;
-		     nid = next_node(nid, memcg->scan_nodes)) {
-
-			if (test_mem_cgroup_node_reclaimable(memcg, nid, noswap))
-				return true;
-		}
-	}
-	/*
-	 * Check rest of nodes.
-	 */
-	for_each_node_state(nid, N_MEMORY) {
-		if (node_isset(nid, memcg->scan_nodes))
-			continue;
-		if (test_mem_cgroup_node_reclaimable(memcg, nid, noswap))
-			return true;
-	}
-	return false;
-}
-
 #else
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
 {
 	return 0;
 }
 
-static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
-{
-	return test_mem_cgroup_node_reclaimable(memcg, 0, noswap);
-}
 #endif
 
 /*
@@ -2895,9 +2663,7 @@ static void __mem_cgroup_commit_charge(s
 	unlock_page_cgroup(pc);
 
 	/*
-	 * "charge_statistics" updated event counter. Then, check it.
-	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
-	 * if they exceeds softlimit.
+	 * "charge_statistics" updated event counter.
 	 */
 	memcg_check_events(memcg, page);
 }
@@ -5984,8 +5750,6 @@ static int alloc_mem_cgroup_per_zone_inf
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
 		lruvec_init(&mz->lruvec);
-		mz->usage_in_excess = 0;
-		mz->on_tree = false;
 		mz->memcg = memcg;
 	}
 	memcg->nodeinfo[node] = pn;
@@ -6041,7 +5805,6 @@ static void __mem_cgroup_free(struct mem
 	int node;
 	size_t size = memcg_size();
 
-	mem_cgroup_remove_from_trees(memcg);
 	free_css_id(&mem_cgroup_subsys, &memcg->css);
 
 	for_each_node(node)
@@ -6078,29 +5841,6 @@ struct mem_cgroup *parent_mem_cgroup(str
 }
 EXPORT_SYMBOL(parent_mem_cgroup);
 
-static void __init mem_cgroup_soft_limit_tree_init(void)
-{
-	struct mem_cgroup_tree_per_node *rtpn;
-	struct mem_cgroup_tree_per_zone *rtpz;
-	int tmp, node, zone;
-
-	for_each_node(node) {
-		tmp = node;
-		if (!node_state(node, N_NORMAL_MEMORY))
-			tmp = -1;
-		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
-		BUG_ON(!rtpn);
-
-		soft_limit_tree.rb_tree_per_node[node] = rtpn;
-
-		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
-			rtpz = &rtpn->rb_tree_per_zone[zone];
-			rtpz->rb_root = RB_ROOT;
-			spin_lock_init(&rtpz->lock);
-		}
-	}
-}
-
 static struct cgroup_subsys_state * __ref
 mem_cgroup_css_alloc(struct cgroup *cont)
 {
@@ -6883,7 +6623,6 @@ static int __init mem_cgroup_init(void)
 {
 	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
 	enable_swap_cgroup();
-	mem_cgroup_soft_limit_tree_init();
 	memcg_stock_init();
 	return 0;
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

vmpressure-change-vmpressure-sr_lock-to-spinlock.patch
vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined-checkpatch-fixes.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
mm-fix-potential-null-pointer-dereference.patch
mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
memcg-trivial-cleanups.patch
linux-next.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

