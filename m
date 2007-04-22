From: akpm@linux-foundation.org
Subject: + cris-arch-v32-fix-dma_declare_coherent_memory-wrong-allocation.patch added to -mm tree
Date: Sat, 21 Apr 2007 19:57:16 -0700
Message-ID: <200704220257.l3M2vGnj018248@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbXDVC5X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 22:57:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, starvik@axis.com


The patch titled
     cris/arch-v32: fix dma_declare_coherent_memory wrong allocation
has been added to the -mm tree.  Its filename is
     cris-arch-v32-fix-dma_declare_coherent_memory-wrong-allocation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
dma_declare_coherent_memory-wrong-allocation.patch
cris-arch-v32-fix-dma_declare_coherent_memory-wrong-allocation.patch
