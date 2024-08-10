Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9CADDDC
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 00:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723249812; cv=none; b=bd4wReKH7tM+Z9cKROW4Sdh1nLR1/nCebUyxQx69fNiKzaY+zwkhVX7VU9+V9VLiu1kc+NtTWUORUVDOHfFHezKSiYz73SAQpn87ssnLVy0yceSBeX95bXrw43lnoV+34lhjOGNhZKnDvZD8N13bTkK9uDcp9JvN3l7ko5h0M34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723249812; c=relaxed/simple;
	bh=pe/t7lyDMelxmM6IQfeoXZtCfTGgCQZcBBt9CYygr1A=;
	h=Date:To:From:Subject:Message-Id; b=YaoSOdPMv/FcPedQ4ZQfDYrKiNy6Dvw8H3a/E03g3SSo2avlCMGlwx5lzwhrplB5HXVv2cTaqPvbeLjFzyyUNrRjk2+TL7g3j8q6Xfw0Icn1Fq59bLn3wbDKU9KrnCoUvJLu3oHSVpxtSrNRxoa2ocNeV4hzOdH6sQwqKo9dpsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vV1H2Jyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vV1H2Jyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F61FC32782;
	Sat, 10 Aug 2024 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723249812;
	bh=pe/t7lyDMelxmM6IQfeoXZtCfTGgCQZcBBt9CYygr1A=;
	h=Date:To:From:Subject:From;
	b=vV1H2JynWPmUnO0mG2kUeHsaca5rlSBGSKkWvdKEd4soct8aikKDD1A77Y+svJUw8
	 my6uZYYWD+S1fS56DjHWER7yhHk2i5tD4WghVYtw7anV3q46L32hb5khvW8r5gNqcS
	 ibXLfRVKK7vZX/svWjpUlCRUZwvh7EBUeBea3y5o=
Date: Fri, 09 Aug 2024 17:30:11 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kaiyang2@cs.cmu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch added to mm-unstable branch
Message-Id: <20240810003012.2F61FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,memcg: provide per-cgroup counters for NUMA balancing operations
has been added to the -mm mm-unstable branch.  Its filename is
     mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch

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
From: kaiyang2@cs.cmu.edu
Subject: mm,memcg: provide per-cgroup counters for NUMA balancing operations
Date: Fri, 9 Aug 2024 21:21:15 +0000


The ability to observe the demotion and promotion decisions made by the
kernel on a per-cgroup basis is important for monitoring and tuning
containerized workloads on either NUMA machines or machines
equipped with tiered memory.

Different containers in the system may experience drastically different
memory tiering actions that cannot be distinguished from the global
counters alone.

For example, a container running a workload that has a much hotter
memory accesses will likely see more promotions and fewer demotions,
potentially depriving a colocated container of top tier memory to such
an extent that its performance degrades unacceptably.

For another example, some containers may exhibit longer periods between
data reuse, causing much more numa_hint_faults than numa_pages_migrated.
In this case, tuning hot_threshold_ms may be appropriate, but the signal
can easily be lost if only global counters are available.

This patch set adds five counters to
memory.stat in a cgroup: numa_pages_migrated, numa_pte_updates,
numa_hint_faults, pgdemote_kswapd and pgdemote_direct.

count_memcg_events_mm() is added to count multiple event occurrences at
once, and get_mem_cgroup_from_folio() is added because we need to get a
reference to the memcg of a folio before it's migrated to track
numa_pages_migrated. The accounting of PGDEMOTE_* is moved to
shrink_inactive_list() before being changed to per-cgroup.

Link: https://lkml.kernel.org/r/20240809212115.59291-1-kaiyang2@cs.cmu.edu
Signed-off-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   24 +++++++++++++++++++++---
 include/linux/vmstat.h     |    1 +
 mm/memcontrol.c            |   32 ++++++++++++++++++++++++++++++++
 mm/memory.c                |    1 +
 mm/mempolicy.c             |    4 +++-
 mm/migrate.c               |    3 +++
 mm/vmscan.c                |    8 ++++----
 7 files changed, 65 insertions(+), 8 deletions(-)

--- a/include/linux/memcontrol.h~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations
+++ a/include/linux/memcontrol.h
@@ -768,6 +768,8 @@ struct mem_cgroup *get_mem_cgroup_from_m
 
 struct mem_cgroup *get_mem_cgroup_from_current(void);
 
+struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio);
+
 struct lruvec *folio_lruvec_lock(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
@@ -1012,8 +1014,8 @@ static inline void count_memcg_folio_eve
 		count_memcg_events(memcg, idx, nr);
 }
 
