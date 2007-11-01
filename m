From: akpm@linux-foundation.org
Subject: + frv-move-dma-macros-to-scatterlisth-for-consistency.patch added to -mm tree
Date: Thu, 01 Nov 2007 16:25:37 -0700
Message-ID: <200711012325.lA1NPbUl020991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37620 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469AbXKAXZy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 19:25:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, dhowells@redhat.com


The patch titled
     FRV: move DMA macros to scatterlist.h for consistency.
has been added to the -mm tree.  Its filename is
     frv-move-dma-macros-to-scatterlisth-for-consistency.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FRV: move DMA macros to scatterlist.h for consistency.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

To be consistent with other architectures, these two DMA macros should
be defined in scatterlist.h as opposed to dma-mapping.h

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/dma-mapping.h |   10 ----------
 include/asm-frv/scatterlist.h |   10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN include/asm-frv/dma-mapping.h~frv-move-dma-macros-to-scatterlisth-for-consistency include/asm-frv/dma-mapping.h
--- a/include/asm-frv/dma-mapping.h~frv-move-dma-macros-to-scatterlisth-for-consistency
+++ a/include/asm-frv/dma-mapping.h
@@ -17,16 +17,6 @@ void *dma_alloc_coherent(struct device *
 void dma_free_coherent(struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle);
 
 /*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->length)
-
-/*
  * Map a single buffer of the indicated size for DMA in streaming mode.
  * The 32-bit bus address to use is returned.
  *
diff -puN include/asm-frv/scatterlist.h~frv-move-dma-macros-to-scatterlisth-for-consistency include/asm-frv/scatterlist.h
--- a/include/asm-frv/scatterlist.h~frv-move-dma-macros-to-scatterlisth-for-consistency
+++ a/include/asm-frv/scatterlist.h
@@ -31,6 +31,16 @@ struct scatterlist {
 	unsigned int	length;
 };
 
+/*
+ * These macros should be used after a pci_map_sg call has been done
+ * to get bus addresses of each of the SG entries and their lengths.
+ * You should only work with the number of sg entries pci_map_sg
+ * returns, or alternatively stop on the first sg_dma_len(sg) which
+ * is 0.
+ */
+#define sg_dma_address(sg)	((sg)->dma_address)
+#define sg_dma_len(sg)		((sg)->length)
+
 #define ISA_DMA_THRESHOLD (0xffffffffUL)
 
 #endif /* !_ASM_SCATTERLIST_H */
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-sh64.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
