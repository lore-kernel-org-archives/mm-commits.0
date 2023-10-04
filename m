Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E4BE7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244571AbjJDUWi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244879AbjJDUW1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DE1171F
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFB7C433C9;
        Wed,  4 Oct 2023 20:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450884;
        bh=bz7qe+FN3hxULq4OOdi7dr2cdxEporwRHIyvLxGIaaw=;
        h=Date:To:From:Subject:From;
        b=WvQGjzrcbfQYXlvX/2IOpob6qMJbd9fukUouwim2fbtLEAIWuOPNsb91iDzTCJWZ8
         w2J8z90rkWkOnY4cX5rUvAUr0lDCtJShgdrLai5jzfKTgdRlcF1lYsyOB46mLgCKN7
         N7Elz1U/9PLfLO4a0PShmI6CNIl7mtknHLDFej14=
Date:   Wed, 04 Oct 2023 13:21:22 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-use-__folio_test_movable.patch removed from -mm tree
Message-Id: <20231004202124.1EFB7C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: use __folio_test_movable()
has been removed from the -mm tree.  Its filename was
     mm-migrate-use-__folio_test_movable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -946,7 +946,7 @@ static int move_to_new_folio(struct foli
 				enum migrate_mode mode)
 {
 	int rc = -EAGAIN;
-	bool is_lru = !__PageMovable(&src->page);
+	bool is_lru = !__folio_test_movable(src);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
 	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
@@ -993,7 +993,7 @@ static int move_to_new_folio(struct foli
 	 * src is freed; but stats require that PageAnon be left as PageAnon.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		if (__PageMovable(&src->page)) {
+		if (__folio_test_movable(src)) {
 			VM_BUG_ON_FOLIO(!folio_test_isolated(src), src);
 
 			/*
@@ -1085,7 +1085,7 @@ static void migrate_folio_done(struct fo
 	/*
 	 * Compaction can migrate also non-LRU pages which are
 	 * not accounted to NR_ISOLATED_*. They can be recognized
-	 * as __PageMovable
+	 * as __folio_test_movable
 	 */
 	if (likely(!__folio_test_movable(src)))
 		mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
@@ -1106,7 +1106,7 @@ static int migrate_folio_unmap(new_folio
 	int rc = -EAGAIN;
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
-	bool is_lru = !__PageMovable(&src->page);
+	bool is_lru = !__folio_test_movable(src);
 	bool locked = false;
 	bool dst_locked = false;
 
@@ -1264,7 +1264,7 @@ static int migrate_folio_move(free_folio
 	int rc;
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
-	bool is_lru = !__PageMovable(&src->page);
+	bool is_lru = !__folio_test_movable(src);
 	struct list_head *prev;
 
 	__migrate_folio_extract(dst, &page_was_mapped, &anon_vma);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-add-vm_normal_folio_pmd.patch
mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch
mm-memory-use-a-folio-in-do_numa_page.patch
mm-memory-make-numa_migrate_prep-to-take-a-folio.patch
mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch
sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

