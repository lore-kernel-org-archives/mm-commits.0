Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DE6EE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 20:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjIMUEb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjIMUEa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 16:04:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA96C19BF
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 13:04:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BCEC433C8;
        Wed, 13 Sep 2023 20:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694635466;
        bh=JWfHl2x1/LbAHpAtUCxcYQ4nMO+IB66RgKIezox8NRQ=;
        h=Date:To:From:Subject:From;
        b=Tmu9aIhBu1w7UZZWK9RnrHmt0RaWvtgteIYnluGLr+9O9zzEip+sLRhwUwNs5EKAd
         M/xFkslNCMnnsxzjFrjVGYzmFSAGoOG2m63d6/uCeK94ZVNIqbu5opJ/prqBVyQmzJ
         ndvNJYbth+dsO1bbUaBzfaicZDKP5ahjwTW73cwg=
Date:   Wed, 13 Sep 2023 13:04:25 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page.patch added to mm-unstable branch
Message-Id: <20230913200426.60BCEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: remove PageTransHuge check in numamigrate_isolate_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page.patch

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
Subject: mm: migrate: remove PageTransHuge check in numamigrate_isolate_page()
Date: Wed, 13 Sep 2023 17:51:24 +0800

Patch series "mm: migrate: more folio conversion and unification", v3.

Convert more migrate functions to use a folio, it is also a preparation
for large folio migration support when balancing numa.


This patch (of 8):

The assert VM_BUG_ON_PAGE(order && !PageTransHuge(page), page) is not very
useful,

   1) for a tail/base page, order = 0, for a head page, the order > 0 &&
      PageTransHuge() is true
   2) there is a PageCompound() check and only base page is handled in
      do_numa_page(), and do_huge_pmd_numa_page() only handle PMD-mapped
      THP
   3) even though the page is a tail page, isolate_lru_page() will post
      a warning, and fail to isolate the page
   4) if large folio/pte-mapped THP migration supported in the future,
      we could migrate the entire folio if numa fault on a tail page

so just remove the check.

Link: https://lkml.kernel.org/r/20230913095131.2426871-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20230913095131.2426871-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page
+++ a/mm/migrate.c
@@ -2483,8 +2483,6 @@ static int numamigrate_isolate_page(pg_d
 	int nr_pages = thp_nr_pages(page);
 	int order = compound_order(page);
 
-	VM_BUG_ON_PAGE(order && !PageTransHuge(page), page);
-
 	/* Do not migrate THP mapped by multiple processes */
 	if (PageTransHuge(page) && total_mapcount(page) > 1)
 		return 0;
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

