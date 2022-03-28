Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D114C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 22:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiC1WRC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiC1WQi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 18:16:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BCE160FE0
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 15:12:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 459CAB8125F
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 22:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BE3C340F0;
        Mon, 28 Mar 2022 22:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648505574;
        bh=1nCJFAcHxK9NAYWolOMb7KIb+/Dpyss8cjxL/I8aKdY=;
        h=Date:To:From:Subject:From;
        b=XdMRUH2ItgipBEkCrq1igKMn6xc9t8jpndszuiZOiK4LM1nE0TyIMXIvNdlDdLnMp
         owAOTYBqwvOZrldZCzRfXKObU0BKcsAxLRPy1RUoosrBT3jx52OIirLyYhQMo5XMGL
         Y+uoW87pxFLPyYcFMj0QVNc/kFEFl6xIy+rSBmiY=
Date:   Mon, 28 Mar 2022 15:12:54 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        songmuchun@bytedance.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migration-fix-the-confusing-pagetranshuge-check.patch added to -mm tree
Message-Id: <20220328221254.C0BE3C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: fix the confusing PageTransHuge check
has been added to the -mm tree.  Its filename is
     mm-migration-fix-the-confusing-pagetranshuge-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migration-fix-the-confusing-pagetranshuge-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-fix-the-confusing-pagetranshuge-check.patch

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
Subject: mm/migration: fix the confusing PageTransHuge check

prep_transhuge_page should be called when PageTransHuge(page) is true. 
The newly allocated new_page is not yet PageTransHuge though it could pass
the check as PageTransHuge only checks PageHead now.

Link: https://lkml.kernel.org/r/20220318111709.60311-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migration-fix-the-confusing-pagetranshuge-check
+++ a/mm/migrate.c
@@ -1553,7 +1553,7 @@ struct page *alloc_migration_target(stru
 
 	new_page = __alloc_pages(gfp_mask, order, nid, mtc->nmask);
 
-	if (new_page && PageTransHuge(new_page))
+	if (new_page && PageTransHuge(page))
 		prep_transhuge_page(new_page);
 
 	return new_page;
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

