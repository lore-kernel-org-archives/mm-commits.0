From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 14:08:07 -0700
Message-ID: <543c3f37.tSqFElRQHrb3RYXz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaJMVIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 17:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, grant.likely@linaro.org, iamjoonsoo.kim@lge.com, joshc@codeaurora.org, kyungmin.park@samsung.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-dma-coherent-add-initialization-from-device-tree-fix-fix
has been removed from the -mm tree.  Its filename was
     drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch

This patch was dropped because it was folded into drivers-dma-coherent-add-initialization-from-device-tree.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-dma-coherent-add-initialization-from-device-tree-fix-fix

use more appropriate printk facility levels

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

 drivers/base/dma-coherent.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/dma-coherent.c~drivers-dma-coherent-add-initialization-from-device-tree-fix-fix drivers/base/dma-coherent.c
--- a/drivers/base/dma-coherent.c~drivers-dma-coherent-add-initialization-from-device-tree-fix-fix
+++ a/drivers/base/dma-coherent.c
@@ -283,7 +283,7 @@ static int rmem_dma_device_init(struct r
 	    dma_init_coherent_memory(rmem->base, rmem->base, rmem->size,
 				     DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE,
 				     &mem) != DMA_MEMORY_MAP) {
-		pr_info("Reserved memory: failed to init DMA memory pool at %pa, size %ld MiB\n",
+		pr_err("Reserved memory: failed to init DMA memory pool at %pa, size %ld MiB\n",
 			&rmem->base, (unsigned long)rmem->size / SZ_1M);
 		return -ENODEV;
 	}
@@ -312,7 +312,7 @@ static int __init rmem_dma_setup(struct
 
 #ifdef CONFIG_ARM
 	if (!of_get_flat_dt_prop(node, "no-map", NULL)) {
-		pr_info("Reserved memory: regions without no-map are not yet supported\n");
+		pr_err("Reserved memory: regions without no-map are not yet supported\n");
 		return -EINVAL;
 	}
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch

