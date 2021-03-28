Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB75C433E9
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9F03619CA
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhC1TLq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231549AbhC1TLk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21C016196E;
        Sun, 28 Mar 2021 19:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958700;
        bh=rd+ECbWqFKPVcFb9bfXCrzWG1RHfDGM202gQqS4leI8=;
        h=Date:From:To:Subject:From;
        b=HHybwITblXZ9ZcYqBXKg8pYu+BE7l5cBv0KuaFRrzzSmO+KtFO1TBbRTJ8+uOKl6c
         11vOqF4f0FmPvtGNZ2IrnDl4p4Fb4AsufJr277VQHs0EYr4AvB0l3xY6xVNb1AWV0I
         MlUNif/ElF9qpwXGQkOXbWeVAC92atUX2nWwbcRI=
Date:   Sun, 28 Mar 2021 12:11:39 -0700
From:   akpm@linux-foundation.org
To:     chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch, hch@lst.de,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rodrigo.vivi@intel.com
Subject:  + i915-use-io_mapping_map_user.patch added to -mm tree
Message-ID: <20210328191139.hIddViLWM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: i915: use io_mapping_map_user
has been added to the -mm tree.  Its filename is
     i915-use-io_mapping_map_user.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/i915-use-io_mapping_map_user.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/i915-use-io_mapping_map_user.patch

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
@@ -363,11 +363,10 @@ retry:
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
@@ -1973,9 +1973,6 @@ int i915_reg_read_ioctl(struct drm_devic
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

Patches currently in -mm which might be from hch@lst.de are

mm-add-remap_pfn_range_notrack.patch
mm-add-a-io_mapping_map_user-helper.patch
i915-use-io_mapping_map_user.patch
i915-fix-remap_io_sg-to-verify-the-pgprot.patch
samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch
mm-unexport-remap_vmalloc_range_partial.patch

