From: akpm@linux-foundation.org
Subject: + media-dma-mapping-use-unsigned-long-for-dma_attrs.patch added
 to -mm tree
Date: Wed, 13 Jul 2016 14:51:20 -0700
Message-ID: <5786b7d8.KlN7ic2iM8C6nPnI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcGMVvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:51:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, fabien.dessenne@st.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: media: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     media-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/media-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/media-dma-mapping-use-unsigned-long-for-dma_attrs.patch

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
Subject: media: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-19-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Fabien Dessenne <fabien.dessenne@st.com> [bdisp]
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com> [vb2-core]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/platform/sti/bdisp/bdisp-hw.c    |   26 ++++---------
 drivers/media/v4l2-core/videobuf2-dma-contig.c |   28 +++++----------
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |   21 ++---------
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |    2 -
 include/media/videobuf2-core.h                 |    6 +--
 include/media/videobuf2-dma-contig.h           |    2 -
 6 files changed, 28 insertions(+), 57 deletions(-)

diff -puN drivers/media/platform/sti/bdisp/bdisp-hw.c~media-dma-mapping-use-unsigned-long-for-dma_attrs drivers/media/platform/sti/bdisp/bdisp-hw.c
--- a/drivers/media/platform/sti/bdisp/bdisp-hw.c~media-dma-mapping-use-unsigned-long-for-dma_attrs
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
 
diff -puN drivers/media/v4l2-core/videobuf2-dma-contig.c~media-dma-mapping-use-unsigned-long-for-dma_attrs drivers/media/v4l2-core/videobuf2-dma-contig.c
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c~media-dma-mapping-use-unsigned-long-for-dma_attrs
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
+	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, buf->attrs))
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
diff -puN drivers/media/v4l2-core/videobuf2-dma-sg.c~media-dma-mapping-use-unsigned-long-for-dma_attrs drivers/media/v4l2-core/videobuf2-dma-sg.c
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c~media-dma-mapping-use-unsigned-long-for-dma_attrs
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
diff -puN drivers/media/v4l2-core/videobuf2-vmalloc.c~media-dma-mapping-use-unsigned-long-for-dma_attrs drivers/media/v4l2-core/videobuf2-vmalloc.c
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c~media-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -33,7 +33,7 @@ struct vb2_vmalloc_buf {
 
 static void vb2_vmalloc_put(void *buf_priv);
 
-static void *vb2_vmalloc_alloc(struct device *dev, const struct dma_attrs *attrs,
+static void *vb2_vmalloc_alloc(struct device *dev, unsigned long attrs,
 			       unsigned long size, enum dma_data_direction dma_dir,
 			       gfp_t gfp_flags)
 {
diff -puN include/media/videobuf2-core.h~media-dma-mapping-use-unsigned-long-for-dma_attrs include/media/videobuf2-core.h
--- a/include/media/videobuf2-core.h~media-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/media/videobuf2-core.h
@@ -92,7 +92,7 @@ struct vb2_threadio_data;
  *				  unmap_dmabuf.
  */
 struct vb2_mem_ops {
-	void		*(*alloc)(struct device *dev, const struct dma_attrs *attrs,
+	void		*(*alloc)(struct device *dev, unsigned long attrs,
 				  unsigned long size, enum dma_data_direction dma_dir,
 				  gfp_t gfp_flags);
 	void		(*put)(void *buf_priv);
@@ -402,7 +402,7 @@ struct vb2_buf_ops {
  * @io_modes:	supported io methods (see vb2_io_modes enum)
  * @dev:	device to use for the default allocation context if the driver
  *		doesn't fill in the @alloc_devs array.
- * @dma_attrs:	DMA attributes to use for the DMA. May be NULL.
+ * @dma_attrs:	DMA attributes to use for the DMA.
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
@@ -470,7 +470,7 @@ struct vb2_queue {
 	unsigned int			type;
 	unsigned int			io_modes;
 	struct device			*dev;
-	const struct dma_attrs		*dma_attrs;
+	unsigned long			dma_attrs;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
diff -puN include/media/videobuf2-dma-contig.h~media-dma-mapping-use-unsigned-long-for-dma_attrs include/media/videobuf2-dma-contig.h
--- a/include/media/videobuf2-dma-contig.h~media-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/media/videobuf2-dma-contig.h
@@ -16,8 +16,6 @@
 #include <media/videobuf2-v4l2.h>
 #include <linux/dma-mapping.h>
 
-struct dma_attrs;
-
 static inline dma_addr_t
 vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 {
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

