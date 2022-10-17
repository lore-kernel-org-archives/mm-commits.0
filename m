Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C45FC43219
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJQATy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiJQATR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:19:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170CD31DD9
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A1AEB80E28
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC20C433C1;
        Mon, 17 Oct 2022 00:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665965953;
        bh=zfU0E0f3HGYBP3+MeTaRdXcHo0PjZ6GXoXS/C+vyCl8=;
        h=Date:To:From:Subject:From;
        b=y1gbXhxSjA/xL+aVFVoEWtqCBIvysYXU57hBDgG7jQ6MMk1Lb9y9aEIjsxlHlTptM
         8UEc0vIVRfrtzPiAJQP3pMyqGTZ0B5UBEukcDyvny18e94ufYgCeH1ivu1suS9vB+S
         Sw4ScR2aVyLPx73WH3lGcTN2t2Ai4nryDhnCmbUQ=
Date:   Sun, 16 Oct 2022 17:19:12 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        willy@infradead.org, lyude@redhat.com, lkp@intel.com,
        kherbst@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, jack@suse.cz, hch@lst.de, Felix.Kuehling@amd.com,
        djwong@kernel.org, david@fromorbit.com, daniel@ffwll.ch,
        christian.koenig@amd.com, bskeggs@redhat.com, apopple@nvidia.com,
        alexander.deucher@amd.com, airlied@linux.ie,
        dan.j.williams@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios.patch added to mm-unstable branch
Message-Id: <20221017001913.1AC20C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap_pages: replace zone_device_page_init() with pgmap_request_folios()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios.patch

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
Subject: mm/memremap_pages: replace zone_device_page_init() with pgmap_request_folios()
Date: Fri, 14 Oct 2022 16:59:06 -0700

Switch to the common method, shared across all MEMORY_DEVICE_* types, for
requesting access to a ZONE_DEVICE page.  The
MEMORY_DEVICE_{PRIVATE,COHERENT} specific expectation that newly requested
pages are locked is moved to the callers.

Link: https://lkml.kernel.org/r/166579194621.2236710.8168919102434295671.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c       |    3 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    3 ++-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |    3 ++-
 include/linux/memremap.h                 |    1 -
 lib/test_hmm.c                           |    3 ++-
 mm/memremap.c                            |   13 +------------
 6 files changed, 9 insertions(+), 17 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -718,7 +718,8 @@ static struct page *kvmppc_uvmem_get_pag
 
 	dpage = pfn_to_page(uvmem_pfn);
 	dpage->zone_device_data = pvt;
-	zone_device_page_init(dpage);
+	pgmap_request_folios(dpage->pgmap, page_folio(dpage), 1);
+	lock_page(dpage);
 	return dpage;
 out_clear:
 	spin_lock(&kvmppc_uvmem_bitmap_lock);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -223,7 +223,8 @@ svm_migrate_get_vram_page(struct svm_ran
 	page = pfn_to_page(pfn);
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
-	zone_device_page_init(page);
+	pgmap_request_folios(page->pgmap, page_folio(page), 1);
+	lock_page(page);
 }
 
 static void
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -324,7 +324,8 @@ nouveau_dmem_page_alloc_locked(struct no
 			return NULL;
 	}
 
-	zone_device_page_init(page);
+	pgmap_request_folios(page->pgmap, page_folio(page), 1);
+	lock_page(page);
 	return page;
 }
 
--- a/include/linux/memremap.h~mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios
+++ a/include/linux/memremap.h
@@ -187,7 +187,6 @@ static inline bool folio_is_device_coher
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-void zone_device_page_init(struct page *page);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
--- a/lib/test_hmm.c~mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios
+++ a/lib/test_hmm.c
@@ -632,7 +632,8 @@ static struct page *dmirror_devmem_alloc
 			goto error;
 	}
 
-	zone_device_page_init(dpage);
+	pgmap_request_folios(dpage->pgmap, page_folio(dpage), 1);
+	lock_page(dpage);
 	dpage->zone_device_data = rpage;
 	return dpage;
 
--- a/mm/memremap.c~mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios
+++ a/mm/memremap.c
@@ -518,18 +518,6 @@ void free_zone_device_page(struct page *
 		put_dev_pagemap(page->pgmap);
 }
 
-void zone_device_page_init(struct page *page)
-{
-	/*
-	 * Drivers shouldn't be allocating pages after calling
-	 * memunmap_pages().
-	 */
-	WARN_ON_ONCE(!percpu_ref_tryget_live(&page->pgmap->ref));
-	set_page_count(page, 1);
-	lock_page(page);
-}
-EXPORT_SYMBOL_GPL(zone_device_page_init);
-
 static bool folio_span_valid(struct dev_pagemap *pgmap, struct folio *folio,
 			     int nr_folios)
 {
@@ -586,6 +574,7 @@ bool pgmap_request_folios(struct dev_pag
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(pgmap_request_folios);
 
 void pgmap_release_folios(struct dev_pagemap *pgmap, struct folio *folio, int nr_folios)
 {
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

