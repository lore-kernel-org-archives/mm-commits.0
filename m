Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D9DC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiDLXUR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiDLXTe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:19:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F72F4B878
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 16:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC05BB82076
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 23:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74540C385A8;
        Tue, 12 Apr 2022 23:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649804563;
        bh=yd+gnQzY9Y5sQ1S6Q42n9j1uJ/2HOYE+TYEcv2f/LMM=;
        h=Date:To:From:Subject:From;
        b=AOmzh3A84XSSCO4wkB22La+Z2eTPUJ1N7Pxgxm26RVddpZkZLWvo1O66Cla8bIP96
         Z5If4nhuibWOG1+zlEdaGxTt96MO4j/D6j5KwOHFyqbYLMnvVatb7HbW3ZxGWb156o
         l8CRE3trfMplIcBhcudktwnlutnQZroCYvyYvVaM=
Date:   Tue, 12 Apr 2022 16:02:42 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        naoya.horiguchi@nec.com, mike.kravetz@oracle.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch removed from -mm tree
Message-Id: <20220412230243.74540C385A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: minor cleanup for HWPoisonHandlable
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch

This patch was dropped because an updated version will be merged

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

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mmapc-use-helper-mlock_future_check.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mremap-avoid-unneeded-do_munmap-call.patch
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
mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch
mm-migration-use-helper-macro-min-in-do_pages_stat.patch
mm-migration-avoid-unneeded-nodemask_t-initialization.patch
mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch

