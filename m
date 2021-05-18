Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAABC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 21:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D59EC6135F
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 21:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352348AbhERVJh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 17:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240342AbhERVJf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 17:09:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E792A611BF;
        Tue, 18 May 2021 21:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621372097;
        bh=qRqFYC/+bA5a1ZK/bx15jXvruynWisPLrCSa+ray3IY=;
        h=Date:From:To:Subject:From;
        b=rkZ0kp0Z35Vx4+WsGN10VRDWTtHC+P2+Ok3l+7W/st9JjgirUmuk1x7vOLF3kRtgU
         Yr5XEfTtzAlm9myzFXqjX6xw3/l1vZ87b6t1wtVTA64Lj1JyO7STVF2E04vZNt0Kcn
         dug8576pd6LhIWmz4J4uQv9EHGep8L5QGe5amOjY=
Date:   Tue, 18 May 2021 14:08:16 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  +
 mm-migrate-account-thp-numa-migration-counters-correctly.patch added to -mm
 tree
Message-ID: <20210518210816.qz-D5rPZA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: account THP NUMA migration counters correctly
has been added to the -mm tree.  Its filename is
     mm-migrate-account-thp-numa-migration-counters-correctly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-account-thp-numa-migration-counters-correctly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-account-thp-numa-migration-counters-correctly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: migrate: account THP NUMA migration counters correctly

Now both base page and THP NUMA migration is done via
migrate_misplaced_page(), keep the counters correctly for THP.

Link: https://lkml.kernel.org/r/20210518200801.7413-5-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~mm-migrate-account-thp-numa-migration-counters-correctly
+++ a/mm/migrate.c
@@ -2116,6 +2116,7 @@ int migrate_misplaced_page(struct page *
 	LIST_HEAD(migratepages);
 	new_page_t *new;
 	bool compound;
+	unsigned int nr_pages = thp_nr_pages(page);
 
 	/*
 	 * PTE mapped THP or HugeTLB page can't reach here so the page could
@@ -2154,13 +2155,13 @@ int migrate_misplaced_page(struct page *
 	if (nr_remaining) {
 		if (!list_empty(&migratepages)) {
 			list_del(&page->lru);
-			dec_node_page_state(page, NR_ISOLATED_ANON +
-					page_is_file_lru(page));
+			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
+					page_is_file_lru(page), -nr_pages);
 			putback_lru_page(page);
 		}
 		isolated = 0;
 	} else
-		count_vm_numa_event(NUMA_PAGE_MIGRATE);
+		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_pages);
 	BUG_ON(!list_empty(&migratepages));
 	return isolated;
 
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-thp-check-total_mapcount-instead-of-page_mapcount.patch
mm-memory-add-orig_pmd-to-struct-vm_fault.patch
mm-memory-make-numa_migrate_prep-non-static.patch
mm-thp-refactor-numa-fault-handling.patch
mm-migrate-account-thp-numa-migration-counters-correctly.patch
mm-migrate-dont-split-thp-for-misplaced-numa-page.patch
mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch
mm-thp-skip-make-pmd-prot_none-if-thp-migration-is-not-supported.patch

