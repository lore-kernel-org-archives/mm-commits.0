From: akpm@linux-foundation.org
Subject: - sched2-sched-domain-sysctl.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:13:41 -0700
Message-ID: <200707290613.l6T6DffU011248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756738AbXG2GX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     sched: sched domain sysctl
has been removed from the -mm tree.  Its filename was
     sched2-sched-domain-sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: sched domain sysctl
From: Nick Piggin <nickpiggin@yahoo.com.au>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |  115 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff -puN kernel/sched.c~sched2-sched-domain-sysctl kernel/sched.c
--- a/kernel/sched.c~sched2-sched-domain-sysctl
+++ a/kernel/sched.c
@@ -53,6 +53,7 @@
 #include <linux/percpu.h>
 #include <linux/kthread.h>
 #include <linux/seq_file.h>
+#include <linux/sysctl.h>
 #include <linux/syscalls.h>
 #include <linux/times.h>
 #include <linux/tsacct_kern.h>
@@ -5145,6 +5146,118 @@ static void migrate_dead_tasks(unsigned 
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
+#if defined(CONFIG_DEBUG_KERNEL) && defined(CONFIG_SYSCTL)
+static struct ctl_table sd_ctl_dir[] = {
+	{CTL_UNNUMBERED, "sched_domain", NULL, 0, 0755, NULL, },
+	{0,},
+};
+
+static struct ctl_table sd_ctl_root[] = {
+	{CTL_UNNUMBERED, "kernel", NULL, 0, 0755, sd_ctl_dir, },
+	{0,},
+};
+
+static struct ctl_table *sd_alloc_ctl_entry(int n)
+{
+	struct ctl_table *entry =
+		kmalloc(n * sizeof(struct ctl_table), GFP_KERNEL);
+	BUG_ON(!entry);
+	memset(entry, 0, n * sizeof(struct ctl_table));
+	return entry;
+}
+
+static void set_table_entry(struct ctl_table *entry, int ctl_name,
+			const char *procname, void *data, int maxlen,
+			mode_t mode, proc_handler *proc_handler)
+{
+	entry->ctl_name = ctl_name;
+	entry->procname = procname;
+	entry->data = data;
+	entry->maxlen = maxlen;
+	entry->mode = mode;
+	entry->proc_handler = proc_handler;
+}
+
+static struct ctl_table *
+sd_alloc_ctl_domain_table(struct sched_domain *sd)
+{
+	struct ctl_table *table;
+	table = sd_alloc_ctl_entry(14);
+
+	set_table_entry(&table[0], 1, "min_interval", &sd->min_interval,
+		sizeof(long), 0644, proc_doulongvec_minmax);
+	set_table_entry(&table[1], 2, "max_interval", &sd->max_interval,
+		sizeof(long), 0644, proc_doulongvec_minmax);
+	set_table_entry(&table[2], 3, "busy_idx", &sd->busy_idx,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[3], 4, "idle_idx", &sd->idle_idx,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[4], 5, "newidle_idx", &sd->newidle_idx,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[5], 6, "wake_idx", &sd->wake_idx,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[6], 7, "forkexec_idx", &sd->forkexec_idx,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[7], 8, "busy_factor", &sd->busy_factor,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[8], 9, "imbalance_pct", &sd->imbalance_pct,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[9], 10, "cache_hot_time", &sd->cache_hot_time,
+		sizeof(long long), 0644, proc_doulongvec_minmax);
+	set_table_entry(&table[10], 11, "cache_nice_tries", &sd->cache_nice_tries,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[12], 13, "flags", &sd->flags,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	return table;
+}
+
+static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
+{
+	struct sched_domain *sd;
+	int domain_num = 0, i;
+	struct ctl_table *entry, *table;
+	char buf[32];
+	for_each_domain(cpu, sd)
+		domain_num++;
+	entry = table = sd_alloc_ctl_entry(domain_num + 1);
+
+	i = 0;
+	for_each_domain(cpu, sd) {
+		snprintf(buf, 32, "domain%d", i);
+		entry->ctl_name = i + 1;
+		entry->procname = kstrdup(buf, GFP_KERNEL);
+		entry->mode = 0755;
+		entry->child = sd_alloc_ctl_domain_table(sd);
+		entry++;
+		i++;
+	}
+	return table;
+}
+
+static struct ctl_table_header *sd_sysctl_header;
+static void init_sched_domain_sysctl(void)
+{
+	int i, cpu_num = num_online_cpus();
+	char buf[32];
+	struct ctl_table *entry = sd_alloc_ctl_entry(cpu_num + 1);
+
+	sd_ctl_dir[0].child = entry;
+
+	for (i = 0; i < cpu_num; i++, entry++) {
+		snprintf(buf, 32, "cpu%d", i);
+		entry->ctl_name = i + 1;
+		entry->procname = kstrdup(buf, GFP_KERNEL);
+		entry->mode = 0755;
+		entry->child = sd_alloc_ctl_cpu_table(i);
+	}
+	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
+}
+#else
+static void init_sched_domain_sysctl(void)
+{
+}
+#endif
+
 /*
  * migration_call - callback that gets triggered when a CPU is added.
  * Here we can start up the necessary migration thread for the new CPU.
@@ -6223,6 +6336,8 @@ void __init sched_init_smp(void)
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
 
+	init_sched_domain_sysctl();
+
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
nommu-fix-sysv-ipc-shm.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
deny-partial-write-for-loop-dev-fd.patch
gfs2-convert-to-new-aops.patch
hugetlbfs-read-support.patch
hugetlbfs-read-support-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
