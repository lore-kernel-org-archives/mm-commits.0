From: akpm@linux-foundation.org
Subject: [merged] mm-nobootmem-free_all_bootmem-again.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 10:59:21 -0800
Message-ID: <52e2b809.iekdYW5QBJUAQG+p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, tangchen@cn.fujitsu.com, schwidefsky@de.ibm.com, santosh.shilimkar@ti.com, qiuxishi@huawei.com, liuj97@gmail.com, grygorii.strashko@ti.com, dhowells@redhat.com, daeseok.youn@gmail.com, phacht@linux.vnet.ibm.com

Subject: [merged] mm-nobootmem-free_all_bootmem-again.patch removed from -mm tree
To: phacht@linux.vnet.ibm.com,daeseok.youn@gmail.com,dhowells@redhat.com,grygorii.strashko@ti.com,liuj97@gmail.com,qiuxishi@huawei.com,santosh.shilimkar@ti.com,schwidefsky@de.ibm.com,tangchen@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:21 -0800


The patch titled
     Subject: mm/nobootmem: free_all_bootmem again
has been removed from the -mm tree.  Its filename was
     mm-nobootmem-free_all_bootmem-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: mm/nobootmem: free_all_bootmem again

get_allocated_memblock_reserved_regions_info() should work if it is
compiled in.  Extended the ifdef around
get_allocated_memblock_memory_regions_info() to include
get_allocated_memblock_reserved_regions_info() as well.  Similar changes
in nobootmem.c/free_low_memory_core_early() where the two functions are
called.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: qiuxishi <qiuxishi@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Jiang Liu <liuj97@gmail.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c  |   17 ++---------------
 mm/nobootmem.c |   23 +++++++++++++----------
 2 files changed, 15 insertions(+), 25 deletions(-)

diff -puN mm/memblock.c~mm-nobootmem-free_all_bootmem-again mm/memblock.c
--- a/mm/memblock.c~mm-nobootmem-free_all_bootmem-again
+++ a/mm/memblock.c
@@ -266,33 +266,20 @@ static void __init_memblock memblock_rem
 	}
 }
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+
 phys_addr_t __init_memblock get_allocated_memblock_reserved_regions_info(
 					phys_addr_t *addr)
 {
 	if (memblock.reserved.regions == memblock_reserved_init_regions)
 		return 0;
 
-	/*
-	 * Don't allow nobootmem allocator to free reserved memory regions
-	 * array if
-	 *  - CONFIG_DEBUG_FS is enabled;
-	 *  - CONFIG_ARCH_DISCARD_MEMBLOCK is not enabled;
-	 *  - reserved memory regions array have been resized during boot.
-	 * Otherwise debug_fs entry "sys/kernel/debug/memblock/reserved"
-	 * will show garbage instead of state of memory reservations.
-	 */
-	if (IS_ENABLED(CONFIG_DEBUG_FS) &&
-	    !IS_ENABLED(CONFIG_ARCH_DISCARD_MEMBLOCK))
-		return 0;
-
 	*addr = __pa(memblock.reserved.regions);
 
 	return PAGE_ALIGN(sizeof(struct memblock_region) *
 			  memblock.reserved.max);
 }
 
-#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
-
 phys_addr_t __init_memblock get_allocated_memblock_memory_regions_info(
 					phys_addr_t *addr)
 {
diff -puN mm/nobootmem.c~mm-nobootmem-free_all_bootmem-again mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-free_all_bootmem-again
+++ a/mm/nobootmem.c
@@ -116,23 +116,26 @@ static unsigned long __init __free_memor
 static unsigned long __init free_low_memory_core_early(void)
 {
 	unsigned long count = 0;
-	phys_addr_t start, end, size;
+	phys_addr_t start, end;
 	u64 i;
 
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
-	/* Free memblock.reserved array if it was allocated */
-	size = get_allocated_memblock_reserved_regions_info(&start);
-	if (size)
-		count += __free_memory_core(start, start + size);
-
 #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+	{
+		phys_addr_t size;
+
+		/* Free memblock.reserved array if it was allocated */
+		size = get_allocated_memblock_reserved_regions_info(&start);
+		if (size)
+			count += __free_memory_core(start, start + size);
 
-	/* Free memblock.memory array if it was allocated */
-	size = get_allocated_memblock_memory_regions_info(&start);
-	if (size)
-		count += __free_memory_core(start, start + size);
+		/* Free memblock.memory array if it was allocated */
+		size = get_allocated_memblock_memory_regions_info(&start);
+		if (size)
+			count += __free_memory_core(start, start + size);
+	}
 #endif
 
 	return count;
_

Patches currently in -mm which might be from phacht@linux.vnet.ibm.com are

origin.patch

