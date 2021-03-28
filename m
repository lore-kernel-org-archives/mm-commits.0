Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E150AC433EA
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB5A561958
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhC1TLr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231551AbhC1TLl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46F9C6197F;
        Sun, 28 Mar 2021 19:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958701;
        bh=bsH2+3RQhTMTY213TlrgyspXjOoyYkMLJROiXkHpges=;
        h=Date:From:To:Subject:From;
        b=erMNN3rV0kccYKBxhcYN3z6QYdhg4UNaUQ4poBg2+3DxeQhO+4cSUi7UQXLBctS3/
         vM9i3u5LitzknrNvcGS1ZkKENSVKSg/ccovXPJ0i2MgKtBdRfopjK7ee+Z6iOpkno6
         ULDranCt4A1fKyEMTvXk6g/iQD8KHi8GCoteu4BM=
Date:   Sun, 28 Mar 2021 12:11:40 -0700
From:   akpm@linux-foundation.org
To:     chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch, hch@lst.de,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rodrigo.vivi@intel.com
Subject:  + i915-fix-remap_io_sg-to-verify-the-pgprot.patch added
 to -mm tree
Message-ID: <20210328191140.G_ehsKCen%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: i915: fix remap_io_sg to verify the pgprot
has been added to the -mm tree.  Its filename is
     i915-fix-remap_io_sg-to-verify-the-pgprot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/i915-fix-remap_io_sg-to-verify-the-pgprot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/i915-fix-remap_io_sg-to-verify-the-pgprot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: i915: fix remap_io_sg to verify the pgprot

remap_io_sg claims that that the pgprot is pre-verified using an
io_mapping, but actually does not get passed an io_mapping and just uses
the pgprot in the VMA.  Remove the apply_to_page_range abuse and just loop
over remap_pfn_range for each segment.

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

Patches currently in -mm which might be from hch@lst.de are

mm-add-remap_pfn_range_notrack.patch
mm-add-a-io_mapping_map_user-helper.patch
i915-use-io_mapping_map_user.patch
i915-fix-remap_io_sg-to-verify-the-pgprot.patch
samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch
mm-unexport-remap_vmalloc_range_partial.patch

