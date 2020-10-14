Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE71CC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7596222253
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709226;
	bh=JA6PtGnQrIMidKtdlevWw8ayM/CrQSjfOecpeN4iJtY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=e4WaDWibQJcN2JxGxz2YB/eCk1mNfM7Il6qFKfa7YswXNlclUvLBnTSKi6pn+iFS8
	 /QyXfPe8XH7S56bLuIyEt2uqdg8zT/KiHCZmzYUTBEcD+GwcJ5CuE0h2TKq5erqxef
	 kX/d0zf5NHQK1h2l7PP0pzHUcA1zbwkDKgf3YZZg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgJNVA0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNVAZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:00:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA74520725;
        Wed, 14 Oct 2020 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709223;
        bh=JA6PtGnQrIMidKtdlevWw8ayM/CrQSjfOecpeN4iJtY=;
        h=Date:From:To:Subject:From;
        b=klyitQDTNerhIq8MHL8wpBcuNxABduXDGAb8w/nXA1wRtFI9mE5cq4/AQVEoEZSPF
         0gMp72GJV6q+9XK84g4qZl4REyFvvQEC4I/isnIQWh7T+7OyCCLQrtdr+EXT+NJbje
         YxkfsheeaTXl2F0wcX5yK20EELfQ+ardDjXDEzaY=
Date:   Wed, 14 Oct 2020 14:00:22 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, guro@fb.com, hannes@cmpxchg.org,
        lizefan@huawei.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch
 removed from -mm tree
Message-ID: <20201014210022.Bq3f1drt1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: add the missing numa_stat interface for cgroup v2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: add the missing numa_stat interface for cgroup v2

In the cgroup v1, we have a numa_stat interface.  This is useful for
providing visibility into the numa locality information within an memcg
since the pages are allowed to be allocated from any physical node.  One
of the use cases is evaluating application performance by combining this
information with the application's CPU allocation.  But the cgroup v2 does
not.  So this patch adds the missing information.

Link: https://lkml.kernel.org/r/20200916100030.71698-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   69 ++++++--
 mm/memcontrol.c                         |  172 ++++++++++++++--------
 2 files changed, 160 insertions(+), 81 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1259,6 +1259,10 @@ PAGE_SIZE multiple when read back.
 	can show up in the middle. Don't rely on items remaining in a
 	fixed position; use the keys to look up specific values!
 
+	If the entry has no per-node counter(or not show in the
+	mempry.numa_stat). We use 'npn'(non-per-node) as the tag
+	to indicate that it will not show in the mempry.numa_stat.
+
 	  anon
 		Amount of memory used in anonymous mappings such as
 		brk(), sbrk(), and mmap(MAP_ANONYMOUS)
@@ -1270,15 +1274,11 @@ PAGE_SIZE multiple when read back.
 	  kernel_stack
 		Amount of memory allocated to kernel stacks.
 
-	  slab
-		Amount of memory used for storing in-kernel data
-		structures.
-
-	  percpu
+	  percpu(npn)
 		Amount of memory used for storing per-cpu kernel
 		data structures.
 
-	  sock
+	  sock(npn)
 		Amount of memory used in network transmission buffers
 
 	  shmem
@@ -1318,11 +1318,9 @@ PAGE_SIZE multiple when read back.
 		Part of "slab" that cannot be reclaimed on memory
 		pressure.
 
-	  pgfault
-		Total number of page faults incurred
-
-	  pgmajfault
-		Number of major page faults incurred
+	  slab(npn)
+		Amount of memory used for storing in-kernel data
+		structures.
 
 	  workingset_refault_anon
 		Number of refaults of previously evicted anonymous pages.
@@ -1348,37 +1346,68 @@ PAGE_SIZE multiple when read back.
 	  workingset_nodereclaim
 		Number of times a shadow node has been reclaimed
 
-	  pgrefill
+	  pgfault(npn)
+		Total number of page faults incurred
+
+	  pgmajfault(npn)
+		Number of major page faults incurred
+
+	  pgrefill(npn)
 		Amount of scanned pages (in an active LRU list)
 
-	  pgscan
+	  pgscan(npn)
 		Amount of scanned pages (in an inactive LRU list)
 
-	  pgsteal
+	  pgsteal(npn)
 		Amount of reclaimed pages
 
-	  pgactivate
+	  pgactivate(npn)
 		Amount of pages moved to the active LRU list
 
-	  pgdeactivate
+	  pgdeactivate(npn)
 		Amount of pages moved to the inactive LRU list
 
-	  pglazyfree
+	  pglazyfree(npn)
 		Amount of pages postponed to be freed under memory pressure
 
-	  pglazyfreed
+	  pglazyfreed(npn)
 		Amount of reclaimed lazyfree pages
 
-	  thp_fault_alloc
+	  thp_fault_alloc(npn)
 		Number of transparent hugepages which were allocated to satisfy
 		a page fault. This counter is not present when CONFIG_TRANSPARENT_HUGEPAGE
                 is not set.
 
-	  thp_collapse_alloc
+	  thp_collapse_alloc(npn)
 		Number of transparent hugepages which were allocated to allow
 		collapsing an existing range of pages. This counter is not
 		present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
 
+  memory.numa_stat
+	A read-only nested-keyed file which exists on non-root cgroups.
+
+	This breaks down the cgroup's memory footprint into different
+	types of memory, type-specific details, and other information
+	per node on the state of the memory management system.
+
+	This is useful for providing visibility into the NUMA locality
+	information within an memcg since the pages are allowed to be
+	allocated from any physical node. One of the use case is evaluating
+	application performance by combining this information with the
+	application's CPU allocation.
+
+	All memory amounts are in bytes.
+
+	The output format of memory.numa_stat is::
+
+	  type N0=<bytes in node 0> N1=<bytes in node 1> ...
+
+	The entries are ordered to be human readable, and new entries
+	can show up in the middle. Don't rely on items remaining in a
+	fixed position; use the keys to look up specific values!
+
+	The entries can refer to the memory.stat.
+
   memory.swap.current
 	A read-only single value file which exists on non-root
 	cgroups.
--- a/mm/memcontrol.c~mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2
+++ a/mm/memcontrol.c
@@ -1448,6 +1448,70 @@ static bool mem_cgroup_wait_acct_move(st
 	return false;
 }
 
+struct memory_stat {
+	const char *name;
+	unsigned int ratio;
+	unsigned int idx;
+};
+
+static struct memory_stat memory_stats[] = {
+	{ "anon", PAGE_SIZE, NR_ANON_MAPPED },
+	{ "file", PAGE_SIZE, NR_FILE_PAGES },
+	{ "kernel_stack", 1024, NR_KERNEL_STACK_KB },
+	{ "percpu", 1, MEMCG_PERCPU_B },
+	{ "sock", PAGE_SIZE, MEMCG_SOCK },
+	{ "shmem", PAGE_SIZE, NR_SHMEM },
+	{ "file_mapped", PAGE_SIZE, NR_FILE_MAPPED },
+	{ "file_dirty", PAGE_SIZE, NR_FILE_DIRTY },
+	{ "file_writeback", PAGE_SIZE, NR_WRITEBACK },
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/*
+	 * The ratio will be initialized in memory_stats_init(). Because
+	 * on some architectures, the macro of HPAGE_PMD_SIZE is not
+	 * constant(e.g. powerpc).
+	 */
+	{ "anon_thp", 0, NR_ANON_THPS },
+#endif
+	{ "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
+	{ "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
+	{ "inactive_file", PAGE_SIZE, NR_INACTIVE_FILE },
+	{ "active_file", PAGE_SIZE, NR_ACTIVE_FILE },
+	{ "unevictable", PAGE_SIZE, NR_UNEVICTABLE },
+
+	/*
+	 * Note: The slab_reclaimable and slab_unreclaimable must be
+	 * together and slab_reclaimable must be in front.
+	 */
+	{ "slab_reclaimable", 1, NR_SLAB_RECLAIMABLE_B },
+	{ "slab_unreclaimable", 1, NR_SLAB_UNRECLAIMABLE_B },
+
+	/* The memory events */
+	{ "workingset_refault_anon", 1, WORKINGSET_REFAULT_ANON },
+	{ "workingset_refault_file", 1, WORKINGSET_REFAULT_FILE },
+	{ "workingset_activate_anon", 1, WORKINGSET_ACTIVATE_ANON },
+	{ "workingset_activate_file", 1, WORKINGSET_ACTIVATE_FILE },
+	{ "workingset_restore_anon", 1, WORKINGSET_RESTORE_ANON },
+	{ "workingset_restore_file", 1, WORKINGSET_RESTORE_FILE },
+	{ "workingset_nodereclaim", 1, WORKINGSET_NODERECLAIM },
+};
+
+static int __init memory_stats_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		if (memory_stats[i].idx == NR_ANON_THPS)
+			memory_stats[i].ratio = HPAGE_PMD_SIZE;
+#endif
+		VM_BUG_ON(!memory_stats[i].ratio);
+		VM_BUG_ON(memory_stats[i].idx >= MEMCG_NR_STAT);
+	}
+
+	return 0;
+}
+pure_initcall(memory_stats_init);
+
 static char *memory_stat_format(struct mem_cgroup *memcg)
 {
 	struct seq_buf s;
@@ -1468,52 +1532,19 @@ static char *memory_stat_format(struct m
 	 * Current memory state:
 	 */
 
-	seq_buf_printf(&s, "anon %llu\n",
-		       (u64)memcg_page_state(memcg, NR_ANON_MAPPED) *
-		       PAGE_SIZE);
-	seq_buf_printf(&s, "file %llu\n",
-		       (u64)memcg_page_state(memcg, NR_FILE_PAGES) *
-		       PAGE_SIZE);
-	seq_buf_printf(&s, "kernel_stack %llu\n",
-		       (u64)memcg_page_state(memcg, NR_KERNEL_STACK_KB) *
-		       1024);
-	seq_buf_printf(&s, "slab %llu\n",
-		       (u64)(memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
-			     memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B)));
-	seq_buf_printf(&s, "percpu %llu\n",
-		       (u64)memcg_page_state(memcg, MEMCG_PERCPU_B));
-	seq_buf_printf(&s, "sock %llu\n",
-		       (u64)memcg_page_state(memcg, MEMCG_SOCK) *
-		       PAGE_SIZE);
-
-	seq_buf_printf(&s, "shmem %llu\n",
-		       (u64)memcg_page_state(memcg, NR_SHMEM) *
-		       PAGE_SIZE);
-	seq_buf_printf(&s, "file_mapped %llu\n",
-		       (u64)memcg_page_state(memcg, NR_FILE_MAPPED) *
-		       PAGE_SIZE);
-	seq_buf_printf(&s, "file_dirty %llu\n",
-		       (u64)memcg_page_state(memcg, NR_FILE_DIRTY) *
-		       PAGE_SIZE);
-	seq_buf_printf(&s, "file_writeback %llu\n",
-		       (u64)memcg_page_state(memcg, NR_WRITEBACK) *
-		       PAGE_SIZE);
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	seq_buf_printf(&s, "anon_thp %llu\n",
-		       (u64)memcg_page_state(memcg, NR_ANON_THPS) *
-		       HPAGE_PMD_SIZE);
-#endif
+	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
+		u64 size;
 
-	for (i = 0; i < NR_LRU_LISTS; i++)
-		seq_buf_printf(&s, "%s %llu\n", lru_list_name(i),
-			       (u64)memcg_page_state(memcg, NR_LRU_BASE + i) *
-			       PAGE_SIZE);
-
-	seq_buf_printf(&s, "slab_reclaimable %llu\n",
-		       (u64)memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B));
-	seq_buf_printf(&s, "slab_unreclaimable %llu\n",
-		       (u64)memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B));
+		size = memcg_page_state(memcg, memory_stats[i].idx);
+		size *= memory_stats[i].ratio;
+		seq_buf_printf(&s, "%s %llu\n", memory_stats[i].name, size);
+
+		if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
+			size = memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
+			       memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B);
+			seq_buf_printf(&s, "slab %llu\n", size);
+		}
+	}
 
 	/* Accumulated memory events */
 
@@ -1521,22 +1552,6 @@ static char *memory_stat_format(struct m
 		       memcg_events(memcg, PGFAULT));
 	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGMAJFAULT),
 		       memcg_events(memcg, PGMAJFAULT));
-
-	seq_buf_printf(&s, "workingset_refault_anon %lu\n",
-		       memcg_page_state(memcg, WORKINGSET_REFAULT_ANON));
-	seq_buf_printf(&s, "workingset_refault_file %lu\n",
-		       memcg_page_state(memcg, WORKINGSET_REFAULT_FILE));
-	seq_buf_printf(&s, "workingset_activate_anon %lu\n",
-		       memcg_page_state(memcg, WORKINGSET_ACTIVATE_ANON));
-	seq_buf_printf(&s, "workingset_activate_file %lu\n",
-		       memcg_page_state(memcg, WORKINGSET_ACTIVATE_FILE));
-	seq_buf_printf(&s, "workingset_restore_anon %lu\n",
-		       memcg_page_state(memcg, WORKINGSET_RESTORE_ANON));
-	seq_buf_printf(&s, "workingset_restore_file %lu\n",
-		       memcg_page_state(memcg, WORKINGSET_RESTORE_FILE));
-	seq_buf_printf(&s, "workingset_nodereclaim %lu\n",
-		       memcg_page_state(memcg, WORKINGSET_NODERECLAIM));
-
 	seq_buf_printf(&s, "%s %lu\n",  vm_event_name(PGREFILL),
 		       memcg_events(memcg, PGREFILL));
 	seq_buf_printf(&s, "pgscan %lu\n",
@@ -6374,6 +6389,35 @@ static int memory_stat_show(struct seq_f
 	return 0;
 }
 
+#ifdef CONFIG_NUMA
+static int memory_numa_stat_show(struct seq_file *m, void *v)
+{
+	int i;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
+		int nid;
+
+		if (memory_stats[i].idx >= NR_VM_NODE_STAT_ITEMS)
+			continue;
+
+		seq_printf(m, "%s", memory_stats[i].name);
+		for_each_node_state(nid, N_MEMORY) {
+			u64 size;
+			struct lruvec *lruvec;
+
+			lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+			size = lruvec_page_state(lruvec, memory_stats[i].idx);
+			size *= memory_stats[i].ratio;
+			seq_printf(m, " N%d=%llu", nid, size);
+		}
+		seq_putc(m, '\n');
+	}
+
+	return 0;
+}
+#endif
+
 static int memory_oom_group_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
@@ -6451,6 +6495,12 @@ static struct cftype memory_files[] = {
 		.name = "stat",
 		.seq_show = memory_stat_show,
 	},
+#ifdef CONFIG_NUMA
+	{
+		.name = "numa_stat",
+		.seq_show = memory_numa_stat_show,
+	},
+#endif
 	{
 		.name = "oom.group",
 		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


