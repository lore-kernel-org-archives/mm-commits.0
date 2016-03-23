From: akpm@linux-foundation.org
Subject: [merged]
 drivers-dma-coherent-use-memremap_wc-for-dma_memory_map.patch removed from
 -mm tree
Date: Wed, 23 Mar 2016 10:42:54 -0700
Message-ID: <56f2d59e.QW2snVvJNuRolY6J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325AbcCWRmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brian.starkey@arm.com, catalin.marinas@arm.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: dma-coherent: use MEMREMAP_WC for DMA_MEMORY_MAP
has been removed from the -mm tree.  Its filename was
     drivers-dma-coherent-use-memremap_wc-for-dma_memory_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Brian Starkey <brian.starkey@arm.com>
Subject: drivers: dma-coherent: use MEMREMAP_WC for DMA_MEMORY_MAP

When the DMA_MEMORY_MAP flag is used, memory which can be accessed
directly should be returned, so use memremap(..., MEMREMAP_WC) to provide
a writecombine mapping.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-coherent.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN drivers/base/dma-coherent.c~drivers-dma-coherent-use-memremap_wc-for-dma_memory_map drivers/base/dma-coherent.c
--- a/drivers/base/dma-coherent.c~drivers-dma-coherent-use-memremap_wc-for-dma_memory_map
+++ a/drivers/base/dma-coherent.c
@@ -2,6 +2,7 @@
  * Coherent per-device memory handling.
  * Borrowed from i386
  */
+#include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -31,7 +32,10 @@ static bool dma_init_coherent_memory(
 	if (!size)
 		goto out;
 
-	mem_base = ioremap(phys_addr, size);
+	if (flags & DMA_MEMORY_MAP)
+		mem_base = memremap(phys_addr, size, MEMREMAP_WC);
+	else
+		mem_base = ioremap(phys_addr, size);
 	if (!mem_base)
 		goto out;
 
@@ -54,8 +58,12 @@ static bool dma_init_coherent_memory(
 
 out:
 	kfree(dma_mem);
-	if (mem_base)
-		iounmap(mem_base);
+	if (mem_base) {
+		if (flags & DMA_MEMORY_MAP)
+			memunmap(mem_base);
+		else
+			iounmap(mem_base);
+	}
 	return false;
 }
 
@@ -63,7 +71,11 @@ static void dma_release_coherent_memory(
 {
 	if (!mem)
 		return;
-	iounmap(mem->virt_base);
+
+	if (mem->flags & DMA_MEMORY_MAP)
+		memunmap(mem->virt_base);
+	else
+		iounmap(mem->virt_base);
 	kfree(mem->bitmap);
 	kfree(mem);
 }
_

Patches currently in -mm which might be from brian.starkey@arm.com are


