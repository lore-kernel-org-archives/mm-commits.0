Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC61CC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 30 Mar 2022 00:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241050AbiC3A4y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Mar 2022 20:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiC3A4y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2022 20:56:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC2119531B
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 17:55:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E710B61266
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 00:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B030C2BBE4;
        Wed, 30 Mar 2022 00:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648601709;
        bh=HeJwDZyv5x7lqoFTeGm2hTC6dNpH0uHNY7U5KZb8nxI=;
        h=Date:To:From:Subject:From;
        b=mEnYvCgIBtRh1p7veRLkBJRtSy00H2H5vsD/KsuHBJSMAv+3gHuVEx3g6qvWCkqQM
         EHCoX/OXKjI6M8YpHW8nxRzOkvJZxPGtczvGzZRN6NRF29M+xJuogNDpv8qF0Tj+pw
         PCgTLK0c4/mLvofK8mlZU1YsAWYSkanb9KQYJrNM=
Date:   Tue, 29 Mar 2022 17:55:08 -0700
To:     mm-commits@vger.kernel.org, legion@kernel.org, hughd@google.com,
        ebiederm@xmission.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mlock-fix-two-bugs-in-user_shm_lock.patch removed from -mm tree
Message-Id: <20220330005509.4B030C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: fix two bugs in user_shm_lock()
has been removed from the -mm tree.  Its filename was
     mm-mlock-fix-two-bugs-in-user_shm_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mlock: fix two bugs in user_shm_lock()

user_shm_lock forgets to set allowed to 0 when get_ucounts fails.  So the
later user_shm_unlock might do the extra dec_rlimit_ucounts.  Also in the
RLIM_INFINITY case, user_shm_lock will success regardless of the value of
memlock where memblock == LONG_MAX && !capable(CAP_IPC_LOCK) should fail. 
Fix all of these by changing the code to leave lock_limit at ULONG_MAX aka
RLIM_INFINITY, leave "allowed" initialized to 0 and remove the special
case of RLIM_INFINITY as nothing can be greater than ULONG_MAX.

Credit goes to Eric W.  Biederman for proposing simplifying the code and
thus catching the later bug.

Link: https://lkml.kernel.org/r/20220322080918.59861-1-linmiaohe@huawei.com
Fixes: d7c9e99aee48 ("Reimplement RLIMIT_MEMLOCK on top of ucounts")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/mlock.c~mm-mlock-fix-two-bugs-in-user_shm_lock
+++ a/mm/mlock.c
@@ -721,13 +721,12 @@ int user_shm_lock(size_t size, struct uc
 
 	locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
-	if (lock_limit == RLIM_INFINITY)
-		allowed = 1;
-	lock_limit >>= PAGE_SHIFT;
+	if (lock_limit != RLIM_INFINITY)
+		lock_limit >>= PAGE_SHIFT;
 	spin_lock(&shmlock_user_lock);
 	memlock = inc_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
 
-	if (!allowed && (memlock == LONG_MAX || memlock > lock_limit) && !capable(CAP_IPC_LOCK)) {
+	if ((memlock == LONG_MAX || memlock > lock_limit) && !capable(CAP_IPC_LOCK)) {
 		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
 		goto out;
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mremap-use-helper-mlock_future_check.patch
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

