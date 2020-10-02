Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0300AC4363D
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B390E2168B
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601674161;
	bh=EzFn/ufo3N3B7GXyHZXIgi+9asimaC3Fy4Ao1jxDl8g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ewCsPy0bNGjW7d++UBgPVe+Rqe1mLKyO6UzJRn3szoIPLPpmghkUggK1IZlvBTiY3
	 7tTNUEss8nMeKSUtF5Mq9pFQIB+gvwZCsdY4iuIaTr5OWVwKaPjuLHVQuBnGf0SJJq
	 djcWjJw+FiVfvHODJjvuybB5NtLtRtHVrrY7855k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgJBV3V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJBV3V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 17:29:21 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0A77208C7;
        Fri,  2 Oct 2020 21:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601674160;
        bh=EzFn/ufo3N3B7GXyHZXIgi+9asimaC3Fy4Ao1jxDl8g=;
        h=Date:From:To:Subject:From;
        b=tuM7J8JtbwvS1qqOurB8iq8FoxfeY4ZV/JQ4lTOPaomz2pbj1CWxNM1WpszdJv3SR
         ZDWVvZa9hcDw1+g3zm+c1SBUoeqgUUpYnWRtsLaA0d9z4fIGI777ejsibVGb7Whsrc
         +b94kZQI09ADwz/lA5P9FeAQSVZG8rBXgyrmnsnA=
Date:   Fri, 02 Oct 2020 14:29:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        tvrtko.ursulin@intel.com, sstabellini@kernel.org,
        rodrigo.vivi@intel.com, peterz@infradead.org, ngupta@vflare.org,
        minchan@kernel.org, matthew.auld@intel.com,
        joonas.lahtinen@linux.intel.com, jgross@suse.com,
        jani.nikula@linux.intel.com, chris@chris-wilson.co.uk,
        boris.ostrovsky@oracle.com, hch@lst.de
Subject:  + drm-i915-use-vmap-in-i915_gem_object_map.patch added to
 -mm tree
Message-ID: <20201002212919.BJ8el%akpm@linux-foundation.org>
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

Link: https://lkml.kernel.org/r/20201002122204.1534411-9-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/Kconfig              |    1 
 drivers/gpu/drm/i915/gem/i915_gem_pages.c |  129 +++++++++-----------
 2 files changed, 61 insertions(+), 69 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c~drm-i915-use-vmap-in-i915_gem_object_map
+++ a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -232,34 +232,21 @@ unlock:
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
-				 enum i915_map_type type)
+static void *i915_gem_object_map_page(struct drm_i915_gem_object *obj,
+		enum i915_map_type type)
 {
-	unsigned long n_pte = obj->base.size >> PAGE_SHIFT;
-	struct sg_table *sgt = obj->mm.pages;
-	pte_t *stack[32], **mem;
-	struct vm_struct *area;
+	unsigned long n_pages = obj->base.size >> PAGE_SHIFT, i;
+	struct page *stack[32], **pages = stack, *page;
+	struct sgt_iter iter;
 	pgprot_t pgprot;
+	void *vaddr;
 
-	if (!i915_gem_object_has_struct_page(obj) && type != I915_MAP_WC)
-		return NULL;
-
-	if (GEM_WARN_ON(type == I915_MAP_WC &&
-			!static_cpu_has(X86_FEATURE_PAT)))
-		return NULL;
-
-	/* A single page can always be kmapped */
-	if (n_pte == 1 && type == I915_MAP_WB) {
-		struct page *page = sg_page(sgt->sgl);
-
+	switch (type) {
+	default:
+		MISSING_CASE(type);
+		fallthrough;	/* to use PAGE_KERNEL anyway */
+	case I915_MAP_WB:
 		/*
 		 * On 32b, highmem using a finite set of indirect PTE (i.e.
 		 * vmap) to provide virtual mappings of the high pages.
@@ -277,30 +264,8 @@ static void *i915_gem_object_map(struct
 		 * So if the page is beyond the 32b boundary, make an explicit
 		 * vmap.
 		 */
-		if (!PageHighMem(page))
-			return page_address(page);
-	}
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
-
-	switch (type) {
-	default:
-		MISSING_CASE(type);
-		fallthrough;	/* to use PAGE_KERNEL anyway */
-	case I915_MAP_WB:
+		if (n_pages == 1 && !PageHighMem(sg_page(obj->mm.pages->sgl)))
+			return page_address(sg_page(obj->mm.pages->sgl));
 		pgprot = PAGE_KERNEL;
 		break;
 	case I915_MAP_WC:
@@ -308,30 +273,50 @@ static void *i915_gem_object_map(struct
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
 
-		iomap = obj->mm.region->iomap.base;
-		iomap -= obj->mm.region->region.start;
+	i = 0;
+	for_each_sgt_page(page, iter, obj->mm.pages)
+		pages[i++] = page;
+	vaddr = vmap(pages, n_pages, 0, pgprot);
+	if (pages != stack)
+		kvfree(pages);
+	return vaddr;
+}
 
-		for_each_sgt_daddr(addr, iter, sgt)
-			**ptes++ = iomap_pte(iomap, addr, pgprot);
-	}
+static void *i915_gem_object_map_pfn(struct drm_i915_gem_object *obj,
+		enum i915_map_type type)
+{
+	resource_size_t iomap = obj->mm.region->iomap.base -
+		obj->mm.region->region.start;
+	unsigned long n_pfn = obj->base.size >> PAGE_SHIFT;
+	unsigned long stack[32], *pfns = stack, i;
+	struct sgt_iter iter;
+	dma_addr_t addr;
+	void *vaddr;
 
-	if (mem != stack)
-		kvfree(mem);
+	if (type != I915_MAP_WC)
+		return NULL;
+
+	if (n_pfn > ARRAY_SIZE(stack)) {
+		/* Too big for stack -- allocate temporary array instead */
+		pfns = kvmalloc_array(n_pfn, sizeof(*pfns), GFP_KERNEL);
+		if (!pfns)
+			return NULL;
+	}
 
-	return area->addr;
+	i = 0;
+	for_each_sgt_daddr(addr, iter, obj->mm.pages)
+		pfns[i++] = (iomap + addr) >> PAGE_SHIFT;
+	vaddr = vmap_pfn(pfns, n_pfn, pgprot_writecombine(PAGE_KERNEL_IO));
+	if (pfns != stack)
+		kvfree(pfns);
+	return vaddr;
 }
 
 /* get, pin, and map the pages of the object into kernel space */
@@ -383,7 +368,13 @@ void *i915_gem_object_pin_map(struct drm
 	}
 
 	if (!ptr) {
-		ptr = i915_gem_object_map(obj, type);
+		if (GEM_WARN_ON(type == I915_MAP_WC &&
+				!static_cpu_has(X86_FEATURE_PAT)))
+			ptr = NULL;
+		else if (i915_gem_object_has_struct_page(obj))
+			ptr = i915_gem_object_map_page(obj, type);
+		else
+			ptr = i915_gem_object_map_pfn(obj, type);
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

mm-add-a-vm_map_put_pages-flag-for-vmap.patch
mm-add-a-vmap_pfn-function.patch
mm-allow-a-null-fn-callback-in-apply_to_page_range.patch
zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
drm-i915-use-vmap-in-shmem_pin_map.patch
drm-i915-stop-using-kmap-in-i915_gem_object_map.patch
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch
mm-remove-alloc_vm_area.patch
mm-cleanup-the-gfp_mask-handling-in-__vmalloc_area_node.patch
mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc.patch

