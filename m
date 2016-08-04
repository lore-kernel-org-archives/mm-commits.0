From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-use-unsigned-long-for-dma_attrs.patch
 removed from -mm tree
Date: Thu, 04 Aug 2016 13:03:26 -0700
Message-ID: <57a39f8e.xQtx5b5/zu5TxuLw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288AbcHDUD2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 16:03:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, bart.vanassche@sandisk.com, bjorn.andersson@linaro.org, daniel.vetter@ffwll.ch, david.vrabel@citrix.com, egtvedt@samfundet.no, fabien.dessenne@st.com, geert@linux-m68k.org, gerald.schaefer@de.ibm.com, jesper.nilsson@axis.com, jroedel@suse.de, konrad.wilk@oracle.com, m.szyprowski@samsung.com, msalter@redhat.com, rkuo@codeaurora.org, robin.murphy@arm.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: dma-mapping: use unsigned long for dma_attrs

The dma-mapping core and the implementations do not change the
DMA attributes passed by pointer.  Thus the pointer can point to const
data.  However the attributes do not have to be a bitfield. Instead
unsigned long will do fine:

1. This is just simpler.  Both in terms of reading the code and setting
   attributes.  Instead of initializing local attributes on the stack
   and passing pointer to it to dma_set_attr(), just set the bits.

2. It brings safeness and checking for const correctness because the
   attributes are passed by value.

Semantic patches for this change (at least most of them):
===
virtual patch
virtual context

@r@
identifier f, attrs;

@@
f(...,
- struct dma_attrs *attrs
+ unsigned long attrs
, ...)
{
...
}

@@
identifier r.f;
@@
f(...,
- NULL
+ 0
 )
===
// Options: --all-includes
virtual patch
virtual context

@r@
identifier f, attrs;
type t;

@@
t f(..., struct dma_attrs *attrs);

@@
identifier r.f;
@@
f(...,
- NULL
+ 0
 )
===

Link: http://lkml.kernel.org/r/1468399300-5399-2-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>
Acked-by: Mark Salter <msalter@redhat.com> [c6x]
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com> [cris]
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> [drm]
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Joerg Roedel <jroedel@suse.de> [iommu]
Acked-by: Fabien Dessenne <fabien.dessenne@st.com> [bdisp]
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com> [vb2-core]
Acked-by: David Vrabel <david.vrabel@citrix.com> [xen]
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> [xen swiotlb]
Acked-by: Joerg Roedel <jroedel@suse.de> [iommu]
Acked-by: Richard Kuo <rkuo@codeaurora.org> [hexagon]
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> [m68k]
Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com> [s390]
Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no> [avr32]
Acked-by: Vineet Gupta <vgupta@synopsys.com> [arc]
Acked-by: Robin Murphy <robin.murphy@arm.com> [arm64 and dma-iommu]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt                           |   33 +-
 Documentation/DMA-attributes.txt                    |    2 
 arch/alpha/include/asm/dma-mapping.h                |    2 
 arch/alpha/kernel/pci-noop.c                        |    2 
 arch/alpha/kernel/pci_iommu.c                       |   12 
 arch/arc/mm/dma.c                                   |   12 
 arch/arm/common/dmabounce.c                         |    4 
 arch/arm/include/asm/dma-mapping.h                  |   13 -
 arch/arm/include/asm/xen/page-coherent.h            |   16 -
 arch/arm/mm/dma-mapping.c                           |  129 ++++------
 arch/arm/xen/mm.c                                   |    8 
 arch/arm64/mm/dma-mapping.c                         |   66 ++---
 arch/avr32/mm/dma-coherent.c                        |   12 
 arch/blackfin/kernel/dma-mapping.c                  |    8 
 arch/c6x/include/asm/dma-mapping.h                  |    4 
 arch/c6x/kernel/dma.c                               |    9 
 arch/c6x/mm/dma-coherent.c                          |    4 
 arch/cris/arch-v32/drivers/pci/dma.c                |    9 
 arch/frv/mb93090-mb00/pci-dma-nommu.c               |    8 
 arch/frv/mb93090-mb00/pci-dma.c                     |    9 
 arch/h8300/kernel/dma.c                             |    8 
 arch/hexagon/include/asm/dma-mapping.h              |    1 
 arch/hexagon/kernel/dma.c                           |    8 
 arch/ia64/hp/common/sba_iommu.c                     |   22 -
 arch/ia64/include/asm/machvec.h                     |    1 
 arch/ia64/kernel/pci-swiotlb.c                      |    4 
 arch/ia64/sn/pci/pci_dma.c                          |   22 -
 arch/m68k/kernel/dma.c                              |   12 
 arch/metag/kernel/dma.c                             |   16 -
 arch/microblaze/include/asm/dma-mapping.h           |    1 
 arch/microblaze/kernel/dma.c                        |   12 
 arch/mips/cavium-octeon/dma-octeon.c                |    8 
 arch/mips/loongson64/common/dma-swiotlb.c           |   10 
 arch/mips/mm/dma-default.c                          |   20 -
 arch/mips/netlogic/common/nlm-dma.c                 |    4 
 arch/mn10300/mm/dma-alloc.c                         |    8 
 arch/nios2/mm/dma-mapping.c                         |   12 
 arch/openrisc/kernel/dma.c                          |   21 -
 arch/parisc/kernel/pci-dma.c                        |   18 -
 arch/powerpc/include/asm/dma-mapping.h              |    7 
 arch/powerpc/include/asm/iommu.h                    |   10 
 arch/powerpc/kernel/dma-iommu.c                     |   12 
 arch/powerpc/kernel/dma.c                           |   18 -
 arch/powerpc/kernel/ibmebus.c                       |   12 
 arch/powerpc/kernel/iommu.c                         |   12 
 arch/powerpc/kernel/vio.c                           |   12 
 arch/powerpc/platforms/cell/iommu.c                 |   28 +-
 arch/powerpc/platforms/pasemi/iommu.c               |    2 
 arch/powerpc/platforms/powernv/npu-dma.c            |    8 
 arch/powerpc/platforms/powernv/pci-ioda.c           |    4 
 arch/powerpc/platforms/powernv/pci.c                |    2 
 arch/powerpc/platforms/powernv/pci.h                |    2 
 arch/powerpc/platforms/ps3/system-bus.c             |   18 -
 arch/powerpc/platforms/pseries/iommu.c              |    6 
 arch/powerpc/sysdev/dart_iommu.c                    |    2 
 arch/s390/include/asm/dma-mapping.h                 |    1 
 arch/s390/pci/pci_dma.c                             |   23 -
 arch/sh/include/asm/dma-mapping.h                   |    4 
 arch/sh/kernel/dma-nommu.c                          |    4 
 arch/sh/mm/consistent.c                             |    4 
 arch/sparc/kernel/iommu.c                           |   12 
 arch/sparc/kernel/ioport.c                          |   24 -
 arch/sparc/kernel/pci_sun4v.c                       |   12 
 arch/tile/kernel/pci-dma.c                          |   28 +-
 arch/unicore32/mm/dma-swiotlb.c                     |    4 
 arch/x86/include/asm/dma-mapping.h                  |    5 
 arch/x86/include/asm/swiotlb.h                      |    4 
 arch/x86/include/asm/xen/page-coherent.h            |    9 
 arch/x86/kernel/amd_gart_64.c                       |   20 -
 arch/x86/kernel/pci-calgary_64.c                    |   14 -
 arch/x86/kernel/pci-dma.c                           |    4 
 arch/x86/kernel/pci-nommu.c                         |    4 
 arch/x86/kernel/pci-swiotlb.c                       |    4 
 arch/x86/pci/sta2x11-fixup.c                        |    2 
 arch/x86/pci/vmd.c                                  |   16 -
 arch/xtensa/kernel/pci-dma.c                        |   12 
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c           |    2 
 drivers/gpu/drm/exynos/exynos_drm_g2d.c             |   12 
 drivers/gpu/drm/exynos/exynos_drm_gem.c             |   20 -
 drivers/gpu/drm/exynos/exynos_drm_gem.h             |    2 
 drivers/gpu/drm/mediatek/mtk_drm_gem.c              |   13 -
 drivers/gpu/drm/mediatek/mtk_drm_gem.h              |    2 
 drivers/gpu/drm/msm/msm_drv.c                       |   13 -
 drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c |   13 -
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c         |   17 -
 drivers/gpu/drm/rockchip/rockchip_drm_gem.h         |    2 
 drivers/infiniband/core/umem.c                      |    7 
 drivers/iommu/amd_iommu.c                           |   12 
 drivers/iommu/dma-iommu.c                           |    8 
 drivers/iommu/intel-iommu.c                         |   12 
 drivers/media/platform/sti/bdisp/bdisp-hw.c         |   26 --
 drivers/media/v4l2-core/videobuf2-dma-contig.c      |   28 --
 drivers/media/v4l2-core/videobuf2-dma-sg.c          |   21 -
 drivers/media/v4l2-core/videobuf2-vmalloc.c         |    2 
 drivers/misc/mic/host/mic_boot.c                    |   20 -
 drivers/parisc/ccio-dma.c                           |   16 -
 drivers/parisc/sba_iommu.c                          |   16 -
 drivers/remoteproc/qcom_q6v5_pil.c                  |    7 
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c      |   12 
 drivers/video/fbdev/omap2/omapfb/omapfb.h           |    3 
 drivers/xen/swiotlb-xen.c                           |   14 -
 include/linux/dma-attrs.h                           |   71 -----
 include/linux/dma-iommu.h                           |    6 
 include/linux/dma-mapping.h                         |  128 ++++++---
 include/linux/swiotlb.h                             |   10 
 include/media/videobuf2-core.h                      |    6 
 include/media/videobuf2-dma-contig.h                |    2 
 include/rdma/ib_verbs.h                             |   17 -
 include/xen/swiotlb-xen.h                           |   12 
 lib/dma-noop.c                                      |    9 
 lib/swiotlb.c                                       |   13 -
 111 files changed, 705 insertions(+), 804 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-mapping-use-unsigned-long-for-dma_attrs Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/Documentation/DMA-API.txt
@@ -369,35 +369,32 @@ See also dma_map_single().
 dma_addr_t
 dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size,
 		     enum dma_data_direction dir,
-		     struct dma_attrs *attrs)
+		     unsigned long attrs)
 
 void
 dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
 		       size_t size, enum dma_data_direction dir,
-		       struct dma_attrs *attrs)
+		       unsigned long attrs)
 
 int
 dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
 		 int nents, enum dma_data_direction dir,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 
 void
 dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
 		   int nents, enum dma_data_direction dir,
-		   struct dma_attrs *attrs)
+		   unsigned long attrs)
 
 The four functions above are just like the counterpart functions
 without the _attrs suffixes, except that they pass an optional
-struct dma_attrs*.
-
-struct dma_attrs encapsulates a set of "DMA attributes". For the
-definition of struct dma_attrs see linux/dma-attrs.h.
+dma_attrs.
 
 The interpretation of DMA attributes is architecture-specific, and
 each attribute should be documented in Documentation/DMA-attributes.txt.
 
-If struct dma_attrs* is NULL, the semantics of each of these
-functions is identical to those of the corresponding function
+If dma_attrs are 0, the semantics of each of these functions
+is identical to those of the corresponding function
 without the _attrs suffix. As a result dma_map_single_attrs()
 can generally replace dma_map_single(), etc.
 
@@ -405,15 +402,15 @@ As an example of the use of the *_attrs
 you could pass an attribute DMA_ATTR_FOO when mapping memory
 for DMA:
 
-#include <linux/dma-attrs.h>
-/* DMA_ATTR_FOO should be defined in linux/dma-attrs.h and
+#include <linux/dma-mapping.h>
+/* DMA_ATTR_FOO should be defined in linux/dma-mapping.h and
  * documented in Documentation/DMA-attributes.txt */
 ...
 
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_FOO, &attrs);
+	unsigned long attr;
+	attr |= DMA_ATTR_FOO;
 	....
-	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, &attr);
+	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, attr);
 	....
 
 Architectures that care about DMA_ATTR_FOO would check for its
@@ -422,12 +419,10 @@ routines, e.g.:
 
 void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr,
 			     size_t size, enum dma_data_direction dir,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	....
-	int foo =  dma_get_attr(DMA_ATTR_FOO, attrs);
-	....
-	if (foo)
+	if (attrs & DMA_ATTR_FOO)
 		/* twizzle the frobnozzle */
 	....
 
diff -puN Documentation/DMA-attributes.txt~dma-mapping-use-unsigned-long-for-dma_attrs Documentation/DMA-attributes.txt
--- a/Documentation/DMA-attributes.txt~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/Documentation/DMA-attributes.txt
@@ -2,7 +2,7 @@
 			==============
 
 This document describes the semantics of the DMA attributes that are
-defined in linux/dma-attrs.h.
+defined in linux/dma-mapping.h.
 
 DMA_ATTR_WRITE_BARRIER
 ----------------------
diff -puN arch/alpha/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -1,8 +1,6 @@
 #ifndef _ALPHA_DMA_MAPPING_H
 #define _ALPHA_DMA_MAPPING_H
 
-#include <linux/dma-attrs.h>
-
 extern struct dma_map_ops *dma_ops;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
diff -puN arch/alpha/kernel/pci-noop.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/alpha/kernel/pci-noop.c
--- a/arch/alpha/kernel/pci-noop.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/alpha/kernel/pci-noop.c
@@ -109,7 +109,7 @@ sys_pciconfig_write(unsigned long bus, u
 
 static void *alpha_noop_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t gfp,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	void *ret;
 
diff -puN arch/alpha/kernel/pci_iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
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
diff -puN arch/arc/mm/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/arc/mm/dma.c
--- a/arch/arc/mm/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arc/mm/dma.c
@@ -22,7 +22,7 @@
 
 
 static void *arc_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	unsigned long order = get_order(size);
 	struct page *page;
@@ -46,7 +46,7 @@ static void *arc_dma_alloc(struct device
 	 *   (vs. always going to memory - thus are faster)
 	 */
 	if ((is_isa_arcv2() && ioc_exists) ||
-	    dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs))
+	    (attrs & DMA_ATTR_NON_CONSISTENT))
 		need_coh = 0;
 
 	/*
@@ -90,13 +90,13 @@ static void *arc_dma_alloc(struct device
 }
 
 static void arc_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	phys_addr_t paddr = plat_dma_to_phys(dev, dma_handle);
 	struct page *page = virt_to_page(paddr);
 	int is_non_coh = 1;
 
-	is_non_coh = dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs) ||
+	is_non_coh = (attrs & DMA_ATTR_NON_CONSISTENT) ||
 			(is_isa_arcv2() && ioc_exists);
 
 	if (PageHighMem(page) || !is_non_coh)
@@ -130,7 +130,7 @@ static void _dma_cache_sync(phys_addr_t
 
 static dma_addr_t arc_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	phys_addr_t paddr = page_to_phys(page) + offset;
 	_dma_cache_sync(paddr, size, dir);
@@ -138,7 +138,7 @@ static dma_addr_t arc_dma_map_page(struc
 }
 
 static int arc_dma_map_sg(struct device *dev, struct scatterlist *sg,
-	   int nents, enum dma_data_direction dir, struct dma_attrs *attrs)
+	   int nents, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
diff -puN arch/arm/common/dmabounce.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/arm/common/dmabounce.c
--- a/arch/arm/common/dmabounce.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arm/common/dmabounce.c
@@ -310,7 +310,7 @@ static inline void unmap_single(struct d
  */
 static dma_addr_t dmabounce_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	dma_addr_t dma_addr;
 	int ret;
@@ -344,7 +344,7 @@ static dma_addr_t dmabounce_map_page(str
  * should be)
  */
 static void dmabounce_unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
-		enum dma_data_direction dir, struct dma_attrs *attrs)
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	struct safe_buffer *buf;
 
diff -puN arch/arm/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/arm/include/asm/dma-mapping.h
--- a/arch/arm/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arm/include/asm/dma-mapping.h
@@ -5,7 +5,6 @@
 
 #include <linux/mm_types.h>
 #include <linux/scatterlist.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-debug.h>
 
 #include <asm/memory.h>
@@ -174,7 +173,7 @@ static inline void dma_mark_clean(void *
  * to be the device-viewed address.
  */
 extern void *arm_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
-			   gfp_t gfp, struct dma_attrs *attrs);
+			   gfp_t gfp, unsigned long attrs);
 
 /**
  * arm_dma_free - free memory allocated by arm_dma_alloc
@@ -191,7 +190,7 @@ extern void *arm_dma_alloc(struct device
  * during and after this call executing are illegal.
  */
 extern void arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
-			 dma_addr_t handle, struct dma_attrs *attrs);
+			 dma_addr_t handle, unsigned long attrs);
 
 /**
  * arm_dma_mmap - map a coherent DMA allocation into user space
@@ -208,7 +207,7 @@ extern void arm_dma_free(struct device *
  */
 extern int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 			void *cpu_addr, dma_addr_t dma_addr, size_t size,
-			struct dma_attrs *attrs);
+			unsigned long attrs);
 
 /*
  * This can be called during early boot to increase the size of the atomic
@@ -262,16 +261,16 @@ extern void dmabounce_unregister_dev(str
  * The scatter list versions of the above methods.
  */
 extern int arm_dma_map_sg(struct device *, struct scatterlist *, int,
-		enum dma_data_direction, struct dma_attrs *attrs);
+		enum dma_data_direction, unsigned long attrs);
 extern void arm_dma_unmap_sg(struct device *, struct scatterlist *, int,
-		enum dma_data_direction, struct dma_attrs *attrs);
+		enum dma_data_direction, unsigned long attrs);
 extern void arm_dma_sync_sg_for_cpu(struct device *, struct scatterlist *, int,
 		enum dma_data_direction);
 extern void arm_dma_sync_sg_for_device(struct device *, struct scatterlist *, int,
 		enum dma_data_direction);
 extern int arm_dma_get_sgtable(struct device *dev, struct sg_table *sgt,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		struct dma_attrs *attrs);
+		unsigned long attrs);
 
 #endif /* __KERNEL__ */
 #endif
diff -puN arch/arm/include/asm/xen/page-coherent.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/arm/include/asm/xen/page-coherent.h
--- a/arch/arm/include/asm/xen/page-coherent.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arm/include/asm/xen/page-coherent.h
@@ -2,15 +2,14 @@
 #define _ASM_ARM_XEN_PAGE_COHERENT_H
 
 #include <asm/page.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-mapping.h>
 
 void __xen_dma_map_page(struct device *hwdev, struct page *page,
 	     dma_addr_t dev_addr, unsigned long offset, size_t size,
-	     enum dma_data_direction dir, struct dma_attrs *attrs);
+	     enum dma_data_direction dir, unsigned long attrs);
 void __xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs);
+		unsigned long attrs);
 void __xen_dma_sync_single_for_cpu(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir);
 
@@ -18,22 +17,20 @@ void __xen_dma_sync_single_for_device(st
 		dma_addr_t handle, size_t size, enum dma_data_direction dir);
 
 static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
-		dma_addr_t *dma_handle, gfp_t flags,
-		struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t flags, unsigned long attrs)
 {
 	return __generic_dma_ops(hwdev)->alloc(hwdev, size, dma_handle, flags, attrs);
 }
 
 static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
-		void *cpu_addr, dma_addr_t dma_handle,
-		struct dma_attrs *attrs)
+		void *cpu_addr, dma_addr_t dma_handle, unsigned long attrs)
 {
 	__generic_dma_ops(hwdev)->free(hwdev, size, cpu_addr, dma_handle, attrs);
 }
 
 static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
 	     dma_addr_t dev_addr, unsigned long offset, size_t size,
-	     enum dma_data_direction dir, struct dma_attrs *attrs)
+	     enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long page_pfn = page_to_xen_pfn(page);
 	unsigned long dev_pfn = XEN_PFN_DOWN(dev_addr);
@@ -58,8 +55,7 @@ static inline void xen_dma_map_page(stru
 }
 
 static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long pfn = PFN_DOWN(handle);
 	/*
diff -puN arch/arm/mm/dma-mapping.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arm/mm/dma-mapping.c
@@ -128,16 +128,16 @@ static void __dma_page_dev_to_cpu(struct
  */
 static dma_addr_t arm_dma_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs)
+	     unsigned long attrs)
 {
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__dma_page_cpu_to_dev(page, offset, size, dir);
 	return pfn_to_dma(dev, page_to_pfn(page)) + offset;
 }
 
 static dma_addr_t arm_coherent_dma_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs)
+	     unsigned long attrs)
 {
 	return pfn_to_dma(dev, page_to_pfn(page)) + offset;
 }
@@ -157,10 +157,9 @@ static dma_addr_t arm_coherent_dma_map_p
  * whatever the device wrote there.
  */
 static void arm_dma_unmap_page(struct device *dev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__dma_page_dev_to_cpu(pfn_to_page(dma_to_pfn(dev, handle)),
 				      handle & ~PAGE_MASK, size, dir);
 }
@@ -198,12 +197,12 @@ struct dma_map_ops arm_dma_ops = {
 EXPORT_SYMBOL(arm_dma_ops);
 
 static void *arm_coherent_dma_alloc(struct device *dev, size_t size,
-	dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs);
+	dma_addr_t *handle, gfp_t gfp, unsigned long attrs);
 static void arm_coherent_dma_free(struct device *dev, size_t size, void *cpu_addr,
-				  dma_addr_t handle, struct dma_attrs *attrs);
+				  dma_addr_t handle, unsigned long attrs);
 static int arm_coherent_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		 struct dma_attrs *attrs);
+		 unsigned long attrs);
 
 struct dma_map_ops arm_coherent_dma_ops = {
 	.alloc			= arm_coherent_dma_alloc,
@@ -639,11 +638,11 @@ static void __free_from_contiguous(struc
 	dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT);
 }
 
-static inline pgprot_t __get_dma_pgprot(struct dma_attrs *attrs, pgprot_t prot)
+static inline pgprot_t __get_dma_pgprot(unsigned long attrs, pgprot_t prot)
 {
-	prot = dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs) ?
-			    pgprot_writecombine(prot) :
-			    pgprot_dmacoherent(prot);
+	prot = (attrs & DMA_ATTR_WRITE_COMBINE) ?
+			pgprot_writecombine(prot) :
+			pgprot_dmacoherent(prot);
 	return prot;
 }
 
@@ -751,7 +750,7 @@ static struct arm_dma_allocator remap_al
 
 static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 			 gfp_t gfp, pgprot_t prot, bool is_coherent,
-			 struct dma_attrs *attrs, const void *caller)
+			 unsigned long attrs, const void *caller)
 {
 	u64 mask = get_coherent_dma_mask(dev);
 	struct page *page = NULL;
@@ -764,7 +763,7 @@ static void *__dma_alloc(struct device *
 		.gfp = gfp,
 		.prot = prot,
 		.caller = caller,
-		.want_vaddr = !dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs),
+		.want_vaddr = ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0),
 		.coherent_flag = is_coherent ? COHERENT : NORMAL,
 	};
 
@@ -834,7 +833,7 @@ static void *__dma_alloc(struct device *
  * virtual and bus address for that space.
  */
 void *arm_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
-		    gfp_t gfp, struct dma_attrs *attrs)
+		    gfp_t gfp, unsigned long attrs)
 {
 	pgprot_t prot = __get_dma_pgprot(attrs, PAGE_KERNEL);
 
@@ -843,7 +842,7 @@ void *arm_dma_alloc(struct device *dev,
 }
 
 static void *arm_coherent_dma_alloc(struct device *dev, size_t size,
-	dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
+	dma_addr_t *handle, gfp_t gfp, unsigned long attrs)
 {
 	return __dma_alloc(dev, size, handle, gfp, PAGE_KERNEL, true,
 			   attrs, __builtin_return_address(0));
@@ -851,7 +850,7 @@ static void *arm_coherent_dma_alloc(stru
 
 static int __arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 {
 	int ret = -ENXIO;
 #ifdef CONFIG_MMU
@@ -879,14 +878,14 @@ static int __arm_dma_mmap(struct device
  */
 static int arm_coherent_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 {
 	return __arm_dma_mmap(dev, vma, cpu_addr, dma_addr, size, attrs);
 }
 
 int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 {
 #ifdef CONFIG_MMU
 	vma->vm_page_prot = __get_dma_pgprot(attrs, vma->vm_page_prot);
@@ -898,7 +897,7 @@ int arm_dma_mmap(struct device *dev, str
  * Free a buffer as defined by the above mapping.
  */
 static void __arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
-			   dma_addr_t handle, struct dma_attrs *attrs,
+			   dma_addr_t handle, unsigned long attrs,
 			   bool is_coherent)
 {
 	struct page *page = pfn_to_page(dma_to_pfn(dev, handle));
@@ -908,7 +907,7 @@ static void __arm_dma_free(struct device
 		.size = PAGE_ALIGN(size),
 		.cpu_addr = cpu_addr,
 		.page = page,
-		.want_vaddr = !dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs),
+		.want_vaddr = ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0),
 	};
 
 	buf = arm_dma_buffer_find(cpu_addr);
@@ -920,20 +919,20 @@ static void __arm_dma_free(struct device
 }
 
 void arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
-		  dma_addr_t handle, struct dma_attrs *attrs)
+		  dma_addr_t handle, unsigned long attrs)
 {
 	__arm_dma_free(dev, size, cpu_addr, handle, attrs, false);
 }
 
 static void arm_coherent_dma_free(struct device *dev, size_t size, void *cpu_addr,
-				  dma_addr_t handle, struct dma_attrs *attrs)
+				  dma_addr_t handle, unsigned long attrs)
 {
 	__arm_dma_free(dev, size, cpu_addr, handle, attrs, true);
 }
 
 int arm_dma_get_sgtable(struct device *dev, struct sg_table *sgt,
 		 void *cpu_addr, dma_addr_t handle, size_t size,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 {
 	struct page *page = pfn_to_page(dma_to_pfn(dev, handle));
 	int ret;
@@ -1066,7 +1065,7 @@ static void __dma_page_dev_to_cpu(struct
  * here.
  */
 int arm_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		enum dma_data_direction dir, struct dma_attrs *attrs)
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	struct scatterlist *s;
@@ -1100,7 +1099,7 @@ int arm_dma_map_sg(struct device *dev, s
  * rules concerning calls here are the same as for dma_unmap_single().
  */
 void arm_dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-		enum dma_data_direction dir, struct dma_attrs *attrs)
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	struct scatterlist *s;
@@ -1273,7 +1272,7 @@ static inline void __free_iova(struct dm
 static const int iommu_order_array[] = { 9, 8, 4, 0 };
 
 static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
-					  gfp_t gfp, struct dma_attrs *attrs,
+					  gfp_t gfp, unsigned long attrs,
 					  int coherent_flag)
 {
 	struct page **pages;
@@ -1289,7 +1288,7 @@ static struct page **__iommu_alloc_buffe
 	if (!pages)
 		return NULL;
 
-	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs))
+	if (attrs & DMA_ATTR_FORCE_CONTIGUOUS)
 	{
 		unsigned long order = get_order(size);
 		struct page *page;
@@ -1307,7 +1306,7 @@ static struct page **__iommu_alloc_buffe
 	}
 
 	/* Go straight to 4K chunks if caller says it's OK. */
-	if (dma_get_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, attrs))
+	if (attrs & DMA_ATTR_ALLOC_SINGLE_PAGES)
 		order_idx = ARRAY_SIZE(iommu_order_array) - 1;
 
 	/*
@@ -1363,12 +1362,12 @@ error:
 }
 
 static int __iommu_free_buffer(struct device *dev, struct page **pages,
-			       size_t size, struct dma_attrs *attrs)
+			       size_t size, unsigned long attrs)
 {
 	int count = size >> PAGE_SHIFT;
 	int i;
 
-	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs)) {
+	if (attrs & DMA_ATTR_FORCE_CONTIGUOUS) {
 		dma_release_from_contiguous(dev, pages[0], count);
 	} else {
 		for (i = 0; i < count; i++)
@@ -1460,14 +1459,14 @@ static struct page **__atomic_get_pages(
 	return (struct page **)page;
 }
 
-static struct page **__iommu_get_pages(void *cpu_addr, struct dma_attrs *attrs)
+static struct page **__iommu_get_pages(void *cpu_addr, unsigned long attrs)
 {
 	struct vm_struct *area;
 
 	if (__in_atomic_pool(cpu_addr, PAGE_SIZE))
 		return __atomic_get_pages(cpu_addr);
 
-	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs))
+	if (attrs & DMA_ATTR_NO_KERNEL_MAPPING)
 		return cpu_addr;
 
 	area = find_vm_area(cpu_addr);
@@ -1511,7 +1510,7 @@ static void __iommu_free_atomic(struct d
 }
 
 static void *__arm_iommu_alloc_attrs(struct device *dev, size_t size,
-	    dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs,
+	    dma_addr_t *handle, gfp_t gfp, unsigned long attrs,
 	    int coherent_flag)
 {
 	pgprot_t prot = __get_dma_pgprot(attrs, PAGE_KERNEL);
@@ -1542,7 +1541,7 @@ static void *__arm_iommu_alloc_attrs(str
 	if (*handle == DMA_ERROR_CODE)
 		goto err_buffer;
 
-	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs))
+	if (attrs & DMA_ATTR_NO_KERNEL_MAPPING)
 		return pages;
 
 	addr = __iommu_alloc_remap(pages, size, gfp, prot,
@@ -1560,20 +1559,20 @@ err_buffer:
 }
 
 static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
-		    dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
+	    dma_addr_t *handle, gfp_t gfp, unsigned long attrs)
 {
 	return __arm_iommu_alloc_attrs(dev, size, handle, gfp, attrs, NORMAL);
 }
 
 static void *arm_coherent_iommu_alloc_attrs(struct device *dev, size_t size,
-		    dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
+		    dma_addr_t *handle, gfp_t gfp, unsigned long attrs)
 {
 	return __arm_iommu_alloc_attrs(dev, size, handle, gfp, attrs, COHERENT);
 }
 
 static int __arm_iommu_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 		    void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		    struct dma_attrs *attrs)
+		    unsigned long attrs)
 {
 	unsigned long uaddr = vma->vm_start;
 	unsigned long usize = vma->vm_end - vma->vm_start;
@@ -1603,7 +1602,7 @@ static int __arm_iommu_mmap_attrs(struct
 }
 static int arm_iommu_mmap_attrs(struct device *dev,
 		struct vm_area_struct *vma, void *cpu_addr,
-		dma_addr_t dma_addr, size_t size, struct dma_attrs *attrs)
+		dma_addr_t dma_addr, size_t size, unsigned long attrs)
 {
 	vma->vm_page_prot = __get_dma_pgprot(attrs, vma->vm_page_prot);
 
@@ -1612,7 +1611,7 @@ static int arm_iommu_mmap_attrs(struct d
 
 static int arm_coherent_iommu_mmap_attrs(struct device *dev,
 		struct vm_area_struct *vma, void *cpu_addr,
-		dma_addr_t dma_addr, size_t size, struct dma_attrs *attrs)
+		dma_addr_t dma_addr, size_t size, unsigned long attrs)
 {
 	return __arm_iommu_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, attrs);
 }
@@ -1622,7 +1621,7 @@ static int arm_coherent_iommu_mmap_attrs
  * Must not be called with IRQs disabled.
  */
 void __arm_iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
-	dma_addr_t handle, struct dma_attrs *attrs, int coherent_flag)
+	dma_addr_t handle, unsigned long attrs, int coherent_flag)
 {
 	struct page **pages;
 	size = PAGE_ALIGN(size);
@@ -1638,7 +1637,7 @@ void __arm_iommu_free_attrs(struct devic
 		return;
 	}
 
-	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs)) {
+	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0) {
 		dma_common_free_remap(cpu_addr, size,
 			VM_ARM_DMA_CONSISTENT | VM_USERMAP);
 	}
@@ -1648,20 +1647,20 @@ void __arm_iommu_free_attrs(struct devic
 }
 
 void arm_iommu_free_attrs(struct device *dev, size_t size,
-		    void *cpu_addr, dma_addr_t handle, struct dma_attrs *attrs)
+		    void *cpu_addr, dma_addr_t handle, unsigned long attrs)
 {
 	__arm_iommu_free_attrs(dev, size, cpu_addr, handle, attrs, NORMAL);
 }
 
 void arm_coherent_iommu_free_attrs(struct device *dev, size_t size,
-		    void *cpu_addr, dma_addr_t handle, struct dma_attrs *attrs)
+		    void *cpu_addr, dma_addr_t handle, unsigned long attrs)
 {
 	__arm_iommu_free_attrs(dev, size, cpu_addr, handle, attrs, COHERENT);
 }
 
 static int arm_iommu_get_sgtable(struct device *dev, struct sg_table *sgt,
 				 void *cpu_addr, dma_addr_t dma_addr,
-				 size_t size, struct dma_attrs *attrs)
+				 size_t size, unsigned long attrs)
 {
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct page **pages = __iommu_get_pages(cpu_addr, attrs);
@@ -1699,7 +1698,7 @@ static int __dma_direction_to_prot(enum
  */
 static int __map_sg_chunk(struct device *dev, struct scatterlist *sg,
 			  size_t size, dma_addr_t *handle,
-			  enum dma_data_direction dir, struct dma_attrs *attrs,
+			  enum dma_data_direction dir, unsigned long attrs,
 			  bool is_coherent)
 {
 	struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
@@ -1720,8 +1719,7 @@ static int __map_sg_chunk(struct device
 		phys_addr_t phys = page_to_phys(sg_page(s));
 		unsigned int len = PAGE_ALIGN(s->offset + s->length);
 
-		if (!is_coherent &&
-			!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+		if (!is_coherent && (attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 			__dma_page_cpu_to_dev(sg_page(s), s->offset, s->length, dir);
 
 		prot = __dma_direction_to_prot(dir);
@@ -1742,7 +1740,7 @@ fail:
 }
 
 static int __iommu_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		     enum dma_data_direction dir, struct dma_attrs *attrs,
+		     enum dma_data_direction dir, unsigned long attrs,
 		     bool is_coherent)
 {
 	struct scatterlist *s = sg, *dma = sg, *start = sg;
@@ -1800,7 +1798,7 @@ bad_mapping:
  * obtained via sg_dma_{address,length}.
  */
 int arm_coherent_iommu_map_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs)
+		int nents, enum dma_data_direction dir, unsigned long attrs)
 {
 	return __iommu_map_sg(dev, sg, nents, dir, attrs, true);
 }
@@ -1818,14 +1816,14 @@ int arm_coherent_iommu_map_sg(struct dev
  * sg_dma_{address,length}.
  */
 int arm_iommu_map_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs)
+		int nents, enum dma_data_direction dir, unsigned long attrs)
 {
 	return __iommu_map_sg(dev, sg, nents, dir, attrs, false);
 }
 
 static void __iommu_unmap_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs,
-		bool is_coherent)
+		int nents, enum dma_data_direction dir,
+		unsigned long attrs, bool is_coherent)
 {
 	struct scatterlist *s;
 	int i;
@@ -1834,8 +1832,7 @@ static void __iommu_unmap_sg(struct devi
 		if (sg_dma_len(s))
 			__iommu_remove_mapping(dev, sg_dma_address(s),
 					       sg_dma_len(s));
-		if (!is_coherent &&
-		    !dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+		if (!is_coherent && (attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 			__dma_page_dev_to_cpu(sg_page(s), s->offset,
 					      s->length, dir);
 	}
@@ -1852,7 +1849,8 @@ static void __iommu_unmap_sg(struct devi
  * rules concerning calls here are the same as for dma_unmap_single().
  */
 void arm_coherent_iommu_unmap_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs)
+		int nents, enum dma_data_direction dir,
+		unsigned long attrs)
 {
 	__iommu_unmap_sg(dev, sg, nents, dir, attrs, true);
 }
@@ -1868,7 +1866,8 @@ void arm_coherent_iommu_unmap_sg(struct
  * rules concerning calls here are the same as for dma_unmap_single().
  */
 void arm_iommu_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-			enum dma_data_direction dir, struct dma_attrs *attrs)
+			enum dma_data_direction dir,
+			unsigned long attrs)
 {
 	__iommu_unmap_sg(dev, sg, nents, dir, attrs, false);
 }
@@ -1921,7 +1920,7 @@ void arm_iommu_sync_sg_for_device(struct
  */
 static dma_addr_t arm_coherent_iommu_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs)
+	     unsigned long attrs)
 {
 	struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
 	dma_addr_t dma_addr;
@@ -1955,9 +1954,9 @@ fail:
  */
 static dma_addr_t arm_iommu_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs)
+	     unsigned long attrs)
 {
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__dma_page_cpu_to_dev(page, offset, size, dir);
 
 	return arm_coherent_iommu_map_page(dev, page, offset, size, dir, attrs);
@@ -1973,8 +1972,7 @@ static dma_addr_t arm_iommu_map_page(str
  * Coherent IOMMU aware version of arm_dma_unmap_page()
  */
 static void arm_coherent_iommu_unmap_page(struct device *dev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
 	dma_addr_t iova = handle & PAGE_MASK;
@@ -1998,8 +1996,7 @@ static void arm_coherent_iommu_unmap_pag
  * IOMMU aware version of arm_dma_unmap_page()
  */
 static void arm_iommu_unmap_page(struct device *dev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
 	dma_addr_t iova = handle & PAGE_MASK;
@@ -2010,7 +2007,7 @@ static void arm_iommu_unmap_page(struct
 	if (!iova)
 		return;
 
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__dma_page_dev_to_cpu(page, offset, size, dir);
 
 	iommu_unmap(mapping->domain, iova, len);
diff -puN arch/arm/xen/mm.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/arm/xen/mm.c
--- a/arch/arm/xen/mm.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arm/xen/mm.c
@@ -98,11 +98,11 @@ static void __xen_dma_page_cpu_to_dev(st
 
 void __xen_dma_map_page(struct device *hwdev, struct page *page,
 	     dma_addr_t dev_addr, unsigned long offset, size_t size,
-	     enum dma_data_direction dir, struct dma_attrs *attrs)
+	     enum dma_data_direction dir, unsigned long attrs)
 {
 	if (is_device_dma_coherent(hwdev))
 		return;
-	if (dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
 		return;
 
 	__xen_dma_page_cpu_to_dev(hwdev, dev_addr, size, dir);
@@ -110,12 +110,12 @@ void __xen_dma_map_page(struct device *h
 
 void __xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 
 {
 	if (is_device_dma_coherent(hwdev))
 		return;
-	if (dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
 		return;
 
 	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
diff -puN arch/arm64/mm/dma-mapping.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/arm64/mm/dma-mapping.c
--- a/arch/arm64/mm/dma-mapping.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arm64/mm/dma-mapping.c
@@ -32,10 +32,10 @@
 
 static int swiotlb __read_mostly;
 
-static pgprot_t __get_dma_pgprot(struct dma_attrs *attrs, pgprot_t prot,
+static pgprot_t __get_dma_pgprot(unsigned long attrs, pgprot_t prot,
 				 bool coherent)
 {
-	if (!coherent || dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs))
+	if (!coherent || (attrs & DMA_ATTR_WRITE_COMBINE))
 		return pgprot_writecombine(prot);
 	return prot;
 }
@@ -91,7 +91,7 @@ static int __free_from_pool(void *start,
 
 static void *__dma_alloc_coherent(struct device *dev, size_t size,
 				  dma_addr_t *dma_handle, gfp_t flags,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	if (dev == NULL) {
 		WARN_ONCE(1, "Use an actual device structure for DMA allocation\n");
@@ -121,7 +121,7 @@ static void *__dma_alloc_coherent(struct
 
 static void __dma_free_coherent(struct device *dev, size_t size,
 				void *vaddr, dma_addr_t dma_handle,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	bool freed;
 	phys_addr_t paddr = dma_to_phys(dev, dma_handle);
@@ -140,7 +140,7 @@ static void __dma_free_coherent(struct d
 
 static void *__dma_alloc(struct device *dev, size_t size,
 			 dma_addr_t *dma_handle, gfp_t flags,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	struct page *page;
 	void *ptr, *coherent_ptr;
@@ -188,7 +188,7 @@ no_mem:
 
 static void __dma_free(struct device *dev, size_t size,
 		       void *vaddr, dma_addr_t dma_handle,
-		       struct dma_attrs *attrs)
+		       unsigned long attrs)
 {
 	void *swiotlb_addr = phys_to_virt(dma_to_phys(dev, dma_handle));
 
@@ -205,7 +205,7 @@ static void __dma_free(struct device *de
 static dma_addr_t __swiotlb_map_page(struct device *dev, struct page *page,
 				     unsigned long offset, size_t size,
 				     enum dma_data_direction dir,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	dma_addr_t dev_addr;
 
@@ -219,7 +219,7 @@ static dma_addr_t __swiotlb_map_page(str
 
 static void __swiotlb_unmap_page(struct device *dev, dma_addr_t dev_addr,
 				 size_t size, enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	if (!is_device_dma_coherent(dev))
 		__dma_unmap_area(phys_to_virt(dma_to_phys(dev, dev_addr)), size, dir);
@@ -228,7 +228,7 @@ static void __swiotlb_unmap_page(struct
 
 static int __swiotlb_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
 				  int nelems, enum dma_data_direction dir,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i, ret;
@@ -245,7 +245,7 @@ static int __swiotlb_map_sg_attrs(struct
 static void __swiotlb_unmap_sg_attrs(struct device *dev,
 				     struct scatterlist *sgl, int nelems,
 				     enum dma_data_direction dir,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -306,7 +306,7 @@ static void __swiotlb_sync_sg_for_device
 static int __swiotlb_mmap(struct device *dev,
 			  struct vm_area_struct *vma,
 			  void *cpu_addr, dma_addr_t dma_addr, size_t size,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	int ret = -ENXIO;
 	unsigned long nr_vma_pages = (vma->vm_end - vma->vm_start) >>
@@ -333,7 +333,7 @@ static int __swiotlb_mmap(struct device
 
 static int __swiotlb_get_sgtable(struct device *dev, struct sg_table *sgt,
 				 void *cpu_addr, dma_addr_t handle, size_t size,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	int ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
 
@@ -435,21 +435,21 @@ out:
 
 static void *__dummy_alloc(struct device *dev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flags,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	return NULL;
 }
 
 static void __dummy_free(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 }
 
 static int __dummy_mmap(struct device *dev,
 			struct vm_area_struct *vma,
 			void *cpu_addr, dma_addr_t dma_addr, size_t size,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	return -ENXIO;
 }
@@ -457,20 +457,20 @@ static int __dummy_mmap(struct device *d
 static dma_addr_t __dummy_map_page(struct device *dev, struct page *page,
 				   unsigned long offset, size_t size,
 				   enum dma_data_direction dir,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	return DMA_ERROR_CODE;
 }
 
 static void __dummy_unmap_page(struct device *dev, dma_addr_t dev_addr,
 			       size_t size, enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 }
 
 static int __dummy_map_sg(struct device *dev, struct scatterlist *sgl,
 			  int nelems, enum dma_data_direction dir,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	return 0;
 }
@@ -478,7 +478,7 @@ static int __dummy_map_sg(struct device
 static void __dummy_unmap_sg(struct device *dev,
 			     struct scatterlist *sgl, int nelems,
 			     enum dma_data_direction dir,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 }
 
@@ -553,7 +553,7 @@ static void flush_page(struct device *de
 
 static void *__iommu_alloc_attrs(struct device *dev, size_t size,
 				 dma_addr_t *handle, gfp_t gfp,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	bool coherent = is_device_dma_coherent(dev);
 	int ioprot = dma_direction_to_prot(DMA_BIDIRECTIONAL, coherent);
@@ -613,7 +613,7 @@ static void *__iommu_alloc_attrs(struct
 }
 
 static void __iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
-			       dma_addr_t handle, struct dma_attrs *attrs)
+			       dma_addr_t handle, unsigned long attrs)
 {
 	size_t iosize = size;
 
@@ -629,7 +629,7 @@ static void __iommu_free_attrs(struct de
 	 * Hence how dodgy the below logic looks...
 	 */
 	if (__in_atomic_pool(cpu_addr, size)) {
-		iommu_dma_unmap_page(dev, handle, iosize, 0, NULL);
+		iommu_dma_unmap_page(dev, handle, iosize, 0, 0);
 		__free_from_pool(cpu_addr, size);
 	} else if (is_vmalloc_addr(cpu_addr)){
 		struct vm_struct *area = find_vm_area(cpu_addr);
@@ -639,14 +639,14 @@ static void __iommu_free_attrs(struct de
 		iommu_dma_free(dev, area->pages, iosize, &handle);
 		dma_common_free_remap(cpu_addr, size, VM_USERMAP);
 	} else {
-		iommu_dma_unmap_page(dev, handle, iosize, 0, NULL);
+		iommu_dma_unmap_page(dev, handle, iosize, 0, 0);
 		__free_pages(virt_to_page(cpu_addr), get_order(size));
 	}
 }
 
 static int __iommu_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 			      void *cpu_addr, dma_addr_t dma_addr, size_t size,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	struct vm_struct *area;
 	int ret;
@@ -666,7 +666,7 @@ static int __iommu_mmap_attrs(struct dev
 
 static int __iommu_get_sgtable(struct device *dev, struct sg_table *sgt,
 			       void *cpu_addr, dma_addr_t dma_addr,
-			       size_t size, struct dma_attrs *attrs)
+			       size_t size, unsigned long attrs)
 {
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct vm_struct *area = find_vm_area(cpu_addr);
@@ -707,14 +707,14 @@ static void __iommu_sync_single_for_devi
 static dma_addr_t __iommu_map_page(struct device *dev, struct page *page,
 				   unsigned long offset, size_t size,
 				   enum dma_data_direction dir,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	bool coherent = is_device_dma_coherent(dev);
 	int prot = dma_direction_to_prot(dir, coherent);
 	dma_addr_t dev_addr = iommu_dma_map_page(dev, page, offset, size, prot);
 
 	if (!iommu_dma_mapping_error(dev, dev_addr) &&
-	    !dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	    (attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__iommu_sync_single_for_device(dev, dev_addr, size, dir);
 
 	return dev_addr;
@@ -722,9 +722,9 @@ static dma_addr_t __iommu_map_page(struc
 
 static void __iommu_unmap_page(struct device *dev, dma_addr_t dev_addr,
 			       size_t size, enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__iommu_sync_single_for_cpu(dev, dev_addr, size, dir);
 
 	iommu_dma_unmap_page(dev, dev_addr, size, dir, attrs);
@@ -760,11 +760,11 @@ static void __iommu_sync_sg_for_device(s
 
 static int __iommu_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
 				int nelems, enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	bool coherent = is_device_dma_coherent(dev);
 
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__iommu_sync_sg_for_device(dev, sgl, nelems, dir);
 
 	return iommu_dma_map_sg(dev, sgl, nelems,
@@ -774,9 +774,9 @@ static int __iommu_map_sg_attrs(struct d
 static void __iommu_unmap_sg_attrs(struct device *dev,
 				   struct scatterlist *sgl, int nelems,
 				   enum dma_data_direction dir,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
-	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+	if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
 		__iommu_sync_sg_for_cpu(dev, sgl, nelems, dir);
 
 	iommu_dma_unmap_sg(dev, sgl, nelems, dir, attrs);
diff -puN arch/avr32/mm/dma-coherent.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/avr32/mm/dma-coherent.c
--- a/arch/avr32/mm/dma-coherent.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/avr32/mm/dma-coherent.c
@@ -99,7 +99,7 @@ static void __dma_free(struct device *de
 }
 
 static void *avr32_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
+		dma_addr_t *handle, gfp_t gfp, unsigned long attrs)
 {
 	struct page *page;
 	dma_addr_t phys;
@@ -109,7 +109,7 @@ static void *avr32_dma_alloc(struct devi
 		return NULL;
 	phys = page_to_phys(page);
 
-	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs)) {
+	if (attrs & DMA_ATTR_WRITE_COMBINE) {
 		/* Now, map the page into P3 with write-combining turned on */
 		*handle = phys;
 		return __ioremap(phys, size, _PAGE_BUFFER);
@@ -119,11 +119,11 @@ static void *avr32_dma_alloc(struct devi
 }
 
 static void avr32_dma_free(struct device *dev, size_t size,
-		void *cpu_addr, dma_addr_t handle, struct dma_attrs *attrs)
+		void *cpu_addr, dma_addr_t handle, unsigned long attrs)
 {
 	struct page *page;
 
-	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs)) {
+	if (attrs & DMA_ATTR_WRITE_COMBINE) {
 		iounmap(cpu_addr);
 
 		page = phys_to_page(handle);
@@ -142,7 +142,7 @@ static void avr32_dma_free(struct device
 
 static dma_addr_t avr32_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size,
-		enum dma_data_direction direction, struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	void *cpu_addr = page_address(page) + offset;
 
@@ -152,7 +152,7 @@ static dma_addr_t avr32_dma_map_page(str
 
 static int avr32_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
diff -puN arch/blackfin/kernel/dma-mapping.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/blackfin/kernel/dma-mapping.c
--- a/arch/blackfin/kernel/dma-mapping.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/blackfin/kernel/dma-mapping.c
@@ -79,7 +79,7 @@ static void __free_dma_pages(unsigned lo
 }
 
 static void *bfin_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 
@@ -94,7 +94,7 @@ static void *bfin_dma_alloc(struct devic
 }
 
 static void bfin_dma_free(struct device *dev, size_t size, void *vaddr,
-		  dma_addr_t dma_handle, struct dma_attrs *attrs)
+		  dma_addr_t dma_handle, unsigned long attrs)
 {
 	__free_dma_pages((unsigned long)vaddr, get_pages(size));
 }
@@ -111,7 +111,7 @@ EXPORT_SYMBOL(__dma_sync);
 
 static int bfin_dma_map_sg(struct device *dev, struct scatterlist *sg_list,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -139,7 +139,7 @@ static void bfin_dma_sync_sg_for_device(
 
 static dma_addr_t bfin_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	dma_addr_t handle = (dma_addr_t)(page_address(page) + offset);
 
diff -puN arch/c6x/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/c6x/include/asm/dma-mapping.h
--- a/arch/c6x/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/c6x/include/asm/dma-mapping.h
@@ -26,8 +26,8 @@ static inline struct dma_map_ops *get_dm
 
 extern void coherent_mem_init(u32 start, u32 size);
 void *c6x_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
-		gfp_t gfp, struct dma_attrs *attrs);
+		gfp_t gfp, unsigned long attrs);
 void c6x_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs);
+		dma_addr_t dma_handle, unsigned long attrs);
 
 #endif	/* _ASM_C6X_DMA_MAPPING_H */
diff -puN arch/c6x/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/c6x/kernel/dma.c
--- a/arch/c6x/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/c6x/kernel/dma.c
@@ -38,7 +38,7 @@ static void c6x_dma_sync(dma_addr_t hand
 
 static dma_addr_t c6x_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	dma_addr_t handle = virt_to_phys(page_address(page) + offset);
 
@@ -47,13 +47,13 @@ static dma_addr_t c6x_dma_map_page(struc
 }
 
 static void c6x_dma_unmap_page(struct device *dev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir, struct dma_attrs *attrs)
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	c6x_dma_sync(handle, size, dir);
 }
 
 static int c6x_dma_map_sg(struct device *dev, struct scatterlist *sglist,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs)
+		int nents, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -67,8 +67,7 @@ static int c6x_dma_map_sg(struct device
 }
 
 static void c6x_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
-		  int nents, enum dma_data_direction dir,
-		  struct dma_attrs *attrs)
+		  int nents, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
diff -puN arch/c6x/mm/dma-coherent.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/c6x/mm/dma-coherent.c
--- a/arch/c6x/mm/dma-coherent.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/c6x/mm/dma-coherent.c
@@ -74,7 +74,7 @@ static void __free_dma_pages(u32 addr, i
  * virtual and DMA address for that space.
  */
 void *c6x_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
-		gfp_t gfp, struct dma_attrs *attrs)
+		gfp_t gfp, unsigned long attrs)
 {
 	u32 paddr;
 	int order;
@@ -99,7 +99,7 @@ void *c6x_dma_alloc(struct device *dev,
  * Free DMA coherent memory as defined by the above mapping.
  */
 void c6x_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	int order;
 
diff -puN arch/cris/arch-v32/drivers/pci/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/cris/arch-v32/drivers/pci/dma.c
--- a/arch/cris/arch-v32/drivers/pci/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/cris/arch-v32/drivers/pci/dma.c
@@ -17,7 +17,7 @@
 #include <asm/io.h>
 
 static void *v32_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp,  struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 
@@ -37,22 +37,21 @@ static void *v32_dma_alloc(struct device
 }
 
 static void v32_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
 static inline dma_addr_t v32_dma_map_page(struct device *dev,
 		struct page *page, unsigned long offset, size_t size,
-		enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	return page_to_phys(page) + offset;
 }
 
 static inline int v32_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	printk("Map sg\n");
 	return nents;
diff -puN arch/frv/mb93090-mb00/pci-dma-nommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/frv/mb93090-mb00/pci-dma-nommu.c
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -35,7 +35,7 @@ static DEFINE_SPINLOCK(dma_alloc_lock);
 static LIST_HEAD(dma_alloc_list);
 
 static void *frv_dma_alloc(struct device *hwdev, size_t size, dma_addr_t *dma_handle,
-		gfp_t gfp, struct dma_attrs *attrs)
+		gfp_t gfp, unsigned long attrs)
 {
 	struct dma_alloc_record *new;
 	struct list_head *this = &dma_alloc_list;
@@ -86,7 +86,7 @@ static void *frv_dma_alloc(struct device
 }
 
 static void frv_dma_free(struct device *hwdev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	struct dma_alloc_record *rec;
 	unsigned long flags;
@@ -107,7 +107,7 @@ static void frv_dma_free(struct device *
 
 static int frv_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
@@ -124,7 +124,7 @@ static int frv_dma_map_sg(struct device
 
 static dma_addr_t frv_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size,
-		enum dma_data_direction direction, struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	BUG_ON(direction == DMA_NONE);
 	flush_dcache_page(page);
diff -puN arch/frv/mb93090-mb00/pci-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/frv/mb93090-mb00/pci-dma.c
--- a/arch/frv/mb93090-mb00/pci-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/frv/mb93090-mb00/pci-dma.c
@@ -19,8 +19,7 @@
 #include <asm/io.h>
 
 static void *frv_dma_alloc(struct device *hwdev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp,
-		struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 
@@ -32,14 +31,14 @@ static void *frv_dma_alloc(struct device
 }
 
 static void frv_dma_free(struct device *hwdev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	consistent_free(vaddr);
 }
 
 static int frv_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	unsigned long dampr2;
 	void *vaddr;
@@ -69,7 +68,7 @@ static int frv_dma_map_sg(struct device
 
 static dma_addr_t frv_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size,
-		enum dma_data_direction direction, struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	flush_dcache_page(page);
 	return (dma_addr_t) page_to_phys(page) + offset;
diff -puN arch/h8300/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/h8300/kernel/dma.c
--- a/arch/h8300/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
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
diff -puN arch/hexagon/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/hexagon/include/asm/dma-mapping.h
--- a/arch/hexagon/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/hexagon/include/asm/dma-mapping.h
@@ -26,7 +26,6 @@
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-debug.h>
-#include <linux/dma-attrs.h>
 #include <asm/io.h>
 
 struct device;
diff -puN arch/hexagon/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/hexagon/kernel/dma.c
--- a/arch/hexagon/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/hexagon/kernel/dma.c
@@ -51,7 +51,7 @@ static struct gen_pool *coherent_pool;
 
 static void *hexagon_dma_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t flag,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	void *ret;
 
@@ -84,7 +84,7 @@ static void *hexagon_dma_alloc_coherent(
 }
 
 static void hexagon_free_coherent(struct device *dev, size_t size, void *vaddr,
-				  dma_addr_t dma_addr, struct dma_attrs *attrs)
+				  dma_addr_t dma_addr, unsigned long attrs)
 {
 	gen_pool_free(coherent_pool, (unsigned long) vaddr, size);
 }
@@ -105,7 +105,7 @@ static int check_addr(const char *name,
 
 static int hexagon_map_sg(struct device *hwdev, struct scatterlist *sg,
 			  int nents, enum dma_data_direction dir,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
@@ -172,7 +172,7 @@ static inline void dma_sync(void *addr,
 static dma_addr_t hexagon_map_page(struct device *dev, struct page *page,
 				   unsigned long offset, size_t size,
 				   enum dma_data_direction dir,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	dma_addr_t bus = page_to_phys(page) + offset;
 	WARN_ON(size == 0);
diff -puN arch/ia64/hp/common/sba_iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -919,7 +919,7 @@ sba_mark_invalid(struct ioc *ioc, dma_ad
 static dma_addr_t sba_map_page(struct device *dev, struct page *page,
 			       unsigned long poff, size_t size,
 			       enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	struct ioc *ioc;
 	void *addr = page_address(page) + poff;
@@ -1005,7 +1005,7 @@ static dma_addr_t sba_map_page(struct de
 
 static dma_addr_t sba_map_single_attrs(struct device *dev, void *addr,
 				       size_t size, enum dma_data_direction dir,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	return sba_map_page(dev, virt_to_page(addr),
 			    (unsigned long)addr & ~PAGE_MASK, size, dir, attrs);
@@ -1046,7 +1046,7 @@ sba_mark_clean(struct ioc *ioc, dma_addr
  * See Documentation/DMA-API-HOWTO.txt
  */
 static void sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
-			   enum dma_data_direction dir, struct dma_attrs *attrs)
+			   enum dma_data_direction dir, unsigned long attrs)
 {
 	struct ioc *ioc;
 #if DELAYED_RESOURCE_CNT > 0
@@ -1115,7 +1115,7 @@ static void sba_unmap_page(struct device
 }
 
 void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-			    enum dma_data_direction dir, struct dma_attrs *attrs)
+			    enum dma_data_direction dir, unsigned long attrs)
 {
 	sba_unmap_page(dev, iova, size, dir, attrs);
 }
@@ -1130,7 +1130,7 @@ void sba_unmap_single_attrs(struct devic
  */
 static void *
 sba_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t flags, struct dma_attrs *attrs)
+		   gfp_t flags, unsigned long attrs)
 {
 	struct ioc *ioc;
 	void *addr;
@@ -1175,7 +1175,7 @@ sba_alloc_coherent(struct device *dev, s
 	 * device to map single to get an iova mapping.
 	 */
 	*dma_handle = sba_map_single_attrs(&ioc->sac_only_dev->dev, addr,
-					   size, 0, NULL);
+					   size, 0, 0);
 
 	return addr;
 }
@@ -1191,9 +1191,9 @@ sba_alloc_coherent(struct device *dev, s
  * See Documentation/DMA-API-HOWTO.txt
  */
 static void sba_free_coherent(struct device *dev, size_t size, void *vaddr,
-			      dma_addr_t dma_handle, struct dma_attrs *attrs)
+			      dma_addr_t dma_handle, unsigned long attrs)
 {
-	sba_unmap_single_attrs(dev, dma_handle, size, 0, NULL);
+	sba_unmap_single_attrs(dev, dma_handle, size, 0, 0);
 	free_pages((unsigned long) vaddr, get_order(size));
 }
 
@@ -1442,7 +1442,7 @@ sba_coalesce_chunks(struct ioc *ioc, str
 
 static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
 			       int nents, enum dma_data_direction dir,
-			       struct dma_attrs *attrs);
+			       unsigned long attrs);
 /**
  * sba_map_sg - map Scatter/Gather list
  * @dev: instance of PCI owned by the driver that's asking.
@@ -1455,7 +1455,7 @@ static void sba_unmap_sg_attrs(struct de
  */
 static int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist,
 			    int nents, enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	struct ioc *ioc;
 	int coalesced, filled = 0;
@@ -1551,7 +1551,7 @@ static int sba_map_sg_attrs(struct devic
  */
 static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
 			       int nents, enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 #ifdef ASSERT_PDIR_SANITY
 	struct ioc *ioc;
diff -puN arch/ia64/include/asm/machvec.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/ia64/include/asm/machvec.h
--- a/arch/ia64/include/asm/machvec.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/ia64/include/asm/machvec.h
@@ -22,7 +22,6 @@ struct pci_bus;
 struct task_struct;
 struct pci_dev;
 struct msi_desc;
-struct dma_attrs;
 
 typedef void ia64_mv_setup_t (char **);
 typedef void ia64_mv_cpu_init_t (void);
diff -puN arch/ia64/kernel/pci-swiotlb.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/ia64/kernel/pci-swiotlb.c
--- a/arch/ia64/kernel/pci-swiotlb.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/ia64/kernel/pci-swiotlb.c
@@ -16,7 +16,7 @@ EXPORT_SYMBOL(swiotlb);
 
 static void *ia64_swiotlb_alloc_coherent(struct device *dev, size_t size,
 					 dma_addr_t *dma_handle, gfp_t gfp,
-					 struct dma_attrs *attrs)
+					 unsigned long attrs)
 {
 	if (dev->coherent_dma_mask != DMA_BIT_MASK(64))
 		gfp |= GFP_DMA;
@@ -25,7 +25,7 @@ static void *ia64_swiotlb_alloc_coherent
 
 static void ia64_swiotlb_free_coherent(struct device *dev, size_t size,
 				       void *vaddr, dma_addr_t dma_addr,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	swiotlb_free_coherent(dev, size, vaddr, dma_addr);
 }
diff -puN arch/ia64/sn/pci/pci_dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/ia64/sn/pci/pci_dma.c
--- a/arch/ia64/sn/pci/pci_dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/ia64/sn/pci/pci_dma.c
@@ -77,7 +77,7 @@ EXPORT_SYMBOL(sn_dma_set_mask);
  */
 static void *sn_dma_alloc_coherent(struct device *dev, size_t size,
 				   dma_addr_t * dma_handle, gfp_t flags,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	void *cpuaddr;
 	unsigned long phys_addr;
@@ -138,7 +138,7 @@ static void *sn_dma_alloc_coherent(struc
  * any associated IOMMU mappings.
  */
 static void sn_dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-				 dma_addr_t dma_handle, struct dma_attrs *attrs)
+				 dma_addr_t dma_handle, unsigned long attrs)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
@@ -176,21 +176,18 @@ static void sn_dma_free_coherent(struct
 static dma_addr_t sn_dma_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t size,
 				  enum dma_data_direction dir,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	void *cpu_addr = page_address(page) + offset;
 	dma_addr_t dma_addr;
 	unsigned long phys_addr;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
-	int dmabarr;
-
-	dmabarr = dma_get_attr(DMA_ATTR_WRITE_BARRIER, attrs);
 
 	BUG_ON(!dev_is_pci(dev));
 
 	phys_addr = __pa(cpu_addr);
-	if (dmabarr)
+	if (attrs & DMA_ATTR_WRITE_BARRIER)
 		dma_addr = provider->dma_map_consistent(pdev, phys_addr,
 							size, SN_DMA_ADDR_PHYS);
 	else
@@ -218,7 +215,7 @@ static dma_addr_t sn_dma_map_page(struct
  */
 static void sn_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 			      size_t size, enum dma_data_direction dir,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
@@ -240,7 +237,7 @@ static void sn_dma_unmap_page(struct dev
  */
 static void sn_dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
 			    int nhwentries, enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -273,16 +270,13 @@ static void sn_dma_unmap_sg(struct devic
  */
 static int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl,
 			 int nhwentries, enum dma_data_direction dir,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	unsigned long phys_addr;
 	struct scatterlist *saved_sg = sgl, *sg;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 	int i;
-	int dmabarr;
-
-	dmabarr = dma_get_attr(DMA_ATTR_WRITE_BARRIER, attrs);
 
 	BUG_ON(!dev_is_pci(dev));
 
@@ -292,7 +286,7 @@ static int sn_dma_map_sg(struct device *
 	for_each_sg(sgl, sg, nhwentries, i) {
 		dma_addr_t dma_addr;
 		phys_addr = SG_ENT_PHYS_ADDRESS(sg);
-		if (dmabarr)
+		if (attrs & DMA_ATTR_WRITE_BARRIER)
 			dma_addr = provider->dma_map_consistent(pdev,
 								phys_addr,
 								sg->length,
diff -puN arch/m68k/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/m68k/kernel/dma.c
--- a/arch/m68k/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/m68k/kernel/dma.c
@@ -19,7 +19,7 @@
 #if defined(CONFIG_MMU) && !defined(CONFIG_COLDFIRE)
 
 static void *m68k_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
-		gfp_t flag, struct dma_attrs *attrs)
+		gfp_t flag, unsigned long attrs)
 {
 	struct page *page, **map;
 	pgprot_t pgprot;
@@ -62,7 +62,7 @@ static void *m68k_dma_alloc(struct devic
 }
 
 static void m68k_dma_free(struct device *dev, size_t size, void *addr,
-		dma_addr_t handle, struct dma_attrs *attrs)
+		dma_addr_t handle, unsigned long attrs)
 {
 	pr_debug("dma_free_coherent: %p, %x\n", addr, handle);
 	vfree(addr);
@@ -73,7 +73,7 @@ static void m68k_dma_free(struct device
 #include <asm/cacheflush.h>
 
 static void *m68k_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 	/* ignore region specifiers */
@@ -91,7 +91,7 @@ static void *m68k_dma_alloc(struct devic
 }
 
 static void m68k_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	free_pages((unsigned long)vaddr, get_order(size));
 }
@@ -130,7 +130,7 @@ static void m68k_dma_sync_sg_for_device(
 
 static dma_addr_t m68k_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	dma_addr_t handle = page_to_phys(page) + offset;
 
@@ -139,7 +139,7 @@ static dma_addr_t m68k_dma_map_page(stru
 }
 
 static int m68k_dma_map_sg(struct device *dev, struct scatterlist *sglist,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs)
+		int nents, enum dma_data_direction dir, unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
diff -puN arch/metag/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/metag/kernel/dma.c
--- a/arch/metag/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/metag/kernel/dma.c
@@ -172,7 +172,7 @@ out:
  * virtual and bus address for that space.
  */
 static void *metag_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
+		dma_addr_t *handle, gfp_t gfp, unsigned long attrs)
 {
 	struct page *page;
 	struct metag_vm_region *c;
@@ -268,7 +268,7 @@ no_page:
  * free a page as defined by the above mapping.
  */
 static void metag_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	struct metag_vm_region *c;
 	unsigned long flags, addr;
@@ -331,13 +331,13 @@ no_area:
 
 static int metag_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	unsigned long flags, user_size, kern_size;
 	struct metag_vm_region *c;
 	int ret = -ENXIO;
 
-	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs))
+	if (attrs & DMA_ATTR_WRITE_COMBINE)
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	else
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
@@ -482,7 +482,7 @@ static void dma_sync_for_cpu(void *vaddr
 
 static dma_addr_t metag_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size,
-		enum dma_data_direction direction, struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	dma_sync_for_device((void *)(page_to_phys(page) + offset), size,
 			    direction);
@@ -491,14 +491,14 @@ static dma_addr_t metag_dma_map_page(str
 
 static void metag_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 		size_t size, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
 }
 
 static int metag_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -516,7 +516,7 @@ static int metag_dma_map_sg(struct devic
 
 static void metag_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 		int nhwentries, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
diff -puN arch/microblaze/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/microblaze/include/asm/dma-mapping.h
--- a/arch/microblaze/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/microblaze/include/asm/dma-mapping.h
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-debug.h>
-#include <linux/dma-attrs.h>
 #include <asm/io.h>
 #include <asm/cacheflush.h>
 
diff -puN arch/microblaze/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/microblaze/kernel/dma.c
--- a/arch/microblaze/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
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
diff -puN arch/mips/cavium-octeon/dma-octeon.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/mips/cavium-octeon/dma-octeon.c
--- a/arch/mips/cavium-octeon/dma-octeon.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/mips/cavium-octeon/dma-octeon.c
@@ -125,7 +125,7 @@ static phys_addr_t octeon_small_dma_to_p
 
 static dma_addr_t octeon_dma_map_page(struct device *dev, struct page *page,
 	unsigned long offset, size_t size, enum dma_data_direction direction,
-	struct dma_attrs *attrs)
+	unsigned long attrs)
 {
 	dma_addr_t daddr = swiotlb_map_page(dev, page, offset, size,
 					    direction, attrs);
@@ -135,7 +135,7 @@ static dma_addr_t octeon_dma_map_page(st
 }
 
 static int octeon_dma_map_sg(struct device *dev, struct scatterlist *sg,
-	int nents, enum dma_data_direction direction, struct dma_attrs *attrs)
+	int nents, enum dma_data_direction direction, unsigned long attrs)
 {
 	int r = swiotlb_map_sg_attrs(dev, sg, nents, direction, attrs);
 	mb();
@@ -157,7 +157,7 @@ static void octeon_dma_sync_sg_for_devic
 }
 
 static void *octeon_dma_alloc_coherent(struct device *dev, size_t size,
-	dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+	dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 
@@ -189,7 +189,7 @@ static void *octeon_dma_alloc_coherent(s
 }
 
 static void octeon_dma_free_coherent(struct device *dev, size_t size,
-	void *vaddr, dma_addr_t dma_handle, struct dma_attrs *attrs)
+	void *vaddr, dma_addr_t dma_handle, unsigned long attrs)
 {
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
diff -puN arch/mips/loongson64/common/dma-swiotlb.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/mips/loongson64/common/dma-swiotlb.c
--- a/arch/mips/loongson64/common/dma-swiotlb.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/mips/loongson64/common/dma-swiotlb.c
@@ -10,7 +10,7 @@
 #include <dma-coherence.h>
 
 static void *loongson_dma_alloc_coherent(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 
@@ -41,7 +41,7 @@ static void *loongson_dma_alloc_coherent
 }
 
 static void loongson_dma_free_coherent(struct device *dev, size_t size,
-		void *vaddr, dma_addr_t dma_handle, struct dma_attrs *attrs)
+		void *vaddr, dma_addr_t dma_handle, unsigned long attrs)
 {
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
@@ -49,7 +49,7 @@ static void loongson_dma_free_coherent(s
 static dma_addr_t loongson_dma_map_page(struct device *dev, struct page *page,
 				unsigned long offset, size_t size,
 				enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	dma_addr_t daddr = swiotlb_map_page(dev, page, offset, size,
 					dir, attrs);
@@ -59,9 +59,9 @@ static dma_addr_t loongson_dma_map_page(
 
 static int loongson_dma_map_sg(struct device *dev, struct scatterlist *sg,
 				int nents, enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
-	int r = swiotlb_map_sg_attrs(dev, sg, nents, dir, NULL);
+	int r = swiotlb_map_sg_attrs(dev, sg, nents, dir, 0);
 	mb();
 
 	return r;
diff -puN arch/mips/mm/dma-default.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/mips/mm/dma-default.c
--- a/arch/mips/mm/dma-default.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/mips/mm/dma-default.c
@@ -131,7 +131,7 @@ static void *mips_dma_alloc_noncoherent(
 }
 
 static void *mips_dma_alloc_coherent(struct device *dev, size_t size,
-	dma_addr_t * dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+	dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 	struct page *page = NULL;
@@ -141,7 +141,7 @@ static void *mips_dma_alloc_coherent(str
 	 * XXX: seems like the coherent and non-coherent implementations could
 	 * be consolidated.
 	 */
-	if (dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs))
+	if (attrs & DMA_ATTR_NON_CONSISTENT)
 		return mips_dma_alloc_noncoherent(dev, size, dma_handle, gfp);
 
 	gfp = massage_gfp_flags(dev, gfp);
@@ -176,13 +176,13 @@ static void mips_dma_free_noncoherent(st
 }
 
 static void mips_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-	dma_addr_t dma_handle, struct dma_attrs *attrs)
+	dma_addr_t dma_handle, unsigned long attrs)
 {
 	unsigned long addr = (unsigned long) vaddr;
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct page *page = NULL;
 
-	if (dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs)) {
+	if (attrs & DMA_ATTR_NON_CONSISTENT) {
 		mips_dma_free_noncoherent(dev, size, vaddr, dma_handle);
 		return;
 	}
@@ -200,7 +200,7 @@ static void mips_dma_free_coherent(struc
 
 static int mips_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 	void *cpu_addr, dma_addr_t dma_addr, size_t size,
-	struct dma_attrs *attrs)
+	unsigned long attrs)
 {
 	unsigned long user_count = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
@@ -214,7 +214,7 @@ static int mips_dma_mmap(struct device *
 
 	pfn = page_to_pfn(virt_to_page((void *)addr));
 
-	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs))
+	if (attrs & DMA_ATTR_WRITE_COMBINE)
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	else
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
@@ -291,7 +291,7 @@ static inline void __dma_sync(struct pag
 }
 
 static void mips_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
-	size_t size, enum dma_data_direction direction, struct dma_attrs *attrs)
+	size_t size, enum dma_data_direction direction, unsigned long attrs)
 {
 	if (cpu_needs_post_dma_flush(dev))
 		__dma_sync(dma_addr_to_page(dev, dma_addr),
@@ -301,7 +301,7 @@ static void mips_dma_unmap_page(struct d
 }
 
 static int mips_dma_map_sg(struct device *dev, struct scatterlist *sglist,
-	int nents, enum dma_data_direction direction, struct dma_attrs *attrs)
+	int nents, enum dma_data_direction direction, unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
@@ -322,7 +322,7 @@ static int mips_dma_map_sg(struct device
 
 static dma_addr_t mips_dma_map_page(struct device *dev, struct page *page,
 	unsigned long offset, size_t size, enum dma_data_direction direction,
-	struct dma_attrs *attrs)
+	unsigned long attrs)
 {
 	if (!plat_device_is_coherent(dev))
 		__dma_sync(page, offset, size, direction);
@@ -332,7 +332,7 @@ static dma_addr_t mips_dma_map_page(stru
 
 static void mips_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	int nhwentries, enum dma_data_direction direction,
-	struct dma_attrs *attrs)
+	unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
diff -puN arch/mips/netlogic/common/nlm-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/mips/netlogic/common/nlm-dma.c
--- a/arch/mips/netlogic/common/nlm-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/mips/netlogic/common/nlm-dma.c
@@ -45,7 +45,7 @@
 static char *nlm_swiotlb;
 
 static void *nlm_dma_alloc_coherent(struct device *dev, size_t size,
-	dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+	dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
@@ -62,7 +62,7 @@ static void *nlm_dma_alloc_coherent(stru
 }
 
 static void nlm_dma_free_coherent(struct device *dev, size_t size,
-	void *vaddr, dma_addr_t dma_handle, struct dma_attrs *attrs)
+	void *vaddr, dma_addr_t dma_handle, unsigned long attrs)
 {
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
diff -puN arch/mn10300/mm/dma-alloc.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/mn10300/mm/dma-alloc.c
--- a/arch/mn10300/mm/dma-alloc.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/mn10300/mm/dma-alloc.c
@@ -21,7 +21,7 @@
 static unsigned long pci_sram_allocated = 0xbc000000;
 
 static void *mn10300_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	unsigned long addr;
 	void *ret;
@@ -63,7 +63,7 @@ done:
 }
 
 static void mn10300_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	unsigned long addr = (unsigned long) vaddr & ~0x20000000;
 
@@ -75,7 +75,7 @@ static void mn10300_dma_free(struct devi
 
 static int mn10300_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -92,7 +92,7 @@ static int mn10300_dma_map_sg(struct dev
 
 static dma_addr_t mn10300_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size,
-		enum dma_data_direction direction, struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	return page_to_bus(page) + offset;
 }
diff -puN arch/nios2/mm/dma-mapping.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/nios2/mm/dma-mapping.c
--- a/arch/nios2/mm/dma-mapping.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/nios2/mm/dma-mapping.c
@@ -59,7 +59,7 @@ static inline void __dma_sync_for_cpu(vo
 }
 
 static void *nios2_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 
@@ -84,7 +84,7 @@ static void *nios2_dma_alloc(struct devi
 }
 
 static void nios2_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	unsigned long addr = (unsigned long) CAC_ADDR((unsigned long) vaddr);
 
@@ -93,7 +93,7 @@ static void nios2_dma_free(struct device
 
 static int nios2_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int i;
 
@@ -113,7 +113,7 @@ static int nios2_dma_map_sg(struct devic
 static dma_addr_t nios2_dma_map_page(struct device *dev, struct page *page,
 			unsigned long offset, size_t size,
 			enum dma_data_direction direction,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	void *addr = page_address(page) + offset;
 
@@ -123,14 +123,14 @@ static dma_addr_t nios2_dma_map_page(str
 
 static void nios2_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 		size_t size, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	__dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
 }
 
 static void nios2_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 		int nhwentries, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	void *addr;
 	int i;
diff -puN arch/openrisc/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/openrisc/kernel/dma.c
--- a/arch/openrisc/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
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
@@ -101,7 +100,7 @@ or1k_dma_alloc(struct device *dev, size_
 
 	va = (unsigned long)page;
 
-	if (!dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs)) {
+	if ((attrs & DMA_ATTR_NON_CONSISTENT) == 0) {
 		/*
 		 * We need to iterate through the pages, clearing the dcache for
 		 * them and setting the cache-inhibit bit.
@@ -117,7 +116,7 @@ or1k_dma_alloc(struct device *dev, size_
 
 static void
 or1k_dma_free(struct device *dev, size_t size, void *vaddr,
-	      dma_addr_t dma_handle, struct dma_attrs *attrs)
+	      dma_addr_t dma_handle, unsigned long attrs)
 {
 	unsigned long va = (unsigned long)vaddr;
 	struct mm_walk walk = {
@@ -125,7 +124,7 @@ or1k_dma_free(struct device *dev, size_t
 		.mm = &init_mm
 	};
 
-	if (!dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs)) {
+	if ((attrs & DMA_ATTR_NON_CONSISTENT) == 0) {
 		/* walk_page_range shouldn't be able to fail here */
 		WARN_ON(walk_page_range(va, va + size, &walk));
 	}
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
 
diff -puN arch/parisc/kernel/pci-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/parisc/kernel/pci-dma.c
--- a/arch/parisc/kernel/pci-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/parisc/kernel/pci-dma.c
@@ -414,7 +414,7 @@ pcxl_dma_init(void)
 __initcall(pcxl_dma_init);
 
 static void *pa11_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t flag, struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t flag, unsigned long attrs)
 {
 	unsigned long vaddr;
 	unsigned long paddr;
@@ -441,7 +441,7 @@ static void *pa11_dma_alloc(struct devic
 }
 
 static void pa11_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	int order;
 
@@ -454,7 +454,7 @@ static void pa11_dma_free(struct device
 
 static dma_addr_t pa11_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size,
-		enum dma_data_direction direction, struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	void *addr = page_address(page) + offset;
 	BUG_ON(direction == DMA_NONE);
@@ -465,7 +465,7 @@ static dma_addr_t pa11_dma_map_page(stru
 
 static void pa11_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	BUG_ON(direction == DMA_NONE);
 
@@ -484,7 +484,7 @@ static void pa11_dma_unmap_page(struct d
 
 static int pa11_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
@@ -503,7 +503,7 @@ static int pa11_dma_map_sg(struct device
 
 static void pa11_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
@@ -577,11 +577,11 @@ struct dma_map_ops pcxl_dma_ops = {
 };
 
 static void *pcx_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t flag, struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t flag, unsigned long attrs)
 {
 	void *addr;
 
-	if (!dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs))
+	if ((attrs & DMA_ATTR_NON_CONSISTENT) == 0)
 		return NULL;
 
 	addr = (void *)__get_free_pages(flag, get_order(size));
@@ -592,7 +592,7 @@ static void *pcx_dma_alloc(struct device
 }
 
 static void pcx_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t iova, struct dma_attrs *attrs)
+		dma_addr_t iova, unsigned long attrs)
 {
 	free_pages((unsigned long)vaddr, get_order(size));
 	return;
diff -puN arch/powerpc/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -13,7 +13,6 @@
 /* need struct page definitions */
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-debug.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
@@ -25,14 +24,14 @@
 /* Some dma direct funcs must be visible for use in other dma_ops */
 extern void *__dma_direct_alloc_coherent(struct device *dev, size_t size,
 					 dma_addr_t *dma_handle, gfp_t flag,
-					 struct dma_attrs *attrs);
+					 unsigned long attrs);
 extern void __dma_direct_free_coherent(struct device *dev, size_t size,
 				       void *vaddr, dma_addr_t dma_handle,
-				       struct dma_attrs *attrs);
+				       unsigned long attrs);
 extern int dma_direct_mmap_coherent(struct device *dev,
 				    struct vm_area_struct *vma,
 				    void *cpu_addr, dma_addr_t handle,
-				    size_t size, struct dma_attrs *attrs);
+				    size_t size, unsigned long attrs);
 
 #ifdef CONFIG_NOT_COHERENT_CACHE
 /*
diff -puN arch/powerpc/include/asm/iommu.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/include/asm/iommu.h
--- a/arch/powerpc/include/asm/iommu.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/include/asm/iommu.h
@@ -53,7 +53,7 @@ struct iommu_table_ops {
 			long index, long npages,
 			unsigned long uaddr,
 			enum dma_data_direction direction,
-			struct dma_attrs *attrs);
+			unsigned long attrs);
 #ifdef CONFIG_IOMMU_API
 	/*
 	 * Exchanges existing TCE with new TCE plus direction bits;
@@ -248,12 +248,12 @@ extern int ppc_iommu_map_sg(struct devic
 			    struct scatterlist *sglist, int nelems,
 			    unsigned long mask,
 			    enum dma_data_direction direction,
-			    struct dma_attrs *attrs);
+			    unsigned long attrs);
 extern void ppc_iommu_unmap_sg(struct iommu_table *tbl,
 			       struct scatterlist *sglist,
 			       int nelems,
 			       enum dma_data_direction direction,
-			       struct dma_attrs *attrs);
+			       unsigned long attrs);
 
 extern void *iommu_alloc_coherent(struct device *dev, struct iommu_table *tbl,
 				  size_t size, dma_addr_t *dma_handle,
@@ -264,10 +264,10 @@ extern dma_addr_t iommu_map_page(struct
 				 struct page *page, unsigned long offset,
 				 size_t size, unsigned long mask,
 				 enum dma_data_direction direction,
-				 struct dma_attrs *attrs);
+				 unsigned long attrs);
 extern void iommu_unmap_page(struct iommu_table *tbl, dma_addr_t dma_handle,
 			     size_t size, enum dma_data_direction direction,
-			     struct dma_attrs *attrs);
+			     unsigned long attrs);
 
 extern void iommu_init_early_pSeries(void);
 extern void iommu_init_early_dart(struct pci_controller_ops *controller_ops);
diff -puN arch/powerpc/kernel/dma-iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/kernel/dma-iommu.c
--- a/arch/powerpc/kernel/dma-iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/kernel/dma-iommu.c
@@ -18,7 +18,7 @@
  */
 static void *dma_iommu_alloc_coherent(struct device *dev, size_t size,
 				      dma_addr_t *dma_handle, gfp_t flag,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	return iommu_alloc_coherent(dev, get_iommu_table_base(dev), size,
 				    dma_handle, dev->coherent_dma_mask, flag,
@@ -27,7 +27,7 @@ static void *dma_iommu_alloc_coherent(st
 
 static void dma_iommu_free_coherent(struct device *dev, size_t size,
 				    void *vaddr, dma_addr_t dma_handle,
-				    struct dma_attrs *attrs)
+				    unsigned long attrs)
 {
 	iommu_free_coherent(get_iommu_table_base(dev), size, vaddr, dma_handle);
 }
@@ -40,7 +40,7 @@ static void dma_iommu_free_coherent(stru
 static dma_addr_t dma_iommu_map_page(struct device *dev, struct page *page,
 				     unsigned long offset, size_t size,
 				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	return iommu_map_page(dev, get_iommu_table_base(dev), page, offset,
 			      size, device_to_mask(dev), direction, attrs);
@@ -49,7 +49,7 @@ static dma_addr_t dma_iommu_map_page(str
 
 static void dma_iommu_unmap_page(struct device *dev, dma_addr_t dma_handle,
 				 size_t size, enum dma_data_direction direction,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	iommu_unmap_page(get_iommu_table_base(dev), dma_handle, size, direction,
 			 attrs);
@@ -58,7 +58,7 @@ static void dma_iommu_unmap_page(struct
 
 static int dma_iommu_map_sg(struct device *dev, struct scatterlist *sglist,
 			    int nelems, enum dma_data_direction direction,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	return ppc_iommu_map_sg(dev, get_iommu_table_base(dev), sglist, nelems,
 				device_to_mask(dev), direction, attrs);
@@ -66,7 +66,7 @@ static int dma_iommu_map_sg(struct devic
 
 static void dma_iommu_unmap_sg(struct device *dev, struct scatterlist *sglist,
 		int nelems, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	ppc_iommu_unmap_sg(get_iommu_table_base(dev), sglist, nelems,
 			   direction, attrs);
diff -puN arch/powerpc/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/kernel/dma.c
--- a/arch/powerpc/kernel/dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/kernel/dma.c
@@ -64,7 +64,7 @@ static int dma_direct_dma_supported(stru
 
 void *__dma_direct_alloc_coherent(struct device *dev, size_t size,
 				  dma_addr_t *dma_handle, gfp_t flag,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	void *ret;
 #ifdef CONFIG_NOT_COHERENT_CACHE
@@ -121,7 +121,7 @@ void *__dma_direct_alloc_coherent(struct
 
 void __dma_direct_free_coherent(struct device *dev, size_t size,
 				void *vaddr, dma_addr_t dma_handle,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 #ifdef CONFIG_NOT_COHERENT_CACHE
 	__dma_free_coherent(size, vaddr);
@@ -132,7 +132,7 @@ void __dma_direct_free_coherent(struct d
 
 static void *dma_direct_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	struct iommu_table *iommu;
 
@@ -156,7 +156,7 @@ static void *dma_direct_alloc_coherent(s
 
 static void dma_direct_free_coherent(struct device *dev, size_t size,
 				     void *vaddr, dma_addr_t dma_handle,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	struct iommu_table *iommu;
 
@@ -177,7 +177,7 @@ static void dma_direct_free_coherent(str
 
 int dma_direct_mmap_coherent(struct device *dev, struct vm_area_struct *vma,
 			     void *cpu_addr, dma_addr_t handle, size_t size,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	unsigned long pfn;
 
@@ -195,7 +195,7 @@ int dma_direct_mmap_coherent(struct devi
 
 static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 			     int nents, enum dma_data_direction direction,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -211,7 +211,7 @@ static int dma_direct_map_sg(struct devi
 
 static void dma_direct_unmap_sg(struct device *dev, struct scatterlist *sg,
 				int nents, enum dma_data_direction direction,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 }
 
@@ -232,7 +232,7 @@ static inline dma_addr_t dma_direct_map_
 					     unsigned long offset,
 					     size_t size,
 					     enum dma_data_direction dir,
-					     struct dma_attrs *attrs)
+					     unsigned long attrs)
 {
 	BUG_ON(dir == DMA_NONE);
 	__dma_sync_page(page, offset, size, dir);
@@ -243,7 +243,7 @@ static inline void dma_direct_unmap_page
 					 dma_addr_t dma_address,
 					 size_t size,
 					 enum dma_data_direction direction,
-					 struct dma_attrs *attrs)
+					 unsigned long attrs)
 {
 }
 
diff -puN arch/powerpc/kernel/ibmebus.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/kernel/ibmebus.c
--- a/arch/powerpc/kernel/ibmebus.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/kernel/ibmebus.c
@@ -65,7 +65,7 @@ static void *ibmebus_alloc_coherent(stru
 				    size_t size,
 				    dma_addr_t *dma_handle,
 				    gfp_t flag,
-				    struct dma_attrs *attrs)
+				    unsigned long attrs)
 {
 	void *mem;
 
@@ -78,7 +78,7 @@ static void *ibmebus_alloc_coherent(stru
 static void ibmebus_free_coherent(struct device *dev,
 				  size_t size, void *vaddr,
 				  dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	kfree(vaddr);
 }
@@ -88,7 +88,7 @@ static dma_addr_t ibmebus_map_page(struc
 				   unsigned long offset,
 				   size_t size,
 				   enum dma_data_direction direction,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	return (dma_addr_t)(page_address(page) + offset);
 }
@@ -97,7 +97,7 @@ static void ibmebus_unmap_page(struct de
 			       dma_addr_t dma_addr,
 			       size_t size,
 			       enum dma_data_direction direction,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	return;
 }
@@ -105,7 +105,7 @@ static void ibmebus_unmap_page(struct de
 static int ibmebus_map_sg(struct device *dev,
 			  struct scatterlist *sgl,
 			  int nents, enum dma_data_direction direction,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -121,7 +121,7 @@ static int ibmebus_map_sg(struct device
 static void ibmebus_unmap_sg(struct device *dev,
 			     struct scatterlist *sg,
 			     int nents, enum dma_data_direction direction,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	return;
 }
diff -puN arch/powerpc/kernel/iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/kernel/iommu.c
@@ -307,7 +307,7 @@ static dma_addr_t iommu_alloc(struct dev
 			      void *page, unsigned int npages,
 			      enum dma_data_direction direction,
 			      unsigned long mask, unsigned int align_order,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	unsigned long entry;
 	dma_addr_t ret = DMA_ERROR_CODE;
@@ -431,7 +431,7 @@ static void iommu_free(struct iommu_tabl
 int ppc_iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 		     struct scatterlist *sglist, int nelems,
 		     unsigned long mask, enum dma_data_direction direction,
-		     struct dma_attrs *attrs)
+		     unsigned long attrs)
 {
 	dma_addr_t dma_next = 0, dma_addr;
 	struct scatterlist *s, *outs, *segstart;
@@ -574,7 +574,7 @@ int ppc_iommu_map_sg(struct device *dev,
 
 void ppc_iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 			int nelems, enum dma_data_direction direction,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	struct scatterlist *sg;
 
@@ -753,7 +753,7 @@ void iommu_free_table(struct iommu_table
 dma_addr_t iommu_map_page(struct device *dev, struct iommu_table *tbl,
 			  struct page *page, unsigned long offset, size_t size,
 			  unsigned long mask, enum dma_data_direction direction,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	dma_addr_t dma_handle = DMA_ERROR_CODE;
 	void *vaddr;
@@ -790,7 +790,7 @@ dma_addr_t iommu_map_page(struct device
 
 void iommu_unmap_page(struct iommu_table *tbl, dma_addr_t dma_handle,
 		      size_t size, enum dma_data_direction direction,
-		      struct dma_attrs *attrs)
+		      unsigned long attrs)
 {
 	unsigned int npages;
 
@@ -845,7 +845,7 @@ void *iommu_alloc_coherent(struct device
 	nio_pages = size >> tbl->it_page_shift;
 	io_order = get_iommu_order(size, tbl);
 	mapping = iommu_alloc(dev, tbl, ret, nio_pages, DMA_BIDIRECTIONAL,
-			      mask >> tbl->it_page_shift, io_order, NULL);
+			      mask >> tbl->it_page_shift, io_order, 0);
 	if (mapping == DMA_ERROR_CODE) {
 		free_pages((unsigned long)ret, order);
 		return NULL;
diff -puN arch/powerpc/kernel/vio.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/kernel/vio.c
@@ -482,7 +482,7 @@ static void vio_cmo_balance(struct work_
 
 static void *vio_dma_iommu_alloc_coherent(struct device *dev, size_t size,
 					  dma_addr_t *dma_handle, gfp_t flag,
-					  struct dma_attrs *attrs)
+					  unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 	void *ret;
@@ -503,7 +503,7 @@ static void *vio_dma_iommu_alloc_coheren
 
 static void vio_dma_iommu_free_coherent(struct device *dev, size_t size,
 					void *vaddr, dma_addr_t dma_handle,
-					struct dma_attrs *attrs)
+					unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 
@@ -515,7 +515,7 @@ static void vio_dma_iommu_free_coherent(
 static dma_addr_t vio_dma_iommu_map_page(struct device *dev, struct page *page,
                                          unsigned long offset, size_t size,
                                          enum dma_data_direction direction,
-                                         struct dma_attrs *attrs)
+                                         unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct iommu_table *tbl;
@@ -539,7 +539,7 @@ static dma_addr_t vio_dma_iommu_map_page
 static void vio_dma_iommu_unmap_page(struct device *dev, dma_addr_t dma_handle,
 				     size_t size,
 				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct iommu_table *tbl;
@@ -552,7 +552,7 @@ static void vio_dma_iommu_unmap_page(str
 
 static int vio_dma_iommu_map_sg(struct device *dev, struct scatterlist *sglist,
                                 int nelems, enum dma_data_direction direction,
-                                struct dma_attrs *attrs)
+                                unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct iommu_table *tbl;
@@ -588,7 +588,7 @@ static int vio_dma_iommu_map_sg(struct d
 static void vio_dma_iommu_unmap_sg(struct device *dev,
 		struct scatterlist *sglist, int nelems,
 		enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct iommu_table *tbl;
diff -puN arch/powerpc/platforms/cell/iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/cell/iommu.c
--- a/arch/powerpc/platforms/cell/iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/cell/iommu.c
@@ -166,7 +166,7 @@ static void invalidate_tce_cache(struct
 
 static int tce_build_cell(struct iommu_table *tbl, long index, long npages,
 		unsigned long uaddr, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int i;
 	unsigned long *io_pte, base_pte;
@@ -193,7 +193,7 @@ static int tce_build_cell(struct iommu_t
 	base_pte = CBE_IOPTE_PP_W | CBE_IOPTE_PP_R | CBE_IOPTE_M |
 		CBE_IOPTE_SO_RW | (window->ioid & CBE_IOPTE_IOID_Mask);
 #endif
-	if (unlikely(dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs)))
+	if (unlikely(attrs & DMA_ATTR_WEAK_ORDERING))
 		base_pte &= ~CBE_IOPTE_SO_RW;
 
 	io_pte = (unsigned long *)tbl->it_base + (index - tbl->it_offset);
@@ -526,7 +526,7 @@ cell_iommu_setup_window(struct cbe_iommu
 
 	__set_bit(0, window->table.it_map);
 	tce_build_cell(&window->table, window->table.it_offset, 1,
-		       (unsigned long)iommu->pad_page, DMA_TO_DEVICE, NULL);
+		       (unsigned long)iommu->pad_page, DMA_TO_DEVICE, 0);
 
 	return window;
 }
@@ -572,7 +572,7 @@ static struct iommu_table *cell_get_iomm
 
 static void *dma_fixed_alloc_coherent(struct device *dev, size_t size,
 				      dma_addr_t *dma_handle, gfp_t flag,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	if (iommu_fixed_is_weak)
 		return iommu_alloc_coherent(dev, cell_get_iommu_table(dev),
@@ -586,7 +586,7 @@ static void *dma_fixed_alloc_coherent(st
 
 static void dma_fixed_free_coherent(struct device *dev, size_t size,
 				    void *vaddr, dma_addr_t dma_handle,
-				    struct dma_attrs *attrs)
+				    unsigned long attrs)
 {
 	if (iommu_fixed_is_weak)
 		iommu_free_coherent(cell_get_iommu_table(dev), size, vaddr,
@@ -598,9 +598,9 @@ static void dma_fixed_free_coherent(stru
 static dma_addr_t dma_fixed_map_page(struct device *dev, struct page *page,
 				     unsigned long offset, size_t size,
 				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
-	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
+	if (iommu_fixed_is_weak == (attrs & DMA_ATTR_WEAK_ORDERING))
 		return dma_direct_ops.map_page(dev, page, offset, size,
 					       direction, attrs);
 	else
@@ -611,9 +611,9 @@ static dma_addr_t dma_fixed_map_page(str
 
 static void dma_fixed_unmap_page(struct device *dev, dma_addr_t dma_addr,
 				 size_t size, enum dma_data_direction direction,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
-	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
+	if (iommu_fixed_is_weak == (attrs & DMA_ATTR_WEAK_ORDERING))
 		dma_direct_ops.unmap_page(dev, dma_addr, size, direction,
 					  attrs);
 	else
@@ -623,9 +623,9 @@ static void dma_fixed_unmap_page(struct
 
 static int dma_fixed_map_sg(struct device *dev, struct scatterlist *sg,
 			   int nents, enum dma_data_direction direction,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
-	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
+	if (iommu_fixed_is_weak == (attrs & DMA_ATTR_WEAK_ORDERING))
 		return dma_direct_ops.map_sg(dev, sg, nents, direction, attrs);
 	else
 		return ppc_iommu_map_sg(dev, cell_get_iommu_table(dev), sg,
@@ -635,9 +635,9 @@ static int dma_fixed_map_sg(struct devic
 
 static void dma_fixed_unmap_sg(struct device *dev, struct scatterlist *sg,
 			       int nents, enum dma_data_direction direction,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
-	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
+	if (iommu_fixed_is_weak == (attrs & DMA_ATTR_WEAK_ORDERING))
 		dma_direct_ops.unmap_sg(dev, sg, nents, direction, attrs);
 	else
 		ppc_iommu_unmap_sg(cell_get_iommu_table(dev), sg, nents,
@@ -1162,7 +1162,7 @@ static int __init setup_iommu_fixed(char
 	pciep = of_find_node_by_type(NULL, "pcie-endpoint");
 
 	if (strcmp(str, "weak") == 0 || (pciep && strcmp(str, "strong") != 0))
-		iommu_fixed_is_weak = 1;
+		iommu_fixed_is_weak = DMA_ATTR_WEAK_ORDERING;
 
 	of_node_put(pciep);
 
diff -puN arch/powerpc/platforms/pasemi/iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/pasemi/iommu.c
--- a/arch/powerpc/platforms/pasemi/iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/pasemi/iommu.c
@@ -88,7 +88,7 @@ static int iommu_table_iobmap_inited;
 static int iobmap_build(struct iommu_table *tbl, long index,
 			 long npages, unsigned long uaddr,
 			 enum dma_data_direction direction,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	u32 *ip;
 	u32 rpn;
diff -puN arch/powerpc/platforms/powernv/npu-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/powernv/npu-dma.c
--- a/arch/powerpc/platforms/powernv/npu-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/powernv/npu-dma.c
@@ -73,7 +73,7 @@ EXPORT_SYMBOL(pnv_pci_get_npu_dev);
 
 static void *dma_npu_alloc(struct device *dev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flag,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	NPU_DMA_OP_UNSUPPORTED();
 	return NULL;
@@ -81,7 +81,7 @@ static void *dma_npu_alloc(struct device
 
 static void dma_npu_free(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	NPU_DMA_OP_UNSUPPORTED();
 }
@@ -89,7 +89,7 @@ static void dma_npu_free(struct device *
 static dma_addr_t dma_npu_map_page(struct device *dev, struct page *page,
 				   unsigned long offset, size_t size,
 				   enum dma_data_direction direction,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	NPU_DMA_OP_UNSUPPORTED();
 	return 0;
@@ -97,7 +97,7 @@ static dma_addr_t dma_npu_map_page(struc
 
 static int dma_npu_map_sg(struct device *dev, struct scatterlist *sglist,
 			  int nelems, enum dma_data_direction direction,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	NPU_DMA_OP_UNSUPPORTED();
 	return 0;
diff -puN arch/powerpc/platforms/powernv/pci-ioda.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/powernv/pci-ioda.c
--- a/arch/powerpc/platforms/powernv/pci-ioda.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1806,7 +1806,7 @@ static void pnv_pci_p7ioc_tce_invalidate
 static int pnv_ioda1_tce_build(struct iommu_table *tbl, long index,
 		long npages, unsigned long uaddr,
 		enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int ret = pnv_tce_build(tbl, index, npages, uaddr, direction,
 			attrs);
@@ -1950,7 +1950,7 @@ static void pnv_pci_ioda2_tce_invalidate
 static int pnv_ioda2_tce_build(struct iommu_table *tbl, long index,
 		long npages, unsigned long uaddr,
 		enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int ret = pnv_tce_build(tbl, index, npages, uaddr, direction,
 			attrs);
diff -puN arch/powerpc/platforms/powernv/pci.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/powernv/pci.c
--- a/arch/powerpc/platforms/powernv/pci.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/powernv/pci.c
@@ -704,7 +704,7 @@ static __be64 *pnv_tce(struct iommu_tabl
 
 int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 		unsigned long uaddr, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	u64 proto_tce = iommu_direction_to_tce_perm(direction);
 	u64 rpn = __pa(uaddr) >> tbl->it_page_shift;
diff -puN arch/powerpc/platforms/powernv/pci.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/powernv/pci.h
--- a/arch/powerpc/platforms/powernv/pci.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/powernv/pci.h
@@ -181,7 +181,7 @@ struct pnv_phb {
 extern struct pci_ops pnv_pci_ops;
 extern int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 		unsigned long uaddr, enum dma_data_direction direction,
-		struct dma_attrs *attrs);
+		unsigned long attrs);
 extern void pnv_tce_free(struct iommu_table *tbl, long index, long npages);
 extern int pnv_tce_xchg(struct iommu_table *tbl, long index,
 		unsigned long *hpa, enum dma_data_direction *direction);
diff -puN arch/powerpc/platforms/ps3/system-bus.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/ps3/system-bus.c
--- a/arch/powerpc/platforms/ps3/system-bus.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/ps3/system-bus.c
@@ -516,7 +516,7 @@ core_initcall(ps3_system_bus_init);
  */
 static void * ps3_alloc_coherent(struct device *_dev, size_t size,
 				 dma_addr_t *dma_handle, gfp_t flag,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	int result;
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
@@ -553,7 +553,7 @@ clean_none:
 }
 
 static void ps3_free_coherent(struct device *_dev, size_t size, void *vaddr,
-			      dma_addr_t dma_handle, struct dma_attrs *attrs)
+			      dma_addr_t dma_handle, unsigned long attrs)
 {
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
 
@@ -569,7 +569,7 @@ static void ps3_free_coherent(struct dev
 
 static dma_addr_t ps3_sb_map_page(struct device *_dev, struct page *page,
 	unsigned long offset, size_t size, enum dma_data_direction direction,
-	struct dma_attrs *attrs)
+	unsigned long attrs)
 {
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
 	int result;
@@ -592,7 +592,7 @@ static dma_addr_t ps3_sb_map_page(struct
 static dma_addr_t ps3_ioc0_map_page(struct device *_dev, struct page *page,
 				    unsigned long offset, size_t size,
 				    enum dma_data_direction direction,
-				    struct dma_attrs *attrs)
+				    unsigned long attrs)
 {
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
 	int result;
@@ -626,7 +626,7 @@ static dma_addr_t ps3_ioc0_map_page(stru
 }
 
 static void ps3_unmap_page(struct device *_dev, dma_addr_t dma_addr,
-	size_t size, enum dma_data_direction direction, struct dma_attrs *attrs)
+	size_t size, enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
 	int result;
@@ -640,7 +640,7 @@ static void ps3_unmap_page(struct device
 }
 
 static int ps3_sb_map_sg(struct device *_dev, struct scatterlist *sgl,
-	int nents, enum dma_data_direction direction, struct dma_attrs *attrs)
+	int nents, enum dma_data_direction direction, unsigned long attrs)
 {
 #if defined(CONFIG_PS3_DYNAMIC_DMA)
 	BUG_ON("do");
@@ -670,14 +670,14 @@ static int ps3_sb_map_sg(struct device *
 static int ps3_ioc0_map_sg(struct device *_dev, struct scatterlist *sg,
 			   int nents,
 			   enum dma_data_direction direction,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	BUG();
 	return 0;
 }
 
 static void ps3_sb_unmap_sg(struct device *_dev, struct scatterlist *sg,
-	int nents, enum dma_data_direction direction, struct dma_attrs *attrs)
+	int nents, enum dma_data_direction direction, unsigned long attrs)
 {
 #if defined(CONFIG_PS3_DYNAMIC_DMA)
 	BUG_ON("do");
@@ -686,7 +686,7 @@ static void ps3_sb_unmap_sg(struct devic
 
 static void ps3_ioc0_unmap_sg(struct device *_dev, struct scatterlist *sg,
 			    int nents, enum dma_data_direction direction,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	BUG();
 }
diff -puN arch/powerpc/platforms/pseries/iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/pseries/iommu.c
--- a/arch/powerpc/platforms/pseries/iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/pseries/iommu.c
@@ -123,7 +123,7 @@ static void iommu_pseries_free_group(str
 static int tce_build_pSeries(struct iommu_table *tbl, long index,
 			      long npages, unsigned long uaddr,
 			      enum dma_data_direction direction,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	u64 proto_tce;
 	__be64 *tcep, *tces;
@@ -173,7 +173,7 @@ static void tce_freemulti_pSeriesLP(stru
 static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
 				long npages, unsigned long uaddr,
 				enum dma_data_direction direction,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	u64 rc = 0;
 	u64 proto_tce, tce;
@@ -216,7 +216,7 @@ static DEFINE_PER_CPU(__be64 *, tce_page
 static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 				     long npages, unsigned long uaddr,
 				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	u64 rc = 0;
 	u64 proto_tce;
diff -puN arch/powerpc/sysdev/dart_iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/sysdev/dart_iommu.c
--- a/arch/powerpc/sysdev/dart_iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/sysdev/dart_iommu.c
@@ -185,7 +185,7 @@ static void dart_flush(struct iommu_tabl
 static int dart_build(struct iommu_table *tbl, long index,
 		       long npages, unsigned long uaddr,
 		       enum dma_data_direction direction,
-		       struct dma_attrs *attrs)
+		       unsigned long attrs)
 {
 	unsigned int *dp, *orig_dp;
 	unsigned int rpn;
diff -puN arch/s390/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/s390/include/asm/dma-mapping.h
--- a/arch/s390/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/s390/include/asm/dma-mapping.h
@@ -5,7 +5,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-debug.h>
 #include <linux/io.h>
 
diff -puN arch/s390/pci/pci_dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/s390/pci/pci_dma.c
--- a/arch/s390/pci/pci_dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/s390/pci/pci_dma.c
@@ -286,7 +286,7 @@ static inline void zpci_err_dma(unsigned
 static dma_addr_t s390_dma_map_pages(struct device *dev, struct page *page,
 				     unsigned long offset, size_t size,
 				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
 	unsigned long nr_pages, iommu_page_index;
@@ -332,7 +332,7 @@ out_err:
 
 static void s390_dma_unmap_pages(struct device *dev, dma_addr_t dma_addr,
 				 size_t size, enum dma_data_direction direction,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
 	unsigned long iommu_page_index;
@@ -355,7 +355,7 @@ static void s390_dma_unmap_pages(struct
 
 static void *s390_dma_alloc(struct device *dev, size_t size,
 			    dma_addr_t *dma_handle, gfp_t flag,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
 	struct page *page;
@@ -370,7 +370,7 @@ static void *s390_dma_alloc(struct devic
 	pa = page_to_phys(page);
 	memset((void *) pa, 0, size);
 
-	map = s390_dma_map_pages(dev, page, 0, size, DMA_BIDIRECTIONAL, NULL);
+	map = s390_dma_map_pages(dev, page, 0, size, DMA_BIDIRECTIONAL, 0);
 	if (dma_mapping_error(dev, map)) {
 		free_pages(pa, get_order(size));
 		return NULL;
@@ -384,19 +384,19 @@ static void *s390_dma_alloc(struct devic
 
 static void s390_dma_free(struct device *dev, size_t size,
 			  void *pa, dma_addr_t dma_handle,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
 
 	size = PAGE_ALIGN(size);
 	atomic64_sub(size / PAGE_SIZE, &zdev->allocated_pages);
-	s390_dma_unmap_pages(dev, dma_handle, size, DMA_BIDIRECTIONAL, NULL);
+	s390_dma_unmap_pages(dev, dma_handle, size, DMA_BIDIRECTIONAL, 0);
 	free_pages((unsigned long) pa, get_order(size));
 }
 
 static int s390_dma_map_sg(struct device *dev, struct scatterlist *sg,
 			   int nr_elements, enum dma_data_direction dir,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	int mapped_elements = 0;
 	struct scatterlist *s;
@@ -405,7 +405,7 @@ static int s390_dma_map_sg(struct device
 	for_each_sg(sg, s, nr_elements, i) {
 		struct page *page = sg_page(s);
 		s->dma_address = s390_dma_map_pages(dev, page, s->offset,
-						    s->length, dir, NULL);
+						    s->length, dir, 0);
 		if (!dma_mapping_error(dev, s->dma_address)) {
 			s->dma_length = s->length;
 			mapped_elements++;
@@ -419,7 +419,7 @@ unmap:
 	for_each_sg(sg, s, mapped_elements, i) {
 		if (s->dma_address)
 			s390_dma_unmap_pages(dev, s->dma_address, s->dma_length,
-					     dir, NULL);
+					     dir, 0);
 		s->dma_address = 0;
 		s->dma_length = 0;
 	}
@@ -429,13 +429,14 @@ unmap:
 
 static void s390_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 			      int nr_elements, enum dma_data_direction dir,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
 
 	for_each_sg(sg, s, nr_elements, i) {
-		s390_dma_unmap_pages(dev, s->dma_address, s->dma_length, dir, NULL);
+		s390_dma_unmap_pages(dev, s->dma_address, s->dma_length, dir,
+				     0);
 		s->dma_address = 0;
 		s->dma_length = 0;
 	}
diff -puN arch/sh/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/sh/include/asm/dma-mapping.h
--- a/arch/sh/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sh/include/asm/dma-mapping.h
@@ -17,9 +17,9 @@ void dma_cache_sync(struct device *dev,
 /* arch/sh/mm/consistent.c */
 extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag,
-					struct dma_attrs *attrs);
+					unsigned long attrs);
 extern void dma_generic_free_coherent(struct device *dev, size_t size,
 				      void *vaddr, dma_addr_t dma_handle,
-				      struct dma_attrs *attrs);
+				      unsigned long attrs);
 
 #endif /* __ASM_SH_DMA_MAPPING_H */
diff -puN arch/sh/kernel/dma-nommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/sh/kernel/dma-nommu.c
--- a/arch/sh/kernel/dma-nommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sh/kernel/dma-nommu.c
@@ -13,7 +13,7 @@
 static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
 				 unsigned long offset, size_t size,
 				 enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	dma_addr_t addr = page_to_phys(page) + offset;
 
@@ -25,7 +25,7 @@ static dma_addr_t nommu_map_page(struct
 
 static int nommu_map_sg(struct device *dev, struct scatterlist *sg,
 			int nents, enum dma_data_direction dir,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
diff -puN arch/sh/mm/consistent.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/sh/mm/consistent.c
--- a/arch/sh/mm/consistent.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sh/mm/consistent.c
@@ -34,7 +34,7 @@ fs_initcall(dma_init);
 
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_handle, gfp_t gfp,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	void *ret, *ret_nocache;
 	int order = get_order(size);
@@ -66,7 +66,7 @@ void *dma_generic_alloc_coherent(struct
 
 void dma_generic_free_coherent(struct device *dev, size_t size,
 			       void *vaddr, dma_addr_t dma_handle,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	int order = get_order(size);
 	unsigned long pfn = dma_handle >> PAGE_SHIFT;
diff -puN arch/sparc/kernel/iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/sparc/kernel/iommu.c
--- a/arch/sparc/kernel/iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sparc/kernel/iommu.c
@@ -196,7 +196,7 @@ static inline void iommu_free_ctx(struct
 
 static void *dma_4u_alloc_coherent(struct device *dev, size_t size,
 				   dma_addr_t *dma_addrp, gfp_t gfp,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	unsigned long order, first_page;
 	struct iommu *iommu;
@@ -245,7 +245,7 @@ static void *dma_4u_alloc_coherent(struc
 
 static void dma_4u_free_coherent(struct device *dev, size_t size,
 				 void *cpu, dma_addr_t dvma,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	struct iommu *iommu;
 	unsigned long order, npages;
@@ -263,7 +263,7 @@ static void dma_4u_free_coherent(struct
 static dma_addr_t dma_4u_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t sz,
 				  enum dma_data_direction direction,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -385,7 +385,7 @@ do_flush_sync:
 
 static void dma_4u_unmap_page(struct device *dev, dma_addr_t bus_addr,
 			      size_t sz, enum dma_data_direction direction,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -431,7 +431,7 @@ static void dma_4u_unmap_page(struct dev
 
 static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 			 int nelems, enum dma_data_direction direction,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	struct scatterlist *s, *outs, *segstart;
 	unsigned long flags, handle, prot, ctx;
@@ -607,7 +607,7 @@ static unsigned long fetch_sg_ctx(struct
 
 static void dma_4u_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			    int nelems, enum dma_data_direction direction,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	unsigned long flags, ctx;
 	struct scatterlist *sg;
diff -puN arch/sparc/kernel/ioport.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/sparc/kernel/ioport.c
--- a/arch/sparc/kernel/ioport.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sparc/kernel/ioport.c
@@ -260,7 +260,7 @@ EXPORT_SYMBOL(sbus_set_sbus64);
  */
 static void *sbus_alloc_coherent(struct device *dev, size_t len,
 				 dma_addr_t *dma_addrp, gfp_t gfp,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	struct platform_device *op = to_platform_device(dev);
 	unsigned long len_total = PAGE_ALIGN(len);
@@ -315,7 +315,7 @@ err_nopages:
 }
 
 static void sbus_free_coherent(struct device *dev, size_t n, void *p,
-			       dma_addr_t ba, struct dma_attrs *attrs)
+			       dma_addr_t ba, unsigned long attrs)
 {
 	struct resource *res;
 	struct page *pgv;
@@ -355,7 +355,7 @@ static void sbus_free_coherent(struct de
 static dma_addr_t sbus_map_page(struct device *dev, struct page *page,
 				unsigned long offset, size_t len,
 				enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	void *va = page_address(page) + offset;
 
@@ -371,20 +371,20 @@ static dma_addr_t sbus_map_page(struct d
 }
 
 static void sbus_unmap_page(struct device *dev, dma_addr_t ba, size_t n,
-			    enum dma_data_direction dir, struct dma_attrs *attrs)
+			    enum dma_data_direction dir, unsigned long attrs)
 {
 	mmu_release_scsi_one(dev, ba, n);
 }
 
 static int sbus_map_sg(struct device *dev, struct scatterlist *sg, int n,
-		       enum dma_data_direction dir, struct dma_attrs *attrs)
+		       enum dma_data_direction dir, unsigned long attrs)
 {
 	mmu_get_scsi_sgl(dev, sg, n);
 	return n;
 }
 
 static void sbus_unmap_sg(struct device *dev, struct scatterlist *sg, int n,
-			  enum dma_data_direction dir, struct dma_attrs *attrs)
+			  enum dma_data_direction dir, unsigned long attrs)
 {
 	mmu_release_scsi_sgl(dev, sg, n);
 }
@@ -429,7 +429,7 @@ arch_initcall(sparc_register_ioport);
  */
 static void *pci32_alloc_coherent(struct device *dev, size_t len,
 				  dma_addr_t *pba, gfp_t gfp,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	unsigned long len_total = PAGE_ALIGN(len);
 	void *va;
@@ -482,7 +482,7 @@ err_nopages:
  * past this call are illegal.
  */
 static void pci32_free_coherent(struct device *dev, size_t n, void *p,
-				dma_addr_t ba, struct dma_attrs *attrs)
+				dma_addr_t ba, unsigned long attrs)
 {
 	struct resource *res;
 
@@ -518,14 +518,14 @@ static void pci32_free_coherent(struct d
 static dma_addr_t pci32_map_page(struct device *dev, struct page *page,
 				 unsigned long offset, size_t size,
 				 enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	/* IIep is write-through, not flushing. */
 	return page_to_phys(page) + offset;
 }
 
 static void pci32_unmap_page(struct device *dev, dma_addr_t ba, size_t size,
-			     enum dma_data_direction dir, struct dma_attrs *attrs)
+			     enum dma_data_direction dir, unsigned long attrs)
 {
 	if (dir != PCI_DMA_TODEVICE)
 		dma_make_coherent(ba, PAGE_ALIGN(size));
@@ -548,7 +548,7 @@ static void pci32_unmap_page(struct devi
  */
 static int pci32_map_sg(struct device *device, struct scatterlist *sgl,
 			int nents, enum dma_data_direction dir,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int n;
@@ -567,7 +567,7 @@ static int pci32_map_sg(struct device *d
  */
 static void pci32_unmap_sg(struct device *dev, struct scatterlist *sgl,
 			   int nents, enum dma_data_direction dir,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int n;
diff -puN arch/sparc/kernel/pci_sun4v.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/sparc/kernel/pci_sun4v.c
--- a/arch/sparc/kernel/pci_sun4v.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sparc/kernel/pci_sun4v.c
@@ -130,7 +130,7 @@ static inline long iommu_batch_end(void)
 
 static void *dma_4v_alloc_coherent(struct device *dev, size_t size,
 				   dma_addr_t *dma_addrp, gfp_t gfp,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	unsigned long flags, order, first_page, npages, n;
 	struct iommu *iommu;
@@ -213,7 +213,7 @@ static void dma_4v_iommu_demap(void *dem
 }
 
 static void dma_4v_free_coherent(struct device *dev, size_t size, void *cpu,
-				 dma_addr_t dvma, struct dma_attrs *attrs)
+				 dma_addr_t dvma, unsigned long attrs)
 {
 	struct pci_pbm_info *pbm;
 	struct iommu *iommu;
@@ -235,7 +235,7 @@ static void dma_4v_free_coherent(struct
 static dma_addr_t dma_4v_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t sz,
 				  enum dma_data_direction direction,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	struct iommu *iommu;
 	unsigned long flags, npages, oaddr;
@@ -294,7 +294,7 @@ iommu_map_fail:
 
 static void dma_4v_unmap_page(struct device *dev, dma_addr_t bus_addr,
 			      size_t sz, enum dma_data_direction direction,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	struct pci_pbm_info *pbm;
 	struct iommu *iommu;
@@ -322,7 +322,7 @@ static void dma_4v_unmap_page(struct dev
 
 static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 			 int nelems, enum dma_data_direction direction,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	struct scatterlist *s, *outs, *segstart;
 	unsigned long flags, handle, prot;
@@ -466,7 +466,7 @@ iommu_map_failed:
 
 static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			    int nelems, enum dma_data_direction direction,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	struct pci_pbm_info *pbm;
 	struct scatterlist *sg;
diff -puN arch/tile/kernel/pci-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/tile/kernel/pci-dma.c
--- a/arch/tile/kernel/pci-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/tile/kernel/pci-dma.c
@@ -34,7 +34,7 @@
 
 static void *tile_dma_alloc_coherent(struct device *dev, size_t size,
 				     dma_addr_t *dma_handle, gfp_t gfp,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	u64 dma_mask = (dev && dev->coherent_dma_mask) ?
 		dev->coherent_dma_mask : DMA_BIT_MASK(32);
@@ -78,7 +78,7 @@ static void *tile_dma_alloc_coherent(str
  */
 static void tile_dma_free_coherent(struct device *dev, size_t size,
 				   void *vaddr, dma_addr_t dma_handle,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	homecache_free_pages((unsigned long)vaddr, get_order(size));
 }
@@ -202,7 +202,7 @@ static void __dma_complete_pa_range(dma_
 
 static int tile_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 			   int nents, enum dma_data_direction direction,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -224,7 +224,7 @@ static int tile_dma_map_sg(struct device
 
 static void tile_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			      int nents, enum dma_data_direction direction,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -240,7 +240,7 @@ static void tile_dma_unmap_sg(struct dev
 static dma_addr_t tile_dma_map_page(struct device *dev, struct page *page,
 				    unsigned long offset, size_t size,
 				    enum dma_data_direction direction,
-				    struct dma_attrs *attrs)
+				    unsigned long attrs)
 {
 	BUG_ON(!valid_dma_direction(direction));
 
@@ -252,7 +252,7 @@ static dma_addr_t tile_dma_map_page(stru
 
 static void tile_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 				size_t size, enum dma_data_direction direction,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	BUG_ON(!valid_dma_direction(direction));
 
@@ -343,7 +343,7 @@ EXPORT_SYMBOL(tile_dma_map_ops);
 
 static void *tile_pci_dma_alloc_coherent(struct device *dev, size_t size,
 					 dma_addr_t *dma_handle, gfp_t gfp,
-					 struct dma_attrs *attrs)
+					 unsigned long attrs)
 {
 	int node = dev_to_node(dev);
 	int order = get_order(size);
@@ -368,14 +368,14 @@ static void *tile_pci_dma_alloc_coherent
  */
 static void tile_pci_dma_free_coherent(struct device *dev, size_t size,
 				       void *vaddr, dma_addr_t dma_handle,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	homecache_free_pages((unsigned long)vaddr, get_order(size));
 }
 
 static int tile_pci_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 			       int nents, enum dma_data_direction direction,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -400,7 +400,7 @@ static int tile_pci_dma_map_sg(struct de
 static void tile_pci_dma_unmap_sg(struct device *dev,
 				  struct scatterlist *sglist, int nents,
 				  enum dma_data_direction direction,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -416,7 +416,7 @@ static void tile_pci_dma_unmap_sg(struct
 static dma_addr_t tile_pci_dma_map_page(struct device *dev, struct page *page,
 					unsigned long offset, size_t size,
 					enum dma_data_direction direction,
-					struct dma_attrs *attrs)
+					unsigned long attrs)
 {
 	BUG_ON(!valid_dma_direction(direction));
 
@@ -429,7 +429,7 @@ static dma_addr_t tile_pci_dma_map_page(
 static void tile_pci_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 				    size_t size,
 				    enum dma_data_direction direction,
-				    struct dma_attrs *attrs)
+				    unsigned long attrs)
 {
 	BUG_ON(!valid_dma_direction(direction));
 
@@ -531,7 +531,7 @@ EXPORT_SYMBOL(gx_pci_dma_map_ops);
 #ifdef CONFIG_SWIOTLB
 static void *tile_swiotlb_alloc_coherent(struct device *dev, size_t size,
 					 dma_addr_t *dma_handle, gfp_t gfp,
-					 struct dma_attrs *attrs)
+					 unsigned long attrs)
 {
 	gfp |= GFP_DMA;
 	return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
@@ -539,7 +539,7 @@ static void *tile_swiotlb_alloc_coherent
 
 static void tile_swiotlb_free_coherent(struct device *dev, size_t size,
 				       void *vaddr, dma_addr_t dma_addr,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	swiotlb_free_coherent(dev, size, vaddr, dma_addr);
 }
diff -puN arch/unicore32/mm/dma-swiotlb.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/unicore32/mm/dma-swiotlb.c
--- a/arch/unicore32/mm/dma-swiotlb.c~dma-mapping-use-unsigned-long-for-dma_attrs
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
diff -puN arch/x86/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -9,7 +9,6 @@
 #include <linux/kmemcheck.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-debug.h>
-#include <linux/dma-attrs.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
 #include <linux/dma-contiguous.h>
@@ -48,11 +47,11 @@ extern int dma_supported(struct device *
 
 extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag,
-					struct dma_attrs *attrs);
+					unsigned long attrs);
 
 extern void dma_generic_free_coherent(struct device *dev, size_t size,
 				      void *vaddr, dma_addr_t dma_addr,
-				      struct dma_attrs *attrs);
+				      unsigned long attrs);
 
 #ifdef CONFIG_X86_DMA_REMAP /* Platform code defines bridge-specific code */
 extern bool dma_capable(struct device *dev, dma_addr_t addr, size_t size);
diff -puN arch/x86/include/asm/swiotlb.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/include/asm/swiotlb.h
--- a/arch/x86/include/asm/swiotlb.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/include/asm/swiotlb.h
@@ -31,9 +31,9 @@ static inline void dma_mark_clean(void *
 
 extern void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags,
-					struct dma_attrs *attrs);
+					unsigned long attrs);
 extern void x86_swiotlb_free_coherent(struct device *dev, size_t size,
 					void *vaddr, dma_addr_t dma_addr,
-					struct dma_attrs *attrs);
+					unsigned long attrs);
 
 #endif /* _ASM_X86_SWIOTLB_H */
diff -puN arch/x86/include/asm/xen/page-coherent.h~dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/include/asm/xen/page-coherent.h
--- a/arch/x86/include/asm/xen/page-coherent.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/include/asm/xen/page-coherent.h
@@ -2,12 +2,11 @@
 #define _ASM_X86_XEN_PAGE_COHERENT_H
 
 #include <asm/page.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-mapping.h>
 
 static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
 		dma_addr_t *dma_handle, gfp_t flags,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	void *vstart = (void*)__get_free_pages(flags, get_order(size));
 	*dma_handle = virt_to_phys(vstart);
@@ -16,18 +15,18 @@ static inline void *xen_alloc_coherent_p
 
 static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
 		void *cpu_addr, dma_addr_t dma_handle,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	free_pages((unsigned long) cpu_addr, get_order(size));
 }
 
 static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
 	     dma_addr_t dev_addr, unsigned long offset, size_t size,
-	     enum dma_data_direction dir, struct dma_attrs *attrs) { }
+	     enum dma_data_direction dir, unsigned long attrs) { }
 
 static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs) { }
+		unsigned long attrs) { }
 
 static inline void xen_dma_sync_single_for_cpu(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir) { }
diff -puN arch/x86/kernel/amd_gart_64.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/kernel/amd_gart_64.c
--- a/arch/x86/kernel/amd_gart_64.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/kernel/amd_gart_64.c
@@ -241,7 +241,7 @@ static dma_addr_t dma_map_area(struct de
 static dma_addr_t gart_map_page(struct device *dev, struct page *page,
 				unsigned long offset, size_t size,
 				enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	unsigned long bus;
 	phys_addr_t paddr = page_to_phys(page) + offset;
@@ -263,7 +263,7 @@ static dma_addr_t gart_map_page(struct d
  */
 static void gart_unmap_page(struct device *dev, dma_addr_t dma_addr,
 			    size_t size, enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	unsigned long iommu_page;
 	int npages;
@@ -285,7 +285,7 @@ static void gart_unmap_page(struct devic
  * Wrapper for pci_unmap_single working with scatterlists.
  */
 static void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-			  enum dma_data_direction dir, struct dma_attrs *attrs)
+			  enum dma_data_direction dir, unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
@@ -293,7 +293,7 @@ static void gart_unmap_sg(struct device
 	for_each_sg(sg, s, nents, i) {
 		if (!s->dma_length || !s->length)
 			break;
-		gart_unmap_page(dev, s->dma_address, s->dma_length, dir, NULL);
+		gart_unmap_page(dev, s->dma_address, s->dma_length, dir, 0);
 	}
 }
 
@@ -315,7 +315,7 @@ static int dma_map_sg_nonforce(struct de
 			addr = dma_map_area(dev, addr, s->length, dir, 0);
 			if (addr == bad_dma_addr) {
 				if (i > 0)
-					gart_unmap_sg(dev, sg, i, dir, NULL);
+					gart_unmap_sg(dev, sg, i, dir, 0);
 				nents = 0;
 				sg[0].dma_length = 0;
 				break;
@@ -386,7 +386,7 @@ dma_map_cont(struct device *dev, struct
  * Merge chunks that have page aligned sizes into a continuous mapping.
  */
 static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		       enum dma_data_direction dir, struct dma_attrs *attrs)
+		       enum dma_data_direction dir, unsigned long attrs)
 {
 	struct scatterlist *s, *ps, *start_sg, *sgmap;
 	int need = 0, nextneed, i, out, start;
@@ -456,7 +456,7 @@ static int gart_map_sg(struct device *de
 
 error:
 	flush_gart();
-	gart_unmap_sg(dev, sg, out, dir, NULL);
+	gart_unmap_sg(dev, sg, out, dir, 0);
 
 	/* When it was forced or merged try again in a dumb way */
 	if (force_iommu || iommu_merge) {
@@ -476,7 +476,7 @@ error:
 /* allocate and map a coherent mapping */
 static void *
 gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
-		    gfp_t flag, struct dma_attrs *attrs)
+		    gfp_t flag, unsigned long attrs)
 {
 	dma_addr_t paddr;
 	unsigned long align_mask;
@@ -508,9 +508,9 @@ gart_alloc_coherent(struct device *dev,
 /* free a coherent mapping */
 static void
 gart_free_coherent(struct device *dev, size_t size, void *vaddr,
-		   dma_addr_t dma_addr, struct dma_attrs *attrs)
+		   dma_addr_t dma_addr, unsigned long attrs)
 {
-	gart_unmap_page(dev, dma_addr, size, DMA_BIDIRECTIONAL, NULL);
+	gart_unmap_page(dev, dma_addr, size, DMA_BIDIRECTIONAL, 0);
 	dma_generic_free_coherent(dev, size, vaddr, dma_addr, attrs);
 }
 
diff -puN arch/x86/kernel/pci-calgary_64.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -340,7 +340,7 @@ static inline struct iommu_table *find_i
 
 static void calgary_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			     int nelems,enum dma_data_direction dir,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -364,7 +364,7 @@ static void calgary_unmap_sg(struct devi
 
 static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 			  int nelems, enum dma_data_direction dir,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -396,7 +396,7 @@ static int calgary_map_sg(struct device
 
 	return nelems;
 error:
-	calgary_unmap_sg(dev, sg, nelems, dir, NULL);
+	calgary_unmap_sg(dev, sg, nelems, dir, 0);
 	for_each_sg(sg, s, nelems, i) {
 		sg->dma_address = DMA_ERROR_CODE;
 		sg->dma_length = 0;
@@ -407,7 +407,7 @@ error:
 static dma_addr_t calgary_map_page(struct device *dev, struct page *page,
 				   unsigned long offset, size_t size,
 				   enum dma_data_direction dir,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	void *vaddr = page_address(page) + offset;
 	unsigned long uaddr;
@@ -422,7 +422,7 @@ static dma_addr_t calgary_map_page(struc
 
 static void calgary_unmap_page(struct device *dev, dma_addr_t dma_addr,
 			       size_t size, enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
@@ -432,7 +432,7 @@ static void calgary_unmap_page(struct de
 }
 
 static void* calgary_alloc_coherent(struct device *dev, size_t size,
-	dma_addr_t *dma_handle, gfp_t flag, struct dma_attrs *attrs)
+	dma_addr_t *dma_handle, gfp_t flag, unsigned long attrs)
 {
 	void *ret = NULL;
 	dma_addr_t mapping;
@@ -466,7 +466,7 @@ error:
 
 static void calgary_free_coherent(struct device *dev, size_t size,
 				  void *vaddr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	unsigned int npages;
 	struct iommu_table *tbl = find_iommu_table(dev);
diff -puN arch/x86/kernel/pci-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/kernel/pci-dma.c
@@ -77,7 +77,7 @@ void __init pci_iommu_alloc(void)
 }
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t flag,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	unsigned long dma_mask;
 	struct page *page;
@@ -120,7 +120,7 @@ again:
 }
 
 void dma_generic_free_coherent(struct device *dev, size_t size, void *vaddr,
-			       dma_addr_t dma_addr, struct dma_attrs *attrs)
+			       dma_addr_t dma_addr, unsigned long attrs)
 {
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct page *page = virt_to_page(vaddr);
diff -puN arch/x86/kernel/pci-nommu.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/kernel/pci-nommu.c
--- a/arch/x86/kernel/pci-nommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/kernel/pci-nommu.c
@@ -28,7 +28,7 @@ check_addr(char *name, struct device *hw
 static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
 				 unsigned long offset, size_t size,
 				 enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	dma_addr_t bus = page_to_phys(page) + offset;
 	WARN_ON(size == 0);
@@ -55,7 +55,7 @@ static dma_addr_t nommu_map_page(struct
  */
 static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 			int nents, enum dma_data_direction dir,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
diff -puN arch/x86/kernel/pci-swiotlb.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/kernel/pci-swiotlb.c
--- a/arch/x86/kernel/pci-swiotlb.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/kernel/pci-swiotlb.c
@@ -16,7 +16,7 @@ int swiotlb __read_mostly;
 
 void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags,
-					struct dma_attrs *attrs)
+					unsigned long attrs)
 {
 	void *vaddr;
 
@@ -37,7 +37,7 @@ void *x86_swiotlb_alloc_coherent(struct
 
 void x86_swiotlb_free_coherent(struct device *dev, size_t size,
 				      void *vaddr, dma_addr_t dma_addr,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	if (is_swiotlb_buffer(dma_to_phys(dev, dma_addr)))
 		swiotlb_free_coherent(dev, size, vaddr, dma_addr);
diff -puN arch/x86/pci/sta2x11-fixup.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/pci/sta2x11-fixup.c
--- a/arch/x86/pci/sta2x11-fixup.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/pci/sta2x11-fixup.c
@@ -169,7 +169,7 @@ static void *sta2x11_swiotlb_alloc_coher
 					    size_t size,
 					    dma_addr_t *dma_handle,
 					    gfp_t flags,
-					    struct dma_attrs *attrs)
+					    unsigned long attrs)
 {
 	void *vaddr;
 
diff -puN arch/x86/pci/vmd.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/pci/vmd.c
--- a/arch/x86/pci/vmd.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/pci/vmd.c
@@ -274,14 +274,14 @@ static struct dma_map_ops *vmd_dma_ops(s
 }
 
 static void *vmd_alloc(struct device *dev, size_t size, dma_addr_t *addr,
-		       gfp_t flag, struct dma_attrs *attrs)
+		       gfp_t flag, unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->alloc(to_vmd_dev(dev), size, addr, flag,
 				       attrs);
 }
 
 static void vmd_free(struct device *dev, size_t size, void *vaddr,
-		     dma_addr_t addr, struct dma_attrs *attrs)
+		     dma_addr_t addr, unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->free(to_vmd_dev(dev), size, vaddr, addr,
 				      attrs);
@@ -289,7 +289,7 @@ static void vmd_free(struct device *dev,
 
 static int vmd_mmap(struct device *dev, struct vm_area_struct *vma,
 		    void *cpu_addr, dma_addr_t addr, size_t size,
-		    struct dma_attrs *attrs)
+		    unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->mmap(to_vmd_dev(dev), vma, cpu_addr, addr,
 				      size, attrs);
@@ -297,7 +297,7 @@ static int vmd_mmap(struct device *dev,
 
 static int vmd_get_sgtable(struct device *dev, struct sg_table *sgt,
 			   void *cpu_addr, dma_addr_t addr, size_t size,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->get_sgtable(to_vmd_dev(dev), sgt, cpu_addr,
 					     addr, size, attrs);
@@ -306,26 +306,26 @@ static int vmd_get_sgtable(struct device
 static dma_addr_t vmd_map_page(struct device *dev, struct page *page,
 			       unsigned long offset, size_t size,
 			       enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->map_page(to_vmd_dev(dev), page, offset, size,
 					  dir, attrs);
 }
 
 static void vmd_unmap_page(struct device *dev, dma_addr_t addr, size_t size,
-			   enum dma_data_direction dir, struct dma_attrs *attrs)
+			   enum dma_data_direction dir, unsigned long attrs)
 {
 	vmd_dma_ops(dev)->unmap_page(to_vmd_dev(dev), addr, size, dir, attrs);
 }
 
 static int vmd_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		      enum dma_data_direction dir, struct dma_attrs *attrs)
+		      enum dma_data_direction dir, unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->map_sg(to_vmd_dev(dev), sg, nents, dir, attrs);
 }
 
 static void vmd_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-			 enum dma_data_direction dir, struct dma_attrs *attrs)
+			 enum dma_data_direction dir, unsigned long attrs)
 {
 	vmd_dma_ops(dev)->unmap_sg(to_vmd_dev(dev), sg, nents, dir, attrs);
 }
diff -puN arch/xtensa/kernel/pci-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs arch/xtensa/kernel/pci-dma.c
--- a/arch/xtensa/kernel/pci-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/xtensa/kernel/pci-dma.c
@@ -142,7 +142,7 @@ static void xtensa_sync_sg_for_device(st
 
 static void *xtensa_dma_alloc(struct device *dev, size_t size,
 			      dma_addr_t *handle, gfp_t flag,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	unsigned long ret;
 	unsigned long uncached = 0;
@@ -171,7 +171,7 @@ static void *xtensa_dma_alloc(struct dev
 }
 
 static void xtensa_dma_free(struct device *hwdev, size_t size, void *vaddr,
-			    dma_addr_t dma_handle, struct dma_attrs *attrs)
+			    dma_addr_t dma_handle, unsigned long attrs)
 {
 	unsigned long addr = (unsigned long)vaddr +
 		XCHAL_KSEG_CACHED_VADDR - XCHAL_KSEG_BYPASS_VADDR;
@@ -185,7 +185,7 @@ static void xtensa_dma_free(struct devic
 static dma_addr_t xtensa_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t size,
 				  enum dma_data_direction dir,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	dma_addr_t dma_handle = page_to_phys(page) + offset;
 
@@ -195,14 +195,14 @@ static dma_addr_t xtensa_map_page(struct
 
 static void xtensa_unmap_page(struct device *dev, dma_addr_t dma_handle,
 			      size_t size, enum dma_data_direction dir,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	xtensa_sync_single_for_cpu(dev, dma_handle, size, dir);
 }
 
 static int xtensa_map_sg(struct device *dev, struct scatterlist *sg,
 			 int nents, enum dma_data_direction dir,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
@@ -217,7 +217,7 @@ static int xtensa_map_sg(struct device *
 static void xtensa_unmap_sg(struct device *dev,
 			    struct scatterlist *sg, int nents,
 			    enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
diff -puN drivers/gpu/drm/exynos/exynos_drm_fbdev.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/exynos/exynos_drm_fbdev.c
--- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
@@ -52,7 +52,7 @@ static int exynos_drm_fb_mmap(struct fb_
 
 	ret = dma_mmap_attrs(to_dma_dev(helper->dev), vma, exynos_gem->cookie,
 			     exynos_gem->dma_addr, exynos_gem->size,
-			     &exynos_gem->dma_attrs);
+			     exynos_gem->dma_attrs);
 	if (ret < 0) {
 		DRM_ERROR("failed to mmap.\n");
 		return ret;
diff -puN drivers/gpu/drm/exynos/exynos_drm_g2d.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/exynos/exynos_drm_g2d.c
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -17,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/dma-mapping.h>
-#include <linux/dma-attrs.h>
 #include <linux/of.h>
 
 #include <drm/drmP.h>
@@ -235,7 +234,7 @@ struct g2d_data {
 	struct mutex			cmdlist_mutex;
 	dma_addr_t			cmdlist_pool;
 	void				*cmdlist_pool_virt;
-	struct dma_attrs		cmdlist_dma_attrs;
+	unsigned long			cmdlist_dma_attrs;
 
 	/* runqueue*/
 	struct g2d_runqueue_node	*runqueue_node;
@@ -256,13 +255,12 @@ static int g2d_init_cmdlist(struct g2d_d
 	int ret;
 	struct g2d_buf_info *buf_info;
 
-	init_dma_attrs(&g2d->cmdlist_dma_attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &g2d->cmdlist_dma_attrs);
+	g2d->cmdlist_dma_attrs = DMA_ATTR_WRITE_COMBINE;
 
 	g2d->cmdlist_pool_virt = dma_alloc_attrs(to_dma_dev(subdrv->drm_dev),
 						G2D_CMDLIST_POOL_SIZE,
 						&g2d->cmdlist_pool, GFP_KERNEL,
-						&g2d->cmdlist_dma_attrs);
+						g2d->cmdlist_dma_attrs);
 	if (!g2d->cmdlist_pool_virt) {
 		dev_err(dev, "failed to allocate dma memory\n");
 		return -ENOMEM;
@@ -295,7 +293,7 @@ static int g2d_init_cmdlist(struct g2d_d
 err:
 	dma_free_attrs(to_dma_dev(subdrv->drm_dev), G2D_CMDLIST_POOL_SIZE,
 			g2d->cmdlist_pool_virt,
-			g2d->cmdlist_pool, &g2d->cmdlist_dma_attrs);
+			g2d->cmdlist_pool, g2d->cmdlist_dma_attrs);
 	return ret;
 }
 
@@ -309,7 +307,7 @@ static void g2d_fini_cmdlist(struct g2d_
 		dma_free_attrs(to_dma_dev(subdrv->drm_dev),
 				G2D_CMDLIST_POOL_SIZE,
 				g2d->cmdlist_pool_virt,
-				g2d->cmdlist_pool, &g2d->cmdlist_dma_attrs);
+				g2d->cmdlist_pool, g2d->cmdlist_dma_attrs);
 	}
 }
 
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/exynos/exynos_drm_gem.c
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -24,7 +24,7 @@
 static int exynos_drm_alloc_buf(struct exynos_drm_gem *exynos_gem)
 {
 	struct drm_device *dev = exynos_gem->base.dev;
-	enum dma_attr attr;
+	unsigned long attr;
 	unsigned int nr_pages;
 	struct sg_table sgt;
 	int ret = -ENOMEM;
@@ -34,7 +34,7 @@ static int exynos_drm_alloc_buf(struct e
 		return 0;
 	}
 
-	init_dma_attrs(&exynos_gem->dma_attrs);
+	exynos_gem->dma_attrs = 0;
 
 	/*
 	 * if EXYNOS_BO_CONTIG, fully physically contiguous memory
@@ -42,7 +42,7 @@ static int exynos_drm_alloc_buf(struct e
 	 * as possible.
 	 */
 	if (!(exynos_gem->flags & EXYNOS_BO_NONCONTIG))
-		dma_set_attr(DMA_ATTR_FORCE_CONTIGUOUS, &exynos_gem->dma_attrs);
+		exynos_gem->dma_attrs |= DMA_ATTR_FORCE_CONTIGUOUS;
 
 	/*
 	 * if EXYNOS_BO_WC or EXYNOS_BO_NONCACHABLE, writecombine mapping
@@ -54,8 +54,8 @@ static int exynos_drm_alloc_buf(struct e
 	else
 		attr = DMA_ATTR_NON_CONSISTENT;
 
-	dma_set_attr(attr, &exynos_gem->dma_attrs);
-	dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &exynos_gem->dma_attrs);
+	exynos_gem->dma_attrs |= attr;
+	exynos_gem->dma_attrs |= DMA_ATTR_NO_KERNEL_MAPPING;
 
 	nr_pages = exynos_gem->size >> PAGE_SHIFT;
 
@@ -67,7 +67,7 @@ static int exynos_drm_alloc_buf(struct e
 
 	exynos_gem->cookie = dma_alloc_attrs(to_dma_dev(dev), exynos_gem->size,
 					     &exynos_gem->dma_addr, GFP_KERNEL,
-					     &exynos_gem->dma_attrs);
+					     exynos_gem->dma_attrs);
 	if (!exynos_gem->cookie) {
 		DRM_ERROR("failed to allocate buffer.\n");
 		goto err_free;
@@ -75,7 +75,7 @@ static int exynos_drm_alloc_buf(struct e
 
 	ret = dma_get_sgtable_attrs(to_dma_dev(dev), &sgt, exynos_gem->cookie,
 				    exynos_gem->dma_addr, exynos_gem->size,
-				    &exynos_gem->dma_attrs);
+				    exynos_gem->dma_attrs);
 	if (ret < 0) {
 		DRM_ERROR("failed to get sgtable.\n");
 		goto err_dma_free;
@@ -99,7 +99,7 @@ err_sgt_free:
 	sg_free_table(&sgt);
 err_dma_free:
 	dma_free_attrs(to_dma_dev(dev), exynos_gem->size, exynos_gem->cookie,
-		       exynos_gem->dma_addr, &exynos_gem->dma_attrs);
+		       exynos_gem->dma_addr, exynos_gem->dma_attrs);
 err_free:
 	drm_free_large(exynos_gem->pages);
 
@@ -120,7 +120,7 @@ static void exynos_drm_free_buf(struct e
 
 	dma_free_attrs(to_dma_dev(dev), exynos_gem->size, exynos_gem->cookie,
 			(dma_addr_t)exynos_gem->dma_addr,
-			&exynos_gem->dma_attrs);
+			exynos_gem->dma_attrs);
 
 	drm_free_large(exynos_gem->pages);
 }
@@ -346,7 +346,7 @@ static int exynos_drm_gem_mmap_buffer(st
 
 	ret = dma_mmap_attrs(to_dma_dev(drm_dev), vma, exynos_gem->cookie,
 			     exynos_gem->dma_addr, exynos_gem->size,
-			     &exynos_gem->dma_attrs);
+			     exynos_gem->dma_attrs);
 	if (ret < 0) {
 		DRM_ERROR("failed to mmap.\n");
 		return ret;
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.h~dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/exynos/exynos_drm_gem.h
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.h
@@ -50,7 +50,7 @@ struct exynos_drm_gem {
 	void			*cookie;
 	void __iomem		*kvaddr;
 	dma_addr_t		dma_addr;
-	struct dma_attrs	dma_attrs;
+	unsigned long		dma_attrs;
 	struct page		**pages;
 	struct sg_table		*sgt;
 };
diff -puN drivers/gpu/drm/mediatek/mtk_drm_gem.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/mediatek/mtk_drm_gem.c
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -54,15 +54,14 @@ struct mtk_drm_gem_obj *mtk_drm_gem_crea
 
 	obj = &mtk_gem->base;
 
-	init_dma_attrs(&mtk_gem->dma_attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &mtk_gem->dma_attrs);
+	mtk_gem->dma_attrs = DMA_ATTR_WRITE_COMBINE;
 
 	if (!alloc_kmap)
-		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &mtk_gem->dma_attrs);
+		mtk_gem->dma_attrs |= DMA_ATTR_NO_KERNEL_MAPPING;
 
 	mtk_gem->cookie = dma_alloc_attrs(priv->dma_dev, obj->size,
 					  &mtk_gem->dma_addr, GFP_KERNEL,
-					  &mtk_gem->dma_attrs);
+					  mtk_gem->dma_attrs);
 	if (!mtk_gem->cookie) {
 		DRM_ERROR("failed to allocate %zx byte dma buffer", obj->size);
 		ret = -ENOMEM;
@@ -93,7 +92,7 @@ void mtk_drm_gem_free_object(struct drm_
 		drm_prime_gem_destroy(obj, mtk_gem->sg);
 	else
 		dma_free_attrs(priv->dma_dev, obj->size, mtk_gem->cookie,
-			       mtk_gem->dma_addr, &mtk_gem->dma_attrs);
+			       mtk_gem->dma_addr, mtk_gem->dma_attrs);
 
 	/* release file pointer to gem object. */
 	drm_gem_object_release(obj);
@@ -173,7 +172,7 @@ static int mtk_drm_gem_object_mmap(struc
 	vma->vm_pgoff = 0;
 
 	ret = dma_mmap_attrs(priv->dma_dev, vma, mtk_gem->cookie,
-			     mtk_gem->dma_addr, obj->size, &mtk_gem->dma_attrs);
+			     mtk_gem->dma_addr, obj->size, mtk_gem->dma_attrs);
 	if (ret)
 		drm_gem_vm_close(vma);
 
@@ -224,7 +223,7 @@ struct sg_table *mtk_gem_prime_get_sg_ta
 
 	ret = dma_get_sgtable_attrs(priv->dma_dev, sgt, mtk_gem->cookie,
 				    mtk_gem->dma_addr, obj->size,
-				    &mtk_gem->dma_attrs);
+				    mtk_gem->dma_attrs);
 	if (ret) {
 		DRM_ERROR("failed to allocate sgt, %d\n", ret);
 		kfree(sgt);
diff -puN drivers/gpu/drm/mediatek/mtk_drm_gem.h~dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/mediatek/mtk_drm_gem.h
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/mediatek/mtk_drm_gem.h
@@ -35,7 +35,7 @@ struct mtk_drm_gem_obj {
 	void			*cookie;
 	void			*kvaddr;
 	dma_addr_t		dma_addr;
-	struct dma_attrs	dma_attrs;
+	unsigned long		dma_attrs;
 	struct sg_table		*sg;
 };
 
diff -puN drivers/gpu/drm/msm/msm_drv.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/msm/msm_drv.c
--- a/drivers/gpu/drm/msm/msm_drv.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/msm/msm_drv.c
@@ -238,11 +238,10 @@ static int msm_drm_uninit(struct device
 	}
 
 	if (priv->vram.paddr) {
-		DEFINE_DMA_ATTRS(attrs);
-		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &attrs);
+		unsigned long attrs = DMA_ATTR_NO_KERNEL_MAPPING;
 		drm_mm_takedown(&priv->vram.mm);
 		dma_free_attrs(dev, priv->vram.size, NULL,
-			       priv->vram.paddr, &attrs);
+			       priv->vram.paddr, attrs);
 	}
 
 	component_unbind_all(dev, ddev);
@@ -310,21 +309,21 @@ static int msm_init_vram(struct drm_devi
 	}
 
 	if (size) {
-		DEFINE_DMA_ATTRS(attrs);
+		unsigned long attrs = 0;
 		void *p;
 
 		priv->vram.size = size;
 
 		drm_mm_init(&priv->vram.mm, 0, (size >> PAGE_SHIFT) - 1);
 
-		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &attrs);
-		dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+		attrs |= DMA_ATTR_NO_KERNEL_MAPPING;
+		attrs |= DMA_ATTR_WRITE_COMBINE;
 
 		/* note that for no-kernel-mapping, the vaddr returned
 		 * is bogus, but non-null if allocation succeeded:
 		 */
 		p = dma_alloc_attrs(dev->dev, size,
-				&priv->vram.paddr, GFP_KERNEL, &attrs);
+				&priv->vram.paddr, GFP_KERNEL, attrs);
 		if (!p) {
 			dev_err(dev->dev, "failed to allocate VRAM\n");
 			priv->vram.paddr = 0;
diff -puN drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
@@ -109,7 +109,7 @@ struct gk20a_instmem {
 	u16 iommu_bit;
 
 	/* Only used by DMA API */
-	struct dma_attrs attrs;
+	unsigned long attrs;
 };
 #define gk20a_instmem(p) container_of((p), struct gk20a_instmem, base)
 
@@ -293,7 +293,7 @@ gk20a_instobj_dtor_dma(struct nvkm_memor
 		goto out;
 
 	dma_free_attrs(dev, node->base.mem.size << PAGE_SHIFT, node->base.vaddr,
-		       node->handle, &imem->attrs);
+		       node->handle, imem->attrs);
 
 out:
 	return node;
@@ -386,7 +386,7 @@ gk20a_instobj_ctor_dma(struct gk20a_inst
 
 	node->base.vaddr = dma_alloc_attrs(dev, npages << PAGE_SHIFT,
 					   &node->handle, GFP_KERNEL,
-					   &imem->attrs);
+					   imem->attrs);
 	if (!node->base.vaddr) {
 		nvkm_error(subdev, "cannot allocate DMA memory\n");
 		return -ENOMEM;
@@ -597,10 +597,9 @@ gk20a_instmem_new(struct nvkm_device *de
 
 		nvkm_info(&imem->base.subdev, "using IOMMU\n");
 	} else {
-		init_dma_attrs(&imem->attrs);
-		dma_set_attr(DMA_ATTR_NON_CONSISTENT, &imem->attrs);
-		dma_set_attr(DMA_ATTR_WEAK_ORDERING, &imem->attrs);
-		dma_set_attr(DMA_ATTR_WRITE_COMBINE, &imem->attrs);
+		imem->attrs = DMA_ATTR_NON_CONSISTENT |
+			      DMA_ATTR_WEAK_ORDERING |
+			      DMA_ATTR_WRITE_COMBINE;
 
 		nvkm_info(&imem->base.subdev, "using DMA API\n");
 	}
diff -puN drivers/gpu/drm/rockchip/rockchip_drm_gem.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/rockchip/rockchip_drm_gem.c
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -17,8 +17,6 @@
 #include <drm/drm_gem.h>
 #include <drm/drm_vma_manager.h>
 
-#include <linux/dma-attrs.h>
-
 #include "rockchip_drm_drv.h"
 #include "rockchip_drm_gem.h"
 
@@ -28,15 +26,14 @@ static int rockchip_gem_alloc_buf(struct
 	struct drm_gem_object *obj = &rk_obj->base;
 	struct drm_device *drm = obj->dev;
 
-	init_dma_attrs(&rk_obj->dma_attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &rk_obj->dma_attrs);
+	rk_obj->dma_attrs = DMA_ATTR_WRITE_COMBINE;
 
 	if (!alloc_kmap)
-		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &rk_obj->dma_attrs);
+		rk_obj->dma_attrs |= DMA_ATTR_NO_KERNEL_MAPPING;
 
 	rk_obj->kvaddr = dma_alloc_attrs(drm->dev, obj->size,
 					 &rk_obj->dma_addr, GFP_KERNEL,
-					 &rk_obj->dma_attrs);
+					 rk_obj->dma_attrs);
 	if (!rk_obj->kvaddr) {
 		DRM_ERROR("failed to allocate %zu byte dma buffer", obj->size);
 		return -ENOMEM;
@@ -51,7 +48,7 @@ static void rockchip_gem_free_buf(struct
 	struct drm_device *drm = obj->dev;
 
 	dma_free_attrs(drm->dev, obj->size, rk_obj->kvaddr, rk_obj->dma_addr,
-		       &rk_obj->dma_attrs);
+		       rk_obj->dma_attrs);
 }
 
 static int rockchip_drm_gem_object_mmap(struct drm_gem_object *obj,
@@ -70,7 +67,7 @@ static int rockchip_drm_gem_object_mmap(
 	vma->vm_pgoff = 0;
 
 	ret = dma_mmap_attrs(drm->dev, vma, rk_obj->kvaddr, rk_obj->dma_addr,
-			     obj->size, &rk_obj->dma_attrs);
+			     obj->size, rk_obj->dma_attrs);
 	if (ret)
 		drm_gem_vm_close(vma);
 
@@ -262,7 +259,7 @@ struct sg_table *rockchip_gem_prime_get_
 
 	ret = dma_get_sgtable_attrs(drm->dev, sgt, rk_obj->kvaddr,
 				    rk_obj->dma_addr, obj->size,
-				    &rk_obj->dma_attrs);
+				    rk_obj->dma_attrs);
 	if (ret) {
 		DRM_ERROR("failed to allocate sgt, %d\n", ret);
 		kfree(sgt);
@@ -276,7 +273,7 @@ void *rockchip_gem_prime_vmap(struct drm
 {
 	struct rockchip_gem_object *rk_obj = to_rockchip_obj(obj);
 
-	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, &rk_obj->dma_attrs))
+	if (rk_obj->dma_attrs & DMA_ATTR_NO_KERNEL_MAPPING)
 		return NULL;
 
 	return rk_obj->kvaddr;
diff -puN drivers/gpu/drm/rockchip/rockchip_drm_gem.h~dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/rockchip/rockchip_drm_gem.h
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
@@ -23,7 +23,7 @@ struct rockchip_gem_object {
 
 	void *kvaddr;
 	dma_addr_t dma_addr;
-	struct dma_attrs dma_attrs;
+	unsigned long dma_attrs;
 };
 
 struct sg_table *rockchip_gem_prime_get_sg_table(struct drm_gem_object *obj);
diff -puN drivers/infiniband/core/umem.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/infiniband/core/umem.c
--- a/drivers/infiniband/core/umem.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/infiniband/core/umem.c
@@ -37,7 +37,6 @@
 #include <linux/sched.h>
 #include <linux/export.h>
 #include <linux/hugetlb.h>
-#include <linux/dma-attrs.h>
 #include <linux/slab.h>
 #include <rdma/ib_umem_odp.h>
 
@@ -92,12 +91,12 @@ struct ib_umem *ib_umem_get(struct ib_uc
 	unsigned long npages;
 	int ret;
 	int i;
-	DEFINE_DMA_ATTRS(attrs);
+	unsigned long dma_attrs = 0;
 	struct scatterlist *sg, *sg_list_start;
 	int need_release = 0;
 
 	if (dmasync)
-		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
+		dma_attrs |= DMA_ATTR_WRITE_BARRIER;
 
 	if (!size)
 		return ERR_PTR(-EINVAL);
@@ -215,7 +214,7 @@ struct ib_umem *ib_umem_get(struct ib_uc
 				  umem->sg_head.sgl,
 				  umem->npages,
 				  DMA_BIDIRECTIONAL,
-				  &attrs);
+				  dma_attrs);
 
 	if (umem->nmap <= 0) {
 		ret = -ENOMEM;
diff -puN drivers/iommu/amd_iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/iommu/amd_iommu.c
--- a/drivers/iommu/amd_iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/iommu/amd_iommu.c
@@ -2375,7 +2375,7 @@ static void __unmap_single(struct dma_op
 static dma_addr_t map_page(struct device *dev, struct page *page,
 			   unsigned long offset, size_t size,
 			   enum dma_data_direction dir,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	phys_addr_t paddr = page_to_phys(page) + offset;
 	struct protection_domain *domain;
@@ -2398,7 +2398,7 @@ static dma_addr_t map_page(struct device
  * The exported unmap_single function for dma_ops.
  */
 static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
-		       enum dma_data_direction dir, struct dma_attrs *attrs)
+		       enum dma_data_direction dir, unsigned long attrs)
 {
 	struct protection_domain *domain;
 	struct dma_ops_domain *dma_dom;
@@ -2444,7 +2444,7 @@ static int sg_num_pages(struct device *d
  */
 static int map_sg(struct device *dev, struct scatterlist *sglist,
 		  int nelems, enum dma_data_direction direction,
-		  struct dma_attrs *attrs)
+		  unsigned long attrs)
 {
 	int mapped_pages = 0, npages = 0, prot = 0, i;
 	struct protection_domain *domain;
@@ -2525,7 +2525,7 @@ out_err:
  */
 static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		     int nelems, enum dma_data_direction dir,
-		     struct dma_attrs *attrs)
+		     unsigned long attrs)
 {
 	struct protection_domain *domain;
 	struct dma_ops_domain *dma_dom;
@@ -2548,7 +2548,7 @@ static void unmap_sg(struct device *dev,
  */
 static void *alloc_coherent(struct device *dev, size_t size,
 			    dma_addr_t *dma_addr, gfp_t flag,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	u64 dma_mask = dev->coherent_dma_mask;
 	struct protection_domain *domain;
@@ -2604,7 +2604,7 @@ out_free:
  */
 static void free_coherent(struct device *dev, size_t size,
 			  void *virt_addr, dma_addr_t dma_addr,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	struct protection_domain *domain;
 	struct dma_ops_domain *dma_dom;
diff -puN drivers/iommu/dma-iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/iommu/dma-iommu.c
--- a/drivers/iommu/dma-iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/iommu/dma-iommu.c
@@ -286,7 +286,7 @@ void iommu_dma_free(struct device *dev,
  *	   or NULL on failure.
  */
 struct page **iommu_dma_alloc(struct device *dev, size_t size, gfp_t gfp,
-		struct dma_attrs *attrs, int prot, dma_addr_t *handle,
+		unsigned long attrs, int prot, dma_addr_t *handle,
 		void (*flush_page)(struct device *, const void *, phys_addr_t))
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
@@ -306,7 +306,7 @@ struct page **iommu_dma_alloc(struct dev
 	} else {
 		size = ALIGN(size, min_size);
 	}
-	if (dma_get_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, attrs))
+	if (attrs & DMA_ATTR_ALLOC_SINGLE_PAGES)
 		alloc_sizes = min_size;
 
 	count = PAGE_ALIGN(size) >> PAGE_SHIFT;
@@ -400,7 +400,7 @@ dma_addr_t iommu_dma_map_page(struct dev
 }
 
 void iommu_dma_unmap_page(struct device *dev, dma_addr_t handle, size_t size,
-		enum dma_data_direction dir, struct dma_attrs *attrs)
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	__iommu_dma_unmap(iommu_get_domain_for_dev(dev), handle);
 }
@@ -560,7 +560,7 @@ out_restore_sg:
 }
 
 void iommu_dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-		enum dma_data_direction dir, struct dma_attrs *attrs)
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	/*
 	 * The scatterlist segments are mapped into a single
diff -puN drivers/iommu/intel-iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/iommu/intel-iommu.c
@@ -3552,7 +3552,7 @@ error:
 static dma_addr_t intel_map_page(struct device *dev, struct page *page,
 				 unsigned long offset, size_t size,
 				 enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	return __intel_map_single(dev, page_to_phys(page) + offset, size,
 				  dir, *dev->dma_mask);
@@ -3711,14 +3711,14 @@ static void intel_unmap(struct device *d
 
 static void intel_unmap_page(struct device *dev, dma_addr_t dev_addr,
 			     size_t size, enum dma_data_direction dir,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	intel_unmap(dev, dev_addr, size);
 }
 
 static void *intel_alloc_coherent(struct device *dev, size_t size,
 				  dma_addr_t *dma_handle, gfp_t flags,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	struct page *page = NULL;
 	int order;
@@ -3764,7 +3764,7 @@ static void *intel_alloc_coherent(struct
 }
 
 static void intel_free_coherent(struct device *dev, size_t size, void *vaddr,
-				dma_addr_t dma_handle, struct dma_attrs *attrs)
+				dma_addr_t dma_handle, unsigned long attrs)
 {
 	int order;
 	struct page *page = virt_to_page(vaddr);
@@ -3779,7 +3779,7 @@ static void intel_free_coherent(struct d
 
 static void intel_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			   int nelems, enum dma_data_direction dir,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	dma_addr_t startaddr = sg_dma_address(sglist) & PAGE_MASK;
 	unsigned long nrpages = 0;
@@ -3808,7 +3808,7 @@ static int intel_nontranslate_map_sg(str
 }
 
 static int intel_map_sg(struct device *dev, struct scatterlist *sglist, int nelems,
-			enum dma_data_direction dir, struct dma_attrs *attrs)
+			enum dma_data_direction dir, unsigned long attrs)
 {
 	int i;
 	struct dmar_domain *domain;
diff -puN drivers/media/platform/sti/bdisp/bdisp-hw.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/media/platform/sti/bdisp/bdisp-hw.c
--- a/drivers/media/platform/sti/bdisp/bdisp-hw.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/media/platform/sti/bdisp/bdisp-hw.c
@@ -430,14 +430,11 @@ int bdisp_hw_get_and_clear_irq(struct bd
  */
 void bdisp_hw_free_nodes(struct bdisp_ctx *ctx)
 {
-	if (ctx && ctx->node[0]) {
-		DEFINE_DMA_ATTRS(attrs);
-
-		dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+	if (ctx && ctx->node[0])
 		dma_free_attrs(ctx->bdisp_dev->dev,
 			       sizeof(struct bdisp_node) * MAX_NB_NODE,
-			       ctx->node[0], ctx->node_paddr[0], &attrs);
-	}
+			       ctx->node[0], ctx->node_paddr[0],
+			       DMA_ATTR_WRITE_COMBINE);
 }
 
 /**
@@ -455,12 +452,10 @@ int bdisp_hw_alloc_nodes(struct bdisp_ct
 	unsigned int i, node_size = sizeof(struct bdisp_node);
 	void *base;
 	dma_addr_t paddr;
-	DEFINE_DMA_ATTRS(attrs);
 
 	/* Allocate all the nodes within a single memory page */
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
 	base = dma_alloc_attrs(dev, node_size * MAX_NB_NODE, &paddr,
-			       GFP_KERNEL | GFP_DMA, &attrs);
+			       GFP_KERNEL | GFP_DMA, DMA_ATTR_WRITE_COMBINE);
 	if (!base) {
 		dev_err(dev, "%s no mem\n", __func__);
 		return -ENOMEM;
@@ -493,13 +488,9 @@ void bdisp_hw_free_filters(struct device
 {
 	int size = (BDISP_HF_NB * NB_H_FILTER) + (BDISP_VF_NB * NB_V_FILTER);
 
-	if (bdisp_h_filter[0].virt) {
-		DEFINE_DMA_ATTRS(attrs);
-
-		dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+	if (bdisp_h_filter[0].virt)
 		dma_free_attrs(dev, size, bdisp_h_filter[0].virt,
-			       bdisp_h_filter[0].paddr, &attrs);
-	}
+			       bdisp_h_filter[0].paddr, DMA_ATTR_WRITE_COMBINE);
 }
 
 /**
@@ -516,12 +507,11 @@ int bdisp_hw_alloc_filters(struct device
 	unsigned int i, size;
 	void *base;
 	dma_addr_t paddr;
-	DEFINE_DMA_ATTRS(attrs);
 
 	/* Allocate all the filters within a single memory page */
 	size = (BDISP_HF_NB * NB_H_FILTER) + (BDISP_VF_NB * NB_V_FILTER);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
-	base = dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA, &attrs);
+	base = dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA,
+			       DMA_ATTR_WRITE_COMBINE);
 	if (!base)
 		return -ENOMEM;
 
diff -puN drivers/media/v4l2-core/videobuf2-dma-contig.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/media/v4l2-core/videobuf2-dma-contig.c
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -27,7 +27,7 @@ struct vb2_dc_buf {
 	unsigned long			size;
 	void				*cookie;
 	dma_addr_t			dma_addr;
-	struct dma_attrs		attrs;
+	unsigned long			attrs;
 	enum dma_data_direction		dma_dir;
 	struct sg_table			*dma_sgt;
 	struct frame_vector		*vec;
@@ -130,12 +130,12 @@ static void vb2_dc_put(void *buf_priv)
 		kfree(buf->sgt_base);
 	}
 	dma_free_attrs(buf->dev, buf->size, buf->cookie, buf->dma_addr,
-			&buf->attrs);
+		       buf->attrs);
 	put_device(buf->dev);
 	kfree(buf);
 }
 
-static void *vb2_dc_alloc(struct device *dev, const struct dma_attrs *attrs,
+static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 			  unsigned long size, enum dma_data_direction dma_dir,
 			  gfp_t gfp_flags)
 {
@@ -146,16 +146,16 @@ static void *vb2_dc_alloc(struct device
 		return ERR_PTR(-ENOMEM);
 
 	if (attrs)
-		buf->attrs = *attrs;
+		buf->attrs = attrs;
 	buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
-					GFP_KERNEL | gfp_flags, &buf->attrs);
+					GFP_KERNEL | gfp_flags, buf->attrs);
 	if (!buf->cookie) {
 		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
 		kfree(buf);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, &buf->attrs))
+	if ((buf->attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0)
 		buf->vaddr = buf->cookie;
 
 	/* Prevent the device from being released while the buffer is used */
@@ -189,7 +189,7 @@ static int vb2_dc_mmap(void *buf_priv, s
 	vma->vm_pgoff = 0;
 
 	ret = dma_mmap_attrs(buf->dev, vma, buf->cookie,
-		buf->dma_addr, buf->size, &buf->attrs);
+		buf->dma_addr, buf->size, buf->attrs);
 
 	if (ret) {
 		pr_err("Remapping memory failed, error: %d\n", ret);
@@ -372,7 +372,7 @@ static struct sg_table *vb2_dc_get_base_
 	}
 
 	ret = dma_get_sgtable_attrs(buf->dev, sgt, buf->cookie, buf->dma_addr,
-		buf->size, &buf->attrs);
+		buf->size, buf->attrs);
 	if (ret < 0) {
 		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
 		kfree(sgt);
@@ -421,15 +421,12 @@ static void vb2_dc_put_userptr(void *buf
 	struct page **pages;
 
 	if (sgt) {
-		DEFINE_DMA_ATTRS(attrs);
-
-		dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 		/*
 		 * No need to sync to CPU, it's already synced to the CPU
 		 * since the finish() memop will have been called before this.
 		 */
 		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				   buf->dma_dir, &attrs);
+				   buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 		pages = frame_vector_pages(buf->vec);
 		/* sgt should exist only if vector contains pages... */
 		BUG_ON(IS_ERR(pages));
@@ -484,9 +481,6 @@ static void *vb2_dc_get_userptr(struct d
 	struct sg_table *sgt;
 	unsigned long contig_size;
 	unsigned long dma_align = dma_get_cache_alignment();
-	DEFINE_DMA_ATTRS(attrs);
-
-	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
 	/* Only cache aligned DMA transfers are reliable */
 	if (!IS_ALIGNED(vaddr | size, dma_align)) {
@@ -548,7 +542,7 @@ static void *vb2_dc_get_userptr(struct d
 	 * prepare() memop is called.
 	 */
 	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				      buf->dma_dir, &attrs);
+				      buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (sgt->nents <= 0) {
 		pr_err("failed to map scatterlist\n");
 		ret = -EIO;
@@ -572,7 +566,7 @@ out:
 
 fail_map_sg:
 	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-			   buf->dma_dir, &attrs);
+			   buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 
 fail_sgt_init:
 	sg_free_table(sgt);
diff -puN drivers/media/v4l2-core/videobuf2-dma-sg.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/media/v4l2-core/videobuf2-dma-sg.c
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -95,7 +95,7 @@ static int vb2_dma_sg_alloc_compacted(st
 	return 0;
 }
 
-static void *vb2_dma_sg_alloc(struct device *dev, const struct dma_attrs *dma_attrs,
+static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
 			      unsigned long size, enum dma_data_direction dma_dir,
 			      gfp_t gfp_flags)
 {
@@ -103,9 +103,6 @@ static void *vb2_dma_sg_alloc(struct dev
 	struct sg_table *sgt;
 	int ret;
 	int num_pages;
-	DEFINE_DMA_ATTRS(attrs);
-
-	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
 	if (WARN_ON(dev == NULL))
 		return NULL;
@@ -144,7 +141,7 @@ static void *vb2_dma_sg_alloc(struct dev
 	 * prepare() memop is called.
 	 */
 	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				      buf->dma_dir, &attrs);
+				      buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (!sgt->nents)
 		goto fail_map;
 
@@ -179,13 +176,10 @@ static void vb2_dma_sg_put(void *buf_pri
 	int i = buf->num_pages;
 
 	if (atomic_dec_and_test(&buf->refcount)) {
-		DEFINE_DMA_ATTRS(attrs);
-
-		dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
 			buf->num_pages);
 		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				   buf->dma_dir, &attrs);
+				   buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 		if (buf->vaddr)
 			vm_unmap_ram(buf->vaddr, buf->num_pages);
 		sg_free_table(buf->dma_sgt);
@@ -228,10 +222,8 @@ static void *vb2_dma_sg_get_userptr(stru
 {
 	struct vb2_dma_sg_buf *buf;
 	struct sg_table *sgt;
-	DEFINE_DMA_ATTRS(attrs);
 	struct frame_vector *vec;
 
-	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return NULL;
@@ -262,7 +254,7 @@ static void *vb2_dma_sg_get_userptr(stru
 	 * prepare() memop is called.
 	 */
 	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				      buf->dma_dir, &attrs);
+				      buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (!sgt->nents)
 		goto userptr_fail_map;
 
@@ -286,14 +278,11 @@ static void vb2_dma_sg_put_userptr(void
 	struct vb2_dma_sg_buf *buf = buf_priv;
 	struct sg_table *sgt = &buf->sg_table;
 	int i = buf->num_pages;
-	DEFINE_DMA_ATTRS(attrs);
-
-	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
 	dprintk(1, "%s: Releasing userspace buffer of %d pages\n",
 	       __func__, buf->num_pages);
 	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir,
-			   &attrs);
+			   DMA_ATTR_SKIP_CPU_SYNC);
 	if (buf->vaddr)
 		vm_unmap_ram(buf->vaddr, buf->num_pages);
 	sg_free_table(buf->dma_sgt);
diff -puN drivers/media/v4l2-core/videobuf2-vmalloc.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/media/v4l2-core/videobuf2-vmalloc.c
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -33,7 +33,7 @@ struct vb2_vmalloc_buf {
 
 static void vb2_vmalloc_put(void *buf_priv);
 
-static void *vb2_vmalloc_alloc(struct device *dev, const struct dma_attrs *attrs,
+static void *vb2_vmalloc_alloc(struct device *dev, unsigned long attrs,
 			       unsigned long size, enum dma_data_direction dma_dir,
 			       gfp_t gfp_flags)
 {
diff -puN drivers/misc/mic/host/mic_boot.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/misc/mic/host/mic_boot.c
--- a/drivers/misc/mic/host/mic_boot.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/misc/mic/host/mic_boot.c
@@ -38,7 +38,7 @@ static inline struct mic_device *vpdev_t
 static dma_addr_t
 _mic_dma_map_page(struct device *dev, struct page *page,
 		  unsigned long offset, size_t size,
-		  enum dma_data_direction dir, struct dma_attrs *attrs)
+		  enum dma_data_direction dir, unsigned long attrs)
 {
 	void *va = phys_to_virt(page_to_phys(page)) + offset;
 	struct mic_device *mdev = vpdev_to_mdev(dev);
@@ -48,7 +48,7 @@ _mic_dma_map_page(struct device *dev, st
 
 static void _mic_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 				size_t size, enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	struct mic_device *mdev = vpdev_to_mdev(dev);
 
@@ -144,7 +144,7 @@ static inline struct mic_device *scdev_t
 
 static void *__mic_dma_alloc(struct device *dev, size_t size,
 			     dma_addr_t *dma_handle, gfp_t gfp,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
 	struct mic_device *mdev = scdev_to_mdev(scdev);
@@ -164,7 +164,7 @@ static void *__mic_dma_alloc(struct devi
 }
 
 static void __mic_dma_free(struct device *dev, size_t size, void *vaddr,
-			   dma_addr_t dma_handle, struct dma_attrs *attrs)
+			   dma_addr_t dma_handle, unsigned long attrs)
 {
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
 	struct mic_device *mdev = scdev_to_mdev(scdev);
@@ -176,7 +176,7 @@ static void __mic_dma_free(struct device
 static dma_addr_t
 __mic_dma_map_page(struct device *dev, struct page *page, unsigned long offset,
 		   size_t size, enum dma_data_direction dir,
-		   struct dma_attrs *attrs)
+		   unsigned long attrs)
 {
 	void *va = phys_to_virt(page_to_phys(page)) + offset;
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
@@ -188,7 +188,7 @@ __mic_dma_map_page(struct device *dev, s
 static void
 __mic_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 		     size_t size, enum dma_data_direction dir,
-		     struct dma_attrs *attrs)
+		     unsigned long attrs)
 {
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
 	struct mic_device *mdev = scdev_to_mdev(scdev);
@@ -198,7 +198,7 @@ __mic_dma_unmap_page(struct device *dev,
 
 static int __mic_dma_map_sg(struct device *dev, struct scatterlist *sg,
 			    int nents, enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
 	struct mic_device *mdev = scdev_to_mdev(scdev);
@@ -229,7 +229,7 @@ err:
 static void __mic_dma_unmap_sg(struct device *dev,
 			       struct scatterlist *sg, int nents,
 			       enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
 	struct mic_device *mdev = scdev_to_mdev(scdev);
@@ -327,7 +327,7 @@ static inline struct mic_device *mbdev_t
 static dma_addr_t
 mic_dma_map_page(struct device *dev, struct page *page,
 		 unsigned long offset, size_t size, enum dma_data_direction dir,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 {
 	void *va = phys_to_virt(page_to_phys(page)) + offset;
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -338,7 +338,7 @@ mic_dma_map_page(struct device *dev, str
 static void
 mic_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 		   size_t size, enum dma_data_direction dir,
-		   struct dma_attrs *attrs)
+		   unsigned long attrs)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 	mic_unmap_single(mdev, dma_addr, size);
diff -puN drivers/parisc/ccio-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/parisc/ccio-dma.c
@@ -790,7 +790,7 @@ ccio_map_single(struct device *dev, void
 static dma_addr_t
 ccio_map_page(struct device *dev, struct page *page, unsigned long offset,
 		size_t size, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	return ccio_map_single(dev, page_address(page) + offset, size,
 			direction);
@@ -806,7 +806,7 @@ ccio_map_page(struct device *dev, struct
  */
 static void 
 ccio_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
-		enum dma_data_direction direction, struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 	unsigned long flags; 
@@ -844,7 +844,7 @@ ccio_unmap_page(struct device *dev, dma_
  */
 static void * 
 ccio_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t flag,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
       void *ret;
 #if 0
@@ -878,9 +878,9 @@ ccio_alloc(struct device *dev, size_t si
  */
 static void 
 ccio_free(struct device *dev, size_t size, void *cpu_addr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
-	ccio_unmap_page(dev, dma_handle, size, 0, NULL);
+	ccio_unmap_page(dev, dma_handle, size, 0, 0);
 	free_pages((unsigned long)cpu_addr, get_order(size));
 }
 
@@ -907,7 +907,7 @@ ccio_free(struct device *dev, size_t siz
  */
 static int
 ccio_map_sg(struct device *dev, struct scatterlist *sglist, int nents, 
-	    enum dma_data_direction direction, struct dma_attrs *attrs)
+	    enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 	int coalesced, filled = 0;
@@ -984,7 +984,7 @@ ccio_map_sg(struct device *dev, struct s
  */
 static void 
 ccio_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents, 
-	      enum dma_data_direction direction, struct dma_attrs *attrs)
+	      enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 
@@ -1004,7 +1004,7 @@ ccio_unmap_sg(struct device *dev, struct
 		ioc->usg_pages += sg_dma_len(sglist) >> PAGE_SHIFT;
 #endif
 		ccio_unmap_page(dev, sg_dma_address(sglist),
-				  sg_dma_len(sglist), direction, NULL);
+				  sg_dma_len(sglist), direction, 0);
 		++sglist;
 	}
 
diff -puN drivers/parisc/sba_iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/parisc/sba_iommu.c
@@ -783,7 +783,7 @@ sba_map_single(struct device *dev, void
 static dma_addr_t
 sba_map_page(struct device *dev, struct page *page, unsigned long offset,
 		size_t size, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	return sba_map_single(dev, page_address(page) + offset, size,
 			direction);
@@ -801,7 +801,7 @@ sba_map_page(struct device *dev, struct
  */
 static void
 sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
-		enum dma_data_direction direction, struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 #if DELAYED_RESOURCE_CNT > 0
@@ -876,7 +876,7 @@ sba_unmap_page(struct device *dev, dma_a
  * See Documentation/DMA-API-HOWTO.txt
  */
 static void *sba_alloc(struct device *hwdev, size_t size, dma_addr_t *dma_handle,
-		gfp_t gfp, struct dma_attrs *attrs)
+		gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 
@@ -908,9 +908,9 @@ static void *sba_alloc(struct device *hw
  */
 static void
 sba_free(struct device *hwdev, size_t size, void *vaddr,
-		    dma_addr_t dma_handle, struct dma_attrs *attrs)
+		    dma_addr_t dma_handle, unsigned long attrs)
 {
-	sba_unmap_page(hwdev, dma_handle, size, 0, NULL);
+	sba_unmap_page(hwdev, dma_handle, size, 0, 0);
 	free_pages((unsigned long) vaddr, get_order(size));
 }
 
@@ -943,7 +943,7 @@ int dump_run_sg = 0;
  */
 static int
 sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	   enum dma_data_direction direction, struct dma_attrs *attrs)
+	   enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 	int coalesced, filled = 0;
@@ -1026,7 +1026,7 @@ sba_map_sg(struct device *dev, struct sc
  */
 static void 
 sba_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	     enum dma_data_direction direction, struct dma_attrs *attrs)
+	     enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 #ifdef ASSERT_PDIR_SANITY
@@ -1051,7 +1051,7 @@ sba_unmap_sg(struct device *dev, struct
 	while (sg_dma_len(sglist) && nents--) {
 
 		sba_unmap_page(dev, sg_dma_address(sglist), sg_dma_len(sglist),
-				direction, NULL);
+				direction, 0);
 #ifdef SBA_COLLECT_STATS
 		ioc->usg_pages += ((sg_dma_address(sglist) & ~IOVP_MASK) + sg_dma_len(sglist) + IOVP_SIZE - 1) >> PAGE_SHIFT;
 		ioc->usingle_calls--;	/* kluge since call is unmap_sg() */
diff -puN drivers/remoteproc/qcom_q6v5_pil.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/remoteproc/qcom_q6v5_pil.c
--- a/drivers/remoteproc/qcom_q6v5_pil.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/remoteproc/qcom_q6v5_pil.c
@@ -349,13 +349,12 @@ static void q6v5proc_halt_axi_port(struc
 
 static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw)
 {
-	DEFINE_DMA_ATTRS(attrs);
+	unsigned long dma_attrs = DMA_ATTR_FORCE_CONTIGUOUS;
 	dma_addr_t phys;
 	void *ptr;
 	int ret;
 
-	dma_set_attr(DMA_ATTR_FORCE_CONTIGUOUS, &attrs);
-	ptr = dma_alloc_attrs(qproc->dev, fw->size, &phys, GFP_KERNEL, &attrs);
+	ptr = dma_alloc_attrs(qproc->dev, fw->size, &phys, GFP_KERNEL, dma_attrs);
 	if (!ptr) {
 		dev_err(qproc->dev, "failed to allocate mdt buffer\n");
 		return -ENOMEM;
@@ -372,7 +371,7 @@ static int q6v5_mpss_init_image(struct q
 	else if (ret < 0)
 		dev_err(qproc->dev, "MPSS header authentication failed: %d\n", ret);
 
-	dma_free_attrs(qproc->dev, fw->size, ptr, phys, &attrs);
+	dma_free_attrs(qproc->dev, fw->size, ptr, phys, dma_attrs);
 
 	return ret < 0 ? ret : 0;
 }
diff -puN drivers/video/fbdev/omap2/omapfb/omapfb-main.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/video/fbdev/omap2/omapfb/omapfb-main.c
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -1332,7 +1332,7 @@ static void omapfb_free_fbmem(struct fb_
 	}
 
 	dma_free_attrs(fbdev->dev, rg->size, rg->token, rg->dma_handle,
-			&rg->attrs);
+			rg->attrs);
 
 	rg->token = NULL;
 	rg->vaddr = NULL;
@@ -1370,7 +1370,7 @@ static int omapfb_alloc_fbmem(struct fb_
 	struct omapfb2_device *fbdev = ofbi->fbdev;
 	struct omapfb2_mem_region *rg;
 	void *token;
-	DEFINE_DMA_ATTRS(attrs);
+	unsigned long attrs;
 	dma_addr_t dma_handle;
 	int r;
 
@@ -1386,15 +1386,15 @@ static int omapfb_alloc_fbmem(struct fb_
 
 	size = PAGE_ALIGN(size);
 
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+	attrs = DMA_ATTR_WRITE_COMBINE;
 
 	if (ofbi->rotation_type == OMAP_DSS_ROT_VRFB)
-		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &attrs);
+		attrs |= DMA_ATTR_NO_KERNEL_MAPPING;
 
 	DBG("allocating %lu bytes for fb %d\n", size, ofbi->id);
 
 	token = dma_alloc_attrs(fbdev->dev, size, &dma_handle,
-			GFP_KERNEL, &attrs);
+			GFP_KERNEL, attrs);
 
 	if (token == NULL) {
 		dev_err(fbdev->dev, "failed to allocate framebuffer\n");
@@ -1408,7 +1408,7 @@ static int omapfb_alloc_fbmem(struct fb_
 		r = omap_vrfb_request_ctx(&rg->vrfb);
 		if (r) {
 			dma_free_attrs(fbdev->dev, size, token, dma_handle,
-					&attrs);
+					attrs);
 			dev_err(fbdev->dev, "vrfb create ctx failed\n");
 			return r;
 		}
diff -puN drivers/video/fbdev/omap2/omapfb/omapfb.h~dma-mapping-use-unsigned-long-for-dma_attrs drivers/video/fbdev/omap2/omapfb/omapfb.h
--- a/drivers/video/fbdev/omap2/omapfb/omapfb.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/video/fbdev/omap2/omapfb/omapfb.h
@@ -28,7 +28,6 @@
 #endif
 
 #include <linux/rwsem.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-mapping.h>
 
 #include <video/omapfb_dss.h>
@@ -51,7 +50,7 @@ extern bool omapfb_debug;
 
 struct omapfb2_mem_region {
 	int             id;
-	struct dma_attrs attrs;
+	unsigned long	attrs;
 	void		*token;
 	dma_addr_t	dma_handle;
 	u32		paddr;
diff -puN drivers/xen/swiotlb-xen.c~dma-mapping-use-unsigned-long-for-dma_attrs drivers/xen/swiotlb-xen.c
--- a/drivers/xen/swiotlb-xen.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/xen/swiotlb-xen.c
@@ -294,7 +294,7 @@ error:
 void *
 xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flags,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	void *ret;
 	int order = get_order(size);
@@ -346,7 +346,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_alloc_cohe
 
 void
 xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
-			  dma_addr_t dev_addr, struct dma_attrs *attrs)
+			  dma_addr_t dev_addr, unsigned long attrs)
 {
 	int order = get_order(size);
 	phys_addr_t phys;
@@ -378,7 +378,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_free_coher
 dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 				unsigned long offset, size_t size,
 				enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	phys_addr_t map, phys = page_to_phys(page) + offset;
 	dma_addr_t dev_addr = xen_phys_to_bus(phys);
@@ -434,7 +434,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_map_page);
  */
 static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 			     size_t size, enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	phys_addr_t paddr = xen_bus_to_phys(dev_addr);
 
@@ -462,7 +462,7 @@ static void xen_unmap_single(struct devi
 
 void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 			    size_t size, enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	xen_unmap_single(hwdev, dev_addr, size, dir, attrs);
 }
@@ -538,7 +538,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_sync_singl
 int
 xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			 int nelems, enum dma_data_direction dir,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -599,7 +599,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_map_sg_att
 void
 xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			   int nelems, enum dma_data_direction dir,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
diff -puN include/linux/dma-attrs.h~dma-mapping-use-unsigned-long-for-dma_attrs /dev/null
--- a/include/linux/dma-attrs.h
+++ /dev/null
@@ -1,71 +0,0 @@
-#ifndef _DMA_ATTR_H
-#define _DMA_ATTR_H
-
-#include <linux/bitmap.h>
-#include <linux/bitops.h>
-#include <linux/bug.h>
-
-/**
- * an enum dma_attr represents an attribute associated with a DMA
- * mapping. The semantics of each attribute should be defined in
- * Documentation/DMA-attributes.txt.
- */
-enum dma_attr {
-	DMA_ATTR_WRITE_BARRIER,
-	DMA_ATTR_WEAK_ORDERING,
-	DMA_ATTR_WRITE_COMBINE,
-	DMA_ATTR_NON_CONSISTENT,
-	DMA_ATTR_NO_KERNEL_MAPPING,
-	DMA_ATTR_SKIP_CPU_SYNC,
-	DMA_ATTR_FORCE_CONTIGUOUS,
-	DMA_ATTR_ALLOC_SINGLE_PAGES,
-	DMA_ATTR_MAX,
-};
-
-#define __DMA_ATTRS_LONGS BITS_TO_LONGS(DMA_ATTR_MAX)
-
-/**
- * struct dma_attrs - an opaque container for DMA attributes
- * @flags - bitmask representing a collection of enum dma_attr
- */
-struct dma_attrs {
-	unsigned long flags[__DMA_ATTRS_LONGS];
-};
-
-#define DEFINE_DMA_ATTRS(x) 					\
-	struct dma_attrs x = {					\
-		.flags = { [0 ... __DMA_ATTRS_LONGS-1] = 0 },	\
-	}
-
-static inline void init_dma_attrs(struct dma_attrs *attrs)
-{
-	bitmap_zero(attrs->flags, __DMA_ATTRS_LONGS);
-}
-
-/**
- * dma_set_attr - set a specific attribute
- * @attr: attribute to set
- * @attrs: struct dma_attrs (may be NULL)
- */
-static inline void dma_set_attr(enum dma_attr attr, struct dma_attrs *attrs)
-{
-	if (attrs == NULL)
-		return;
-	BUG_ON(attr >= DMA_ATTR_MAX);
-	__set_bit(attr, attrs->flags);
-}
-
-/**
- * dma_get_attr - check for a specific attribute
- * @attr: attribute to set
- * @attrs: struct dma_attrs (may be NULL)
- */
-static inline int dma_get_attr(enum dma_attr attr, struct dma_attrs *attrs)
-{
-	if (attrs == NULL)
-		return 0;
-	BUG_ON(attr >= DMA_ATTR_MAX);
-	return test_bit(attr, attrs->flags);
-}
-
-#endif /* _DMA_ATTR_H */
diff -puN include/linux/dma-iommu.h~dma-mapping-use-unsigned-long-for-dma_attrs include/linux/dma-iommu.h
--- a/include/linux/dma-iommu.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/linux/dma-iommu.h
@@ -39,7 +39,7 @@ int dma_direction_to_prot(enum dma_data_
  * the arch code to take care of attributes and cache maintenance
  */
 struct page **iommu_dma_alloc(struct device *dev, size_t size, gfp_t gfp,
-		struct dma_attrs *attrs, int prot, dma_addr_t *handle,
+		unsigned long attrs, int prot, dma_addr_t *handle,
 		void (*flush_page)(struct device *, const void *, phys_addr_t));
 void iommu_dma_free(struct device *dev, struct page **pages, size_t size,
 		dma_addr_t *handle);
@@ -56,9 +56,9 @@ int iommu_dma_map_sg(struct device *dev,
  * directly as DMA mapping callbacks for simplicity
  */
 void iommu_dma_unmap_page(struct device *dev, dma_addr_t handle, size_t size,
-		enum dma_data_direction dir, struct dma_attrs *attrs);
+		enum dma_data_direction dir, unsigned long attrs);
 void iommu_dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-		enum dma_data_direction dir, struct dma_attrs *attrs);
+		enum dma_data_direction dir, unsigned long attrs);
 int iommu_dma_supported(struct device *dev, u64 mask);
 int iommu_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 
diff -puN include/linux/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/linux/dma-mapping.h
@@ -5,13 +5,58 @@
 #include <linux/string.h>
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-debug.h>
 #include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
 #include <linux/kmemcheck.h>
 #include <linux/bug.h>
 
+/**
+ * List of possible attributes associated with a DMA mapping. The semantics
+ * of each attribute should be defined in Documentation/DMA-attributes.txt.
+ *
+ * DMA_ATTR_WRITE_BARRIER: DMA to a memory region with this attribute
+ * forces all pending DMA writes to complete.
+ */
+#define DMA_ATTR_WRITE_BARRIER		(1UL << 0)
+/*
+ * DMA_ATTR_WEAK_ORDERING: Specifies that reads and writes to the mapping
+ * may be weakly ordered, that is that reads and writes may pass each other.
+ */
+#define DMA_ATTR_WEAK_ORDERING		(1UL << 1)
+/*
+ * DMA_ATTR_WRITE_COMBINE: Specifies that writes to the mapping may be
+ * buffered to improve performance.
+ */
+#define DMA_ATTR_WRITE_COMBINE		(1UL << 2)
+/*
+ * DMA_ATTR_NON_CONSISTENT: Lets the platform to choose to return either
+ * consistent or non-consistent memory as it sees fit.
+ */
+#define DMA_ATTR_NON_CONSISTENT		(1UL << 3)
+/*
+ * DMA_ATTR_NO_KERNEL_MAPPING: Lets the platform to avoid creating a kernel
+ * virtual mapping for the allocated buffer.
+ */
+#define DMA_ATTR_NO_KERNEL_MAPPING	(1UL << 4)
+/*
+ * DMA_ATTR_SKIP_CPU_SYNC: Allows platform code to skip synchronization of
+ * the CPU cache for the given buffer assuming that it has been already
+ * transferred to 'device' domain.
+ */
+#define DMA_ATTR_SKIP_CPU_SYNC		(1UL << 5)
+/*
+ * DMA_ATTR_FORCE_CONTIGUOUS: Forces contiguous allocation of the buffer
+ * in physical memory.
+ */
+#define DMA_ATTR_FORCE_CONTIGUOUS	(1UL << 6)
+/*
+ * DMA_ATTR_ALLOC_SINGLE_PAGES: This is a hint to the DMA-mapping subsystem
+ * that it's probably not worth the time to try to allocate memory to in a way
+ * that gives better TLB efficiency.
+ */
+#define DMA_ATTR_ALLOC_SINGLE_PAGES	(1UL << 7)
+
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
  * It can be given to a device to use as a DMA source or target.  A CPU cannot
@@ -21,34 +66,35 @@
 struct dma_map_ops {
 	void* (*alloc)(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp,
-				struct dma_attrs *attrs);
+				unsigned long attrs);
 	void (*free)(struct device *dev, size_t size,
 			      void *vaddr, dma_addr_t dma_handle,
-			      struct dma_attrs *attrs);
+			      unsigned long attrs);
 	int (*mmap)(struct device *, struct vm_area_struct *,
-			  void *, dma_addr_t, size_t, struct dma_attrs *attrs);
+			  void *, dma_addr_t, size_t,
+			  unsigned long attrs);
 
 	int (*get_sgtable)(struct device *dev, struct sg_table *sgt, void *,
-			   dma_addr_t, size_t, struct dma_attrs *attrs);
+			   dma_addr_t, size_t, unsigned long attrs);
 
 	dma_addr_t (*map_page)(struct device *dev, struct page *page,
 			       unsigned long offset, size_t size,
 			       enum dma_data_direction dir,
-			       struct dma_attrs *attrs);
+			       unsigned long attrs);
 	void (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
 			   size_t size, enum dma_data_direction dir,
-			   struct dma_attrs *attrs);
+			   unsigned long attrs);
 	/*
 	 * map_sg returns 0 on error and a value > 0 on success.
 	 * It should never return a value < 0.
 	 */
 	int (*map_sg)(struct device *dev, struct scatterlist *sg,
 		      int nents, enum dma_data_direction dir,
-		      struct dma_attrs *attrs);
+		      unsigned long attrs);
 	void (*unmap_sg)(struct device *dev,
 			 struct scatterlist *sg, int nents,
 			 enum dma_data_direction dir,
-			 struct dma_attrs *attrs);
+			 unsigned long attrs);
 	void (*sync_single_for_cpu)(struct device *dev,
 				    dma_addr_t dma_handle, size_t size,
 				    enum dma_data_direction dir);
@@ -123,7 +169,7 @@ static inline struct dma_map_ops *get_dm
 static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 					      size_t size,
 					      enum dma_data_direction dir,
-					      struct dma_attrs *attrs)
+					      unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
@@ -142,7 +188,7 @@ static inline dma_addr_t dma_map_single_
 static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
 					  size_t size,
 					  enum dma_data_direction dir,
-					  struct dma_attrs *attrs)
+					  unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
@@ -158,7 +204,7 @@ static inline void dma_unmap_single_attr
  */
 static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 				   int nents, enum dma_data_direction dir,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	int i, ents;
@@ -176,7 +222,7 @@ static inline int dma_map_sg_attrs(struc
 
 static inline void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg,
 				      int nents, enum dma_data_direction dir,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
@@ -195,7 +241,7 @@ static inline dma_addr_t dma_map_page(st
 
 	kmemcheck_mark_initialized(page_address(page) + offset, size);
 	BUG_ON(!valid_dma_direction(dir));
-	addr = ops->map_page(dev, page, offset, size, dir, NULL);
+	addr = ops->map_page(dev, page, offset, size, dir, 0);
 	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
 
 	return addr;
@@ -208,7 +254,7 @@ static inline void dma_unmap_page(struct
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
-		ops->unmap_page(dev, addr, size, dir, NULL);
+		ops->unmap_page(dev, addr, size, dir, 0);
 	debug_dma_unmap_page(dev, addr, size, dir, false);
 }
 
@@ -289,10 +335,10 @@ dma_sync_sg_for_device(struct device *de
 
 }
 
-#define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
-#define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, NULL)
-#define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, NULL)
-#define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, NULL)
+#define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, 0)
+#define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, 0)
+#define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, 0)
+#define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, 0)
 
 extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
@@ -321,7 +367,7 @@ void dma_common_free_remap(void *cpu_add
  */
 static inline int
 dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma, void *cpu_addr,
-	       dma_addr_t dma_addr, size_t size, struct dma_attrs *attrs)
+	       dma_addr_t dma_addr, size_t size, unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	BUG_ON(!ops);
@@ -330,7 +376,7 @@ dma_mmap_attrs(struct device *dev, struc
 	return dma_common_mmap(dev, vma, cpu_addr, dma_addr, size);
 }
 
-#define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, NULL)
+#define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, 0)
 
 int
 dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
@@ -338,7 +384,8 @@ dma_common_get_sgtable(struct device *de
 
 static inline int
 dma_get_sgtable_attrs(struct device *dev, struct sg_table *sgt, void *cpu_addr,
-		      dma_addr_t dma_addr, size_t size, struct dma_attrs *attrs)
+		      dma_addr_t dma_addr, size_t size,
+		      unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	BUG_ON(!ops);
@@ -348,7 +395,7 @@ dma_get_sgtable_attrs(struct device *dev
 	return dma_common_get_sgtable(dev, sgt, cpu_addr, dma_addr, size);
 }
 
-#define dma_get_sgtable(d, t, v, h, s) dma_get_sgtable_attrs(d, t, v, h, s, NULL)
+#define dma_get_sgtable(d, t, v, h, s) dma_get_sgtable_attrs(d, t, v, h, s, 0)
 
 #ifndef arch_dma_alloc_attrs
 #define arch_dma_alloc_attrs(dev, flag)	(true)
@@ -356,7 +403,7 @@ dma_get_sgtable_attrs(struct device *dev
 
 static inline void *dma_alloc_attrs(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	void *cpu_addr;
@@ -378,7 +425,7 @@ static inline void *dma_alloc_attrs(stru
 
 static inline void dma_free_attrs(struct device *dev, size_t size,
 				     void *cpu_addr, dma_addr_t dma_handle,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
@@ -398,31 +445,27 @@ static inline void dma_free_attrs(struct
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t flag)
 {
-	return dma_alloc_attrs(dev, size, dma_handle, flag, NULL);
+	return dma_alloc_attrs(dev, size, dma_handle, flag, 0);
 }
 
 static inline void dma_free_coherent(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_handle)
 {
-	return dma_free_attrs(dev, size, cpu_addr, dma_handle, NULL);
+	return dma_free_attrs(dev, size, cpu_addr, dma_handle, 0);
 }
 
 static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp)
 {
-	DEFINE_DMA_ATTRS(attrs);
-
-	dma_set_attr(DMA_ATTR_NON_CONSISTENT, &attrs);
-	return dma_alloc_attrs(dev, size, dma_handle, gfp, &attrs);
+	return dma_alloc_attrs(dev, size, dma_handle, gfp,
+			       DMA_ATTR_NON_CONSISTENT);
 }
 
 static inline void dma_free_noncoherent(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_handle)
 {
-	DEFINE_DMA_ATTRS(attrs);
-
-	dma_set_attr(DMA_ATTR_NON_CONSISTENT, &attrs);
-	dma_free_attrs(dev, size, cpu_addr, dma_handle, &attrs);
+	dma_free_attrs(dev, size, cpu_addr, dma_handle,
+		       DMA_ATTR_NON_CONSISTENT);
 }
 
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
@@ -646,9 +689,8 @@ static inline void dmam_release_declared
 static inline void *dma_alloc_wc(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t gfp)
 {
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
-	return dma_alloc_attrs(dev, size, dma_addr, gfp, &attrs);
+	return dma_alloc_attrs(dev, size, dma_addr, gfp,
+			       DMA_ATTR_WRITE_COMBINE);
 }
 #ifndef dma_alloc_writecombine
 #define dma_alloc_writecombine dma_alloc_wc
@@ -657,9 +699,8 @@ static inline void *dma_alloc_wc(struct
 static inline void dma_free_wc(struct device *dev, size_t size,
 			       void *cpu_addr, dma_addr_t dma_addr)
 {
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
-	return dma_free_attrs(dev, size, cpu_addr, dma_addr, &attrs);
+	return dma_free_attrs(dev, size, cpu_addr, dma_addr,
+			      DMA_ATTR_WRITE_COMBINE);
 }
 #ifndef dma_free_writecombine
 #define dma_free_writecombine dma_free_wc
@@ -670,9 +711,8 @@ static inline int dma_mmap_wc(struct dev
 			      void *cpu_addr, dma_addr_t dma_addr,
 			      size_t size)
 {
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
-	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, &attrs);
+	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size,
+			      DMA_ATTR_WRITE_COMBINE);
 }
 #ifndef dma_mmap_writecombine
 #define dma_mmap_writecombine dma_mmap_wc
diff -puN include/linux/swiotlb.h~dma-mapping-use-unsigned-long-for-dma_attrs include/linux/swiotlb.h
--- a/include/linux/swiotlb.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/linux/swiotlb.h
@@ -6,7 +6,6 @@
 #include <linux/types.h>
 
 struct device;
-struct dma_attrs;
 struct page;
 struct scatterlist;
 
@@ -68,10 +67,10 @@ swiotlb_free_coherent(struct device *hwd
 extern dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 				   unsigned long offset, size_t size,
 				   enum dma_data_direction dir,
-				   struct dma_attrs *attrs);
+				   unsigned long attrs);
 extern void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 			       size_t size, enum dma_data_direction dir,
-			       struct dma_attrs *attrs);
+			       unsigned long attrs);
 
 extern int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
@@ -83,12 +82,13 @@ swiotlb_unmap_sg(struct device *hwdev, s
 
 extern int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		     enum dma_data_direction dir, struct dma_attrs *attrs);
+		     enum dma_data_direction dir,
+		     unsigned long attrs);
 
 extern void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 		       int nelems, enum dma_data_direction dir,
-		       struct dma_attrs *attrs);
+		       unsigned long attrs);
 
 extern void
 swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
diff -puN include/media/videobuf2-core.h~dma-mapping-use-unsigned-long-for-dma_attrs include/media/videobuf2-core.h
--- a/include/media/videobuf2-core.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/media/videobuf2-core.h
@@ -98,7 +98,7 @@ struct vb2_threadio_data;
  *    #) Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf, unmap_dmabuf.
  */
 struct vb2_mem_ops {
-	void		*(*alloc)(struct device *dev, const struct dma_attrs *attrs,
+	void		*(*alloc)(struct device *dev, unsigned long attrs,
 				  unsigned long size, enum dma_data_direction dma_dir,
 				  gfp_t gfp_flags);
 	void		(*put)(void *buf_priv);
@@ -408,7 +408,7 @@ struct vb2_buf_ops {
  * @io_modes:	supported io methods (see vb2_io_modes enum)
  * @dev:	device to use for the default allocation context if the driver
  *		doesn't fill in the @alloc_devs array.
- * @dma_attrs:	DMA attributes to use for the DMA. May be NULL.
+ * @dma_attrs:	DMA attributes to use for the DMA.
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
@@ -476,7 +476,7 @@ struct vb2_queue {
 	unsigned int			type;
 	unsigned int			io_modes;
 	struct device			*dev;
-	const struct dma_attrs		*dma_attrs;
+	unsigned long			dma_attrs;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
diff -puN include/media/videobuf2-dma-contig.h~dma-mapping-use-unsigned-long-for-dma_attrs include/media/videobuf2-dma-contig.h
--- a/include/media/videobuf2-dma-contig.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/media/videobuf2-dma-contig.h
@@ -16,8 +16,6 @@
 #include <media/videobuf2-v4l2.h>
 #include <linux/dma-mapping.h>
 
-struct dma_attrs;
-
 static inline dma_addr_t
 vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 {
diff -puN include/rdma/ib_verbs.h~dma-mapping-use-unsigned-long-for-dma_attrs include/rdma/ib_verbs.h
--- a/include/rdma/ib_verbs.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/rdma/ib_verbs.h
@@ -2819,19 +2819,19 @@ static inline void ib_dma_unmap_single(s
 static inline u64 ib_dma_map_single_attrs(struct ib_device *dev,
 					  void *cpu_addr, size_t size,
 					  enum dma_data_direction direction,
-					  struct dma_attrs *attrs)
+					  unsigned long dma_attrs)
 {
 	return dma_map_single_attrs(dev->dma_device, cpu_addr, size,
-				    direction, attrs);
+				    direction, dma_attrs);
 }
 
 static inline void ib_dma_unmap_single_attrs(struct ib_device *dev,
 					     u64 addr, size_t size,
 					     enum dma_data_direction direction,
-					     struct dma_attrs *attrs)
+					     unsigned long dma_attrs)
 {
 	return dma_unmap_single_attrs(dev->dma_device, addr, size,
-				      direction, attrs);
+				      direction, dma_attrs);
 }
 
 /**
@@ -2906,17 +2906,18 @@ static inline void ib_dma_unmap_sg(struc
 static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
 				      struct scatterlist *sg, int nents,
 				      enum dma_data_direction direction,
-				      struct dma_attrs *attrs)
+				      unsigned long dma_attrs)
 {
-	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction, attrs);
+	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction,
+				dma_attrs);
 }
 
 static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
 					 struct scatterlist *sg, int nents,
 					 enum dma_data_direction direction,
-					 struct dma_attrs *attrs)
+					 unsigned long dma_attrs)
 {
-	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction, attrs);
+	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction, dma_attrs);
 }
 /**
  * ib_sg_dma_address - Return the DMA address from a scatter/gather entry
diff -puN include/xen/swiotlb-xen.h~dma-mapping-use-unsigned-long-for-dma_attrs include/xen/swiotlb-xen.h
--- a/include/xen/swiotlb-xen.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/xen/swiotlb-xen.h
@@ -9,30 +9,30 @@ extern int xen_swiotlb_init(int verbose,
 extern void
 *xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			    dma_addr_t *dma_handle, gfp_t flags,
-			    struct dma_attrs *attrs);
+			    unsigned long attrs);
 
 extern void
 xen_swiotlb_free_coherent(struct device *hwdev, size_t size,
 			  void *vaddr, dma_addr_t dma_handle,
-			  struct dma_attrs *attrs);
+			  unsigned long attrs);
 
 extern dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 				       unsigned long offset, size_t size,
 				       enum dma_data_direction dir,
-				       struct dma_attrs *attrs);
+				       unsigned long attrs);
 
 extern void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 				   size_t size, enum dma_data_direction dir,
-				   struct dma_attrs *attrs);
+				   unsigned long attrs);
 extern int
 xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			 int nelems, enum dma_data_direction dir,
-			 struct dma_attrs *attrs);
+			 unsigned long attrs);
 
 extern void
 xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			   int nelems, enum dma_data_direction dir,
-			   struct dma_attrs *attrs);
+			   unsigned long attrs);
 
 extern void
 xen_swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
diff -puN lib/dma-noop.c~dma-mapping-use-unsigned-long-for-dma_attrs lib/dma-noop.c
--- a/lib/dma-noop.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/lib/dma-noop.c
@@ -10,7 +10,7 @@
 
 static void *dma_noop_alloc(struct device *dev, size_t size,
 			    dma_addr_t *dma_handle, gfp_t gfp,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	void *ret;
 
@@ -22,7 +22,7 @@ static void *dma_noop_alloc(struct devic
 
 static void dma_noop_free(struct device *dev, size_t size,
 			  void *cpu_addr, dma_addr_t dma_addr,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	free_pages((unsigned long)cpu_addr, get_order(size));
 }
@@ -30,13 +30,14 @@ static void dma_noop_free(struct device
 static dma_addr_t dma_noop_map_page(struct device *dev, struct page *page,
 				      unsigned long offset, size_t size,
 				      enum dma_data_direction dir,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	return page_to_phys(page) + offset;
 }
 
 static int dma_noop_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
-			     enum dma_data_direction dir, struct dma_attrs *attrs)
+			     enum dma_data_direction dir,
+			     unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
diff -puN lib/swiotlb.c~dma-mapping-use-unsigned-long-for-dma_attrs lib/swiotlb.c
--- a/lib/swiotlb.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/lib/swiotlb.c
@@ -738,7 +738,7 @@ swiotlb_full(struct device *dev, size_t
 dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 			    unsigned long offset, size_t size,
 			    enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	phys_addr_t map, phys = page_to_phys(page) + offset;
 	dma_addr_t dev_addr = phys_to_dma(dev, phys);
@@ -807,7 +807,7 @@ static void unmap_single(struct device *
 
 void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 			size_t size, enum dma_data_direction dir,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	unmap_single(hwdev, dev_addr, size, dir);
 }
@@ -877,7 +877,7 @@ EXPORT_SYMBOL(swiotlb_sync_single_for_de
  */
 int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		     enum dma_data_direction dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -914,7 +914,7 @@ int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 	       enum dma_data_direction dir)
 {
-	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
+	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, 0);
 }
 EXPORT_SYMBOL(swiotlb_map_sg);
 
@@ -924,7 +924,8 @@ EXPORT_SYMBOL(swiotlb_map_sg);
  */
 void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
-		       int nelems, enum dma_data_direction dir, struct dma_attrs *attrs)
+		       int nelems, enum dma_data_direction dir,
+		       unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -941,7 +942,7 @@ void
 swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		 enum dma_data_direction dir)
 {
-	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
+	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, 0);
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg);
 
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are


