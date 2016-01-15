From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch added to -mm tree
Date: Fri, 15 Jan 2016 12:37:54 -0800
Message-ID: <569958a2.NpD/jKiOqUXlU38F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbcAOUhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 15:37:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: basic memory statistics in cgroup2 memory controller fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: basic memory statistics in cgroup2 memory controller fix

Fixlet addressing akpm's feedback:

- Fix overflowing byte counters on 32-bit. Just like in the existing
  interface files, bytes must be printed as u64 to work with highmem.

- Add documentation in cgroup.txt that explains the memory.stat file
  and its format.

- Rethink item ordering to accomodate potential future additions. The
  ordering now follows both 1) from big picture to detail and 2) from
  stats that reflect on userspace behavior towards stats that reflect
  on kernel heuristics. Both are gradients, and item-by-item ordering
  will still require judgement calls (and some bike shed painting).

Changelog addendum to the original patch:

The output of this file looks as follows:

$ cat memory.stat
anon 167936
file 87302144
file_mapped 0
file_dirty 0
file_writeback 0
inactive_anon 0
active_anon 155648
inactive_file 87298048
active_file 4096
unevictable 0
pgfault 636
pgmajfault 0

The list consists of two sections: statistics reflecting the current
state of the memory management subsystem, and statistics reflecting
past events. The items themselves are sorted such that generic big
picture items come before specific details, and items related to
userspace activity come before items related to kernel heuristics.

All memory counters are in bytes to eliminate all ambiguity with
variable page sizes.

There will be more items and statistics added in the future, but this
is a good initial set to get a minimum of insight into how a cgroup is
using memory, and the items chosen for now are likely to remain valid
even with significant changes to the memory management implementation.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |   56 ++++++++++++++++++++++++++++++++++
 mm/memcontrol.c             |   47 +++++++++++++++++-----------
 2 files changed, 85 insertions(+), 18 deletions(-)

diff -puN Documentation/cgroup-v2.txt~mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix
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
diff -puN mm/memcontrol.c~mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix
+++ a/mm/memcontrol.c
@@ -5112,32 +5112,43 @@ static int memory_stat_show(struct seq_f
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
 	int i;
 
-	/* Memory consumer totals */
-
-	seq_printf(m, "anon %lu\n",
-		   tree_stat(memcg, MEM_CGROUP_STAT_RSS) * PAGE_SIZE);
-	seq_printf(m, "file %lu\n",
-		   tree_stat(memcg, MEM_CGROUP_STAT_CACHE) * PAGE_SIZE);
-
-	/* Per-consumer breakdowns */
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
 
 	for (i = 0; i < NR_LRU_LISTS; i++) {
 		struct mem_cgroup *mi;
 		unsigned long val = 0;
 
 		for_each_mem_cgroup_tree(mi, memcg)
-			val += mem_cgroup_nr_lru_pages(mi, BIT(i)) * PAGE_SIZE;
-		seq_printf(m, "%s %lu\n", mem_cgroup_lru_names[i], val);
+			val += mem_cgroup_nr_lru_pages(mi, BIT(i));
+		seq_printf(m, "%s %llu\n",
+			   mem_cgroup_lru_names[i], (u64)val * PAGE_SIZE);
 	}
 
-	seq_printf(m, "file_mapped %lu\n",
-		   tree_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED) * PAGE_SIZE);
-	seq_printf(m, "file_dirty %lu\n",
-		   tree_stat(memcg, MEM_CGROUP_STAT_DIRTY) * PAGE_SIZE);
-	seq_printf(m, "file_writeback %lu\n",
-		   tree_stat(memcg, MEM_CGROUP_STAT_WRITEBACK) * PAGE_SIZE);
-
-	/* Memory management events */
+	/* Accumulated memory events */
 
 	seq_printf(m, "pgfault %lu\n",
 		   tree_events(memcg, MEM_CGROUP_EVENTS_PGFAULT));
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-memcontrol-export-root_mem_cgroup.patch
net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

