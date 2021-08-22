Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A3DC432BE
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 20:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F24E61357
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 20:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhHVUYd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Aug 2021 16:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhHVUYc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Aug 2021 16:24:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84CAA6127B;
        Sun, 22 Aug 2021 20:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629663831;
        bh=XboiZGKy0Iv0P1xmXKXuuXxNLIBbKikRuioFUSQeLp4=;
        h=Date:From:To:Subject:From;
        b=mt71/1XIvKTVXglrenMql9b3wvHSu2PPsDMOk+yoNwJhDVaswIRp9Byi+wvKfvzRs
         zgACNpfUmc/c9B+EIHVDngbUCA2THt6ZIaKPKJnYHFvFRDpF0gxtSjsyOM6P4D2sUw
         t0dlFLBsxC1YG1TH+hh/MhbgZfSQsGroru+xD3G0=
Date:   Sun, 22 Aug 2021 13:23:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com
Subject:  +
 mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch added
 to -mm tree
Message-ID: <20210822202351.3CI34%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: introduce a local variable to get the number of pages
has been added to the -mm tree.  Its filename is
     mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2100,6 +2100,7 @@ out:
 static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 {
 	int page_lru;
+	int nr_pages = thp_nr_pages(page);
 
 	VM_BUG_ON_PAGE(compound_order(page) && !PageTransHuge(page), page);
 
@@ -2108,7 +2109,7 @@ static int numamigrate_isolate_page(pg_d
 		return 0;
 
 	/* Avoid migrating to a node that is nearly full */
-	if (!migrate_balanced_pgdat(pgdat, compound_nr(page)))
+	if (!migrate_balanced_pgdat(pgdat, nr_pages))
 		return 0;
 
 	if (isolate_lru_page(page))
@@ -2116,7 +2117,7 @@ static int numamigrate_isolate_page(pg_d
 
 	page_lru = page_is_file_lru(page);
 	mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON + page_lru,
-				thp_nr_pages(page));
+			    nr_pages);
 
 	/*
 	 * Isolating the page has taken another reference, so the
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memcontrol-set-the-correct-memcg-swappiness-restriction.patch
mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch
mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch
mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch
mm-migrate-fix-the-incorrect-function-name-in-comments.patch
mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch

