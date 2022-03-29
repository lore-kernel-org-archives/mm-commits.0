Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077F6C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 29 Mar 2022 01:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiC2BMo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 21:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiC2BMm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 21:12:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A1A2E6B1
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 18:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9764B815AA
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 01:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567E5C340EC;
        Tue, 29 Mar 2022 01:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648516257;
        bh=gaYM2c3ro3YS/KIbNmgJlEpH8KVxCHWfw/4E6TUWXnM=;
        h=Date:To:From:Subject:From;
        b=1KwDjJgyW/LZ5gYPxD3L8lySMeAn2Ghf0lkPkX3Hatn1ZyK3j2ilJMfx3Vvig8uE5
         DRaiUO3OFnGwk7NAyNc65M0f6V3g6p5RGCuTpYmnzOXL9pceJH/XRucBvMwKbFj6oA
         dmQkSp/V0si6brJHlXuREDhwG3/bDpFrltEmaHmU=
Date:   Mon, 28 Mar 2022 18:10:56 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch added to -mm tree
Message-Id: <20220329011057.567E5C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: remove obsolete comment in z3fold_alloc
has been added to the -mm tree.  Its filename is
     mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch

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
Subject: mm/z3fold: remove obsolete comment in z3fold_alloc

The highmem pages are supported since commit f1549cb5ab2b ("mm/z3fold.c:
allow __GFP_HIGHMEM in z3fold_alloc").  Remove the residual comment.

Link: https://lkml.kernel.org/r/20220308134311.59086-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-obsolete-comment-in-z3fold_alloc
+++ a/mm/z3fold.c
@@ -1064,9 +1064,6 @@ static void z3fold_destroy_pool(struct z
  * performed first. If no suitable free region is found, then a new page is
  * allocated and added to the pool to satisfy the request.
  *
- * gfp should not set __GFP_HIGHMEM as highmem pages cannot be used
- * as z3fold pool pages.
- *
  * Return: 0 if success and handle is set, otherwise -EINVAL if the size or
  * gfp arguments are invalid or -ENOMEM if the pool was unable to allocate
  * a new page.
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

