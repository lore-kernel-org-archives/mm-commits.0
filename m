Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52775C38A2D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 19:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJUT0m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 15:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiJUT0m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 15:26:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F314265528
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 12:26:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0E6161F55
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 19:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDBBC433C1;
        Fri, 21 Oct 2022 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666380399;
        bh=3ZIXuQxYtg+YFi60H9wDOzx7mJkoDRglD9cs4dexlkU=;
        h=Date:To:From:Subject:From;
        b=VcMtEzNyaWop/5e5U43qrW3Z7Hgl07ATPHL5xze63DhXDcEgEWHzBXJVMkM7O5Yc4
         WGxa7sJ3gI6FtdSoL6/M64AALFJXlNag1JIcDWhAEboayW3zE5vKGs5YQ7hM2yyxea
         kUHOlGCJsG2NGn+sY4pICxmMArsorhz9SsM/LVkY=
Date:   Fri, 21 Oct 2022 12:26:38 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, kherbst@redhat.com,
        jhubbard@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, daniel@ffwll.ch, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alexander.deucher@amd.com,
        airlied@linux.ie, dan.j.williams@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch added to mm-unstable branch
Message-Id: <20221021192639.3FDBBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap: Introduce pgmap_request_folio() using pgmap offsets
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm/memremap: Introduce pgmap_request_folio() using pgmap offsets
Date: Thu, 20 Oct 2022 14:56:39 -0700

A 'struct dev_pagemap' (pgmap) represents a collection of ZONE_DEVICE
pages. The pgmap is a reference counted object that serves a similar
role as a 'struct request_queue'. Live references are obtained for each
in flight request / page, and once a page's reference count drops to
zero the associated pin of the pgmap is dropped as well. While a page is
idle nothing should be accessing it because that is effectively a
use-after-free situation. Unfortunately, all current ZONE_DEVICE
implementations deploy a layering violation to manage requests to
activate pages owned by a pgmap. Specifically, they take steps like walk
the pfns that were previously assigned at memremap_pages() time and use
pfn_to_page() to recall metadata like page->pgmap, or make use of other
data like page->zone_device_data.

The first step towards correcting that situation is to provide a
API to get access to a pgmap page that does not require the caller to
know the pfn, nor access any fields of an idle page. Ideally this API
would be able to support dynamic page creation instead of the current
status quo of pre-allocating and initializing pages.

On a prompt from Jason, introduce pgmap_request_folio() that operates on
an offset into a pgmap. It replaces the shortlived
pgmap_request_folios() that was continuing the layering violation of
assuming pages are available to be consulted before asking the pgmap to
make them available.

For now this only converts the callers to lookup the pgmap and generate
the pgmap offset, but it does not do the deeper cleanup of teaching
those call sites to generate those arguments without walking the page
metadata. For next steps it appears the DEVICE_PRIVATE implementations
could plumb the pgmap into the necessary callsites and switch to using
gen_pool_alloc() to track which offsets of a pgmap are allocated. For
DAX, dax_direct_access() could switch from returning pfns to returning
the associated @pgmap and @pgmap_offset. Those changes are saved for
follow-on work.

Link: https://lkml.kernel.org/r/166630293549.1017198.3833687373550679565.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c       |   11 +-
 drivers/dax/mapping.c                    |   10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |   14 ++-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |   13 ++
 include/linux/memremap.h                 |   35 +++++--
 lib/test_hmm.c                           |    9 +-
 mm/memremap.c                            |   94 ++++++++-------------
 7 files changed, 107 insertions(+), 79 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -689,12 +689,14 @@ unsigned long kvmppc_h_svm_init_abort(st
  */
 static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
 {
-	struct page *dpage = NULL;
+	struct dev_pagemap *pgmap = &kvmppc_uvmem_pgmap;
 	unsigned long bit, uvmem_pfn;
 	struct kvmppc_uvmem_page_pvt *pvt;
 	unsigned long pfn_last, pfn_first;
+	struct folio *folio;
+	struct page *dpage;
 
-	pfn_first = kvmppc_uvmem_pgmap.range.start >> PAGE_SHIFT;
+	pfn_first = pgmap->range.start >> PAGE_SHIFT;
 	pfn_last = pfn_first +
 		   (range_len(&kvmppc_uvmem_pgmap.range) >> PAGE_SHIFT);
 
@@ -716,9 +718,10 @@ static struct page *kvmppc_uvmem_get_pag
 	pvt->gpa = gpa;
 	pvt->kvm = kvm;
 
-	dpage = pfn_to_page(uvmem_pfn);
+	folio = pgmap_request_folio(pgmap,
+				    pfn_to_pgmap_offset(pgmap, uvmem_pfn), 0);
+	dpage = &folio->page;
 	dpage->zone_device_data = pvt;
-	pgmap_request_folios(dpage->pgmap, page_folio(dpage), 1);
 	lock_page(dpage);
 	return dpage;
 out_clear:
--- a/drivers/dax/mapping.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets
+++ a/drivers/dax/mapping.c
@@ -376,8 +376,14 @@ static vm_fault_t dax_associate_entry(vo
 		if (flags & DAX_COW) {
 			dax_mapping_set_cow(folio);
 		} else {
+			struct dev_pagemap *pgmap = folio_pgmap(folio);
+			unsigned long pfn = page_to_pfn(&folio->page);
+
 			WARN_ON_ONCE(folio->mapping);
-			if (!pgmap_request_folios(folio_pgmap(folio), folio, 1))
+			if (folio !=
+			    pgmap_request_folio(pgmap,
+						pfn_to_pgmap_offset(pgmap, pfn),
+						folio_order(folio)))
 				return VM_FAULT_SIGBUS;
 			folio->mapping = mapping;
 			folio->index = index + i;
@@ -691,7 +697,7 @@ static struct page *dax_zap_pages(struct
 
 	dax_for_each_folio(entry, folio, i) {
 		if (zap)
-			pgmap_release_folios(folio, 1);
+			folio_put(folio);
 		if (!ret && !dax_folio_idle(folio))
 			ret = folio_page(folio, 0);
 	}
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -215,15 +215,17 @@ svm_migrate_addr_to_pfn(struct amdgpu_de
 	return (addr + adev->kfd.dev->pgmap.range.start) >> PAGE_SHIFT;
 }
 
-static void
-svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
+static void svm_migrate_get_vram_page(struct dev_pagemap *pgmap,
+				      struct svm_range *prange,
+				      unsigned long pfn)
 {
+	struct folio *folio;
 	struct page *page;
 
-	page = pfn_to_page(pfn);
+	folio = pgmap_request_folio(pgmap, pfn_to_pgmap_offset(pgmap, pfn), 0);
+	page = &folio->page;
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
-	pgmap_request_folios(page->pgmap, page_folio(page), 1);
 	lock_page(page);
 }
 
@@ -298,6 +300,7 @@ svm_migrate_copy_to_vram(struct amdgpu_d
 			 struct migrate_vma *migrate, struct dma_fence **mfence,
 			 dma_addr_t *scratch)
 {
+	struct kfd_dev *kfddev = adev->kfd.dev;
 	uint64_t npages = migrate->npages;
 	struct device *dev = adev->dev;
 	struct amdgpu_res_cursor cursor;
@@ -325,7 +328,8 @@ svm_migrate_copy_to_vram(struct amdgpu_d
 
 		dst[i] = cursor.start + (j << PAGE_SHIFT);
 		migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
-		svm_migrate_get_vram_page(prange, migrate->dst[i]);
+			svm_migrate_get_vram_page(&kfddev->pgmap, prange,
+						  migrate->dst[i]);
 		migrate->dst[i] = migrate_pfn(migrate->dst[i]);
 
 		spage = migrate_pfn_to_page(migrate->src[i]);
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -308,6 +308,9 @@ static struct page *
 nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm)
 {
 	struct nouveau_dmem_chunk *chunk;
+	struct dev_pagemap *pgmap;
+	struct folio *folio;
+	unsigned long pfn;
 	struct page *page = NULL;
 	int ret;
 
@@ -317,17 +320,21 @@ nouveau_dmem_page_alloc_locked(struct no
 		drm->dmem->free_pages = page->zone_device_data;
 		chunk = nouveau_page_to_chunk(page);
 		chunk->callocated++;
+		pfn = page_to_pfn(page);
 		spin_unlock(&drm->dmem->lock);
 	} else {
 		spin_unlock(&drm->dmem->lock);
 		ret = nouveau_dmem_chunk_alloc(drm, &page);
 		if (ret)
 			return NULL;
+		chunk = nouveau_page_to_chunk(page);
+		pfn = page_to_pfn(page);
 	}
 
-	pgmap_request_folios(page->pgmap, page_folio(page), 1);
-	lock_page(page);
-	return page;
+	pgmap = &chunk->pagemap;
+	folio = pgmap_request_folio(pgmap, pfn_to_pgmap_offset(pgmap, pfn), 0);
+	lock_page(&folio->page);
+	return &folio->page;
 }
 
 static void
--- a/include/linux/memremap.h~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets
+++ a/include/linux/memremap.h
@@ -139,6 +139,28 @@ struct dev_pagemap {
 	};
 };
 
+/*
+ * Do not use this in new code, this is a transitional helper on the
+ * path to convert all ZONE_DEVICE users to operate in terms of pgmap
+ * offsets rather than pfn and pfn_to_page() to put ZONE_DEVICE pages
+ * into use.
+ */
+static inline pgoff_t pfn_to_pgmap_offset(struct dev_pagemap *pgmap, unsigned long pfn)
+{
+	u64 phys = PFN_PHYS(pfn), sum = 0;
+	int i;
+
+	for (i = 0; i < pgmap->nr_range; i++) {
+		struct range *range = &pgmap->ranges[i];
+
+		if (phys >= range->start && phys <= range->end)
+			return PHYS_PFN(phys - range->start + sum);
+		sum += range_len(range);
+	}
+
+	return -1;
+}
+
 static inline bool pgmap_has_memory_failure(struct dev_pagemap *pgmap)
 {
 	return pgmap->ops && pgmap->ops->memory_failure;
@@ -193,9 +215,8 @@ void *devm_memremap_pages(struct device
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 				    struct dev_pagemap *pgmap);
-bool pgmap_request_folios(struct dev_pagemap *pgmap, struct folio *folio,
-			  int nr_folios);
-void pgmap_release_folios(struct folio *folio, int nr_folios);
+struct folio *pgmap_request_folio(struct dev_pagemap *pgmap,
+				  pgoff_t pgmap_offset, int order);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
@@ -231,16 +252,12 @@ static inline struct dev_pagemap *get_de
 	return NULL;
 }
 
-static inline bool pgmap_request_folios(struct dev_pagemap *pgmap,
-					struct folio *folio, int nr_folios)
+static inline struct folio *pgmap_request_folio(struct dev_pagemap *pgmap,
+						pgoff_t pgmap_offset, int order)
 {
 	return false;
 }
 
-static inline void pgmap_release_folios(struct folio *folio, int nr_folios)
-{
-}
-
 static inline bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
 {
 	return false;
--- a/lib/test_hmm.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets
+++ a/lib/test_hmm.c
@@ -605,8 +605,11 @@ err_devmem:
 
 static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
 {
+	struct dev_pagemap *pgmap;
 	struct page *dpage = NULL;
 	struct page *rpage = NULL;
+	struct folio *folio;
+	unsigned long pfn;
 
 	/*
 	 * For ZONE_DEVICE private type, this is a fake device so we allocate
@@ -632,7 +635,11 @@ static struct page *dmirror_devmem_alloc
 			goto error;
 	}
 
-	pgmap_request_folios(dpage->pgmap, page_folio(dpage), 1);
+	/* FIXME: Rework allocator to be pgmap offset based */
+	pgmap = dpage->pgmap;
+	pfn = page_to_pfn(dpage);
+	folio = pgmap_request_folio(pgmap, pfn_to_pgmap_offset(pgmap, pfn), 0);
+	WARN_ON_ONCE(dpage != &folio->page);
 	lock_page(dpage);
 	dpage->zone_device_data = rpage;
 	return dpage;
--- a/mm/memremap.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets
+++ a/mm/memremap.c
@@ -492,76 +492,60 @@ void free_zone_device_page(struct page *
 	put_dev_pagemap(page->pgmap);
 }
 
-static __maybe_unused bool folio_span_valid(struct dev_pagemap *pgmap,
-					    struct folio *folio,
-					    int nr_folios)
+static unsigned long pgmap_offset_to_pfn(struct dev_pagemap *pgmap,
+					 pgoff_t pgmap_offset)
 {
-	unsigned long pfn_start, pfn_end;
-
-	pfn_start = page_to_pfn(folio_page(folio, 0));
-	pfn_end = pfn_start + (1 << folio_order(folio)) * nr_folios - 1;
+	u64 sum = 0, offset = PFN_PHYS(pgmap_offset);
+	int i;
 
-	if (pgmap != xa_load(&pgmap_array, pfn_start))
-		return false;
+	for (i = 0; i < pgmap->nr_range; i++) {
+		struct range *range = &pgmap->ranges[i];
 
-	if (pfn_end > pfn_start && pgmap != xa_load(&pgmap_array, pfn_end))
-		return false;
+		if (offset >= sum && offset < (sum + range_len(range)))
+			return PHYS_PFN(range->start + offset - sum);
+		sum += range_len(range);
+	}
 
-	return true;
+	return -1;
 }
 
 /**
- * pgmap_request_folios - activate an contiguous span of folios in @pgmap
- * @pgmap: host page map for the folio array
- * @folio: start of the folio list, all subsequent folios have same folio_size()
+ * pgmap_request_folio - activate a folio of a given order in @pgmap
+ * @pgmap: host page map of the folio to activate
+ * @pgmap_offset: page-offset into the pgmap to request
+ * @order: expected folio_order() of the folio
  *
  * Caller is responsible for @pgmap remaining live for the duration of
- * this call. Caller is also responsible for not racing requests for the
- * same folios.
+ * this call. The order (size) of the folios in the pgmap are assumed
+ * stable before this call.
  */
-bool pgmap_request_folios(struct dev_pagemap *pgmap, struct folio *folio,
-			  int nr_folios)
+struct folio *pgmap_request_folio(struct dev_pagemap *pgmap,
+				  pgoff_t pgmap_offset, int order)
 {
-	struct folio *iter;
-	int i;
+	unsigned long pfn = pgmap_offset_to_pfn(pgmap, pgmap_offset);
+	struct page *page = pfn_to_page(pfn);
+	struct folio *folio;
+	int v;
 
-	/*
-	 * All of the WARNs below are for catching bugs in future
-	 * development that changes the assumptions of:
-	 * 1/ uniform folios in @pgmap
-	 * 2/ @pgmap death does not race this routine.
-	 */
-	VM_WARN_ON_ONCE(!folio_span_valid(pgmap, folio, nr_folios));
+	if (WARN_ON_ONCE(page->pgmap != pgmap))
+		return NULL;
 
 	if (WARN_ON_ONCE(percpu_ref_is_dying(&pgmap->ref)))
-		return false;
+		return NULL;
 
-	for (iter = folio_next(folio), i = 1; i < nr_folios;
-	     iter = folio_next(folio), i++)
-		if (WARN_ON_ONCE(folio_order(iter) != folio_order(folio)))
-			return false;
-
-	for (iter = folio, i = 0; i < nr_folios; iter = folio_next(iter), i++) {
-		folio_ref_inc(iter);
-		if (folio_ref_count(iter) == 1)
-			percpu_ref_tryget(&pgmap->ref);
+	folio = page_folio(page);
+	if (WARN_ON_ONCE(folio_order(folio) != order))
+		return NULL;
+
+	v = folio_ref_inc_return(folio);
+	if (v > 1)
+		return folio;
+
+	if (WARN_ON_ONCE(!percpu_ref_tryget(&pgmap->ref))) {
+		folio_put(folio);
+		return NULL;
 	}
 
-	return true;
-}
-EXPORT_SYMBOL_GPL(pgmap_request_folios);
-
-/*
- * A symmetric helper to undo the page references acquired by
- * pgmap_request_folios(), but the caller can also just arrange
- * folio_put() on all the folios it acquired previously for the same
- * effect.
- */
-void pgmap_release_folios(struct folio *folio, int nr_folios)
-{
-	struct folio *iter;
-	int i;
-
-	for (iter = folio, i = 0; i < nr_folios; iter = folio_next(folio), i++)
-		folio_put(iter);
+	return folio;
 }
+EXPORT_SYMBOL_GPL(pgmap_request_folio);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

fsdax-wait-on-page-not-page-_refcount.patch
fsdax-use-dax_page_idle-to-document-dax-busy-page-checking.patch
fsdax-include-unmapped-inodes-for-page-idle-detection.patch
fsdax-introduce-dax_zap_mappings.patch
fsdax-wait-for-pinned-pages-during-truncate_inode_pages_final.patch
fsdax-validate-dax-layouts-broken-before-truncate.patch
fsdax-hold-dax-lock-over-mapping-insertion.patch
fsdax-update-dax_insert_entry-calling-convention-to-return-an-error.patch
fsdax-rework-for_each_mapped_pfn-to-dax_for_each_folio.patch
fsdax-introduce-pgmap_request_folios.patch
fsdax-rework-dax_insert_entry-calling-convention.patch
fsdax-cleanup-dax_associate_entry.patch
devdax-minor-warning-fixups.patch
devdax-fix-sparse-lock-imbalance-warning.patch
libnvdimm-pmem-support-pmem-block-devices-without-dax.patch
devdax-move-address_space-helpers-to-the-dax-core.patch
devdax-sparse-fixes-for-xarray-locking.patch
devdax-sparse-fixes-for-vmfault_t-dax-entry-conversions.patch
devdax-sparse-fixes-for-vm_fault_t-in-tracepoints.patch
devdax-add-pud-support-to-the-dax-mapping-infrastructure.patch
devdax-use-dax_insert_entry-dax_delete_mapping_entry.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios.patch
mm-memremap_pages-initialize-all-zone_device-pages-to-start-at-refcount-0.patch
mm-meremap_pages-delete-put_devmap_managed_page_refs.patch
mm-gup-drop-dax-pgmap-accounting.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch

