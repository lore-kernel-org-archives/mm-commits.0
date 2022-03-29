Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F21C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 29 Mar 2022 01:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiC2BMz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 21:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiC2BMw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 21:12:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB6D30543
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 18:11:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E47661214
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 01:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D9EC34111;
        Tue, 29 Mar 2022 01:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648516267;
        bh=r9WKRlC//C8P8ZAXvwe+t+LIKnyxQWOuOFvZP0wYgmg=;
        h=Date:To:From:Subject:From;
        b=I9YG6exoE0e5OBKWYYzTpsDJR7oYSxKeDdnY70LtSkZhgaCUpVRhKMFGYRINnAn6/
         XE0voAlslNlhafJcsT+Xp0WW0ajeyheBN+c1iNBgWq6Cf7QBNYOSwbi7A+2fccClVY
         8EAN62MXluZWSNGyeMDH2HxK1fse99saCsPnSYdE=
Date:   Mon, 28 Mar 2022 18:11:07 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch added to -mm tree
Message-Id: <20220329011107.A5D9EC34111@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: remove unneeded PAGE_HEADLESS check in free_handle()
has been added to the -mm tree.  Its filename is
     mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch

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
Subject: mm/z3fold: remove unneeded PAGE_HEADLESS check in free_handle()

The only caller z3fold_free() never calls free_handle() in PAGE_HEADLESS
case.  Remove this unneeded check.

Link: https://lkml.kernel.org/r/20220308134311.59086-9-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-unneeded-page_headless-check-in-free_handle
+++ a/mm/z3fold.c
@@ -297,9 +297,6 @@ static inline void free_handle(unsigned
 	int i;
 	bool is_free;
 
-	if (handle & (1 << PAGE_HEADLESS))
-		return;
-
 	if (WARN_ON(*(unsigned long *)handle == 0))
 		return;
 
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

