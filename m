From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-free-memblockmemory-in-free_all_bootmem-fix.patch removed from -mm tree
Date: Thu, 23 Jan 2014 15:19:36 -0800
Message-ID: <52e1a388.HehVg96wP3+/9q/K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaAWXTh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, toshi.kani@hp.com, tj@kernel.org, tangchen@cn.fujitsu.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, phacht@linux.vnet.ibm.com

Subject: [folded-merged] mm-free-memblockmemory-in-free_all_bootmem-fix.patch removed from -mm tree
To: phacht@linux.vnet.ibm.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,tangchen@cn.fujitsu.com,tj@kernel.org,toshi.kani@hp.com,wujianguo@huawei.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:19:36 -0800


The patch titled
     Subject: mm-free-memblockmemory-in-free_all_bootmem-fix
has been removed from the -mm tree.  Its filename was
     mm-free-memblockmemory-in-free_all_bootmem-fix.patch

This patch was dropped because it was folded into mm-free-memblockmemory-in-free_all_bootmem.patch

------------------------------------------------------
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: mm-free-memblockmemory-in-free_all_bootmem-fix

Am Wed, 8 Jan 2014 12:08:04 +0800
schrieb Jianguo Wu <wujianguo@huawei.com>:

> For some archs, like arm64, would use memblock.memory after system
> booting, so we can not simply released to the buddy allocator, maybe
> need !defined(CONFIG_ARCH_DISCARD_MEMBLOCK).

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c  |    4 ++++
 mm/nobootmem.c |    3 +++
 2 files changed, 7 insertions(+)

diff -puN mm/memblock.c~mm-free-memblockmemory-in-free_all_bootmem-fix mm/memblock.c
--- a/mm/memblock.c~mm-free-memblockmemory-in-free_all_bootmem-fix
+++ a/mm/memblock.c
@@ -291,6 +291,8 @@ phys_addr_t __init_memblock get_allocate
 			  memblock.reserved.max);
 }
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+
 phys_addr_t __init_memblock get_allocated_memblock_memory_regions_info(
 					phys_addr_t *addr)
 {
@@ -303,6 +305,8 @@ phys_addr_t __init_memblock get_allocate
 			  memblock.memory.max);
 }
 
+#endif
+
 /**
  * memblock_double_array - double the size of the memblock regions array
  * @type: memblock type of the regions array being doubled
diff -puN mm/nobootmem.c~mm-free-memblockmemory-in-free_all_bootmem-fix mm/nobootmem.c
--- a/mm/nobootmem.c~mm-free-memblockmemory-in-free_all_bootmem-fix
+++ a/mm/nobootmem.c
@@ -127,10 +127,13 @@ static unsigned long __init free_low_mem
 	if (size)
 		count += __free_memory_core(start, start + size);
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+
 	/* Free memblock.memory array if it was allocated */
 	size = get_allocated_memblock_memory_regions_info(&start);
 	if (size)
 		count += __free_memory_core(start, start + size);
+#endif
 
 	return count;
 }
_

Patches currently in -mm which might be from phacht@linux.vnet.ibm.com are

mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch
mm-nobootmem-free_all_bootmem-again.patch
mm-nobootmem-free_all_bootmem-again-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch

