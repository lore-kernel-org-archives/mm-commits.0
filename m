From: akpm@linux-foundation.org
Subject: + dma_declare_coherent_memory-wrong-allocation.patch added to -mm tree
Date: Sat, 21 Apr 2007 00:08:31 -0700
Message-ID: <200704210708.l3L78VOR000899@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933004AbXDUHIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 03:08:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, James.Bottomley@steeleye.com, ak@suse.de, greg@kroah.com, htejun@gmail.com


The patch titled
     i386: dma_declare_coherent_memory(): wrong allocation
has been added to the -mm tree.  Its filename is
     dma_declare_coherent_memory-wrong-allocation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: dma_declare_coherent_memory(): wrong allocation
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

dma_declare_coherent_memory() allocates a bitmap 1 bit per page, it
calculates the bitmap size based on size of long, but allocates bytes...

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>
Cc: Greg KH <greg@kroah.com>
Cc: Andi Kleen <ak@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/pci-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/pci-dma.c~dma_declare_coherent_memory-wrong-allocation arch/i386/kernel/pci-dma.c
--- a/arch/i386/kernel/pci-dma.c~dma_declare_coherent_memory-wrong-allocation
+++ a/arch/i386/kernel/pci-dma.c
@@ -77,7 +77,7 @@ int dma_declare_coherent_memory(struct d
 {
 	void __iomem *mem_base = NULL;
 	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = (pages + 31)/32;
+	int bitmap_size = DIV_ROUND_UP(pages, 8);
 
 	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
 		goto out;
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

git-powerpc.patch
dma_declare_coherent_memory-wrong-allocation.patch
