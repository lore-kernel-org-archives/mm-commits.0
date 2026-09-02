Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0936C4AE123
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788378051; cv=none; b=qHEkFj/jN7Ge/sYyztCdYgeIl5G7UzHTp/o7tibX/vIZm2KRJaxlCInCxJgd4IOIcd5PYmH2J7Uur2BdPDkp/o4LYMFih9vo7s8jPIka/Xy6kMQHbvWUWuymeRjEgWmN+JRyAc8b1DACVFsKNSeg/nUOH5JS+nRCYUbCwlm545E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788378051; c=relaxed/simple;
	bh=Ic5zNzfeOxYBTK2eGFxX2Uz9qN6nbuDO9Vp6o3LHsKk=;
	h=Date:To:From:Subject:Message-Id; b=NyaLVvZWv1qG/hDwX/P18UzS8OTm59u2gBr5fHB/FUteSBC/mzZ6SvRah+xPRHQrzVNMyjUtF3oG6P5EF9mmG04cVGdhIiwuGQF3eOUR909xfYpbZLSRDeMFouXt2orQErWN2v9nvn7HjJTpP+OcpW5CIKkKrsHQzD/0PaLmeV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uW7P1VVA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uW7P1VVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A61B1F00A3D;
	Wed,  2 Sep 2026 19:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788378035;
	bh=opvM8Rh42o5i+Juxk7WgBQ88VVu317DsUlboukSLuGw=;
	h=Date:To:From:Subject;
	b=uW7P1VVA2683O/HHZqDiiir9PqXg+Lky7BguA6gA+C7AxHF1Z7aF0cXSFRNAeAEh+
	 JC4BFN7GQe8FGWBRwr3AxzMogpItS0JJCZ7cRZMBjVoeTu/j3meR2O++yLnBmh4nhj
	 zCJoxHzd2LriMzOtfS4XrHOiQsgpGasa/wGWA3Kk=
Date: Wed, 02 Sep 2026 12:40:34 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-the-soft-limit-rbtree.patch added to mm-unstable branch
Message-Id: <20260902194035.1A61B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove the soft limit rbtree
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-remove-the-soft-limit-rbtree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-the-soft-limit-rbtree.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

memcg-avoid-charging-the-root-memcg-from-obj_cgroup_charge_pages.patch
mm-mlock-use-the-irq-safe-accessor-for-nr_mlock-in-__munlock_folio.patch
memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-v1-soft-limit-reclaim.patch
memcg-remove-mem_cgroup_shrink_node.patch
memcg-remove-the-soft-limit-reclaim-tracepoints.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch

