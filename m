Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87DFEC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiANVe4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiANVey (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:34:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A083C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 13:34:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0747B82A34
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FF7C36AEC;
        Fri, 14 Jan 2022 21:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642196091;
        bh=eTTRFoFu9VTgRtJc++kvRimgVdTUUMINZwMHocw0/uM=;
        h=Date:From:To:Subject:From;
        b=CQvohr5QHFAq3pwOnRINpHH0Btvw2UJTDk1DkkztvmwAPjl1fILn0CK2atuqb+102
         Tl6Dd1S7puT3nUuTWXRHPrjEHCApzZUmL4Vkq1sU8wJ1Ao+cYkHlQt+DfSXx5BtiJI
         UXHoriZC9G0T2cSW62af5toKPepKHbHNW2lKbPbE=
Date:   Fri, 14 Jan 2022 13:34:50 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com, ziy@nvidia.com
Subject:  [folded-merged]
 mm-migrate-correct-the-hugetlb-migration-stats-fix.patch removed from -mm
 tree
Message-ID: <20220114213450.jJsOOCIHv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-correct-the-hugetlb-migration-stats-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-correct-the-hugetlb-migration-stats-fix.patch

This patch was dropped because it was folded into mm-migrate-correct-the-hugetlb-migration-stats.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-migrate-correct-the-hugetlb-migration-stats-fix

fix docs, per Mike

Link: https://lkml.kernel.org/r/141bdfc6-f898-3cc3-f692-726c5f6cb74d@linux.alibaba.com
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_migration.rst |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/vm/page_migration.rst~mm-migrate-correct-the-hugetlb-migration-stats-fix
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
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-fix-the-return-value-of-migrate_pages.patch
mm-migrate-correct-the-hugetlb-migration-stats.patch
mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch
mm-migrate-support-multiple-target-nodes-demotion.patch
mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch
mm-damon-add-access-checking-for-hugetlb-pages.patch
mm-damon-add-access-checking-for-hugetlb-pages-fix.patch
mm-damon-add-access-checking-for-hugetlb-pages-v3.patch

