From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-memblock_is_map-region_memory-can-be-boolean.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 11:59:41 -0800
Message-ID: <20180207195941.fVY6o_6SH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754622AbeBGT7m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: memblock_is_map/region_memory can be boolean
has been removed from the -mm tree.  Its filename was
     mm-memblock-memblock_is_map-region_memory-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: mm/memblock: memblock_is_map/region_memory can be boolean

Make memblock_is_map/region_memory return bool due to these two functions
only using either true or false as its return value.

No functional change.

Link: http://lkml.kernel.org/r/1513266622-15860-2-git-send-email-baiyaowei@cmss.chinamobile.com
Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 mm/memblock.c            |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-memblock_is_map-region_memory-can-be-boolean include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-memblock_is_map-region_memory-can-be-boolean
+++ a/include/linux/memblock.h
@@ -332,8 +332,8 @@ void memblock_enforce_memory_limit(phys_
 void memblock_cap_memory_range(phys_addr_t base, phys_addr_t size);
 void memblock_mem_limit_remove_map(phys_addr_t limit);
 bool memblock_is_memory(phys_addr_t addr);
-int memblock_is_map_memory(phys_addr_t addr);
-int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
+bool memblock_is_map_memory(phys_addr_t addr);
+bool memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
 bool memblock_is_reserved(phys_addr_t addr);
 bool memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 
diff -puN mm/memblock.c~mm-memblock-memblock_is_map-region_memory-can-be-boolean mm/memblock.c
--- a/mm/memblock.c~mm-memblock-memblock_is_map-region_memory-can-be-boolean
+++ a/mm/memblock.c
@@ -1654,7 +1654,7 @@ bool __init_memblock memblock_is_memory(
 	return memblock_search(&memblock.memory, addr) != -1;
 }
 
-int __init_memblock memblock_is_map_memory(phys_addr_t addr)
+bool __init_memblock memblock_is_map_memory(phys_addr_t addr)
 {
 	int i = memblock_search(&memblock.memory, addr);
 
@@ -1690,13 +1690,13 @@ int __init_memblock memblock_search_pfn_
  * RETURNS:
  * 0 if false, non-zero if true
  */
-int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
+bool __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
 {
 	int idx = memblock_search(&memblock.memory, base);
 	phys_addr_t end = base + memblock_cap_size(base, &size);
 
 	if (idx == -1)
-		return 0;
+		return false;
 	return (memblock.memory.regions[idx].base +
 		 memblock.memory.regions[idx].size) >= end;
 }
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are


