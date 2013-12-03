From: akpm@linux-foundation.org
Subject: +
 memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch added to -mm tree
Date: Tue, 03 Dec 2013 15:54:39 -0800
Message-ID: <529e6f3f.97gnti1QuGcklYjp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3LCXyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 18:54:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, rjw@sisk.pl, riel@redhat.com, prarit@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, lwoodman@redhat.com, liwanp@linux.vnet.ibm.com, lenb@kernel.org, laijs@cn.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, imtangchen@gmail.com, hpa@zytor.com, hannes@cmpxchg.org, gong.chen@linux.intel.com, tangchen@cn.fujitsu.com

Subject: + memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch added to -mm tree
To: tangchen@cn.fujitsu.com,gong.chen@linux.intel.com,hannes@cmpxchg.org,hpa@zytor.com,imtangchen@gmail.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,laijs@cn.fujitsu.com,lenb@kernel.org,liwanp@linux.vnet.ibm.com,lwoodman@redhat.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,prarit@redhat.com,riel@redhat.com,rjw@sisk.pl,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,vasilis.liaskovitis@profitbricks.com,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 15:54:39 -0800


The patch titled
     Subject: memblock, mem_hotplug: introduce MEMBLOCK_HOTPLUG flag to mark hotpluggable regions
has been added to the -mm tree.  Its filename is
     memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch

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
Subject: memblock, mem_hotplug: introduce MEMBLOCK_HOTPLUG flag to mark hotpluggable regions

In find_hotpluggable_memory, once we find out a memory region which is
hotpluggable, we want to mark them in memblock.memory.  So that we could
control memblock allocator not to allocte hotpluggable memory for the
kernel later.

To achieve this goal, we introduce MEMBLOCK_HOTPLUG flag to indicate the
hotpluggable memory regions in memblock and a function
memblock_mark_hotplug() to mark hotpluggable memory if we find one.

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

 include/linux/memblock.h |   17 ++++++++++++
 mm/memblock.c            |   52 +++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff -puN include/linux/memblock.h~memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions
+++ a/include/linux/memblock.h
@@ -19,6 +19,9 @@
 
 #define INIT_MEMBLOCK_REGIONS	128
 
+/* Definition of memblock flags. */
+#define MEMBLOCK_HOTPLUG	0x1	/* hotpluggable region */
+
 struct memblock_region {
 	phys_addr_t base;
 	phys_addr_t size;
@@ -60,6 +63,8 @@ int memblock_remove(phys_addr_t base, ph
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
 void memblock_trim_memory(phys_addr_t align);
+int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
+int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
@@ -122,6 +127,18 @@ void __next_free_mem_range_rev(u64 *idx,
 	     i != (u64)ULLONG_MAX;					\
 	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid))
 
+static inline void memblock_set_region_flags(struct memblock_region *r,
+					     unsigned long flags)
+{
+	r->flags |= flags;
+}
+
+static inline void memblock_clear_region_flags(struct memblock_region *r,
+					       unsigned long flags)
+{
+	r->flags &= ~flags;
+}
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
 
diff -puN mm/memblock.c~memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions mm/memblock.c
--- a/mm/memblock.c~memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions
+++ a/mm/memblock.c
@@ -683,6 +683,58 @@ int __init_memblock memblock_reserve(phy
 }
 
 /**
+ * memblock_mark_hotplug - Mark hotpluggable memory with flag MEMBLOCK_HOTPLUG.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * This function isolates region [@base, @base + @size), and mark it with flag
+ * MEMBLOCK_HOTPLUG.
+ *
+ * Return 0 on succees, -errno on failure.
+ */
+int __init_memblock memblock_mark_hotplug(phys_addr_t base, phys_addr_t size)
+{
+	struct memblock_type *type = &memblock.memory;
+	int i, ret, start_rgn, end_rgn;
+
+	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
+	if (ret)
+		return ret;
+
+	for (i = start_rgn; i < end_rgn; i++)
+		memblock_set_region_flags(&type->regions[i], MEMBLOCK_HOTPLUG);
+
+	memblock_merge_regions(type);
+	return 0;
+}
+
+/**
+ * memblock_clear_hotplug - Clear flag MEMBLOCK_HOTPLUG for a specified region.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * This function isolates region [@base, @base + @size), and clear flag
+ * MEMBLOCK_HOTPLUG for the isolated regions.
+ *
+ * Return 0 on succees, -errno on failure.
+ */
+int __init_memblock memblock_clear_hotplug(phys_addr_t base, phys_addr_t size)
+{
+	struct memblock_type *type = &memblock.memory;
+	int i, ret, start_rgn, end_rgn;
+
+	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
+	if (ret)
+		return ret;
+
+	for (i = start_rgn; i < end_rgn; i++)
+		memblock_clear_region_flags(&type->regions[i], MEMBLOCK_HOTPLUG);
+
+	memblock_merge_regions(type);
+	return 0;
+}
+
+/**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
  * @nid: node selector, %MAX_NUMNODES for all nodes
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

