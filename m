Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F99C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 924E861476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbhGAByW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238427AbhGAByW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30FFF61468;
        Thu,  1 Jul 2021 01:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104312;
        bh=u54k/CjEHa1zzENVGfXNHYSuUkrbAJJvnxYkwPqsebs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ub2pMqhHAxREIOFOcve9x2TlS0+tRN58UC3O24rzz9HivMmEEr1TySGzCCvBfB4Lk
         9+kbbiKDIuJrtXRdVE4zt+fAe48gYSw4R7hHee5APQzfrA7L3c43XtzfEEbKab6dMV
         t6AOnXSzGxRL424UqahDoWb/xC3RQ4joSFoVk9vQ=
Date:   Wed, 30 Jun 2021 18:51:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, borntraeger@de.ibm.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [patch 088/192] mm: migrate: check mapcount for THP
 instead of refcount
Message-ID: <20210701015151.3eYyc1NfJ%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
