Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B7F10F1;
	Fri, 16 Jan 2026 00:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768521664; cv=none; b=aJerKDoL/TXplXXvufa427tfFcLemWazdqr+iZG7E8NtIXfOyKriyF+HhqpfxRzxScbedf4MErw4K6FU7ClFnYeOJ4CxO01jA6Mn2zqW9jJdijEod+P1PAavANK/N4/MC6pqXHax1FcDA5RaZdF+qc8sb2UDHnZu5uabbPDE6x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768521664; c=relaxed/simple;
	bh=PJb9b5U0mt7e4Or4uBN+agV01aQbclD3kC5jjWWF0ac=;
	h=Date:To:From:Subject:Message-Id; b=GG0EvEX/B3p2T4bCR1/jH3SRX2prJiHgDJFTZ5LtkTv5yCaFp3qEUc/iUoeap/wb+bA5EeguQMM0Yjjc0wQ4r1VreKRg6yhqO4dVSU+fkmYXfq3J1mU0ja+EQQ/hZqYxc2P91thLcvdE7SWk5/Y/KFiavLxY4HIjZq8p8otkhfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ru1KQcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ru1KQcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A384C116D0;
	Fri, 16 Jan 2026 00:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768521664;
	bh=PJb9b5U0mt7e4Or4uBN+agV01aQbclD3kC5jjWWF0ac=;
	h=Date:To:From:Subject:From;
	b=0ru1KQcun1pt6FcXEvaofsyYKfu4zfbpd6SMoA9PtGKBLdWTFZfFp/KjTyGvyI4Nc
	 MUDea4om10gIie5YsW0spwISe6jQSifvLTygK/G2x7RZVmHt0MokNCjXIjVJ0rVGpo
	 vAdFmg92X/zH25N0tMIa9MO5cCXxD8hnu/7teBK4=
Date: Thu, 15 Jan 2026 16:01:03 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,longman@redhat.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,axelrasmussen@google.com,bingjiao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion.patch added to mm-new branch
Message-Id: <20260116000104.3A384C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix demotion targets checks in reclaim/demotion
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Bing Jiao <bingjiao@google.com>
Subject: mm/vmscan: fix demotion targets checks in reclaim/demotion
Date: Wed, 14 Jan 2026 20:53:02 +0000

Patch series "mm/vmscan: fix demotion targets checks in reclaim/demotion",
v9.

This patch series addresses two issues in demote_folio_list(),
can_demote(), and next_demotion_node() in reclaim/demotion.

1. demote_folio_list() and can_demote() do not correctly check demotion
   target against cpuset.mems_effective, which will cause (a) pages are
   demoted to not-allowed nodes and (b) pages are failed to demote even
   if the system still have allowed demotion nodes.

   Patch 1 fixes this bug by update cpuset_node_allowed() and
   mem_cgroup_node_allowed() to return effective_mems, allowing directly
   logic-and operation against demotion targets.

2. next_demotion_node() returns a preferred demotion target, but it does
   check the node against allowed nodes.

   Patch 2 ensures that next_demotion_node() filters against the allowed
   node mask and selects the closest demotion target to the source node.


This patch (of 2):

Fix two bugs in demote_folio_list() and can_demote() due to incorrect
demotion target checks against cpuset.mems_effective in reclaim/demotion.

Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
introduces the cpuset.mems_effective check and applies it to can_demote().
However:

  1. It does not apply this check in demote_folio_list(), which leads
     to situations where pages are demoted to nodes that are
     explicitly excluded from the task's cpuset.mems.

  2. It checks only the nodes in the immediate next demotion hierarchy
     and does not check all allowed demotion targets in can_demote().
     This can cause pages to never be demoted if the nodes in the next
     demotion hierarchy are not set in mems_effective.

These bugs break resource isolation provided by cpuset.mems.  This is
visible from userspace because pages can either fail to be demoted
entirely or are demoted to nodes that are not allowed in multi-tier memory
systems.

To address these bugs, update cpuset_node_allowed() and
mem_cgroup_node_allowed() to return effective_mems, allowing directly
logic-and operation against demotion targets.  Also update can_demote()
and demote_folio_list() accordingly.

Bug 1 reproduction:
  Assume a system with 4 nodes, where nodes 0-1 are top-tier and
  nodes 2-3 are far-tier memory. All nodes have equal capacity.

  Test script:
    echo 1 > /sys/kernel/mm/numa/demotion_enabled
    mkdir /sys/fs/cgroup/test
    echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
    echo "0-2" > /sys/fs/cgroup/test/cpuset.mems
    echo $$ > /sys/fs/cgroup/test/cgroup.procs
    swapoff -a
    # Expectation: Should respect node 0-2 limit.
    # Observation: Node 3 shows significant allocation (MemFree drops)
    stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1

Bug 2 reproduction:
  Assume a system with 6 nodes, where nodes 0-2 are top-tier,
  node 3 is a far-tier node, and nodes 4-5 are the farthest-tier nodes.
  All nodes have equal capacity.

  Test script:
    echo 1 > /sys/kernel/mm/numa/demotion_enabled
    mkdir /sys/fs/cgroup/test
    echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
    echo "0-2,4-5" > /sys/fs/cgroup/test/cpuset.mems
    echo $$ > /sys/fs/cgroup/test/cgroup.procs
    swapoff -a
    # Expectation: Pages are demoted to Nodes 4-5
    # Observation: No pages are demoted before oom.
    stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1,2

Link: https://lkml.kernel.org/r/20260114205305.2869796-1-bingjiao@google.com
Link: https://lkml.kernel.org/r/20260114205305.2869796-2-bingjiao@google.com
Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h     |    6 +--
 include/linux/memcontrol.h |    6 +--
 kernel/cgroup/cpuset.c     |   54 +++++++++++++++++++++++------------
 mm/memcontrol.c            |   16 +++++++++-
 mm/vmscan.c                |   34 ++++++++++++++--------
 5 files changed, 78 insertions(+), 38 deletions(-)

--- a/include/linux/cpuset.h~mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion
+++ a/include/linux/cpuset.h
@@ -174,7 +174,7 @@ static inline void set_mems_allowed(node
 	task_unlock(current);
 }
 
-extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
+extern void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask);
 #else /* !CONFIG_CPUSETS */
 
 static inline bool cpusets_enabled(void) { return false; }
@@ -301,9 +301,9 @@ static inline bool read_mems_allowed_ret
 	return false;
 }
 
-static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+static inline void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
 {
-	return true;
+	nodes_copy(*mask, node_states[N_MEMORY]);
 }
 #endif /* !CONFIG_CPUSETS */
 
--- a/include/linux/memcontrol.h~mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion
+++ a/include/linux/memcontrol.h
@@ -1754,7 +1754,7 @@ static inline void count_objcg_events(st
 	rcu_read_unlock();
 }
 
-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
+void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask);
 
 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
 
@@ -1825,9 +1825,9 @@ static inline ino_t page_cgroup_ino(stru
 	return 0;
 }
 
-static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+static inline void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg,
+						  nodemask_t *mask)
 {
-	return true;
 }
 
 static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
--- a/kernel/cgroup/cpuset.c~mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion
+++ a/kernel/cgroup/cpuset.c
@@ -4426,40 +4426,58 @@ bool cpuset_current_node_allowed(int nod
 	return allowed;
 }
 
-bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+/**
+ * cpuset_nodes_allowed - return effective_mems mask from a cgroup cpuset.
+ * @cgroup: pointer to struct cgroup.
+ * @mask: pointer to struct nodemask_t to be returned.
+ *
+ * Returns effective_mems mask from a cgroup cpuset if it is cgroup v2 and
+ * has cpuset subsys. Otherwise, returns node_states[N_MEMORY].
+ *
+ * This function intentionally avoids taking the cpuset_mutex or callback_lock
+ * when accessing effective_mems. This is because the obtained effective_mems
+ * is stale immediately after the query anyway (e.g., effective_mems is updated
+ * immediately after releasing the lock but before returning).
+ *
+ * As a result, returned @mask may be empty because cs->effective_mems can be
+ * rebound during this call. Besides, nodes in @mask are not guaranteed to be
+ * online due to hot plugins. Callers should check the mask for validity on
+ * return based on its subsequent use.
+ **/
+void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
 {
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
-	bool allowed;
 
 	/*
 	 * In v1, mem_cgroup and cpuset are unlikely in the same hierarchy
 	 * and mems_allowed is likely to be empty even if we could get to it,
-	 * so return true to avoid taking a global lock on the empty check.
+	 * so return directly to avoid taking a global lock on the empty check.
 	 */
-	if (!cpuset_v2())
-		return true;
+	if (!cgroup || !cpuset_v2()) {
+		nodes_copy(*mask, node_states[N_MEMORY]);
+		return;
+	}
 
 	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
-	if (!css)
-		return true;
+	if (!css) {
+		nodes_copy(*mask, node_states[N_MEMORY]);
+		return;
+	}
 
 	/*
-	 * Normally, accessing effective_mems would require the cpuset_mutex
-	 * or callback_lock - but node_isset is atomic and the reference
-	 * taken via cgroup_get_e_css is sufficient to protect css.
-	 *
-	 * Since this interface is intended for use by migration paths, we
-	 * relax locking here to avoid taking global locks - while accepting
-	 * there may be rare scenarios where the result may be innaccurate.
+	 * The reference taken via cgroup_get_e_css is sufficient to
+	 * protect css, but it does not imply safe accesses to effective_mems.
 	 *
-	 * Reclaim and migration are subject to these same race conditions, and
-	 * cannot make strong isolation guarantees, so this is acceptable.
+	 * Normally, accessing effective_mems would require the cpuset_mutex
+	 * or callback_lock - but the correctness of this information is stale
+	 * immediately after the query anyway. We do not acquire the lock
+	 * during this process to save lock contention in exchange for racing
+	 * against mems_allowed rebinds.
 	 */
 	cs = container_of(css, struct cpuset, css);
-	allowed = node_isset(nid, cs->effective_mems);
+	nodes_copy(*mask, cs->effective_mems);
 	css_put(css);
-	return allowed;
 }
 
 /**
--- a/mm/memcontrol.c~mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion
+++ a/mm/memcontrol.c
@@ -5723,9 +5723,21 @@ subsys_initcall(mem_cgroup_swap_init);
 
 #endif /* CONFIG_SWAP */
 
-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask)
 {
-	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
+	nodemask_t allowed;
+
+	if (!memcg)
+		return;
+
+	/*
+	 * Since this interface is intended for use by migration paths, and
+	 * reclaim and migration are subject to race conditions such as changes
+	 * in effective_mems and hot-unpluging of nodes, inaccurate allowed
+	 * mask is acceptable.
+	 */
+	cpuset_nodes_allowed(memcg->css.cgroup, &allowed);
+	nodes_and(*mask, *mask, allowed);
 }
 
 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
--- a/mm/vmscan.c~mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion
+++ a/mm/vmscan.c
@@ -324,19 +324,21 @@ static void flush_reclaim_state(struct s
 static bool can_demote(int nid, struct scan_control *sc,
 		       struct mem_cgroup *memcg)
 {
-	int demotion_nid;
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	nodemask_t allowed_mask;
 
-	if (!numa_demotion_enabled)
+	if (!pgdat || !numa_demotion_enabled)
 		return false;
 	if (sc && sc->no_demotion)
 		return false;
 
-	demotion_nid = next_demotion_node(nid);
-	if (demotion_nid == NUMA_NO_NODE)
+	node_get_allowed_targets(pgdat, &allowed_mask);
+	if (nodes_empty(allowed_mask))
 		return false;
 
-	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
-	return mem_cgroup_node_allowed(memcg, demotion_nid);
+	/* Filter out nodes that are not in cgroup's mems_allowed. */
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	return !nodes_empty(allowed_mask);
 }
 
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
@@ -998,9 +1000,10 @@ static struct folio *alloc_demote_folio(
  * Folios which are not demoted are left on @demote_folios.
  */
 static unsigned int demote_folio_list(struct list_head *demote_folios,
-				     struct pglist_data *pgdat)
+				      struct pglist_data *pgdat,
+				      struct mem_cgroup *memcg)
 {
-	int target_nid = next_demotion_node(pgdat->node_id);
+	int target_nid;
 	unsigned int nr_succeeded;
 	nodemask_t allowed_mask;
 
@@ -1012,7 +1015,6 @@ static unsigned int demote_folio_list(st
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
-		.nid = target_nid,
 		.nmask = &allowed_mask,
 		.reason = MR_DEMOTION,
 	};
@@ -1020,10 +1022,18 @@ static unsigned int demote_folio_list(st
 	if (list_empty(demote_folios))
 		return 0;
 
-	if (target_nid == NUMA_NO_NODE)
+	node_get_allowed_targets(pgdat, &allowed_mask);
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	if (nodes_empty(allowed_mask))
 		return 0;
 
-	node_get_allowed_targets(pgdat, &allowed_mask);
+	target_nid = next_demotion_node(pgdat->node_id);
+	if (target_nid == NUMA_NO_NODE)
+		/* No lower-tier nodes or nodes were hot-unplugged. */
+		return 0;
+	if (!node_isset(target_nid, allowed_mask))
+		target_nid = node_random(&allowed_mask);
+	mtc.nid = target_nid;
 
 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
@@ -1545,7 +1555,7 @@ keep:
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
-	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
 	nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
_

Patches currently in -mm which might be from bingjiao@google.com are

mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion.patch
mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list.patch

