From: akpm@linux-foundation.org
Subject: - add-accessors-for-segment_boundary_mask-in.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:08 -0800
Message-ID: <200802052231.m15MVn0j012190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762604AbYBEWnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: add accessors for segment_boundary_mask in device_dma_parameters()
has been removed from the -mm tree.  Its filename was
     add-accessors-for-segment_boundary_mask-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: add accessors for segment_boundary_mask in device_dma_parameters()
From: FUJITA Tomonori <tomof@acm.org>

This adds new accessors for segment_boundary_mask in device_dma_parameters
structure in the same way I did for max_segment_size.  So we can easily change
where to place struct device_dma_parameters in the future.

dma_get_segment boundary returns 0xffffffff if dma_parms in struct device
isn't set up properly.  0xffffffff is the default value used in the block
layer and the scsi mid layer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/linux/dma-mapping.h~add-accessors-for-segment_boundary_mask-in include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~add-accessors-for-segment_boundary_mask-in
+++ a/include/linux/dma-mapping.h
@@ -75,6 +75,21 @@ static inline unsigned int dma_set_max_s
 		return -EIO;
 }
 
+static inline unsigned long dma_get_seg_boundary(struct device *dev)
+{
+	return dev->dma_parms ?
+		dev->dma_parms->segment_boundary_mask : 0xffffffff;
+}
+
+static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
+{
+	if (dev->dma_parms) {
+		dev->dma_parms->segment_boundary_mask = mask;
+		return 0;
+	} else
+		return -EIO;
+}
+
 /* flags for the coherent memory api */
 #define	DMA_MEMORY_MAP			0x01
 #define DMA_MEMORY_IO			0x02
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
