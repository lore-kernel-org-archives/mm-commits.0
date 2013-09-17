From: akpm@linux-foundation.org
Subject: + revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
 added to -mm tree
Date: Tue, 17 Sep 2013 13:58:09 -0700
Message-ID: <5238c261./m+A6NkQRrWFdH70%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3IQU6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 16:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: + revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch added to -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@suse.cz,torvalds@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 13:58:09 -0700


The patch titled
     Subject: revert "memcg: get rid of soft-limit tree infrastructure"
has been added to the -mm tree.  Its filename is
     revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "memcg: get rid of soft-limit tree infrastructure"

Revert

: commit e883110aad718b65de658db77387aaa69cce996d
: Author:     Michal Hocko <mhocko@suse.cz>
: AuthorDate: Thu Sep 12 15:13:23 2013 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Thu Sep 12 15:38:00 2013 -0700
: 
:     memcg: get rid of soft-limit tree infrastructure

I merged this prematurely - Michal and Johannes still disagree about the
overall design direction and the future remains unclear.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  265 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 263 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~revert-memcg-get-rid-of-soft-limit-tree-infrastructure mm/memcontrol.c
--- a/mm/memcontrol.c~revert-memcg-get-rid-of-soft-limit-tree-infrastructure
+++ a/mm/memcontrol.c
@@ -39,6 +39,7 @@
 #include <linux/limits.h>
 #include <linux/export.h>
 #include <linux/mutex.h>
+#include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
@@ -124,6 +125,7 @@ static const char * const mem_cgroup_lru
  */
 enum mem_cgroup_events_target {
 	MEM_CGROUP_TARGET_THRESH,
+	MEM_CGROUP_TARGET_SOFTLIMIT,
 	MEM_CGROUP_TARGET_NUMAINFO,
 	MEM_CGROUP_NTARGETS,
 };
@@ -159,6 +161,10 @@ struct mem_cgroup_per_zone {
 
 	struct mem_cgroup_reclaim_iter reclaim_iter[DEF_PRIORITY + 1];
 
+	struct rb_node		tree_node;	/* RB tree node */
+	unsigned long long	usage_in_excess;/* Set to the value by which */
+						/* the soft limit is exceeded*/
+	bool			on_tree;
 	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
 						/* use container_of	   */
 };
@@ -167,6 +173,26 @@ struct mem_cgroup_per_node {
 	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
 };
 
