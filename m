Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50080C28B2B
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239342AbiHQPqy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240182AbiHQPqq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:46:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358C280EAA
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:46:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B72886158A
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15431C433D7;
        Wed, 17 Aug 2022 15:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660751205;
        bh=6B8nNJmihQOpt6rE91bje3GTQJgKV7TPu4vzUNRD7bQ=;
        h=Date:To:From:Subject:From;
        b=LqqA/OW1bCBPWzvsYpBi/k/qY8d9F8S8dKYzahI5LkmP5NQ8AOHIrBw9Sqm0v3hxd
         /OMooVbk0U7sdDxfgglp6919v5R6ifnzDLUcFRcSMVarIUAWFYRjmR1/TaZFBYCLf3
         SgFbbyBw6e5ZoJkIALrJhxsZvMa7dWziIDf/W2R4=
Date:   Wed, 17 Aug 2022 08:46:44 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        osalvador@suse.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-remove-unnecessary-list_safe_reset_next.patch added to mm-unstable branch
Message-Id: <20220817154645.15431C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages(): remove unnecessary list_safe_reset_next()
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-remove-unnecessary-list_safe_reset_next.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-remove-unnecessary-list_safe_reset_next.patch

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
Subject: migrate_pages(): remove unnecessary list_safe_reset_next()
Date: Wed, 17 Aug 2022 16:14:02 +0800

Before commit b5bade978e9b ("mm: migrate: fix the return value of
migrate_pages()"), the tail pages of THP will be put in the "from"
list directly.  So one of the loop cursors (page2) needs to be reset,
as is done in try_split_thp() via list_safe_reset_next().  But after
the commit, the tail pages of THP will be put in a dedicated
list (thp_split_pages).  That is, the "from" list will not be changed
during splitting.  So, it's unnecessary to call list_safe_reset_next()
anymore.

This is a code cleanup, no functionality changes are expected.

Link: https://lkml.kernel.org/r/20220817081408.513338-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/migrate.c~migrate_pages-remove-unnecessary-list_safe_reset_next
+++ a/mm/migrate.c
@@ -1369,16 +1369,13 @@ out:
 	return rc;
 }
 
-static inline int try_split_thp(struct page *page, struct page **page2,
-				struct list_head *from)
+static inline int try_split_thp(struct page *page, struct list_head *split_pages)
 {
-	int rc = 0;
+	int rc;
 
 	lock_page(page);
-	rc = split_huge_page_to_list(page, from);
+	rc = split_huge_page_to_list(page, split_pages);
 	unlock_page(page);
-	if (!rc)
-		list_safe_reset_next(page, *page2, lru);
 
 	return rc;
 }
@@ -1482,7 +1479,7 @@ retry:
 				/* THP migration is unsupported */
 				if (is_thp) {
 					nr_thp_failed++;
-					if (!try_split_thp(page, &page2, &thp_split_pages)) {
+					if (!try_split_thp(page, &thp_split_pages)) {
 						nr_thp_split++;
 						goto retry;
 					}
@@ -1501,7 +1498,7 @@ retry:
 				 */
 				if (is_thp && !nosplit) {
 					nr_thp_failed++;
-					if (!try_split_thp(page, &page2, &thp_split_pages)) {
+					if (!try_split_thp(page, &thp_split_pages)) {
 						nr_thp_split++;
 						goto retry;
 					}
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

