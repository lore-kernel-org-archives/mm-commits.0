From: akpm@linux-foundation.org
Subject: [merged] ivtv-convert-get_user_pages-pin_user_pages.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:39:58 -0700
Message-ID: <20200602213958.pHDprIuqD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVj7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: awalls@md.metrocast.net, jhubbard@nvidia.com, mchehab@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ivtv: convert get_user_pages() --> pin_user_pages()
has been removed from the -mm tree.  Its filename was
     ivtv-convert-get_user_pages-pin_user_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: ivtv: convert get_user_pages() --> pin_user_pages()

This code was using get_user_pages*(), in a "Case 2" scenario (DMA/RDMA),
using the categorization from [1].  That means that it's time to convert
the get_user_pages*() + put_page() calls to pin_user_pages*() +
unpin_user_pages() calls.

There is some helpful background in [2]: basically, this is a small part
of fixing a long-standing disconnect between pinning pages, and file
systems' use of those pages.

[1] Documentation/core-api/pin_user_pages.rst

[2] "Explicit pinning of user-space pages":
    https://lwn.net/Articles/807108/

Link: http://lkml.kernel.org/r/20200518012157.1178336-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/ivtv/ivtv-udma.c |   19 ++++++-------------
 drivers/media/pci/ivtv/ivtv-yuv.c  |   17 ++++++-----------
 drivers/media/pci/ivtv/ivtvfb.c    |    4 ++--
 3 files changed, 14 insertions(+), 26 deletions(-)

