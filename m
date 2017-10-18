From: akpm@linux-foundation.org
Subject: + mm-sysctl-make-numa-stats-configurable-v5.patch added to -mm
 tree
Date: Wed, 18 Oct 2017 15:28:45 -0700
Message-ID: <59e7d59d.2/Futx0fQoA4+jkb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38740 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdJRW2r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 18:28:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kemi.wang@intel.com, aaron.lu@intel.com, andi.kleen@intel.com, aryabinin@virtuozzo.com, bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, keescook@chromium.org, mcgrof@kernel.org, mgorman@techsingularity.net, mhocko@suse.com, tim.c.chen@intel.com, vbabka@suse.cz, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, sysctl: make NUMA stats configurable
has been added to the -mm tree.  Its filename is
     mm-sysctl-make-numa-stats-configurable-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sysctl-make-numa-stats-configurable-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sysctl-make-numa-stats-configurable-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kemi Wang <kemi.wang@intel.com>
Subject: mm, sysctl: make NUMA stats configurable

This is the second step which introduces a tunable interface that allow
numa stats configurable for optimizing zone_statistics(), as suggested by
Dave Hansen and Ying Huang.

=========================================================================

When page allocation performance becomes a bottleneck and you can tolerate
some possible tool breakage and decreased numa counter precision, you can
do:

	echo 0 > /proc/sys/vm/numa_stat

In this case, numa counter update is ignored.  We can see about
*4.8%*(185->176) drop of cpu cycles per single page allocation and reclaim
on Jesper's page_bench01 (single thread) and *8.1%*(343->315) drop of cpu
cycles per single page allocation and reclaim on Jesper's page_bench03 (88
threads) running on a 2-Socket Broadwell-based server (88 threads, 126G
memory).

Benchmark link provided by Jesper D Brouer(increase loop times to
10000000):
https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/mm/
bench

=========================================================================

When page allocation performance is not a bottleneck and you want all
tooling to work, you can do:

	echo 1 > /proc/sys/vm/numa_stat

This is system default setting.

Many thanks to Michal Hocko, Dave Hansen, Ying Huang and Vlastimil Babka
for comments to help improve the original patch.

Link: http://lkml.kernel.org/r/1508290927-8518-1-git-send-email-kemi.wang@intel.com
Signed-off-by: Kemi Wang <kemi.wang@intel.com>
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: Ying Huang <ying.huang@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christopher Lameter <cl@linux.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   16 +++++++
 include/linux/vmstat.h      |   10 ++++
 kernel/sysctl.c             |    9 ++++
 mm/mempolicy.c              |    3 +
 mm/page_alloc.c             |    6 ++
 mm/vmstat.c                 |   70 ++++++++++++++++++++++++++++++++++
 6 files changed, 114 insertions(+)

diff -puN Documentation/sysctl/vm.txt~mm-sysctl-make-numa-stats-configurable-v5 Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-sysctl-make-numa-stats-configurable-v5
+++ a/Documentation/sysctl/vm.txt
@@ -57,6 +57,7 @@ Currently, these files are in /proc/sys/
 - percpu_pagelist_fraction
 - stat_interval
 - stat_refresh
+- numa_stat
 - swappiness
 - user_reserve_kbytes
 - vfs_cache_pressure
@@ -774,6 +775,21 @@ with no ill effects: errors and warnings
 
 ==============================================================
 
+numa_stat
+
+This interface allows runtime configuration of numa statistics.
+
+When page allocation performance becomes a bottleneck and you can tolerate
+some possible tool breakage and decreased numa counter precision, you can
+do:
+	echo 0 > /proc/sys/vm/numa_stat
+
+When page allocation performance is not a bottleneck and you want all
+tooling to work, you can do:
+	echo 1 > /proc/sys/vm/numa_stat
+
+==============================================================
+
 swappiness
 
 This control is used to define how aggressive the kernel will swap
diff -puN include/linux/vmstat.h~mm-sysctl-make-numa-stats-configurable-v5 include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-sysctl-make-numa-stats-configurable-v5
+++ a/include/linux/vmstat.h
@@ -6,9 +6,19 @@
 #include <linux/mmzone.h>
 #include <linux/vm_event_item.h>
 #include <linux/atomic.h>
+#include <linux/static_key.h>
 
 extern int sysctl_stat_interval;
 
+#ifdef CONFIG_NUMA
+#define ENABLE_NUMA_STAT   1
+#define DISABLE_NUMA_STAT   0
+extern int sysctl_vm_numa_stat;
+DECLARE_STATIC_KEY_TRUE(vm_numa_stat_key);
+extern int sysctl_vm_numa_stat_handler(struct ctl_table *table,
+		int write, void __user *buffer, size_t *length, loff_t *ppos);
+#endif
+
 #ifdef CONFIG_VM_EVENT_COUNTERS
 /*
  * Light weight per cpu counter implementation.
diff -puN kernel/sysctl.c~mm-sysctl-make-numa-stats-configurable-v5 kernel/sysctl.c
--- a/kernel/sysctl.c~mm-sysctl-make-numa-stats-configurable-v5
+++ a/kernel/sysctl.c
@@ -1361,6 +1361,15 @@ static struct ctl_table vm_table[] = {
 		.mode           = 0644,
 		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
 	},
+	{
+		.procname		= "numa_stat",
+		.data			= &sysctl_vm_numa_stat,
+		.maxlen			= sizeof(int),
+		.mode			= 0644,
+		.proc_handler	= sysctl_vm_numa_stat_handler,
+		.extra1			= &zero,
+		.extra2			= &one,
+	},
 #endif
 	 {
 		.procname	= "hugetlb_shm_group",
diff -puN mm/mempolicy.c~mm-sysctl-make-numa-stats-configurable-v5 mm/mempolicy.c
--- a/mm/mempolicy.c~mm-sysctl-make-numa-stats-configurable-v5
+++ a/mm/mempolicy.c
@@ -1915,6 +1915,9 @@ static struct page *alloc_page_interleav
 	struct page *page;
 
 	page = __alloc_pages(gfp, order, nid);
+	/* skip NUMA_INTERLEAVE_HIT counter update if numa stats is disabled */
+	if (!static_branch_likely(&vm_numa_stat_key))
+		return page;
 	if (page && page_to_nid(page) == nid) {
 		preempt_disable();
 		__inc_numa_state(page_zone(page), NUMA_INTERLEAVE_HIT);
diff -puN mm/page_alloc.c~mm-sysctl-make-numa-stats-configurable-v5 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-sysctl-make-numa-stats-configurable-v5
+++ a/mm/page_alloc.c
@@ -82,6 +82,8 @@ DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
 #endif
 
+DEFINE_STATIC_KEY_TRUE(vm_numa_stat_key);
+
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
 /*
  * N.B., Do NOT reference the '_numa_mem_' per cpu variable directly.
@@ -2753,6 +2755,10 @@ static inline void zone_statistics(struc
 #ifdef CONFIG_NUMA
 	enum numa_stat_item local_stat = NUMA_LOCAL;
 
+	/* skip numa counters update if numa stats is disabled */
+	if (!static_branch_likely(&vm_numa_stat_key))
+		return;
+
 	if (z->node != numa_node_id())
 		local_stat = NUMA_OTHER;
 
diff -puN mm/vmstat.c~mm-sysctl-make-numa-stats-configurable-v5 mm/vmstat.c
--- a/mm/vmstat.c~mm-sysctl-make-numa-stats-configurable-v5
+++ a/mm/vmstat.c
@@ -32,6 +32,76 @@
 
 #define NUMA_STATS_THRESHOLD (U16_MAX - 2)
 
+#ifdef CONFIG_NUMA
+int sysctl_vm_numa_stat = ENABLE_NUMA_STAT;
+
+/* zero numa counters within a zone */
+static void zero_zone_numa_counters(struct zone *zone)
+{
+	int item, cpu;
+
+	for (item = 0; item < NR_VM_NUMA_STAT_ITEMS; item++) {
+		atomic_long_set(&zone->vm_numa_stat[item], 0);
+		for_each_online_cpu(cpu)
+			per_cpu_ptr(zone->pageset, cpu)->vm_numa_stat_diff[item]
+						= 0;
+	}
+}
+
+/* zero numa counters of all the populated zones */
+static void zero_zones_numa_counters(void)
+{
+	struct zone *zone;
+
+	for_each_populated_zone(zone)
+		zero_zone_numa_counters(zone);
+}
+
+/* zero global numa counters */
+static void zero_global_numa_counters(void)
+{
+	int item;
+
+	for (item = 0; item < NR_VM_NUMA_STAT_ITEMS; item++)
+		atomic_long_set(&vm_numa_stat[item], 0);
+}
+
+static void invalid_numa_statistics(void)
+{
+	zero_zones_numa_counters();
+	zero_global_numa_counters();
+}
+
+int sysctl_vm_numa_stat_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int ret, oldval;
+	DEFINE_MUTEX(vm_numa_stat_lock);
+
+	mutex_lock(&vm_numa_stat_lock);
+	if (write)
+		oldval = sysctl_vm_numa_stat;
+	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (ret || !write)
+		goto out;
+
+	if (oldval == sysctl_vm_numa_stat)
+		goto out;
+	else if (sysctl_vm_numa_stat == ENABLE_NUMA_STAT) {
+		static_branch_enable(&vm_numa_stat_key);
+		pr_info("enable numa statistics\n");
+	} else {
+		static_branch_disable(&vm_numa_stat_key);
+		invalid_numa_statistics();
+		pr_info("disable numa statistics, and clear numa counters\n");
+	}
+
+out:
+	mutex_unlock(&vm_numa_stat_lock);
+	return ret;
+}
+#endif
+
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
_

Patches currently in -mm which might be from kemi.wang@intel.com are

mm-sysctl-make-numa-stats-configurable-v5.patch

