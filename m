Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD67C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiGRAQr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiGRAQe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:16:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4314995A4
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE444B80EB8
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604AEC3411E;
        Mon, 18 Jul 2022 00:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103390;
        bh=ImVkweJ0X7GE2pYDjXTxhf5L59gRxhKW1PnCBdLdXVA=;
        h=Date:To:From:Subject:From;
        b=0j8APpkt2lo+fYGE/a6oudbBKcWnt4raHiyWO45ktpwfwtiR0BPC4ARrw1oeQa1+O
         IIX1kZQFqvipFJlRYF+m8nGxjKhQYRD8r6PBKqi83EZtGJQTS3MxKw4Rr43QJW35Zz
         BQpSOOWKjpSXSsQBn/6BwzbKVw8Ki3P71VwOBFk0=
Date:   Sun, 17 Jul 2022 17:16:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch removed from -mm tree
Message-Id: <20220718001630.604AEC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: migrate device coherent pages when pinning instead of failing
has been removed from the -mm tree.  Its filename was
     mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/gup: migrate device coherent pages when pinning instead of failing
Date: Fri, 15 Jul 2022 10:05:13 -0500

Currently any attempts to pin a device coherent page will fail.  This is
because device coherent pages need to be managed by a device driver, and
pinning them would prevent a driver from migrating them off the device.

However this is no reason to fail pinning of these pages.  These are
coherent and accessible from the CPU so can be migrated just like pinning
ZONE_MOVABLE pages.  So instead of failing all attempts to pin them first
try migrating them out of ZONE_DEVICE.

[hch@lst.de: rebased to the split device memory checks, moved migrate_device_page to migrate_device.c]
Link: https://lkml.kernel.org/r/20220715150521.18165-7-alex.sierra@amd.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c            |   50 ++++++++++++++++++++++++++++++++++------
 mm/internal.h       |    1 
 mm/migrate_device.c |   52 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 7 deletions(-)

--- a/mm/gup.c~mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing
+++ a/mm/gup.c
@@ -1913,7 +1913,7 @@ static long check_and_migrate_movable_pa
 	unsigned long isolation_error_count = 0, i;
 	struct folio *prev_folio = NULL;
 	LIST_HEAD(movable_page_list);
-	bool drain_allow = true;
+	bool drain_allow = true, coherent_pages = false;
 	int ret = 0;
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1923,9 +1923,38 @@ static long check_and_migrate_movable_pa
 			continue;
 		prev_folio = folio;
 
-		if (folio_is_longterm_pinnable(folio))
+		/*
+		 * Device coherent pages are managed by a driver and should not
+		 * be pinned indefinitely as it prevents the driver moving the
+		 * page. So when trying to pin with FOLL_LONGTERM instead try
+		 * to migrate the page out of device memory.
+		 */
+		if (folio_is_device_coherent(folio)) {
+			/*
+			 * We always want a new GUP lookup with device coherent
+			 * pages.
+			 */
+			pages[i] = 0;
+			coherent_pages = true;
+
+			/*
+			 * Migration will fail if the page is pinned, so convert
+			 * the pin on the source page to a normal reference.
+			 */
+			if (gup_flags & FOLL_PIN) {
+				get_page(&folio->page);
+				unpin_user_page(&folio->page);
+			}
+
+			ret = migrate_device_coherent_page(&folio->page);
+			if (ret)
+				goto unpin_pages;
+
 			continue;
+		}
 
+		if (folio_is_longterm_pinnable(folio))
+			continue;
 		/*
 		 * Try to move out any movable page before pinning the range.
 		 */
@@ -1951,7 +1980,8 @@ static long check_and_migrate_movable_pa
 				    folio_nr_pages(folio));
 	}
 
-	if (!list_empty(&movable_page_list) || isolation_error_count)
+	if (!list_empty(&movable_page_list) || isolation_error_count
+		|| coherent_pages)
 		goto unpin_pages;
 
 	/*
@@ -1961,10 +1991,16 @@ static long check_and_migrate_movable_pa
 	return nr_pages;
 
 unpin_pages:
-	if (gup_flags & FOLL_PIN) {
-		unpin_user_pages(pages, nr_pages);
-	} else {
-		for (i = 0; i < nr_pages; i++)
+	/*
+	 * pages[i] might be NULL if any device coherent pages were found.
+	 */
+	for (i = 0; i < nr_pages; i++) {
+		if (!pages[i])
+			continue;
+
+		if (gup_flags & FOLL_PIN)
+			unpin_user_page(pages[i]);
+		else
 			put_page(pages[i]);
 	}
 
--- a/mm/internal.h~mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing
+++ a/mm/internal.h
@@ -853,6 +853,7 @@ int numa_migrate_prep(struct page *page,
 		      unsigned long addr, int page_nid, int *flags);
 
 void free_zone_device_page(struct page *page);
+int migrate_device_coherent_page(struct page *page);
 
 /*
  * mm/gup.c
--- a/mm/migrate_device.c~mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing
+++ a/mm/migrate_device.c
@@ -686,6 +686,12 @@ void migrate_vma_pages(struct migrate_vm
 		}
 
 		if (!page) {
+			/*
+			 * The only time there is no vma is when called from
+			 * migrate_device_coherent_page(). However this isn't
+			 * called if the page could not be unmapped.
+			 */
+			VM_BUG_ON(!migrate->vma);
 			if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE))
 				continue;
 			if (!notified) {
@@ -794,3 +800,49 @@ void migrate_vma_finalize(struct migrate
 	}
 }
 EXPORT_SYMBOL(migrate_vma_finalize);
+
+/*
+ * Migrate a device coherent page back to normal memory. The caller should have
+ * a reference on page which will be copied to the new page if migration is
+ * successful or dropped on failure.
+ */
+int migrate_device_coherent_page(struct page *page)
+{
+	unsigned long src_pfn, dst_pfn = 0;
+	struct migrate_vma args;
+	struct page *dpage;
+
+	WARN_ON_ONCE(PageCompound(page));
+
+	lock_page(page);
+	src_pfn = migrate_pfn(page_to_pfn(page)) | MIGRATE_PFN_MIGRATE;
+	args.src = &src_pfn;
+	args.dst = &dst_pfn;
+	args.cpages = 1;
+	args.npages = 1;
+	args.vma = NULL;
+
+	/*
+	 * We don't have a VMA and don't need to walk the page tables to find
+	 * the source page. So call migrate_vma_unmap() directly to unmap the
+	 * page as migrate_vma_setup() will fail if args.vma == NULL.
+	 */
+	migrate_vma_unmap(&args);
+	if (!(src_pfn & MIGRATE_PFN_MIGRATE))
+		return -EBUSY;
+
+	dpage = alloc_page(GFP_USER | __GFP_NOWARN);
+	if (dpage) {
+		lock_page(dpage);
+		dst_pfn = migrate_pfn(page_to_pfn(dpage));
+	}
+
+	migrate_vma_pages(&args);
+	if (src_pfn & MIGRATE_PFN_MIGRATE)
+		copy_highpage(dpage, page);
+	migrate_vma_finalize(&args);
+
+	if (src_pfn & MIGRATE_PFN_MIGRATE)
+		return 0;
+	return -EBUSY;
+}
_

Patches currently in -mm which might be from apopple@nvidia.com are


