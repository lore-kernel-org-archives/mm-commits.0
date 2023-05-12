Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B263BC77B7C
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 23:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238921AbjELXer (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 19:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjELXeq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 19:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F66810C
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 16:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B00A7658FB
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 23:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D48C433EF;
        Fri, 12 May 2023 23:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683934484;
        bh=HE8YJA2llAbEfXz4qagSGy6vhKPh4TV1j0NAWge3PZI=;
        h=Date:To:From:Subject:From;
        b=gfnvK5hfAlqrcnPmmoJhzguDnLtJ5sS+aWKPwxa8ZMW/4dGq7wrSYamXnim6MQQGV
         6YjmSxVdIq3PVC2VmvTgRQNMBjzpz/4tKizhh+oyx80DBAn7Am5TIduq1E4Zq/M2cU
         hs0c0h2f8tS9kYR3TBG1ElQcmgtKKXwZTcytpxzs=
Date:   Fri, 12 May 2023 16:34:43 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        shy828301@gmail.com, osalvador@suse.de,
        baolin.wang@linux.alibaba.com, apopple@nvidia.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages_batch-simplify-retrying-and-failure-counting-of-large-folios.patch added to mm-unstable branch
Message-Id: <20230512233444.07D48C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages_batch: simplify retrying and failure counting of large folios
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages_batch-simplify-retrying-and-failure-counting-of-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages_batch-simplify-retrying-and-failure-counting-of-large-folios.patch

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
Subject: migrate_pages_batch: simplify retrying and failure counting of large folios
Date: Wed, 10 May 2023 11:18:29 +0800

After recent changes to the retrying and failure counting in
migrate_pages_batch(), it was found that it's unnecessary to count
retrying and failure for normal, large, and THP folios separately. 
Because we don't use retrying and failure number of large folios directly.
So, in this patch, we simplified retrying and failure counting of large
folios via counting retrying and failure of normal and large folios
together.  This results in the reduced line number.

Previously, in migrate_pages_batch we need to track whether the source
folio is large/THP before splitting.  So is_large is used to cache
folio_test_large() result.  Now, we don't need that variable any more
because we don't count retrying and failure of large folios (only counting
that of THP folios).  So, in this patch, is_large is removed to simplify
the code.

This is just code cleanup, no functionality changes are expected.

Link: https://lkml.kernel.org/r/20230510031829.11513-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |  112 +++++++++++++++----------------------------------
 1 file changed, 36 insertions(+), 76 deletions(-)

--- a/mm/migrate.c~migrate_pages_batch-simplify-retrying-and-failure-counting-of-large-folios
+++ a/mm/migrate.c
@@ -1617,13 +1617,10 @@ static int migrate_pages_batch(struct li
 		int nr_pass)
 {
 	int retry = 1;
-	int large_retry = 1;
 	int thp_retry = 1;
 	int nr_failed = 0;
 	int nr_retry_pages = 0;
-	int nr_large_failed = 0;
 	int pass = 0;
-	bool is_large = false;
 	bool is_thp = false;
 	struct folio *folio, *folio2, *dst = NULL, *dst2;
 	int rc, rc_saved = 0, nr_pages;
@@ -1634,20 +1631,13 @@ static int migrate_pages_batch(struct li
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
 			!list_empty(from) && !list_is_singular(from));
 
-	for (pass = 0; pass < nr_pass && (retry || large_retry); pass++) {
+	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
-		large_retry = 0;
 		thp_retry = 0;
 		nr_retry_pages = 0;
 
 		list_for_each_entry_safe(folio, folio2, from, lru) {
-			/*
-			 * Large folio statistics is based on the source large
-			 * folio. Capture required information that might get
-			 * lost during migration.
-			 */
-			is_large = folio_test_large(folio);
-			is_thp = is_large && folio_test_pmd_mappable(folio);
+			is_thp = folio_test_large(folio) && folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
 
 			cond_resched();
@@ -1663,7 +1653,7 @@ static int migrate_pages_batch(struct li
 			 * list is processed.
 			 */
 			if (!thp_migration_supported() && is_thp) {
-				nr_large_failed++;
+				nr_failed++;
 				stats->nr_thp_failed++;
 				if (!try_split_folio(folio, split_folios)) {
 					stats->nr_thp_split++;
@@ -1691,38 +1681,33 @@ static int migrate_pages_batch(struct li
 				 * When memory is low, don't bother to try to migrate
 				 * other folios, move unmapped folios, then exit.
 				 */
-				if (is_large) {
-					nr_large_failed++;
-					stats->nr_thp_failed += is_thp;
-					/* Large folio NUMA faulting doesn't split to retry. */
-					if (!nosplit) {
-						int ret = try_split_folio(folio, split_folios);
-
-						if (!ret) {
-							stats->nr_thp_split += is_thp;
-							break;
-						} else if (reason == MR_LONGTERM_PIN &&
-							   ret == -EAGAIN) {
-							/*
-							 * Try again to split large folio to
-							 * mitigate the failure of longterm pinning.
-							 */
-							large_retry++;
-							thp_retry += is_thp;
-							nr_retry_pages += nr_pages;
-							/* Undo duplicated failure counting. */
-							nr_large_failed--;
-							stats->nr_thp_failed -= is_thp;
-							break;
-						}
+				nr_failed++;
+				stats->nr_thp_failed += is_thp;
+				/* Large folio NUMA faulting doesn't split to retry. */
+				if (folio_test_large(folio) && !nosplit) {
+					int ret = try_split_folio(folio, split_folios);
+
+					if (!ret) {
+						stats->nr_thp_split += is_thp;
+						break;
+					} else if (reason == MR_LONGTERM_PIN &&
+						   ret == -EAGAIN) {
+						/*
+						 * Try again to split large folio to
+						 * mitigate the failure of longterm pinning.
+						 */
+						retry++;
+						thp_retry += is_thp;
+						nr_retry_pages += nr_pages;
+						/* Undo duplicated failure counting. */
+						nr_failed--;
+						stats->nr_thp_failed -= is_thp;
+						break;
 					}
-				} else {
-					nr_failed++;
 				}
 
 				stats->nr_failed_pages += nr_pages + nr_retry_pages;
 				/* nr_failed isn't updated for not used */
-				nr_large_failed += large_retry;
 				stats->nr_thp_failed += thp_retry;
 				rc_saved = rc;
 				if (list_empty(&unmap_folios))
@@ -1730,12 +1715,8 @@ static int migrate_pages_batch(struct li
 				else
 					goto move;
 			case -EAGAIN:
-				if (is_large) {
-					large_retry++;
-					thp_retry += is_thp;
-				} else {
-					retry++;
-				}
+				retry++;
+				thp_retry += is_thp;
 				nr_retry_pages += nr_pages;
 				break;
 			case MIGRATEPAGE_SUCCESS:
@@ -1753,20 +1734,14 @@ static int migrate_pages_batch(struct li
 				 * removed from migration folio list and not
 				 * retried in the next outer loop.
 				 */
-				if (is_large) {
-					nr_large_failed++;
-					stats->nr_thp_failed += is_thp;
-				} else {
-					nr_failed++;
-				}
-
+				nr_failed++;
+				stats->nr_thp_failed += is_thp;
 				stats->nr_failed_pages += nr_pages;
 				break;
 			}
 		}
 	}
 	nr_failed += retry;
-	nr_large_failed += large_retry;
 	stats->nr_thp_failed += thp_retry;
 	stats->nr_failed_pages += nr_retry_pages;
 move:
@@ -1774,17 +1749,15 @@ move:
 	try_to_unmap_flush();
 
 	retry = 1;
-	for (pass = 0; pass < nr_pass && (retry || large_retry); pass++) {
+	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
-		large_retry = 0;
 		thp_retry = 0;
 		nr_retry_pages = 0;
 
 		dst = list_first_entry(&dst_folios, struct folio, lru);
 		dst2 = list_next_entry(dst, lru);
 		list_for_each_entry_safe(folio, folio2, &unmap_folios, lru) {
-			is_large = folio_test_large(folio);
-			is_thp = is_large && folio_test_pmd_mappable(folio);
+			is_thp = folio_test_large(folio) && folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
 
 			cond_resched();
@@ -1800,12 +1773,8 @@ move:
 			 */
 			switch(rc) {
 			case -EAGAIN:
-				if (is_large) {
-					large_retry++;
-					thp_retry += is_thp;
-				} else {
-					retry++;
-				}
+				retry++;
+				thp_retry += is_thp;
 				nr_retry_pages += nr_pages;
 				break;
 			case MIGRATEPAGE_SUCCESS:
@@ -1813,13 +1782,8 @@ move:
 				stats->nr_thp_succeeded += is_thp;
 				break;
 			default:
-				if (is_large) {
-					nr_large_failed++;
-					stats->nr_thp_failed += is_thp;
-				} else {
-					nr_failed++;
-				}
-
+				nr_failed++;
+				stats->nr_thp_failed += is_thp;
 				stats->nr_failed_pages += nr_pages;
 				break;
 			}
@@ -1828,14 +1792,10 @@ move:
 		}
 	}
 	nr_failed += retry;
-	nr_large_failed += large_retry;
 	stats->nr_thp_failed += thp_retry;
 	stats->nr_failed_pages += nr_retry_pages;
 
-	if (rc_saved)
-		rc = rc_saved;
-	else
-		rc = nr_failed + nr_large_failed;
+	rc = rc_saved ? : nr_failed;
 out:
 	/* Cleanup remaining folios */
 	dst = list_first_entry(&dst_folios, struct folio, lru);
_

Patches currently in -mm which might be from ying.huang@intel.com are

migrate_pages_batch-simplify-retrying-and-failure-counting-of-large-folios.patch

