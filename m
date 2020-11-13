Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75075C6369E
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 23:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 405D72225E
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 23:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1KzG4/ky"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgKMXmm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 18:42:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgKMXmm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 18:42:42 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D971F22263;
        Fri, 13 Nov 2020 23:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605310961;
        bh=dqKbc50NG4ZwSm7W9EMfzFijK5Jn2Pgot7tIgxOhkzs=;
        h=Date:From:To:Subject:From;
        b=1KzG4/kyF3PZ0lCG7QWXgBT9VZkSgivoFu1jmIOk1leuK2OarfmE0PLLrNtPusaqQ
         udTTEzQyFa+byGimYEFaMCf5V1cVKz7AyZfkV1+JXldE3yffZZCfRFTgZillw3rkuX
         hOOOc2zFLcGp/jEc+RLUv7LMLSDVD6FUrMW5/aaM=
Date:   Fri, 13 Nov 2020 15:42:40 -0800
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  +
 mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch added to -mm
 tree
Message-ID: <20201113234240.Mm4g_F3Z9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: return -ENOSYS if THP migration is unsupported
has been added to the -mm tree.  Its filename is
     mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch

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
Subject: mm: migrate: return -ENOSYS if THP migration is unsupported

In the current implementation unmap_and_move() would return -ENOMEM if THP
migration is unsupported, then the THP will be split.  If split is failed
just exit without trying to migrate other pages.  It doesn't make too much
sense since there may be enough free memory to migrate other pages and
there may be a lot base pages on the list.

Return -ENOSYS to make consistent with hugetlb.  And if THP split is
failed just skip and try other pages on the list.

Just skip the whole list and exit when free memory is really low.

Link: https://lkml.kernel.org/r/20201113205359.556831-6-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   62 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 16 deletions(-)

--- a/mm/migrate.c~mm-migrate-return-enosys-if-thp-migration-is-unsupported
+++ a/mm/migrate.c
@@ -1171,7 +1171,7 @@ static int unmap_and_move(new_page_t get
 	struct page *newpage = NULL;
 
 	if (!thp_migration_supported() && PageTransHuge(page))
-		return -ENOMEM;
+		return -ENOSYS;
 
 	if (page_count(page) == 1) {
 		/* page was freed from under us. So we are done. */
@@ -1378,6 +1378,20 @@ out:
 	return rc;
 }
 
+static inline int try_split_thp(struct page *page, struct page **page2,
+				struct list_head *from)
+{
+	int rc = 0;
+
+	lock_page(page);
+	rc = split_huge_page_to_list(page, from);
+	unlock_page(page);
+	if (!rc)
+		list_safe_reset_next(page, *page2, lru);
+
+	return rc;
+}
+
 /*
  * migrate_pages - migrate the pages specified in a list, to the free pages
  *		   supplied as the target for the page migration
@@ -1455,24 +1469,40 @@ retry:
 			 *		     from list
 			 */
 			switch(rc) {
+			/*
+			 * THP migration might be unsupported or the
+			 * allocation could've failed so we should
+			 * retry on the same page with the THP split
+			 * to base pages.
+			 *
+			 * Head page is retried immediately and tail
+			 * pages are added to the tail of the list so
+			 * we encounter them after the rest of the list
+			 * is processed.
+			 */
+			case -ENOSYS:
+				/* THP migration is unsupported */
+				if (is_thp) {
+					if (!try_split_thp(page, &page2, from)) {
+						nr_thp_split++;
+						goto retry;
+					}
+
+					nr_thp_failed++;
+					nr_failed += nr_subpages;
+					break;
+				}
+
+				/* Hugetlb migration is unsupported */
+				nr_failed++;
+				break;
 			case -ENOMEM:
 				/*
-				 * THP migration might be unsupported or the
-				 * allocation could've failed so we should
-				 * retry on the same page with the THP split
-				 * to base pages.
-				 *
-				 * Head page is retried immediately and tail
-				 * pages are added to the tail of the list so
-				 * we encounter them after the rest of the list
-				 * is processed.
+				 * When memory is low, don't bother to try to migrate
+				 * other pages, just exit.
 				 */
 				if (is_thp) {
-					lock_page(page);
-					rc = split_huge_page_to_list(page, from);
-					unlock_page(page);
-					if (!rc) {
-						list_safe_reset_next(page, page2, lru);
+					if (!try_split_thp(page, &page2, from)) {
 						nr_thp_split++;
 						goto retry;
 					}
@@ -1500,7 +1530,7 @@ retry:
 				break;
 			default:
 				/*
-				 * Permanent failure (-EBUSY, -ENOSYS, etc.):
+				 * Permanent failure (-EBUSY, etc.):
 				 * unlike -EAGAIN case, the failed page is
 				 * removed from migration page list and not
 				 * retried in the next outer loop.
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-truncate_complete_page-is-not-existed-anymore.patch
mm-migrate-simplify-the-logic-for-handling-permanent-failure.patch
mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch
mm-migrate-clean-up-migrate_prep_local.patch
mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch

