From: akpm@linux-foundation.org
Subject: [patch 067/102] powerpc: implement the DMA_ATTR_NO_WARN attribute
Date: Tue, 11 Oct 2016 13:54:17 -0700
Message-ID: <57fd5179.PQI+HWtCehYzmRnt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38138 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbcJKUyS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:54:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mauricfo@linux.vnet.ibm.com, axboe@fb.com, benh@kernel.crashing.org, k.kozlowski@samsung.com, keith.busch@intel.com, mpe@ellerman.id.au

From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: powerpc: implement the DMA_ATTR_NO_WARN attribute

Add support for the DMA_ATTR_NO_WARN attribute on powerpc iommu code.

Link: http://lkml.kernel.org/r/1470092390-25451-3-git-send-email-mauricfo@linux.vnet.ibm.com
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/iommu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/iommu.c~powerpc-implement-the-dma_attr_no_warn-attribute arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~powerpc-implement-the-dma_attr_no_warn-attribute
+++ a/arch/powerpc/kernel/iommu.c
@@ -479,7 +479,8 @@ int ppc_iommu_map_sg(struct device *dev,
 
 		/* Handle failure */
 		if (unlikely(entry == DMA_ERROR_CODE)) {
-			if (printk_ratelimit())
+			if (!(attrs & DMA_ATTR_NO_WARN) &&
+			    printk_ratelimit())
 				dev_info(dev, "iommu_alloc failed, tbl %p "
 					 "vaddr %lx npages %lu\n", tbl, vaddr,
 					 npages);
@@ -776,7 +777,8 @@ dma_addr_t iommu_map_page(struct device
 					 mask >> tbl->it_page_shift, align,
 					 attrs);
 		if (dma_handle == DMA_ERROR_CODE) {
-			if (printk_ratelimit())  {
+			if (!(attrs & DMA_ATTR_NO_WARN) &&
+			    printk_ratelimit())  {
 				dev_info(dev, "iommu_alloc failed, tbl %p "
 					 "vaddr %p npages %d\n", tbl, vaddr,
 					 npages);
_
