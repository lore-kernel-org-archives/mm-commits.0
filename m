Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424B6C3526E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AB6122D73
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgLOX7r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729750AbgLOX0G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:06 -0500
Date:   Tue, 15 Dec 2020 15:23:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074614;
        bh=XX2egl9XCSA5Bun1ZM+rvUCOBoNW0tEuHmlyMPMGmbo=;
        h=From:To:Subject:From;
        b=yHo5viRpqYfpWOvbUk2+9iZmYFiulb4K4kPEjYTBp4ycqQzhKLYAafA00P0klAYCA
         2di95smyZYSsWbo8lePbSG16+YKNFQ4QHurySvRBXms5GUUM0nokOQym1hABBWUmtT
         Ds6x2PY/EZAzECPu5KCwHghHTHs6GXSWAlOMkcdA=
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch removed from
 -mm tree
Message-ID: <20201215232334.QVYhHXhXL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: return -ENOSYS if THP migration is unsupported
has been removed from the -mm tree.  Its filename was
     mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


