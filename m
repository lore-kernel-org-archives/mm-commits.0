From: akpm@linux-foundation.org
Subject: [folded-merged]
 unicore32-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from
 -mm tree
Date: Wed, 03 Aug 2016 13:14:48 -0700
Message-ID: <57a250b8.VXnD55L1y5UARYhp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbcHCUOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: unicore32: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     unicore32-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: unicore32: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-42-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/mm/dma-swiotlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/unicore32/mm/dma-swiotlb.c~unicore32-dma-mapping-use-unsigned-long-for-dma_attrs arch/unicore32/mm/dma-swiotlb.c
--- a/arch/unicore32/mm/dma-swiotlb.c~unicore32-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/unicore32/mm/dma-swiotlb.c
@@ -19,14 +19,14 @@
 
 static void *unicore_swiotlb_alloc_coherent(struct device *dev, size_t size,
 					    dma_addr_t *dma_handle, gfp_t flags,
-					    struct dma_attrs *attrs)
+					    unsigned long attrs)
 {
 	return swiotlb_alloc_coherent(dev, size, dma_handle, flags);
 }
 
 static void unicore_swiotlb_free_coherent(struct device *dev, size_t size,
 					  void *vaddr, dma_addr_t dma_addr,
-					  struct dma_attrs *attrs)
+					  unsigned long attrs)
 {
 	swiotlb_free_coherent(dev, size, vaddr, dma_addr);
 }
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
xtensa-dma-mapping-use-unsigned-long-for-dma_attrs.patch
remoteproc-qcom-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

