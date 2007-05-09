From: akpm@linux-foundation.org
Subject: - dma_declare_coherent_memory-wrong-allocation.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:00 -0700
Message-ID: <200705090252.l492q0qf009527@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032197AbXEICwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, James.Bottomley@SteelEye.com, ak@suse.de, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     dma_declare_coherent_memory wrong allocation
has been removed from the -mm tree.  Its filename was
     dma_declare_coherent_memory-wrong-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dma_declare_coherent_memory wrong allocation
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

dma_declare_coherent_memory() allocates a bitmap 1 bit per page, it
calculates the bitmap size based on size of long, but allocates bytes... 
Thanks to James Bottomley for clarifications and corrections.

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/drivers/pci/dma.c |    2 +-
 arch/i386/kernel/pci-dma.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/cris/arch-v32/drivers/pci/dma.c~dma_declare_coherent_memory-wrong-allocation arch/cris/arch-v32/drivers/pci/dma.c
--- a/arch/cris/arch-v32/drivers/pci/dma.c~dma_declare_coherent_memory-wrong-allocation
+++ a/arch/cris/arch-v32/drivers/pci/dma.c
@@ -76,7 +76,7 @@ int dma_declare_coherent_memory(struct d
 {
 	void __iomem *mem_base;
 	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = (pages + 31)/32;
+	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
 
 	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
 		goto out;
diff -puN arch/i386/kernel/pci-dma.c~dma_declare_coherent_memory-wrong-allocation arch/i386/kernel/pci-dma.c
--- a/arch/i386/kernel/pci-dma.c~dma_declare_coherent_memory-wrong-allocation
+++ a/arch/i386/kernel/pci-dma.c
@@ -77,7 +77,7 @@ int dma_declare_coherent_memory(struct d
 {
 	void __iomem *mem_base = NULL;
 	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = (pages + 31)/32;
+	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
 
 	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
 		goto out;
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

origin.patch
git-scsi-misc.patch
