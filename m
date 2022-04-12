Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D2AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiDLXUQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiDLXTe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:19:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AA81ADA7
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 16:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3379B82036
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 23:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73330C385A1;
        Tue, 12 Apr 2022 23:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649804562;
        bh=ecDNoIbxP8lJ6LCxOfpzNg4qZ6jAfj9Vf4+R7OVeafg=;
        h=Date:To:From:Subject:From;
        b=Na12jpIRAiEQ8GtvsB6dhBXBrulYFofAzDKD5tNSLO5k3gyaS+Sx4peWiZifW4kDF
         pWXUl0sww6HSjvAxAvpyzYvJHWcMiuihk2vqb7wRctK/cMHvtkGP3QBD7lB45nuuzA
         BpBHlDccOuSZHn1UKtvBqS/97NrU+Y665y4Wloek=
Date:   Tue, 12 Apr 2022 16:02:41 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        naoya.horiguchi@nec.com, mike.kravetz@oracle.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failurec-avoid-false-postive-pageswapcache-test.patch removed from -mm tree
Message-Id: <20220412230242.73330C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: avoid false-postive PageSwapCache test
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-avoid-false-postive-pageswapcache-test.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: avoid false-postive PageSwapCache test

Patch series "A few fixup and cleanup patches for memory failure".

This series contains a patch to fix false-postive PageSwapCache test,
minor cleanup for HWPoisonHandlable and try to dissolve truncated hugetlb
page.  More details can be found in the respective changelogs.


This patch (of 3):

PageSwapCache is only reliable when PageAnon is true because PG_swapcache
serves as PG_owner_priv_1 which can be used by fs if it's pagecache page. 
So we should test PageAnon to distinguish pagecache page from swapcache
page to avoid false-postive PageSwapCache test.

Link: https://lkml.kernel.org/r/20220407130352.15618-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220407130352.15618-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failurec-avoid-false-postive-pageswapcache-test
+++ a/mm/memory-failure.c
@@ -2262,7 +2262,7 @@ static int __soft_offline_page(struct pa
 		return 0;
 	}
 
-	if (!PageHuge(page) && PageLRU(page) && !PageSwapCache(page))
+	if (!PageHuge(page) && PageLRU(page) && !PageAnon(page))
 		/*
 		 * Try to invalidate first. This should work for
 		 * non dirty unmapped page cache pages.
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mmapc-use-helper-mlock_future_check.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mremap-avoid-unneeded-do_munmap-call.patch
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
mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch
mm-migration-use-helper-macro-min-in-do_pages_stat.patch
mm-migration-avoid-unneeded-nodemask_t-initialization.patch
mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch

