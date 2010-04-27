From: akpm@linux-foundation.org
Subject: + powerpc-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch added to -mm tree
Date: Tue, 27 Apr 2010 15:26:44 -0700
Message-ID: <201004272226.o3RMQiJ1023850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272Ab0D0W1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 18:27:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, beckyb@kernel.crashing.org, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     powerpc: remove unnecessary sync_single_range_* in swiotlb_dma_ops
has been added to the -mm tree.  Its filename is
     powerpc-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch

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
Subject: powerpc: remove unnecessary sync_single_range_* in swiotlb_dma_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

sync_single_range_for_cpu and sync_single_range_for_device hooks in
swiotlb_dma_ops are unnecessary because sync_single_for_cpu and
sync_single_for_device are used there.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/dma-swiotlb.c |    4 ++--
 arch/powerpc/kernel/dma.c         |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/powerpc/kernel/dma-swiotlb.c~powerpc-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops arch/powerpc/kernel/dma-swiotlb.c
--- a/arch/powerpc/kernel/dma-swiotlb.c~powerpc-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops
+++ a/arch/powerpc/kernel/dma-swiotlb.c
@@ -38,8 +38,8 @@ struct dma_map_ops swiotlb_dma_ops = {
 	.dma_supported = swiotlb_dma_supported,
 	.map_page = swiotlb_map_page,
 	.unmap_page = swiotlb_unmap_page,
-	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
-	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
+	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = swiotlb_sync_single_for_device,
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
 	.sync_sg_for_device = swiotlb_sync_sg_for_device,
 	.mapping_error = swiotlb_dma_mapping_error,
diff -puN arch/powerpc/kernel/dma.c~powerpc-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops arch/powerpc/kernel/dma.c
--- a/arch/powerpc/kernel/dma.c~powerpc-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops
+++ a/arch/powerpc/kernel/dma.c
@@ -127,11 +127,11 @@ static inline void dma_direct_sync_sg(st
 		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
 }
 
-static inline void dma_direct_sync_single_range(struct device *dev,
-		dma_addr_t dma_handle, unsigned long offset, size_t size,
-		enum dma_data_direction direction)
+static inline void dma_direct_sync_single(struct device *dev,
+					  dma_addr_t dma_handle, size_t size,
+					  enum dma_data_direction direction)
 {
-	__dma_sync(bus_to_virt(dma_handle+offset), size, direction);
+	__dma_sync(bus_to_virt(dma_handle), size, direction);
 }
 #endif
 
@@ -144,8 +144,8 @@ struct dma_map_ops dma_direct_ops = {
 	.map_page	= dma_direct_map_page,
 	.unmap_page	= dma_direct_unmap_page,
 #ifdef CONFIG_NOT_COHERENT_CACHE
-	.sync_single_range_for_cpu 	= dma_direct_sync_single_range,
-	.sync_single_range_for_device 	= dma_direct_sync_single_range,
+	.sync_single_for_cpu 		= dma_direct_sync_single,
+	.sync_single_for_device 	= dma_direct_sync_single,
 	.sync_sg_for_cpu 		= dma_direct_sync_sg,
 	.sync_sg_for_device 		= dma_direct_sync_sg,
 #endif
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

