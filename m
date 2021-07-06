Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119E1C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 014666192B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhGFTWZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231833AbhGFTWY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A49BF61C7F;
        Tue,  6 Jul 2021 19:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599186;
        bh=FQ7sVg3BcKQ1qiWA7dfvSK56FbfygEo6FCFqKlyu/Uw=;
        h=Date:From:To:Subject:From;
        b=YUzxb/RqnH99kuqcWCla1PAEmK/zsivlYnbgSsT03vBX9siSuwZ99Gjg2Bx9IfWJj
         M7EmPL2nsnP7L8gesWX3fLYaX7nbi+QpAXFPkWokuPBB/jyFWoSXo2M1r+5zb6hCmN
         vYXeu/NbMfJiieVra6m7bN76RYxYdLXECiad7skM=
Date:   Tue, 06 Jul 2021 12:19:45 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch removed from
 -mm tree
Message-ID: <20210706191945.tlDW87BA7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: check mapcount for THP instead of refcount
has been removed from the -mm tree.  Its filename was
     mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2073,6 +2073,10 @@ static int numamigrate_isolate_page(pg_d
 
 	VM_BUG_ON_PAGE(compound_order(page) && !PageTransHuge(page), page);
 
+	/* Do not migrate THP mapped by multiple processes */
+	if (PageTransHuge(page) && total_mapcount(page) > 1)
+		return 0;
+
 	/* Avoid migrating to a node that is nearly full */
 	if (!migrate_balanced_pgdat(pgdat, compound_nr(page)))
 		return 0;
@@ -2080,18 +2084,6 @@ static int numamigrate_isolate_page(pg_d
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


