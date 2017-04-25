From: akpm@linux-foundation.org
Subject: + dmaengine-mv_xor-use-offset_in_page-macro.patch added to -mm
 tree
Date: Tue, 25 Apr 2017 14:30:56 -0700
Message-ID: <58ffc010.JX/WCHBwCfgu1+Tv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54560 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176915AbdDYVa5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 17:30:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, dan.j.williams@intel.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/dma/mv_xor.c: use offset_in_page() macro
has been added to the -mm tree.  Its filename is
     dmaengine-mv_xor-use-offset_in_page-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dmaengine-mv_xor-use-offset_in_page-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dmaengine-mv_xor-use-offset_in_page-macro.patch

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
Subject: drivers/dma/mv_xor.c: use offset_in_page() macro

Use offset_in_page() macro instead of open-coding.

Link: http://lkml.kernel.org/r/517217f3a0e0c85f745054ad1f00d5de90ea9650.1492757182.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/mv_xor.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/dma/mv_xor.c~dmaengine-mv_xor-use-offset_in_page-macro drivers/dma/mv_xor.c
--- a/drivers/dma/mv_xor.c~dmaengine-mv_xor-use-offset_in_page-macro
+++ a/drivers/dma/mv_xor.c
@@ -960,7 +960,7 @@ static int mv_chan_memcpy_self_test(stru
 	}
 
 	src_dma = dma_map_page(dma_chan->device->dev, virt_to_page(src),
-			       (size_t)src & ~PAGE_MASK, PAGE_SIZE,
+			       offset_in_page(src), PAGE_SIZE,
 			       DMA_TO_DEVICE);
 	unmap->addr[0] = src_dma;
 
@@ -972,7 +972,7 @@ static int mv_chan_memcpy_self_test(stru
 	unmap->to_cnt = 1;
 
 	dest_dma = dma_map_page(dma_chan->device->dev, virt_to_page(dest),
-				(size_t)dest & ~PAGE_MASK, PAGE_SIZE,
+				offset_in_page(dest), PAGE_SIZE,
 				DMA_FROM_DEVICE);
 	unmap->addr[1] = dest_dma;
 
_

Patches currently in -mm which might be from geliangtang@gmail.com are

fs-ocfs2-cluster-use-setup_timer.patch
fs-ocfs2-cluster-use-offset_in_page-macro.patch
writeback-use-setup_deferrable_timer.patch
dmaengine-dmatest-use-offset_in_page-macro.patch
dmaengine-mv_xor-use-offset_in_page-macro.patch
dma-debug-use-offset_in_page-macro.patch

