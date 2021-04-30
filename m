Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE70EC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFDD66147E
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhD3F61 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230308AbhD3F60 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2E176147D;
        Fri, 30 Apr 2021 05:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762259;
        bh=5Bygb5VoHcpNiQHGyWIKOgr2vklJ9PR6sAE81j2BF5o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XUr5gdH+qDWvHwo/ha+H0VErCIowrWvFQPMpearTjDtsJzjAS57QtKe2vfbsWHJ6n
         Zl+9+dXgAXzOXXI9iJoj4joqBVfnLwHZs4Fr7vRYGEFezB8Xn6CmFDBZmbVZV13loe
         qauOdkckRr9xrJV+FWTiNFzVqSR0iN5gpdInOvGk=
Date:   Thu, 29 Apr 2021 22:57:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chris-wilson.co.uk,
        daniel.vetter@ffwll.ch, hch@lst.de, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rodrigo.vivi@intel.com, torvalds@linux-foundation.org
Subject:  [patch 087/178] i915: fix remap_io_sg to verify the
 pgprot
Message-ID: <20210430055738.vRrQ3_yRK%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: i915: fix remap_io_sg to verify the pgprot

remap_io_sg claims that the pgprot is pre-verified using an io_mapping,
but actually does not get passed an io_mapping and just uses the pgprot in
the VMA.  Remove the apply_to_page_range abuse and just loop over
remap_pfn_range for each segment.

Note: this could use io_mapping_map_user by passing an iomap to
remap_io_sg if the maintainers can verify that the pgprot in the iomap in
the only caller is indeed the desired one here.

Link: https://lkml.kernel.org/r/20210326055505.1424432-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_mm.c |   73 +++++++++----------------------
 1 file changed, 23 insertions(+), 50 deletions(-)

--- a/drivers/gpu/drm/i915/i915_mm.c~i915-fix-remap_io_sg-to-verify-the-pgprot
+++ a/drivers/gpu/drm/i915/i915_mm.c
@@ -28,46 +28,10 @@
 
 #include "i915_drv.h"
 
-struct remap_pfn {
-	struct mm_struct *mm;
-	unsigned long pfn;
-	pgprot_t prot;
-
-	struct sgt_iter sgt;
-	resource_size_t iobase;
-};
+#define EXPECTED_FLAGS (VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
 
 #define use_dma(io) ((io) != -1)
 
-static inline unsigned long sgt_pfn(const struct remap_pfn *r)
-{
-	if (use_dma(r->iobase))
-		return (r->sgt.dma + r->sgt.curr + r->iobase) >> PAGE_SHIFT;
-	else
-		return r->sgt.pfn + (r->sgt.curr >> PAGE_SHIFT);
-}
-
-static int remap_sg(pte_t *pte, unsigned long addr, void *data)
-{
-	struct remap_pfn *r = data;
-
-	if (GEM_WARN_ON(!r->sgt.sgp))
-		return -EINVAL;
-
-	/* Special PTE are not associated with any struct page */
-	set_pte_at(r->mm, addr, pte,
-		   pte_mkspecial(pfn_pte(sgt_pfn(r), r->prot)));
-	r->pfn++; /* track insertions in case we need to unwind later */
-
-	r->sgt.curr += PAGE_SIZE;
-	if (r->sgt.curr >= r->sgt.max)
-		r->sgt = __sgt_iter(__sg_next(r->sgt.sgp), use_dma(r->iobase));
-
-	return 0;
-}
-
-#define EXPECTED_FLAGS (VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
-
 /**
  * remap_io_sg - remap an IO mapping to userspace
  * @vma: user vma to map to
@@ -82,12 +46,7 @@ int remap_io_sg(struct vm_area_struct *v
 		unsigned long addr, unsigned long size,
 		struct scatterlist *sgl, resource_size_t iobase)
 {
-	struct remap_pfn r = {
-		.mm = vma->vm_mm,
-		.prot = vma->vm_page_prot,
-		.sgt = __sgt_iter(sgl, use_dma(iobase)),
-		.iobase = iobase,
-	};
+	unsigned long pfn, len, remapped = 0;
 	int err;
 
 	/* We rely on prevalidation of the io-mapping to skip track_pfn(). */
@@ -96,11 +55,25 @@ int remap_io_sg(struct vm_area_struct *v
 	if (!use_dma(iobase))
 		flush_cache_range(vma, addr, size);
 
-	err = apply_to_page_range(r.mm, addr, size, remap_sg, &r);
-	if (unlikely(err)) {
-		zap_vma_ptes(vma, addr, r.pfn << PAGE_SHIFT);
-		return err;
-	}
-
-	return 0;
+	do {
+		if (use_dma(iobase)) {
+			if (!sg_dma_len(sgl))
+				break;
+			pfn = (sg_dma_address(sgl) + iobase) >> PAGE_SHIFT;
+			len = sg_dma_len(sgl);
+		} else {
+			pfn = page_to_pfn(sg_page(sgl));
+			len = sgl->length;
+		}
+
+		err = remap_pfn_range(vma, addr + remapped, pfn, len,
+				      vma->vm_page_prot);
+		if (err)
+			break;
+		remapped += len;
+	} while ((sgl = __sg_next(sgl)));
+
+	if (err)
+		zap_vma_ptes(vma, addr, remapped);
+	return err;
 }
_
