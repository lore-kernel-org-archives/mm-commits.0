Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F7FC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbiHQPq4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240333AbiHQPqx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:46:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB042832D4
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:46:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 831AEB81E06
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE1EC433C1;
        Wed, 17 Aug 2022 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660751209;
        bh=HgjkFaThvC0NyEVroe5zQ9YrmFEVXSrMLCvBSvb9HTw=;
        h=Date:To:From:Subject:From;
        b=NE5Vb2B1SB43L/h1QQGxhaAeKaMFRalbCfmvV5hVGK+J7tLuPiU8PdBVgV+P5y3iN
         piSj+vLrWBvWknlKKAPxYDjxQWmROVs3VSyaTgCv6ZMp4zytWwiAcZeFXL9dePkedZ
         gUEnyhnkxaWZjMR+70N1C41AIkfMdOYbc07c9piA=
Date:   Wed, 17 Aug 2022 08:46:48 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        osalvador@suse.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-fix-failure-counting-for-thp-subpages-retrying.patch added to mm-unstable branch
Message-Id: <20220817154649.3BE1EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages(): fix failure counting for THP subpages retrying
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-fix-failure-counting-for-thp-subpages-retrying.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-fix-failure-counting-for-thp-subpages-retrying.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages(): fix failure counting for THP subpages retrying
Date: Wed, 17 Aug 2022 16:14:04 +0800

If THP is failed to be migrated for -ENOSYS and -ENOMEM, the THP will be
split into thp_split_pages, and after other pages are migrated, pages in
thp_split_pages will be migrated with no_subpage_counting == true, because
its failure have been counted already.  If some pages in thp_split_pages
are retried during migration, we should not count their failure if
no_subpage_counting == true too.  This is done this patch to fix the
failure counting for THP subpages retrying.

Link: https://lkml.kernel.org/r/20220817081408.513338-5-ying.huang@intel.com
Fixes: 5984fabb6e82 ("mm: move_pages: report the number of non-attempted pages")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~migrate_pages-fix-failure-counting-for-thp-subpages-retrying
+++ a/mm/migrate.c
@@ -1545,7 +1545,8 @@ retry:
 			}
 		}
 	}
-	nr_failed += retry;
+	if (!no_subpage_counting)
+		nr_failed += retry;
 	nr_thp_failed += thp_retry;
 	/*
 	 * Try to migrate subpages of fail-to-migrate THPs, no nr_failed
_

Patches currently in -mm which might be from ying.huang@intel.com are

memory-tiering-hot-page-selection-with-hint-page-fault-latency.patch
memory-tiering-rate-limit-numa-migration-throughput.patch
memory-tiering-adjust-hot-threshold-automatically.patch
migrate-fix-syscall-move_pages-return-value-for-failure.patch
migrate_pages-remove-unnecessary-list_safe_reset_next.patch
migrate_pages-fix-thp-failure-counting-for-enomem.patch
migrate_pages-fix-failure-counting-for-thp-subpages-retrying.patch
migrate_pages-fix-failure-counting-for-thp-on-enosys.patch
migrate_pages-fix-failure-counting-for-thp-splitting.patch
migrate_pages-fix-failure-counting-for-retry.patch

