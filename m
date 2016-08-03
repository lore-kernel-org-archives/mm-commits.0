From: akpm@linux-foundation.org
Subject: [folded-merged]
 dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 13:15:04 -0700
Message-ID: <57a250c8.a+zm7bMbWRO91V5s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbcHCUPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: document the DMA attributes next to the declaration
has been removed from the -mm tree.  Its filename was
     dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: dma-mapping: document the DMA attributes next to the declaration

Copy documentation abstract about each DMA attribute from
Documentation/DMA-attributes.txt to the place with declaration.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Link: http://lkml.kernel.org/r/1468399300-5399-46-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN include/linux/dma-mapping.h~dma-mapping-document-the-dma-attributes-next-to-the-declaration include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-document-the-dma-attributes-next-to-the-declaration
+++ a/include/linux/dma-mapping.h
@@ -14,14 +14,47 @@
 /**
  * List of possible attributes associated with a DMA mapping. The semantics
  * of each attribute should be defined in Documentation/DMA-attributes.txt.
+ *
+ * DMA_ATTR_WRITE_BARRIER: DMA to a memory region with this attribute
+ * forces all pending DMA writes to complete.
  */
 #define DMA_ATTR_WRITE_BARRIER		(1UL << 0)
+/*
+ * DMA_ATTR_WEAK_ORDERING: Specifies that reads and writes to the mapping
+ * may be weakly ordered, that is that reads and writes may pass each other.
+ */
 #define DMA_ATTR_WEAK_ORDERING		(1UL << 1)
+/*
+ * DMA_ATTR_WRITE_COMBINE: Specifies that writes to the mapping may be
+ * buffered to improve performance.
+ */
 #define DMA_ATTR_WRITE_COMBINE		(1UL << 2)
+/*
+ * DMA_ATTR_NON_CONSISTENT: Lets the platform to choose to return either
+ * consistent or non-consistent memory as it sees fit.
+ */
 #define DMA_ATTR_NON_CONSISTENT		(1UL << 3)
+/*
+ * DMA_ATTR_NO_KERNEL_MAPPING: Lets the platform to avoid creating a kernel
+ * virtual mapping for the allocated buffer.
+ */
 #define DMA_ATTR_NO_KERNEL_MAPPING	(1UL << 4)
+/*
+ * DMA_ATTR_SKIP_CPU_SYNC: Allows platform code to skip synchronization of
+ * the CPU cache for the given buffer assuming that it has been already
+ * transferred to 'device' domain.
+ */
 #define DMA_ATTR_SKIP_CPU_SYNC		(1UL << 5)
+/*
+ * DMA_ATTR_FORCE_CONTIGUOUS: Forces contiguous allocation of the buffer
+ * in physical memory.
+ */
 #define DMA_ATTR_FORCE_CONTIGUOUS	(1UL << 6)
+/*
+ * DMA_ATTR_ALLOC_SINGLE_PAGES: This is a hint to the DMA-mapping subsystem
+ * that it's probably not worth the time to try to allocate memory to in a way
+ * that gives better TLB efficiency.
+ */
 #define DMA_ATTR_ALLOC_SINGLE_PAGES	(1UL << 7)
 
 /*
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch

