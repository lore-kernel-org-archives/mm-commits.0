Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF55EE0207
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 20:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjIMUEz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbjIMUEx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 16:04:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D751BCA
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 13:04:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42C7C433C7;
        Wed, 13 Sep 2023 20:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694635489;
        bh=eXZRY4uhbSxxFhiuAAnajdAwrbnJtYfrzSQHcdv6SlM=;
        h=Date:To:From:Subject:From;
        b=nSc10WWBH0Ek5G7XO2Y6iWNC5rnHfKgpt8RL1IN16gO9fsr0MvlCKhoR4V9C8d7Ce
         sCQSVk/yOCM1BYwUd5J+IiSWBPpucgODqEKmPHkxRLL+D/2XfueHT2xdRYR7vMSp2X
         Vs2c+ooY1OLmevZjC9Rt8R4XW9WCLVZbmJOV9i4U=
Date:   Wed, 13 Sep 2023 13:04:48 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-isolated-variable-in-add_page_for_migration.patch added to mm-unstable branch
Message-Id: <20230913200448.E42C7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: remove isolated variable in add_page_for_migration()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-isolated-variable-in-add_page_for_migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-isolated-variable-in-add_page_for_migration.patch

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
Subject: mm: migrate: remove isolated variable in add_page_for_migration()
Date: Wed, 13 Sep 2023 17:51:31 +0800

Directly check the return of isolate_hugetlb() and folio_isolate_lru() to
remove isolated variable, also setup err = -EBUSY in advance before
isolation, and update err only when successfully queued for migration,
which could help us to unify and simplify code a bit.

Link: https://lkml.kernel.org/r/20230913095131.2426871-9-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-isolated-variable-in-add_page_for_migration
+++ a/mm/migrate.c
@@ -2059,7 +2059,6 @@ static int add_page_for_migration(struct
 	struct page *page;
 	struct folio *folio;
 	int err;
-	bool isolated;
 
 	mmap_read_lock(mm);
 	addr = (unsigned long)untagged_addr_remote(mm, p);
@@ -2092,15 +2091,13 @@ static int add_page_for_migration(struct
 	if (page_mapcount(page) > 1 && !migrate_all)
 		goto out_putfolio;
 
+	err = -EBUSY;
 	if (folio_test_hugetlb(folio)) {
-		isolated = isolate_hugetlb(folio, pagelist);
-		err = isolated ? 1 : -EBUSY;
+		if (isolate_hugetlb(folio, pagelist))
+			err = 1;
 	} else {
-		isolated = folio_isolate_lru(folio);
-		if (!isolated) {
-			err = -EBUSY;
+		if (!folio_isolate_lru(folio))
 			goto out_putfolio;
-		}
 
 		err = 1;
 		list_add_tail(&folio->lru, pagelist);
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

