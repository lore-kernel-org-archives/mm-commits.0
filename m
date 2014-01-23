From: akpm@linux-foundation.org
Subject: [folded-merged] mm-nobootmem-free_all_bootmem-again-fix-fix.patch removed from -mm tree
Date: Thu, 23 Jan 2014 15:20:21 -0800
Message-ID: <52e1a3b5.EY3HWcDwnBpMe8W6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaAWXUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:20:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robinmholt@gmail.com, rientjes@google.com, phacht@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-nobootmem-free_all_bootmem-again-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,phacht@linux.vnet.ibm.com,rientjes@google.com,robinmholt@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:20:21 -0800


The patch titled
     Subject: mm-nobootmem-free_all_bootmem-again-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-nobootmem-free_all_bootmem-again-fix-fix.patch

This patch was dropped because it was folded into mm-nobootmem-free_all_bootmem-again.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-nobootmem-free_all_bootmem-again-fix-fix

cleanup

Cc: David Rientjes <rientjes@google.com>
Cc: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Robin Holt <robinmholt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN mm/nobootmem.c~mm-nobootmem-free_all_bootmem-again-fix-fix mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-free_all_bootmem-again-fix-fix
+++ a/mm/nobootmem.c
@@ -119,24 +119,23 @@ static unsigned long __init free_low_mem
 	phys_addr_t start, end;
 	u64 i;
 
-#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
-	phys_addr_t size;
-#endif
-
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
 #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+	{
+		phys_addr_t size;
 
-	/* Free memblock.reserved array if it was allocated */
-	size = get_allocated_memblock_reserved_regions_info(&start);
-	if (size)
-		count += __free_memory_core(start, start + size);
-
-	/* Free memblock.memory array if it was allocated */
-	size = get_allocated_memblock_memory_regions_info(&start);
-	if (size)
-		count += __free_memory_core(start, start + size);
+		/* Free memblock.reserved array if it was allocated */
+		size = get_allocated_memblock_reserved_regions_info(&start);
+		if (size)
+			count += __free_memory_core(start, start + size);
+
+		/* Free memblock.memory array if it was allocated */
+		size = get_allocated_memblock_memory_regions_info(&start);
+		if (size)
+			count += __free_memory_core(start, start + size);
+	}
 #endif
 
 	return count;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-print-more-details-for-bad_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
numa-add-a-sysctl-for-numa_balancing.patch
mm-nobootmem-free_all_bootmem-again.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch

