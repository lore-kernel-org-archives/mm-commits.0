From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 15:30:07 -0800
Message-ID: <56a169ff.ooJ9ku/js2JN6Oqo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAUXaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:30:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: basic memory statistics in cgroup2 memory controller
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: basic memory statistics in cgroup2 memory controller

Provide a cgroup2 memory.stat that provides statistics on LRU memory
and fault event counters. More consumers and breakdowns will follow.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |   56 ++++++++++++++++++++++++++++
 mm/memcontrol.c             |   68 ++++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+)

diff -puN Documentation/cgroup-v2.txt~mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller
+++ a/Documentation/cgroup-v2.txt
@@ -819,6 +819,62 @@ PAGE_SIZE multiple when read back.
 		the cgroup.  This may not exactly match the number of
 		processes killed but should generally be close.
 
+  memory.stat
+
+	A read-only flat-keyed file which exists on non-root cgroups.
+
+	This breaks down the cgroup's memory footprint into different
+	types of memory, type-specific details, and other information
+	on the state and past events of the memory management system.
+
+	All memory amounts are in bytes.
+
+	The entries are ordered to be human readable, and new entries
+	can show up in the middle. Don't rely on items remaining in a
+	fixed position; use the keys to look up specific values!
+
+	  anon
+
+		Amount of memory used in anonymous mappings such as
+		brk(), sbrk(), and mmap(MAP_ANONYMOUS)
+
+	  file
+
+		Amount of memory used to cache filesystem data,
+		including tmpfs and shared memory.
+
+	  file_mapped
+
+		Amount of cached filesystem data mapped with mmap()
+
+	  file_dirty
+
+		Amount of cached filesystem data that was modified but
+		not yet written back to disk
+
+	  file_writeback
+
+		Amount of cached filesystem data that was modified and
+		is currently being written back to disk
+
+	  inactive_anon
+	  active_anon
+	  inactive_file
+	  active_file
+	  unevictable
+
+		Amount of memory, swap-backed and filesystem-backed,
+		on the internal memory management lists used by the
+		page reclaim algorithm
+
+	  pgfault
+
+		Total number of page faults incurred
+
+	  pgmajfault
+
+		Number of major page faults incurred
+
   memory.swap.current
 
 	A read-only single value file which exists on non-root
diff -puN mm/memcontrol.c~mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller
+++ a/mm/memcontrol.c
@@ -2767,6 +2767,18 @@ static unsigned long tree_stat(struct me
 	return val;
 }
 
+static unsigned long tree_events(struct mem_cgroup *memcg,
+				 enum mem_cgroup_events_index idx)
+{
+	struct mem_cgroup *iter;
+	unsigned long val = 0;
+
+	for_each_mem_cgroup_tree(iter, memcg)
+		val += mem_cgroup_read_events(iter, idx);
+
+	return val;
+}
+
 static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 {
 	unsigned long val;
@@ -5096,6 +5108,57 @@ static int memory_events_show(struct seq
 	return 0;
 }
 
+static int memory_stat_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	int i;
+
+	/*
+	 * Provide statistics on the state of the memory subsystem as
+	 * well as cumulative event counters that show past behavior.
+	 *
+	 * This list is ordered following a combination of these gradients:
+	 * 1) generic big picture -> specifics and details
+	 * 2) reflecting userspace activity -> reflecting kernel heuristics
+	 *
+	 * Current memory state:
+	 */
+
+	seq_printf(m, "anon %llu\n",
+		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_RSS) * PAGE_SIZE);
+	seq_printf(m, "file %llu\n",
+		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_CACHE) * PAGE_SIZE);
+
+	seq_printf(m, "file_mapped %llu\n",
+		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED) *
+		   PAGE_SIZE);
+	seq_printf(m, "file_dirty %llu\n",
+		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_DIRTY) *
+		   PAGE_SIZE);
+	seq_printf(m, "file_writeback %llu\n",
+		   (u64)tree_stat(memcg, MEM_CGROUP_STAT_WRITEBACK) *
+		   PAGE_SIZE);
+
+	for (i = 0; i < NR_LRU_LISTS; i++) {
+		struct mem_cgroup *mi;
+		unsigned long val = 0;
+
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_nr_lru_pages(mi, BIT(i));
+		seq_printf(m, "%s %llu\n",
+			   mem_cgroup_lru_names[i], (u64)val * PAGE_SIZE);
+	}
+
+	/* Accumulated memory events */
+
+	seq_printf(m, "pgfault %lu\n",
+		   tree_events(memcg, MEM_CGROUP_EVENTS_PGFAULT));
+	seq_printf(m, "pgmajfault %lu\n",
+		   tree_events(memcg, MEM_CGROUP_EVENTS_PGMAJFAULT));
+
+	return 0;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -5126,6 +5189,11 @@ static struct cftype memory_files[] = {
 		.file_offset = offsetof(struct mem_cgroup, events_file),
 		.seq_show = memory_events_show,
 	},
+	{
+		.name = "stat",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_stat_show,
+	},
 	{ }	/* terminate */
 };
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

