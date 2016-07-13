From: akpm@linux-foundation.org
Subject: + alpha-dma-mapping-use-unsigned-long-for-dma_attrs.patch added
 to -mm tree
Date: Wed, 13 Jul 2016 14:50:48 -0700
Message-ID: <5786b7b8.+Fsl41+dMMNasGMa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcGMVut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     alpha-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/alpha-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/alpha-dma-mapping-use-unsigned-long-for-dma_attrs.patch

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
Subject: alpha: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-3-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/dma-mapping.h |    2 --
 arch/alpha/kernel/pci-noop.c         |    2 +-
 arch/alpha/kernel/pci_iommu.c        |   12 ++++++------
 3 files changed, 7 insertions(+), 9 deletions(-)

diff -puN arch/alpha/include/asm/dma-mapping.h~alpha-dma-mapping-use-unsigned-long-for-dma_attrs arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~alpha-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -1,8 +1,6 @@
 #ifndef _ALPHA_DMA_MAPPING_H
 #define _ALPHA_DMA_MAPPING_H
 
-#include <linux/dma-attrs.h>
-
 extern struct dma_map_ops *dma_ops;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
diff -puN arch/alpha/kernel/pci-noop.c~alpha-dma-mapping-use-unsigned-long-for-dma_attrs arch/alpha/kernel/pci-noop.c
--- a/arch/alpha/kernel/pci-noop.c~alpha-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/alpha/kernel/pci-noop.c
@@ -109,7 +109,7 @@ sys_pciconfig_write(unsigned long bus, u
 
 static void *alpha_noop_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t gfp,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	void *ret;
 
diff -puN arch/alpha/kernel/pci_iommu.c~alpha-dma-mapping-use-unsigned-long-for-dma_attrs arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -349,7 +349,7 @@ static struct pci_dev *alpha_gendev_to_p
 static dma_addr_t alpha_pci_map_page(struct device *dev, struct page *page,
 				     unsigned long offset, size_t size,
 				     enum dma_data_direction dir,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	int dac_allowed;
@@ -369,7 +369,7 @@ static dma_addr_t alpha_pci_map_page(str
 
 static void alpha_pci_unmap_page(struct device *dev, dma_addr_t dma_addr,
 				 size_t size, enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	unsigned long flags;
 	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
@@ -433,7 +433,7 @@ static void alpha_pci_unmap_page(struct
 
 static void *alpha_pci_alloc_coherent(struct device *dev, size_t size,
 				      dma_addr_t *dma_addrp, gfp_t gfp,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	void *cpu_addr;
@@ -478,7 +478,7 @@ try_again:
 
 static void alpha_pci_free_coherent(struct device *dev, size_t size,
 				    void *cpu_addr, dma_addr_t dma_addr,
-				    struct dma_attrs *attrs)
+				    unsigned long attrs)
 {
 	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	pci_unmap_single(pdev, dma_addr, size, PCI_DMA_BIDIRECTIONAL);
@@ -651,7 +651,7 @@ sg_fill(struct device *dev, struct scatt
 
 static int alpha_pci_map_sg(struct device *dev, struct scatterlist *sg,
 			    int nents, enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	struct scatterlist *start, *end, *out;
@@ -729,7 +729,7 @@ static int alpha_pci_map_sg(struct devic
 
 static void alpha_pci_unmap_sg(struct device *dev, struct scatterlist *sg,
 			       int nents, enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	unsigned long flags;
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

