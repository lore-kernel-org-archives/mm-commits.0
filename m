From: akpm@linux-foundation.org
Subject: [merged] mm-use-alloc_bootmem_node_nopanic-on-really-needed-path.patch removed from -mm tree
Date: Thu, 12 May 2011 11:54:42 -0700
Message-ID: <201105121847.p4CIlFHY025932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710Ab1ELSrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 14:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, hpa@linux.intel.com, mingo@elte.hu, stable@kernel.org, stefan@the2masters.de, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     mm: use alloc_bootmem_node_nopanic() on really needed path
has been removed from the -mm tree.  Its filename was
     mm-use-alloc_bootmem_node_nopanic-on-really-needed-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use alloc_bootmem_node_nopanic() on really needed path
From: Yinghai Lu <yinghai@kernel.org>

Stefan found nobootmem does not work on his system that has only 8M of
RAM.  This causes an early panic:

 (Red Hat 4.6.0-6) (GCC) ) #5 Thu May 5 21:49:09 CEST 2011
BIOS-provided physical RAM map:
 BIOS-88: 0000000000000000 - 000000000009f000 (usable)
 BIOS-88: 0000000000100000 - 0000000000840000 (usable)
bootconsole [earlyser0] enabled
Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
DMI not present or invalid.
last_pfn = 0x840 max_arch_pfn = 0x100000
init_memory_mapping: 0000000000000000-0000000000840000
8MB LOWMEM available.
  mapped low ram: 0 - 00840000
  low ram: 0 - 00840000
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000001 -> 0x0000009f
    0: 0x00000100 -> 0x00000840
BUG: Int 6: CR2 (null)
     EDI c034663c  ESI (null)  EBP c0329f38  ESP c0329ef4
     EBX c0346380  EDX 00000006  ECX ffffffff  EAX fffffff4
     err (null)  EIP c0353191   CS c0320060  flg 00010082
Stack: (null) c030c533 000007cd (null) c030c533 00000001 (null) (null)
       00000003 0000083f 00000018 00000002 00000002 c0329f6c c03534d6 (null)
       (null) 00000100 00000840 (null) c0329f64 00000001 00001000 (null)
Pid: 0, comm: swapper Not tainted 2.6.36 #5
Call Trace:
 [<c02e3707>] ? 0xc02e3707
 [<c035e6e5>] 0xc035e6e5
 [<c0353191>] ? 0xc0353191
 [<c03534d6>] 0xc03534d6
 [<c034f1cd>] 0xc034f1cd
 [<c034a824>] 0xc034a824
 [<c03513cb>] ? 0xc03513cb
 [<c0349432>] 0xc0349432
 [<c0349066>] 0xc0349066


It turns out that we should ignore the low limit of 16M.

Use alloc_bootmem_node_nopanic() in this case.

[akpm@linux-foundation.org: less mess]
Signed-off-by: Yinghai LU <yinghai@kernel.org>
Reported-by: Stefan Hellermann <stefan@the2masters.de>
Tested-by: Stefan Hellermann <stefan@the2masters.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>		[2.6.34+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    2 ++
 mm/page_alloc.c         |    7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/bootmem.h~mm-use-alloc_bootmem_node_nopanic-on-really-needed-path include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-use-alloc_bootmem_node_nopanic-on-really-needed-path
+++ a/include/linux/bootmem.h
@@ -111,6 +111,8 @@ extern void *__alloc_bootmem_low_node(pg
 	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_node_nopanic(pgdat, x) \
+	__alloc_bootmem_node_nopanic(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node_nopanic(pgdat, x) \
diff -puN mm/page_alloc.c~mm-use-alloc_bootmem_node_nopanic-on-really-needed-path mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-alloc_bootmem_node_nopanic-on-really-needed-path
+++ a/mm/page_alloc.c
@@ -3564,7 +3564,7 @@ int zone_wait_table_init(struct zone *zo
 
 	if (!slab_is_available()) {
 		zone->wait_table = (wait_queue_head_t *)
-			alloc_bootmem_node(pgdat, alloc_size);
+			alloc_bootmem_node_nopanic(pgdat, alloc_size);
 	} else {
 		/*
 		 * This case means that a zone whose size was 0 gets new memory
@@ -4141,7 +4141,8 @@ static void __init setup_usemap(struct p
 	unsigned long usemapsize = usemap_size(zonesize);
 	zone->pageblock_flags = NULL;
 	if (usemapsize)
-		zone->pageblock_flags = alloc_bootmem_node(pgdat, usemapsize);
+		zone->pageblock_flags = alloc_bootmem_node_nopanic(pgdat,
+								   usemapsize);
 }
 #else
 static inline void setup_usemap(struct pglist_data *pgdat,
@@ -4307,7 +4308,7 @@ static void __init_refok alloc_node_mem_
 		size =  (end - start) * sizeof(struct page);
 		map = alloc_remap(pgdat->node_id, size);
 		if (!map)
-			map = alloc_bootmem_node(pgdat, size);
+			map = alloc_bootmem_node_nopanic(pgdat, size);
 		pgdat->node_mem_map = map + (pgdat->node_start_pfn - start);
 	}
 #ifndef CONFIG_NEED_MULTIPLE_NODES
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch
pci-dmar-update-dmar-units-devices-list-during-hotplug.patch
memblock-nobootmem-allow-alloc_bootmem-to-take-0-as-low-limit.patch
memblock-nobootmem-remove-code-for-alloc_bootmem_node_high.patch
memblock-add-error-return-when-config_have_memblock-is-not-set.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

