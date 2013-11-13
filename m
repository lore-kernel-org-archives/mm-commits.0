From: akpm@linux-foundation.org
Subject: [merged] memblock-factor-out-of-top-down-allocation.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:58 -0800
Message-ID: <5283e362.7B8wPBqrEDoidHDC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMUjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, tangchen@cn.fujitsu.com

Subject: [merged] memblock-factor-out-of-top-down-allocation.patch removed from -mm tree
To: tangchen@cn.fujitsu.com,hannes@cmpxchg.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,kamezawa.hiroyu@jp.fujitsu.com,laijs@cn.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,riel@redhat.com,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:58 -0800


The patch titled
     Subject: mm/memblock.c: factor out of top-down allocation
has been removed from the -mm tree.  Its filename was
     memblock-factor-out-of-top-down-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mm/memblock.c: factor out of top-down allocation

[Problem]

The current Linux cannot migrate pages used by the kernel because of the
kernel direct mapping.  In Linux kernel space, va = pa + PAGE_OFFSET. 
When the pa is changed, we cannot simply update the pagetable and keep the
va unmodified.  So the kernel pages are not migratable.

There are also some other issues will cause the kernel pages not
migratable.  For example, the physical address may be cached somewhere and
will be used.  It is not to update all the caches.

When doing memory hotplug in Linux, we first migrate all the pages in one
memory device somewhere else, and then remove the device.  But if pages
are used by the kernel, they are not migratable.  As a result, memory used
by the kernel cannot be hot-removed.

Modifying the kernel direct mapping mechanism is too difficult to do.  And
it may cause the kernel performance down and unstable.  So we use the
following way to do memory hotplug.


[What we are doing]

In Linux, memory in one numa node is divided into several zones.  One of
the zones is ZONE_MOVABLE, which the kernel won't use.

In order to implement memory hotplug in Linux, we are going to arrange all
hotpluggable memory in ZONE_MOVABLE so that the kernel won't use these
memory.  To do this, we need ACPI's help.

In ACPI, SRAT(System Resource Affinity Table) contains NUMA info.  The
memory affinities in SRAT record every memory range in the system, and
also, flags specifying if the memory range is hotpluggable.  (Please refer
to ACPI spec 5.0 5.2.16)

With the help of SRAT, we have to do the following two things to achieve our
goal:

1. When doing memory hot-add, allow the users arranging hotpluggable as
   ZONE_MOVABLE.
   (This has been done by the MOVABLE_NODE functionality in Linux.)

2. when the system is booting, prevent bootmem allocator from allocating
   hotpluggable memory for the kernel before the memory initialization
   finishes.

The problem 2 is the key problem we are going to solve. But before solving it,
we need some preparation. Please see below.


[Preparation]

Bootloader has to load the kernel image into memory.  And this memory must
be unhotpluggable.  We cannot prevent this anyway.  So in a memory hotplug
system, we can assume any node the kernel resides in is not hotpluggable.

Before SRAT is parsed, we don't know which memory ranges are hotpluggable.
 But memblock has already started to work.  In the current kernel,
memblock allocates the following memory before SRAT is parsed:

setup_arch()
 |->memblock_x86_fill()            /* memblock is ready */
 |......
 |->early_reserve_e820_mpc_new()   /* allocate memory under 1MB */
 |->reserve_real_mode()            /* allocate memory under 1MB */
 |->init_mem_mapping()             /* allocate page tables, about 2MB to map 1GB memory */
 |->dma_contiguous_reserve()       /* specified by user, should be low */
 |->setup_log_buf()                /* specified by user, several mega bytes */
 |->relocate_initrd()              /* could be large, but will be freed after boot, should reorder */
 |->acpi_initrd_override()         /* several mega bytes */
 |->reserve_crashkernel()          /* could be large, should reorder */
 |......
 |->initmem_init()                 /* Parse SRAT */

According to Tejun's advice, before SRAT is parsed, we should try our best
to allocate memory near the kernel image.  Since the whole node the kernel
resides in won't be hotpluggable, and for a modern server, a node may have
at least 16GB memory, allocating several mega bytes memory around the
kernel image won't cross to hotpluggable memory.


[About this patchset]

So this patchset is the preparation for the problem 2 that we want to
solve.  It does the following:

1. Make memblock be able to allocate memory bottom up.
   1) Keep all the memblock APIs' prototype unmodified.
   2) When the direction is bottom up, keep the start address greater than the 
      end of kernel image.

2. Improve init_mem_mapping() to support allocate page tables in
   bottom up direction.

3. Introduce "movable_node" boot option to enable and disable this
   functionality.



This patch (of 6):

Create a new function __memblock_find_range_top_down to factor out of
top-down allocation from memblock_find_in_range_node.  This is a
preparation because we will introduce a new bottom-up allocation mode in
the following patch.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff -puN mm/memblock.c~memblock-factor-out-of-top-down-allocation mm/memblock.c
--- a/mm/memblock.c~memblock-factor-out-of-top-down-allocation
+++ a/mm/memblock.c
@@ -83,33 +83,25 @@ static long __init_memblock memblock_ove
 }
 
 /**
- * memblock_find_in_range_node - find free area in given range and node
+ * __memblock_find_range_top_down - find free area utility, in top-down
  * @start: start of candidate range
  * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
  * @size: size of free area to find
  * @align: alignment of free area to find
  * @nid: nid of the free area to find, %MAX_NUMNODES for any node
  *
- * Find @size free area aligned to @align in the specified range and node.
+ * Utility called from memblock_find_in_range_node(), find free area top-down.
  *
  * RETURNS:
  * Found address on success, %0 on failure.
  */
-phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
-					phys_addr_t end, phys_addr_t size,
-					phys_addr_t align, int nid)
+static phys_addr_t __init_memblock
+__memblock_find_range_top_down(phys_addr_t start, phys_addr_t end,
+			       phys_addr_t size, phys_addr_t align, int nid)
 {
 	phys_addr_t this_start, this_end, cand;
 	u64 i;
 
-	/* pump up @end */
-	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
-		end = memblock.current_limit;
-
-	/* avoid allocating the first page */
-	start = max_t(phys_addr_t, start, PAGE_SIZE);
-	end = max(start, end);
-
 	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
@@ -121,10 +113,39 @@ phys_addr_t __init_memblock memblock_fin
 		if (cand >= this_start)
 			return cand;
 	}
+
 	return 0;
 }
 
 /**
+ * memblock_find_in_range_node - find free area in given range and node
+ * @start: start of candidate range
+ * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
+ * @size: size of free area to find
+ * @align: alignment of free area to find
+ * @nid: nid of the free area to find, %MAX_NUMNODES for any node
+ *
+ * Find @size free area aligned to @align in the specified range and node.
+ *
+ * RETURNS:
+ * Found address on success, %0 on failure.
+ */
+phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
+					phys_addr_t end, phys_addr_t size,
+					phys_addr_t align, int nid)
+{
+	/* pump up @end */
+	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
+		end = memblock.current_limit;
+
+	/* avoid allocating the first page */
+	start = max_t(phys_addr_t, start, PAGE_SIZE);
+	end = max(start, end);
+
+	return __memblock_find_range_top_down(start, end, size, align, nid);
+}
+
+/**
  * memblock_find_in_range - find free area in given range
  * @start: start of candidate range
  * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

