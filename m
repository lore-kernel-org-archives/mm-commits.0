From: akpm@linux-foundation.org
Subject: [merged] vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:03 -0700
Message-ID: <200906121822.n5CIM30o030805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760052AbZFLSXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:23:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     vino: replace dma_sync_single with dma_sync_single_for_cpu
has been removed from the -mm tree.  Its filename was
     vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vino: replace dma_sync_single with dma_sync_single_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This replaces dma_sync_single() with dma_sync_single_for_cpu() because
dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:

/* Backwards compat, remove in 2.7.x */
#define dma_sync_single		dma_sync_single_for_cpu
#define dma_sync_sg		dma_sync_sg_for_cpu

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/vino.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/media/video/vino.c~vino-replace-dma_sync_single-with-dma_sync_single_for_cpu drivers/media/video/vino.c
--- a/drivers/media/video/vino.c~vino-replace-dma_sync_single-with-dma_sync_single_for_cpu
+++ a/drivers/media/video/vino.c
@@ -868,9 +868,9 @@ static void vino_sync_buffer(struct vino
 	dprintk("vino_sync_buffer():\n");
 
 	for (i = 0; i < fb->desc_table.page_count; i++)
-		dma_sync_single(NULL,
-				fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
-				PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(NULL,
+					fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
+					PAGE_SIZE, DMA_FROM_DEVICE);
 }
 
 /* Framebuffer fifo functions (need to be locked externally) */
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
sg_io-dont-perform-unneeded-copy-in-compat-code.patch
sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh.patch
sparc-add-sync_single_for_device-and-sync_sg_for_device-to-struct-dma_ops.patch
sparc-use-dma_map_page-instead-of-dma_map_single.patch
sparc-remove-dma-mapping_3264h.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch
dma-mapping-add-asm-generic-dma-mapping-commonh.patch
dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-add-config_dma_api_debug-support.patch
dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch

