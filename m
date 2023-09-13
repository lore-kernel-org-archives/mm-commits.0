Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5106CEE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 20:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjIMUEo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjIMUEo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 16:04:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BFB19BF
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 13:04:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D936BC433C8;
        Wed, 13 Sep 2023 20:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694635479;
        bh=5Np+qDkwV5SRCS2CP9D7wSHCpuxlhVQB2O6FhXmBITc=;
        h=Date:To:From:Subject:From;
        b=I47yenxtnZIgolvE6LuhxoOk+Fy3/yVIsBuBX7Xn5l+ulm0b3rpk7rVPBA8C2NUU/
         FUwdfjYhygjFE9Yn8kUDG55VAkktgRpUrncKo9aje47ZqqB8fOtrIr5DkYqx3ngakF
         HP+7BsSICSMRug+/ICuLL1/ZBDAJP1DyZ3HPCPvE=
Date:   Wed, 13 Sep 2023 13:04:39 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-use-__folio_test_movable.patch added to mm-unstable branch
Message-Id: <20230913200439.D936BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: use __folio_test_movable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-use-__folio_test_movable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-use-__folio_test_movable.patch

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
Subject: mm: migrate: use __folio_test_movable()
Date: Wed, 13 Sep 2023 17:51:28 +0800

Use __folio_test_movable(), no need to convert from folio to page again.

Link: https://lkml.kernel.org/r/20230913095131.2426871-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/migrate.c~mm-migrate-use-__folio_test_movable
+++ a/mm/migrate.c
@@ -157,8 +157,8 @@ void putback_movable_pages(struct list_h
 		list_del(&folio->lru);
 		/*
 		 * We isolated non-lru movable folio so here we can use
-		 * __PageMovable because LRU folio's mapping cannot have
-		 * PAGE_MAPPING_MOVABLE.
+		 * __folio_test_movable because LRU folio's mapping cannot
+		 * have PAGE_MAPPING_MOVABLE.
 		 */
 		if (unlikely(__folio_test_movable(folio))) {
 			VM_BUG_ON_FOLIO(!folio_test_isolated(folio), folio);
@@ -943,7 +943,7 @@ static int move_to_new_folio(struct foli
 				enum migrate_mode mode)
 {
 	int rc = -EAGAIN;
-	bool is_lru = !__PageMovable(&src->page);
+	bool is_lru = !__folio_test_movable(src);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
 	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
@@ -990,7 +990,7 @@ static int move_to_new_folio(struct foli
 	 * src is freed; but stats require that PageAnon be left as PageAnon.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		if (__PageMovable(&src->page)) {
+		if (__folio_test_movable(src)) {
 			VM_BUG_ON_FOLIO(!folio_test_isolated(src), src);
 
 			/*
@@ -1082,7 +1082,7 @@ static void migrate_folio_done(struct fo
 	/*
 	 * Compaction can migrate also non-LRU pages which are
 	 * not accounted to NR_ISOLATED_*. They can be recognized
-	 * as __PageMovable
+	 * as __folio_test_movable
 	 */
 	if (likely(!__folio_test_movable(src)))
 		mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
@@ -1103,7 +1103,7 @@ static int migrate_folio_unmap(new_folio
 	int rc = -EAGAIN;
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
-	bool is_lru = !__PageMovable(&src->page);
+	bool is_lru = !__folio_test_movable(src);
 	bool locked = false;
 	bool dst_locked = false;
 
@@ -1261,7 +1261,7 @@ static int migrate_folio_move(free_folio
 	int rc;
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
-	bool is_lru = !__PageMovable(&src->page);
+	bool is_lru = !__folio_test_movable(src);
 	struct list_head *prev;
 
 	__migrate_folio_extract(dst, &page_was_mapped, &anon_vma);
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

