From: akpm@linux-foundation.org
Subject: +
 memblock-make-memblock_set_node-support-different-memblock_type.patch added to -mm tree
Date: Tue, 03 Dec 2013 15:54:42 -0800
Message-ID: <529e6f42.9IZXLBpCNAz09jGl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3LCXyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 18:54:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, rjw@sisk.pl, riel@redhat.com, prarit@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, lwoodman@redhat.com, liwanp@linux.vnet.ibm.com, lenb@kernel.org, laijs@cn.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, imtangchen@gmail.com, hpa@zytor.com, hannes@cmpxchg.org, gong.chen@linux.intel.com, tangchen@cn.fujitsu.com

Subject: + memblock-make-memblock_set_node-support-different-memblock_type.patch added to -mm tree
To: tangchen@cn.fujitsu.com,gong.chen@linux.intel.com,hannes@cmpxchg.org,hpa@zytor.com,imtangchen@gmail.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,laijs@cn.fujitsu.com,lenb@kernel.org,liwanp@linux.vnet.ibm.com,lwoodman@redhat.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,prarit@redhat.com,riel@redhat.com,rjw@sisk.pl,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,vasilis.liaskovitis@profitbricks.com,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 15:54:42 -0800


The patch titled
     Subject: memblock: make memblock_set_node() support different memblock_type
has been added to the -mm tree.  Its filename is
     memblock-make-memblock_set_node-support-different-memblock_type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-make-memblock_set_node-support-different-memblock_type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-make-memblock_set_node-support-different-memblock_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memblock: make memblock_set_node() support different memblock_type

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Chen Tang <imtangchen@gmail.com>
Cc: Gong Chen <gong.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Liu Jiang <jiang.liu@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/mm/init.c      |    3 ++-
 arch/metag/mm/numa.c      |    3 ++-
 arch/microblaze/mm/init.c |    3 ++-
 arch/powerpc/mm/mem.c     |    2 +-
 arch/powerpc/mm/numa.c    |    8 +++++---
 arch/sh/kernel/setup.c    |    4 ++--
 arch/sparc/mm/init_64.c   |    5 +++--
 arch/x86/mm/init_32.c     |    2 +-
 arch/x86/mm/init_64.c     |    2 +-
 arch/x86/mm/numa.c        |    6 ++++--
 include/linux/memblock.h  |    3 ++-
 mm/memblock.c             |    6 +++---
 12 files changed, 28 insertions(+), 19 deletions(-)

diff -puN arch/metag/mm/init.c~memblock-make-memblock_set_node-support-different-memblock_type arch/metag/mm/init.c
--- a/arch/metag/mm/init.c~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/arch/metag/mm/init.c
@@ -204,7 +204,8 @@ static void __init do_init_bootmem(void)
 		start_pfn = memblock_region_memory_base_pfn(reg);
 		end_pfn = memblock_region_memory_end_pfn(reg);
 		memblock_set_node(PFN_PHYS(start_pfn),
-				  PFN_PHYS(end_pfn - start_pfn), 0);
+				  PFN_PHYS(end_pfn - start_pfn),
+				  &memblock.memory, 0);
 	}
 
 	/* All of system RAM sits in node 0 for the non-NUMA case */
diff -puN arch/metag/mm/numa.c~memblock-make-memblock_set_node-support-different-memblock_type arch/metag/mm/numa.c
--- a/arch/metag/mm/numa.c~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/arch/metag/mm/numa.c
@@ -42,7 +42,8 @@ void __init setup_bootmem_node(int nid,
 	memblock_add(start, end - start);
 
 	memblock_set_node(PFN_PHYS(start_pfn),
-			  PFN_PHYS(end_pfn - start_pfn), nid);
+			  PFN_PHYS(end_pfn - start_pfn),
+			  &memblock.memory, nid);
 
 	/* Node-local pgdat */
 	pgdat_paddr = memblock_alloc_base(sizeof(struct pglist_data),
diff -puN arch/microblaze/mm/init.c~memblock-make-memblock_set_node-support-different-memblock_type arch/microblaze/mm/init.c
--- a/arch/microblaze/mm/init.c~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/arch/microblaze/mm/init.c
@@ -192,7 +192,8 @@ void __init setup_memory(void)
 		start_pfn = memblock_region_memory_base_pfn(reg);
 		end_pfn = memblock_region_memory_end_pfn(reg);
 		memblock_set_node(start_pfn << PAGE_SHIFT,
-					(end_pfn - start_pfn) << PAGE_SHIFT, 0);
+				  (end_pfn - start_pfn) << PAGE_SHIFT,
+				  &memblock.memory, 0);
 	}
 
 	/* free bootmem is whole main memory */
diff -puN arch/powerpc/mm/mem.c~memblock-make-memblock_set_node-support-different-memblock_type arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/arch/powerpc/mm/mem.c
@@ -209,7 +209,7 @@ void __init do_init_bootmem(void)
 	/* Place all memblock_regions in the same node and merge contiguous
 	 * memblock_regions
 	 */
-	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, &memblock_memory, 0);
 
 	/* Add all physical memory to the bootmem map, mark each area
 	 * present.
diff -puN arch/powerpc/mm/numa.c~memblock-make-memblock_set_node-support-different-memblock_type arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/arch/powerpc/mm/numa.c
@@ -670,7 +670,8 @@ static void __init parse_drconf_memory(s
 			node_set_online(nid);
 			sz = numa_enforce_memory_limit(base, size);
 			if (sz)
-				memblock_set_node(base, sz, nid);
+				memblock_set_node(base, sz,
+						  &memblock.memory, nid);
 		} while (--ranges);
 	}
 }
@@ -760,7 +761,7 @@ new_range:
 				continue;
 		}
 
-		memblock_set_node(start, size, nid);
+		memblock_set_node(start, size, &memblock.memory, nid);
 
 		if (--ranges)
 			goto new_range;
@@ -797,7 +798,8 @@ static void __init setup_nonnuma(void)
 
 		fake_numa_create_new_node(end_pfn, &nid);
 		memblock_set_node(PFN_PHYS(start_pfn),
-				  PFN_PHYS(end_pfn - start_pfn), nid);
+				  PFN_PHYS(end_pfn - start_pfn),
+				  &memblock.memory, nid);
 		node_set_online(nid);
 	}
 }
diff -puN arch/sh/kernel/setup.c~memblock-make-memblock_set_node-support-different-memblock_type arch/sh/kernel/setup.c
--- a/arch/sh/kernel/setup.c~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/arch/sh/kernel/setup.c
@@ -230,8 +230,8 @@ void __init __add_active_range(unsigned
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
 
-	memblock_set_node(PFN_PHYS(start_pfn),
-			  PFN_PHYS(end_pfn - start_pfn), nid);
+	memblock_set_node(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
+			  &memblock.memory, nid);
 }
 
 void __init __weak plat_early_device_setup(void)
diff -puN arch/sparc/mm/init_64.c~memblock-make-memblock_set_node-support-different-memblock_type arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/arch/sparc/mm/init_64.c
@@ -1021,7 +1021,8 @@ static void __init add_node_ranges(void)
 				"start[%lx] end[%lx]\n",
 				nid, start, this_end);
 
-			memblock_set_node(start, this_end - start, nid);
+			memblock_set_node(start, this_end - start,
+					  &memblock.memory, nid);
 			start = this_end;
 		}
 	}
@@ -1325,7 +1326,7 @@ static void __init bootmem_init_nonnuma(
 	       (top_of_ram - total_ram) >> 20);
 
 	init_node_masks_nonnuma();
-	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, &memblock.memory, 0);
 	allocate_node_data(0);
 	node_set_online(0);
 }
diff -puN arch/x86/mm/init_32.c~memblock-make-memblock_set_node-support-different-memblock_type arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/arch/x86/mm/init_32.c
@@ -665,7 +665,7 @@ void __init initmem_init(void)
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
 
-	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, &memblock.memory, 0);
 	sparse_memory_present_with_active_regions(0);
 
 #ifdef CONFIG_FLATMEM
diff -puN arch/x86/mm/init_64.c~memblock-make-memblock_set_node-support-different-memblock_type arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/arch/x86/mm/init_64.c
@@ -643,7 +643,7 @@ kernel_physical_mapping_init(unsigned lo
 #ifndef CONFIG_NUMA
 void __init initmem_init(void)
 {
-	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, &memblock.memory, 0);
 }
 #endif
 
diff -puN arch/x86/mm/numa.c~memblock-make-memblock_set_node-support-different-memblock_type arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/arch/x86/mm/numa.c
@@ -492,7 +492,8 @@ static int __init numa_register_memblks(
 
 	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *mb = &mi->blk[i];
-		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
+		memblock_set_node(mb->start, mb->end - mb->start,
+				  &memblock.memory, mb->nid);
 	}
 
 	/*
@@ -566,7 +567,8 @@ static int __init numa_init(int (*init_f
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
-	WARN_ON(memblock_set_node(0, ULLONG_MAX, MAX_NUMNODES));
+	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.memory,
+				  MAX_NUMNODES));
 	numa_reset_distance();
 
 	ret = init_func();
diff -puN include/linux/memblock.h~memblock-make-memblock_set_node-support-different-memblock_type include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/include/linux/memblock.h
@@ -140,7 +140,8 @@ static inline void memblock_clear_region
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
+int memblock_set_node(phys_addr_t base, phys_addr_t size,
+		      struct memblock_type *type, int nid);
 
 static inline void memblock_set_region_node(struct memblock_region *r, int nid)
 {
diff -puN mm/memblock.c~memblock-make-memblock_set_node-support-different-memblock_type mm/memblock.c
--- a/mm/memblock.c~memblock-make-memblock_set_node-support-different-memblock_type
+++ a/mm/memblock.c
@@ -910,18 +910,18 @@ void __init_memblock __next_mem_pfn_rang
  * memblock_set_node - set node ID on memblock regions
  * @base: base of area to set node ID for
  * @size: size of area to set node ID for
+ * @type: memblock type to set node ID for
  * @nid: node ID to set
  *
- * Set the nid of memblock memory regions in [@base,@base+@size) to @nid.
+ * Set the nid of memblock @type regions in [@base,@base+@size) to @nid.
  * Regions which cross the area boundaries are split as necessary.
  *
  * RETURNS:
  * 0 on success, -errno on failure.
  */
 int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
-				      int nid)
+				      struct memblock_type *type, int nid)
 {
-	struct memblock_type *type = &memblock.memory;
 	int start_rgn, end_rgn;
 	int i, ret;
 
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch

