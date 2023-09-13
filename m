Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC892EE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 20:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbjIMUEs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjIMUEr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 16:04:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D94119BF
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 13:04:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3BCC433C7;
        Wed, 13 Sep 2023 20:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694635483;
        bh=TJcPZb4O5aekFXV4BfYq9L5fQIvPUNNklXoe4uXmJ/0=;
        h=Date:To:From:Subject:From;
        b=xw2YUsm3y0bZW0Efi+fZ64rouS8YxWaZKHcgeWZFLG10vutDNVpOMbEXSaLauY99l
         lvvqBwjy3tpnIvQ2edHhROgihGrUFkZOtbNWrvwMHrKIvQonfMmeNO9nBzH5x90TzV
         oH+tGX2rs59V6gJaif1W0td9IXgsqcQFuDbZYC7U=
Date:   Wed, 13 Sep 2023 13:04:42 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-use-a-folio-in-add_page_for_migration.patch added to mm-unstable branch
Message-Id: <20230913200443.2A3BCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: use a folio in add_page_for_migration()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-use-a-folio-in-add_page_for_migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-use-a-folio-in-add_page_for_migration.patch

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
@@ -2057,6 +2057,7 @@ static int add_page_for_migration(struct
 	struct vm_area_struct *vma;
 	unsigned long addr;
 	struct page *page;
+	struct folio *folio;
 	int err;
 	bool isolated;
 
@@ -2079,45 +2080,42 @@ static int add_page_for_migration(struct
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

mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page.patch
mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page.patch
mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio.patch
mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio.patch
mm-migrate-use-__folio_test_movable.patch
mm-migrate-use-a-folio-in-add_page_for_migration.patch
mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration.patch
mm-migrate-remove-isolated-variable-in-add_page_for_migration.patch

