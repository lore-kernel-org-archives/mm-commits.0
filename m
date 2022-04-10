Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E33C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Apr 2022 04:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiDJEi3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Apr 2022 00:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiDJEi0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Apr 2022 00:38:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A21D5F
        for <mm-commits@vger.kernel.org>; Sat,  9 Apr 2022 21:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33B87CE0DDB
        for <mm-commits@vger.kernel.org>; Sun, 10 Apr 2022 04:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B83C385A1;
        Sun, 10 Apr 2022 04:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649565372;
        bh=kr/ug6wfWJ7TzFrpOoxHyZ5heFYe5LSw58/R8cbWJXI=;
        h=Date:To:From:Subject:From;
        b=VLLrf21AyPwJH/6vKZ2++2NhyMZ9Ib3jmFaAaHFkLS+OMNs+D+DURZhcci8UdX3cd
         LEKLOXWUl5kewOmEORGx8xhTxUjBf14sT8zCUEHJboaY+rm8ZpCMJEDcWWzCnKp7AK
         1eoXyRFReEsssMmJcPehfXYoZX7jFz3D+JSdjPAQ=
Date:   Sat, 09 Apr 2022 21:36:11 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        songmuchun@bytedance.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-migration-remove-unneeded-out-label.patch removed from -mm tree
Message-Id: <20220410043612.61B83C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: remove unneeded out label
has been removed from the -mm tree.  Its filename was
     mm-migration-remove-unneeded-out-label.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: remove unneeded out label

We can do prep_transhuge_page when newpage is not NULL.  Thus we can
remove out label to simplify the code.

Link: https://lkml.kernel.org/r/20220318111709.60311-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/migrate.c~mm-migration-remove-unneeded-out-label
+++ a/mm/migrate.c
@@ -2028,12 +2028,9 @@ static struct page *alloc_misplaced_dst_
 
 	newpage = alloc_pages_node(nid, (GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
 				   HPAGE_PMD_ORDER);
-	if (!newpage)
-		goto out;
+	if (newpage)
+		prep_transhuge_page(newpage);
 
-	prep_transhuge_page(newpage);
-
-out:
 	return newpage;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

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
mm-migration-remove-unneeded-local-variable-page_lru.patch
mm-migration-fix-the-confusing-pagetranshuge-check.patch
mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch
mm-migration-use-helper-macro-min-in-do_pages_stat.patch
mm-migration-avoid-unneeded-nodemask_t-initialization.patch
mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch

