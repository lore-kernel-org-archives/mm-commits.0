Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B932AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 22:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiC1WR0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiC1WQj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 18:16:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75B515405A
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 15:13:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7779461477
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 22:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC37AC340F0;
        Mon, 28 Mar 2022 22:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648505581;
        bh=4cAuuDGFea6K9RNbiosHWGg/+BSED5CGTiva8spUMaU=;
        h=Date:To:From:Subject:From;
        b=dLSeYlODLUEkYxozFXznjMiKiRM583p1iIW903O8wNK8LjNhyGG2L0eih/SrhU82j
         rUZXjzcIdLGi4a0k80fnMJA1Fp+ingvwFpCCySIDgtlrVPbooONqb9mMNRqbGAtfCi
         k0tSwsdtgP9tWVUFx42bIVRwgeMJOGpU89C5+mOo=
Date:   Mon, 28 Mar 2022 15:13:01 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        songmuchun@bytedance.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch added to -mm tree
Message-Id: <20220328221301.CC37AC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: remove some duplicated codes in migrate_pages
has been added to the -mm tree.  Its filename is
     mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: remove some duplicated codes in migrate_pages

Remove the duplicated codes in migrate_pages to simplify the code.  Minor
readability improvement.  No functional change intended.

Link: https://lkml.kernel.org/r/20220318111709.60311-9-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

--- a/mm/migrate.c~mm-migration-remove-some-duplicated-codes-in-migrate_pages
+++ a/mm/migrate.c
@@ -1410,14 +1410,11 @@ retry:
 						nr_thp_split++;
 						goto retry;
 					}
-
-					nr_failed_pages += nr_subpages;
-					break;
-				}
-
 				/* Hugetlb migration is unsupported */
-				if (!no_subpage_counting)
+				} else if (!no_subpage_counting) {
 					nr_failed++;
+				}
+
 				nr_failed_pages += nr_subpages;
 				break;
 			case -ENOMEM:
@@ -1432,28 +1429,22 @@ retry:
 						nr_thp_split++;
 						goto retry;
 					}
-
-					nr_failed_pages += nr_subpages;
-					goto out;
+				} else if (!no_subpage_counting) {
+					nr_failed++;
 				}
 
-				if (!no_subpage_counting)
-					nr_failed++;
 				nr_failed_pages += nr_subpages;
 				goto out;
 			case -EAGAIN:
-				if (is_thp) {
+				if (is_thp)
 					thp_retry++;
-					break;
-				}
-				retry++;
+				else
+					retry++;
 				break;
 			case MIGRATEPAGE_SUCCESS:
 				nr_succeeded += nr_subpages;
-				if (is_thp) {
+				if (is_thp)
 					nr_thp_succeeded++;
-					break;
-				}
 				break;
 			default:
 				/*
@@ -1462,14 +1453,11 @@ retry:
 				 * removed from migration page list and not
 				 * retried in the next outer loop.
 				 */
-				if (is_thp) {
+				if (is_thp)
 					nr_thp_failed++;
-					nr_failed_pages += nr_subpages;
-					break;
-				}
-
-				if (!no_subpage_counting)
+				else if (!no_subpage_counting)
 					nr_failed++;
+
 				nr_failed_pages += nr_subpages;
 				break;
 			}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mlock-fix-two-bugs-in-user_shm_lock.patch
mm-compaction-use-helper-isolation_suitable.patch
mm-migration-remove-unneeded-local-variable-mapping_locked.patch
mm-migration-remove-unneeded-out-label.patch
mm-migration-remove-unneeded-local-variable-page_lru.patch
mm-migration-fix-the-confusing-pagetranshuge-check.patch
mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch
mm-migration-use-helper-macro-min-in-do_pages_stat.patch
mm-migration-avoid-unneeded-nodemask_t-initialization.patch
mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch

