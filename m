Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7A8E936E1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjJDUcY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244586AbjJDUWL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7BE10E5
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD54AC433C7;
        Wed,  4 Oct 2023 20:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450864;
        bh=tfh3MOU4BOaTpYQNwVrcpQ56XTemvd0TqdPRvAATW/o=;
        h=Date:To:From:Subject:From;
        b=mty3QjojH8QYgDTvi8KFtR9moMAGtUvfpC9vjlRJAehoHSny+Hma0rOL4AI7h7tgA
         ZFg9Q/vsx4bg6X5tYht1I1lRARTJmt7uzriapcsFMzsjcVJr29oOQ+6FoJnZVSWJwu
         tURSeSPRbh0nw8WaJIPdV/g9IQuECqGyZFGi9WE4=
Date:   Wed, 04 Oct 2023 13:21:02 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page.patch removed from -mm tree
Message-Id: <20231004202103.BD54AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: remove THP mapcount check in numamigrate_isolate_page()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2486,10 +2486,6 @@ static int numamigrate_isolate_page(pg_d
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

mm-memory-add-vm_normal_folio_pmd.patch
mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch
mm-memory-use-a-folio-in-do_numa_page.patch
mm-memory-make-numa_migrate_prep-to-take-a-folio.patch
mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch
sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

