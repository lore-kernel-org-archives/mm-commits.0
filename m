Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C97AE7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbjJDUWd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244644AbjJDUW0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1F31709
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F54C433C7;
        Wed,  4 Oct 2023 20:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450875;
        bh=wUy6PaYBfyykrROJyV5hL1ae331bwQvo1Wkymt2kc8g=;
        h=Date:To:From:Subject:From;
        b=peylvLBgZ2NKcFuvtGX2Hn5Ow1a8533izfgXFqIjS0oPrUlwWpBa7ZMqOky2/qYHO
         lumIiKdvWQL8154BBxmcRQJWm1KA9IJVp5K0XSKMUdzzm6Ltxxjlqnsj7JriVYd3v8
         vw1waLMSmFYwpvV6iIonB3DGU2EPU+dnfpXDqj5o=
Date:   Wed, 04 Oct 2023 13:21:14 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration.patch removed from -mm tree
Message-Id: <20231004202115.98F54C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: remove PageHead() check for HugeTLB in add_page_for_migration()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2096,10 +2096,8 @@ static int add_page_for_migration(struct
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

mm-memory-add-vm_normal_folio_pmd.patch
mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch
mm-memory-use-a-folio-in-do_numa_page.patch
mm-memory-make-numa_migrate_prep-to-take-a-folio.patch
mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch
sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

