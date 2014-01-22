From: akpm@linux-foundation.org
Subject: [merged]
 memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:13:10 -0800
Message-ID: <52e02656.BlKqq0YCpU/RJ/FF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaAVUNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, rjw@sisk.pl, riel@redhat.com, prarit@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, lwoodman@redhat.com, liwanp@linux.vnet.ibm.com, lenb@kernel.org, laijs@cn.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, imtangchen@gmail.com, hpa@zytor.com, hannes@cmpxchg.org, gong.chen@linux.intel.com, tangchen@cn.fujitsu.com

Subject: [merged] memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch removed from -mm tree
To: tangchen@cn.fujitsu.com,gong.chen@linux.intel.com,hannes@cmpxchg.org,hpa@zytor.com,imtangchen@gmail.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,laijs@cn.fujitsu.com,lenb@kernel.org,liwanp@linux.vnet.ibm.com,lwoodman@redhat.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,prarit@redhat.com,riel@redhat.com,rjw@sisk.pl,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,vasilis.liaskovitis@profitbricks.com,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:10 -0800


The patch titled
     Subject: memblock, mem_hotplug: make memblock skip hotpluggable regions if needed
has been removed from the -mm tree.  Its filename was
     memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memblock, mem_hotplug: make memblock skip hotpluggable regions if needed

Linux kernel cannot migrate pages used by the kernel.  As a result,
hotpluggable memory used by the kernel won't be able to be hot-removed. 
To solve this problem, the basic idea is to prevent memblock from
allocating hotpluggable memory for the kernel at early time, and arrange
all hotpluggable memory in ACPI SRAT(System Resource Affinity Table) as
ZONE_MOVABLE when initializing zones.

In the previous patches, we have marked hotpluggable memory regions with
MEMBLOCK_HOTPLUG flag in memblock.memory.

In this patch, we make memblock skip these hotpluggable memory regions in
the default top-down allocation function if movable_node boot option is
specified.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
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

 include/linux/memblock.h |   24 ++++++++++++++++++++++++
 mm/memblock.c            |   12 ++++++++++++
 mm/memory_hotplug.c      |    1 +
 3 files changed, 37 insertions(+)

diff -puN include/linux/memblock.h~memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed
+++ a/include/linux/memblock.h
@@ -47,6 +47,10 @@ struct memblock {
 
 extern struct memblock memblock;
 extern int memblock_debug;
+#ifdef CONFIG_MOVABLE_NODE
+/* If movable_node boot option specified */
+extern bool movable_node_enabled;
+#endif /* CONFIG_MOVABLE_NODE */
 
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
@@ -65,6 +69,26 @@ int memblock_reserve(phys_addr_t base, p
 void memblock_trim_memory(phys_addr_t align);
 int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
+#ifdef CONFIG_MOVABLE_NODE
+static inline bool memblock_is_hotpluggable(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_HOTPLUG;
+}
+
+static inline bool movable_node_is_enabled(void)
+{
+	return movable_node_enabled;
+}
+#else
+static inline bool memblock_is_hotpluggable(struct memblock_region *m)
+{
+	return false;
+}
+static inline bool movable_node_is_enabled(void)
+{
+	return false;
+}
+#endif
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
diff -puN mm/memblock.c~memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed mm/memblock.c
--- a/mm/memblock.c~memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed
+++ a/mm/memblock.c
@@ -39,6 +39,9 @@ struct memblock memblock __initdata_memb
 };
 
 int memblock_debug __initdata_memblock;
+#ifdef CONFIG_MOVABLE_NODE
+bool movable_node_enabled __initdata_memblock = false;
+#endif
 static int memblock_can_resize __initdata_memblock;
 static int memblock_memory_in_slab __initdata_memblock = 0;
 static int memblock_reserved_in_slab __initdata_memblock = 0;
@@ -820,6 +823,11 @@ void __init_memblock __next_free_mem_ran
  * @out_nid: ptr to int for nid of the range, can be %NULL
  *
  * Reverse of __next_free_mem_range().
+ *
+ * Linux kernel cannot migrate pages used by itself. Memory hotplug users won't
+ * be able to hot-remove hotpluggable memory used by the kernel. So this
+ * function skip hotpluggable regions if needed when allocating memory for the
+ * kernel.
  */
 void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
 					   phys_addr_t *out_start,
@@ -844,6 +852,10 @@ void __init_memblock __next_free_mem_ran
 		if (nid != MAX_NUMNODES && nid != memblock_get_region_node(m))
 			continue;
 
+		/* skip hotpluggable memory regions if needed */
+		if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
+			continue;
+
 		/* scan areas before each reservation for intersection */
 		for ( ; ri >= 0; ri--) {
 			struct memblock_region *r = &rsv->regions[ri];
diff -puN mm/memory_hotplug.c~memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed
+++ a/mm/memory_hotplug.c
@@ -1446,6 +1446,7 @@ static int __init cmdline_parse_movable_
 	 * the kernel away from hotpluggable memory.
 	 */
 	memblock_set_bottom_up(true);
+	movable_node_enabled = true;
 #else
 	pr_warn("movable_node option not supported\n");
 #endif
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch
mm-free-memblockmemory-in-free_all_bootmem-fix.patch
mm-nobootmem-free_all_bootmem-again.patch
mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug.patch
linux-next.patch

