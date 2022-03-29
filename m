Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FA5C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 29 Mar 2022 01:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiC2BMq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 21:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiC2BMn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 21:12:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04722E9C9
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 18:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6466FB815A9
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 01:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3041C340ED;
        Tue, 29 Mar 2022 01:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648516259;
        bh=v7eo2pODcIIJe7j5BYwnyNk2rNU9W3UZLXWtpsiRaDk=;
        h=Date:To:From:Subject:From;
        b=S2nTpBNuJ0i27t0qwsdv2+9SlHilBHR5jYHzwz7jkwH61mpoZZPRwCN7TvdwL6MBg
         +YYYpHZApcPQjjXOtxJAlGq6SmEtoRaCdFvJnu8LmgndtfvFxuhfDgcXrywHcJlrKM
         g7NeAp4/V87IVEKoqVKZu+Ys2u6z7r8zY1ou1doY=
Date:   Mon, 28 Mar 2022 18:10:58 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-minor-clean-up-for-z3fold_free.patch added to -mm tree
Message-Id: <20220329011058.F3041C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: minor clean up for z3fold_free
has been added to the -mm tree.  Its filename is
     mm-z3fold-minor-clean-up-for-z3fold_free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-z3fold-minor-clean-up-for-z3fold_free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-z3fold-minor-clean-up-for-z3fold_free.patch

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
Subject: mm/z3fold: minor clean up for z3fold_free

Use put_z3fold_header() to pair with get_z3fold_header.  Also fix the
wrong comments.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220308134311.59086-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-minor-clean-up-for-z3fold_free
+++ a/mm/z3fold.c
@@ -1187,9 +1187,9 @@ headless:
  * @handle:	handle associated with the allocation returned by z3fold_alloc()
  *
  * In the case that the z3fold page in which the allocation resides is under
- * reclaim, as indicated by the PG_reclaim flag being set, this function
- * only sets the first|last_chunks to 0.  The page is actually freed
- * once both buddies are evicted (see z3fold_reclaim_page() below).
+ * reclaim, as indicated by the PAGE_CLAIMED flag being set, this function
+ * only sets the first|middle|last_chunks to 0.  The page is actually freed
+ * once all buddies are evicted (see z3fold_reclaim_page() below).
  */
 static void z3fold_free(struct z3fold_pool *pool, unsigned long handle)
 {
@@ -1247,7 +1247,7 @@ static void z3fold_free(struct z3fold_po
 	}
 	if (page_claimed) {
 		/* the page has not been claimed by us */
-		z3fold_page_unlock(zhdr);
+		put_z3fold_header(zhdr);
 		return;
 	}
 	if (test_and_set_bit(NEEDS_COMPACTING, &page->private)) {
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

