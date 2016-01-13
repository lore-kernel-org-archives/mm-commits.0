From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
 added to -mm tree
Date: Wed, 13 Jan 2016 14:49:49 -0800
Message-ID: <5696d48d.zEXB7NvSDEpkXS1S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbcAMWtu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jan 2016 17:49:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: basic memory statistics in cgroup2 memory controller
has been added to the -mm tree.  Its filename is
     mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch

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
Subject: mm: memcontrol: basic memory statistics in cgroup2 memory controller

Provide a cgroup2 memory.stat that provides statistics on LRU memory
and fault event counters. More consumers and breakdowns will follow.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

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
@@ -5095,6 +5107,46 @@ static int memory_events_show(struct seq
 	return 0;
 }
 
+static int memory_stat_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	int i;
+
+	/* Memory consumer totals */
+
+	seq_printf(m, "anon %lu\n",
+		   tree_stat(memcg, MEM_CGROUP_STAT_RSS) * PAGE_SIZE);
+	seq_printf(m, "file %lu\n",
+		   tree_stat(memcg, MEM_CGROUP_STAT_CACHE) * PAGE_SIZE);
+
+	/* Per-consumer breakdowns */
+
+	for (i = 0; i < NR_LRU_LISTS; i++) {
+		struct mem_cgroup *mi;
+		unsigned long val = 0;
+
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_nr_lru_pages(mi, BIT(i)) * PAGE_SIZE;
+		seq_printf(m, "%s %lu\n", mem_cgroup_lru_names[i], val);
+	}
+
+	seq_printf(m, "file_mapped %lu\n",
+		   tree_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED) * PAGE_SIZE);
+	seq_printf(m, "file_dirty %lu\n",
+		   tree_stat(memcg, MEM_CGROUP_STAT_DIRTY) * PAGE_SIZE);
+	seq_printf(m, "file_writeback %lu\n",
+		   tree_stat(memcg, MEM_CGROUP_STAT_WRITEBACK) * PAGE_SIZE);
+
+	/* Memory management events */
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
@@ -5125,6 +5177,11 @@ static struct cftype memory_files[] = {
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
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch
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
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

