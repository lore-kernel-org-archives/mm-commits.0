From: akpm@linux-foundation.org
Subject: [failures]
 mm-dmapool-align-to-arch_dma_minalign-in-non-coherent-dma-mode.patch
 removed from -mm tree
Date: Wed, 13 Sep 2017 16:55:58 -0700
Message-ID: <59b9c58e.Wka8g5TKHNCKTQzD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59000 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdIMX4A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 19:56:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenhc@lemote.com, stable@vger.kernel.org, zhangfx@lemote.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: align to ARCH_DMA_MINALIGN in non-coherent DMA mode
has been removed from the -mm tree.  Its filename was
     mm-dmapool-align-to-arch_dma_minalign-in-non-coherent-dma-mode.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Huacai Chen <chenhc@lemote.com>
Subject: mm/dmapool.c: align to ARCH_DMA_MINALIGN in non-coherent DMA mode

In non-coherent DMA mode, kernel uses cache flushing operations to
maintain I/O coherency, so the dmapool objects should be aligned to
ARCH_DMA_MINALIGN.

Link: http://lkml.kernel.org/r/1505294451-21312-1-git-send-email-chenhc@lemote.com
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Cc: Fuxin Zhang <zhangfx@lemote.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/dmapool.c~mm-dmapool-align-to-arch_dma_minalign-in-non-coherent-dma-mode mm/dmapool.c
--- a/mm/dmapool.c~mm-dmapool-align-to-arch_dma_minalign-in-non-coherent-dma-mode
+++ a/mm/dmapool.c
@@ -140,6 +140,9 @@ struct dma_pool *dma_pool_create(const c
 	else if (align & (align - 1))
 		return NULL;
 
+	if (!plat_device_is_coherent(dev))
+		align = max_t(size_t, align, dma_get_cache_alignment());
+
 	if (size == 0)
 		return NULL;
 	else if (size < 4)
_

Patches currently in -mm which might be from chenhc@lemote.com are


