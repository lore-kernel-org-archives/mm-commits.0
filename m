From: akpm@linux-foundation.org
Subject: + mm-sysctl-make-numa-stats-configurable.patch added to -mm tree
Date: Thu, 28 Sep 2017 14:30:01 -0700
Message-ID: <59cd69d9.RVJ4Nvn114lljcw/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751917AbdI1VaD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2017 17:30:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kemi.wang@intel.com, aaron.lu@intel.com, andi.kleen@intel.com, bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, keescook@chromium.org, mcgrof@kernel.org, mgorman@techsingularity.net, mhocko@suse.com, tim.c.chen@intel.com, vbabka@suse.cz, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, sysctl: make NUMA stats configurable
has been added to the -mm tree.  Its filename is
     mm-sysctl-make-numa-stats-configurable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sysctl-make-numa-stats-configurable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sysctl-make-numa-stats-configurable.patch

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

When page allocation performance becomes a bottleneck and you can tolerate
some possible tool breakage and decreased numa counter precision, you can
do:

	echo [C|c]oarse > /proc/sys/vm/numa_stats_mode

In this case, numa counter update is ignored.

We can see about *4.8%*(185->176) drop of cpu cycles per single page
allocation and reclaim on Jesper's page_bench01 (single thread) and
*8.1%*(343->315) drop of cpu cycles per single page allocation and reclaim
on Jesper's page_bench03 (88 threads) running on a 2-Socket
Broadwell-based server (88 threads, 126G memory).

Benchmark link provided by Jesper D Brouer(increase loop times to
10000000):
https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/mm/bench

=========================================================================
When page allocation performance is not a bottleneck and you want all
tooling to work, you can do:
	echo [S|s]trict > /proc/sys/vm/numa_stats_mode

=========================================================================

We recommend automatic detection of numa statistics by system, this is also
system default configuration, you can do:

	echo [A|a]uto > /proc/sys/vm/numa_stats_mode

In this case, numa counter update is skipped unless it has been read by
users at least once, e.g. cat /proc/zoneinfo.

Branch target selection with jump label:

a) When numa_stats_mode is changed to *strict*, jump to the branch for
   numa counters update.

b) When numa_stats_mode is changed to *coarse*, return back directly.

c) When numa_stats_mode is changed to *auto*, the branch target used in
   last time is kept, and the branch target is changed to the branch for
   numa counters update once numa counters are *read* by users.

Therefore, with the help of jump label, the page allocation performance is
hardly affected when numa counters are updated with a call in
zone_statistics().  Meanwhile, the auto mode can give people benefit
without manual tuning.

Many thanks to Michal Hocko, Dave Hansen and Ying Huang for comments to
help improve the original patch.

Link: http://lkml.kernel.org/r/1506579101-5457-1-git-send-email-kemi.wang@intel.com
Signed-off-by: Kemi Wang <kemi.wang@intel.com>
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: Ying Huang <ying.huang@intel.com>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christopher Lameter <cl@linux.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   24 ++++++
 drivers/base/node.c         |    4 +
 include/linux/vmstat.h      |   23 ++++++
 init/main.c                 |    3 
 kernel/sysctl.c             |    7 +
 mm/page_alloc.c             |   10 ++
 mm/vmstat.c                 |  129 ++++++++++++++++++++++++++++++++++
 7 files changed, 200 insertions(+)

diff -puN Documentation/sysctl/vm.txt~mm-sysctl-make-numa-stats-configurable Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-sysctl-make-numa-stats-configurable
+++ a/Documentation/sysctl/vm.txt
@@ -61,6 +61,7 @@ Currently, these files are in /proc/sys/
 - swappiness
 - user_reserve_kbytes
 - vfs_cache_pressure
+- numa_stats_mode
 - watermark_scale_factor
 - zone_reclaim_mode
 
@@ -850,6 +851,29 @@ ten times more freeable objects than the
 
 =============================================================
 
+numa_stats_mode
+
+This interface allows numa statistics configurable.
+
+When page allocation performance becomes a bottleneck and you can tolerate
+some possible tool breakage and decreased numa counter precision, you can
+do:
+	echo [C|c]oarse > /proc/sys/vm/numa_stats_mode
+
+When page allocation performance is not a bottleneck and you want all
+tooling to work, you can do:
+	echo [S|s]trict > /proc/sys/vm/numa_stat_mode
+
+We recommend automatic detection of numa statistics by system, because numa
+statistics does not affect system's decision and it is very rarely
+consumed. you can do:
+	echo [A|a]uto > /proc/sys/vm/numa_stats_mode
+This is also system default configuration, with this default setting, numa
+counters update is skipped unless the counter is *read* by users at least
+once.
+
+==============================================================
+
 watermark_scale_factor:
 
 This factor controls the aggressiveness of kswapd. It defines the
diff -puN drivers/base/node.c~mm-sysctl-make-numa-stats-configurable drivers/base/node.c
--- a/drivers/base/node.c~mm-sysctl-make-numa-stats-configurable
+++ a/drivers/base/node.c
@@ -153,6 +153,8 @@ static DEVICE_ATTR(meminfo, S_IRUGO, nod
 static ssize_t node_read_numastat(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
+	if (vm_numa_stats_mode == VM_NUMA_STAT_AUTO_MODE)
+		static_branch_enable(&vm_numa_stats_mode_key);
 	return sprintf(buf,
 		       "numa_hit %lu\n"
 		       "numa_miss %lu\n"
@@ -186,6 +188,8 @@ static ssize_t node_read_vmstat(struct d
 		n += sprintf(buf+n, "%s %lu\n",
 			     vmstat_text[i + NR_VM_ZONE_STAT_ITEMS],
 			     sum_zone_numa_state(nid, i));
+	if (vm_numa_stats_mode == VM_NUMA_STAT_AUTO_MODE)
+		static_branch_enable(&vm_numa_stats_mode_key);
 #endif
 
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
diff -puN include/linux/vmstat.h~mm-sysctl-make-numa-stats-configurable include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-sysctl-make-numa-stats-configurable
+++ a/include/linux/vmstat.h
@@ -6,9 +6,28 @@
 #include <linux/mmzone.h>
 #include <linux/vm_event_item.h>
 #include <linux/atomic.h>
+#include <linux/static_key.h>
 
 extern int sysctl_stat_interval;
 
+#ifdef CONFIG_NUMA
+DECLARE_STATIC_KEY_FALSE(vm_numa_stats_mode_key);
+/*
+ * vm_numa_stats_mode:
+ * 0 = auto mode of NUMA stats, automatic detection of NUMA statistics.
+ * 1 = strict mode of NUMA stats, keep NUMA statistics.
+ * 2 = coarse mode of NUMA stats, ignore NUMA statistics.
+ */
+#define VM_NUMA_STAT_AUTO_MODE 0
+#define VM_NUMA_STAT_STRICT_MODE  1
+#define VM_NUMA_STAT_COARSE_MODE  2
+#define VM_NUMA_STAT_MODE_LEN 16
+extern int vm_numa_stats_mode;
+extern char sysctl_vm_numa_stats_mode[];
+extern int sysctl_vm_numa_stats_mode_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *length, loff_t *ppos);
+#endif
+
 #ifdef CONFIG_VM_EVENT_COUNTERS
 /*
  * Light weight per cpu counter implementation.
@@ -229,6 +248,10 @@ extern unsigned long sum_zone_node_page_
 extern unsigned long sum_zone_numa_state(int node, enum numa_stat_item item);
 extern unsigned long node_page_state(struct pglist_data *pgdat,
 						enum node_stat_item item);
+extern void zero_zone_numa_counters(struct zone *zone);
+extern void zero_zones_numa_counters(void);
+extern void zero_global_numa_counters(void);
+extern void invalid_numa_statistics(void);
 #else
 #define sum_zone_node_page_state(node, item) global_zone_page_state(item)
 #define node_page_state(node, item) global_node_page_state(item)
diff -puN init/main.c~mm-sysctl-make-numa-stats-configurable init/main.c
--- a/init/main.c~mm-sysctl-make-numa-stats-configurable
+++ a/init/main.c
@@ -567,6 +567,9 @@ asmlinkage __visible void __init start_k
 	sort_main_extable();
 	trap_init();
 	mm_init();
+#ifdef CONFIG_NUMA
+	pr_info("vmstat: NUMA stats is skipped unless it has been consumed\n");
+#endif
 
 	ftrace_init();
 
diff -puN kernel/sysctl.c~mm-sysctl-make-numa-stats-configurable kernel/sysctl.c
--- a/kernel/sysctl.c~mm-sysctl-make-numa-stats-configurable
+++ a/kernel/sysctl.c
@@ -1374,6 +1374,13 @@ static struct ctl_table vm_table[] = {
 		.mode           = 0644,
 		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
 	},
+	{
+		.procname	= "numa_stats_mode",
+		.data		= sysctl_vm_numa_stats_mode,
+		.maxlen		= VM_NUMA_STAT_MODE_LEN,
+		.mode		= 0644,
+		.proc_handler	= sysctl_vm_numa_stats_mode_handler,
+	},
 #endif
 	 {
 		.procname	= "hugetlb_shm_group",
diff -puN mm/page_alloc.c~mm-sysctl-make-numa-stats-configurable mm/page_alloc.c
--- a/mm/page_alloc.c~mm-sysctl-make-numa-stats-configurable
+++ a/mm/page_alloc.c
@@ -83,6 +83,8 @@ DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
 #endif
 
+DEFINE_STATIC_KEY_FALSE(vm_numa_stats_mode_key);
+
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
 /*
  * N.B., Do NOT reference the '_numa_mem_' per cpu variable directly.
@@ -2739,6 +2741,14 @@ static inline void zone_statistics(struc
 #ifdef CONFIG_NUMA
 	enum numa_stat_item local_stat = NUMA_LOCAL;
 
+	/*
+	 * skip zone_statistics() if NUMA stats is set to coarse mode or
+	 * NUMA stats is never consumed in auto mode.
+	 */
+
+	if (!static_branch_unlikely(&vm_numa_stats_mode_key))
+		return;
+
 	if (z->node != numa_node_id())
 		local_stat = NUMA_OTHER;
 
diff -puN mm/vmstat.c~mm-sysctl-make-numa-stats-configurable mm/vmstat.c
--- a/mm/vmstat.c~mm-sysctl-make-numa-stats-configurable
+++ a/mm/vmstat.c
@@ -32,6 +32,91 @@
 
 #define NUMA_STATS_THRESHOLD (U16_MAX - 2)
 
+#ifdef CONFIG_NUMA
+int vm_numa_stats_mode = VM_NUMA_STAT_AUTO_MODE;
+char sysctl_vm_numa_stats_mode[VM_NUMA_STAT_MODE_LEN] = "auto";
+static const char *vm_numa_stats_mode_name[3] = {"auto", "strict", "coarse"};
+static DEFINE_MUTEX(vm_numa_stats_mode_lock);
+
+static int __parse_vm_numa_stats_mode(char *s)
+{
+	const char *str = s;
+
+	if (strcmp(str, "auto") == 0 || strcmp(str, "Auto") == 0)
+		vm_numa_stats_mode = VM_NUMA_STAT_AUTO_MODE;
+	else if (strcmp(str, "strict") == 0 || strcmp(str, "Strict") == 0)
+		vm_numa_stats_mode = VM_NUMA_STAT_STRICT_MODE;
+	else if (strcmp(str, "coarse") == 0 || strcmp(str, "Coarse") == 0)
+		vm_numa_stats_mode = VM_NUMA_STAT_COARSE_MODE;
+	else {
+		pr_warn("Ignoring invalid vm_numa_stats_mode value: %s\n", s);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int sysctl_vm_numa_stats_mode_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *length, loff_t *ppos)
+{
+	char old_string[VM_NUMA_STAT_MODE_LEN];
+	int ret, oldval;
+
+	mutex_lock(&vm_numa_stats_mode_lock);
+	if (write)
+		strncpy(old_string, (char *)table->data, VM_NUMA_STAT_MODE_LEN);
+	ret = proc_dostring(table, write, buffer, length, ppos);
+	if (ret || !write) {
+		mutex_unlock(&vm_numa_stats_mode_lock);
+		return ret;
+	}
+
+	oldval = vm_numa_stats_mode;
+	if (__parse_vm_numa_stats_mode((char *)table->data)) {
+		/*
+		 * invalid sysctl_vm_numa_stats_mode value, restore saved string
+		 */
+		strncpy((char *)table->data, old_string, VM_NUMA_STAT_MODE_LEN);
+		vm_numa_stats_mode = oldval;
+	} else {
+		/*
+		 * check whether numa stats mode changes or not
+		 */
+		if (vm_numa_stats_mode == oldval) {
+			/* no change */
+			mutex_unlock(&vm_numa_stats_mode_lock);
+			return 0;
+		} else if (vm_numa_stats_mode == VM_NUMA_STAT_AUTO_MODE)
+			/*
+			 * Keep the branch selection in last time when numa stats
+			 * is changed to auto mode.
+			 */
+			pr_info("numa stats changes from %s mode to auto mode\n",
+					vm_numa_stats_mode_name[oldval]);
+		else if (vm_numa_stats_mode == VM_NUMA_STAT_STRICT_MODE) {
+			static_branch_enable(&vm_numa_stats_mode_key);
+			pr_info("numa stats changes from %s mode to strict mode\n",
+					vm_numa_stats_mode_name[oldval]);
+		} else if (vm_numa_stats_mode == VM_NUMA_STAT_COARSE_MODE) {
+			static_branch_disable(&vm_numa_stats_mode_key);
+			/*
+			 * Invalidate numa counters when vmstat mode is set to coarse
+			 * mode, because users can't tell the difference between the
+			 * dead state and when allocator activity is quiet once
+			 * zone_statistics() is turned off.
+			 */
+			invalid_numa_statistics();
+			pr_info("numa stats changes from %s mode to coarse mode\n",
+					vm_numa_stats_mode_name[oldval]);
+		} else
+			pr_warn("invalid vm_numa_stats_mode:%d\n", vm_numa_stats_mode);
+	}
+
+	mutex_unlock(&vm_numa_stats_mode_lock);
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
@@ -914,6 +999,42 @@ unsigned long sum_zone_numa_state(int no
 	return count;
 }
 
+/* zero numa counters within a zone */
+void zero_zone_numa_counters(struct zone *zone)
+{
+	int item, cpu;
+
+	for (item = 0; item < NR_VM_NUMA_STAT_ITEMS; item++) {
+		atomic_long_set(&zone->vm_numa_stat[item], 0);
+		for_each_online_cpu(cpu)
+			per_cpu_ptr(zone->pageset, cpu)->vm_numa_stat_diff[item] = 0;
+	}
+}
+
+/* zero numa counters of all the populated zones */
+void zero_zones_numa_counters(void)
+{
+	struct zone *zone;
+
+	for_each_populated_zone(zone)
+		zero_zone_numa_counters(zone);
+}
+
+/* zero global numa counters */
+void zero_global_numa_counters(void)
+{
+	int item;
+
+	for (item = 0; item < NR_VM_NUMA_STAT_ITEMS; item++)
+		atomic_long_set(&vm_numa_stat[item], 0);
+}
+
+void invalid_numa_statistics(void)
+{
+	zero_zones_numa_counters();
+	zero_global_numa_counters();
+}
+
 /*
  * Determine the per node value of a stat item.
  */
@@ -1582,6 +1703,10 @@ static int zoneinfo_show(struct seq_file
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;
 	walk_zones_in_node(m, pgdat, false, false, zoneinfo_show_print);
+#ifdef CONFIG_NUMA
+	if (vm_numa_stats_mode == VM_NUMA_STAT_AUTO_MODE)
+		static_branch_enable(&vm_numa_stats_mode_key);
+#endif
 	return 0;
 }
 
@@ -1678,6 +1803,10 @@ static int vmstat_show(struct seq_file *
 
 static void vmstat_stop(struct seq_file *m, void *arg)
 {
+#ifdef CONFIG_NUMA
+	if (vm_numa_stats_mode == VM_NUMA_STAT_AUTO_MODE)
+		static_branch_enable(&vm_numa_stats_mode_key);
+#endif
 	kfree(m->private);
 	m->private = NULL;
 }
_

Patches currently in -mm which might be from kemi.wang@intel.com are

mm-sysctl-make-numa-stats-configurable.patch

