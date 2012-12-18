From: akpm@linux-foundation.org
Subject: [merged] dmatest-implement-two-helpers-to-unmap-dma-memory.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:18 -0800
Message-ID: <20121218200319.300A1200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:59211 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:21 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so69474lbc.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, vinod.koul@intel.com, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dmatest: implement two helpers to unmap dma memory
has been removed from the -mm tree.  Its filename was
     dmatest-implement-two-helpers-to-unmap-dma-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: dmatest: implement two helpers to unmap dma memory

The unmap_src() and unmap_dst() will be used later as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff -puN drivers/dma/dmatest.c~dmatest-implement-two-helpers-to-unmap-dma-memory drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmatest-implement-two-helpers-to-unmap-dma-memory
+++ a/drivers/dma/dmatest.c
@@ -228,6 +228,20 @@ static void dmatest_callback(void *arg)
 	wake_up_all(done->wait);
 }
 
+static inline void unmap_src(struct device *dev, dma_addr_t *addr, size_t len,
+			     unsigned int count)
+{
+	while (count--)
+		dma_unmap_single(dev, addr[count], len, DMA_TO_DEVICE);
+}
+
+static inline void unmap_dst(struct device *dev, dma_addr_t *addr, size_t len,
+			     unsigned int count)
+{
+	while (count--)
+		dma_unmap_single(dev, addr[count], len, DMA_BIDIRECTIONAL);
+}
+
 /*
  * This function repeatedly tests DMA transfers of various lengths and
  * offsets for a given operation type until it is told to exit by
@@ -383,13 +397,8 @@ static int dmatest_func(void *data)
 		}
 
 		if (!tx) {
-			for (i = 0; i < src_cnt; i++)
-				dma_unmap_single(dev->dev, dma_srcs[i], len,
-						 DMA_TO_DEVICE);
-			for (i = 0; i < dst_cnt; i++)
-				dma_unmap_single(dev->dev, dma_dsts[i],
-						 test_buf_size,
-						 DMA_BIDIRECTIONAL);
+			unmap_src(dev->dev, dma_srcs, len, src_cnt);
+			unmap_dst(dev->dev, dma_dsts, test_buf_size, dst_cnt);
 			pr_warning("%s: #%u: prep error with src_off=0x%x "
 					"dst_off=0x%x len=0x%x\n",
 					thread_name, total_tests - 1,
@@ -443,9 +452,7 @@ static int dmatest_func(void *data)
 		}
 
 		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
-		for (i = 0; i < dst_cnt; i++)
-			dma_unmap_single(dev->dev, dma_dsts[i], test_buf_size,
-					 DMA_BIDIRECTIONAL);
+		unmap_dst(dev->dev, dma_dsts, test_buf_size, dst_cnt);
 
 		error_count = 0;
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

