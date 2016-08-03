From: akpm@linux-foundation.org
Subject: [folded-merged]
 h8300-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 13:14:16 -0700
Message-ID: <57a25098.Y6S5CQ8YT4vp2pPk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553AbcHCUOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     h8300-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: h8300: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-26-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/dma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/h8300/kernel/dma.c~h8300-dma-mapping-use-unsigned-long-for-dma_attrs arch/h8300/kernel/dma.c
--- a/arch/h8300/kernel/dma.c~h8300-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/h8300/kernel/dma.c
@@ -12,7 +12,7 @@
 
 static void *dma_alloc(struct device *dev, size_t size,
 		       dma_addr_t *dma_handle, gfp_t gfp,
-		       struct dma_attrs *attrs)
+		       unsigned long attrs)
 {
 	void *ret;
 
@@ -32,7 +32,7 @@ static void *dma_alloc(struct device *de
 
 static void dma_free(struct device *dev, size_t size,
 		     void *vaddr, dma_addr_t dma_handle,
-		     struct dma_attrs *attrs)
+		     unsigned long attrs)
 
 {
 	free_pages((unsigned long)vaddr, get_order(size));
@@ -41,14 +41,14 @@ static void dma_free(struct device *dev,
 static dma_addr_t map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t size,
 				  enum dma_data_direction direction,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	return page_to_phys(page) + offset;
 }
 
 static int map_sg(struct device *dev, struct scatterlist *sgl,
 		  int nents, enum dma_data_direction direction,
-		  struct dma_attrs *attrs)
+		  unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
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