--- a/drivers/media/pci/ivtv/ivtvfb.c~ivtv-convert-get_user_pages-pin_user_pages
+++ a/drivers/media/pci/ivtv/ivtvfb.c
@@ -281,10 +281,10 @@ static int ivtvfb_prep_dec_dma_to_device
 	/* Map User DMA */
 	if (ivtv_udma_setup(itv, ivtv_dest_addr, userbuf, size_in_bytes) <= 0) {
 		mutex_unlock(&itv->udma.lock);
-		IVTVFB_WARN("ivtvfb_prep_dec_dma_to_device, Error with get_user_pages: %d bytes, %d pages returned\n",
+		IVTVFB_WARN("ivtvfb_prep_dec_dma_to_device, Error with pin_user_pages: %d bytes, %d pages returned\n",
 			       size_in_bytes, itv->udma.page_count);
 
-		/* get_user_pages must have failed completely */
+		/* pin_user_pages must have failed completely */
 		return -EIO;
 	}
 
--- a/drivers/media/pci/ivtv/ivtv-udma.c~ivtv-convert-get_user_pages-pin_user_pages
+++ a/drivers/media/pci/ivtv/ivtv-udma.c
@@ -92,7 +92,7 @@ int ivtv_udma_setup(struct ivtv *itv, un
 {
 	struct ivtv_dma_page_info user_dma;
 	struct ivtv_user_dma *dma = &itv->udma;
-	int i, err;
+	int err;
 
 	IVTV_DEBUG_DMA("ivtv_udma_setup, dst: 0x%08x\n", (unsigned int)ivtv_dest_addr);
 
@@ -111,16 +111,15 @@ int ivtv_udma_setup(struct ivtv *itv, un
 		return -EINVAL;
 	}
 
-	/* Get user pages for DMA Xfer */
-	err = get_user_pages_unlocked(user_dma.uaddr, user_dma.page_count,
+	/* Pin user pages for DMA Xfer */
+	err = pin_user_pages_unlocked(user_dma.uaddr, user_dma.page_count,
 			dma->map, FOLL_FORCE);
 
 	if (user_dma.page_count != err) {
 		IVTV_DEBUG_WARN("failed to map user pages, returned %d instead of %d\n",
 			   err, user_dma.page_count);
 		if (err >= 0) {
-			for (i = 0; i < err; i++)
-				put_page(dma->map[i]);
+			unpin_user_pages(dma->map, err);
 			return -EINVAL;
 		}
 		return err;
@@ -130,9 +129,7 @@ int ivtv_udma_setup(struct ivtv *itv, un
 
 	/* Fill SG List with new values */
 	if (ivtv_udma_fill_sg_list(dma, &user_dma, 0) < 0) {
-		for (i = 0; i < dma->page_count; i++) {
-			put_page(dma->map[i]);
-		}
+		unpin_user_pages(dma->map, dma->page_count);
 		dma->page_count = 0;
 		return -ENOMEM;
 	}
@@ -153,7 +150,6 @@ int ivtv_udma_setup(struct ivtv *itv, un
 void ivtv_udma_unmap(struct ivtv *itv)
 {
 	struct ivtv_user_dma *dma = &itv->udma;
-	int i;
 
 	IVTV_DEBUG_INFO("ivtv_unmap_user_dma\n");
 
@@ -169,10 +165,7 @@ void ivtv_udma_unmap(struct ivtv *itv)
 	/* sync DMA */
 	ivtv_udma_sync_for_cpu(itv);
 
-	/* Release User Pages */
-	for (i = 0; i < dma->page_count; i++) {
-		put_page(dma->map[i]);
-	}
+	unpin_user_pages(dma->map, dma->page_count);
 	dma->page_count = 0;
 }
 
--- a/drivers/media/pci/ivtv/ivtv-yuv.c~ivtv-convert-get_user_pages-pin_user_pages
+++ a/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -30,7 +30,6 @@ static int ivtv_yuv_prep_user_dma(struct
 	struct yuv_playback_info *yi = &itv->yuv_info;
 	u8 frame = yi->draw_frame;
 	struct yuv_frame_info *f = &yi->new_frame_info[frame];
-	int i;
 	int y_pages, uv_pages;
 	unsigned long y_buffer_offset, uv_buffer_offset;
 	int y_decode_height, uv_decode_height, y_size;
@@ -62,12 +61,12 @@ static int ivtv_yuv_prep_user_dma(struct
 	ivtv_udma_get_page_info (&y_dma, (unsigned long)args->y_source, 720 * y_decode_height);
 	ivtv_udma_get_page_info (&uv_dma, (unsigned long)args->uv_source, 360 * uv_decode_height);
 
-	/* Get user pages for DMA Xfer */
-	y_pages = get_user_pages_unlocked(y_dma.uaddr,
+	/* Pin user pages for DMA Xfer */
+	y_pages = pin_user_pages_unlocked(y_dma.uaddr,
 			y_dma.page_count, &dma->map[0], FOLL_FORCE);
 	uv_pages = 0; /* silence gcc. value is set and consumed only if: */
 	if (y_pages == y_dma.page_count) {
-		uv_pages = get_user_pages_unlocked(uv_dma.uaddr,
+		uv_pages = pin_user_pages_unlocked(uv_dma.uaddr,
 				uv_dma.page_count, &dma->map[y_pages],
 				FOLL_FORCE);
 	}
@@ -81,8 +80,7 @@ static int ivtv_yuv_prep_user_dma(struct
 				 uv_pages, uv_dma.page_count);
 
 			if (uv_pages >= 0) {
-				for (i = 0; i < uv_pages; i++)
-					put_page(dma->map[y_pages + i]);
+				unpin_user_pages(&dma->map[y_pages], uv_pages);
 				rc = -EFAULT;
 			} else {
 				rc = uv_pages;
@@ -93,8 +91,7 @@ static int ivtv_yuv_prep_user_dma(struct
 				 y_pages, y_dma.page_count);
 		}
 		if (y_pages >= 0) {
-			for (i = 0; i < y_pages; i++)
-				put_page(dma->map[i]);
+			unpin_user_pages(dma->map, y_pages);
 			/*
 			 * Inherit the -EFAULT from rc's
 			 * initialization, but allow it to be
@@ -112,9 +109,7 @@ static int ivtv_yuv_prep_user_dma(struct
 	/* Fill & map SG List */
 	if (ivtv_udma_fill_sg_list (dma, &uv_dma, ivtv_udma_fill_sg_list (dma, &y_dma, 0)) < 0) {
 		IVTV_DEBUG_WARN("could not allocate bounce buffers for highmem userspace buffers\n");
-		for (i = 0; i < dma->page_count; i++) {
-			put_page(dma->map[i]);
-		}
+		unpin_user_pages(dma->map, dma->page_count);
 		dma->page_count = 0;
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code-fix.patch
mm-gup-introduce-pin_user_pages_fast_only.patch
drm-i915-convert-get_user_pages-pin_user_pages.patch
mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch
khugepaged-add-self-test-fix-3.patch
rapidio-convert-get_user_pages-pin_user_pages.patch
mm-gup-update-pin_user_pagesrst-for-case-3-mmu-notifiers.patch
mm-gup-introduce-pin_user_pages_locked.patch
mm-gup-introduce-pin_user_pages_locked-v2.patch
mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch
mm-gup-documentation-fix-for-pin_user_pages-apis.patch
docs-mm-gup-pin_user_pagesrst-add-a-case-5.patch
vhost-convert-get_user_pages-pin_user_pages.patch
