From: akpm@linux-foundation.org
Subject: [patch 2/5] dma-mapping.h: preserve unmap info for
 CONFIG_DMA_API_DEBUG
Date: Wed, 28 Sep 2016 15:22:33 -0700
Message-ID: <57ec42a9.kkO3QUzjf2P4Ri64%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933608AbcI1WWe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2016 18:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, andrew.smirnov@gmail.com, borntraeger@de.ibm.com, geliangtang@163.com, jroedel@suse.de, mcgrof@suse.com, robin.murphy@arm.com, thunder.leizhen@huawei.com, will.deacon@arm.com

From: Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: dma-mapping.h: preserve unmap info for CONFIG_DMA_API_DEBUG

When CONFIG_DMA_API_DEBUG is enabled we need to preserve unmapping address
even if "unmap" is a no-op for our architecutre because we need
debug_dma_unmap_page() to correctly cleanup all of the debug bookkeeping. 
Failing to do so results in a false positive warnings about previously
mapped areas never being unmapped.

Link: http://lkml.kernel.org/r/1474387125-3713-1-git-send-email-andrew.smirnov@gmail.com
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Geliang Tang <geliangtang@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/dma-mapping.h~dma-mappingh-preserve-unmap-info-for-config_dma_api_debug include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mappingh-preserve-unmap-info-for-config_dma_api_debug
+++ a/include/linux/dma-mapping.h
@@ -718,7 +718,7 @@ static inline int dma_mmap_wc(struct dev
 #define dma_mmap_writecombine dma_mmap_wc
 #endif
 
-#ifdef CONFIG_NEED_DMA_MAP_STATE
+#if defined(CONFIG_NEED_DMA_MAP_STATE) || defined(CONFIG_DMA_API_DEBUG)
 #define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME
 #define DEFINE_DMA_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME
 #define dma_unmap_addr(PTR, ADDR_NAME)           ((PTR)->ADDR_NAME)
_
