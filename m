Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE26C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJLW61 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiJLW5z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:57:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394CE125038
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F96BB81CAC
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64B7C433D7;
        Wed, 12 Oct 2022 22:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615453;
        bh=vGt+cOiJPqJWVLm89tmLtscwpvEoxFpCurrDiNVYytk=;
        h=Date:To:From:Subject:From;
        b=iqhS30S2aleD2ylp9ZctAG3b9i5ylOSAHIX7GM7kwn0qfoB4exU++YxxkZl6OOQUl
         BKBc2atCjuinclWqk7GrpqOlLqK1Peteq2qRKk79xx+/Dd334MZ2lvkcsjojEDGT9d
         3Uf8ghNGqMgxuudwi7s4nwUbwI6AURmSva5olWV0=
Date:   Wed, 12 Oct 2022 15:57:32 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, shy828301@gmail.com, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, david@redhat.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, alex.sierra@amd.com, alexander.deucher@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_devicec-refactor-migrate_vma-and-migrate_deivce_coherent_page.patch removed from -mm tree
Message-Id: <20221012225732.E64B7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate_device.c: refactor migrate_vma and migrate_deivce_coherent_page()
has been removed from the -mm tree.  Its filename was
     mm-migrate_devicec-refactor-migrate_vma-and-migrate_deivce_coherent_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/migrate_device.c: refactor migrate_vma and migrate_deivce_coherent_page()
Date: Wed, 28 Sep 2022 22:01:18 +1000

migrate_device_coherent_page() reuses the existing migrate_vma family of
functions to migrate a specific page without providing a valid mapping or
vma.  This looks a bit odd because it means we are calling migrate_vma_*()
without setting a valid vma, however it was considered acceptable at the
time because the details were internal to migrate_device.c and there was
only a single user.

One of the reasons the details could be kept internal was that this was
strictly for migrating device coherent memory.  Such memory can be copied
directly by the CPU without intervention from a driver.  However this
isn't true for device private memory, and a future change requires similar
functionality for device private memory.  So refactor the code into
something more sensible for migrating device memory without a vma.

Link: https://lkml.kernel.org/r/c7b2ff84e9b33d022cf4a40f87d051f281a16d8f.1664366292.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |  150 +++++++++++++++++++++++-------------------
 1 file changed, 85 insertions(+), 65 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_devicec-refactor-migrate_vma-and-migrate_deivce_coherent_page
+++ a/mm/migrate_device.c
@@ -357,26 +357,20 @@ static bool migrate_vma_check_page(struc
 }
 
 /*
- * migrate_vma_unmap() - replace page mapping with special migration pte entry
- * @migrate: migrate struct containing all migration information
- *
- * Isolate pages from the LRU and replace mappings (CPU page table pte) with a
- * special migration pte entry and check if it has been pinned. Pinned pages are
- * restored because we cannot migrate them.
- *
- * This is the last step before we call the device driver callback to allocate
- * destination memory and copy contents of original page over to new page.
+ * Unmaps pages for migration. Returns number of unmapped pages.
  */
-static void migrate_vma_unmap(struct migrate_vma *migrate)
+static unsigned long migrate_device_unmap(unsigned long *src_pfns,
+					  unsigned long npages,
+					  struct page *fault_page)
 {
-	const unsigned long npages = migrate->npages;
 	unsigned long i, restore = 0;
 	bool allow_drain = true;
+	unsigned long unmapped = 0;
 
 	lru_add_drain();
 
 	for (i = 0; i < npages; i++) {
-		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct folio *folio;
 
 		if (!page)
@@ -391,8 +385,7 @@ static void migrate_vma_unmap(struct mig
 			}
 
 			if (isolate_lru_page(page)) {
-				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
-				migrate->cpages--;
+				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 				restore++;
 				continue;
 			}
@@ -406,34 +399,54 @@ static void migrate_vma_unmap(struct mig
 			try_to_migrate(folio, 0);
 
 		if (page_mapped(page) ||
-		    !migrate_vma_check_page(page, migrate->fault_page)) {
+		    !migrate_vma_check_page(page, fault_page)) {
 			if (!is_zone_device_page(page)) {
 				get_page(page);
 				putback_lru_page(page);
 			}
 
-			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
-			migrate->cpages--;
+			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 			restore++;
 			continue;
 		}
+
+		unmapped++;
 	}
 
 	for (i = 0; i < npages && restore; i++) {
-		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct folio *folio;
 
-		if (!page || (migrate->src[i] & MIGRATE_PFN_MIGRATE))
+		if (!page || (src_pfns[i] & MIGRATE_PFN_MIGRATE))
 			continue;
 
 		folio = page_folio(page);
 		remove_migration_ptes(folio, folio, false);
 
-		migrate->src[i] = 0;
+		src_pfns[i] = 0;
 		folio_unlock(folio);
 		folio_put(folio);
 		restore--;
 	}
+
+	return unmapped;
+}
+
+/*
+ * migrate_vma_unmap() - replace page mapping with special migration pte entry
+ * @migrate: migrate struct containing all migration information
+ *
+ * Isolate pages from the LRU and replace mappings (CPU page table pte) with a
+ * special migration pte entry and check if it has been pinned. Pinned pages are
+ * restored because we cannot migrate them.
+ *
+ * This is the last step before we call the device driver callback to allocate
+ * destination memory and copy contents of original page over to new page.
+ */
+static void migrate_vma_unmap(struct migrate_vma *migrate)
+{
+	migrate->cpages = migrate_device_unmap(migrate->src, migrate->npages,
+					migrate->fault_page);
 }
 
 /**
@@ -680,41 +693,36 @@ abort:
 	*src &= ~MIGRATE_PFN_MIGRATE;
 }
 
-/**
- * migrate_vma_pages() - migrate meta-data from src page to dst page
- * @migrate: migrate struct containing all migration information
- *
- * This migrates struct page meta-data from source struct page to destination
- * struct page. This effectively finishes the migration from source page to the
- * destination page.
- */
-void migrate_vma_pages(struct migrate_vma *migrate)
+static void migrate_device_pages(unsigned long *src_pfns,
+				unsigned long *dst_pfns, unsigned long npages,
+				struct migrate_vma *migrate)
 {
-	const unsigned long npages = migrate->npages;
-	const unsigned long start = migrate->start;
 	struct mmu_notifier_range range;
-	unsigned long addr, i;
+	unsigned long i;
 	bool notified = false;
 
-	for (i = 0, addr = start; i < npages; addr += PAGE_SIZE, i++) {
-		struct page *newpage = migrate_pfn_to_page(migrate->dst[i]);
-		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+	for (i = 0; i < npages; i++) {
+		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
+		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct address_space *mapping;
 		int r;
 
 		if (!newpage) {
-			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 			continue;
 		}
 
 		if (!page) {
+			unsigned long addr;
+
 			/*
 			 * The only time there is no vma is when called from
 			 * migrate_device_coherent_page(). However this isn't
 			 * called if the page could not be unmapped.
 			 */
-			VM_BUG_ON(!migrate->vma);
-			if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE))
+			VM_BUG_ON(!migrate);
+			addr = migrate->start + i*PAGE_SIZE;
+			if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE))
 				continue;
 			if (!notified) {
 				notified = true;
@@ -726,7 +734,7 @@ void migrate_vma_pages(struct migrate_vm
 				mmu_notifier_invalidate_range_start(&range);
 			}
 			migrate_vma_insert_page(migrate, addr, newpage,
-						&migrate->src[i]);
+						&src_pfns[i]);
 			continue;
 		}
 
@@ -739,18 +747,18 @@ void migrate_vma_pages(struct migrate_vm
 			 * device private or coherent memory.
 			 */
 			if (mapping) {
-				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 				continue;
 			}
 		} else if (is_zone_device_page(newpage)) {
 			/*
 			 * Other types of ZONE_DEVICE page are not supported.
 			 */
-			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 			continue;
 		}
 
-		if (migrate->fault_page == page)
+		if (migrate && migrate->fault_page == page)
 			r = migrate_folio_extra(mapping, page_folio(newpage),
 						page_folio(page),
 						MIGRATE_SYNC_NO_COPY, 1);
@@ -758,7 +766,7 @@ void migrate_vma_pages(struct migrate_vm
 			r = migrate_folio(mapping, page_folio(newpage),
 					page_folio(page), MIGRATE_SYNC_NO_COPY);
 		if (r != MIGRATEPAGE_SUCCESS)
-			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 	}
 
 	/*
@@ -769,28 +777,30 @@ void migrate_vma_pages(struct migrate_vm
 	if (notified)
 		mmu_notifier_invalidate_range_only_end(&range);
 }
-EXPORT_SYMBOL(migrate_vma_pages);
 
 /**
- * migrate_vma_finalize() - restore CPU page table entry
+ * migrate_vma_pages() - migrate meta-data from src page to dst page
  * @migrate: migrate struct containing all migration information
  *
- * This replaces the special migration pte entry with either a mapping to the
- * new page if migration was successful for that page, or to the original page
- * otherwise.
- *
- * This also unlocks the pages and puts them back on the lru, or drops the extra
- * refcount, for device pages.
+ * This migrates struct page meta-data from source struct page to destination
+ * struct page. This effectively finishes the migration from source page to the
+ * destination page.
  */
-void migrate_vma_finalize(struct migrate_vma *migrate)
+void migrate_vma_pages(struct migrate_vma *migrate)
+{
+	migrate_device_pages(migrate->src, migrate->dst, migrate->npages, migrate);
+}
+EXPORT_SYMBOL(migrate_vma_pages);
+
+static void migrate_device_finalize(unsigned long *src_pfns,
+				unsigned long *dst_pfns, unsigned long npages)
 {
-	const unsigned long npages = migrate->npages;
 	unsigned long i;
 
 	for (i = 0; i < npages; i++) {
 		struct folio *dst, *src;
-		struct page *newpage = migrate_pfn_to_page(migrate->dst[i]);
-		struct page *page = migrate_pfn_to_page(migrate->src[i]);
+		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
+		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 
 		if (!page) {
 			if (newpage) {
@@ -800,7 +810,7 @@ void migrate_vma_finalize(struct migrate
 			continue;
 		}
 
-		if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE) || !newpage) {
+		if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE) || !newpage) {
 			if (newpage) {
 				unlock_page(newpage);
 				put_page(newpage);
@@ -827,6 +837,22 @@ void migrate_vma_finalize(struct migrate
 		}
 	}
 }
+
+/**
+ * migrate_vma_finalize() - restore CPU page table entry
+ * @migrate: migrate struct containing all migration information
+ *
+ * This replaces the special migration pte entry with either a mapping to the
+ * new page if migration was successful for that page, or to the original page
+ * otherwise.
+ *
+ * This also unlocks the pages and puts them back on the lru, or drops the extra
+ * refcount, for device pages.
+ */
+void migrate_vma_finalize(struct migrate_vma *migrate)
+{
+	migrate_device_finalize(migrate->src, migrate->dst, migrate->npages);
+}
 EXPORT_SYMBOL(migrate_vma_finalize);
 
 /*
@@ -837,25 +863,19 @@ EXPORT_SYMBOL(migrate_vma_finalize);
 int migrate_device_coherent_page(struct page *page)
 {
 	unsigned long src_pfn, dst_pfn = 0;
-	struct migrate_vma args;
 	struct page *dpage;
 
 	WARN_ON_ONCE(PageCompound(page));
 
 	lock_page(page);
 	src_pfn = migrate_pfn(page_to_pfn(page)) | MIGRATE_PFN_MIGRATE;
-	args.src = &src_pfn;
-	args.dst = &dst_pfn;
-	args.cpages = 1;
-	args.npages = 1;
-	args.vma = NULL;
 
 	/*
 	 * We don't have a VMA and don't need to walk the page tables to find
 	 * the source page. So call migrate_vma_unmap() directly to unmap the
 	 * page as migrate_vma_setup() will fail if args.vma == NULL.
 	 */
-	migrate_vma_unmap(&args);
+	migrate_device_unmap(&src_pfn, 1, NULL);
 	if (!(src_pfn & MIGRATE_PFN_MIGRATE))
 		return -EBUSY;
 
@@ -865,10 +885,10 @@ int migrate_device_coherent_page(struct
 		dst_pfn = migrate_pfn(page_to_pfn(dpage));
 	}
 
-	migrate_vma_pages(&args);
+	migrate_device_pages(&src_pfn, &dst_pfn, 1, NULL);
 	if (src_pfn & MIGRATE_PFN_MIGRATE)
 		copy_highpage(dpage, page);
-	migrate_vma_finalize(&args);
+	migrate_device_finalize(&src_pfn, &dst_pfn, 1);
 
 	if (src_pfn & MIGRATE_PFN_MIGRATE)
 		return 0;
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-migrate_devicec-add-migrate_device_range.patch
nouveau-dmem-refactor-nouveau_dmem_fault_copy_one.patch
nouveau-dmem-evict-device-private-memory-during-release.patch
hmm-tests-add-test-for-migrate_device_range.patch

