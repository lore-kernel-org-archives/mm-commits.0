From: akpm@linux-foundation.org
Subject: + dma-debug-use-offset_in_page-macro.patch added to -mm tree
Date: Tue, 25 Apr 2017 14:30:59 -0700
Message-ID: <58ffc013.s1OJDoyLTT8j6ZdW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54566 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2993738AbdDYVbA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 17:31:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, dan.j.williams@intel.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dma-debug.c: use offset_in_page() macro
has been added to the -mm tree.  Its filename is
     dma-debug-use-offset_in_page-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-use-offset_in_page-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-use-offset_in_page-macro.patch

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
Subject: lib/dma-debug.c: use offset_in_page() macro

Use offset_in_page() macro instead of open-coding.

Link: http://lkml.kernel.org/r/a23e2178bef0fea63f24995b5086a0d4ed82061e.1492757182.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-use-offset_in_page-macro lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-use-offset_in_page-macro
+++ a/lib/dma-debug.c
@@ -1498,7 +1498,7 @@ void debug_dma_alloc_coherent(struct dev
 	entry->type      = dma_debug_coherent;
 	entry->dev       = dev;
 	entry->pfn	 = page_to_pfn(virt_to_page(virt));
-	entry->offset	 = (size_t) virt & ~PAGE_MASK;
+	entry->offset	 = offset_in_page(virt);
 	entry->size      = size;
 	entry->dev_addr  = dma_addr;
 	entry->direction = DMA_BIDIRECTIONAL;
@@ -1514,7 +1514,7 @@ void debug_dma_free_coherent(struct devi
 		.type           = dma_debug_coherent,
 		.dev            = dev,
 		.pfn		= page_to_pfn(virt_to_page(virt)),
-		.offset		= (size_t) virt & ~PAGE_MASK,
+		.offset		= offset_in_page(virt),
 		.dev_addr       = addr,
 		.size           = size,
 		.direction      = DMA_BIDIRECTIONAL,
_

Patches currently in -mm which might be from geliangtang@gmail.com are

fs-ocfs2-cluster-use-setup_timer.patch
fs-ocfs2-cluster-use-offset_in_page-macro.patch
writeback-use-setup_deferrable_timer.patch
dmaengine-dmatest-use-offset_in_page-macro.patch
dmaengine-mv_xor-use-offset_in_page-macro.patch
dma-debug-use-offset_in_page-macro.patch

