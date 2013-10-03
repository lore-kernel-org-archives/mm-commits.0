From: akpm@linux-foundation.org
Subject: [to-be-updated]
 memblock-introduce-bottom-up-allocation-mode.patch removed from -mm tree
Date: Thu, 03 Oct 2013 11:59:16 -0700
Message-ID: <524dbe84.7HKTkphIu9X8Fx4L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab3JCS7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 14:59:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, rjw@sisk.pl, riel@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, lenb@kernel.org, laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, tangchen@cn.fujitsu.com

Subject: [to-be-updated] memblock-introduce-bottom-up-allocation-mode.patch removed from -mm tree
To: tangchen@cn.fujitsu.com,hannes@cmpxchg.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,kamezawa.hiroyu@jp.fujitsu.com,laijs@cn.fujitsu.com,lenb@kernel.org,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,riel@redhat.com,rjw@sisk.pl,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 11:59:16 -0700


The patch titled
     Subject: mm/memblock.c: introduce bottom-up allocation mode
has been removed from the -mm tree.  Its filename was
     memblock-introduce-bottom-up-allocation-mode.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mm/memblock.c: introduce bottom-up allocation mode

The Linux kernel cannot migrate pages used by the kernel.  As a result,
kernel pages cannot be hot-removed.  So we cannot allocate hotpluggable
memory for the kernel.

ACPI SRAT (System Resource Affinity Table) contains the memory hotplug
info.  But before SRAT is parsed, memblock has already started to allocate
memory for the kernel.  So we need to prevent memblock from doing this.

In a memory hotplug system, any numa node the kernel resides in should be
unhotpluggable.  And for a modern server, each node could have at least
16GB memory.  So memory around the kernel image is highly likely
unhotpluggable.

So the basic idea is: Allocate memory from the end of the kernel image and
to the higher memory.  Since memory allocation before SRAT is parsed won't
be too much, it could highly likely be in the same node with kernel image.

The current memblock can only allocate memory top-down.  So this patch
introduces a new bottom-up allocation mode to allocate memory bottom-up. 
And later when we use this allocation direction to allocate memory, we
will limit the start address above the kernel.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |   16 +++++++
 mm/memblock.c            |   81 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 2 deletions(-)

diff -puN include/linux/memblock.h~memblock-introduce-bottom-up-allocation-mode include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-introduce-bottom-up-allocation-mode
+++ a/include/linux/memblock.h
@@ -35,6 +35,7 @@ struct memblock_type {
 };
 
 struct memblock {
+	bool bottom_up;  /* is bottom up direction? */
 	phys_addr_t current_limit;
 	struct memblock_type memory;
 	struct memblock_type reserved;
@@ -148,6 +149,21 @@ phys_addr_t memblock_alloc_try_nid(phys_
 
 phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align);
 
+#ifdef CONFIG_MOVABLE_NODE
+static inline void memblock_set_bottom_up(bool enable)
+{
+	memblock.bottom_up = enable;
+}
+
+static inline bool memblock_bottom_up(void)
+{
+	return memblock.bottom_up;
+}
+#else
+static inline void memblock_set_bottom_up(bool enable) {}
+static inline bool memblock_bottom_up(void) { return false; }
+#endif
+
 /* Flags for memblock_alloc_base() amd __memblock_alloc_base() */
 #define MEMBLOCK_ALLOC_ANYWHERE	(~(phys_addr_t)0)
 #define MEMBLOCK_ALLOC_ACCESSIBLE	0
diff -puN mm/memblock.c~memblock-introduce-bottom-up-allocation-mode mm/memblock.c
--- a/mm/memblock.c~memblock-introduce-bottom-up-allocation-mode
+++ a/mm/memblock.c
@@ -20,6 +20,8 @@
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 
+#include <asm-generic/sections.h>
+
 static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
 static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
 
@@ -32,6 +34,7 @@ struct memblock memblock __initdata_memb
 	.reserved.cnt		= 1,	/* empty dummy entry */
 	.reserved.max		= INIT_MEMBLOCK_REGIONS,
 
+	.bottom_up		= false,
 	.current_limit		= MEMBLOCK_ALLOC_ANYWHERE,
 };
 
@@ -83,6 +86,38 @@ static long __init_memblock memblock_ove
 }
 
 /**
+ * __memblock_find_range - find free area utility
+ * @start: start of candidate range
+ * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
+ * @size: size of free area to find
+ * @align: alignment of free area to find
+ * @nid: nid of the free area to find, %MAX_NUMNODES for any node
+ *
+ * Utility called from memblock_find_in_range_node(), find free area bottom-up.
+ *
+ * RETURNS:
+ * Found address on success, 0 on failure.
+ */
+static phys_addr_t __init_memblock
+__memblock_find_range(phys_addr_t start, phys_addr_t end, phys_addr_t size,
+		      phys_addr_t align, int nid)
+{
+	phys_addr_t this_start, this_end, cand;
+	u64 i;
+
+	for_each_free_mem_range(i, nid, &this_start, &this_end, NULL) {
+		this_start = clamp(this_start, start, end);
+		this_end = clamp(this_end, start, end);
+
+		cand = round_up(this_start, align);
+		if (cand < this_end && this_end - cand >= size)
+			return cand;
+	}
+
+	return 0;
+}
+
+/**
  * __memblock_find_range_rev - find free area utility, in reverse order
  * @start: start of candidate range
  * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
@@ -93,7 +128,7 @@ static long __init_memblock memblock_ove
  * Utility called from memblock_find_in_range_node(), find free area top-down.
  *
  * RETURNS:
- * Found address on success, %0 on failure.
+ * Found address on success, 0 on failure.
  */
 static phys_addr_t __init_memblock
 __memblock_find_range_rev(phys_addr_t start, phys_addr_t end,
@@ -127,13 +162,24 @@ __memblock_find_range_rev(phys_addr_t st
  *
  * Find @size free area aligned to @align in the specified range and node.
  *
+ * When allocation direction is bottom-up, the @start should be greater
+ * than the end of the kernel image. Otherwise, it will be trimmed. The
+ * reason is that we want the bottom-up allocation just near the kernel
+ * image so it is highly likely that the allocated memory and the kernel
+ * will reside in the same node.
+ *
+ * If bottom-up allocation failed, will try to allocate memory top-down.
+ *
  * RETURNS:
- * Found address on success, %0 on failure.
+ * Found address on success, 0 on failure.
  */
 phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 					phys_addr_t end, phys_addr_t size,
 					phys_addr_t align, int nid)
 {
+	int ret;
+	phys_addr_t kernel_end;
+
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
@@ -141,6 +187,37 @@ phys_addr_t __init_memblock memblock_fin
 	/* avoid allocating the first page */
 	start = max_t(phys_addr_t, start, PAGE_SIZE);
 	end = max(start, end);
+	kernel_end = __pa_symbol(_end);
+
+	/*
+	 * try bottom-up allocation only when bottom-up mode
+	 * is set and @end is above the kernel image.
+	 */
+	if (memblock_bottom_up() && end > kernel_end) {
+		phys_addr_t bottom_up_start;
+
+		/* make sure we will allocate above the kernel */
+		bottom_up_start = max(start, kernel_end);
+
+		/* ok, try bottom-up allocation first */
+		ret = __memblock_find_range(bottom_up_start, end,
+					    size, align, nid);
+		if (ret)
+			return ret;
+
+		/*
+		 * we always limit bottom-up allocation above the kernel,
+		 * but top-down allocation doesn't have the limit, so
+		 * retrying top-down allocation may succeed when bottom-up
+		 * allocation failed.
+		 *
+		 * bottom-up allocation is expected to be fail very rarely,
+		 * so we use WARN_ONCE() here to see the stack trace if
+		 * fail happens.
+		 */
+		WARN_ONCE(1, "memblock: Failed to allocate memory in bottom up "
+			"direction. Now try top down direction.\n");
+	}
 
 	return __memblock_find_range_rev(start, end, size, align, nid);
 }
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movablenode-boot-option.patch
mem-hotplug-introduce-movablenode-boot-option-fix.patch
memblock-factor-out-of-top-down-allocation-hack.patch
linux-next.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch

