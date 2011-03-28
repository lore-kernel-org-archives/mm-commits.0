From: akpm@linux-foundation.org
Subject: + arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions.patch added to -mm tree
Date: Mon, 28 Mar 2011 15:56:19 -0700
Message-ID: <201103282256.p2SMuJNc002594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753589Ab1C1W6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Mar 2011 18:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, davem@davemloft.net, deller@gmx.de, fenghua.yu@intel.com, gxt@mprc.pku.edu.cn, jejb@parisc-linux.org, kyle@mcmartin.ca, linux@arm.linux.org.uk, tony.luck@intel.com


The patch titled
     arch, mm: filter disallowed nodes from arch specific show_mem functions
has been added to the -mm tree.  Its filename is
     arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions.patch

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
Subject: arch, mm: filter disallowed nodes from arch specific show_mem functions
From: David Rientjes <rientjes@google.com>

Architectures that implement their own show_mem() function did not pass
the filter argument to show_free_areas() to appropriately avoid emitting
the state of nodes that are disallowed in the current context.  This patch
now passes the filter argument to show_free_areas() so those nodes are now
avoided.

This patch also removes the show_free_areas() wrapper around
__show_free_areas() and converts existing callers to pass an empty filter.

ia64 emits additional information for each node, so skip_free_areas_zone()
must be made global to filter disallowed nodes and it is converted to use
a nid argument rather than a zone for this use case.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <jejb@parisc-linux.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c               |    2 +-
 arch/ia64/mm/contig.c            |   10 ++++++----
 arch/ia64/mm/discontig.c         |   10 ++++++----
 arch/parisc/mm/init.c            |    2 +-
 arch/sparc/kernel/setup_32.c     |    2 +-
 arch/sparc/mm/init_32.c          |    2 +-
 arch/unicore32/mm/init.c         |    2 +-
 drivers/net/ioc3-eth.c           |    2 +-
 drivers/tty/serial/68328serial.c |    2 +-
 include/linux/mm.h               |    6 +++---
 lib/show_mem.c                   |    2 +-
 mm/nommu.c                       |    6 +++---
 mm/page_alloc.c                  |   22 ++++++++--------------
 13 files changed, 34 insertions(+), 36 deletions(-)

diff -puN arch/arm/mm/init.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/arch/arm/mm/init.c
@@ -85,7 +85,7 @@ void show_mem(unsigned int filter)
 	struct meminfo * mi = &meminfo;
 
 	printk("Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 
 	for_each_bank (i, mi) {
 		struct membank *bank = &mi->bank[i];
diff -puN arch/ia64/mm/contig.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/arch/ia64/mm/contig.c
@@ -44,13 +44,16 @@ void show_mem(unsigned int filter)
 	pg_data_t *pgdat;
 
 	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 	printk(KERN_INFO "Node memory in pages:\n");
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
 		unsigned long flags;
 		int shared = 0, cached = 0, reserved = 0;
+		int nid = pgdat->node_id;
 
+		if (skip_free_areas_node(filter, nid))
+			continue;
 		pgdat_resize_lock(pgdat, &flags);
 		present = pgdat->node_present_pages;
 		for(i = 0; i < pgdat->node_spanned_pages; i++) {
@@ -64,8 +67,7 @@ void show_mem(unsigned int filter)
 				if (max_gap < LARGE_GAP)
 					continue;
 #endif
-				i = vmemmap_find_next_valid_pfn(pgdat->node_id,
-					 i) - 1;
+				i = vmemmap_find_next_valid_pfn(nid, i) - 1;
 				continue;
 			}
 			if (PageReserved(page))
@@ -81,7 +83,7 @@ void show_mem(unsigned int filter)
 		total_cached += cached;
 		total_shared += shared;
 		printk(KERN_INFO "Node %4d:  RAM: %11ld, rsvd: %8d, "
-		       "shrd: %10d, swpd: %10d\n", pgdat->node_id,
+		       "shrd: %10d, swpd: %10d\n", nid,
 		       present, reserved, shared, cached);
 	}
 	printk(KERN_INFO "%ld pages of RAM\n", total_present);
diff -puN arch/ia64/mm/discontig.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/arch/ia64/mm/discontig.c
@@ -622,13 +622,16 @@ void show_mem(unsigned int filter)
 	pg_data_t *pgdat;
 
 	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 	printk(KERN_INFO "Node memory in pages:\n");
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
 		unsigned long flags;
 		int shared = 0, cached = 0, reserved = 0;
+		int nid = pgdat->node_id;
 
+		if (skip_free_areas_node(filter, nid))
+			continue;
 		pgdat_resize_lock(pgdat, &flags);
 		present = pgdat->node_present_pages;
 		for(i = 0; i < pgdat->node_spanned_pages; i++) {
@@ -638,8 +641,7 @@ void show_mem(unsigned int filter)
 			if (pfn_valid(pgdat->node_start_pfn + i))
 				page = pfn_to_page(pgdat->node_start_pfn + i);
 			else {
-				i = vmemmap_find_next_valid_pfn(pgdat->node_id,
-					 i) - 1;
+				i = vmemmap_find_next_valid_pfn(nid, i) - 1;
 				continue;
 			}
 			if (PageReserved(page))
@@ -655,7 +657,7 @@ void show_mem(unsigned int filter)
 		total_cached += cached;
 		total_shared += shared;
 		printk(KERN_INFO "Node %4d:  RAM: %11ld, rsvd: %8d, "
-		       "shrd: %10d, swpd: %10d\n", pgdat->node_id,
+		       "shrd: %10d, swpd: %10d\n", nid,
 		       present, reserved, shared, cached);
 	}
 	printk(KERN_INFO "%ld pages of RAM\n", total_present);
diff -puN arch/parisc/mm/init.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/arch/parisc/mm/init.c
@@ -550,7 +550,7 @@ void show_mem(unsigned int filter)
 	int shared = 0, cached = 0;
 
 	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 #ifndef CONFIG_DISCONTIGMEM
 	i = max_mapnr;
 	while (i-- > 0) {
diff -puN arch/sparc/kernel/setup_32.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions arch/sparc/kernel/setup_32.c
--- a/arch/sparc/kernel/setup_32.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/arch/sparc/kernel/setup_32.c
@@ -82,7 +82,7 @@ static void prom_sync_me(void)
 			     "nop\n\t" : : "r" (&trapbase));
 
 	prom_printf("PROM SYNC COMMAND...\n");
-	show_free_areas();
+	show_free_areas(0);
 	if(current->pid != 0) {
 		local_irq_enable();
 		sys_sync();
diff -puN arch/sparc/mm/init_32.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/arch/sparc/mm/init_32.c
@@ -78,7 +78,7 @@ void __init kmap_init(void)
 void show_mem(unsigned int filter)
 {
 	printk("Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 	printk("Free swap:       %6ldkB\n",
 	       nr_swap_pages << (PAGE_SHIFT-10));
 	printk("%ld pages of RAM\n", totalram_pages);
diff -puN arch/unicore32/mm/init.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions arch/unicore32/mm/init.c
--- a/arch/unicore32/mm/init.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/arch/unicore32/mm/init.c
@@ -62,7 +62,7 @@ void show_mem(unsigned int filter)
 	struct meminfo *mi = &meminfo;
 
 	printk(KERN_DEFAULT "Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 
 	for_each_bank(i, mi) {
 		struct membank *bank = &mi->bank[i];
diff -puN drivers/net/ioc3-eth.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions drivers/net/ioc3-eth.c
--- a/drivers/net/ioc3-eth.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/drivers/net/ioc3-eth.c
@@ -917,7 +917,7 @@ static void ioc3_alloc_rings(struct net_
 
 			skb = ioc3_alloc_skb(RX_BUF_ALLOC_SIZE, GFP_ATOMIC);
 			if (!skb) {
-				show_free_areas();
+				show_free_areas(0);
 				continue;
 			}
 
diff -puN drivers/tty/serial/68328serial.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions drivers/tty/serial/68328serial.c
--- a/drivers/tty/serial/68328serial.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/drivers/tty/serial/68328serial.c
@@ -281,7 +281,7 @@ static void receive_chars(struct m68k_se
 #ifdef CONFIG_MAGIC_SYSRQ
 			} else if (ch == 0x10) { /* ^P */
 				show_state();
-				show_free_areas();
+				show_free_areas(0);
 				show_buffers();
 /*				show_net_buffers(); */
 				return;
diff -puN include/linux/mm.h~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions include/linux/mm.h
--- a/include/linux/mm.h~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/include/linux/mm.h
@@ -861,13 +861,13 @@ extern void pagefault_out_of_memory(void
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
 
 /*
- * Flags passed to show_mem() and __show_free_areas() to suppress output in
+ * Flags passed to show_mem() and show_free_areas() to suppress output in
  * various contexts.
  */
 #define SHOW_MEM_FILTER_NODES	(0x0001u)	/* filter disallowed nodes */
 
-extern void show_free_areas(void);
-extern void __show_free_areas(unsigned int flags);
+extern void show_free_areas(unsigned int flags);
+extern bool skip_free_areas_node(unsigned int flags, int nid);
 
 int shmem_lock(struct file *file, int lock, struct user_struct *user);
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags);
diff -puN lib/show_mem.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions lib/show_mem.c
--- a/lib/show_mem.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/lib/show_mem.c
@@ -16,7 +16,7 @@ void show_mem(unsigned int filter)
 		nonshared = 0, highmem = 0;
 
 	printk("Mem-Info:\n");
-	__show_free_areas(filter);
+	show_free_areas(filter);
 
 	for_each_online_pgdat(pgdat) {
 		unsigned long i, flags;
diff -puN mm/nommu.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions mm/nommu.c
--- a/mm/nommu.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/mm/nommu.c
@@ -1235,7 +1235,7 @@ error_free:
 enomem:
 	printk("Allocation of length %lu from process %d (%s) failed\n",
 	       len, current->pid, current->comm);
-	show_free_areas();
+	show_free_areas(0);
 	return -ENOMEM;
 }
 
@@ -1468,14 +1468,14 @@ error_getting_vma:
 	printk(KERN_WARNING "Allocation of vma for %lu byte allocation"
 	       " from process %d failed\n",
 	       len, current->pid);
-	show_free_areas();
+	show_free_areas(0);
 	return -ENOMEM;
 
 error_getting_region:
 	printk(KERN_WARNING "Allocation of vm region for %lu byte allocation"
 	       " from process %d failed\n",
 	       len, current->pid);
-	show_free_areas();
+	show_free_areas(0);
 	return -ENOMEM;
 }
 EXPORT_SYMBOL(do_mmap_pgoff);
diff -puN mm/page_alloc.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions mm/page_alloc.c
--- a/mm/page_alloc.c~arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions
+++ a/mm/page_alloc.c
@@ -2446,10 +2446,10 @@ void si_meminfo_node(struct sysinfo *val
 #endif
 
 /*
- * Determine whether the zone's node should be displayed or not, depending on
- * whether SHOW_MEM_FILTER_NODES was passed to __show_free_areas().
+ * Determine whether the node should be displayed or not, depending on whether
+ * SHOW_MEM_FILTER_NODES was passed to show_free_areas().
  */
-static bool skip_free_areas_zone(unsigned int flags, const struct zone *zone)
+bool skip_free_areas_node(unsigned int flags, int nid)
 {
 	bool ret = false;
 
@@ -2457,8 +2457,7 @@ static bool skip_free_areas_zone(unsigne
 		goto out;
 
 	get_mems_allowed();
-	ret = !node_isset(zone->zone_pgdat->node_id,
-				cpuset_current_mems_allowed);
+	ret = !node_isset(nid, cpuset_current_mems_allowed);
 	put_mems_allowed();
 out:
 	return ret;
@@ -2473,13 +2472,13 @@ out:
  * Suppresses nodes that are not allowed by current's cpuset if
  * SHOW_MEM_FILTER_NODES is passed.
  */
-void __show_free_areas(unsigned int filter)
+void show_free_areas(unsigned int filter)
 {
 	int cpu;
 	struct zone *zone;
 
 	for_each_populated_zone(zone) {
-		if (skip_free_areas_zone(filter, zone))
+		if (skip_free_areas_node(filter, zone_to_nid(zone)))
 			continue;
 		show_node(zone);
 		printk("%s per-cpu:\n", zone->name);
@@ -2522,7 +2521,7 @@ void __show_free_areas(unsigned int filt
 	for_each_populated_zone(zone) {
 		int i;
 
-		if (skip_free_areas_zone(filter, zone))
+		if (skip_free_areas_node(filter, zone_to_nid(zone)))
 			continue;
 		show_node(zone);
 		printk("%s"
@@ -2591,7 +2590,7 @@ void __show_free_areas(unsigned int filt
 	for_each_populated_zone(zone) {
  		unsigned long nr[MAX_ORDER], flags, order, total = 0;
 
-		if (skip_free_areas_zone(filter, zone))
+		if (skip_free_areas_node(filter, zone_to_nid(zone)))
 			continue;
 		show_node(zone);
 		printk("%s: ", zone->name);
@@ -2612,11 +2611,6 @@ void __show_free_areas(unsigned int filt
 	show_swap_cache_info();
 }
 
-void show_free_areas(void)
-{
-	__show_free_areas(0);
-}
