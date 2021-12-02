Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C3FC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 21:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354021AbhLBVgF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Dec 2021 16:36:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38248 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243217AbhLBVgE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2021 16:36:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E07562856
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 21:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E91DC00446;
        Thu,  2 Dec 2021 21:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638480760;
        bh=VJ6HABtobnsACzJ+LoikKqNTsKWPatEy39pFb4cUNgU=;
        h=Date:From:To:Subject:From;
        b=XFBvfrYANugtx+rBlBTWHyR/Q/ZM7uN1kkzqMoBfJjXxEY+a7EnmZ0GuYCuMZprju
         gMtIA/4KNLq3+5vIjDcPA8PsGOqxPh05G6BV9pFIdNgCdSR1qPm7TdwEpUIH1ctSvX
         jRHlVCwTMU18LwpizoEKJImMUToq7GovCiVy/c3o=
Date:   Thu, 02 Dec 2021 13:32:39 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  +
 mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch added to -mm
 tree
Message-ID: <20211202213239.U0Ryj6G8s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: refactor memmap_init_zone_device() page init
has been added to the -mm tree.  Its filename is
     mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/page_alloc: refactor memmap_init_zone_device() page init

Move struct page init to an helper function __init_zone_device_page().

This is in preparation for sharing the storage for compound page metadata.

Link: https://lkml.kernel.org/r/20211202204422.26777-4-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   74 +++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 33 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-refactor-memmap_init_zone_device-page-init
+++ a/mm/page_alloc.c
@@ -6572,6 +6572,46 @@ void __meminit memmap_init_range(unsigne
 }
 
 #ifdef CONFIG_ZONE_DEVICE
+static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
+					  unsigned long zone_idx, int nid,
+					  struct dev_pagemap *pgmap)
+{
+
+	__init_single_page(page, pfn, zone_idx, nid);
+
+	/*
+	 * Mark page reserved as it will need to wait for onlining
+	 * phase for it to be fully associated with a zone.
+	 *
+	 * We can use the non-atomic __set_bit operation for setting
+	 * the flag as we are still initializing the pages.
+	 */
+	__SetPageReserved(page);
+
+	/*
+	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
+	 * and zone_device_data.  It is a bug if a ZONE_DEVICE page is
+	 * ever freed or placed on a driver-private list.
+	 */
+	page->pgmap = pgmap;
+	page->zone_device_data = NULL;
+
+	/*
+	 * Mark the block movable so that blocks are reserved for
+	 * movable at startup. This will force kernel allocations
+	 * to reserve their blocks rather than leaking throughout
+	 * the address space during boot when many long-lived
+	 * kernel allocations are made.
+	 *
+	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
+	 * because this is done early in section_activate()
+	 */
+	if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
+		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+		cond_resched();
+	}
+}
+
 void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long start_pfn,
 				   unsigned long nr_pages,
@@ -6600,39 +6640,7 @@ void __ref memmap_init_zone_device(struc
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_single_page(page, pfn, zone_idx, nid);
-
-		/*
-		 * Mark page reserved as it will need to wait for onlining
-		 * phase for it to be fully associated with a zone.
-		 *
-		 * We can use the non-atomic __set_bit operation for setting
-		 * the flag as we are still initializing the pages.
-		 */
-		__SetPageReserved(page);
-
-		/*
-		 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
-		 * and zone_device_data.  It is a bug if a ZONE_DEVICE page is
-		 * ever freed or placed on a driver-private list.
-		 */
-		page->pgmap = pgmap;
-		page->zone_device_data = NULL;
-
-		/*
-		 * Mark the block movable so that blocks are reserved for
-		 * movable at startup. This will force kernel allocations
-		 * to reserve their blocks rather than leaking throughout
-		 * the address space during boot when many long-lived
-		 * kernel allocations are made.
-		 *
-		 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
-		 * because this is done early in section_activate()
-		 */
-		if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
-			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-			cond_resched();
-		}
+		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch
mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch
mm-memremap-add-zone_device-support-for-compound-pages.patch
device-dax-use-align-for-determining-pgoff.patch
device-dax-use-struct_size.patch
device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch
device-dax-factor-out-page-mapping-initialization.patch
device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault.patch
device-dax-compound-devmap-support.patch

