From: akpm@linux-foundation.org
Subject: [merged] dmatest-check-for-dma-mapping-error.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:22 -0800
Message-ID: <20121218200323.22F3F200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:65384 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:51 -0500
Received: by mail-la0-f73.google.com with SMTP id d3so63586lah.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, vinod.koul@intel.com, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dmatest: check for dma mapping error
has been removed from the -mm tree.  Its filename was
     dmatest-check-for-dma-mapping-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: dmatest: check for dma mapping error

The kernel emits a warning if CONFIG_DMA_API_DEBUG=y:

[   28.150631] WARNING: at lib/dma-debug.c:933 check_unmap+0x5d6/0x6ac()
[   28.157058] dw_dmac dw_dmac.0: DMA-API: device driver failed to check map error[device address=0x0000000035698305] [size=14365 bytes] [mapped as single]

Fix this by adding the required checking of the dma_map_single() return
value.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff -puN drivers/dma/dmatest.c~dmatest-check-for-dma-mapping-error drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmatest-check-for-dma-mapping-error
+++ a/drivers/dma/dmatest.c
@@ -367,15 +367,35 @@ static int dmatest_func(void *data)
 
 			dma_srcs[i] = dma_map_single(dev->dev, buf, len,
 						     DMA_TO_DEVICE);
+			ret = dma_mapping_error(dev->dev, dma_srcs[i]);
+			if (ret) {
+				unmap_src(dev->dev, dma_srcs, len, i);
+				pr_warn("%s: #%u: mapping error %d with "
+					"src_off=0x%x len=0x%x\n",
+					thread_name, total_tests - 1, ret,
+					src_off, len);
+				failed_tests++;
+				continue;
+			}
 		}
 		/* map with DMA_BIDIRECTIONAL to force writeback/invalidate */
 		for (i = 0; i < dst_cnt; i++) {
 			dma_dsts[i] = dma_map_single(dev->dev, thread->dsts[i],
 						     test_buf_size,
 						     DMA_BIDIRECTIONAL);
+			ret = dma_mapping_error(dev->dev, dma_dsts[i]);
+			if (ret) {
+				unmap_src(dev->dev, dma_srcs, len, src_cnt);
+				unmap_dst(dev->dev, dma_dsts, test_buf_size, i);
+				pr_warn("%s: #%u: mapping error %d with "
+					"dst_off=0x%x len=0x%x\n",
+					thread_name, total_tests - 1, ret,
+					dst_off, test_buf_size);
+				failed_tests++;
+				continue;
+			}
 		}
 
