Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CD1EE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 20:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjIMUEf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjIMUEd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 16:04:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DE91BC6
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 13:04:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A25C433C8;
        Wed, 13 Sep 2023 20:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694635469;
        bh=460j5gmulsFYDg4CEoEAwT/4h1g2PcoCb8cINDcf6Hg=;
        h=Date:To:From:Subject:From;
        b=AQgIA05zuSht63i7AOBxeb+aULHE9/06k+6/GNxf96AEaXifpqnoeQVP+8oKEjkIz
         Z5nkct6X9FH3QpO94ui8LXq30A4qTR1CXknMKCoLWibUV32GBvTcqt1kjQByj6pjKr
         bvXzZdKsRT4UEXSVUWXYT7KEwJiC/Pe2pL9fP0+c=
Date:   Wed, 13 Sep 2023 13:04:28 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page.patch added to mm-unstable branch
Message-Id: <20230913200429.33A25C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: remove THP mapcount check in numamigrate_isolate_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate: remove THP mapcount check in numamigrate_isolate_page()
Date: Wed, 13 Sep 2023 17:51:25 +0800

The check of THP mapped by multiple processes was introduced by commit
04fa5d6a6547 ("mm: migrate: check page_count of THP before migrating") and
refactor by commit 340ef3902cf2 ("mm: numa: cleanup flow of transhuge page
migration"), which is out of date, since migrate_misplaced_page() is now
using the standard migrate_pages() for small pages and THPs, the reference
count checking is in folio_migrate_mapping(), so let's remove the special
check for THP.

Link: https://lkml.kernel.org/r/20230913095131.2426871-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page
+++ a/mm/migrate.c
@@ -2483,10 +2483,6 @@ static int numamigrate_isolate_page(pg_d
 	int nr_pages = thp_nr_pages(page);
 	int order = compound_order(page);
 
-	/* Do not migrate THP mapped by multiple processes */
-	if (PageTransHuge(page) && total_mapcount(page) > 1)
-		return 0;
-
 	/* Avoid migrating to a node that is nearly full */
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
 		int z;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page.patch
mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page.patch
mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio.patch
mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio.patch
mm-migrate-use-__folio_test_movable.patch
mm-migrate-use-a-folio-in-add_page_for_migration.patch
mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration.patch
mm-migrate-remove-isolated-variable-in-add_page_for_migration.patch

