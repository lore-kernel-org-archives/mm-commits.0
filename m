From: akpm@linux-foundation.org
Subject: + oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch added to -mm tree
Date: Thu, 20 Jan 2011 16:28:12 -0800
Message-ID: <201101210028.p0L0SD2J011459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753065Ab1AUA3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 19:29:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     oom: suppress nodes that are not allowed from meminfo on oom kill
has been added to the -mm tree.  Its filename is
     oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: suppress nodes that are not allowed from meminfo on oom kill
From: David Rientjes <rientjes@google.com>

The oom killer is extremely verbose for machines with a large number of
cpus and/or nodes.  This verbosity can often be harmful if it causes other
important messages to be scrolled from the kernel log and incurs a
signicant time delay, specifically for kernels with CONFIG_NODES_SHIFT >
8.

This patch causes only memory information to be displayed for nodes that
are allowed by current's cpuset when dumping the VM state.  Information
for all other nodes is irrelevant to the oom condition; we don't care if
there's an abundance of memory elsewhere if we can't access it.

This only affects the behavior of dumping memory information when an oom
is triggered.  Other dumps, such as for sysrq+m, still display the
unfiltered form when using the existing show_mem() interface.

Additionally, the per-cpu pageset statistics are extremely verbose in oom
killer output, so it is now suppressed.  This removes

	nodes_weight(current->mems_allowed) * (1 + nr_cpus)

lines from the oom killer output.

Callers may use __show_mem(SHOW_MEM_FILTER_NODES) to filter disallowed
nodes.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++++++
 lib/show_mem.c     |    9 +++++++--
 mm/oom_kill.c      |    2 +-
 mm/page_alloc.c    |   34 +++++++++++++++++++++++++++++++++-
 4 files changed, 49 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill include/linux/mm.h
--- a/include/linux/mm.h~oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill
+++ a/include/linux/mm.h
@@ -850,7 +850,14 @@ extern void pagefault_out_of_memory(void
 
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
 
+/*
+ * Flags passed to __show_mem() and __show_free_areas() to suppress output in
+ * various contexts.
+ */
+#define SHOW_MEM_FILTER_NODES	(0x0001u)	/* filter disallowed nodes */
+
 extern void show_free_areas(void);
+extern void __show_free_areas(unsigned int flags);
 
 int shmem_lock(struct file *file, int lock, struct user_struct *user);
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags);
@@ -1337,6 +1344,7 @@ extern void calculate_zone_inactive_rati
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(void);
+extern void __show_mem(unsigned int flags);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 extern int after_bootmem;
diff -puN lib/show_mem.c~oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill lib/show_mem.c
--- a/lib/show_mem.c~oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill
+++ a/lib/show_mem.c
@@ -9,14 +9,14 @@
 #include <linux/nmi.h>
 #include <linux/quicklist.h>
 
-void show_mem(void)
+void __show_mem(unsigned int filter)
 {
 	pg_data_t *pgdat;
 	unsigned long total = 0, reserved = 0, shared = 0,
 		nonshared = 0, highmem = 0;
 
 	printk("Mem-Info:\n");
-	show_free_areas();
+	__show_free_areas(filter);
 
 	for_each_online_pgdat(pgdat) {
 		unsigned long i, flags;
@@ -61,3 +61,8 @@ void show_mem(void)
 		quicklist_total_size());
 #endif
 }
+
+void show_mem(void)
+{
+	__show_mem(0);
+}
diff -puN mm/oom_kill.c~oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill mm/oom_kill.c
--- a/mm/oom_kill.c~oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill
+++ a/mm/oom_kill.c
@@ -396,7 +396,7 @@ static void dump_header(struct task_stru
 	task_unlock(current);
 	dump_stack();
 	mem_cgroup_print_oom_info(mem, p);
-	show_mem();
+	__show_mem(SHOW_MEM_FILTER_NODES);
 	if (sysctl_oom_dump_tasks)
 		dump_tasks(mem, nodemask);
 }
diff -puN mm/page_alloc.c~oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill mm/page_alloc.c
--- a/mm/page_alloc.c~oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill
+++ a/mm/page_alloc.c
@@ -2399,19 +2399,42 @@ void si_meminfo_node(struct sysinfo *val
 }
 #endif
 
+/*
+ * Determine whether the zone's node should be displayed or not, depending on
+ * whether SHOW_MEM_FILTER_NODES was passed to __show_free_areas().
+ */
+static bool skip_free_areas_zone(unsigned int flags, const struct zone *zone)
+{
+	bool ret = false;
+
+	if (!(flags & SHOW_MEM_FILTER_NODES))
+		goto out;
+
+	get_mems_allowed();
+	ret = !node_isset(zone->zone_pgdat->node_id,
+				cpuset_current_mems_allowed);
+	put_mems_allowed();
+out:
+	return ret;
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 
 /*
  * Show free area list (used inside shift_scroll-lock stuff)
  * We also calculate the percentage fragmentation. We do this by counting the
  * memory on each free list with the exception of the first item on the list.
+ * Suppresses nodes that are not allowed by current's cpuset if
+ * SHOW_MEM_FILTER_NODES is passed.
  */
-void show_free_areas(void)
+void __show_free_areas(unsigned int filter)
 {
 	int cpu;
 	struct zone *zone;
 
 	for_each_populated_zone(zone) {
+		if (skip_free_areas_zone(filter, zone))
+			continue;
 		show_node(zone);
 		printk("%s per-cpu:\n", zone->name);
 
@@ -2453,6 +2476,8 @@ void show_free_areas(void)
 	for_each_populated_zone(zone) {
 		int i;
 
+		if (skip_free_areas_zone(filter, zone))
+			continue;
 		show_node(zone);
 		printk("%s"
 			" free:%lukB"
@@ -2520,6 +2545,8 @@ void show_free_areas(void)
 	for_each_populated_zone(zone) {
  		unsigned long nr[MAX_ORDER], flags, order, total = 0;
 
+		if (skip_free_areas_zone(filter, zone))
+			continue;
 		show_node(zone);
 		printk("%s: ", zone->name);
 
@@ -2539,6 +2566,11 @@ void show_free_areas(void)
 	show_swap_cache_info();
 }
 
+void show_free_areas(void)
+{
+	__show_free_areas(0);
+}
+
 static void zoneref_set_zone(struct zone *zone, struct zoneref *zoneref)
 {
 	zoneref->zone = zone;
_

Patches currently in -mm which might be from rientjes@google.com are

kconfig-rename-config_embedded-to-config_expert.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
jbd-remove-dependency-on-__gfp_nofail.patch

