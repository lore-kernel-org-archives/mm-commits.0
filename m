From: akpm@linux-foundation.org
Subject: + dma-mapping-remove-unnecessary-sync_single_range_-in-dma_map_ops.patch added to -mm tree
Date: Tue, 27 Apr 2010 15:30:36 -0700
Message-ID: <201004272230.o3RMUaRT024069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757421Ab0D0WbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 18:31:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp


The patch titled
     dma-mapping: remove unnecessary sync_single_range_* in dma_map_ops
has been added to the -mm tree.  Its filename is
     dma-mapping-remove-unnecessary-sync_single_range_-in-dma_map_ops.patch

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
Subject: dma-mapping: remove unnecessary sync_single_range_* in dma_map_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

sync_single_range_for_cpu and sync_single_range_for_device hooks are
unnecessary because sync_single_for_cpu and sync_single_for_device can
be used instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/dma-mapping-common.h |   20 ++------------------
 include/linux/dma-mapping.h              |   10 ----------
 2 files changed, 2 insertions(+), 28 deletions(-)

diff -puN include/asm-generic/dma-mapping-common.h~dma-mapping-remove-unnecessary-sync_single_range_-in-dma_map_ops include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~dma-mapping-remove-unnecessary-sync_single_range_-in-dma_map_ops
+++ a/include/asm-generic/dma-mapping-common.h
@@ -123,15 +123,7 @@ static inline void dma_sync_single_range
 						 size_t size,
 						 enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_range_for_cpu) {
-		ops->sync_single_range_for_cpu(dev, addr, offset, size, dir);
-		debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
-
-	} else
-		dma_sync_single_for_cpu(dev, addr + offset, size, dir);
+	dma_sync_single_for_cpu(dev, addr + offset, size, dir);
 }
 
 static inline void dma_sync_single_range_for_device(struct device *dev,
@@ -140,15 +132,7 @@ static inline void dma_sync_single_range
 						    size_t size,
 						    enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_range_for_device) {
-		ops->sync_single_range_for_device(dev, addr, offset, size, dir);
-		debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
-
-	} else
-		dma_sync_single_for_device(dev, addr + offset, size, dir);
+	dma_sync_single_for_device(dev, addr + offset, size, dir);
 }
 
 static inline void
diff -puN include/linux/dma-mapping.h~dma-mapping-remove-unnecessary-sync_single_range_-in-dma_map_ops include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-remove-unnecessary-sync_single_range_-in-dma_map_ops
+++ a/include/linux/dma-mapping.h
@@ -40,16 +40,6 @@ struct dma_map_ops {
 	void (*sync_single_for_device)(struct device *dev,
 				       dma_addr_t dma_handle, size_t size,
 				       enum dma_data_direction dir);
-	void (*sync_single_range_for_cpu)(struct device *dev,
-					  dma_addr_t dma_handle,
-					  unsigned long offset,
-					  size_t size,
-					  enum dma_data_direction dir);
-	void (*sync_single_range_for_device)(struct device *dev,
-					     dma_addr_t dma_handle,
-					     unsigned long offset,
-					     size_t size,
-					     enum dma_data_direction dir);
 	void (*sync_sg_for_cpu)(struct device *dev,
 				struct scatterlist *sg, int nents,
 				enum dma_data_direction dir);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
dma-mapping-fix-dma_sync_single_range_.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ia64-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
x86-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
powerpc-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
swiotlb-remove-unnecessary-swiotlb_sync_single_range_.patch
dma-mapping-remove-unnecessary-sync_single_range_-in-dma_map_ops.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch
asm-generic-remove-isa_dma_threshold-in-scatterlisth.patch
asm-generic-add-need_sg_dma_length-to-define-sg_dma_len.patch
x86_32-use-asm-generic-scatterlisth.patch
powerpc-use-asm-generic-scatterlisth.patch
arm-use-asm-generic-scatterlisth.patch
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

