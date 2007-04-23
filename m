From: akpm@linux-foundation.org
Subject: - cris-arch-v32-fix-dma_declare_coherent_memory-wrong-allocation.patch removed from -mm tree
Date: Sun, 22 Apr 2007 17:07:05 -0700
Message-ID: <200704230007.l3N075J8003837@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964976AbXDWAHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 20:07:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris/arch-v32: fix dma_declare_coherent_memory wrong allocation
has been removed from the -mm tree.  Its filename was
     cris-arch-v32-fix-dma_declare_coherent_memory-wrong-allocation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: cris/arch-v32: fix dma_declare_coherent_memory wrong allocation
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

arch/cris/arch-v32 seems to have copy-pasted the bug from arch/i386 fixed
with an earlier patch - allocate bitmap in bytes, not words.

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/drivers/pci/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/cris/arch-v32/drivers/pci/dma.c~cris-arch-v32-fix-dma_declare_coherent_memory-wrong-allocation arch/cris/arch-v32/drivers/pci/dma.c
--- a/arch/cris/arch-v32/drivers/pci/dma.c~cris-arch-v32-fix-dma_declare_coherent_memory-wrong-allocation
+++ a/arch/cris/arch-v32/drivers/pci/dma.c
@@ -76,7 +76,7 @@ int dma_declare_coherent_memory(struct d
 {
 	void __iomem *mem_base;
 	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = (pages + 31)/32;
+	int bitmap_size = DIV_ROUND_UP(pages, 8);
 
 	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
 		goto out;
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

git-powerpc.patch
cris-arch-v32-fix-dma_declare_coherent_memory-wrong-allocation.patch
