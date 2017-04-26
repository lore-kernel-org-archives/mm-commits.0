From: akpm@linux-foundation.org
Subject: [merged] dmaengine-dmatest-use-offset_in_page-macro.patch
 removed from -mm tree
Date: Wed, 26 Apr 2017 14:45:04 -0700
Message-ID: <20170426214504.c1-ZGbv04%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56690 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031020AbdDZVpG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Apr 2017 17:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, geliangtang@gmail.com, mm-commits@vger.kernel.org, vinod.koul@intel.com


The patch titled
     Subject: drivers/dma/dmatest.c: use offset_in_page() macro
has been removed from the -mm tree.  Its filename was
     dmaengine-dmatest-use-offset_in_page-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: drivers/dma/dmatest.c: use offset_in_page() macro

Use offset_in_page() macro instead of open-coding.

Link: http://lkml.kernel.org/r/5b8a96f45462de15e1713b8022b0e72d4f2231f6.1492757182.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/dma/dmatest.c~dmaengine-dmatest-use-offset_in_page-macro drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmaengine-dmatest-use-offset_in_page-macro
+++ a/drivers/dma/dmatest.c
@@ -585,7 +585,7 @@ static int dmatest_func(void *data)
 		for (i = 0; i < src_cnt; i++) {
 			void *buf = thread->srcs[i];
 			struct page *pg = virt_to_page(buf);
-			unsigned pg_off = (unsigned long) buf & ~PAGE_MASK;
+			unsigned long pg_off = offset_in_page(buf);
 
 			um->addr[i] = dma_map_page(dev->dev, pg, pg_off,
 						   um->len, DMA_TO_DEVICE);
@@ -605,7 +605,7 @@ static int dmatest_func(void *data)
 		for (i = 0; i < dst_cnt; i++) {
 			void *buf = thread->dsts[i];
 			struct page *pg = virt_to_page(buf);
-			unsigned pg_off = (unsigned long) buf & ~PAGE_MASK;
+			unsigned long pg_off = offset_in_page(buf);
 
 			dsts[i] = dma_map_page(dev->dev, pg, pg_off, um->len,
 					       DMA_BIDIRECTIONAL);
_

Patches currently in -mm which might be from geliangtang@gmail.com are

fs-ocfs2-cluster-use-setup_timer.patch
fs-ocfs2-cluster-use-offset_in_page-macro.patch
writeback-use-setup_deferrable_timer.patch

