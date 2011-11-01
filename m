From: akpm@linux-foundation.org
Subject: [merged] memblock-add-memblock_start_of_dram.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:04 -0700
Message-ID: <201111012110.pA1LA45c012243@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15580 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab1KAVKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, davem@davemloft.net, hpa@zytor.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: add memblock_start_of_DRAM()
has been removed from the -mm tree.  Its filename was
     memblock-add-memblock_start_of_dram.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sam Ravnborg <sam@ravnborg.org>
Subject: memblock: add memblock_start_of_DRAM()

SPARC32 require access to the start address.  Add a new helper
memblock_start_of_DRAM() to give access to the address of the first
memblock - which contains the lowest address.

The awkward name was chosen to match the already present
memblock_end_of_DRAM().

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 +
 mm/memblock.c            |    6 ++++++
 2 files changed, 7 insertions(+)

diff -puN include/linux/memblock.h~memblock-add-memblock_start_of_dram include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-add-memblock_start_of_dram
+++ a/include/linux/memblock.h
@@ -80,6 +80,7 @@ extern phys_addr_t __memblock_alloc_base
 					   phys_addr_t align,
 					   phys_addr_t max_addr);
 extern phys_addr_t memblock_phys_mem_size(void);
+extern phys_addr_t memblock_start_of_DRAM(void);
 extern phys_addr_t memblock_end_of_DRAM(void);
 extern void memblock_enforce_memory_limit(phys_addr_t memory_limit);
 extern int memblock_is_memory(phys_addr_t addr);
diff -puN mm/memblock.c~memblock-add-memblock_start_of_dram mm/memblock.c
--- a/mm/memblock.c~memblock-add-memblock_start_of_dram
+++ a/mm/memblock.c
@@ -626,6 +626,12 @@ phys_addr_t __init memblock_phys_mem_siz
 	return memblock.memory_size;
 }
 
+/* lowest address */
+phys_addr_t __init_memblock memblock_start_of_DRAM(void)
+{
+	return memblock.memory.regions[0].base;
+}
+
 phys_addr_t __init_memblock memblock_end_of_DRAM(void)
 {
 	int idx = memblock.memory.cnt - 1;
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
linux-next.patch

