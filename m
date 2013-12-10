From: akpm@linux-foundation.org
Subject: + arm-move-arm_dma_limit-to-setup_dma_zone.patch added to -mm
 tree
Date: Tue, 10 Dec 2013 14:48:43 -0800
Message-ID: <52a79a4b.x17AMI6k67waG4F1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3LJWsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 17:48:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, av1474@comtv.ru, murzin.v@gmail.com

Subject: + arm-move-arm_dma_limit-to-setup_dma_zone.patch added to -mm tree
To: murzin.v@gmail.com,av1474@comtv.ru
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 14:48:43 -0800


The patch titled
     Subject: arm: move arm_dma_limit to setup_dma_zone
has been added to the -mm tree.  Its filename is
     arm-move-arm_dma_limit-to-setup_dma_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-move-arm_dma_limit-to-setup_dma_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-move-arm_dma_limit-to-setup_dma_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -208,7 +208,6 @@ EXPORT_SYMBOL(arm_dma_zone_size);
  * allocations.  This must be the smallest DMA mask in the system,
  * so a successful GFP_DMA allocation will always satisfy this.
  */
-phys_addr_t arm_dma_limit;
 unsigned long arm_dma_pfn_limit;
 
 static void __init arm_adjust_dma_zone(unsigned long *size, unsigned long *hole,
@@ -227,6 +226,8 @@ static void __init arm_adjust_dma_zone(u
 void __init setup_dma_zone(const struct machine_desc *mdesc)
 {
 #ifdef CONFIG_ZONE_DMA
+	phys_addr_t arm_dma_limit;
+
 	if (mdesc->dma_zone_size) {
 		arm_dma_zone_size = mdesc->dma_zone_size;
 		arm_dma_limit = PHYS_OFFSET + arm_dma_zone_size - 1;
@@ -381,7 +382,8 @@ void __init arm_memblock_init(struct mem
 	 * reserve memory for DMA contigouos allocations,
 	 * must come from DMA area inside low memory
 	 */
-	dma_contiguous_reserve(min(arm_dma_limit, arm_lowmem_limit));
+	dma_contiguous_reserve(min((phys_addr_t)arm_dma_pfn_limit << PAGE_SHIFT,
+				   arm_lowmem_limit));
 
 	arm_memblock_steal_permitted = false;
 	memblock_allow_resize();
diff -puN arch/arm/mm/mm.h~arm-move-arm_dma_limit-to-setup_dma_zone arch/arm/mm/mm.h
--- a/arch/arm/mm/mm.h~arm-move-arm_dma_limit-to-setup_dma_zone
+++ a/arch/arm/mm/mm.h
@@ -80,10 +80,8 @@ extern __init void add_static_vm_early(s
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

arm-move-arm_dma_limit-to-setup_dma_zone.patch
mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch
mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage-fix.patch
mm-hwpoison-add-to-hwpoison_inject.patch

