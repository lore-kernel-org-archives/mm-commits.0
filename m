From: akpm@linux-foundation.org
Subject: +
 dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch added to -mm tree
Date: Wed, 13 Jul 2016 14:52:14 -0700
Message-ID: <5786b80e.eA7mXLjhM79ixQCb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcGMVwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     subject: dma-mapping: document the DMA attributes next to the declaration
has been added to the -mm tree.  Its filename is
     dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
subject: dma-mapping: document the DMA attributes next to the declaration

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
alpha-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arm64-dma-mapping-use-unsigned-long-for-dma_attrs.patch
avr32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
blackfin-dma-mapping-use-unsigned-long-for-dma_attrs.patch
c6x-dma-mapping-use-unsigned-long-for-dma_attrs.patch
cris-dma-mapping-use-unsigned-long-for-dma_attrs.patch
frv-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-mediatek-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-nouveau-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-rockship-dma-mapping-use-unsigned-long-for-dma_attrs.patch
infiniband-dma-mapping-use-unsigned-long-for-dma_attrs.patch
iommu-dma-mapping-use-unsigned-long-for-dma_attrs.patch
media-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xen-dma-mapping-use-unsigned-long-for-dma_attrs.patch
swiotlb-dma-mapping-use-unsigned-long-for-dma_attrs.patch
powerpc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
video-dma-mapping-use-unsigned-long-for-dma_attrs.patch
x86-dma-mapping-use-unsigned-long-for-dma_attrs.patch
iommu-intel-dma-mapping-use-unsigned-long-for-dma_attrs.patch
h8300-dma-mapping-use-unsigned-long-for-dma_attrs.patch
hexagon-dma-mapping-use-unsigned-long-for-dma_attrs.patch
ia64-dma-mapping-use-unsigned-long-for-dma_attrs.patch
m68k-dma-mapping-use-unsigned-long-for-dma_attrs.patch
metag-dma-mapping-use-unsigned-long-for-dma_attrs.patch
microblaze-dma-mapping-use-unsigned-long-for-dma_attrs.patch
mips-dma-mapping-use-unsigned-long-for-dma_attrs.patch
mn10300-dma-mapping-use-unsigned-long-for-dma_attrs.patch
nios2-dma-mapping-use-unsigned-long-for-dma_attrs.patch
openrisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
parisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
misc-mic-dma-mapping-use-unsigned-long-for-dma_attrs.patch
s390-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sh-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sparc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
tile-dma-mapping-use-unsigned-long-for-dma_attrs.patch
unicore32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xtensa-dma-mapping-use-unsigned-long-for-dma_attrs.patch
remoteproc-qcom-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

