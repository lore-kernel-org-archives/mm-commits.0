Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E39C04A95
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 15:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiI1PNj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbiI1PNZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 11:13:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C368CAC252
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 08:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE9E61EC5
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 15:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499B5C433C1;
        Wed, 28 Sep 2022 15:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664378002;
        bh=HO/Ril1KzhD3UYUrp4UmxX6U5TWlwNMBfVTAIh4eJ14=;
        h=Date:To:From:Subject:From;
        b=c0KWcqRSGWPP3RchZlqb8Fveyya+aDhOn4SM+h/+Dt0kRH0BlByTDPUGqSHeHwDJV
         uqsmmQMWoIrGSof+jsMNB+wb5MmqTrzOgfTqEwOUC0MJRiLrkBUbI0y91z010JzfYe
         8mxe3fJgFZPfyfMS7WoVtgn4KpboUPNrm6rrWCnI=
Date:   Wed, 28 Sep 2022 08:13:18 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, shy828301@gmail.com, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, david@redhat.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, alex.sierra@amd.com, alexander.deucher@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremapc-take-a-pgmap-reference-on-page-allocation.patch added to mm-unstable branch
Message-Id: <20220928151322.499B5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap.c: take a pgmap reference on page allocation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memremapc-take-a-pgmap-reference-on-page-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremapc-take-a-pgmap-reference-on-page-allocation.patch

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
Subject: mm/memremap.c: take a pgmap reference on page allocation
Date: Wed, 28 Sep 2022 22:01:17 +1000

ZONE_DEVICE pages have a struct dev_pagemap which is allocated by a
driver.  When the struct page is first allocated by the kernel in
memremap_pages() a reference is taken on the associated pagemap to ensure
it is not freed prior to the pages being freed.

Prior to 27674ef6c73f ("mm: remove the extra ZONE_DEVICE struct page
refcount") pages were considered free and returned to the driver when the
reference count dropped to one.  However the pagemap reference was not
dropped until the page reference count hit zero.  This would occur as part
of the final put_page() in memunmap_pages() which would wait for all pages
to be freed prior to returning.

When the extra refcount was removed the pagemap reference was no longer
being dropped in put_page().  Instead memunmap_pages() was changed to
explicitly drop the pagemap references.  This means that memunmap_pages()
can complete even though pages are still mapped by the kernel which can
lead to kernel crashes, particularly if a driver frees the pagemap.

To fix this drivers should take a pagemap reference when allocating the
page.  This reference can then be returned when the page is freed.

Link: https://lkml.kernel.org/r/12d155ec727935ebfbb4d639a03ab374917ea51b.1664366292.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Fixes: 27674ef6c73f ("mm: remove the extra ZONE_DEVICE struct page refcount")
Cc: Jason Gunthorpe <jgg@nvidia.com>
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
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memremap.c~mm-memremapc-take-a-pgmap-reference-on-page-allocation
+++ a/mm/memremap.c
@@ -138,8 +138,11 @@ void memunmap_pages(struct dev_pagemap *
 	int i;
 
 	percpu_ref_kill(&pgmap->ref);
-	for (i = 0; i < pgmap->nr_range; i++)
-		percpu_ref_put_many(&pgmap->ref, pfn_len(pgmap, i));
+	if (pgmap->type != MEMORY_DEVICE_PRIVATE &&
+	    pgmap->type != MEMORY_DEVICE_COHERENT)
+		for (i = 0; i < pgmap->nr_range; i++)
+			percpu_ref_put_many(&pgmap->ref, pfn_len(pgmap, i));
+
 	wait_for_completion(&pgmap->done);
 
 	for (i = 0; i < pgmap->nr_range; i++)
@@ -264,7 +267,9 @@ static int pagemap_range(struct dev_page
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), pgmap);
-	percpu_ref_get_many(&pgmap->ref, pfn_len(pgmap, range_id));
+	if (pgmap->type != MEMORY_DEVICE_PRIVATE &&
+	    pgmap->type != MEMORY_DEVICE_COHERENT)
+		percpu_ref_get_many(&pgmap->ref, pfn_len(pgmap, range_id));
 	return 0;
 
 err_add_memory:
@@ -502,16 +507,24 @@ void free_zone_device_page(struct page *
 	page->mapping = NULL;
 	page->pgmap->ops->page_free(page);
 
-	/*
-	 * Reset the page count to 1 to prepare for handing out the page again.
-	 */
 	if (page->pgmap->type != MEMORY_DEVICE_PRIVATE &&
 	    page->pgmap->type != MEMORY_DEVICE_COHERENT)
+		/*
+		 * Reset the page count to 1 to prepare for handing out the page
+		 * again.
+		 */
 		set_page_count(page, 1);
+	else
+		put_dev_pagemap(page->pgmap);
 }
 
 void zone_device_page_init(struct page *page)
 {
+	/*
+	 * Drivers shouldn't be allocating pages after calling
+	 * memunmap_pages().
+	 */
+	WARN_ON_ONCE(!percpu_ref_tryget_live(&page->pgmap->ref));
 	set_page_count(page, 1);
 	lock_page(page);
 }
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

