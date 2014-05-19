From: akpm@linux-foundation.org
Subject: [obsolete] arm-move-arm_dma_limit-to-setup_dma_zone.patch removed from -mm tree
Date: Mon, 19 May 2014 12:51:46 -0700
Message-ID: <537a60d2.HYy3ruVvA9Kt8YYd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaESTvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 15:51:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, av1474@comtv.ru, murzin.v@gmail.com

Subject: [obsolete] arm-move-arm_dma_limit-to-setup_dma_zone.patch removed from -mm tree
To: murzin.v@gmail.com,av1474@comtv.ru,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 12:51:46 -0700


The patch titled
     Subject: arm: move arm_dma_limit to setup_dma_zone
has been removed from the -mm tree.  Its filename was
     arm-move-arm_dma_limit-to-setup_dma_zone.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Vladimir Murzin <murzin.v@gmail.com>
Subject: arm: move arm_dma_limit to setup_dma_zone

Since 4dcfa600 ("ARM: DMA-API: better handing of DMA masks for coherent
allocations") arm_dma_limit_pfn has almost substituted the arm_dma_limit. 
The remaining user is dma_contiguous_reserve().  It is also referenced in
setup_dma_zone() to calculate arm_dma_limit_pfn.

Kill the global arm_dma_limit and equip setup_zone_dma with the local one.

Signed-off-by: Vladimir Murzin <murzin.v@gmail.com>
Reported-by: Vassili Karpov <av1474@comtv.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c |    6 ++++--
 arch/arm/mm/mm.h   |    2 --
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/arm/mm/init.c~arm-move-arm_dma_limit-to-setup_dma_zone arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~arm-move-arm_dma_limit-to-setup_dma_zone
+++ a/arch/arm/mm/init.c
@@ -153,7 +153,6 @@ EXPORT_SYMBOL(arm_dma_zone_size);
  * allocations.  This must be the smallest DMA mask in the system,
  * so a successful GFP_DMA allocation will always satisfy this.
  */
-phys_addr_t arm_dma_limit;
 unsigned long arm_dma_pfn_limit;
 
 static void __init arm_adjust_dma_zone(unsigned long *size, unsigned long *hole,
@@ -172,6 +171,8 @@ static void __init arm_adjust_dma_zone(u
 void __init setup_dma_zone(const struct machine_desc *mdesc)
 {
 #ifdef CONFIG_ZONE_DMA
+	phys_addr_t arm_dma_limit;
+
 	if (mdesc->dma_zone_size) {
 		arm_dma_zone_size = mdesc->dma_zone_size;
 		arm_dma_limit = PHYS_OFFSET + arm_dma_zone_size - 1;
@@ -328,7 +329,8 @@ void __init arm_memblock_init(struct mem
 	 * reserve memory for DMA contigouos allocations,
 	 * must come from DMA area inside low memory
 	 */
-	dma_contiguous_reserve(min(arm_dma_limit, arm_lowmem_limit));
+	dma_contiguous_reserve(min((phys_addr_t)arm_dma_pfn_limit << PAGE_SHIFT,
+				   arm_lowmem_limit));
 
 	arm_memblock_steal_permitted = false;
 	memblock_dump_all();
diff -puN arch/arm/mm/mm.h~arm-move-arm_dma_limit-to-setup_dma_zone arch/arm/mm/mm.h
--- a/arch/arm/mm/mm.h~arm-move-arm_dma_limit-to-setup_dma_zone
+++ a/arch/arm/mm/mm.h
@@ -81,10 +81,8 @@ extern __init void add_static_vm_early(s
 #endif
 
 #ifdef CONFIG_ZONE_DMA
-extern phys_addr_t arm_dma_limit;
 extern unsigned long arm_dma_pfn_limit;
 #else
-#define arm_dma_limit ((phys_addr_t)~0)
 #define arm_dma_pfn_limit (~0ul >> PAGE_SHIFT)
 #endif
 
_

Patches currently in -mm which might be from murzin.v@gmail.com are

origin.patch