-static inline void count_memcg_event_mm(struct mm_struct *mm,
-					enum vm_event_item idx)
+static inline void count_memcg_events_mm(struct mm_struct *mm,
+					enum vm_event_item idx, unsigned long count)
 {
 	struct mem_cgroup *memcg;
 
@@ -1023,10 +1025,16 @@ static inline void count_memcg_event_mm(
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
@@ -1246,6 +1254,11 @@ static inline struct mem_cgroup *get_mem
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
@@ -1468,6 +1481,11 @@ static inline void count_memcg_folio_eve
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
@@ -307,6 +307,9 @@ static const unsigned int memcg_node_sta
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
+	PGDEMOTE_KSWAPD,
+	PGDEMOTE_DIRECT,
+	PGDEMOTE_KHUGEPAGED,
 };
 
 static const unsigned int memcg_stat_items[] = {
@@ -437,6 +440,11 @@ static const unsigned int memcg_vm_event
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
@@ -979,6 +987,23 @@ again:
 }
 
 /**
+ * get_mem_cgroup_from_folio - Obtain a reference on a given folio's memcg.
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
@@ -1383,6 +1408,10 @@ static const struct memory_stat memory_s
 	{ "workingset_restore_anon",	WORKINGSET_RESTORE_ANON		},
 	{ "workingset_restore_file",	WORKINGSET_RESTORE_FILE		},
 	{ "workingset_nodereclaim",	WORKINGSET_NODERECLAIM		},
+
+	{ "pgdemote_kswapd",		PGDEMOTE_KSWAPD		},
+	{ "pgdemote_direct",		PGDEMOTE_DIRECT		},
+	{ "pgdemote_khugepaged",	PGDEMOTE_KHUGEPAGED	},
 };
 
 /* The actual unit of the state item, not the same as the output unit */
@@ -1416,6 +1445,9 @@ static int memcg_page_state_output_unit(
 	case WORKINGSET_RESTORE_ANON:
 	case WORKINGSET_RESTORE_FILE:
 	case WORKINGSET_NODERECLAIM:
+	case PGDEMOTE_KSWAPD:
+	case PGDEMOTE_DIRECT:
+	case PGDEMOTE_KHUGEPAGED:
 		return 1;
 	default:
 		return memcg_page_state_unit(item);
--- a/mm/memory.c~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations
+++ a/mm/memory.c
@@ -5400,6 +5400,7 @@ int numa_migrate_check(struct folio *fol
 	vma_set_access_pid_bit(vma);
 
 	count_vm_numa_event(NUMA_HINT_FAULTS);
+	count_memcg_folio_events(folio, NUMA_HINT_FAULTS, 1);
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
@@ -2614,6 +2614,7 @@ int migrate_misplaced_folio(struct folio
 	int nr_remaining;
 	unsigned int nr_succeeded;
 	LIST_HEAD(migratepages);
+	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
 
 	list_add(&folio->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_folio,
@@ -2623,12 +2624,14 @@ int migrate_misplaced_folio(struct folio
 		putback_movable_pages(&migratepages);
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
+		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
 		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
 		    && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node))
 			mod_node_page_state(pgdat, PGPROMOTE_SUCCESS,
 					    nr_succeeded);
 	}
+	mem_cgroup_put(memcg);
 	BUG_ON(!list_empty(&migratepages));
 	return nr_remaining ? -EAGAIN : 0;
 }
--- a/mm/vmscan.c~mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations
+++ a/mm/vmscan.c
@@ -1008,9 +1008,6 @@ static unsigned int demote_folio_list(st
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
 		      &nr_succeeded);
 
-	mod_node_page_state(pgdat, PGDEMOTE_KSWAPD + reclaimer_offset(),
-			    nr_succeeded);
-
 	return nr_succeeded;
 }
 
@@ -1518,7 +1515,8 @@ keep:
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
-	nr_reclaimed += demote_folio_list(&demote_folios, pgdat);
+	stat->nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_reclaimed += stat->nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
 		/* Folios which weren't demoted go back on @folio_list */
@@ -1984,6 +1982,8 @@ static unsigned long shrink_inactive_lis
 	spin_lock_irq(&lruvec->lru_lock);
 	move_folios_to_lru(lruvec, &folio_list);
 
+	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(),
+					stat.nr_demoted);
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
_

Patches currently in -mm which might be from kaiyang2@cs.cmu.edu are

mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node.patch
mm-create-promo_wmark_pages-and-clean-up-open-coded-sites.patch
mm-print-the-promo-watermark-in-zoneinfo.patch
mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch

