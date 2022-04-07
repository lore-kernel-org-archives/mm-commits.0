Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B60CC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Apr 2022 22:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbiDGWg2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Apr 2022 18:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiDGWg2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2022 18:36:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C33F114DFE
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 15:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA33162029
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 22:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A56BC385A0;
        Thu,  7 Apr 2022 22:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649370866;
        bh=E7CJpAo39p3jkv3PxgLfe20+BkzKh4IlQmY9FK1ZgPo=;
        h=Date:To:From:Subject:From;
        b=tbQlz4v8DFAfrnr1LG4lSmnGkRTfOowTBBAWSmwv5SuZmgZfXkejHjJ/TBC8b91ZG
         vQiIuEXi8D92uuSxJGQRklM4Vh9AYB9z5Vb4NvhgS/oX1OGE/AK/20QT5uhfjsByYL
         xQfJXN2lXvXF5qYieLeGyoRp5U/iGo/0cf3u9kIM=
Date:   Thu, 07 Apr 2022 15:34:25 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        naoya.horiguchi@nec.com, mike.kravetz@oracle.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch added to -mm tree
Message-Id: <20220407223426.3A56BC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: minor cleanup for HWPoisonHandlable
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch

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
Subject: mm/memory-failure.c: minor cleanup for HWPoisonHandlable

The local variable movable can be removed by returning true directly. 
Also fix typo 'mirgate'.  No functional change intended.

Link: https://lkml.kernel.org/r/20220407130352.15618-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable
+++ a/mm/memory-failure.c
@@ -1180,13 +1180,11 @@ void ClearPageHWPoisonTakenOff(struct pa
  */
 static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
 {
-	bool movable = false;
-
-	/* Soft offline could mirgate non-LRU movable pages */
+	/* Soft offline could migrate non-LRU movable pages */
 	if ((flags & MF_SOFT_OFFLINE) && __PageMovable(page))
-		movable = true;
+		return true;
 
-	return movable || PageLRU(page) || is_free_buddy_page(page);
+	return PageLRU(page) || is_free_buddy_page(page);
 }
 
 static int __get_hwpoison_page(struct page *page, unsigned long flags)
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

