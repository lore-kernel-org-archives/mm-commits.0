From: akpm@linux-foundation.org
Subject: + staging-saa7134-go7007-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch added to -mm tree
Date: Wed, 12 May 2010 20:55:17 -0400
Message-ID: <201005130356.o4D3ujGp006044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754909Ab0EMD5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 23:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, ben@decadent.org.uk, gregkh@suse.de


The patch titled
     Staging: saa7134-go7007: replace dma_sync_single with dma_sync_single_for_cpu
has been added to the -mm tree.  Its filename is
     staging-saa7134-go7007-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Staging: saa7134-go7007: replace dma_sync_single with dma_sync_single_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_sync_single() is deprecated and will be removed soon.

No functional change since dma_sync_single is the wrapper of
dma_sync_single_for_cpu.

saa7134-go7007.c is commented out but anyway let's replace it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/go7007/saa7134-go7007.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/staging/go7007/saa7134-go7007.c~staging-saa7134-go7007-replace-dma_sync_single-with-dma_sync_single_for_cpu drivers/staging/go7007/saa7134-go7007.c
--- a/drivers/staging/go7007/saa7134-go7007.c~staging-saa7134-go7007-replace-dma_sync_single-with-dma_sync_single_for_cpu
+++ a/drivers/staging/go7007/saa7134-go7007.c
@@ -242,13 +242,13 @@ static void saa7134_go7007_irq_ts_done(s
 		printk(KERN_DEBUG "saa7134-go7007: irq: lost %ld\n",
 				(status >> 16) & 0x0f);
 	if (status & 0x100000) {
-		dma_sync_single(&dev->pci->dev,
-				saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(&dev->pci->dev,
+					saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
 		go7007_parse_video_stream(go, saa->bottom, PAGE_SIZE);
 		saa_writel(SAA7134_RS_BA2(5), cpu_to_le32(saa->bottom_dma));
 	} else {
-		dma_sync_single(&dev->pci->dev,
-				saa->top_dma, PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(&dev->pci->dev,
+					saa->top_dma, PAGE_SIZE, DMA_FROM_DEVICE);
 		go7007_parse_video_stream(go, saa->top, PAGE_SIZE);
 		saa_writel(SAA7134_RS_BA1(5), cpu_to_le32(saa->top_dma));
 	}
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ia64-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
x86-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
powerpc-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
swiotlb-remove-unnecessary-swiotlb_sync_single_range_.patch
dma-mapping-remove-unnecessary-sync_single_range_-in-dma_map_ops.patch
documentation-add-networking-drivers-mapping-error-handling-to-dma-api-howto.patch
staging-saa7134-go7007-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
dma-mapping-remove-deprecated-dma_sync_single-and-dma_sync_sg-api.patch
documentation-add-scsi-drivers-mapping-error-handling-to-dma-api-howto.patch
documentation-update-scatterlist-struct-description-in-dma-api-howto.patch
documentation-move-the-error-handling-to-the-better-place-in-dma-api-howto.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch
asm-generic-remove-isa_dma_threshold-in-scatterlisth.patch
asm-generic-add-need_sg_dma_length-to-define-sg_dma_len.patch
x86_32-use-asm-generic-scatterlisth.patch
powerpc-use-asm-generic-scatterlisth.patch
alpha-use-asm-generic-scatterlisth.patch
asm-generic-remove-arch_has_sg_chain-in-scatterlisth.patch
avr32-use-asm-generic-scatterlisth.patch
cris-use-asm-generic-scatterlisth.patch
h8300-use-asm-generic-scatterlisth.patch
m32r-use-use-asm-generic-scatterlisth.patch
m68k-use-asm-generic-scatterlisth.patch
mips-use-use-asm-generic-scatterlisth.patch
xtensa-use-use-asm-generic-scatterlisth.patch
blackfin-use-use-asm-generic-scatterlisth.patch
frv-use-asm-generic-scatterlisth.patch
mn10300-use-asm-generic-scatterlisth.patch
parisc-use-asm-generic-scatterlisth.patch

