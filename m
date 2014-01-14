From: akpm@linux-foundation.org
Subject: + mm-nobootmem-free_all_bootmem-again.patch added to -mm tree
Date: Mon, 13 Jan 2014 16:34:24 -0800
Message-ID: <52d48610.HFEZCdts+WWQ2+JN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaANAeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 19:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, tangchen@cn.fujitsu.com, schwidefsky@de.ibm.com, santosh.shilimkar@ti.com, qiuxishi@huawei.com, liuj97@gmail.com, grygorii.strashko@ti.com, dhowells@redhat.com, daeseok.youn@gmail.com, phacht@linux.vnet.ibm.com

Subject: + mm-nobootmem-free_all_bootmem-again.patch added to -mm tree
To: phacht@linux.vnet.ibm.com,daeseok.youn@gmail.com,dhowells@redhat.com,grygorii.strashko@ti.com,liuj97@gmail.com,qiuxishi@huawei.com,santosh.shilimkar@ti.com,schwidefsky@de.ibm.com,tangchen@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 16:34:24 -0800


The patch titled
     Subject: mm/nobootmem: free_all_bootmem again
has been added to the -mm tree.  Its filename is
     mm-nobootmem-free_all_bootmem-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nobootmem-free_all_bootmem-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-nobootmem-free_all_bootmem-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: mm/nobootmem: free_all_bootmem again

get_allocated_memblock_reserved_regions_info() should work if it is
compiled in.  Extended the ifdef around
get_allocated_memblock_memory_regions_info() to include
get_allocated_memblock_reserved_regions_info() as well.  Similar changes
in nobootmem.c/free_low_memory_core_early() where the two functions are
called.

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: qiuxishi <qiuxishi@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c  |   17 ++---------------
 mm/nobootmem.c |    4 ++--
 2 files changed, 4 insertions(+), 17 deletions(-)

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
@@ -122,13 +122,13 @@ static unsigned long __init free_low_mem
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+
 	/* Free memblock.reserved array if it was allocated */
 	size = get_allocated_memblock_reserved_regions_info(&start);
 	if (size)
 		count += __free_memory_core(start, start + size);
 
-#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
