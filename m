From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-dma-coherent-add-initialization-from-device-tree-fix.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 14:08:05 -0700
Message-ID: <543c3f35.ZDIhJUM4xItVaMkt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaJMVIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 17:08:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, grant.likely@linaro.org, iamjoonsoo.kim@lge.com, joshc@codeaurora.org, kyungmin.park@samsung.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-dma-coherent-add-initialization-from-device-tree-fix
has been removed from the -mm tree.  Its filename was
     drivers-dma-coherent-add-initialization-from-device-tree-fix.patch

This patch was dropped because it was folded into drivers-dma-coherent-add-initialization-from-device-tree.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-dma-coherent-add-initialization-from-device-tree-fix

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-coherent.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/base/dma-coherent.c~drivers-dma-coherent-add-initialization-from-device-tree-fix drivers/base/dma-coherent.c
--- a/drivers/base/dma-coherent.c~drivers-dma-coherent-add-initialization-from-device-tree-fix
+++ a/drivers/base/dma-coherent.c
@@ -40,7 +40,7 @@ static int dma_init_coherent_memory(phys
 		goto out;
 	dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
 	if (!dma_mem->bitmap)
-		goto free1_out;
+		goto out;
 
 	dma_mem->virt_base = mem_base;
 	dma_mem->device_base = device_addr;
@@ -56,9 +56,8 @@ static int dma_init_coherent_memory(phys
 
 	return DMA_MEMORY_IO;
 
- free1_out:
+out:
 	kfree(dma_mem);
- out:
 	if (mem_base)
 		iounmap(mem_base);
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch

