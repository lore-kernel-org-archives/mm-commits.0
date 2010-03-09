From: akpm@linux-foundation.org
Subject: - bootmem-avoid-dma32-zone-by-default.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:40:04 -0800
Message-ID: <201003091940.o29Je4Iq000754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512Ab0CITlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:41:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hpa@zytor.com, jslaby@suse.cz, mingo@elte.hu, ralf@linux-mips.org, stable@kernel.org, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     bootmem: avoid DMA32 zone by default
has been removed from the -mm tree.  Its filename was
     bootmem-avoid-dma32-zone-by-default.patch

This patch was dropped because I'm all confused

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: avoid DMA32 zone by default
From: Johannes Weiner <hannes@cmpxchg.org>

Bootmem already tries normal allocations above the DMA zone to reserve it
for users that can not cope with higher addresses.

The same principle applies to the DMA32 zone, which is currently not
spared from normal allocations.

This can lead to exhaustion of this limited amount of address space
through things that can easily live elsewhere, like the mem_map e.g.

Raise bootmem's default goal beyond DMA32 for architectures with this zone
defined.  For now, these are x86 and mips.

I cc'd stable because this affects already released kernels.  But since
this is the first report of DMA32 memory exhaustion through bootmem that I
hear of, you guys might want to skip this patch due to the fragile nature
of early memory management.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@kernel.org>		[See above note]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN include/linux/bootmem.h~bootmem-avoid-dma32-zone-by-default include/linux/bootmem.h
--- a/include/linux/bootmem.h~bootmem-avoid-dma32-zone-by-default
+++ a/include/linux/bootmem.h
@@ -103,20 +103,26 @@ extern void *__alloc_bootmem_low_node(pg
 				      unsigned long align,
 				      unsigned long goal);
 
+#ifdef MAX_DMA32_PFN
+#define BOOTMEM_DEFAULT_GOAL	(MAX_DMA32_PFN << PAGE_SHIFT)
+#else
+#define BOOTMEM_DEFAULT_GOAL	__pa(MAX_DMA_ADDRESS)
+#endif
+
 #define alloc_bootmem(x) \
-	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, SMP_CACHE_BYTES, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_nopanic(x) \
-	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_pages(x) \
-	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, PAGE_SIZE, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_pages_nopanic(x) \
-	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_nopanic(x, PAGE_SIZE, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_node(pgdat, x) \
-	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_pages_node(pgdat, x) \
-	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_pages_node_nopanic(pgdat, x) \
-	__alloc_bootmem_node_nopanic(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node_nopanic(pgdat, x, PAGE_SIZE, BOOTMEM_DEFAULT_GOAL)
 
 #define alloc_bootmem_low(x) \
 	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

bootmem-avoid-dma32-zone-by-default.patch

