Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58BA2A1BF
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334222; cv=none; b=SHL+yU4UmdUVMrMjxhrs/BvfhB5jz9bpdeTa7JAWn+tCxVRNmRMv0Ie+l1QJqyloM+i4aH/o2wqmWz0TbuB4UQd0j6UYMTMeNN7cy+u/QaLP5l4USxJFSy/moDr08TQLMdHRQjKULn4PcA3CcPPxfQmoitLeKn6oHAvONjJaerI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334222; c=relaxed/simple;
	bh=nXDZXGPKMiPyfRqQoOCT8aTJIBaQu+FCgKEBLOxqxXs=;
	h=Date:To:From:Subject:Message-Id; b=qwCVgIhETdm/s6jpNT8BWFsm2mmqNzqHoca31vc75v6MEnbhj9fd3krP6T1VUlgS/JPbGxxCcxWkbRtIeA4hTnRA484PRY7dGyD1ba/JCyr+ceS4kgaWGqZ6iMiD8ZKFZiewefyOGvouqBOO/4ueX6IYzr3BlxSETmm1B4JvQlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=puD7Snzy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="puD7Snzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C641F0089B;
	Wed,  7 Oct 2026 00:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334220;
	bh=gOY2ilB8hy6TxkxuSmA5a1yqNa5YUDqDPFAJKDWJuII=;
	h=Date:To:From:Subject;
	b=puD7Snzyui3uP4JFlkddHD+L7K9C0Rkbd6HsNftKY5yv/yFsT7armrFNlXYlYsrWx
	 ideKyBdG3ecrZ37bVXlHA0c2Qh/GBxEMa0bOH/z0CYr5WrZ/AYJiYDtr27NHtC5yYd
	 3tWl8ogzevgTDQN4HSSFFchQT6bofBT/yDw3YIQU=
Date: Tue, 06 Oct 2026 17:50:20 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-the-soft-limit-rbtree.patch removed from -mm tree
Message-Id: <20261007005020.82C641F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove the soft limit rbtree
has been removed from the -mm tree.  Its filename was
     memcg-remove-the-soft-limit-rbtree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove the soft limit rbtree
Date: Wed, 2 Sep 2026 10:43:07 -0700

With soft limit reclaim gone, the per-node rbtree of cgroups in excess
has no readers left. Remove the tree, the helpers maintaining it, and
the subsys_initcall that existed only to allocate it. memcg1_check_events()
no longer needs to feed it, which also drops the last caller of
lru_gen_soft_reclaim().

Link: https://lore.kernel.org/20260902174311.1772372-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
---

 mm/memcontrol-v1.c |  176 -------------------------------------------
 mm/memcontrol-v1.h |    2 
 mm/memcontrol.c    |    1 
 3 files changed, 2 insertions(+), 177 deletions(-)

--- a/mm/memcontrol.c~memcg-remove-the-soft-limit-rbtree
+++ a/mm/memcontrol.c
@@ -4429,7 +4429,6 @@ static void mem_cgroup_css_free(struct c
 
 	vmpressure_cleanup(&memcg->vmpressure);
 	cancel_work_sync(&memcg->high_work);
-	memcg1_remove_from_trees(memcg);
 	free_shrinker_info(memcg);
 	mem_cgroup_free(memcg);
 }
--- a/mm/memcontrol-v1.c~memcg-remove-the-soft-limit-rbtree
+++ a/mm/memcontrol-v1.c
@@ -17,23 +17,6 @@
 #include "swap_table.h"
 #include "memcontrol-v1.h"
 
-/*
- * Cgroups above their limits are maintained in a RB-Tree, independent of
- * their hierarchy representation
- */
-
-struct mem_cgroup_tree_per_node {
-	struct rb_root rb_root;
-	struct rb_node *rb_rightmost;
-	spinlock_t lock;
-};
-
-struct mem_cgroup_tree {
-	struct mem_cgroup_tree_per_node *rb_tree_per_node[MAX_NUMNODES];
-};
-
-static struct mem_cgroup_tree soft_limit_tree __read_mostly;
-
 /* for OOM */
 struct mem_cgroup_eventfd_list {
 	struct list_head list;
@@ -99,133 +82,6 @@ static struct lockdep_map memcg_oom_lock
 
 DEFINE_SPINLOCK(memcg_oom_lock);
 
-static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
-					 struct mem_cgroup_tree_per_node *mctz,
-					 unsigned long new_usage_in_excess)
-{
-	struct rb_node **p = &mctz->rb_root.rb_node;
-	struct rb_node *parent = NULL;
-	struct mem_cgroup_per_node *mz_node;
-	bool rightmost = true;
-
-	if (mz->on_tree)
-		return;
-
-	mz->usage_in_excess = new_usage_in_excess;
-	if (!mz->usage_in_excess)
-		return;
-	while (*p) {
-		parent = *p;
-		mz_node = rb_entry(parent, struct mem_cgroup_per_node,
-					tree_node);
-		if (mz->usage_in_excess < mz_node->usage_in_excess) {
-			p = &(*p)->rb_left;
-			rightmost = false;
-		} else {
-			p = &(*p)->rb_right;
-		}
-	}
-
-	if (rightmost)
-		mctz->rb_rightmost = &mz->tree_node;
-
-	rb_link_node(&mz->tree_node, parent, p);
-	rb_insert_color(&mz->tree_node, &mctz->rb_root);
-	mz->on_tree = true;
-}
-
-static void __mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
-					 struct mem_cgroup_tree_per_node *mctz)
-{
-	if (!mz->on_tree)
-		return;
-
-	if (&mz->tree_node == mctz->rb_rightmost)
-		mctz->rb_rightmost = rb_prev(&mz->tree_node);
-
-	rb_erase(&mz->tree_node, &mctz->rb_root);
-	mz->on_tree = false;
-}
-
-static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
-				       struct mem_cgroup_tree_per_node *mctz)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&mctz->lock, flags);
-	__mem_cgroup_remove_exceeded(mz, mctz);
-	spin_unlock_irqrestore(&mctz->lock, flags);
-}
-
-static unsigned long soft_limit_excess(struct mem_cgroup *memcg)
-{
-	unsigned long nr_pages = page_counter_read(&memcg->memory);
-	unsigned long soft_limit = READ_ONCE(memcg->soft_limit);
-	unsigned long excess = 0;
-
-	if (nr_pages > soft_limit)
-		excess = nr_pages - soft_limit;
-
-	return excess;
-}
-
-static void memcg1_update_tree(struct mem_cgroup *memcg, int nid)
-{
-	unsigned long excess;
-	struct mem_cgroup_per_node *mz;
-	struct mem_cgroup_tree_per_node *mctz;
-
-	if (lru_gen_enabled()) {
-		if (soft_limit_excess(memcg))
-			lru_gen_soft_reclaim(memcg, nid);
-		return;
-	}
-
-	mctz = soft_limit_tree.rb_tree_per_node[nid];
-	if (!mctz)
-		return;
-	/*
-	 * Necessary to update all ancestors when hierarchy is used.
-	 * because their event counter is not touched.
-	 */
-	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		mz = memcg->nodeinfo[nid];
-		excess = soft_limit_excess(memcg);
-		/*
-		 * We have to update the tree if mz is on RB-tree or
-		 * mem is over its softlimit.
-		 */
-		if (excess || mz->on_tree) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&mctz->lock, flags);
-			/* if on-tree, remove it */
-			if (mz->on_tree)
-				__mem_cgroup_remove_exceeded(mz, mctz);
-			/*
-			 * Insert again. mz->usage_in_excess will be updated.
-			 * If excess is 0, no tree ops.
-			 */
-			__mem_cgroup_insert_exceeded(mz, mctz, excess);
-			spin_unlock_irqrestore(&mctz->lock, flags);
-		}
-	}
-}
-
-void memcg1_remove_from_trees(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup_tree_per_node *mctz;
-	struct mem_cgroup_per_node *mz;
-	int nid;
-
-	for_each_node(nid) {
-		mz = memcg->nodeinfo[nid];
-		mctz = soft_limit_tree.rb_tree_per_node[nid];
-		if (mctz)
-			mem_cgroup_remove_exceeded(mz, mctz);
-	}
-}
-
 static u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
 				struct cftype *cft)
 {
@@ -336,7 +192,7 @@ static void mem_cgroup_threshold(struct
 	}
 }
 
-/* Cgroup1: threshold notifications & softlimit tree updates */
+/* Cgroup1: threshold notifications */
 
 /*
  * Per memcg event counter is incremented at every pagein/pageout. With THP,
@@ -405,17 +261,8 @@ static void memcg1_check_events(struct m
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		return;
 
-	/* threshold event is triggered in finer grain than soft limit */
-	if (unlikely(memcg1_event_ratelimit(memcg,
-						MEM_CGROUP_TARGET_THRESH))) {
-		bool do_softlimit;
-
-		do_softlimit = memcg1_event_ratelimit(memcg,
-						MEM_CGROUP_TARGET_SOFTLIMIT);
+	if (unlikely(memcg1_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRESH)))
 		mem_cgroup_threshold(memcg);
-		if (unlikely(do_softlimit))
-			memcg1_update_tree(memcg, nid);
-	}
 }
 
 void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
@@ -2391,22 +2238,3 @@ void memcg1_free_events(struct mem_cgrou
 {
 	free_percpu(memcg->events_percpu);
 }
-
-static int __init memcg1_init(void)
-{
-	int node;
-
-	for_each_node(node) {
-		struct mem_cgroup_tree_per_node *rtpn;
-
-		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
-
-		rtpn->rb_root = RB_ROOT;
-		rtpn->rb_rightmost = NULL;
-		spin_lock_init(&rtpn->lock);
-		soft_limit_tree.rb_tree_per_node[node] = rtpn;
-	}
-
-	return 0;
-}
-subsys_initcall(memcg1_init);
--- a/mm/memcontrol-v1.h~memcg-remove-the-soft-limit-rbtree
+++ a/mm/memcontrol-v1.h
@@ -41,7 +41,6 @@ bool memcg1_alloc_events(struct mem_cgro
 void memcg1_free_events(struct mem_cgroup *memcg);
 
 void memcg1_memcg_init(struct mem_cgroup *memcg);
-void memcg1_remove_from_trees(struct mem_cgroup *memcg);
 
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
 {
@@ -98,7 +97,6 @@ static inline bool memcg1_alloc_events(s
 static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
 
 static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
-static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

