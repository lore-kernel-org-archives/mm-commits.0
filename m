From: akpm@linux-foundation.org
Subject: + fix-memory-leak-dma_declare_coherent_memory.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:54:29 -0800
Message-ID: <200702272054.l1RKsXwR028241@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51518 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbXB0Uyh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:54:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp


The patch titled
     fix memory leak in dma_declare_coherent_memory()
has been added to the -mm tree.  Its filename is
     fix-memory-leak-dma_declare_coherent_memory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-input.patch
git-mips.patch
fix-memory-leak-dma_declare_coherent_memory.patch
