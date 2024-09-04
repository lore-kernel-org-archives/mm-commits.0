Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA0A74402
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423482; cv=none; b=XSxTcVNGIWUhY8wiOiyoE/qStzZvH5OTzeEKu14va8ZzOKzcFbORP2WItN3WLVIPTQaJZR/GUsWn9KLg0d+xTYautuJPNJZnEVRqTWIzTF9qitr8wp7J+Dc0H9o95mgdaOz3PR/BsNyurpmxUmir1ZxzniA907BlUBGMMa1hB8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423482; c=relaxed/simple;
	bh=f6pTRePjGAX9kCqVKrCjDJAlfdlj4n6zDk4PML2mLrg=;
	h=Date:To:From:Subject:Message-Id; b=ftJOfjctMvtlWVCy31GCbnVqj5km5m9TApqUOpwbxjGLZXCLWm/+U75GF/Yh9/hzLbkzX8CKGMFSQax7jDbBzZkDkgG4BkeVpVL7fWHm7Jp4dU0FFWpf+DmRoE+DMbHqw1QRX/hFD8jgH2j9EC374Ksm9paElEW5Mb11YIT5jx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ikOAhUB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ikOAhUB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A1CC4CEC2;
	Wed,  4 Sep 2024 04:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423482;
	bh=f6pTRePjGAX9kCqVKrCjDJAlfdlj4n6zDk4PML2mLrg=;
	h=Date:To:From:Subject:From;
	b=ikOAhUB+F6Zkdy3vZUSKkUGPsyn5UAzW34qV5Y7Jk9gePtLmwmbj4FsNDoWotjL8G
	 lFH9mAiDKqyme+KAHuxrY79axDbBlpx2rUW4zj+X1gtYF4lRPjNZFR0Winry5UmNqv
	 v92hNv6HEJtZwU6qbVQfaBuwQRk8P6ID3+VZoFNM=
Date: Tue, 03 Sep 2024 21:18:01 -0700
To: mm-commits@vger.kernel.org,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kaiyang2@cs.cmu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch removed from -mm tree
Message-Id: <20240904041802.72A1CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,memcg: provide per-cgroup counters for NUMA balancing operations
has been removed from the -mm tree.  Its filename was
     mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Subject: mm,memcg: provide per-cgroup counters for NUMA balancing operations
Date: Wed, 14 Aug 2024 17:42:27 +0000

The ability to observe the demotion and promotion decisions made by the
kernel on a per-cgroup basis is important for monitoring and tuning
containerized workloads on machines equipped with tiered memory.

Different containers in the system may experience drastically different
memory tiering actions that cannot be distinguished from the global
counters alone.

For example, a container running a workload that has a much hotter memory
accesses will likely see more promotions and fewer demotions, potentially
depriving a colocated container of top tier memory to such an extent that
its performance degrades unacceptably.

For another example, some containers may exhibit longer periods between
data reuse, causing much more numa_hint_faults than numa_pages_migrated. 
In this case, tuning hot_threshold_ms may be appropriate, but the signal
can easily be lost if only global counters are available.

In the long term, we hope to introduce per-cgroup control of promotion and
demotion actions to implement memory placement policies in tiering.

This patch set adds seven counters to memory.stat in a cgroup:
numa_pages_migrated, numa_pte_updates, numa_hint_faults, pgdemote_kswapd,
pgdemote_khugepaged, pgdemote_direct and pgpromote_success.  pgdemote_*
and pgpromote_success are also available in memory.numa_stat.

count_memcg_events_mm() is added to count multiple event occurrences at
once, and get_mem_cgroup_from_folio() is added because we need to get a
reference to the memcg of a folio before it's migrated to track
numa_pages_migrated.  The accounting of PGDEMOTE_* is moved to
shrink_inactive_list() before being changed to per-cgroup.

[kaiyang2@cs.cmu.edu: add documentation of the memcg counters in cgroup-v2.rst]
  Link: https://lkml.kernel.org/r/20240814235122.252309-1-kaiyang2@cs.cmu.edu
Link: https://lkml.kernel.org/r/20240814174227.30639-1-kaiyang2@cs.cmu.edu
Signed-off-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   19 +++++++++
 include/linux/memcontrol.h              |   24 ++++++++++-
 include/linux/vmstat.h                  |    1 
 mm/memcontrol.c                         |   45 ++++++++++++++++++++++
 mm/memory.c                             |    3 +
 mm/mempolicy.c                          |    4 +
 mm/migrate.c                            |    7 ++-
 mm/vmscan.c                             |    8 +--
 8 files changed, 101 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1617,6 +1617,25 @@ The following nested keys are defined.
 		Usually because failed to allocate some continuous swap space
 		for the huge page.
 
+	  numa_pages_migrated (npn)
+		Number of pages migrated by NUMA balancing.
+
+	  numa_pte_updates (npn)
+		Number of pages whose page table entries are modified by
+		NUMA balancing to produce NUMA hinting faults on access.
+
+	  numa_hint_faults (npn)
+		Number of NUMA hinting faults.
+
+	  pgdemote_kswapd
+		Number of pages demoted by kswapd.
+
+	  pgdemote_direct
+		Number of pages demoted directly.
+
+	  pgdemote_khugepaged
+		Number of pages demoted by khugepaged.
+
   memory.numa_stat
 	A read-only nested-keyed file which exists on non-root cgroups.
 
--- a/include/linux/memcontrol.h~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations
+++ a/include/linux/memcontrol.h
@@ -784,6 +784,8 @@ struct mem_cgroup *get_mem_cgroup_from_m
 
 struct mem_cgroup *get_mem_cgroup_from_current(void);
 
+struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio);
+
 struct lruvec *folio_lruvec_lock(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
@@ -1028,8 +1030,8 @@ static inline void count_memcg_folio_eve
 		count_memcg_events(memcg, idx, nr);
 }
 
-static inline void count_memcg_event_mm(struct mm_struct *mm,
-					enum vm_event_item idx)
+static inline void count_memcg_events_mm(struct mm_struct *mm,
+					enum vm_event_item idx, unsigned long count)
 {
 	struct mem_cgroup *memcg;
 
@@ -1039,10 +1041,16 @@ static inline void count_memcg_event_mm(
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	if (likely(memcg))
-		count_memcg_events(memcg, idx, 1);
+		count_memcg_events(memcg, idx, count);
 	rcu_read_unlock();
 }
 
+static inline void count_memcg_event_mm(struct mm_struct *mm,
+					enum vm_event_item idx)
+{
+	count_memcg_events_mm(mm, idx, 1);
+}
+
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
@@ -1262,6 +1270,11 @@ static inline struct mem_cgroup *get_mem
 	return NULL;
 }
 
+static inline struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+{
+	return NULL;
+}
+
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css)
 {
@@ -1484,6 +1497,11 @@ static inline void count_memcg_folio_eve
 {
 }
 
+static inline void count_memcg_events_mm(struct mm_struct *mm,
+					enum vm_event_item idx, unsigned long count)
+{
+}
+
 static inline
 void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
 {
--- a/include/linux/vmstat.h~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations
+++ a/include/linux/vmstat.h
@@ -32,6 +32,7 @@ struct reclaim_stat {
 	unsigned nr_ref_keep;
 	unsigned nr_unmap_fail;
 	unsigned nr_lazyfree_fail;
+	unsigned nr_demoted;
 };
 
 /* Stat data for system wide items */
--- a/mm/memcontrol.c~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations
+++ a/mm/memcontrol.c
@@ -304,6 +304,12 @@ static const unsigned int memcg_node_sta
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
+#ifdef CONFIG_NUMA_BALANCING
+	PGPROMOTE_SUCCESS,
+#endif
+	PGDEMOTE_KSWAPD,
+	PGDEMOTE_DIRECT,
+	PGDEMOTE_KHUGEPAGED,
 };
 
 static const unsigned int memcg_stat_items[] = {
@@ -436,6 +442,11 @@ static const unsigned int memcg_vm_event
 	THP_SWPOUT,
 	THP_SWPOUT_FALLBACK,
 #endif
+#ifdef CONFIG_NUMA_BALANCING
+	NUMA_PAGE_MIGRATE,
+	NUMA_PTE_UPDATES,
+	NUMA_HINT_FAULTS,
+#endif
 };
 
 #define NR_MEMCG_EVENTS ARRAY_SIZE(memcg_vm_event_stat)
@@ -936,6 +947,24 @@ again:
 }
 
 /**
+ * get_mem_cgroup_from_folio - Obtain a reference on a given folio's memcg.
+ * @folio: folio from which memcg should be extracted.
+ */
+struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+{
+	struct mem_cgroup *memcg = folio_memcg(folio);
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	rcu_read_lock();
+	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
+		memcg = root_mem_cgroup;
+	rcu_read_unlock();
+	return memcg;
+}
+
+/**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
  * @prev: previously returned memcg, NULL on first invocation
@@ -1340,6 +1369,13 @@ static const struct memory_stat memory_s
 	{ "workingset_restore_anon",	WORKINGSET_RESTORE_ANON		},
 	{ "workingset_restore_file",	WORKINGSET_RESTORE_FILE		},
 	{ "workingset_nodereclaim",	WORKINGSET_NODERECLAIM		},
+
+	{ "pgdemote_kswapd",		PGDEMOTE_KSWAPD		},
+	{ "pgdemote_direct",		PGDEMOTE_DIRECT		},
+	{ "pgdemote_khugepaged",	PGDEMOTE_KHUGEPAGED	},
+#ifdef CONFIG_NUMA_BALANCING
+	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
+#endif
 };
 
 /* The actual unit of the state item, not the same as the output unit */
@@ -1364,6 +1400,9 @@ static int memcg_page_state_output_unit(
 	/*
 	 * Workingset state is actually in pages, but we export it to userspace
 	 * as a scalar count of events, so special case it here.
+	 *
+	 * Demotion and promotion activities are exported in pages, consistent
+	 * with their global counterparts.
 	 */
 	switch (item) {
 	case WORKINGSET_REFAULT_ANON:
@@ -1373,6 +1412,12 @@ static int memcg_page_state_output_unit(
 	case WORKINGSET_RESTORE_ANON:
 	case WORKINGSET_RESTORE_FILE:
 	case WORKINGSET_NODERECLAIM:
+	case PGDEMOTE_KSWAPD:
+	case PGDEMOTE_DIRECT:
+	case PGDEMOTE_KHUGEPAGED:
+#ifdef CONFIG_NUMA_BALANCING
+	case PGPROMOTE_SUCCESS:
+#endif
 		return 1;
 	default:
 		return memcg_page_state_unit(item);
--- a/mm/memory.c~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations
+++ a/mm/memory.c
@@ -5236,6 +5236,9 @@ int numa_migrate_check(struct folio *fol
 	vma_set_access_pid_bit(vma);
 
 	count_vm_numa_event(NUMA_HINT_FAULTS);
+#ifdef CONFIG_NUMA_BALANCING
+	count_memcg_folio_events(folio, NUMA_HINT_FAULTS, 1);
+#endif
 	if (folio_nid(folio) == numa_node_id()) {
 		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
 		*flags |= TNF_FAULT_LOCAL;
--- a/mm/mempolicy.c~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations
+++ a/mm/mempolicy.c
@@ -676,8 +676,10 @@ unsigned long change_prot_numa(struct vm
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
 	nr_updated = change_protection(&tlb, vma, addr, end, MM_CP_PROT_NUMA);
-	if (nr_updated > 0)
+	if (nr_updated > 0) {
 		count_vm_numa_events(NUMA_PTE_UPDATES, nr_updated);
+		count_memcg_events_mm(vma->vm_mm, NUMA_PTE_UPDATES, nr_updated);
+	}
 
 	tlb_finish_mmu(&tlb);
 
--- a/mm/migrate.c~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations
+++ a/mm/migrate.c
@@ -2614,6 +2614,8 @@ int migrate_misplaced_folio(struct folio
 	int nr_remaining;
 	unsigned int nr_succeeded;
 	LIST_HEAD(migratepages);
+	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	list_add(&folio->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_folio,
@@ -2623,12 +2625,13 @@ int migrate_misplaced_folio(struct folio
 		putback_movable_pages(&migratepages);
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
+		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
 		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
 		    && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node))
-			mod_node_page_state(pgdat, PGPROMOTE_SUCCESS,
-					    nr_succeeded);
+			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
 	}
+	mem_cgroup_put(memcg);
 	BUG_ON(!list_empty(&migratepages));
 	return nr_remaining ? -EAGAIN : 0;
 }
--- a/mm/vmscan.c~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations
+++ a/mm/vmscan.c
@@ -1016,9 +1016,6 @@ static unsigned int demote_folio_list(st
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
 		      &nr_succeeded);
 
-	mod_node_page_state(pgdat, PGDEMOTE_KSWAPD + reclaimer_offset(),
-			    nr_succeeded);
-
 	return nr_succeeded;
 }
 
@@ -1516,7 +1513,8 @@ keep:
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
-	nr_reclaimed += demote_folio_list(&demote_folios, pgdat);
+	stat->nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_reclaimed += stat->nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
 		/* Folios which weren't demoted go back on @folio_list */
@@ -1982,6 +1980,8 @@ static unsigned long shrink_inactive_lis
 	spin_lock_irq(&lruvec->lru_lock);
 	move_folios_to_lru(lruvec, &folio_list);
 
+	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(),
+					stat.nr_demoted);
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
_

Patches currently in -mm which might be from kaiyang2@cs.cmu.edu are


