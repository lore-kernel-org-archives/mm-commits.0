Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50EBC32796
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 17:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239736AbiHXR5B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 13:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240271AbiHXR47 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 13:56:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90B148C93
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 10:56:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 548F4B8260D
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BC0C433C1;
        Wed, 24 Aug 2022 17:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661363815;
        bh=ouhlCxSHTtjuqliT7jw0CgcQoFOx8a9FRlj7qchZExE=;
        h=Date:To:From:Subject:From;
        b=Ja00S+Mcm98Xd5YWIUcSe9U/82pWaQ/aMYLQMGGX+jLAT4clKI90Cgzam92vYatqB
         1QkM7rOIvOv4EW0m+ot2HxPdSdbGhvK2USB15dX8SaxrWgRZzBG5UmY30ZiJlrPlPF
         K/SzEuHS8+VqF61m4OMnoRj0n0M4INvYMZLKwlT8=
Date:   Wed, 24 Aug 2022 10:56:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        syoshida@redhat.com, songmuchun@bytedance.com,
        rcampbell@nvidia.com, logang@deltatee.com, linmiaohe@huawei.com,
        jhubbard@nvidia.com, jgg@nvidia.com, felix.kuehling@amd.com,
        david@redhat.com, dan.j.williams@intel.com, alex.sierra@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-refactor-check_and_migrate_movable_pages.patch added to mm-unstable branch
Message-Id: <20220824175654.E8BC0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: refactor check_and_migrate_movable_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gupc-refactor-check_and_migrate_movable_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gupc-refactor-check_and_migrate_movable_pages.patch

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
Subject: mm/gup.c: refactor check_and_migrate_movable_pages()
Date: Wed, 24 Aug 2022 15:09:52 +1000

When pinning pages with FOLL_LONGTERM check_and_migrate_movable_pages() is
called to migrate pages out of zones which should not contain any longterm
pinned pages.

When migration succeeds all pages will have been unpinned so pinning needs
to be retried.  Migration can also fail, in which case the pages will also
have been unpinned but the operation should not be retried.  If all pages
are in the correct zone nothing will be unpinned and no retry is required.

The logic in check_and_migrate_movable_pages() tracks unnecessary state
and the return codes for each case are difficult to follow.  Refactor the
code to clean this up.  No behaviour change is intended.

Link: https://lkml.kernel.org/r/19583d1df07fdcb99cfa05c265588a3fa58d1902.1661317396.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>

Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  180 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 112 insertions(+), 68 deletions(-)

--- a/mm/gup.c~mm-gupc-refactor-check_and_migrate_movable_pages
+++ a/mm/gup.c
@@ -1904,19 +1904,16 @@ struct page *get_dump_page(unsigned long
 
 #ifdef CONFIG_MIGRATION
 /*
- * Check whether all pages are pinnable. If some pages are not pinnable migrate
- * them and unpin all the pages. Returns -EAGAIN if pages were unpinned or zero
- * if all pages are pinnable and in the right zone. Other errors indicate
- * migration failure.
+ * Returns the number of collected pages. Return value is always >= 0.
  */
-static long check_and_migrate_movable_pages(unsigned long nr_pages,
-					    struct page **pages)
+static unsigned long collect_longterm_unpinnable_pages(
+					struct list_head *movable_page_list,
+					unsigned long nr_pages,
+					struct page **pages)
 {
-	unsigned long i;
+	unsigned long i, collected = 0;
 	struct folio *prev_folio = NULL;
-	LIST_HEAD(movable_page_list);
-	bool drain_allow = true, coherent_pages = false;
-	int ret = 0;
+	bool drain_allow = true;
 
 	for (i = 0; i < nr_pages; i++) {
 		struct folio *folio = page_folio(pages[i]);
@@ -1925,43 +1922,16 @@ static long check_and_migrate_movable_pa
 			continue;
 		prev_folio = folio;
 
-		/*
-		 * Device coherent pages are managed by a driver and should not
-		 * be pinned indefinitely as it prevents the driver moving the
-		 * page. So when trying to pin with FOLL_LONGTERM instead try
-		 * to migrate the page out of device memory.
-		 */
-		if (folio_is_device_coherent(folio)) {
-			/*
-			 * We always want a new GUP lookup with device coherent
-			 * pages.
-			 */
-			pages[i] = 0;
-			coherent_pages = true;
+		if (folio_is_longterm_pinnable(folio))
+			continue;
 
-			/*
-			 * Migration will fail if the page is pinned, so convert
-			 * the pin on the source page to a normal reference.
-			 */
-			get_page(&folio->page);
-			unpin_user_page(&folio->page);
+		collected++;
 
-			if (migrate_device_coherent_page(&folio->page)) {
-				ret = -EBUSY;
-				break;
-			}
+		if (folio_is_device_coherent(folio))
 			continue;
-		}
 
-		if (folio_is_longterm_pinnable(folio))
-			continue;
-		/*
-		 * Try to move out any movable page before pinning the range.
-		 */
 		if (folio_test_hugetlb(folio)) {
-			if (isolate_hugetlb(&folio->page,
-						&movable_page_list))
-				ret = -EBUSY;
+			isolate_hugetlb(&folio->page, movable_page_list);
 			continue;
 		}
 
@@ -1970,53 +1940,119 @@ static long check_and_migrate_movable_pa
 			drain_allow = false;
 		}
 
-		if (folio_isolate_lru(folio)) {
-			ret = -EBUSY;
+		if (!folio_isolate_lru(folio))
 			continue;
-		}
-		list_add_tail(&folio->lru, &movable_page_list);
+
+		list_add_tail(&folio->lru, movable_page_list);
 		node_stat_mod_folio(folio,
 				    NR_ISOLATED_ANON + folio_is_file_lru(folio),
 				    folio_nr_pages(folio));
 	}
 
-	/*
-	 * If list is empty, and no isolation errors, means that all pages are
-	 * in the correct zone. If there were device coherent pages some pages
-	 * have been unpinned.
-	 */
-	if (list_empty(&movable_page_list) && !ret && !coherent_pages)
-		return 0;
+	return collected;
+}
+
+/*
+ * Unpins all pages and migrates device coherent pages and movable_page_list.
+ * Returns -EAGAIN if all pages were successfully migrated or -errno for failure
+ * (or partial success).
+ */
+static int migrate_longterm_unpinnable_pages(
+					struct list_head *movable_page_list,
+					unsigned long nr_pages,
+					struct page **pages)
+{
+	int ret;
+	unsigned long i;
 
-	/*
-	 * Unpin all pages. If device coherent pages were found
-	 * migrate_device_coherent_page() will have dropped the pin and set
-	 * pages[i] == NULL.
-	 */
 	for (i = 0; i < nr_pages; i++) {
-		if (!pages[i])
+		struct folio *folio = page_folio(pages[i]);
+
+		if (folio_is_device_coherent(folio)) {
+			/*
+			 * Migration will fail if the page is pinned, so convert
+			 * the pin on the source page to a normal reference.
+			 */
+			pages[i] = NULL;
+			folio_get(folio);
+			gup_put_folio(folio, 1, FOLL_PIN);
+
+			if (migrate_device_coherent_page(&folio->page)) {
+				ret = -EBUSY;
+				goto err;
+			}
+
 			continue;
+		}
 
+		/*
+		 * We can't migrate pages with unexpected references, so drop
+		 * the reference obtained by __get_user_pages_locked().
+		 * Migrating pages have been added to movable_page_list after
+		 * calling folio_isolate_lru() which takes a reference so the
+		 * page won't be freed if it's migrating.
+		 */
 		unpin_user_page(pages[i]);
+		pages[i] = NULL;
 	}
 
-	if (!list_empty(&movable_page_list)) {
+	if (!list_empty(movable_page_list)) {
 		struct migration_target_control mtc = {
 			.nid = NUMA_NO_NODE,
 			.gfp_mask = GFP_USER | __GFP_NOWARN,
 		};
 
-		ret = migrate_pages(&movable_page_list, alloc_migration_target,
-				    NULL, (unsigned long)&mtc, MIGRATE_SYNC,
-				    MR_LONGTERM_PIN, NULL);
-		if (ret > 0) /* number of pages not migrated */
+		if (migrate_pages(movable_page_list, alloc_migration_target,
+				  NULL, (unsigned long)&mtc, MIGRATE_SYNC,
+				  MR_LONGTERM_PIN, NULL)) {
 			ret = -ENOMEM;
+			goto err;
+		}
 	}
 
-	if (ret && !list_empty(&movable_page_list))
-		putback_movable_pages(&movable_page_list);
+	putback_movable_pages(movable_page_list);
+
+	return -EAGAIN;
+
+err:
+	for (i = 0; i < nr_pages; i++)
+		if (pages[i])
+			unpin_user_page(pages[i]);
+	putback_movable_pages(movable_page_list);
 
-	return ret ? ret : -EAGAIN;
+	return ret;
+}
+
+/*
+ * Check whether all pages are *allowed* to be pinned. Rather confusingly, all
+ * pages in the range are required to be pinned via FOLL_PIN, before calling
+ * this routine.
+ *
+ * If any pages in the range are not allowed to be pinned, then this routine
+ * will migrate those pages away, unpin all the pages in the range and return
+ * -EAGAIN. The caller should re-pin the entire range with FOLL_PIN and then
+ * call this routine again.
+ *
+ * If an error other than -EAGAIN occurs, this indicates a migration failure.
+ * The caller should give up, and propagate the error back up the call stack.
+ *
+ * If everything is OK and all pages in the range are allowed to be pinned, then
+ * this routine leaves all pages pinned and returns zero for success.
+ */
+static long check_and_migrate_movable_pages(unsigned long nr_pages,
+					    struct page **pages)
+{
+	int ret;
+	unsigned long collected;
+	LIST_HEAD(movable_page_list);
+
+	collected = collect_longterm_unpinnable_pages(&movable_page_list,
+						nr_pages, pages);
+	if (!collected)
+		return 0;
+
+	return migrate_longterm_unpinnable_pages(&movable_page_list, nr_pages,
+						pages);
 }
 #else
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
@@ -2043,7 +2079,15 @@ static long __gup_longterm_locked(struct
 	if (!(gup_flags & FOLL_LONGTERM))
 		return __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
 					       NULL, gup_flags);
-	/* check_and_migrate_movable_pages() assumes pages have been pinned. */
+
+	/*
+	 * If we get to this point then FOLL_LONGTERM is set, and FOLL_LONGTERM
+	 * implies FOLL_PIN (although the reverse is not true). Therefore it is
+	 * correct to unconditionally call check_and_migrate_movable_pages()
+	 * which assumes pages have been pinned via FOLL_PIN.
+	 *
+	 * Enforce the above reasoning by asserting that FOLL_PIN is set.
+	 */
 	if (WARN_ON(!(gup_flags & FOLL_PIN)))
 		return -EINVAL;
 	flags = memalloc_pin_save();
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-migrate_devicec-copy-pte-dirty-bit-to-page.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch
selftests-hmm-tests-add-test-for-dirty-bits.patch
mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch
mm-gupc-refactor-check_and_migrate_movable_pages.patch

