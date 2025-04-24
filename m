Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242FF289376
	for <mm-commits@vger.kernel.org>; Thu, 24 Apr 2025 21:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745531450; cv=none; b=MzgGxOhcKNa3GznzFWW+SNoBjJedVHgF2sIqyc5e+vuIoFyCGAuYOc97AmuEQ0CMtk7zku2giX03SKqlGwr23KX+6LIAtFQA1Vcwgvod6yYcc8y1kXF7ib2cPf0R792Fhg01Tp+SxF+mpUIh+HmJk+bYe9Ggf3lM01/euVfzcCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745531450; c=relaxed/simple;
	bh=YThEEB8N9NSb7rs9obYHSeQEOV2mGCIbkd3X6r1yADc=;
	h=Date:To:From:Subject:Message-Id; b=fPXbmal2tdC8RzdW80N6xwcqi/qVSvROFBAn4+iqnd/vfuqfclqhUSiVIzCcMKuFs7fmEMwcPmiVqqPB0O/FrFWrmhdgGE71591eJLzswaoDFFuJbYSPAriMD4XN+FqBLf31Lq26DruoLePXUrePUo7Cj5J7vaVjCg8ex8ISHoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sCITXF3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sCITXF3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19E0C4CEE3;
	Thu, 24 Apr 2025 21:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745531449;
	bh=YThEEB8N9NSb7rs9obYHSeQEOV2mGCIbkd3X6r1yADc=;
	h=Date:To:From:Subject:From;
	b=sCITXF3CEREsCr/PCTsIwiwM/B3NvBw1MafmlLSvAuvsanw+/Zgaj7upHrJzYrU5H
	 um7IFBMFKwjBC4DMtHa5lD6X5a3OP6O1wuk/nyAiP0kHk4lRWKlMySY+t19wA1lt/I
	 +rA2d4BkkZrf6FZvubfNtOASXFmex8ac/7QGmvds=
Date: Thu, 24 Apr 2025 14:50:49 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,hannes@cmpxchg.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscancgroup-apply-mems_effective-to-reclaim.patch added to mm-unstable branch
Message-Id: <20250424215049.C19E0C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmscan,cgroup: apply mems_effective to reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     vmscancgroup-apply-mems_effective-to-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmscancgroup-apply-mems_effective-to-reclaim.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: vmscan,cgroup: apply mems_effective to reclaim
Date: Thu, 24 Apr 2025 16:28:06 -0400

It is possible for a reclaimer to cause demotions of an lruvec belonging
to a cgroup with cpuset.mems set to exclude some nodes.  Attempt to apply
this limitation based on the lruvec's memcg and prevent demotion.

Notably, this may still allow demotion of shared libraries or any memory
first instantiated in another cgroup.  This means cpusets still cannot
cannot guarantee complete isolation when demotion is enabled, and the docs
have been updated to reflect this.

This is useful for isolating workloads on a multi-tenant system from
certain classes of memory more consistently - with the noted exceptions.

Note on locking:

The cgroup_get_e_css reference protects the css->effective_mems, and calls
of this interface would be subject to the same race conditions associated
with a non-atomic access to cs->effective_mems.

So while this interface cannot make strong guarantees of correctness, it
can therefore avoid taking a global or rcu_read_lock for performance.

Link: https://lkml.kernel.org/r/20250424202806.52632-3-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Waiman Long <longman@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Waiman Long <longman@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-numa |   16 +++--
 include/linux/cpuset.h                         |    5 +
 include/linux/memcontrol.h                     |    7 ++
 kernel/cgroup/cpuset.c                         |   36 +++++++++++++
 mm/memcontrol.c                                |    6 ++
 mm/vmscan.c                                    |   41 +++++++++------
 6 files changed, 89 insertions(+), 22 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-numa~vmscancgroup-apply-mems_effective-to-reclaim
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-numa
@@ -16,9 +16,13 @@ Description:	Enable/disable demoting pag
 		Allowing page migration during reclaim enables these
 		systems to migrate pages from fast tiers to slow tiers
 		when the fast tier is under pressure.  This migration
-		is performed before swap.  It may move data to a NUMA
-		node that does not fall into the cpuset of the
-		allocating process which might be construed to violate
-		the guarantees of cpusets.  This should not be enabled
-		on systems which need strict cpuset location
-		guarantees.
+		is performed before swap if an eligible numa node is
+		present in cpuset.mems for the cgroup (or if cpuset v1
+		is being used). If cpusets.mems changes at runtime, it
+		may move data to a NUMA node that does not fall into the
+		cpuset of the new cpusets.mems, which might be construed
+		to violate the guarantees of cpusets.  Shared memory,
+		such as libraries, owned by another cgroup may still be
+		demoted and result in memory use on a node not present
+		in cpusets.mem. This should not be enabled on systems
+		which need strict cpuset location guarantees.
--- a/include/linux/cpuset.h~vmscancgroup-apply-mems_effective-to-reclaim
+++ a/include/linux/cpuset.h
@@ -173,6 +173,7 @@ static inline void set_mems_allowed(node
 	task_unlock(current);
 }
 
+extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
 #else /* !CONFIG_CPUSETS */
 
 static inline bool cpusets_enabled(void) { return false; }
@@ -293,6 +294,10 @@ static inline bool read_mems_allowed_ret
 	return false;
 }
 
+static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+{
+	return true;
+}
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
--- a/include/linux/memcontrol.h~vmscancgroup-apply-mems_effective-to-reclaim
+++ a/include/linux/memcontrol.h
@@ -1736,6 +1736,8 @@ static inline void count_objcg_events(st
 	rcu_read_unlock();
 }
 
+bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
+
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1797,6 +1799,11 @@ static inline ino_t page_cgroup_ino(stru
 {
 	return 0;
 }
+
+static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+{
+	return true;
+}
 #endif /* CONFIG_MEMCG */
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
--- a/kernel/cgroup/cpuset.c~vmscancgroup-apply-mems_effective-to-reclaim
+++ a/kernel/cgroup/cpuset.c
@@ -4237,6 +4237,42 @@ bool cpuset_current_node_allowed(int nod
 	return allowed;
 }
 
+bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+{
+	struct cgroup_subsys_state *css;
+	struct cpuset *cs;
+	bool allowed;
+
+	/*
+	 * In v1, mem_cgroup and cpuset are unlikely in the same hierarchy
+	 * and mems_allowed is likely to be empty even if we could get to it,
+	 * so return true to avoid taking a global lock on the empty check.
+	 */
+	if (!cpuset_v2())
+		return true;
+
+	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
+	if (!css)
+		return true;
+
+	/*
+	 * Normally, accessing effective_mems would require the cpuset_mutex
+	 * or callback_lock - but node_isset is atomic and the reference
+	 * taken via cgroup_get_e_css is sufficient to protect css.
+	 *
+	 * Since this interface is intended for use by migration paths, we
+	 * relax locking here to avoid taking global locks - while accepting
+	 * there may be rare scenarios where the result may be innaccurate.
+	 *
+	 * Reclaim and migration are subject to these same race conditions, and
+	 * cannot make strong isolation guarantees, so this is acceptable.
+	 */
+	cs = container_of(css, struct cpuset, css);
+	allowed = node_isset(nid, cs->effective_mems);
+	css_put(css);
+	return allowed;
+}
+
 /**
  * cpuset_spread_node() - On which node to begin search for a page
  * @rotor: round robin rotor
--- a/mm/memcontrol.c~vmscancgroup-apply-mems_effective-to-reclaim
+++ a/mm/memcontrol.c
@@ -29,6 +29,7 @@
 #include <linux/page_counter.h>
 #include <linux/memcontrol.h>
 #include <linux/cgroup.h>
+#include <linux/cpuset.h>
 #include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
@@ -5511,3 +5512,8 @@ static int __init mem_cgroup_swap_init(v
 subsys_initcall(mem_cgroup_swap_init);
 
 #endif /* CONFIG_SWAP */
+
+bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+{
+	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
+}
--- a/mm/vmscan.c~vmscancgroup-apply-mems_effective-to-reclaim
+++ a/mm/vmscan.c
@@ -342,16 +342,22 @@ static void flush_reclaim_state(struct s
 	}
 }
 
-static bool can_demote(int nid, struct scan_control *sc)
+static bool can_demote(int nid, struct scan_control *sc,
+		       struct mem_cgroup *memcg)
 {
+	int demotion_nid;
+
 	if (!numa_demotion_enabled)
 		return false;
 	if (sc && sc->no_demotion)
 		return false;
-	if (next_demotion_node(nid) == NUMA_NO_NODE)
+
+	demotion_nid = next_demotion_node(nid);
+	if (demotion_nid == NUMA_NO_NODE)
 		return false;
 
-	return true;
+	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
+	return mem_cgroup_node_allowed(memcg, demotion_nid);
 }
 
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
@@ -376,7 +382,7 @@ static inline bool can_reclaim_anon_page
 	 *
 	 * Can it be reclaimed from this node via demotion?
 	 */
