From: akpm@linux-foundation.org
Subject: - i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:58:27 -0700
Message-ID: <200710180858.l9I8wRH0003238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933690AbXJRI7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:59:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, shannon.nelson@intel.com, mm-commits@vger.kernel.org


The patch titled
     i-oat-add-completion-callback-for-async_tx-interface-use-fix
has been removed from the -mm tree.  Its filename was
     i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch

This patch was dropped because it was folded into i-oat-add-completion-callback-for-async_tx-interface-use.patch

------------------------------------------------------
Subject: i-oat-add-completion-callback-for-async_tx-interface-use-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dma.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/dma/ioat_dma.c~i-oat-add-completion-callback-for-async_tx-interface-use-fix drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-add-completion-callback-for-async_tx-interface-use-fix
+++ a/drivers/dma/ioat_dma.c
@@ -654,11 +654,10 @@ static void ioat_dma_start_null_desc(str
  */
 #define IOAT_TEST_SIZE 2000
 
-static dma_async_tx_callback ioat_dma_test_callback(void *dma_async_param)
+static void ioat_dma_test_callback(void *dma_async_param)
 {
-	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(0x%04llx)\n",
-		(u64)dma_async_param);
-	return 0;
+	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(0x%p)\n",
+			dma_async_param);
 }
 
 /**
@@ -715,7 +714,7 @@ static int ioat_dma_self_test(struct ioa
 	addr = dma_map_single(dma_chan->device->dev, dest, IOAT_TEST_SIZE,
 			DMA_FROM_DEVICE);
 	ioat_set_dest(addr, tx, 0);
-	tx->callback = (void *)ioat_dma_test_callback;
+	tx->callback = ioat_dma_test_callback;
 	tx->callback_param = (void *)0x8086;
 	cookie = ioat_tx_submit(tx);
 	if (cookie < 0) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
stop-using-dma_xxbit_mask.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-add-file-handle-to-getattr-operation.patch
sparse-pointer-use-of-zero-as-null.patch
i-oat-tighten-descriptor-setup-performance.patch
i-oat-add-completion-callback-for-async_tx-interface-use.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch
