Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2623FC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 22:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiBGWYB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 17:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbiBGWYA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 17:24:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DA9C061A73
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 14:23:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 720FA60A77
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 22:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F7CC004E1;
        Mon,  7 Feb 2022 22:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644272638;
        bh=zUuch5OV0sCvRR4JJMOrFW7XjaU5qa+l6bKFnSYjfdI=;
        h=Date:To:From:Subject:From;
        b=poUpkrXkMjVLNkzTqtIv3x/yvXKf7Ch4x3GqvQarTJQqBwunDIXuw073vFOL5rId6
         ovlfEJpLs7kd6yQt4AS5fj+QAKanc5GMmt5zQi4f7lhT17nAANJRt82pp8jc2CV4mZ
         8mUqLoMy+amDaGS3uFjmkks8xIq2j5eHGQYujhNM=
Date:   Mon, 07 Feb 2022 14:23:58 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, hch@lst.de, Felix.Kuehling@amd.com,
        alex.sierra@amd.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch added to -mm tree
Message-Id: <20220207222358.C5F7CC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: migrate device coherent pages when pinning instead of failing
has been added to the -mm tree.  Its filename is
     mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1862,6 +1862,60 @@ struct page *get_dump_page(unsigned long
 
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
@@ -1889,15 +1943,40 @@ static long check_and_migrate_movable_pa
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
@@ -1925,16 +2004,22 @@ static long check_and_migrate_movable_pa
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

migratec-remove-vma-check-in-migrate_vma_setup.patch
mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