-	return can_demote(nid, sc);
+	return can_demote(nid, sc, memcg);
 }
 
 /*
@@ -1096,7 +1102,8 @@ static bool may_enter_fs(struct folio *f
  */
 static unsigned int shrink_folio_list(struct list_head *folio_list,
 		struct pglist_data *pgdat, struct scan_control *sc,
-		struct reclaim_stat *stat, bool ignore_references)
+		struct reclaim_stat *stat, bool ignore_references,
+		struct mem_cgroup *memcg)
 {
 	struct folio_batch free_folios;
 	LIST_HEAD(ret_folios);
@@ -1109,7 +1116,7 @@ static unsigned int shrink_folio_list(st
 	folio_batch_init(&free_folios);
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
-	do_demote_pass = can_demote(pgdat->node_id, sc);
+	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
 
 retry:
 	while (!list_empty(folio_list)) {
@@ -1658,7 +1665,7 @@ unsigned int reclaim_clean_pages_from_li
 	 */
 	noreclaim_flag = memalloc_noreclaim_save();
 	nr_reclaimed = shrink_folio_list(&clean_folios, zone->zone_pgdat, &sc,
-					&stat, true);
+					&stat, true, NULL);
 	memalloc_noreclaim_restore(noreclaim_flag);
 
 	list_splice(&clean_folios, folio_list);
@@ -2029,7 +2036,8 @@ static unsigned long shrink_inactive_lis
 	if (nr_taken == 0)
 		return 0;
 
-	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false);
+	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
+					 lruvec_memcg(lruvec));
 
 	spin_lock_irq(&lruvec->lru_lock);
 	move_folios_to_lru(lruvec, &folio_list);
@@ -2212,7 +2220,7 @@ static unsigned int reclaim_folio_list(s
 		.no_demotion = 1,
 	};
 
-	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &stat, true);
+	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &stat, true, NULL);
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
@@ -2644,7 +2652,7 @@ out:
  * Anonymous LRU management is a waste if there is
  * ultimately no way to reclaim the memory.
  */
-static bool can_age_anon_pages(struct pglist_data *pgdat,
+static bool can_age_anon_pages(struct lruvec *lruvec,
 			       struct scan_control *sc)
 {
 	/* Aging the anon LRU is valuable if swap is present: */
@@ -2652,7 +2660,8 @@ static bool can_age_anon_pages(struct pg
 		return true;
 
 	/* Also valuable if anon pages can be demoted: */
-	return can_demote(pgdat->node_id, sc);
+	return can_demote(lruvec_pgdat(lruvec)->node_id, sc,
+			  lruvec_memcg(lruvec));
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -2730,7 +2739,7 @@ static int get_swappiness(struct lruvec
 	if (!sc->may_swap)
 		return 0;
 
-	if (!can_demote(pgdat->node_id, sc) &&
+	if (!can_demote(pgdat->node_id, sc, memcg) &&
 	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
 		return 0;
 
@@ -4693,7 +4702,7 @@ static int evict_folios(struct lruvec *l
 	if (list_empty(&list))
 		return scanned;
 retry:
-	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false);
+	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
@@ -5848,7 +5857,7 @@ static void shrink_lruvec(struct lruvec
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (can_age_anon_pages(lruvec_pgdat(lruvec), sc) &&
+	if (can_age_anon_pages(lruvec, sc) &&
 	    inactive_is_low(lruvec, LRU_INACTIVE_ANON))
 		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 				   sc, LRU_ACTIVE_ANON);
@@ -6679,10 +6688,10 @@ static void kswapd_age_node(struct pglis
 		return;
 	}
 
-	if (!can_age_anon_pages(pgdat, sc))
+	lruvec = mem_cgroup_lruvec(NULL, pgdat);
+	if (!can_age_anon_pages(lruvec, sc))
 		return;
 
-	lruvec = mem_cgroup_lruvec(NULL, pgdat);
 	if (!inactive_is_low(lruvec, LRU_INACTIVE_ANON))
 		return;
 
_

Patches currently in -mm which might be from gourry@gourry.net are

memory-implement-memory_block_advise-probe_max_size.patch
x86-probe-memory-block-size-advisement-value-during-mm-init.patch
acpisrat-give-memory-block-size-advice-based-on-cfmws-alignment.patch
cpuset-rename-cpuset_node_allowed-to-cpuset_current_node_allowed.patch
vmscancgroup-apply-mems_effective-to-reclaim.patch

