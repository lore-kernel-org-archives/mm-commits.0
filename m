Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDC8E936E4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243717AbjJDUc1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244746AbjJDUWZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CD11702
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832E3C433C8;
        Wed,  4 Oct 2023 20:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450873;
        bh=vhHKrlIgrBsb+5XbXO8NwP+26VwPwe4NYZivXeBlNg4=;
        h=Date:To:From:Subject:From;
        b=OgvBAXg9X+QviOlu4KznzNjyuBQWg7OnlMgHYgsxuQb/uce08P8qarbRQrRFOKB69
         3oAjUcSNFyk0RqxFtWNi+guYUVpZxBAwFBXrMEVelYmQ+qEIZkrLoMl+qc37MnxTza
         OPw5U3CxJpprDYXM8t8OjhVTvm8bIJn/ZW3ocDGs=
Date:   Wed, 04 Oct 2023 13:21:11 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-use-a-folio-in-add_page_for_migration.patch removed from -mm tree
Message-Id: <20231004202113.832E3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: use a folio in add_page_for_migration()
has been removed from the -mm tree.  Its filename was
     mm-migrate-use-a-folio-in-add_page_for_migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate: use a folio in add_page_for_migration()
Date: Wed, 13 Sep 2023 17:51:29 +0800

Use a folio in add_page_for_migration() to save compound_head() calls.

Link: https://lkml.kernel.org/r/20230913095131.2426871-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

--- a/mm/migrate.c~mm-migrate-use-a-folio-in-add_page_for_migration
+++ a/mm/migrate.c
@@ -2060,6 +2060,7 @@ static int add_page_for_migration(struct
 	struct vm_area_struct *vma;
 	unsigned long addr;
 	struct page *page;
+	struct folio *folio;
 	int err;
 	bool isolated;
 
@@ -2082,45 +2083,42 @@ static int add_page_for_migration(struct
 	if (!page)
 		goto out;
 
-	if (is_zone_device_page(page))
-		goto out_putpage;
+	folio = page_folio(page);
+	if (folio_is_zone_device(folio))
+		goto out_putfolio;
 
 	err = 0;
-	if (page_to_nid(page) == node)
-		goto out_putpage;
+	if (folio_nid(folio) == node)
+		goto out_putfolio;
 
 	err = -EACCES;
 	if (page_mapcount(page) > 1 && !migrate_all)
-		goto out_putpage;
+		goto out_putfolio;
 
-	if (PageHuge(page)) {
+	if (folio_test_hugetlb(folio)) {
 		if (PageHead(page)) {
-			isolated = isolate_hugetlb(page_folio(page), pagelist);
+			isolated = isolate_hugetlb(folio, pagelist);
 			err = isolated ? 1 : -EBUSY;
 		}
 	} else {
-		struct page *head;
-
-		head = compound_head(page);
-		isolated = isolate_lru_page(head);
+		isolated = folio_isolate_lru(folio);
 		if (!isolated) {
 			err = -EBUSY;
-			goto out_putpage;
+			goto out_putfolio;
 		}
 
 		err = 1;
-		list_add_tail(&head->lru, pagelist);
-		mod_node_page_state(page_pgdat(head),
-			NR_ISOLATED_ANON + page_is_file_lru(head),
-			thp_nr_pages(head));
+		list_add_tail(&folio->lru, pagelist);
+		node_stat_mod_folio(folio,
+			NR_ISOLATED_ANON + folio_is_file_lru(folio),
+			folio_nr_pages(folio));
 	}
-out_putpage:
+out_putfolio:
 	/*
-	 * Either remove the duplicate refcount from
-	 * isolate_lru_page() or drop the page ref if it was
-	 * not isolated.
+	 * Either remove the duplicate refcount from folio_isolate_lru()
+	 * or drop the folio ref if it was not isolated.
 	 */
-	put_page(page);
+	folio_put(folio);
 out:
 	mmap_read_unlock(mm);
 	return err;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-add-vm_normal_folio_pmd.patch
mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch
mm-memory-use-a-folio-in-do_numa_page.patch
mm-memory-make-numa_migrate_prep-to-take-a-folio.patch
mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch
sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

