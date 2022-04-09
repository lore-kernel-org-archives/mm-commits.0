Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DC6C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  9 Apr 2022 03:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiDIDKX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 23:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238241AbiDIDKV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 23:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9854836332
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 20:08:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFCDD62298
        for <mm-commits@vger.kernel.org>; Sat,  9 Apr 2022 03:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D856C385A4;
        Sat,  9 Apr 2022 03:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649473694;
        bh=StOxqgEKFwElxEWErMIXoRadRA1RnLSIyKcFt6XdTYc=;
        h=Date:To:From:Subject:From;
        b=djd9pK4VihU8QfsYkTBXsyXoBApeHLi7dhsbys7y8rM/laQoYHiheghVGefyIm4Fa
         qlkj3CnE3JT1sTUFPnURPLtlypzjJ+Ng6+iJIJlFmMxwzMkiTzLI6YXdVbpwpS/YDl
         0gxcYd5IUEGiDo11appnuBcIZ1RmNxvWDDlG9U64=
Date:   Fri, 08 Apr 2022 20:08:13 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-remove-obsolete-comment-in-get_scan_count.patch added to -mm tree
Message-Id: <20220409030814.3D856C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: remove obsolete comment in get_scan_count
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-obsolete-comment-in-get_scan_count.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-obsolete-comment-in-get_scan_count.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-obsolete-comment-in-get_scan_count.patch

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
Subject: mm/vmscan: remove obsolete comment in get_scan_count

Since commit 1431d4d11abb ("mm: base LRU balancing on an explicit cost
model"), the relative value of each set of LRU lists is based on cost
model instead of rotated/scanned ratio.  Cleanup the relevant comment.

Link: https://lkml.kernel.org/r/20220409030245.61211-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-obsolete-comment-in-get_scan_count
+++ a/mm/vmscan.c
@@ -2663,9 +2663,7 @@ enum scan_balance {
 
 /*
  * Determine how aggressively the anon and file LRU lists should be
- * scanned.  The relative value of each set of LRU lists is determined
- * by looking at the fraction of the pages scanned we did rotate back
- * onto the active list instead of evict.
+ * scanned.
  *
  * nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
  * nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mempolicy-fix-mpol_new-leak-in-shared_policy_replace.patch
mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mmapc-use-helper-mlock_future_check.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mremap-avoid-unneeded-do_munmap-call.patch
mm-memory-failurec-avoid-false-postive-pageswapcache-test.patch
mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch
mm-memory-failurec-dissolve-truncated-hugetlb-page.patch
mm-vmscan-remove-obsolete-comment-in-get_scan_count.patch
mm-z3fold-declare-z3fold_mount-with-__init.patch
mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch
mm-z3fold-minor-clean-up-for-z3fold_free.patch
mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch
mm-z3fold-remove-confusing-local-variable-l-reassignment.patch
mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch
mm-z3fold-remove-redundant-list_del_init-of-zhdr-buddy-in-z3fold_free.patch
mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch
mm-compaction-use-helper-isolation_suitable.patch
drivers-base-nodec-fix-compaction-sysfs-file-leak.patch
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

