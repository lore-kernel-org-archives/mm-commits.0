From: akpm@linux-foundation.org
Subject: + nios2-convert-to-dma_map_ops-fix.patch added to -mm tree
Date: Mon, 23 Nov 2015 14:44:43 -0800
Message-ID: <565396db.FzG/vl2js65gnJe1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbbKWWon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 17:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: nios2: dma mapping fixes
has been added to the -mm tree.  Its filename is
     nios2-convert-to-dma_map_ops-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nios2-convert-to-dma_map_ops-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nios2-convert-to-dma_map_ops-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: nios2: dma mapping fixes

Signed-off-by: Christoph Hellwig <hch@lst.de
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/mm/dma-mapping.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN arch/nios2/mm/dma-mapping.c~nios2-convert-to-dma_map_ops-fix arch/nios2/mm/dma-mapping.c
--- a/arch/nios2/mm/dma-mapping.c~nios2-convert-to-dma_map_ops-fix
+++ a/arch/nios2/mm/dma-mapping.c
@@ -128,7 +128,7 @@ static void nios2_dma_unmap_page(struct
 	__dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
 }
 
-static void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+static void nios2_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 		int nhwentries, enum dma_data_direction direction,
 		struct dma_attrs *attrs)
 {
@@ -183,13 +183,15 @@ static void nios2_dma_sync_sg_for_device
 }
 
 struct dma_map_ops nios2_dma_ops = {
-	.alloc                  = nios2_dma_alloc,
-	.free                   = nios2_dma_free,
-	.map_page               = nios2_dma_map_page,
-	.map_sg                 = nios2_dma_map_sg,
-	.sync_single_for_device = nios2_dma_sync_single_for_device,
-	.sync_single_for_cpu    = nios2_dma_sync_single_for_cpu,
-	.sync_sg_for_cpu        = nios2_dma_sync_sg_for_cpu,
-	.sync_sg_for_dev        = nios2_dma_sync_sg_for_device,
+	.alloc			= nios2_dma_alloc,
+	.free			= nios2_dma_free,
+	.map_page		= nios2_dma_map_page,
+	.unmap_page		= nios2_dma_unmap_page,
+	.map_sg			= nios2_dma_map_sg,
+	.unmap_sg		= nios2_dma_unmap_sg,
+	.sync_single_for_device	= nios2_dma_sync_single_for_device,
+	.sync_single_for_cpu	= nios2_dma_sync_single_for_cpu,
+	.sync_sg_for_cpu	= nios2_dma_sync_sg_for_cpu,
+	.sync_sg_for_device	= nios2_dma_sync_sg_for_device,
 };
 EXPORT_SYMBOL(nios2_dma_ops);
_

Patches currently in -mm which might be from hch@lst.de are

dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch
arc-convert-to-dma_map_ops.patch
arc-convert-to-dma_map_ops-fix.patch
avr32-convert-to-dma_map_ops.patch
blackfin-convert-to-dma_map_ops.patch
c6x-convert-to-dma_map_ops.patch
c6x-convert-to-dma_map_ops-fix-2.patch
cris-convert-to-dma_map_ops.patch
nios2-convert-to-dma_map_ops.patch
nios2-convert-to-dma_map_ops-fix.patch
frv-convert-to-dma_map_ops.patch
parisc-convert-to-dma_map_ops.patch
mn10300-convert-to-dma_map_ops.patch
m68k-convert-to-dma_map_ops.patch
metag-convert-to-dma_map_ops.patch
sparc-use-generic-dma_set_mask.patch
tile-uninline-dma_set_mask.patch
dma-mapping-always-provide-the-dma_map_ops-based-implementation.patch
dma-mapping-remove-asm-generic-dma-coherenth.patch

