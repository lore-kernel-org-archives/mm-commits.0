Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EB2ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiILDdY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiILDbY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:31:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E6813FBE
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 914C261169
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32A9C433C1;
        Mon, 12 Sep 2022 03:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953386;
        bh=8tL4P+E4S+HDlOuw9oVns+vDnrZtZSwZJb76tQZq9zE=;
        h=Date:To:From:Subject:From;
        b=FlfxH6ZFb6i8/6+EM9hQ93p4R0OIs3p4DCknWa0/KMRZPyBsBGtEZucuG9m7hYPAF
         KQpYVg6ZvTyvnG/pbI3WpMe1alK4DSr7wymXW5AnoZnFIgSbgb6P5RZ0DEBiYRK+Lk
         r6IuF1SisMyCi6k6L6E+WK9rSHnnepx9Dk9mvcO4=
Date:   Sun, 11 Sep 2022 20:29:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        syoshida@redhat.com, songmuchun@bytedance.com,
        rcampbell@nvidia.com, logang@deltatee.com, linmiaohe@huawei.com,
        jhubbard@nvidia.com, jgg@nvidia.com, felix.kuehling@amd.com,
        david@redhat.com, dan.j.williams@intel.com, alex.sierra@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch removed from -mm tree
Message-Id: <20220912032945.E32A9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup.c: don't pass gup_flags to check_and_migrate_movable_pages()
has been removed from the -mm tree.  Its filename was
     mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/gup.c: don't pass gup_flags to check_and_migrate_movable_pages()
Date: Wed, 24 Aug 2022 15:09:51 +1000

gup_flags is passed to check_and_migrate_movable_pages() so that it can
call either put_page() or unpin_user_page() to drop the page reference. 
However check_and_migrate_movable_pages() is only called for
FOLL_LONGTERM, which implies FOLL_PIN so there is no need to pass
gup_flags.

Link: https://lkml.kernel.org/r/d611c65a9008ff55887307df457c6c2220ad6163.1661317396.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
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

 mm/gup.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/mm/gup.c~mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages
+++ a/mm/gup.c
@@ -1933,8 +1933,7 @@ struct page *get_dump_page(unsigned long
  * migration failure.
  */
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
-					    struct page **pages,
-					    unsigned int gup_flags)
+					    struct page **pages)
 {
 	unsigned long i;
 	struct folio *prev_folio = NULL;
@@ -1967,10 +1966,8 @@ static long check_and_migrate_movable_pa
 			 * Migration will fail if the page is pinned, so convert
 			 * the pin on the source page to a normal reference.
 			 */
-			if (gup_flags & FOLL_PIN) {
-				get_page(&folio->page);
-				unpin_user_page(&folio->page);
-			}
+			get_page(&folio->page);
+			unpin_user_page(&folio->page);
 
 			if (migrate_device_coherent_page(&folio->page)) {
 				ret = -EBUSY;
@@ -2023,10 +2020,7 @@ static long check_and_migrate_movable_pa
 		if (!pages[i])
 			continue;
 
-		if (gup_flags & FOLL_PIN)
-			unpin_user_page(pages[i]);
-		else
-			put_page(pages[i]);
+		unpin_user_page(pages[i]);
 	}
 
 	if (!list_empty(&movable_page_list)) {
@@ -2049,8 +2043,7 @@ static long check_and_migrate_movable_pa
 }
 #else
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
-					    struct page **pages,
-					    unsigned int gup_flags)
+					    struct page **pages)
 {
 	return 0;
 }
@@ -2073,6 +2066,9 @@ static long __gup_longterm_locked(struct
 	if (!(gup_flags & FOLL_LONGTERM))
 		return __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
 					       NULL, gup_flags);
+	/* check_and_migrate_movable_pages() assumes pages have been pinned. */
+	if (WARN_ON(!(gup_flags & FOLL_PIN)))
+		return -EINVAL;
 	flags = memalloc_pin_save();
 	do {
 		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages,
@@ -2082,8 +2078,7 @@ static long __gup_longterm_locked(struct
 			rc = nr_pinned_pages;
 			break;
 		}
-		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages,
-						     gup_flags);
+		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages);
 	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
 
_

Patches currently in -mm which might be from apopple@nvidia.com are

selftests-hmm-tests-add-test-for-dirty-bits.patch

