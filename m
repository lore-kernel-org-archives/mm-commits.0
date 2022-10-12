Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D08C43219
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiJLW54 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJLW5f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:57:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1D6120BD7
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE3BE61671
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2754EC433D6;
        Wed, 12 Oct 2022 22:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615450;
        bh=SCx8lcpcp9bPpASUMJQBaSf/eHH1DAaYpfWZdYcPf8I=;
        h=Date:To:From:Subject:From;
        b=jYBLH8hpsV/ZDmcxtMilyJNVXXRrGBOZ0xpc/eyyRelNN94SSRRLcYSXyJOoW0Pro
         MFLWuIQs6BBInQpLJE/BajxmwysvOBWSjVzeG0ftAFMzKVYJvTjRMkIMK6nNC3BtCd
         HPIvI4ye6Yqum5o1K1R67NmyfbZnVF+9IQ/g3Peg=
Date:   Wed, 12 Oct 2022 15:57:29 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, shy828301@gmail.com, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, david@redhat.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, alex.sierra@amd.com, alexander.deucher@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-free-device-private-pages-have-zero-refcount.patch removed from -mm tree
Message-Id: <20221012225730.2754EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: free device private pages have zero refcount
has been removed from the -mm tree.  Its filename was
     mm-free-device-private-pages-have-zero-refcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm: free device private pages have zero refcount
Date: Wed, 28 Sep 2022 22:01:16 +1000

Since 27674ef6c73f ("mm: remove the extra ZONE_DEVICE struct page
refcount") device private pages have no longer had an extra reference
count when the page is in use.  However before handing them back to the
owning device driver we add an extra reference count such that free pages
have a reference count of one.

This makes it difficult to tell if a page is free or not because both free
and in use pages will have a non-zero refcount.  Instead we should return
pages to the drivers page allocator with a zero reference count.  Kernel
code can then safely use kernel functions such as get_page_unless_zero().

Link: https://lkml.kernel.org/r/cf70cf6f8c0bdb8aaebdbfb0d790aea4c683c3c6.1664366292.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c       |    2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |    2 +-
 include/linux/memremap.h                 |    1 +
 lib/test_hmm.c                           |    2 +-
 mm/memremap.c                            |    9 +++++++++
 mm/page_alloc.c                          |    8 ++++++++
 7 files changed, 22 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-free-device-private-pages-have-zero-refcount
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -718,7 +718,7 @@ static struct page *kvmppc_uvmem_get_pag
 
 	dpage = pfn_to_page(uvmem_pfn);
 	dpage->zone_device_data = pvt;
-	lock_page(dpage);
+	zone_device_page_init(dpage);
 	return dpage;
 out_clear:
 	spin_lock(&kvmppc_uvmem_bitmap_lock);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-free-device-private-pages-have-zero-refcount
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -223,7 +223,7 @@ svm_migrate_get_vram_page(struct svm_ran
 	page = pfn_to_page(pfn);
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
-	lock_page(page);
+	zone_device_page_init(page);
 }
 
 static void
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-free-device-private-pages-have-zero-refcount
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -326,7 +326,7 @@ nouveau_dmem_page_alloc_locked(struct no
 			return NULL;
 	}
 
-	lock_page(page);
+	zone_device_page_init(page);
 	return page;
 }
 
--- a/include/linux/memremap.h~mm-free-device-private-pages-have-zero-refcount
+++ a/include/linux/memremap.h
@@ -187,6 +187,7 @@ static inline bool folio_is_device_coher
 }
 
 #ifdef CONFIG_ZONE_DEVICE
+void zone_device_page_init(struct page *page);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
--- a/lib/test_hmm.c~mm-free-device-private-pages-have-zero-refcount
+++ a/lib/test_hmm.c
@@ -627,8 +627,8 @@ static struct page *dmirror_devmem_alloc
 			goto error;
 	}
 
+	zone_device_page_init(dpage);
 	dpage->zone_device_data = rpage;
-	lock_page(dpage);
 	return dpage;
 
 error:
--- a/mm/memremap.c~mm-free-device-private-pages-have-zero-refcount
+++ a/mm/memremap.c
@@ -505,8 +505,17 @@ void free_zone_device_page(struct page *
 	/*
 	 * Reset the page count to 1 to prepare for handing out the page again.
 	 */
+	if (page->pgmap->type != MEMORY_DEVICE_PRIVATE &&
+	    page->pgmap->type != MEMORY_DEVICE_COHERENT)
+		set_page_count(page, 1);
+}
+
+void zone_device_page_init(struct page *page)
+{
 	set_page_count(page, 1);
+	lock_page(page);
 }
+EXPORT_SYMBOL_GPL(zone_device_page_init);
 
 #ifdef CONFIG_FS_DAX
 bool __put_devmap_managed_page_refs(struct page *page, int refs)
--- a/mm/page_alloc.c~mm-free-device-private-pages-have-zero-refcount
+++ a/mm/page_alloc.c
@@ -6819,6 +6819,14 @@ static void __ref __init_zone_device_pag
 		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 		cond_resched();
 	}
+
+	/*
+	 * ZONE_DEVICE pages are released directly to the driver page allocator
+	 * which will set the page count to 1 when allocating the page.
+	 */
+	if (pgmap->type == MEMORY_DEVICE_PRIVATE ||
+	    pgmap->type == MEMORY_DEVICE_COHERENT)
+		set_page_count(page, 0);
 }
 
 /*
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-memremapc-take-a-pgmap-reference-on-page-allocation.patch
mm-migrate_devicec-refactor-migrate_vma-and-migrate_deivce_coherent_page.patch
mm-migrate_devicec-add-migrate_device_range.patch
nouveau-dmem-refactor-nouveau_dmem_fault_copy_one.patch
nouveau-dmem-evict-device-private-memory-during-release.patch
hmm-tests-add-test-for-migrate_device_range.patch

