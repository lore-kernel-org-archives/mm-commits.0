Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6AB4C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 29 Mar 2022 01:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiC2BMp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 21:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiC2BMn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 21:12:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE79B2E9CB
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 18:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D2A56121C
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 01:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AAEC3410F;
        Tue, 29 Mar 2022 01:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648516260;
        bh=V8fp3b9mcxLD4TkKimiseLJ2DNZAWqvF0Alv1nK90w0=;
        h=Date:To:From:Subject:From;
        b=oJD2anGsifRbzr6YjytmxEXUa/+BcX6xOqgO+Day4IPniEe6EyakkfX1BHFzmVIJC
         Zp+8jWGfN0MXmTkG+UkyCIWXCwpyUXUALlyrTi+LwXmR8R0eaHJtSRQEPZfpDUi3Xj
         RCMhSCip1BdqZBFS2TirZh7HK7vK6fO1cQYRll54=
Date:   Mon, 28 Mar 2022 18:11:00 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch added to -mm tree
Message-Id: <20220329011100.B4AAEC3410F@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: remove unneeded page_mapcount_reset and ClearPagePrivate
has been added to the -mm tree.  Its filename is
     mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch

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
Subject: mm/z3fold: remove unneeded page_mapcount_reset and ClearPagePrivate

Page->page_type and PagePrivate are not used in z3fold.  We should remove
these confusing unneeded operations.  The z3fold do these here is due to
referring to zsmalloc's migration code which does need these operations.

Link: https://lkml.kernel.org/r/20220308134311.59086-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate
+++ a/mm/z3fold.c
@@ -420,7 +420,6 @@ static void free_z3fold_page(struct page
 		__ClearPageMovable(page);
 		unlock_page(page);
 	}
-	ClearPagePrivate(page);
 	__free_page(page);
 }
 
@@ -1635,7 +1634,6 @@ static int z3fold_page_migrate(struct ad
 	INIT_LIST_HEAD(&new_zhdr->buddy);
 	new_mapping = page_mapping(page);
 	__ClearPageMovable(page);
-	ClearPagePrivate(page);
 
 	get_page(newpage);
 	z3fold_page_lock(new_zhdr);
@@ -1655,7 +1653,6 @@ static int z3fold_page_migrate(struct ad
 
 	queue_work_on(new_zhdr->cpu, pool->compact_wq, &new_zhdr->work);
 
-	page_mapcount_reset(page);
 	clear_bit(PAGE_CLAIMED, &page->private);
 	put_page(page);
 	return 0;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mlock-fix-two-bugs-in-user_shm_lock.patch
mm-z3fold-declare-z3fold_mount-with-__init.patch
mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch
mm-z3fold-minor-clean-up-for-z3fold_free.patch
mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch
mm-z3fold-remove-confusing-local-variable-l-reassignment.patch
mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch
mm-z3fold-remove-redundant-list_del_init-of-zhdr-buddy-in-z3fold_free.patch
mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch
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

