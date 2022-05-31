Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C3EC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 20:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345899AbiEaUXO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 16:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347678AbiEaUXM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 16:23:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5183C56405
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 13:23:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E55A6612A5
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 20:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473CAC385A9;
        Tue, 31 May 2022 20:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654028590;
        bh=8ONCIptPOLd0e83OJRuWIS0+jTJNPeJUO2Ekm99XuwQ=;
        h=Date:To:From:Subject:From;
        b=JIoS0UJ0yiPm5iXspJ+ZYg9jawIxK5G5ZzpMlY5bLj0/4ioZgJiFbbCxTQkeKK7iv
         NJECtQKwb2P/86ZX3awLFTi3B9BKGuWVGzw35ko4erFfqEx3JEUpldZyEfspmIlIJ1
         VEQUU+iy5gTv/VpAo0EsQeGklPucmQsA15n0iEOc=
Date:   Tue, 31 May 2022 13:23:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch added to mm-unstable branch
Message-Id: <20220531202310.473CAC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: migrate device coherent pages when pinning instead of failing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

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
Subject: mm/gup: migrate device coherent pages when pinning instead of failing
Date: Tue, 31 May 2022 15:00:33 -0500

Currently any attempts to pin a device coherent page will fail.  This is
because device coherent pages need to be managed by a device driver, and
pinning them would prevent a driver from migrating them off the device.

However this is no reason to fail pinning of these pages.  These are
coherent and accessible from the CPU so can be migrated just like pinning
ZONE_MOVABLE pages.  So instead of failing all attempts to pin them first
try migrating them out of ZONE_DEVICE.

[hch@lst.de: rebased to the split device memory checks, moved migrate_device_page to migrate_device.c]
Link: https://lkml.kernel.org/r/20220531200041.24904-6-alex.sierra@amd.com
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

 mm/gup.c            |   47 +++++++++++++++++++++++++++++++++----
 mm/internal.h       |    1 
 mm/migrate_device.c |   53 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 5 deletions(-)

--- a/mm/gup.c~mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing
+++ a/mm/gup.c
@@ -1927,9 +1927,43 @@ static long check_and_migrate_movable_pa
 			continue;
 		prev_folio = folio;
 
-		if (folio_is_pinnable(folio))
+		/*
+		 * Device private pages will get faulted in during gup so it
+		 * shouldn't be possible to see one here.
+		 */
+		if (WARN_ON_ONCE(folio_is_device_private(folio))) {
+			ret = -EFAULT;
+			goto unpin_pages;
+		}
+
+		/*
+		 * Device coherent pages are managed by a driver and should not
+		 * be pinned indefinitely as it prevents the driver moving the
+		 * page. So when trying to pin with FOLL_LONGTERM instead try
+		 * to migrate the page out of device memory.
+		 */
+		if (folio_is_device_coherent(folio)) {
+			WARN_ON_ONCE(PageCompound(&folio->page));
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
+			pages[i] = migrate_device_page(&folio->page, gup_flags);
+			if (!pages[i]) {
+				ret = -EBUSY;
+				goto unpin_pages;
+			}
 			continue;
+		}
 
+		if (folio_is_pinnable(folio))
+			continue;
 		/*
 		 * Try to move out any movable page before pinning the range.
 		 */
@@ -1965,10 +1999,13 @@ static long check_and_migrate_movable_pa
 	return nr_pages;
 
 unpin_pages:
-	if (gup_flags & FOLL_PIN) {
-		unpin_user_pages(pages, nr_pages);
-	} else {
-		for (i = 0; i < nr_pages; i++)
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
+struct page *migrate_device_page(struct page *page, unsigned int gup_flags);
 
 /*
  * mm/gup.c
--- a/mm/migrate_device.c~mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing
+++ a/mm/migrate_device.c
@@ -794,3 +794,56 @@ void migrate_vma_finalize(struct migrate
 	}
 }
 EXPORT_SYMBOL(migrate_vma_finalize);
+
+/*
+ * Migrate a device coherent page back to normal memory.  The caller should have
+ * a reference on page which will be copied to the new page if migration is
+ * successful or dropped on failure.
+ */
+struct page *migrate_device_page(struct page *page, unsigned int gup_flags)
+{
+	unsigned long src_pfn, dst_pfn = 0;
+	struct migrate_vma args;
+	struct page *dpage;
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
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-remove-the-vma-check-in-migrate_vma_setup.patch
mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

