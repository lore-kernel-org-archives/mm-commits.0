Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51091C3F6B0
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240762AbiHQPrT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240411AbiHQPrB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:47:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5996E85FF1
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB23FB81E0D
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550BDC433C1;
        Wed, 17 Aug 2022 15:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660751215;
        bh=eP8xeo/TnQilWrXosxO85xgdsggQlNJJTBRvUTzI9nM=;
        h=Date:To:From:Subject:From;
        b=rDGrlSYIlP7+lvYgEpImIHYcFZOo7NSq5tgN6p/+NktNFiS1XOc9sC4tZwa0nPycO
         zEIbCyunBBXn1hlrHwscwfZ+8/0GLNBcDhzYpHu+Ahg5zSRSHPMto8u1SzcscOMKFI
         kU1UTT91TFayn2NgoLWDnLKcHoVQ7vWNFPCYlnac=
Date:   Wed, 17 Aug 2022 08:46:54 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        osalvador@suse.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-fix-failure-counting-for-retry.patch added to mm-unstable branch
Message-Id: <20220817154655.550BDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages(): fix failure counting for retry
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-fix-failure-counting-for-retry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-fix-failure-counting-for-retry.patch

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
Subject: migrate_pages(): fix failure counting for retry
Date: Wed, 17 Aug 2022 16:14:07 +0800

After 10 retries, we will give up and the remaining pages will be counted
as failure in nr_failed and nr_thp_failed.  We should count the failure in
nr_failed_pages too.  This is done in this patch.

Link: https://lkml.kernel.org/r/20220817081408.513338-8-ying.huang@intel.com
Fixes: 5984fabb6e82 ("mm: move_pages: report the number of non-attempted pages")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~migrate_pages-fix-failure-counting-for-retry
+++ a/mm/migrate.c
@@ -1413,6 +1413,7 @@ int migrate_pages(struct list_head *from
 	int thp_retry = 1;
 	int nr_failed = 0;
 	int nr_failed_pages = 0;
+	int nr_retry_pages = 0;
 	int nr_succeeded = 0;
 	int nr_thp_succeeded = 0;
 	int nr_thp_failed = 0;
@@ -1433,6 +1434,7 @@ thp_subpage_migration:
 	for (pass = 0; pass < 10 && (retry || thp_retry); pass++) {
 		retry = 0;
 		thp_retry = 0;
+		nr_retry_pages = 0;
 
 		list_for_each_entry_safe(page, page2, from, lru) {
 			/*
@@ -1506,7 +1508,7 @@ thp_subpage_migration:
 					nr_failed++;
 				}
 
-				nr_failed_pages += nr_subpages;
+				nr_failed_pages += nr_subpages + nr_retry_pages;
 				/*
 				 * There might be some subpages of fail-to-migrate THPs
 				 * left in thp_split_pages list. Move them back to migration
@@ -1522,6 +1524,7 @@ thp_subpage_migration:
 					thp_retry++;
 				else
 					retry++;
+				nr_retry_pages += nr_subpages;
 				break;
 			case MIGRATEPAGE_SUCCESS:
 				nr_succeeded += nr_subpages;
@@ -1548,6 +1551,7 @@ thp_subpage_migration:
 	if (!no_subpage_counting)
 		nr_failed += retry;
 	nr_thp_failed += thp_retry;
+	nr_failed_pages += nr_retry_pages;
 	/*
 	 * Try to migrate subpages of fail-to-migrate THPs, no nr_failed
 	 * counting in this round, since all subpages of a THP is counted
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

