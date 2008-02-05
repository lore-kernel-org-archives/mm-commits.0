From: akpm@linux-foundation.org
Subject: - iommu-sg-merging-add-device_dma_parameters-structure.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:56 -0800
Message-ID: <200802052227.m15MRb8d011817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762700AbYBEWoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: add device_dma_parameters structure
has been removed from the -mm tree.  Its filename was
     iommu-sg-merging-add-device_dma_parameters-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: add device_dma_parameters structure
From: FUJITA Tomonori <tomof@acm.org>

IOMMUs merges scatter/gather segments without considering a low level
driver's restrictions. The problem is that IOMMUs can't access to the
limitations because they are in request_queue.

This patchset introduces a new structure, device_dma_parameters,
including dma information. A pointer to device_dma_parameters is added
to struct device. The bus specific structures (like pci_dev) includes
device_dma_parameters. Low level drivers can use dma_set_max_seg_size
to tell IOMMUs about the restrictions.

We can move more dma stuff in struct device (like dma_mask) to struct
device_dma_parameters later (needs some cleanups before that).

This includes patches for all the IOMMUs that could merge sg (x86_64,
ppc, IA64, alpha, sparc64, and parisc) though only the ppc patch was
tested. The patches for other IOMMUs are only compile tested.



This patch:

Add a new structure, device_dma_parameters, including dma information.  A
pointer to device_dma_parameters is added to struct device.

- there are only max_segment_size and segment_boundary_mask there but we'll
  move more dma stuff in struct device (like dma_mask) to struct
  device_dma_parameters later.  segment_boundary_mask is not supported yet.

- new accessors for the dma parameters are added.  So we can easily change
  where to place struct device_dma_parameters in the future.

- dma_get_max_seg_size returns 64K if dma_parms in struct device isn't set
  up properly.  64K is the default max_segment_size in the block layer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/device.h      |   11 +++++++++++
 include/linux/dma-mapping.h |   15 +++++++++++++++
 2 files changed, 26 insertions(+)

diff -puN include/linux/device.h~iommu-sg-merging-add-device_dma_parameters-structure include/linux/device.h
--- a/include/linux/device.h~iommu-sg-merging-add-device_dma_parameters-structure
+++ a/include/linux/device.h
@@ -410,6 +410,15 @@ extern int devres_release_group(struct d
 extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
 extern void devm_kfree(struct device *dev, void *p);
 
+struct device_dma_parameters {
+	/*
+	 * a low level driver may set these to teach IOMMU code about
+	 * sg limitations.
+	 */
+	unsigned int max_segment_size;
+	unsigned long segment_boundary_mask;
+};
+
 struct device {
 	struct klist		klist_children;
 	struct klist_node	knode_parent;	/* node in sibling list */
@@ -445,6 +454,8 @@ struct device {
 					     64 bit addresses for consistent
 					     allocations such descriptors. */
 
+	struct device_dma_parameters *dma_parms;
+
 	struct list_head	dma_pools;	/* dma pools (if dma'ble) */
 
 	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
diff -puN include/linux/dma-mapping.h~iommu-sg-merging-add-device_dma_parameters-structure include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~iommu-sg-merging-add-device_dma_parameters-structure
+++ a/include/linux/dma-mapping.h
@@ -60,6 +60,21 @@ static inline int is_device_dma_capable(
 
 extern u64 dma_get_required_mask(struct device *dev);
 
+static inline unsigned int dma_get_max_seg_size(struct device *dev)
+{
+	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
+}
+
+static inline unsigned int dma_set_max_seg_size(struct device *dev,
+						unsigned int size)
+{
+	if (dev->dma_parms) {
+		dev->dma_parms->max_segment_size = size;
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
