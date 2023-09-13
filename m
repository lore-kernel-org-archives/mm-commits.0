Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1ABEE0207
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 20:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbjIMUEv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjIMUEu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 16:04:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0EA1BC6
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 13:04:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DD8C433C8;
        Wed, 13 Sep 2023 20:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694635486;
        bh=7WFXFuAkiMV9Unk5cozkmNeE8VJMsdq5Lp4B528clvM=;
        h=Date:To:From:Subject:From;
        b=iNmRy2Hy4pl4ayUYQad5D9l8UlI/97suoLElrE8BM56koOtaUXklMmKQX1MSR98Pt
         LBdnwV1C9rOnJ9Vu2zfmFaLuPTxsNY/3LwSuz5cGeYf8BQZslK0BjvgVgWV8cPKizR
         KcO+jNZ1LhqYOraLs+QFttC6wzsAjLk83yiPcUsY=
Date:   Wed, 13 Sep 2023 13:04:45 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration.patch added to mm-unstable branch
Message-Id: <20230913200446.39DD8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: remove PageHead() check for HugeTLB in add_page_for_migration()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration.patch

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
Subject: mm: migrate: remove PageHead() check for HugeTLB in add_page_for_migration()
Date: Wed, 13 Sep 2023 17:51:30 +0800

There is some different between hugeTLB and THP behave when passed the
address of a tail page, for THP, it will migrate the entire THP page, but
for HugeTLB, it will return -EACCES, or -ENOENT before commit e66f17ff7177
("mm/hugetlb: take page table lock in follow_huge_pmd()"),

  -EACCES The page is mapped by multiple processes and can be moved
	  only if MPOL_MF_MOVE_ALL is specified.
  -ENOENT The page is not present.

But when check manual[1], both of the two errnos are not suitable, it is
better to keep the same behave between hugetlb and THP when passed the
address of a tail page, so let's just remove the PageHead() check for
HugeTLB.

[1] https://man7.org/linux/man-pages/man2/move_pages.2.html

Link: https://lkml.kernel.org/r/20230913095131.2426871-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration
+++ a/mm/migrate.c
@@ -2093,10 +2093,8 @@ static int add_page_for_migration(struct
 		goto out_putfolio;
 
 	if (folio_test_hugetlb(folio)) {
-		if (PageHead(page)) {
-			isolated = isolate_hugetlb(folio, pagelist);
-			err = isolated ? 1 : -EBUSY;
-		}
+		isolated = isolate_hugetlb(folio, pagelist);
+		err = isolated ? 1 : -EBUSY;
 	} else {
 		isolated = folio_isolate_lru(folio);
 		if (!isolated) {
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

