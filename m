Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF01C32771
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 15:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiI1PNW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiI1PNV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 11:13:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CBBB02B0
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 08:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF9F8B820E8
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 15:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63038C433D6;
        Wed, 28 Sep 2022 15:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664377996;
        bh=6SpRuzgeVhwlmQJk0tYRP+sV93bgOfzCrQQUhGN5TcE=;
        h=Date:To:From:Subject:From;
        b=B3pu/MQOzVGIhHYf1fRCDJoRzGOzyF49BKweWtnSBsWDFnmlJSV/koFG0DYQt8j9N
         zSxRFpi3ptv6C/D8PkwJW2WOhGYALkNNNMqDjxhTli0/o5PwH+27y/cbW2/j71Has5
         VVUpsYvTLAStBqvBO6YlmD/du+FvM3TsGHj47Eiw=
Date:   Wed, 28 Sep 2022 08:13:10 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, shy828301@gmail.com, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, david@redhat.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, alex.sierra@amd.com, alexander.deucher@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-free-device-private-pages-have-zero-refcount.patch added to mm-unstable branch
Message-Id: <20220928151316.63038C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: free device private pages have zero refcount
has been added to the -mm mm-unstable branch.  Its filename is
     mm-free-device-private-pages-have-zero-refcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-free-device-private-pages-have-zero-refcount.patch

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
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
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
@@ -6811,6 +6811,14 @@ static void __ref __init_zone_device_pag
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

mm-memoryc-fix-race-when-faulting-a-device-private-page.patch
mm-free-device-private-pages-have-zero-refcount.patch
mm-memremapc-take-a-pgmap-reference-on-page-allocation.patch
mm-migrate_devicec-refactor-migrate_vma-and-migrate_deivce_coherent_page.patch
mm-migrate_devicec-add-migrate_device_range.patch
nouveau-dmem-refactor-nouveau_dmem_fault_copy_one.patch
nouveau-dmem-evict-device-private-memory-during-release.patch
hmm-tests-add-test-for-migrate_device_range.patch

