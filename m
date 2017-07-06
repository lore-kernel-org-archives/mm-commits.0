From: akpm@linux-foundation.org
Subject: [patch 107/108] mm, memory_hotplug: drop
 CONFIG_MOVABLE_NODE
Date: Thu, 06 Jul 2017 15:41:02 -0700
Message-ID: <20170706224102.OmbQiO4UM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752707AbdGFWlD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:41:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, daniel.kiper@oracle.com, imammedo@redhat.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, slaoub@gmail.com, torvalds@linux-foundation.org, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: drop CONFIG_MOVABLE_NODE

20b2f52b73fe ("numa: add CONFIG_MOVABLE_NODE for movable-dedicated node")
has introduced CONFIG_MOVABLE_NODE without a good explanation on why it is
actually useful.  It makes a lot of sense to make movable node semantic
opt in but we already have that because the feature has to be explicitly
enabled on the kernel command line.  A config option on top only makes the
configuration space larger without a good reason.  It also adds an
additional ifdefery that pollutes the code.  Just drop the config option
and make it de-facto always enabled.  This shouldn't introduce any change
to the semantic.

Link: http://lkml.kernel.org/r/20170529114141.536-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Kani Toshimitsu <toshi.kani@hpe.com>
Cc: Chen Yucong <slaoub@gmail.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    7 ++-
 drivers/base/node.c                             |    4 --
 include/linux/memblock.h                        |   18 ---------
 include/linux/nodemask.h                        |    4 --
 mm/Kconfig                                      |   26 --------------
 mm/memblock.c                                   |    2 -
 mm/memory_hotplug.c                             |    4 --
 mm/page_alloc.c                                 |    2 -
 8 files changed, 5 insertions(+), 62 deletions(-)

diff -puN Documentation/admin-guide/kernel-parameters.txt~mm-memory_hotplug-drop-config_movable_node Documentation/admin-guide/kernel-parameters.txt
--- a/Documentation/admin-guide/kernel-parameters.txt~mm-memory_hotplug-drop-config_movable_node
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2303,8 +2303,11 @@
 			that the amount of memory usable for all allocations
 			is not too small.
 
-	movable_node	[KNL] Boot-time switch to enable the effects
-			of CONFIG_MOVABLE_NODE=y. See mm/Kconfig for details.
+	movable_node	[KNL] Boot-time switch to make hotplugable memory
+			NUMA nodes to be movable. This means that the memory
+			of such nodes will be usable only for movable
+			allocations which rules out almost all kernel
+			allocations. Use with caution!
 
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
diff -puN drivers/base/node.c~mm-memory_hotplug-drop-config_movable_node drivers/base/node.c
--- a/drivers/base/node.c~mm-memory_hotplug-drop-config_movable_node
+++ a/drivers/base/node.c
@@ -639,9 +639,7 @@ static struct node_attr node_state_attr[
 #ifdef CONFIG_HIGHMEM
 	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
-#ifdef CONFIG_MOVABLE_NODE
 	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
-#endif
 	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 };
 
@@ -652,9 +650,7 @@ static struct attribute *node_state_attr
 #ifdef CONFIG_HIGHMEM
 	&node_state_attr[N_HIGH_MEMORY].attr.attr,
 #endif
-#ifdef CONFIG_MOVABLE_NODE
 	&node_state_attr[N_MEMORY].attr.attr,
-#endif
 	&node_state_attr[N_CPU].attr.attr,
 	NULL
 };
diff -puN include/linux/memblock.h~mm-memory_hotplug-drop-config_movable_node include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memory_hotplug-drop-config_movable_node
+++ a/include/linux/memblock.h
@@ -57,10 +57,8 @@ struct memblock {
 
 extern struct memblock memblock;
 extern int memblock_debug;
-#ifdef CONFIG_MOVABLE_NODE
 /* If movable_node boot option specified */
 extern bool movable_node_enabled;
-#endif /* CONFIG_MOVABLE_NODE */
 
 #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
 #define __init_memblock __meminit
@@ -169,7 +167,6 @@ void __next_reserved_mem_region(u64 *idx
 	     i != (u64)ULLONG_MAX;					\
 	     __next_reserved_mem_region(&i, p_start, p_end))
 
-#ifdef CONFIG_MOVABLE_NODE
 static inline bool memblock_is_hotpluggable(struct memblock_region *m)
 {
 	return m->flags & MEMBLOCK_HOTPLUG;
@@ -179,16 +176,6 @@ static inline bool __init_memblock movab
 {
 	return movable_node_enabled;
 }
-#else
-static inline bool memblock_is_hotpluggable(struct memblock_region *m)
-{
-	return false;
-}
-static inline bool movable_node_is_enabled(void)
-{
-	return false;
-}
-#endif
 
 static inline bool memblock_is_mirror(struct memblock_region *m)
 {
@@ -296,7 +283,6 @@ phys_addr_t memblock_alloc_try_nid(phys_
 
 phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align);
 
-#ifdef CONFIG_MOVABLE_NODE
 /*
  * Set the allocation direction to bottom-up or top-down.
  */
@@ -314,10 +300,6 @@ static inline bool memblock_bottom_up(vo
 {
 	return memblock.bottom_up;
 }
-#else
-static inline void __init memblock_set_bottom_up(bool enable) {}
-static inline bool memblock_bottom_up(void) { return false; }
-#endif
 
 /* Flags for memblock_alloc_base() amd __memblock_alloc_base() */
 #define MEMBLOCK_ALLOC_ANYWHERE	(~(phys_addr_t)0)
diff -puN include/linux/nodemask.h~mm-memory_hotplug-drop-config_movable_node include/linux/nodemask.h
--- a/include/linux/nodemask.h~mm-memory_hotplug-drop-config_movable_node
+++ a/include/linux/nodemask.h
@@ -387,11 +387,7 @@ enum node_states {
 #else
 	N_HIGH_MEMORY = N_NORMAL_MEMORY,
 #endif
-#ifdef CONFIG_MOVABLE_NODE
 	N_MEMORY,		/* The node has memory(regular, high, movable) */
-#else
-	N_MEMORY = N_HIGH_MEMORY,
-#endif
 	N_CPU,		/* The node has one or more cpus */
 	NR_NODE_STATES
 };
diff -puN mm/Kconfig~mm-memory_hotplug-drop-config_movable_node mm/Kconfig
--- a/mm/Kconfig~mm-memory_hotplug-drop-config_movable_node
+++ a/mm/Kconfig
@@ -149,32 +149,6 @@ config NO_BOOTMEM
 config MEMORY_ISOLATION
 	bool
 
-config MOVABLE_NODE
-	bool "Enable to assign a node which has only movable memory"
-	depends on HAVE_MEMBLOCK
-	depends on NO_BOOTMEM
-	depends on X86_64 || OF_EARLY_FLATTREE || MEMORY_HOTPLUG
-	depends on NUMA
-	default n
-	help
-	  Allow a node to have only movable memory.  Pages used by the kernel,
-	  such as direct mapping pages cannot be migrated.  So the corresponding
-	  memory device cannot be hotplugged.  This option allows the following
-	  two things:
-	  - When the system is booting, node full of hotpluggable memory can
-	  be arranged to have only movable memory so that the whole node can
-	  be hot-removed. (need movable_node boot option specified).
-	  - After the system is up, the option allows users to online all the
-	  memory of a node as movable memory so that the whole node can be
-	  hot-removed.
-
-	  Users who don't use the memory hotplug feature are fine with this
-	  option on since they don't specify movable_node boot option or they
-	  don't online memory as movable.
-
-	  Say Y here if you want to hotplug a whole node.
-	  Say N here if you want kernel to use memory on all nodes evenly.
-
 #
 # Only be set on architectures that have completely implemented memory hotplug
 # feature. If you are not sure, don't touch it.
diff -puN mm/memblock.c~mm-memory_hotplug-drop-config_movable_node mm/memblock.c
--- a/mm/memblock.c~mm-memory_hotplug-drop-config_movable_node
+++ a/mm/memblock.c
@@ -54,9 +54,7 @@ struct memblock memblock __initdata_memb
 };
 
 int memblock_debug __initdata_memblock;
-#ifdef CONFIG_MOVABLE_NODE
 bool movable_node_enabled __initdata_memblock = false;
-#endif
 static bool system_has_some_mirror __initdata_memblock = false;
 static int memblock_can_resize __initdata_memblock;
 static int memblock_memory_in_slab __initdata_memblock = 0;
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-drop-config_movable_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-config_movable_node
+++ a/mm/memory_hotplug.c
@@ -1572,11 +1572,7 @@ check_pages_isolated(unsigned long start
 
 static int __init cmdline_parse_movable_node(char *p)
 {
-#ifdef CONFIG_MOVABLE_NODE
 	movable_node_enabled = true;
-#else
-	pr_warn("movable_node option not supported\n");
-#endif
 	return 0;
 }
 early_param("movable_node", cmdline_parse_movable_node);
diff -puN mm/page_alloc.c~mm-memory_hotplug-drop-config_movable_node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-drop-config_movable_node
+++ a/mm/page_alloc.c
@@ -113,9 +113,7 @@ nodemask_t node_states[NR_NODE_STATES] _
 #ifdef CONFIG_HIGHMEM
 	[N_HIGH_MEMORY] = { { [0] = 1UL } },
 #endif
-#ifdef CONFIG_MOVABLE_NODE
 	[N_MEMORY] = { { [0] = 1UL } },
-#endif
 	[N_CPU] = { { [0] = 1UL } },
 #endif	/* NUMA */
 };
_
