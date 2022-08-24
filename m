Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3917C00140
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 17:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240290AbiHXR5A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 13:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239736AbiHXR4z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 13:56:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082FE1EC6D
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 10:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A7CE615AE
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C954EC433D7;
        Wed, 24 Aug 2022 17:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661363812;
        bh=mg5qA7bFrnKvuv+kob/cqlF16WIyAZ7OwNo+zM16Ul4=;
        h=Date:To:From:Subject:From;
        b=QmvCmKWThj9R7znIXbAAUl4OVMUxl/TtweGzUow7EmT/X69y1709HJ8v+2ZNaGDDf
         BNVCmfCfIdwjMB0AQPTep43Po8RY3XivgmchmNRgEknhkhpmmabaLlcZa8gyOXnkVi
         /J0EtBWCLM9mW9stBrPoGYZCQgtQrcy9rqYWBDcs=
Date:   Wed, 24 Aug 2022 10:56:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        syoshida@redhat.com, songmuchun@bytedance.com,
        rcampbell@nvidia.com, logang@deltatee.com, linmiaohe@huawei.com,
        jhubbard@nvidia.com, jgg@nvidia.com, felix.kuehling@amd.com,
        david@redhat.com, dan.j.williams@intel.com, alex.sierra@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch added to mm-unstable branch
Message-Id: <20220824175652.C954EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: don't pass gup_flags to check_and_migrate_movable_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch

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
@@ -1910,8 +1910,7 @@ struct page *get_dump_page(unsigned long
  * migration failure.
  */
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
-					    struct page **pages,
-					    unsigned int gup_flags)
+					    struct page **pages)
 {
 	unsigned long i;
 	struct folio *prev_folio = NULL;
@@ -1944,10 +1943,8 @@ static long check_and_migrate_movable_pa
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
@@ -2000,10 +1997,7 @@ static long check_and_migrate_movable_pa
 		if (!pages[i])
 			continue;
 
-		if (gup_flags & FOLL_PIN)
-			unpin_user_page(pages[i]);
-		else
-			put_page(pages[i]);
+		unpin_user_page(pages[i]);
 	}
 
 	if (!list_empty(&movable_page_list)) {
@@ -2026,8 +2020,7 @@ static long check_and_migrate_movable_pa
 }
 #else
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
-					    struct page **pages,
-					    unsigned int gup_flags)
+					    struct page **pages)
 {
 	return 0;
 }
@@ -2050,6 +2043,9 @@ static long __gup_longterm_locked(struct
 	if (!(gup_flags & FOLL_LONGTERM))
 		return __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
 					       NULL, gup_flags);
+	/* check_and_migrate_movable_pages() assumes pages have been pinned. */
+	if (WARN_ON(!(gup_flags & FOLL_PIN)))
+		return -EINVAL;
 	flags = memalloc_pin_save();
 	do {
 		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages,
@@ -2057,8 +2053,7 @@ static long __gup_longterm_locked(struct
 							  gup_flags);
 		if (nr_pinned_pages <= 0)
 			break;
-		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages,
-						     gup_flags);
+		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages);
 	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
 
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-migrate_devicec-copy-pte-dirty-bit-to-page.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch
selftests-hmm-tests-add-test-for-dirty-bits.patch
mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch
mm-gupc-refactor-check_and_migrate_movable_pages.patch

