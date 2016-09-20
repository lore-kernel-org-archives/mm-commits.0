From: akpm@linux-foundation.org
Subject: + dma-mappingh-preserve-unmap-info-for-config_dma_api_debug.patch added to -mm tree
Date: Tue, 20 Sep 2016 13:39:55 -0700
Message-ID: <57e19e9b.qfioTl8wR0PDHM7N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49529 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751729AbcITUj4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 16:39:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.smirnov@gmail.com, Robin.Murphy@arm.com, borntraeger@de.ibm.com, geliangtang@163.com, jroedel@suse.de, mcgrof@suse.com, thunder.leizhen@huawei.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping.h: preserve unmap info for CONFIG_DMA_API_DEBUG
has been added to the -mm tree.  Its filename is
     dma-mappingh-preserve-unmap-info-for-config_dma_api_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mappingh-preserve-unmap-info-for-config_dma_api_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mappingh-preserve-unmap-info-for-config_dma_api_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: dma-mapping.h: preserve unmap info for CONFIG_DMA_API_DEBUG

When CONFIG_DMA_API_DEBUG is enabled we need to preserve unmapping address
even if "unmap" is a no-op for our architecutre because we need
debug_dma_unmap_page() to correctly cleanup all of the debug bookkeeping. 
Failing to do so results in a false positive warnings about previously
mapped areas never being unmapped.

Link: http://lkml.kernel.org/r/1474387125-3713-1-git-send-email-andrew.smirnov@gmail.com
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Robin Murphy <Robin.Murphy@arm.com>
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

Patches currently in -mm which might be from andrew.smirnov@gmail.com are

dma-mappingh-preserve-unmap-info-for-config_dma_api_debug.patch

