Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA339C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353347AbiBKUrO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:47:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiBKUrM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:47:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89364CF9
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:47:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F014B82CDF
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B405FC340E9;
        Fri, 11 Feb 2022 20:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612427;
        bh=aoo4ZiKYGuxDp0bH966aK9gmmZGyNMVQqs35nF3oXGw=;
        h=Date:To:From:Subject:From;
        b=xFyfkdLK2LfXe+Itf+9a3AKXiLiSHCebDYgEuPBRcm/jEEu005Ga6f0UQ+ehcLiEx
         KioL8wgnn0YjRo9iImSuDo2Lqq8DY0FYt3Sv9zaxf0wK/lnNyV0zKiNZE7Fn8UN6hw
         KOCZ1YnDoCMy8XebI50YGQ08KWqv+RlZTy9+xdVQ=
Date:   Fri, 11 Feb 2022 12:47:07 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, hch@lst.de, Felix.Kuehling@amd.com,
        alex.sierra@amd.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch removed from -mm tree
Message-Id: <20220211204707.B405FC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: migrate device coherent pages when pinning instead of failing
has been removed from the -mm tree.  Its filename was
     mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/gup.c: migrate device coherent pages when pinning instead of failing

Currently any attempts to pin a device coherent page will fail.  This is
because device coherent pages need to be managed by a device driver, and
pinning them would prevent a driver from migrating them off the device.

However this is no reason to fail pinning of these pages.  These are
coherent and accessible from the CPU so can be migrated just like pinning
ZONE_MOVABLE pages.  So instead of failing all attempts to pin them first
try migrating them out of ZONE_DEVICE.

Link: https://lkml.kernel.org/r/dd9960b327ca49a9103d9f97868ea7b0b81186c4.1644207242.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  105 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 95 insertions(+), 10 deletions(-)

--- a/mm/gup.c~mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing
+++ a/mm/gup.c
@@ -1835,6 +1835,60 @@ struct page *get_dump_page(unsigned long
 
 #ifdef CONFIG_MIGRATION
 /*
+ * Migrates a device coherent page back to normal memory. Caller should have a
+ * reference on page which will be copied to the new page if migration is
+ * successful or dropped on failure.
+ */
+static struct page *migrate_device_page(struct page *page,
+					unsigned int gup_flags)
+{
+	struct page *dpage;
+	struct migrate_vma args;
+	unsigned long src_pfn, dst_pfn = 0;
+
+	lock_page(page);
+	src_pfn = migrate_pfn(page_to_pfn(page)) | MIGRATE_PFN_MIGRATE;
+	args.src = &src_pfn;
+	args.dst = &dst_pfn;
+	args.cpages = 1;
+	args.npages = 1;
+	args.vma = NULL;
+	migrate_vma_setup(&args);
+	if (!(src_pfn & MIGRATE_PFN_MIGRATE))
+		return NULL;
+
+	dpage = alloc_pages(GFP_USER | __GFP_NOWARN, 0);
+
+	/*
+	 * get/pin the new page now so we don't have to retry gup after
+	 * migrating. We already have a reference so this should never fail.
+	 */
+	if (dpage && WARN_ON_ONCE(!try_grab_page(dpage, gup_flags))) {
+		__free_pages(dpage, 0);
+		dpage = NULL;
+	}
+
+	if (dpage) {
+		lock_page(dpage);
+		dst_pfn = migrate_pfn(page_to_pfn(dpage));
+	}
+
+	migrate_vma_pages(&args);
+	if (src_pfn & MIGRATE_PFN_MIGRATE)
+		copy_highpage(dpage, page);
+	migrate_vma_finalize(&args);
+	if (dpage && !(src_pfn & MIGRATE_PFN_MIGRATE)) {
+		if (gup_flags & FOLL_PIN)
+			unpin_user_page(dpage);
+		else
+			put_page(dpage);
+		dpage = NULL;
+	}
+
+	return dpage;
+}
+
+/*
  * Check whether all pages are pinnable, if so return number of pages.  If some
  * pages are not pinnable, migrate them, and unpin all pages. Return zero if
  * pages were migrated, or if some pages were not successfully isolated.
@@ -1862,15 +1916,40 @@ static long check_and_migrate_movable_pa
 			continue;
 		prev_head = head;
 		/*
-		 * If we get a movable page, since we are going to be pinning
-		 * these entries, try to move them out if possible.
+		 * Device coherent pages are managed by a driver and should not
+		 * be pinned indefinitely as it prevents the driver moving the
+		 * page. So when trying to pin with FOLL_LONGTERM instead try
+		 * migrating page out of device memory.
 		 */
 		if (is_dev_private_or_coherent_page(head)) {
+			/*
+			 * device private pages will get faulted in during gup
+			 * so it shouldn't be possible to see one here.
+			 */
 			WARN_ON_ONCE(is_device_private_page(head));
-			ret = -EFAULT;
-			goto unpin_pages;
+			WARN_ON_ONCE(PageCompound(head));
+
+			/*
+			 * migration will fail if the page is pinned, so convert
+			 * the pin on the source page to a normal reference.
+			 */
+			if (gup_flags & FOLL_PIN) {
+				get_page(head);
+				unpin_user_page(head);
+			}
+
+			pages[i] = migrate_device_page(head, gup_flags);
+			if (!pages[i]) {
+				ret = -EBUSY;
+				break;
+			}
+			continue;
 		}
 
+		/*
+		 * If we get a movable page, since we are going to be pinning
+		 * these entries, try to move them out if possible.
+		 */
 		if (!is_pinnable_page(head)) {
 			if (PageHuge(head)) {
 				if (!isolate_huge_page(head, &movable_page_list))
@@ -1898,16 +1977,22 @@ static long check_and_migrate_movable_pa
 	 * If list is empty, and no isolation errors, means that all pages are
 	 * in the correct zone.
 	 */
-	if (list_empty(&movable_page_list) && !isolation_error_count)
+	if (!ret && list_empty(&movable_page_list) && !isolation_error_count)
 		return nr_pages;
 
-unpin_pages:
-	if (gup_flags & FOLL_PIN) {
-		unpin_user_pages(pages, nr_pages);
-	} else {
-		for (i = 0; i < nr_pages; i++)
+	for (i = 0; i < nr_pages; i++)
+		if (!pages[i])
+			continue;
+		else if (gup_flags & FOLL_PIN)
+			unpin_user_page(pages[i]);
+		else
 			put_page(pages[i]);
+
+	if (ret && !list_empty(&movable_page_list)) {
+		putback_movable_pages(&movable_page_list);
+		return ret;
 	}
+
 	if (!list_empty(&movable_page_list)) {
 		ret = migrate_pages(&movable_page_list, alloc_migration_target,
 				    NULL, (unsigned long)&mtc, MIGRATE_SYNC,
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-remove-the-vma-check-in-migrate_vma_setup.patch
mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

