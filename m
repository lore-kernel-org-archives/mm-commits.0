Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9184C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7634611C8
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346995AbhIIVHF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347262AbhIIVGw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 952F4611C9;
        Thu,  9 Sep 2021 21:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221542;
        bh=Iv2IjlcPp04WmV6/4Vi5R7xqZun6dVHzkK9uyVVpA7c=;
        h=Date:From:To:Subject:From;
        b=Jp+Y4pz+FNy3znB6LdQPrG5+vaNlsmHu2WyQSKp4hAJ0s7Oj8zTTgwfCd3jNJa65g
         wEW74a/pPDczFXOpDGBdN81l1K5vmlLzF3yn+yZ8HYecoMARwuNxKHKqXjeoXuqpi1
         hMUxAXVaY3SUUyFXzllle973QWzcV3gUT1y+g51o=
Date:   Thu, 09 Sep 2021 14:05:42 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, baolin.wang@linux.alibaba.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        willy@infradead.org
Subject:  [merged]
 mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch
 removed from -mm tree
Message-ID: <20210909210542.aYYwf_8YO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: introduce a local variable to get the number of pages
has been removed from the -mm tree.  Its filename was
     mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: introduce a local variable to get the number of pages

Use thp_nr_pages() instead of compound_nr() to get the number of pages for
THP page, meanwhile introducing a local variable 'nr_pages' to avoid
getting the number of pages repeatedly.

Link: https://lkml.kernel.org/r/a8e331ac04392ee230c79186330fb05e86a2aa77.1629447552.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages
+++ a/mm/migrate.c
@@ -2107,6 +2107,7 @@ out:
 static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 {
 	int page_lru;
+	int nr_pages = thp_nr_pages(page);
 
 	VM_BUG_ON_PAGE(compound_order(page) && !PageTransHuge(page), page);
 
@@ -2115,7 +2116,7 @@ static int numamigrate_isolate_page(pg_d
 		return 0;
 
 	/* Avoid migrating to a node that is nearly full */
-	if (!migrate_balanced_pgdat(pgdat, compound_nr(page)))
+	if (!migrate_balanced_pgdat(pgdat, nr_pages))
 		return 0;
 
 	if (isolate_lru_page(page))
@@ -2123,7 +2124,7 @@ static int numamigrate_isolate_page(pg_d
 
 	page_lru = page_is_file_lru(page);
 	mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON + page_lru,
-				thp_nr_pages(page));
+			    nr_pages);
 
 	/*
 	 * Isolating the page has taken another reference, so the
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

