Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA726C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 22:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiDDWXp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 18:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242191AbiDDWV6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 18:21:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39F865B4
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 14:47:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53095614EA
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 21:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E846C2BBE4;
        Mon,  4 Apr 2022 21:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649108853;
        bh=i2UOLEJE/FNFccLvuTnIRAbEMM47ZwI1S8OD5+P6hIk=;
        h=Date:To:From:Subject:From;
        b=XIS571I74Kr49C04QXKAlb11w0+k99CIC0WPBEAsIKE9dwVUfjVwJveYhDGwBSy/J
         Toryl9iar/rY8zptJ2DRARCJ7cqzQFzNhFW08vW1sUJ7tvL8DdGphb7GYZfvzV6+vi
         b8P+EyI3APJq2Et24rVhsO+6K2g8vtggVFxBuOvM=
Date:   Mon, 04 Apr 2022 14:47:32 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmapc-use-helper-mlock_future_check.patch added to -mm tree
Message-Id: <20220404214733.9E846C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: use helper mlock_future_check()
has been added to the -mm tree.  Its filename is
     mm-mmapc-use-helper-mlock_future_check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-use-helper-mlock_future_check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-use-helper-mlock_future_check.patch

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
Subject: mm/mmap.c: use helper mlock_future_check()

Use helper mlock_future_check() to check whether it's safe to enlarge the
locked_vm to simplify the code.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220402032231.64974-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/mmap.c~mm-mmapc-use-helper-mlock_future_check
+++ a/mm/mmap.c
@@ -2372,15 +2372,8 @@ static int acct_stack_growth(struct vm_a
 		return -ENOMEM;
 
 	/* mlock limit tests */
-	if (vma->vm_flags & VM_LOCKED) {
-		unsigned long locked;
-		unsigned long limit;
-		locked = mm->locked_vm + grow;
-		limit = rlimit(RLIMIT_MEMLOCK);
-		limit >>= PAGE_SHIFT;
-		if (locked > limit && !capable(CAP_IPC_LOCK))
-			return -ENOMEM;
-	}
+	if (mlock_future_check(mm, vma->vm_flags, grow << PAGE_SHIFT))
+		return -ENOMEM;
 
 	/* Check to ensure the stack will not grow into a hugetlb-only region */
 	new_start = (vma->vm_flags & VM_GROWSUP) ? vma->vm_start :
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mempolicy-fix-mpol_new-leak-in-shared_policy_replace.patch
mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mmapc-use-helper-mlock_future_check.patch
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

