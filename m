Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F18C43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE8561490
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhD3F6Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230296AbhD3F6X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C297861459;
        Fri, 30 Apr 2021 05:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762256;
        bh=TWdVI+5oKc+mbJN/8B1Tie4E816ZSfXIV/rrvHeTXiY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XIdHj7KDOj667mEguLQrJfigt0KdHwOY4Yp+t31OjMgsLPLdj2EHHgalXJ3t4RLVQ
         QtX65JGJX8XaCrgI09/4566PMY//1x0rCIDaD/B2NUJxFi1o7IyrwjAqAaCMV8Fh+H
         BXXxEEpyJAHMF9kuoxjnJJYoQ8ZpQ4Vt9+Hc9W7k=
Date:   Thu, 29 Apr 2021 22:57:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chris-wilson.co.uk,
        daniel.vetter@ffwll.ch, hch@lst.de, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rodrigo.vivi@intel.com, torvalds@linux-foundation.org
Subject:  [patch 086/178] i915: use io_mapping_map_user
Message-ID: <20210430055735.K-Sk-TDN5%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: i915: use io_mapping_map_user

Replace the home-grown remap_io_mapping that abuses apply_to_page_range
with the proper io_mapping_map_user interface.

Link: https://lkml.kernel.org/r/20210326055505.1424432-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/Kconfig             |    1 
 drivers/gpu/drm/i915/gem/i915_gem_mman.c |    9 +---
 drivers/gpu/drm/i915/i915_drv.h          |    3 -
 drivers/gpu/drm/i915/i915_mm.c           |   44 ---------------------
 4 files changed, 5 insertions(+), 52 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c~i915-use-io_mapping_map_user
+++ a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -367,11 +367,10 @@ retry:
 		goto err_unpin;
 
 	/* Finally, remap it using the new GTT offset */
-	ret = remap_io_mapping(area,
-			       area->vm_start + (vma->ggtt_view.partial.offset << PAGE_SHIFT),
-			       (ggtt->gmadr.start + vma->node.start) >> PAGE_SHIFT,
-			       min_t(u64, vma->size, area->vm_end - area->vm_start),
-			       &ggtt->iomap);
+	ret = io_mapping_map_user(&ggtt->iomap, area, area->vm_start +
+			(vma->ggtt_view.partial.offset << PAGE_SHIFT),
+			(ggtt->gmadr.start + vma->node.start) >> PAGE_SHIFT,
+			min_t(u64, vma->size, area->vm_end - area->vm_start));
 	if (ret)
 		goto err_fence;
 
--- a/drivers/gpu/drm/i915/i915_drv.h~i915-use-io_mapping_map_user
+++ a/drivers/gpu/drm/i915/i915_drv.h
@@ -1905,9 +1905,6 @@ int i915_reg_read_ioctl(struct drm_devic
 			struct drm_file *file);
 
 /* i915_mm.c */
-int remap_io_mapping(struct vm_area_struct *vma,
-		     unsigned long addr, unsigned long pfn, unsigned long size,
-		     struct io_mapping *iomap);
 int remap_io_sg(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long size,
 		struct scatterlist *sgl, resource_size_t iobase);
--- a/drivers/gpu/drm/i915/i915_mm.c~i915-use-io_mapping_map_user
+++ a/drivers/gpu/drm/i915/i915_mm.c
@@ -37,17 +37,6 @@ struct remap_pfn {
 	resource_size_t iobase;
 };
 
-static int remap_pfn(pte_t *pte, unsigned long addr, void *data)
-{
-	struct remap_pfn *r = data;
-
-	/* Special PTE are not associated with any struct page */
-	set_pte_at(r->mm, addr, pte, pte_mkspecial(pfn_pte(r->pfn, r->prot)));
-	r->pfn++;
-
-	return 0;
-}
-
 #define use_dma(io) ((io) != -1)
 
 static inline unsigned long sgt_pfn(const struct remap_pfn *r)
@@ -77,40 +66,7 @@ static int remap_sg(pte_t *pte, unsigned
 	return 0;
 }
 
-/**
- * remap_io_mapping - remap an IO mapping to userspace
- * @vma: user vma to map to
- * @addr: target user address to start at
- * @pfn: physical address of kernel memory
- * @size: size of map area
- * @iomap: the source io_mapping
- *
- *  Note: this is only safe if the mm semaphore is held when called.
- */
-int remap_io_mapping(struct vm_area_struct *vma,
-		     unsigned long addr, unsigned long pfn, unsigned long size,
-		     struct io_mapping *iomap)
-{
-	struct remap_pfn r;
-	int err;
-
 #define EXPECTED_FLAGS (VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
-	GEM_BUG_ON((vma->vm_flags & EXPECTED_FLAGS) != EXPECTED_FLAGS);
-
-	/* We rely on prevalidation of the io-mapping to skip track_pfn(). */
-	r.mm = vma->vm_mm;
-	r.pfn = pfn;
-	r.prot = __pgprot((pgprot_val(iomap->prot) & _PAGE_CACHE_MASK) |
-			  (pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK));
-
-	err = apply_to_page_range(r.mm, addr, size, remap_pfn, &r);
-	if (unlikely(err)) {
-		zap_vma_ptes(vma, addr, (r.pfn - pfn) << PAGE_SHIFT);
-		return err;
-	}
-
-	return 0;
-}
 
 /**
  * remap_io_sg - remap an IO mapping to userspace
--- a/drivers/gpu/drm/i915/Kconfig~i915-use-io_mapping_map_user
+++ a/drivers/gpu/drm/i915/Kconfig
@@ -20,6 +20,7 @@ config DRM_I915
 	select INPUT if ACPI
 	select ACPI_VIDEO if ACPI
 	select ACPI_BUTTON if ACPI
+	select IO_MAPPING
 	select SYNC_FILE
 	select IOSF_MBI
 	select CRC32
_
