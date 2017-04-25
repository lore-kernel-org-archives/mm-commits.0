From: akpm@linux-foundation.org
Subject: + dmaengine-dmatest-use-offset_in_page-macro.patch added to -mm
 tree
Date: Tue, 25 Apr 2017 14:30:53 -0700
Message-ID: <58ffc00d.yhfUyhmr2AFyKhws%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54556 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176915AbdDYVaz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 17:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, dan.j.williams@intel.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/dma/dmatest.c: use offset_in_page() macro
has been added to the -mm tree.  Its filename is
     dmaengine-dmatest-use-offset_in_page-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dmaengine-dmatest-use-offset_in_page-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dmaengine-dmatest-use-offset_in_page-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
dmaengine-dmatest-use-offset_in_page-macro.patch
dmaengine-mv_xor-use-offset_in_page-macro.patch
dma-debug-use-offset_in_page-macro.patch

