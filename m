Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1926C43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74E4E221EC
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600474130;
	bh=sEMDX9Y8kaHlANqvpFvPQMyB6RsqOgjYFNwZLPh6O3E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GFhduu8v3yJ0M/7usUoD+rkpGT1QGB9+0AgngFDLnKpYnj2sAVzH2fI/Lw4vPny+C
	 HQUK7YKijlZvnq1+qoSBakE5fQSgGYYo2DuGHNytZLkH8u+bzbgdMg8Vl8oL/9WL01
	 kktQqz09Ur71F0HZctddKl/bogSHjRWZokrfQwFg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgISAIu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAIu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:08:50 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FC7421D7B;
        Sat, 19 Sep 2020 00:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600474129;
        bh=sEMDX9Y8kaHlANqvpFvPQMyB6RsqOgjYFNwZLPh6O3E=;
        h=Date:From:To:Subject:From;
        b=CJ9lfK8uEcCrXZK0ujxRksykBdkGG7Ttd1kypS01avllBph0YXRnzs9iFiN/5LMV5
         kw6YPJ2/nVnwCOx+UyyHw84y7nthsyZGPwv5jZT7EdWy+2fVcuZRYsxwrSDYK7znk5
         RyRUXyHLGuCRbFlYc1M5TaoQgTRnmbQwgcuotcGI=
Date:   Fri, 18 Sep 2020 17:08:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hch@lst.de
Subject:  + drm-i915-use-vmap-in-i915_gem_object_map.patch added to
 -mm tree
Message-ID: <20200919000848.hH5ld%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: use vmap in i915_gem_object_map
has been added to the -mm tree.  Its filename is
     drm-i915-use-vmap-in-i915_gem_object_map.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drm-i915-use-vmap-in-i915_gem_object_map.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drm-i915-use-vmap-in-i915_gem_object_map.patch

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
Subject: drm/i915: use vmap in i915_gem_object_map

i915_gem_object_map implements fairly low-level vmap functionality in a
driver.  Split it into two helpers, one for remapping kernel memory which
can use vmap, and one for I/O memory that uses vmap_pfn.

The only practical difference is that alloc_vm_area prefeaults the vmalloc
area PTEs, which doesn't seem to be required here for the kernel memory
case (and could be added to vmap using a flag if actually required).

Link: https://lkml.kernel.org/r/20200918163724.2511-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/Kconfig              |    1 
 drivers/gpu/drm/i915/gem/i915_gem_pages.c |  101 +++++++++-----------
 2 files changed, 47 insertions(+), 55 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c~drm-i915-use-vmap-in-i915_gem_object_map
+++ a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -234,50 +234,24 @@ unlock:
 	return err;
 }
 
-static inline pte_t iomap_pte(resource_size_t base,
-			      dma_addr_t offset,
-			      pgprot_t prot)
-{
-	return pte_mkspecial(pfn_pte((base + offset) >> PAGE_SHIFT, prot));
-}
-
 /* The 'mapping' part of i915_gem_object_pin_map() below */
-static void *i915_gem_object_map(struct drm_i915_gem_object *obj,
+static void *i915_gem_object_map_page(struct drm_i915_gem_object *obj,
 				 enum i915_map_type type)
 {
-	unsigned long n_pte = obj->base.size >> PAGE_SHIFT;
-	struct sg_table *sgt = obj->mm.pages;
-	pte_t *stack[32], **mem;
-	struct vm_struct *area;
+	unsigned long n_pages = obj->base.size >> PAGE_SHIFT, i;
+	struct page *stack[32], **pages = stack, *page;
+	struct sgt_iter iter;
 	pgprot_t pgprot;
-
-	if (!i915_gem_object_has_struct_page(obj) && type != I915_MAP_WC)
-		return NULL;
-
-	/* A single page can always be kmapped */
-	if (n_pte == 1 && type == I915_MAP_WB)
-		return kmap(sg_page(sgt->sgl));
-
-	mem = stack;
-	if (n_pte > ARRAY_SIZE(stack)) {
-		/* Too big for stack -- allocate temporary array instead */
-		mem = kvmalloc_array(n_pte, sizeof(*mem), GFP_KERNEL);
-		if (!mem)
-			return NULL;
-	}
-
-	area = alloc_vm_area(obj->base.size, mem);
-	if (!area) {
-		if (mem != stack)
-			kvfree(mem);
-		return NULL;
-	}
+	void *vaddr;
 
 	switch (type) {
 	default:
 		MISSING_CASE(type);
 		fallthrough;	/* to use PAGE_KERNEL anyway */
 	case I915_MAP_WB:
+		/* A single page can always be kmapped */
+		if (n_pages == 1)
+			return kmap(sg_page(obj->mm.pages->sgl));
 		pgprot = PAGE_KERNEL;
 		break;
 	case I915_MAP_WC:
@@ -285,30 +259,44 @@ static void *i915_gem_object_map(struct
 		break;
 	}
 
-	if (i915_gem_object_has_struct_page(obj)) {
-		struct sgt_iter iter;
-		struct page *page;
-		pte_t **ptes = mem;
-
-		for_each_sgt_page(page, iter, sgt)
-			**ptes++ = mk_pte(page, pgprot);
-	} else {
-		resource_size_t iomap;
-		struct sgt_iter iter;
-		pte_t **ptes = mem;
-		dma_addr_t addr;
+	if (n_pages > ARRAY_SIZE(stack)) {
+		/* Too big for stack -- allocate temporary array instead */
+		pages = kvmalloc_array(n_pages, sizeof(*pages), GFP_KERNEL);
+		if (!pages)
+			return NULL;
+	}
+
+	for_each_sgt_page(page, iter, obj->mm.pages)
+		pages[i++] = page;
+	vaddr = vmap(pages, n_pages, 0, pgprot);
+	if (pages != stack)
+		kvfree(pages);
+	return vaddr;
+}
 
-		iomap = obj->mm.region->iomap.base;
-		iomap -= obj->mm.region->region.start;
+static void *i915_gem_object_map_pfn(struct drm_i915_gem_object *obj)
+{
+	resource_size_t iomap = obj->mm.region->iomap.base -
+		obj->mm.region->region.start;
+	unsigned long n_pfn = obj->base.size >> PAGE_SHIFT;
+	unsigned long stack[32], *pfns = stack, i;
+	struct sgt_iter iter;
+	dma_addr_t addr;
+	void *vaddr;
 
-		for_each_sgt_daddr(addr, iter, sgt)
-			**ptes++ = iomap_pte(iomap, addr, pgprot);
+	if (n_pfn > ARRAY_SIZE(stack)) {
+		/* Too big for stack -- allocate temporary array instead */
+		pfns = kvmalloc_array(n_pfn, sizeof(*pfns), GFP_KERNEL);
+		if (!pfns)
+			return NULL;
 	}
 
-	if (mem != stack)
-		kvfree(mem);
-
-	return area->addr;
+	for_each_sgt_daddr(addr, iter, obj->mm.pages)
+		pfns[i++] = (iomap + addr) >> PAGE_SHIFT;
+	vaddr = vmap_pfn(pfns, n_pfn, pgprot_writecombine(PAGE_KERNEL_IO));
+	if (pfns != stack)
+		kvfree(pfns);
+	return vaddr;
 }
 
 /* get, pin, and map the pages of the object into kernel space */
@@ -360,7 +348,10 @@ void *i915_gem_object_pin_map(struct drm
 	}
 
 	if (!ptr) {
-		ptr = i915_gem_object_map(obj, type);
+		if (i915_gem_object_has_struct_page(obj))
+			ptr = i915_gem_object_map_page(obj, type);
+		else if (type == I915_MAP_WC)
+			ptr = i915_gem_object_map_pfn(obj);
 		if (!ptr) {
 			err = -ENOMEM;
 			goto err_unpin;
--- a/drivers/gpu/drm/i915/Kconfig~drm-i915-use-vmap-in-i915_gem_object_map
+++ a/drivers/gpu/drm/i915/Kconfig
@@ -25,6 +25,7 @@ config DRM_I915
 	select CRC32
 	select SND_HDA_I915 if SND_HDA_CORE
 	select CEC_CORE if CEC_NOTIFIER
+	select VMAP_PFN
 	help
 	  Choose this option if you have a system that has "Intel Graphics
 	  Media Accelerator" or "HD Graphics" integrated graphics,
_

Patches currently in -mm which might be from hch@lst.de are

zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
mm-add-a-vmap_pfn-function.patch
drm-i915-use-vmap-in-shmem_pin_map.patch
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch

