Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AA6C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhK1A5n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 19:57:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50466 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356692AbhK1Azm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:55:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8181060F57
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB117C53FBF;
        Sun, 28 Nov 2021 00:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638060746;
        bh=7FvH94cO/c6gTB5SQbheHW6+Sco/lyt05btVEe+uIlY=;
        h=Date:From:To:Subject:From;
        b=eMjs6+/kdOs9ZECizzsSQYwoqYAI+FkaTJfaVap/e99RJQrHNLK02qffyHt5B9iS7
         KGmg4/lMlcdenY/V9TYQq/g+EqSk/K5TzY/lergo6jPQBAz6KeiUmrxTrFdkE78dcg
         inIcMyn/yAun8kQKWHUTfp1OdmDG7/DiWsmasNwE=
Date:   Sat, 27 Nov 2021 16:52:26 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com, ziy@nvidia.com
Subject:  +
 mm-migrate-correct-the-hugetlb-migration-stats-fix.patch added to -mm tree
Message-ID: <20211128005226.ojuierGy0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-correct-the-hugetlb-migration-stats-fix
has been added to the -mm tree.  Its filename is
     mm-migrate-correct-the-hugetlb-migration-stats-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-correct-the-hugetlb-migration-stats-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-correct-the-hugetlb-migration-stats-fix.patch

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
mm-migrate-correct-the-hugetlb-migration-stats-fix.patch
mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch
mm-migrate-support-multiple-target-nodes-demotion.patch
mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch

