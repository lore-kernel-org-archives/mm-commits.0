From: akpm@linux-foundation.org
Subject: [merged]
 lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch removed
 from -mm tree
Date: Thu, 23 Feb 2017 13:17:11 -0800
Message-ID: <58af5157.8ewuOvPidn+cVg4B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVRm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/show_mem.c: teach show_mem to work with the given nodemask
has been removed from the -mm tree.  Its filename was
     lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: lib/show_mem.c: teach show_mem to work with the given nodemask

show_mem() allows to filter out node specific data which is irrelevant to
the allocation request via SHOW_MEM_FILTER_NODES.  The filtering is done
in skip_free_areas_node which skips all nodes which are not in the
mems_allowed of the current process.  This works most of the time as
expected because the nodemask shouldn't be outside of the allocating task
but there are some exceptions.  E.g.  memory hotplug might want to request
allocations from outside of the allowed nodes (see new_node_page).

Get rid of this hardcoded behavior and push the allocation mask down the
show_mem path and use it instead of cpuset_current_mems_allowed.  NULL
nodemask is interpreted as cpuset_current_mems_allowed.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20170117091543.25850-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/xmon/xmon.c            |    2 -
 arch/sparc/kernel/setup_32.c        |    2 -
 drivers/net/ethernet/sgi/ioc3-eth.c |    2 -
 drivers/tty/sysrq.c                 |    2 -
 drivers/tty/vt/keyboard.c           |    2 -
 include/linux/mm.h                  |    5 +--
 lib/show_mem.c                      |    4 +-
 mm/nommu.c                          |    6 ++--
 mm/oom_kill.c                       |    2 -
 mm/page_alloc.c                     |   38 +++++++++++++-------------
 10 files changed, 32 insertions(+), 33 deletions(-)

diff -puN arch/powerpc/xmon/xmon.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask arch/powerpc/xmon/xmon.c
--- a/arch/powerpc/xmon/xmon.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask
+++ a/arch/powerpc/xmon/xmon.c
@@ -916,7 +916,7 @@ cmds(struct pt_regs *excp)
 				memzcan();
 				break;
 			case 'i':
-				show_mem(0);
+				show_mem(0, NULL);
 				break;
 			default:
 				termch = cmd;
diff -puN arch/sparc/kernel/setup_32.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask arch/sparc/kernel/setup_32.c
--- a/arch/sparc/kernel/setup_32.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask
+++ a/arch/sparc/kernel/setup_32.c
@@ -82,7 +82,7 @@ static void prom_sync_me(void)
 			     "nop\n\t" : : "r" (&trapbase));
 
 	prom_printf("PROM SYNC COMMAND...\n");
-	show_free_areas(0);
+	show_free_areas(0, NULL);
 	if (!is_idle_task(current)) {
 		local_irq_enable();
 		sys_sync();
diff -puN drivers/net/ethernet/sgi/ioc3-eth.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask drivers/net/ethernet/sgi/ioc3-eth.c
--- a/drivers/net/ethernet/sgi/ioc3-eth.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask
+++ a/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -914,7 +914,7 @@ static void ioc3_alloc_rings(struct net_
 
 			skb = ioc3_alloc_skb(RX_BUF_ALLOC_SIZE, GFP_ATOMIC);
 			if (!skb) {
-				show_free_areas(0);
+				show_free_areas(0, NULL);
 				continue;
 			}
 
diff -puN drivers/tty/sysrq.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask
+++ a/drivers/tty/sysrq.c
@@ -317,7 +317,7 @@ static struct sysrq_key_op sysrq_ftrace_
 
 static void sysrq_handle_showmem(int key)
 {
-	show_mem(0);
+	show_mem(0, NULL);
 }
 static struct sysrq_key_op sysrq_showmem_op = {
 	.handler	= sysrq_handle_showmem,
diff -puN drivers/tty/vt/keyboard.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask drivers/tty/vt/keyboard.c
--- a/drivers/tty/vt/keyboard.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask
+++ a/drivers/tty/vt/keyboard.c
@@ -572,7 +572,7 @@ static void fn_scroll_back(struct vc_dat
 
 static void fn_show_mem(struct vc_data *vc)
 {
-	show_mem(0);
+	show_mem(0, NULL);
 }
 
 static void fn_show_state(struct vc_data *vc)
diff -puN include/linux/mm.h~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask include/linux/mm.h
--- a/include/linux/mm.h~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask
+++ a/include/linux/mm.h
@@ -1152,8 +1152,7 @@ extern void pagefault_out_of_memory(void
  */
 #define SHOW_MEM_FILTER_NODES		(0x0001u)	/* disallowed nodes */
 
-extern void show_free_areas(unsigned int flags);
-extern bool skip_free_areas_node(unsigned int flags, int nid);
+extern void show_free_areas(unsigned int flags, nodemask_t *nodemask);
 
 int shmem_zero_setup(struct vm_area_struct *);
 #ifdef CONFIG_SHMEM
@@ -1934,7 +1933,7 @@ extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
 extern void __init mmap_init(void);
-extern void show_mem(unsigned int flags);
+extern void show_mem(unsigned int flags, nodemask_t *nodemask);
 extern long si_mem_available(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
diff -puN lib/show_mem.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask lib/show_mem.c
--- a/lib/show_mem.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask
+++ a/lib/show_mem.c
@@ -9,13 +9,13 @@
 #include <linux/quicklist.h>
 #include <linux/cma.h>
 
-void show_mem(unsigned int filter)
+void show_mem(unsigned int filter, nodemask_t *nodemask)
 {
 	pg_data_t *pgdat;
 	unsigned long total = 0, reserved = 0, highmem = 0;
 
 	printk("Mem-Info:\n");
-	show_free_areas(filter);
+	show_free_areas(filter, nodemask);
 
 	for_each_online_pgdat(pgdat) {
 		unsigned long flags;
diff -puN mm/nommu.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask mm/nommu.c
--- a/mm/nommu.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask
+++ a/mm/nommu.c
@@ -1191,7 +1191,7 @@ error_free:
 enomem:
 	pr_err("Allocation of length %lu from process %d (%s) failed\n",
 	       len, current->pid, current->comm);
-	show_free_areas(0);
+	show_free_areas(0, NULL);
 	return -ENOMEM;
 }
 
@@ -1412,13 +1412,13 @@ error_getting_vma:
 	kmem_cache_free(vm_region_jar, region);
 	pr_warn("Allocation of vma for %lu byte allocation from process %d failed\n",
 			len, current->pid);
-	show_free_areas(0);
+	show_free_areas(0, NULL);
 	return -ENOMEM;
 
 error_getting_region:
 	pr_warn("Allocation of vm region for %lu byte allocation from process %d failed\n",
 			len, current->pid);
-	show_free_areas(0);
+	show_free_areas(0, NULL);
 	return -ENOMEM;
 }
 
diff -puN mm/oom_kill.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask mm/oom_kill.c
--- a/mm/oom_kill.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask
+++ a/mm/oom_kill.c
@@ -417,7 +417,7 @@ static void dump_header(struct oom_contr
 	if (oc->memcg)
 		mem_cgroup_print_oom_info(oc->memcg, p);
 	else
-		show_mem(SHOW_MEM_FILTER_NODES);
+		show_mem(SHOW_MEM_FILTER_NODES, nm);
 	if (sysctl_oom_dump_tasks)
 		dump_tasks(oc->memcg, oc->nodemask);
 }
diff -puN mm/page_alloc.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask mm/page_alloc.c
--- a/mm/page_alloc.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask
+++ a/mm/page_alloc.c
@@ -3005,7 +3005,7 @@ static inline bool should_suppress_show_
 	return ret;
 }
 
-static void warn_alloc_show_mem(gfp_t gfp_mask)
+static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
 {
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
 	static DEFINE_RATELIMIT_STATE(show_mem_rs, HZ, 1);
@@ -3025,7 +3025,7 @@ static void warn_alloc_show_mem(gfp_t gf
 	if (in_interrupt() || !(gfp_mask & __GFP_DIRECT_RECLAIM))
 		filter &= ~SHOW_MEM_FILTER_NODES;
 
-	show_mem(filter);
+	show_mem(filter, nodemask);
 }
 
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
@@ -3052,7 +3052,7 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 	cpuset_print_current_mems_allowed();
 
 	dump_stack();
-	warn_alloc_show_mem(gfp_mask);
+	warn_alloc_show_mem(gfp_mask, nm);
 }
 
 static inline struct page *
@@ -4274,20 +4274,20 @@ void si_meminfo_node(struct sysinfo *val
  * Determine whether the node should be displayed or not, depending on whether
  * SHOW_MEM_FILTER_NODES was passed to show_free_areas().
  */
-bool skip_free_areas_node(unsigned int flags, int nid)
+static bool show_mem_node_skip(unsigned int flags, int nid, nodemask_t *nodemask)
 {
-	bool ret = false;
-	unsigned int cpuset_mems_cookie;
-
 	if (!(flags & SHOW_MEM_FILTER_NODES))
-		goto out;
+		return false;
 
-	do {
-		cpuset_mems_cookie = read_mems_allowed_begin();
-		ret = !node_isset(nid, cpuset_current_mems_allowed);
-	} while (read_mems_allowed_retry(cpuset_mems_cookie));
-out:
-	return ret;
+	/*
+	 * no node mask - aka implicit memory numa policy. Do not bother with
+	 * the synchronization - read_mems_allowed_begin - because we do not
+	 * have to be precise here.
+	 */
+	if (!nodemask)
+		nodemask = &cpuset_current_mems_allowed;
+
+	return !node_isset(nid, *nodemask);
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
@@ -4328,7 +4328,7 @@ static void show_migration_types(unsigne
  * SHOW_MEM_FILTER_NODES: suppress nodes that are not allowed by current's
  *   cpuset.
  */
-void show_free_areas(unsigned int filter)
+void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 {
 	unsigned long free_pcp = 0;
 	int cpu;
@@ -4336,7 +4336,7 @@ void show_free_areas(unsigned int filter
 	pg_data_t *pgdat;
 
 	for_each_populated_zone(zone) {
-		if (skip_free_areas_node(filter, zone_to_nid(zone)))
+		if (show_mem_node_skip(filter, zone_to_nid(zone), nodemask))
 			continue;
 
 		for_each_online_cpu(cpu)
@@ -4370,7 +4370,7 @@ void show_free_areas(unsigned int filter
 		global_page_state(NR_FREE_CMA_PAGES));
 
 	for_each_online_pgdat(pgdat) {
-		if (skip_free_areas_node(filter, pgdat->node_id))
+		if (show_mem_node_skip(filter, pgdat->node_id, nodemask))
 			continue;
 
 		printk("Node %d"
@@ -4422,7 +4422,7 @@ void show_free_areas(unsigned int filter
 	for_each_populated_zone(zone) {
 		int i;
 
-		if (skip_free_areas_node(filter, zone_to_nid(zone)))
+		if (show_mem_node_skip(filter, zone_to_nid(zone), nodemask))
 			continue;
 
 		free_pcp = 0;
@@ -4487,7 +4487,7 @@ void show_free_areas(unsigned int filter
 		unsigned long nr[MAX_ORDER], flags, total = 0;
 		unsigned char types[MAX_ORDER];
 
-		if (skip_free_areas_node(filter, zone_to_nid(zone)))
+		if (show_mem_node_skip(filter, zone_to_nid(zone), nodemask))
 			continue;
 		show_node(zone);
 		printk(KERN_CONT "%s: ", zone->name);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-page_alloc-do-not-depend-on-cpu-hotplug-locks-inside-the-allocator.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch
vmalloc-back-of-when-the-current-is-killed.patch

