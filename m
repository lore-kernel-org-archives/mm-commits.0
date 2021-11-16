Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107F5C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E19B861A3A
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240603AbhKPEUm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:20:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242933AbhKPESn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:18:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D500D61AE3;
        Tue, 16 Nov 2021 04:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637036141;
        bh=Kpn1AJi3/uqjRdh2mRwEGFvaPfoOw2GoA7/2nZe0a5Q=;
        h=Date:From:To:Subject:From;
        b=atvYF9Yl9GDInyIIQaKo8otn6qPz88/yDaX491bDxawRjxV5PklL9Rkso58/M5Uj3
         6XhffuGnzW4EICu74glozTm9JBI4FMisxe44deqmDkAfljTQTzkyIsteNTMRrDfqnl
         FKZtukOZBPlsjoZ6x/yy5+7HkZNf71pi9+GJFztE=
Date:   Mon, 15 Nov 2021 20:15:40 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, ziy@nvidia.com
Subject:  + mm-migrate-correct-the-hugetlb-migration-stats.patch
 added to -mm tree
Message-ID: <20211116041540.CIltQRCL9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: correct the hugetlb migration stats
has been added to the -mm tree.  Its filename is
     mm-migrate-correct-the-hugetlb-migration-stats.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-correct-the-hugetlb-migration-stats.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-correct-the-hugetlb-migration-stats.patch

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
Subject: mm: migrate: correct the hugetlb migration stats

Correct the migration stats for hugetlb with using compound_nr() instead
of thp_nr_pages(), meanwhile change 'nr_failed_pages' to record the number
of normal pages failed to migrate, including THP and hugetlb, and
'nr_succeeded' will record the number of normal pages migrated
successfully.

Link: https://lkml.kernel.org/r/71a4b6c22f208728fe8c78ad26375436c4ff9704.1636275127.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/migrate.c~mm-migrate-correct-the-hugetlb-migration-stats
+++ a/mm/migrate.c
@@ -1430,9 +1430,9 @@ static inline int try_split_thp(struct p
  * It is caller's responsibility to call putback_movable_pages() to return pages
  * to the LRU or free list only if ret != 0.
  *
- * Returns the number of {normal page, THP} that were not migrated, or an error code.
- * The number of THP splits will be considered as the number of non-migrated THP,
- * no matter how many subpages of the THP are migrated successfully.
+ * Returns the number of {normal page, THP, hugetlb} that were not migrated, or
+ * an error code. The number of THP splits will be considered as the number of
+ * non-migrated THP, no matter how many subpages of the THP are migrated successfully.
  */
 int migrate_pages(struct list_head *from, new_page_t get_new_page,
 		free_page_t put_new_page, unsigned long private,
@@ -1475,7 +1475,7 @@ retry:
 			 * during migration.
 			 */
 			is_thp = PageTransHuge(page) && !PageHuge(page);
-			nr_subpages = thp_nr_pages(page);
+			nr_subpages = compound_nr(page);
 			cond_resched();
 
 			if (PageHuge(page))
@@ -1524,7 +1524,7 @@ retry:
 				/* Hugetlb migration is unsupported */
 				if (!no_subpage_counting)
 					nr_failed++;
-				nr_failed_pages++;
+				nr_failed_pages += nr_subpages;
 				break;
 			case -ENOMEM:
 				/*
@@ -1545,7 +1545,7 @@ retry:
 
 				if (!no_subpage_counting)
 					nr_failed++;
-				nr_failed_pages++;
+				nr_failed_pages += nr_subpages;
 				goto out;
 			case -EAGAIN:
 				if (is_thp) {
@@ -1555,12 +1555,11 @@ retry:
 				retry++;
 				break;
 			case MIGRATEPAGE_SUCCESS:
+				nr_succeeded += nr_subpages;
 				if (is_thp) {
 					nr_thp_succeeded++;
-					nr_succeeded += nr_subpages;
 					break;
 				}
-				nr_succeeded++;
 				break;
 			default:
 				/*
@@ -1577,7 +1576,7 @@ retry:
 
 				if (!no_subpage_counting)
 					nr_failed++;
-				nr_failed_pages++;
+				nr_failed_pages += nr_subpages;
 				break;
 			}
 		}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-fix-the-return-value-of-migrate_pages.patch
mm-migrate-correct-the-hugetlb-migration-stats.patch
mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch
mm-migrate-support-multiple-target-nodes-demotion.patch

