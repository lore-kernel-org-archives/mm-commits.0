From: akpm@linux-foundation.org
Subject: [merged] drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:57 -0700
Message-ID: <201107260754.p6Q7s02N003304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab1GZHyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, airlied@linux.ie, jgarzik@pobox.com, joe@perches.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers: use kzalloc/kcalloc instead of 'kmalloc+memset', where possible
has been removed from the -mm tree.  Its filename was
     drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers: use kzalloc/kcalloc instead of 'kmalloc+memset', where possible
From: Rakib Mullick <rakib.mullick@gmail.com>

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_dwc_460ex.c             |    3 +--
 drivers/gpu/drm/drm_scatter.c            |   10 +++-------
 drivers/gpu/drm/radeon/radeon_mem.c      |    3 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c  |    3 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |    8 +++-----
 drivers/gpu/vga/vgaarb.c                 |    3 +--
 6 files changed, 10 insertions(+), 20 deletions(-)

diff -puN drivers/ata/sata_dwc_460ex.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible drivers/ata/sata_dwc_460ex.c
--- a/drivers/ata/sata_dwc_460ex.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible
+++ a/drivers/ata/sata_dwc_460ex.c
@@ -1638,13 +1638,12 @@ static int sata_dwc_probe(struct platfor
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 
 	/* Allocate DWC SATA device */
-	hsdev = kmalloc(sizeof(*hsdev), GFP_KERNEL);
+	hsdev = kzalloc(sizeof(*hsdev), GFP_KERNEL);
 	if (hsdev == NULL) {
 		dev_err(&ofdev->dev, "kmalloc failed for hsdev\n");
 		err = -ENOMEM;
 		goto error_out;
 	}
-	memset(hsdev, 0, sizeof(*hsdev));
 
 	/* Ioremap SATA registers */
 	base = of_iomap(ofdev->dev.of_node, 0);
diff -puN drivers/gpu/drm/drm_scatter.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible drivers/gpu/drm/drm_scatter.c
--- a/drivers/gpu/drm/drm_scatter.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible
+++ a/drivers/gpu/drm/drm_scatter.c
@@ -83,30 +83,26 @@ int drm_sg_alloc(struct drm_device *dev,
 	if (dev->sg)
 		return -EINVAL;
 
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
 
-	memset(entry, 0, sizeof(*entry));
 	pages = (request->size + PAGE_SIZE - 1) / PAGE_SIZE;
 	DRM_DEBUG("size=%ld pages=%ld\n", request->size, pages);
 
 	entry->pages = pages;
-	entry->pagelist = kmalloc(pages * sizeof(*entry->pagelist), GFP_KERNEL);
+	entry->pagelist = kcalloc(pages, sizeof(*entry->pagelist), GFP_KERNEL);
 	if (!entry->pagelist) {
 		kfree(entry);
 		return -ENOMEM;
 	}
 
-	memset(entry->pagelist, 0, pages * sizeof(*entry->pagelist));
-
-	entry->busaddr = kmalloc(pages * sizeof(*entry->busaddr), GFP_KERNEL);
+	entry->busaddr = kcalloc(pages, sizeof(*entry->busaddr), GFP_KERNEL);
 	if (!entry->busaddr) {
 		kfree(entry->pagelist);
 		kfree(entry);
 		return -ENOMEM;
 	}
-	memset((void *)entry->busaddr, 0, pages * sizeof(*entry->busaddr));
 
 	entry->virtual = drm_vmalloc_dma(pages << PAGE_SHIFT);
 	if (!entry->virtual) {
diff -puN drivers/gpu/drm/radeon/radeon_mem.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible drivers/gpu/drm/radeon/radeon_mem.c
--- a/drivers/gpu/drm/radeon/radeon_mem.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible
+++ a/drivers/gpu/drm/radeon/radeon_mem.c
@@ -139,7 +139,7 @@ static int init_heap(struct mem_block **
 	if (!blocks)
 		return -ENOMEM;
 
-	*heap = kmalloc(sizeof(**heap), GFP_KERNEL);
+	*heap = kzalloc(sizeof(**heap), GFP_KERNEL);
 	if (!*heap) {
 		kfree(blocks);
 		return -ENOMEM;
@@ -150,7 +150,6 @@ static int init_heap(struct mem_block **
 	blocks->file_priv = NULL;
 	blocks->next = blocks->prev = *heap;
 
-	memset(*heap, 0, sizeof(**heap));
 	(*heap)->file_priv = (struct drm_file *) - 1;
 	(*heap)->next = (*heap)->prev = blocks;
 	return 0;
diff -puN drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -585,11 +585,10 @@ int vmw_overlay_init(struct vmw_private 
 		return -ENOSYS;
 	}
 
-	overlay = kmalloc(sizeof(*overlay), GFP_KERNEL);
+	overlay = kzalloc(sizeof(*overlay), GFP_KERNEL);
 	if (!overlay)
 		return -ENOMEM;
 
-	memset(overlay, 0, sizeof(*overlay));
 	mutex_init(&overlay->mutex);
 	for (i = 0; i < VMW_MAX_NUM_STREAMS; i++) {
 		overlay->stream[i].buf = NULL;
diff -puN drivers/gpu/drm/vmwgfx/vmwgfx_resource.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -612,11 +612,9 @@ int vmw_surface_define_ioctl(struct drm_
 	    srf->sizes[0].height == 64 &&
 	    srf->format == SVGA3D_A8R8G8B8) {
 
-		srf->snooper.image = kmalloc(64 * 64 * 4, GFP_KERNEL);
-		/* clear the image */
-		if (srf->snooper.image) {
-			memset(srf->snooper.image, 0x00, 64 * 64 * 4);
-		} else {
+		/* allocate image area and clear it */
+		srf->snooper.image = kzalloc(64 * 64 * 4, GFP_KERNEL);
+		if (!srf->snooper.image) {
 			DRM_ERROR("Failed to allocate cursor_image\n");
 			ret = -ENOMEM;
 			goto out_err1;
diff -puN drivers/gpu/vga/vgaarb.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible drivers/gpu/vga/vgaarb.c
--- a/drivers/gpu/vga/vgaarb.c~drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible
+++ a/drivers/gpu/vga/vgaarb.c
@@ -1171,10 +1171,9 @@ static int vga_arb_open(struct inode *in
 
 	pr_debug("%s\n", __func__);
 
-	priv = kmalloc(sizeof(struct vga_arb_private), GFP_KERNEL);
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv == NULL)
 		return -ENOMEM;
-	memset(priv, 0, sizeof(*priv));
 	spin_lock_init(&priv->lock);
 	file->private_data = priv;
 
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch

