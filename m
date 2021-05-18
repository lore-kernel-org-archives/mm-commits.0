Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F6EC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 21:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 860356124C
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 21:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352363AbhERVJl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 17:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352353AbhERVJj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 17:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9BC4611BF;
        Tue, 18 May 2021 21:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621372101;
        bh=TbwmTn/qDEFx0iqgwiRywVPbI0w+hgIENW8Unceu1Kw=;
        h=Date:From:To:Subject:From;
        b=z8Z7jEYG4aigbAbndx41/ZCMHNE9ntbmoouQ5/in6PoDgjN9/WfPBIT0ZmsKaCkYP
         bhNzagobGSBBCxgtuCqZGWyH/n6XPjAC00K4FxfXKqr2nZ+10BM5XPpcNBCXjS8WsR
         2/KzI7aeKBBAUYteqP60x2ETZ2ckgLNypsI4KbMw=
Date:   Tue, 18 May 2021 14:08:20 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  +
 mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch added to -mm
 tree
Message-ID: <20210518210820.w7qB2JEqF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: check mapcount for THP instead of refcount
has been added to the -mm tree.  Its filename is
     mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch

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
Subject: mm: migrate: check mapcount for THP instead of refcount

The generic migration path will check refcount, so no need check refcount
here.  But the old code actually prevents from migrating shared THP
(mapped by multiple processes), so bail out early if mapcount is > 1 to
keep the behavior.

Link: https://lkml.kernel.org/r/20210518200801.7413-7-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/mm/migrate.c~mm-migrate-check-mapcount-for-thp-instead-of-refcount
+++ a/mm/migrate.c
@@ -2072,6 +2072,10 @@ static int numamigrate_isolate_page(pg_d
 
 	VM_BUG_ON_PAGE(compound_order(page) && !PageTransHuge(page), page);
 
+	/* Do not migrate THP mapped by multiple processes */
+	if (PageTransHuge(page) && total_mapcount(page) > 1)
+		return 0;
+
 	/* Avoid migrating to a node that is nearly full */
 	if (!migrate_balanced_pgdat(pgdat, compound_nr(page)))
 		return 0;
@@ -2079,18 +2083,6 @@ static int numamigrate_isolate_page(pg_d
 	if (isolate_lru_page(page))
 		return 0;
 
-	/*
-	 * migrate_misplaced_transhuge_page() skips page migration's usual
-	 * check on page_count(), so we must do it here, now that the page
-	 * has been isolated: a GUP pin, or any other pin, prevents migration.
-	 * The expected page count is 3: 1 for page's mapcount and 1 for the
-	 * caller's pin and 1 for the reference taken by isolate_lru_page().
-	 */
-	if (PageTransHuge(page) && page_count(page) != 3) {
-		putback_lru_page(page);
-		return 0;
-	}
-
 	page_lru = page_is_file_lru(page);
 	mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON + page_lru,
 				thp_nr_pages(page));
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

