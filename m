From: akpm@linux-foundation.org
Subject: [merged] dmaengine-dmatest-correct-thread_count-while-using-multiple-thread-per-channel.patch removed from -mm tree
Date: Fri, 24 Jul 2009 13:39:42 -0700
Message-ID: <200907242039.n6OKdgFj009456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943AbZGXUkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 16:40:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, dan.j.williams@intel.com, haavard.skinnemoen@atmel.com, maciej.sosnowski@intel.com, mm-commits@vger.kernel.org


The patch titled
     dmaengine: dmatest: correct thread_count while using multiple thread per channel
has been removed from the -mm tree.  Its filename was
     dmaengine-dmatest-correct-thread_count-while-using-multiple-thread-per-channel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmaengine: dmatest: correct thread_count while using multiple thread per channel
From: Nicolas Ferre <nicolas.ferre@atmel.com>

It seems that thread_count is not properly calculated in dmatest.  In fact
the thread count number that is returned from dmatest_add_threads() is not
correctly added to the thread_count and thus not properly printed.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/dma/dmatest.c~dmaengine-dmatest-correct-thread_count-while-using-multiple-thread-per-channel drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmaengine-dmatest-correct-thread_count-while-using-multiple-thread-per-channel
+++ a/drivers/dma/dmatest.c
@@ -495,11 +495,11 @@ static int dmatest_add_channel(struct dm
 
 	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
 		cnt = dmatest_add_threads(dtc, DMA_MEMCPY);
-		thread_count += cnt > 0 ?: 0;
+		thread_count += cnt > 0 ? cnt : 0;
 	}
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
 		cnt = dmatest_add_threads(dtc, DMA_XOR);
-		thread_count += cnt > 0 ?: 0;
+		thread_count += cnt > 0 ? cnt : 0;
 	}
 
 	pr_info("dmatest: Started %u threads using %s\n",
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch

