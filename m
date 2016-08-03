From: akpm@linux-foundation.org
Subject: [folded-merged]
 openrisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm tree
Date: Wed, 03 Aug 2016 13:14:34 -0700
Message-ID: <57a250aa.z+SC6tkDnR8WSEBu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbcHCUOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: openrisc: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     openrisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: openrisc: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-35-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/kernel/dma.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN arch/openrisc/kernel/dma.c~openrisc-dma-mapping-use-unsigned-long-for-dma_attrs arch/openrisc/kernel/dma.c
--- a/arch/openrisc/kernel/dma.c~openrisc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/openrisc/kernel/dma.c
@@ -22,7 +22,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/dma-debug.h>
 #include <linux/export.h>
-#include <linux/dma-attrs.h>
 
 #include <asm/cpuinfo.h>
 #include <asm/spr_defs.h>
@@ -83,7 +82,7 @@ page_clear_nocache(pte_t *pte, unsigned
 static void *
 or1k_dma_alloc(struct device *dev, size_t size,
 	       dma_addr_t *dma_handle, gfp_t gfp,
-	       struct dma_attrs *attrs)
+	       unsigned long attrs)
 {
 	unsigned long va;
 	void *page;
@@ -117,7 +116,7 @@ or1k_dma_alloc(struct device *dev, size_
 
 static void
 or1k_dma_free(struct device *dev, size_t size, void *vaddr,
-	      dma_addr_t dma_handle, struct dma_attrs *attrs)
+	      dma_addr_t dma_handle, unsigned long attrs)
 {
 	unsigned long va = (unsigned long)vaddr;
 	struct mm_walk walk = {
@@ -137,7 +136,7 @@ static dma_addr_t
 or1k_map_page(struct device *dev, struct page *page,
 	      unsigned long offset, size_t size,
 	      enum dma_data_direction dir,
-	      struct dma_attrs *attrs)
+	      unsigned long attrs)
 {
 	unsigned long cl;
 	dma_addr_t addr = page_to_phys(page) + offset;
@@ -170,7 +169,7 @@ or1k_map_page(struct device *dev, struct
 static void
 or1k_unmap_page(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	/* Nothing special to do here... */
 }
@@ -178,14 +177,14 @@ or1k_unmap_page(struct device *dev, dma_
 static int
 or1k_map_sg(struct device *dev, struct scatterlist *sg,
 	    int nents, enum dma_data_direction dir,
-	    struct dma_attrs *attrs)
+	    unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
 
 	for_each_sg(sg, s, nents, i) {
 		s->dma_address = or1k_map_page(dev, sg_page(s), s->offset,
-					       s->length, dir, NULL);
+					       s->length, dir, 0);
 	}
 
 	return nents;
@@ -194,13 +193,13 @@ or1k_map_sg(struct device *dev, struct s
 static void
 or1k_unmap_sg(struct device *dev, struct scatterlist *sg,
 	      int nents, enum dma_data_direction dir,
-	      struct dma_attrs *attrs)
+	      unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
 
 	for_each_sg(sg, s, nents, i) {
-		or1k_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir, NULL);
+		or1k_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir, 0);
 	}
 }
 
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
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