+/*
+ * Cgroups above their limits are maintained in a RB-Tree, independent of
+ * their hierarchy representation
+ */
+
+struct mem_cgroup_tree_per_zone {
+	struct rb_root rb_root;
+	spinlock_t lock;
+};
+
+struct mem_cgroup_tree_per_node {
+	struct mem_cgroup_tree_per_zone rb_tree_per_zone[MAX_NR_ZONES];
+};
+
+struct mem_cgroup_tree {
+	struct mem_cgroup_tree_per_node *rb_tree_per_node[MAX_NUMNODES];
+};
+
+static struct mem_cgroup_tree soft_limit_tree __read_mostly;
+
 struct mem_cgroup_threshold {
 	struct eventfd_ctx *eventfd;
 	u64 threshold;
@@ -405,6 +431,7 @@ static bool move_file(void)
  * limit reclaim to prevent infinite loops, if they ever occur.
  */
 #define	MEM_CGROUP_MAX_RECLAIM_LOOPS		100
+#define	MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS	2
 
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
@@ -631,6 +658,164 @@ page_cgroup_zoneinfo(struct mem_cgroup *
 	return mem_cgroup_zoneinfo(memcg, nid, zid);
 }
 
+static struct mem_cgroup_tree_per_zone *
+soft_limit_tree_node_zone(int nid, int zid)
+{
+	return &soft_limit_tree.rb_tree_per_node[nid]->rb_tree_per_zone[zid];
+}
+
+static struct mem_cgroup_tree_per_zone *
+soft_limit_tree_from_page(struct page *page)
+{
+	int nid = page_to_nid(page);
+	int zid = page_zonenum(page);
+
+	return &soft_limit_tree.rb_tree_per_node[nid]->rb_tree_per_zone[zid];
+}
+
+static void
+__mem_cgroup_insert_exceeded(struct mem_cgroup *memcg,
+				struct mem_cgroup_per_zone *mz,
+				struct mem_cgroup_tree_per_zone *mctz,
+				unsigned long long new_usage_in_excess)
+{
+	struct rb_node **p = &mctz->rb_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct mem_cgroup_per_zone *mz_node;
+
+	if (mz->on_tree)
+		return;
+
+	mz->usage_in_excess = new_usage_in_excess;
+	if (!mz->usage_in_excess)
+		return;
+	while (*p) {
+		parent = *p;
+		mz_node = rb_entry(parent, struct mem_cgroup_per_zone,
+					tree_node);
+		if (mz->usage_in_excess < mz_node->usage_in_excess)
+			p = &(*p)->rb_left;
+		/*
+		 * We can't avoid mem cgroups that are over their soft
+		 * limit by the same amount
+		 */
+		else if (mz->usage_in_excess >= mz_node->usage_in_excess)
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&mz->tree_node, parent, p);
+	rb_insert_color(&mz->tree_node, &mctz->rb_root);
+	mz->on_tree = true;
+}
+
+static void
+__mem_cgroup_remove_exceeded(struct mem_cgroup *memcg,
+				struct mem_cgroup_per_zone *mz,
+				struct mem_cgroup_tree_per_zone *mctz)
+{
+	if (!mz->on_tree)
+		return;
+	rb_erase(&mz->tree_node, &mctz->rb_root);
+	mz->on_tree = false;
+}
+
+static void
+mem_cgroup_remove_exceeded(struct mem_cgroup *memcg,
+				struct mem_cgroup_per_zone *mz,
+				struct mem_cgroup_tree_per_zone *mctz)
+{
+	spin_lock(&mctz->lock);
+	__mem_cgroup_remove_exceeded(memcg, mz, mctz);
+	spin_unlock(&mctz->lock);
+}
+
+
+static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
+{
+	unsigned long long excess;
+	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup_tree_per_zone *mctz;
+	int nid = page_to_nid(page);
+	int zid = page_zonenum(page);
+	mctz = soft_limit_tree_from_page(page);
+
+	/*
+	 * Necessary to update all ancestors when hierarchy is used.
+	 * because their event counter is not touched.
+	 */
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
+		mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+		excess = res_counter_soft_limit_excess(&memcg->res);
+		/*
+		 * We have to update the tree if mz is on RB-tree or
+		 * mem is over its softlimit.
+		 */
+		if (excess || mz->on_tree) {
+			spin_lock(&mctz->lock);
+			/* if on-tree, remove it */
+			if (mz->on_tree)
+				__mem_cgroup_remove_exceeded(memcg, mz, mctz);
+			/*
+			 * Insert again. mz->usage_in_excess will be updated.
+			 * If excess is 0, no tree ops.
+			 */
+			__mem_cgroup_insert_exceeded(memcg, mz, mctz, excess);
+			spin_unlock(&mctz->lock);
+		}
+	}
+}
+
+static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
+{
+	int node, zone;
+	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup_tree_per_zone *mctz;
+
+	for_each_node(node) {
+		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+			mz = mem_cgroup_zoneinfo(memcg, node, zone);
+			mctz = soft_limit_tree_node_zone(node, zone);
+			mem_cgroup_remove_exceeded(memcg, mz, mctz);
+		}
+	}
+}
+
+static struct mem_cgroup_per_zone *
+__mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
+{
+	struct rb_node *rightmost = NULL;
+	struct mem_cgroup_per_zone *mz;
+
+retry:
+	mz = NULL;
+	rightmost = rb_last(&mctz->rb_root);
+	if (!rightmost)
+		goto done;		/* Nothing to reclaim from */
+
+	mz = rb_entry(rightmost, struct mem_cgroup_per_zone, tree_node);
+	/*
+	 * Remove the node now but someone else can add it back,
+	 * we will to add it back at the end of reclaim to its correct
+	 * position in the tree.
+	 */
+	__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
+	if (!res_counter_soft_limit_excess(&mz->memcg->res) ||
+		!css_tryget(&mz->memcg->css))
+		goto retry;
+done:
+	return mz;
+}
+
+static struct mem_cgroup_per_zone *
+mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
+{
+	struct mem_cgroup_per_zone *mz;
+
+	spin_lock(&mctz->lock);
+	mz = __mem_cgroup_largest_soft_limit_node(mctz);
+	spin_unlock(&mctz->lock);
+	return mz;
+}
+
 /*
  * Implementation Note: reading percpu statistics for memcg.
  *
@@ -789,6 +974,9 @@ static bool mem_cgroup_event_ratelimit(s
 		case MEM_CGROUP_TARGET_THRESH:
 			next = val + THRESHOLDS_EVENTS_TARGET;
 			break;
+		case MEM_CGROUP_TARGET_SOFTLIMIT:
+			next = val + SOFTLIMIT_EVENTS_TARGET;
+			break;
 		case MEM_CGROUP_TARGET_NUMAINFO:
 			next = val + NUMAINFO_EVENTS_TARGET;
 			break;
@@ -811,8 +999,11 @@ static void memcg_check_events(struct me
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
+		bool do_softlimit;
 		bool do_numainfo __maybe_unused;
 
+		do_softlimit = mem_cgroup_event_ratelimit(memcg,
+						MEM_CGROUP_TARGET_SOFTLIMIT);
 #if MAX_NUMNODES > 1
 		do_numainfo = mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_NUMAINFO);
@@ -820,6 +1011,8 @@ static void memcg_check_events(struct me
 		preempt_enable();
 
 		mem_cgroup_threshold(memcg);
+		if (unlikely(do_softlimit))
+			mem_cgroup_update_tree(memcg, page);
 #if MAX_NUMNODES > 1
 		if (unlikely(do_numainfo))
 			atomic_inc(&memcg->numainfo_events);
@@ -1661,7 +1854,6 @@ static unsigned long mem_cgroup_reclaim(
 	return total;
 }
 
-#if MAX_NUMNODES > 1
 /**
  * test_mem_cgroup_node_reclaimable
  * @memcg: the target memcg
@@ -1684,6 +1876,7 @@ static bool test_mem_cgroup_node_reclaim
 	return false;
 
 }
+#if MAX_NUMNODES > 1
 
 /*
  * Always updating the nodemask is not very good - even if we have an empty
@@ -1751,12 +1944,51 @@ int mem_cgroup_select_victim_node(struct
 	return node;
 }
 
+/*
+ * Check all nodes whether it contains reclaimable pages or not.
+ * For quick scan, we make use of scan_nodes. This will allow us to skip
+ * unused nodes. But scan_nodes is lazily updated and may not cotain
+ * enough new information. We need to do double check.
+ */
+static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
+{
+	int nid;
+
+	/*
+	 * quick check...making use of scan_node.
+	 * We can skip unused nodes.
+	 */
+	if (!nodes_empty(memcg->scan_nodes)) {
+		for (nid = first_node(memcg->scan_nodes);
+		     nid < MAX_NUMNODES;
+		     nid = next_node(nid, memcg->scan_nodes)) {
+
+			if (test_mem_cgroup_node_reclaimable(memcg, nid, noswap))
+				return true;
+		}
+	}
+	/*
+	 * Check rest of nodes.
+	 */
+	for_each_node_state(nid, N_MEMORY) {
+		if (node_isset(nid, memcg->scan_nodes))
+			continue;
+		if (test_mem_cgroup_node_reclaimable(memcg, nid, noswap))
+			return true;
+	}
+	return false;
+}
+
 #else
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
 {
 	return 0;
 }
 
+static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
+{
+	return test_mem_cgroup_node_reclaimable(memcg, 0, noswap);
+}
 #endif
 
 /*
@@ -2692,7 +2924,9 @@ static void __mem_cgroup_commit_charge(s
 	unlock_page_cgroup(pc);
 
 	/*
-	 * "charge_statistics" updated event counter.
+	 * "charge_statistics" updated event counter. Then, check it.
+	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
+	 * if they exceeds softlimit.
 	 */
 	memcg_check_events(memcg, page);
 }
@@ -5791,6 +6025,8 @@ static int alloc_mem_cgroup_per_zone_inf
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
 		lruvec_init(&mz->lruvec);
+		mz->usage_in_excess = 0;
+		mz->on_tree = false;
 		mz->memcg = memcg;
 	}
 	memcg->nodeinfo[node] = pn;
@@ -5846,6 +6082,7 @@ static void __mem_cgroup_free(struct mem
 	int node;
 	size_t size = memcg_size();
 
+	mem_cgroup_remove_from_trees(memcg);
 	free_css_id(&mem_cgroup_subsys, &memcg->css);
 
 	for_each_node(node)
@@ -5882,6 +6119,29 @@ struct mem_cgroup *parent_mem_cgroup(str
 }
 EXPORT_SYMBOL(parent_mem_cgroup);
 
+static void __init mem_cgroup_soft_limit_tree_init(void)
+{
+	struct mem_cgroup_tree_per_node *rtpn;
+	struct mem_cgroup_tree_per_zone *rtpz;
+	int tmp, node, zone;
+
+	for_each_node(node) {
+		tmp = node;
+		if (!node_state(node, N_NORMAL_MEMORY))
+			tmp = -1;
+		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
+		BUG_ON(!rtpn);
+
+		soft_limit_tree.rb_tree_per_node[node] = rtpn;
+
+		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+			rtpz = &rtpn->rb_tree_per_zone[zone];
+			rtpz->rb_root = RB_ROOT;
+			spin_lock_init(&rtpz->lock);
+		}
+	}
+}
+
 static struct cgroup_subsys_state * __ref
 mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 {
@@ -6662,6 +6922,7 @@ static int __init mem_cgroup_init(void)
 {
 	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
 	enable_swap_cgroup();
+	mem_cgroup_soft_limit_tree_init();
 	memcg_stock_init();
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm.patch
mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch

