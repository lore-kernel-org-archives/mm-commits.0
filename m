From: akpm@linux-foundation.org
Subject: [folded-merged]
 microblaze-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from
 -mm tree
Date: Wed, 03 Aug 2016 13:14:26 -0700
Message-ID: <57a250a2.Cs9byyIBb2cx5lmD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633AbcHCUOc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     microblaze-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: microblaze: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-31-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/dma-mapping.h |    1 -
 arch/microblaze/kernel/dma.c              |   12 ++++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN arch/microblaze/include/asm/dma-mapping.h~microblaze-dma-mapping-use-unsigned-long-for-dma_attrs arch/microblaze/include/asm/dma-mapping.h
--- a/arch/microblaze/include/asm/dma-mapping.h~microblaze-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/microblaze/include/asm/dma-mapping.h
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-debug.h>
-#include <linux/dma-attrs.h>
 #include <asm/io.h>
 #include <asm/cacheflush.h>
 
diff -puN arch/microblaze/kernel/dma.c~microblaze-dma-mapping-use-unsigned-long-for-dma_attrs arch/microblaze/kernel/dma.c
--- a/arch/microblaze/kernel/dma.c~microblaze-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/microblaze/kernel/dma.c
@@ -17,7 +17,7 @@
 
 static void *dma_direct_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 #ifdef NOT_COHERENT_CACHE
 	return consistent_alloc(flag, size, dma_handle);
@@ -42,7 +42,7 @@ static void *dma_direct_alloc_coherent(s
 
 static void dma_direct_free_coherent(struct device *dev, size_t size,
 				     void *vaddr, dma_addr_t dma_handle,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 #ifdef NOT_COHERENT_CACHE
 	consistent_free(size, vaddr);
@@ -53,7 +53,7 @@ static void dma_direct_free_coherent(str
 
 static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 			     int nents, enum dma_data_direction direction,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -78,7 +78,7 @@ static inline dma_addr_t dma_direct_map_
 					     unsigned long offset,
 					     size_t size,
 					     enum dma_data_direction direction,
-					     struct dma_attrs *attrs)
+					     unsigned long attrs)
 {
 	__dma_sync(page_to_phys(page) + offset, size, direction);
 	return page_to_phys(page) + offset;
@@ -88,7 +88,7 @@ static inline void dma_direct_unmap_page
 					 dma_addr_t dma_address,
 					 size_t size,
 					 enum dma_data_direction direction,
-					 struct dma_attrs *attrs)
+					 unsigned long attrs)
 {
 /* There is not necessary to do cache cleanup
  *
@@ -157,7 +157,7 @@ dma_direct_sync_sg_for_device(struct dev
 static
 int dma_direct_mmap_coherent(struct device *dev, struct vm_area_struct *vma,
 			     void *cpu_addr, dma_addr_t handle, size_t size,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 #ifdef CONFIG_MMU
 	unsigned long user_count = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
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

