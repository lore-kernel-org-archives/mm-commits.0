From: akpm@linux-foundation.org
Subject: - change-zonelist-order-zonelist-order-selection-logic.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:38 -0700
Message-ID: <200707162048.l6GKmcOT001080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758182AbXGPUsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, ak@suse.de, clameter@sgi.com, jesse.barnes@intel.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     change zonelist order: zonelist order selection logic
has been removed from the -mm tree.  Its filename was
     change-zonelist-order-zonelist-order-selection-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: change zonelist order: zonelist order selection logic
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Make zonelist creation policy selectable from sysctl/boot option v6.

This patch makes NUMA's zonelist (of pgdat) order selectable.
Available order are Default(automatic)/ Node-based / Zone-based.

[Default Order]
The kernel selects Node-based or Zone-based order automatically.

[Node-based Order]
This policy treats the locality of memory as the most important parameter.
Zonelist order is created by each zone's locality. This means lower zones
(ex. ZONE_DMA) can be used before higher zone (ex. ZONE_NORMAL) exhausion.
IOW. ZONE_DMA will be in the middle of zonelist.
current 2.6.21 kernel uses this.

Pros.
 * A user can expect local memory as much as possible.
Cons.
 * lower zone will be exhansted before higher zone. This may cause OOM_KILL.

Maybe suitable if ZONE_DMA is relatively big and you never see OOM_KILL
because of ZONE_DMA exhaution and you need the best locality.

(example)
assume 2 node NUMA. node(0) has ZONE_DMA/ZONE_NORMAL, node(1) has ZONE_NORMAL.

*node(0)'s memory allocation order:

 node(0)'s NORMAL -> node(0)'s DMA -> node(1)'s NORMAL.

*node(1)'s memory allocation order:

 node(1)'s NORMAL -> node(0)'s NORMAL -> node(0)'s DMA.

[Zone-based order]
This policy treats the zone type as the most important parameter.
Zonelist order is created by zone-type order. This means lower zone
never be used bofere higher zone exhaustion.
IOW. ZONE_DMA will be always at the tail of zonelist.

Pros.
 * OOM_KILL(bacause of lower zone) occurs only if the whole zones are exhausted.
Cons.
 * memory locality may not be best.

(example)
assume 2 node NUMA. node(0) has ZONE_DMA/ZONE_NORMAL, node(1) has ZONE_NORMAL.

*node(0)'s memory allocation order:

 node(0)'s NORMAL -> node(1)'s NORMAL -> node(0)'s DMA.

*node(1)'s memory allocation order:

 node(1)'s NORMAL -> node(0)'s NORMAL -> node(0)'s DMA.

bootoption "numa_zonelist_order=" and proc/sysctl is supporetd.

command:
%echo N > /proc/sys/vm/numa_zonelist_order

Will rebuild zonelist in Node-based order.

command:
%echo Z > /proc/sys/vm/numa_zonelist_order

Will rebuild zonelist in Zone-based order.

Thanks to Lee Schermerhorn, he gives me much help and codes.

[Lee.Schermerhorn@hp.com: add check_highest_zone to build_zonelists_in_zone_order]
[akpm@linux-foundation.org: build fix]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "jesse.barnes@intel.com" <jesse.barnes@intel.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 
 Documentation/sysctl/vm.txt         |   45 ++++
 include/linux/mmzone.h              |    5 
 kernel/sysctl.c                     |   11 +
 mm/page_alloc.c                     |  273 +++++++++++++++++++++++---
 5 files changed, 317 insertions(+), 22 deletions(-)

diff -puN Documentation/kernel-parameters.txt~change-zonelist-order-zonelist-order-selection-logic Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~change-zonelist-order-zonelist-order-selection-logic
+++ a/Documentation/kernel-parameters.txt
@@ -1196,6 +1196,11 @@ and is between 256 and 4096 characters. 
 
 	nowb		[ARM]
 
+	numa_zonelist_order= [KNL, BOOT] Select zonelist order for NUMA.
+			one of ['zone', 'node', 'default'] can be specified
+			This can be set from sysctl after boot.
+			See Documentation/sysctl/vm.txt for details.
+
 	nr_uarts=	[SERIAL] maximum number of UARTs to be registered.
 
 	opl3=		[HW,OSS]
diff -puN Documentation/sysctl/vm.txt~change-zonelist-order-zonelist-order-selection-logic Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~change-zonelist-order-zonelist-order-selection-logic
+++ a/Documentation/sysctl/vm.txt
@@ -32,6 +32,7 @@ Currently, these files are in /proc/sys/
 - min_slab_ratio
 - panic_on_oom
 - mmap_min_address
+- numa_zonelist_order
 
 ==============================================================
 
@@ -231,3 +232,47 @@ security module.  Setting this value to 
 vast majority of applications to work correctly and provide defense in depth
 against future potential kernel bugs.
 
+==============================================================
+
+numa_zonelist_order
+
+This sysctl is only for NUMA.
+'where the memory is allocated from' is controlled by zonelists.
+(This documentation ignores ZONE_HIGHMEM/ZONE_DMA32 for simple explanation.
+ you may be able to read ZONE_DMA as ZONE_DMA32...)
+
+In non-NUMA case, a zonelist for GFP_KERNEL is ordered as following.
+ZONE_NORMAL -> ZONE_DMA
+This means that a memory allocation request for GFP_KERNEL will
+get memory from ZONE_DMA only when ZONE_NORMAL is not available.
+
+In NUMA case, you can think of following 2 types of order.
+Assume 2 node NUMA and below is zonelist of Node(0)'s GFP_KERNEL
+
+(A) Node(0) ZONE_NORMAL -> Node(0) ZONE_DMA -> Node(1) ZONE_NORMAL
+(B) Node(0) ZONE_NORMAL -> Node(1) ZONE_NORMAL -> Node(0) ZONE_DMA.
+
+Type(A) offers the best locality for processes on Node(0), but ZONE_DMA
+will be used before ZONE_NORMAL exhaustion. This increases possibility of
+out-of-memory(OOM) of ZONE_DMA because ZONE_DMA is tend to be small.
+
+Type(B) cannot offer the best locality but is more robust against OOM of
+the DMA zone.
+
+Type(A) is called as "Node" order. Type (B) is "Zone" order.
+
+"Node order" orders the zonelists by node, then by zone within each node.
+Specify "[Nn]ode" for zone order
+
+"Zone Order" orders the zonelists by zone type, then by node within each
+zone.  Specify "[Zz]one"for zode order.
+
+Specify "[Dd]efault" to request automatic configuration.  Autoconfiguration
+will select "node" order in following case.
+(1) if the DMA zone does not exist or
+(2) if the DMA zone comprises greater than 50% of the available memory or
+(3) if any node's DMA zone comprises greater than 60% of its local memory and
+    the amount of local memory is big enough.
+
+Otherwise, "zone" order will be selected. Default order is recommended unless
+this is causing problems for your system/application.
diff -puN include/linux/mmzone.h~change-zonelist-order-zonelist-order-selection-logic include/linux/mmzone.h
--- a/include/linux/mmzone.h~change-zonelist-order-zonelist-order-selection-logic
+++ a/include/linux/mmzone.h
@@ -566,6 +566,11 @@ int sysctl_min_unmapped_ratio_sysctl_han
 int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *, int,
 			struct file *, void __user *, size_t *, loff_t *);
 
+extern int numa_zonelist_order_handler(struct ctl_table *, int,
+			struct file *, void __user *, size_t *, loff_t *);
+extern char numa_zonelist_order[];
+#define NUMA_ZONELIST_ORDER_LEN 16	/* string buffer size */
+
 #include <linux/topology.h>
 /* Returns the number of the current Node. */
 #ifndef numa_node_id
diff -puN kernel/sysctl.c~change-zonelist-order-zonelist-order-selection-logic kernel/sysctl.c
--- a/kernel/sysctl.c~change-zonelist-order-zonelist-order-selection-logic
+++ a/kernel/sysctl.c
@@ -958,6 +958,17 @@ static ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
+#ifdef CONFIG_NUMA
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "numa_zonelist_order",
+		.data		= &numa_zonelist_order,
+		.maxlen		= NUMA_ZONELIST_ORDER_LEN,
+		.mode		= 0644,
+		.proc_handler	= &numa_zonelist_order_handler,
+		.strategy	= &sysctl_string,
+	},
+#endif
 #endif
 #if defined(CONFIG_X86_32) || \
    (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
diff -puN mm/page_alloc.c~change-zonelist-order-zonelist-order-selection-logic mm/page_alloc.c
--- a/mm/page_alloc.c~change-zonelist-order-zonelist-order-selection-logic
+++ a/mm/page_alloc.c
@@ -1621,8 +1621,8 @@ void show_free_areas(void)
  *
  * Add all populated zones of a node to the zonelist.
  */
-static int __meminit build_zonelists_node(pg_data_t *pgdat,
-			struct zonelist *zonelist, int nr_zones, enum zone_type zone_type)
+static int build_zonelists_node(pg_data_t *pgdat, struct zonelist *zonelist,
+				int nr_zones, enum zone_type zone_type)
 {
 	struct zone *zone;
 
@@ -1641,9 +1641,102 @@ static int __meminit build_zonelists_nod
 	return nr_zones;
 }
 
+
+/*
+ *  zonelist_order:
+ *  0 = automatic detection of better ordering.
+ *  1 = order by ([node] distance, -zonetype)
+ *  2 = order by (-zonetype, [node] distance)
+ *
+ *  If not NUMA, ZONELIST_ORDER_ZONE and ZONELIST_ORDER_NODE will create
+ *  the same zonelist. So only NUMA can configure this param.
+ */
+#define ZONELIST_ORDER_DEFAULT  0
+#define ZONELIST_ORDER_NODE     1
+#define ZONELIST_ORDER_ZONE     2
+
+/* zonelist order in the kernel.
+ * set_zonelist_order() will set this to NODE or ZONE.
+ */
+static int current_zonelist_order = ZONELIST_ORDER_DEFAULT;
+static char zonelist_order_name[3][8] = {"Default", "Node", "Zone"};
+
+
 #ifdef CONFIG_NUMA
+/* The value user specified ....changed by config */
+static int user_zonelist_order = ZONELIST_ORDER_DEFAULT;
+/* string for sysctl */
+#define NUMA_ZONELIST_ORDER_LEN	16
+char numa_zonelist_order[16] = "default";
+
+/*
+ * interface for configure zonelist ordering.
+ * command line option "numa_zonelist_order"
+ *	= "[dD]efault	- default, automatic configuration.
+ *	= "[nN]ode 	- order by node locality, then by zone within node
+ *	= "[zZ]one      - order by zone, then by locality within zone
+ */
+
+static int __parse_numa_zonelist_order(char *s)
+{
+	if (*s == 'd' || *s == 'D') {
+		user_zonelist_order = ZONELIST_ORDER_DEFAULT;
+	} else if (*s == 'n' || *s == 'N') {
+		user_zonelist_order = ZONELIST_ORDER_NODE;
+	} else if (*s == 'z' || *s == 'Z') {
+		user_zonelist_order = ZONELIST_ORDER_ZONE;
+	} else {
+		printk(KERN_WARNING
+			"Ignoring invalid numa_zonelist_order value:  "
+			"%s\n", s);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static __init int setup_numa_zonelist_order(char *s)
+{
+	if (s)
+		return __parse_numa_zonelist_order(s);
+	return 0;
+}
+early_param("numa_zonelist_order", setup_numa_zonelist_order);
+
+/*
+ * sysctl handler for numa_zonelist_order
+ */
+int numa_zonelist_order_handler(ctl_table *table, int write,
+		struct file *file, void __user *buffer, size_t *length,
+		loff_t *ppos)
+{
+	char saved_string[NUMA_ZONELIST_ORDER_LEN];
+	int ret;
+
+	if (write)
+		strncpy(saved_string, (char*)table->data,
+			NUMA_ZONELIST_ORDER_LEN);
+	ret = proc_dostring(table, write, file, buffer, length, ppos);
+	if (ret)
+		return ret;
+	if (write) {
+		int oldval = user_zonelist_order;
+		if (__parse_numa_zonelist_order((char*)table->data)) {
+			/*
+			 * bogus value.  restore saved string
+			 */
+			strncpy((char*)table->data, saved_string,
+				NUMA_ZONELIST_ORDER_LEN);
+			user_zonelist_order = oldval;
+		} else if (oldval != user_zonelist_order)
+			build_all_zonelists();
+	}
+	return 0;
+}
+
+
 #define MAX_NODE_LOAD (num_online_nodes())
-static int __meminitdata node_load[MAX_NUMNODES];
+static int node_load[MAX_NUMNODES];
+
 /**
  * find_next_best_node - find the next node that should appear in a given node's fallback list
  * @node: node whose fallback list we're appending
@@ -1658,7 +1751,7 @@ static int __meminitdata node_load[MAX_N
  * on them otherwise.
  * It returns -1 if no node is found.
  */
-static int __meminit find_next_best_node(int node, nodemask_t *used_node_mask)
+static int find_next_best_node(int node, nodemask_t *used_node_mask)
 {
 	int n, val;
 	int min_val = INT_MAX;
@@ -1704,13 +1797,129 @@ static int __meminit find_next_best_node
 	return best_node;
 }
 
-static void __meminit build_zonelists(pg_data_t *pgdat)
+
+/*
+ * Build zonelists ordered by node and zones within node.
+ * This results in maximum locality--normal zone overflows into local
+ * DMA zone, if any--but risks exhausting DMA zone.
+ */
+static void build_zonelists_in_node_order(pg_data_t *pgdat, int node)
 {
-	int j, node, local_node;
 	enum zone_type i;
-	int prev_node, load;
+	int j;
 	struct zonelist *zonelist;
+
+	for (i = 0; i < MAX_NR_ZONES; i++) {
+		zonelist = pgdat->node_zonelists + i;
+		for (j = 0; zonelist->zones[j] != NULL; j++)
+			;
+ 		j = build_zonelists_node(NODE_DATA(node), zonelist, j, i);
+		zonelist->zones[j] = NULL;
+	}
+}
+
+/*
+ * Build zonelists ordered by zone and nodes within zones.
+ * This results in conserving DMA zone[s] until all Normal memory is
+ * exhausted, but results in overflowing to remote node while memory
+ * may still exist in local DMA zone.
+ */
+static int node_order[MAX_NUMNODES];
+
+static void build_zonelists_in_zone_order(pg_data_t *pgdat, int nr_nodes)
+{
+	enum zone_type i;
+	int pos, j, node;
+	int zone_type;		/* needs to be signed */
+	struct zone *z;
+	struct zonelist *zonelist;
+
+	for (i = 0; i < MAX_NR_ZONES; i++) {
+		zonelist = pgdat->node_zonelists + i;
+		pos = 0;
+		for (zone_type = i; zone_type >= 0; zone_type--) {
+			for (j = 0; j < nr_nodes; j++) {
+				node = node_order[j];
+				z = &NODE_DATA(node)->node_zones[zone_type];
+				if (populated_zone(z)) {
+					zonelist->zones[pos++] = z;
+					check_highest_zone(zone_type);
+				}
+			}
+		}
+		zonelist->zones[pos] = NULL;
+	}
+}
+
+static int default_zonelist_order(void)
+{
+	int nid, zone_type;
+	unsigned long low_kmem_size,total_size;
+	struct zone *z;
+	int average_size;
+	/*
+         * ZONE_DMA and ZONE_DMA32 can be very small area in the sytem.
+	 * If they are really small and used heavily, the system can fall
+	 * into OOM very easily.
+	 * This function detect ZONE_DMA/DMA32 size and confgigures zone order.
+	 */
+	/* Is there ZONE_NORMAL ? (ex. ppc has only DMA zone..) */
+	low_kmem_size = 0;
+	total_size = 0;
+	for_each_online_node(nid) {
+		for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+			z = &NODE_DATA(nid)->node_zones[zone_type];
+			if (populated_zone(z)) {
+				if (zone_type < ZONE_NORMAL)
+					low_kmem_size += z->present_pages;
+				total_size += z->present_pages;
+			}
+		}
+	}
+	if (!low_kmem_size ||  /* there are no DMA area. */
+	    low_kmem_size > total_size/2) /* DMA/DMA32 is big. */
+		return ZONELIST_ORDER_NODE;
+	/*
+	 * look into each node's config.
+  	 * If there is a node whose DMA/DMA32 memory is very big area on
+ 	 * local memory, NODE_ORDER may be suitable.
+         */
+	average_size = total_size / (num_online_nodes() + 1);
+	for_each_online_node(nid) {
+		low_kmem_size = 0;
+		total_size = 0;
+		for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+			z = &NODE_DATA(nid)->node_zones[zone_type];
+			if (populated_zone(z)) {
+				if (zone_type < ZONE_NORMAL)
+					low_kmem_size += z->present_pages;
+				total_size += z->present_pages;
+			}
+		}
+		if (low_kmem_size &&
+		    total_size > average_size && /* ignore small node */
+		    low_kmem_size > total_size * 70/100)
+			return ZONELIST_ORDER_NODE;
+	}
+	return ZONELIST_ORDER_ZONE;
+}
+
+static void set_zonelist_order(void)
+{
+	if (user_zonelist_order == ZONELIST_ORDER_DEFAULT)
+		current_zonelist_order = default_zonelist_order();
+	else
+		current_zonelist_order = user_zonelist_order;
+}
+
+static void build_zonelists(pg_data_t *pgdat)
+{
+	int j, node, load;
+	enum zone_type i;
 	nodemask_t used_mask;
+	int local_node, prev_node;
+	struct zonelist *zonelist;
+	int order = current_zonelist_order;
 
 	/* initialize zonelists */
 	for (i = 0; i < MAX_NR_ZONES; i++) {
@@ -1723,6 +1932,11 @@ static void __meminit build_zonelists(pg
 	load = num_online_nodes();
 	prev_node = local_node;
 	nodes_clear(used_mask);
+
+	memset(node_load, 0, sizeof(node_load));
+	memset(node_order, 0, sizeof(node_order));
+	j = 0;
+
 	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
 		int distance = node_distance(local_node, node);
 
@@ -1738,23 +1952,25 @@ static void __meminit build_zonelists(pg
 		 * So adding penalty to the first node in same
 		 * distance group to make it round-robin.
 		 */
-
 		if (distance != node_distance(local_node, prev_node))
-			node_load[node] += load;
+			node_load[node] = load;
+
 		prev_node = node;
 		load--;
-		for (i = 0; i < MAX_NR_ZONES; i++) {
-			zonelist = pgdat->node_zonelists + i;
-			for (j = 0; zonelist->zones[j] != NULL; j++);
+		if (order == ZONELIST_ORDER_NODE)
+			build_zonelists_in_node_order(pgdat, node);
+		else
+			node_order[j++] = node;	/* remember order */
+	}
 
-	 		j = build_zonelists_node(NODE_DATA(node), zonelist, j, i);
-			zonelist->zones[j] = NULL;
-		}
+	if (order == ZONELIST_ORDER_ZONE) {
+		/* calculate node order -- i.e., DMA last! */
+		build_zonelists_in_zone_order(pgdat, j);
 	}
 }
 
 /* Construct the zonelist performance cache - see further mmzone.h */
-static void __meminit build_zonelist_cache(pg_data_t *pgdat)
+static void build_zonelist_cache(pg_data_t *pgdat)
 {
 	int i;
 
@@ -1771,9 +1987,15 @@ static void __meminit build_zonelist_cac
 	}
 }
 
+
 #else	/* CONFIG_NUMA */
 
-static void __meminit build_zonelists(pg_data_t *pgdat)
+static void set_zonelist_order(void)
+{
+	current_zonelist_order = ZONELIST_ORDER_ZONE;
+}
+
+static void build_zonelists(pg_data_t *pgdat)
 {
 	int node, local_node;
 	enum zone_type i,j;
@@ -1809,7 +2031,7 @@ static void __meminit build_zonelists(pg
 }
 
 /* non-NUMA variant of zonelist performance cache - just NULL zlcache_ptr */
-static void __meminit build_zonelist_cache(pg_data_t *pgdat)
+static void build_zonelist_cache(pg_data_t *pgdat)
 {
 	int i;
 
@@ -1820,7 +2042,7 @@ static void __meminit build_zonelist_cac
 #endif	/* CONFIG_NUMA */
 
 /* return values int ....just for stop_machine_run() */
-static int __meminit __build_all_zonelists(void *dummy)
+static int __build_all_zonelists(void *dummy)
 {
 	int nid;
 
@@ -1831,8 +2053,10 @@ static int __meminit __build_all_zonelis
 	return 0;
 }
 
-void __meminit build_all_zonelists(void)
+void build_all_zonelists(void)
 {
+	set_zonelist_order();
+
 	if (system_state == SYSTEM_BOOTING) {
 		__build_all_zonelists(NULL);
 		cpuset_init_current_mems_allowed();
@@ -1843,8 +2067,13 @@ void __meminit build_all_zonelists(void)
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
-	printk("Built %i zonelists.  Total pages: %ld\n",
-			num_online_nodes(), vm_total_pages);
+	printk("Built %i zonelists in %s order.  Total pages: %ld\n",
+			num_online_nodes(),
+			zonelist_order_name[current_zonelist_order],
+			vm_total_pages);
+#ifdef CONFIG_NUMA
+	printk("Policy zone: %s\n", zone_names[policy_zone]);
+#endif
 }
 
 /*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
