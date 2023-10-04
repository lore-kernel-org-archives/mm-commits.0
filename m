Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DFBE7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbjJDUWd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244744AbjJDUWZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E531700
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC2FC433C9;
        Wed,  4 Oct 2023 20:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450871;
        bh=3QscZCULWMGWvBQ63Dkck2zOSyMv6DAlEL5fiX6ymB8=;
        h=Date:To:From:Subject:From;
        b=Tq3AMXKZ5fSc4Yzo+6bE5jqGHtDLf7i7u38NXmeB0JNy6MJnBY3a3S1RUnq8y8S0o
         qi6MX4F12DHdcnrsu026QU4tDBBMammO/vJsWN5ZhU8emNVl9r6UFFGqfAcqt+V5O3
         eQXgd0iz6FK45SLicbbXLxGXu1VwOlg0+cAMTh2o=
Date:   Wed, 04 Oct 2023 13:21:09 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page.patch removed from -mm tree
Message-Id: <20231004202111.5BC2FC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: remove PageTransHuge check in numamigrate_isolate_page()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2486,8 +2486,6 @@ static int numamigrate_isolate_page(pg_d
 	int nr_pages = thp_nr_pages(page);
 	int order = compound_order(page);
 
-	VM_BUG_ON_PAGE(order && !PageTransHuge(page), page);
-
 	/* Do not migrate THP mapped by multiple processes */
 	if (PageTransHuge(page) && total_mapcount(page) > 1)
 		return 0;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-add-vm_normal_folio_pmd.patch
mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch
mm-memory-use-a-folio-in-do_numa_page.patch
mm-memory-make-numa_migrate_prep-to-take-a-folio.patch
mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch
sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

