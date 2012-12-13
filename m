From: akpm@linux-foundation.org
Subject: + dmatest-implement-two-helpers-to-unmap-dma-memory.patch added to -mm tree
Date: Thu, 13 Dec 2012 15:34:56 -0800
Message-ID: <20121213233458.34F60100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:39081 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2LMXe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Dec 2012 18:34:59 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so20397qaq.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Dec 2012 15:34:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, vinod.koul@intel.com, viresh.kumar@linaro.org


The patch titled
     Subject: dmatest: implement two helpers to unmap dma memory
has been added to the -mm tree.  Its filename is
     dmatest-implement-two-helpers-to-unmap-dma-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -235,6 +235,20 @@ static unsigned int min_odd(unsigned int
 	return val % 2 ? val : val - 1;
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
@@ -393,13 +407,8 @@ static int dmatest_func(void *data)
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
@@ -453,9 +462,7 @@ static int dmatest_func(void *data)
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
dmatest-implement-two-helpers-to-unmap-dma-memory.patch
dmatest-check-for-dma-mapping-error.patch
string-introduce-helper-to-get-base-file-name-from-given-path.patch
lib-dynamic_debug-use-kbasename.patch
mm-use-kbasename.patch
procfs-use-kbasename.patch
procfs-use-kbasename-fix.patch
trace-use-kbasename.patch
drivers-of-fdtc-re-use-kernels-kbasename.patch

