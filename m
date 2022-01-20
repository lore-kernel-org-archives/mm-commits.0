Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13C6C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377821AbiATV1d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377870AbiATV1Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D8FC06161C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:27:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49F3F615EF
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E1CC340E0;
        Thu, 20 Jan 2022 21:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714044;
        bh=Aj6wjpnVCRTNjEkx6mWmrB0QGbfnDJKRAY5+gJG+nrs=;
        h=Date:From:To:Subject:From;
        b=i+VB6dKQ9JJWMnQA8dn7Jm+KJgm/A+mov9awsj4qBawxNAsw7pJVegZbFuyXeZapF
         /Vu9bAnEpzfU/qo8NO5V/7C2jXGP8+LM0UG6g64mdY0qV0f6tLKH/llIFzXKT7glL7
         ueylRgvu90UDtB5Zd7WylbvEXdCs76euNRllHLA0=
Date:   Thu, 20 Jan 2022 13:27:24 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-correct-the-hugetlb-migration-stats.patch removed from -mm tree
Message-ID: <20220120212724.Ba2EPZQD_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: correct the hugetlb migration stats
has been removed from the -mm tree.  Its filename was
     mm-migrate-correct-the-hugetlb-migration-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: correct the hugetlb migration stats

Correct the migration stats for hugetlb with using compound_nr() instead
of thp_nr_pages(), meanwhile change 'nr_failed_pages' to record the number
of normal pages failed to migrate, including THP and hugetlb, and
'nr_succeeded' will record the number of normal pages migrated
successfully.

[baolin.wang@linux.alibaba.com: fix docs, per Mike]
  Link: https://lkml.kernel.org/r/141bdfc6-f898-3cc3-f692-726c5f6cb74d@linux.alibaba.com
Link: https://lkml.kernel.org/r/71a4b6c22f208728fe8c78ad26375436c4ff9704.1636275127.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_migration.rst |   12 ++++++------
 mm/migrate.c                        |   17 ++++++++---------
 2 files changed, 14 insertions(+), 15 deletions(-)

--- a/Documentation/vm/page_migration.rst~mm-migrate-correct-the-hugetlb-migration-stats
+++ a/Documentation/vm/page_migration.rst
@@ -263,15 +263,15 @@ Monitoring Migration
 The following events (counters) can be used to monitor page migration.
 
 1. PGMIGRATE_SUCCESS: Normal page migration success. Each count means that a
-   page was migrated. If the page was a non-THP page, then this counter is
-   increased by one. If the page was a THP, then this counter is increased by
-   the number of THP subpages. For example, migration of a single 2MB THP that
-   has 4KB-size base pages (subpages) will cause this counter to increase by
-   512.
+   page was migrated. If the page was a non-THP and non-hugetlb page, then
+   this counter is increased by one. If the page was a THP or hugetlb, then
+   this counter is increased by the number of THP or hugetlb subpages.
+   For example, migration of a single 2MB THP that has 4KB-size base pages
+   (subpages) will cause this counter to increase by 512.
 
 2. PGMIGRATE_FAIL: Normal page migration failure. Same counting rules as for
    PGMIGRATE_SUCCESS, above: this will be increased by the number of subpages,
-   if it was a THP.
+   if it was a THP or hugetlb.
 
 3. THP_MIGRATION_SUCCESS: A THP was migrated without being split.
 
--- a/mm/migrate.c~mm-migrate-correct-the-hugetlb-migration-stats
+++ a/mm/migrate.c
@@ -1429,9 +1429,9 @@ static inline int try_split_thp(struct p
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
@@ -1474,7 +1474,7 @@ retry:
 			 * during migration.
 			 */
 			is_thp = PageTransHuge(page) && !PageHuge(page);
-			nr_subpages = thp_nr_pages(page);
+			nr_subpages = compound_nr(page);
 			cond_resched();
 
 			if (PageHuge(page))
@@ -1523,7 +1523,7 @@ retry:
 				/* Hugetlb migration is unsupported */
 				if (!no_subpage_counting)
 					nr_failed++;
-				nr_failed_pages++;
+				nr_failed_pages += nr_subpages;
 				break;
 			case -ENOMEM:
 				/*
@@ -1544,7 +1544,7 @@ retry:
 
 				if (!no_subpage_counting)
 					nr_failed++;
-				nr_failed_pages++;
+				nr_failed_pages += nr_subpages;
 				goto out;
 			case -EAGAIN:
 				if (is_thp) {
@@ -1554,12 +1554,11 @@ retry:
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
@@ -1576,7 +1575,7 @@ retry:
 
 				if (!no_subpage_counting)
 					nr_failed++;
-				nr_failed_pages++;
+				nr_failed_pages += nr_subpages;
 				break;
 			}
 		}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


