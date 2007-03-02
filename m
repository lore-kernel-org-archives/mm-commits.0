From: akpm@linux-foundation.org
Subject: - fix-memory-leak-dma_declare_coherent_memory.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:25 -0800
Message-ID: <200703020507.l2257P0X000874@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42390 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422764AbXCBFHa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, mm-commits@vger.kernel.org


The patch titled
     fix memory leak in dma_declare_coherent_memory()
has been removed from the -mm tree.  Its filename was
     fix-memory-leak-dma_declare_coherent_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix memory leak in dma_declare_coherent_memory()
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

When it goes to free1_out, dev->dma_mem has not been freed.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/drivers/pci/dma.c |    2 +-
 arch/i386/kernel/pci-dma.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/cris/arch-v32/drivers/pci/dma.c~fix-memory-leak-dma_declare_coherent_memory arch/cris/arch-v32/drivers/pci/dma.c
--- a/arch/cris/arch-v32/drivers/pci/dma.c~fix-memory-leak-dma_declare_coherent_memory
+++ a/arch/cris/arch-v32/drivers/pci/dma.c
@@ -111,7 +111,7 @@ int dma_declare_coherent_memory(struct d
 	return DMA_MEMORY_IO;
 
  free1_out:
-	kfree(dev->dma_mem->bitmap);
+	kfree(dev->dma_mem);
  out:
 	return 0;
 }
diff -puN arch/i386/kernel/pci-dma.c~fix-memory-leak-dma_declare_coherent_memory arch/i386/kernel/pci-dma.c
--- a/arch/i386/kernel/pci-dma.c~fix-memory-leak-dma_declare_coherent_memory
+++ a/arch/i386/kernel/pci-dma.c
@@ -110,7 +110,7 @@ int dma_declare_coherent_memory(struct d
 	return DMA_MEMORY_IO;
 
  free1_out:
-	kfree(dev->dma_mem->bitmap);
+	kfree(dev->dma_mem);
  out:
 	if (mem_base)
 		iounmap(mem_base);
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch
git-input.patch
