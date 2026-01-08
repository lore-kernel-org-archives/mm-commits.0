Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293E3330333;
	Thu,  8 Jan 2026 20:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767905401; cv=none; b=BGgXecYTyIGJvUkUgjWyxUo2HVuraylMxZPu2lcQ4TR2eYtQndQP4wV7OSTA4A0q6ra3wY6Vlp5/Nue2Hj4u5K4PpfXbA1Zl5bILFdWGSR6SxC+QoFNRKI1t7Oc2zkF0Fv4zjf3o5XLrMza4PzxzXHAPb5Kw22zFlf++LYdHsnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767905401; c=relaxed/simple;
	bh=aS7lS9qmGaUPzyeGqfuxY9W94KEBDGBd07hGN8hFdH8=;
	h=Date:To:From:Subject:Message-Id; b=lBbgy5o/xQR3FfsVEP7j3S0PSPaRY74GPmqMfo+Y6cLex5J94NnuWGtwP2Xuq+UXj3KtDYjJF+U+hIg9Din7EETOdz5QiwkILFCt5VOjI5gidszVLw1RiQs0WQWiNqkAN8g72UnUfY5yN9BduS1SkTVL25SQJt3xFaRMzxSnViM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gyxEI4jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gyxEI4jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B18C116C6;
	Thu,  8 Jan 2026 20:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767905400;
	bh=aS7lS9qmGaUPzyeGqfuxY9W94KEBDGBd07hGN8hFdH8=;
	h=Date:To:From:Subject:From;
	b=gyxEI4jx+GPHFibMwluSz3dj8agrZHvruAl1F7VzGa+QpnsYXrvy0JW4bJ1QqtgAz
	 44mGktNLMK3I9wuQfJ6LPugRWbfO/pLG6HBXsI4WDnQogDSpLM/0SbdheQ8GAZ7fK3
	 aZbcMbx+vsPzPR/TypV8CG12ri+VzmtWU1fFIKdE=
Date: Thu, 08 Jan 2026 12:49:59 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,tj@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,longman@redhat.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,axelrasmussen@google.com,akinobu.mita@gmail.com,bingjiao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion.patch added to mm-new branch
Message-Id: <20260108205000.99B18C116C6@smtp.kernel.org>
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
Date: Thu, 8 Jan 2026 03:32:46 +0000

Fix two bugs in demote_folio_list() and can_demote() due to incorrect
demotion target checks in reclaim/demotion.

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

To address these bugs, update cpuset_node_allowed() to return
effective_mems and mem_cgroup_node_allowed() to filter out nodes that are
not set in effective_mems.  Also update can_demote() and
demote_folio_list() accordingly.

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

Link: https://lkml.kernel.org/r/20260108033248.2791579-2-bingjiao@google.com
Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
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
 mm/vmscan.c                |   28 ++++++++++++------
 5 files changed, 75 insertions(+), 35 deletions(-)

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
@@ -1736,7 +1736,7 @@ static inline void count_objcg_events(st
 	rcu_read_unlock();
 }
 
-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
+void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask);
 
 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
 
@@ -1807,9 +1807,9 @@ static inline ino_t page_cgroup_ino(stru
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
@@ -4416,40 +4416,58 @@ bool cpuset_current_node_allowed(int nod
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
@@ -5593,9 +5593,21 @@ subsys_initcall(mem_cgroup_swap_init);
 
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
@@ -344,19 +344,21 @@ static void flush_reclaim_state(struct s
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
@@ -1018,7 +1020,8 @@ static struct folio *alloc_demote_folio(
  * Folios which are not demoted are left on @demote_folios.
  */
 static unsigned int demote_folio_list(struct list_head *demote_folios,
-				     struct pglist_data *pgdat)
+				      struct pglist_data *pgdat,
+				      struct mem_cgroup *memcg)
 {
 	int target_nid = next_demotion_node(pgdat->node_id);
 	unsigned int nr_succeeded;
@@ -1032,7 +1035,6 @@ static unsigned int demote_folio_list(st
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
-		.nid = target_nid,
 		.nmask = &allowed_mask,
 		.reason = MR_DEMOTION,
 	};
@@ -1041,9 +1043,17 @@ static unsigned int demote_folio_list(st
 		return 0;
 
 	if (target_nid == NUMA_NO_NODE)
+		/* No lower-tier nodes or nodes were hot-unplugged. */
 		return 0;
 
 	node_get_allowed_targets(pgdat, &allowed_mask);
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return 0;
+
+	if (!node_isset(target_nid, allowed_mask))
+		target_nid = node_random(&allowed_mask);
+	mtc.nid = target_nid;
 
 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
@@ -1565,7 +1575,7 @@ keep:
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
mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list.patch

