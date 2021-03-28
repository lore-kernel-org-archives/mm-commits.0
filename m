Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB64C433E2
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37CC461972
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhC1TMS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231499AbhC1TLw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 480936196E;
        Sun, 28 Mar 2021 19:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958712;
        bh=UDf3ZIgj+G24K8giWS1P8bIsT33DLy7gOBUsRv6KmkU=;
        h=Date:From:To:Subject:From;
        b=jQ7dkEOqo4aSG+nGq4M4v17LLNoIWFYBBjoIR71NnWiLuKC/hMxkhsiec1IAFSETQ
         gPk7EepRYdFw23T6gN4mprCOUfc3xUIOVs74Zreh26cOWOtvOwABQUBcerqtKb9DVi
         F83bh07iOq/4m4x5fVm867Q/8vVh+7KZ6/0sjbeQ=
Date:   Sun, 28 Mar 2021 12:11:51 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, aquini@redhat.com, david@redhat.com,
        jglisse@redhat.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com
Subject:  + mm-migratec-make-putback_movable_page-static.patch
 added to -mm tree
Message-ID: <20210328191151.08ZLRmXGF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: make putback_movable_page() static
has been added to the -mm tree.  Its filename is
     mm-migratec-make-putback_movable_page-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-make-putback_movable_page-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-make-putback_movable_page-static.patch

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
Subject: mm/migrate.c: make putback_movable_page() static

Patch series "Cleanup and fixup for mm/migrate.c", v3.

This series contains cleanups to remove unnecessary VM_BUG_ON_PAGE and rc
!= MIGRATEPAGE_SUCCESS check.  Also use helper function to remove some
duplicated codes.  What's more, this fixes potential deadlock in NUMA
balancing shared exec THP case and so on.  More details can be found in
the respective changelogs.


This patch (of 5):

The putback_movable_page() is just called by putback_movable_pages() and
we know the page is locked and both PageMovable() and PageIsolated() is
checked right before calling putback_movable_page().  So we make it static
and remove all the 3 VM_BUG_ON_PAGE().

Link: https://lkml.kernel.org/r/20210325131524.48181-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210325131524.48181-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    1 -
 mm/migrate.c            |    7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/include/linux/migrate.h~mm-migratec-make-putback_movable_page-static
+++ a/include/linux/migrate.h
@@ -43,7 +43,6 @@ extern int migrate_pages(struct list_hea
 		unsigned long private, enum migrate_mode mode, int reason);
 extern struct page *alloc_migration_target(struct page *page, unsigned long private);
 extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
-extern void putback_movable_page(struct page *page);
 
 extern void migrate_page_states(struct page *newpage, struct page *page);
 extern void migrate_page_copy(struct page *newpage, struct page *page);
--- a/mm/migrate.c~mm-migratec-make-putback_movable_page-static
+++ a/mm/migrate.c
@@ -118,15 +118,10 @@ out:
 	return -EBUSY;
 }
 
-/* It should be called on page which is PG_movable */
-void putback_movable_page(struct page *page)
+static void putback_movable_page(struct page *page)
 {
 	struct address_space *mapping;
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageMovable(page), page);
-	VM_BUG_ON_PAGE(!PageIsolated(page), page);
-
 	mapping = page_mapping(page);
 	mapping->a_ops->putback_page(page);
 	__ClearPageIsolated(page);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch
mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch
mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch
hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch
mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch
mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch
khugepaged-remove-unneeded-return-value-of-khugepaged_collapse_pte_mapped_thps.patch
khugepaged-reuse-the-smp_wmb-inside-__setpageuptodate.patch
khugepaged-use-helper-khugepaged_test_exit-in-__khugepaged_enter.patch
khugepaged-fix-wrong-result-value-for-trace_mm_collapse_huge_page_isolate.patch
mm-huge_memoryc-remove-unnecessary-local-variable-ret2.patch
mm-huge_memoryc-rework-the-function-vma_adjust_trans_huge.patch
mm-huge_memoryc-make-get_huge_zero_page-return-bool.patch
mm-huge_memoryc-rework-the-function-do_huge_pmd_numa_page-slightly.patch
mm-huge_memoryc-remove-redundant-pagecompound-check.patch
mm-huge_memoryc-remove-unused-macro-transparent_hugepage_debug_cow_flag.patch
mm-huge_memoryc-use-helper-function-migration_entry_to_page.patch
khugepaged-use-helper-function-range_in_vma-in-collapse_pte_mapped_thp.patch
khugepaged-remove-unnecessary-out-label-in-collapse_huge_page.patch
khugepaged-remove-meaningless-pte_present-check-in-khugepaged_scan_pmd.patch
mm-migratec-make-putback_movable_page-static.patch
mm-migratec-remove-unnecessary-rc-=-migratepage_success-check-in-else-case.patch
mm-migratec-fix-potential-indeterminate-pte-entry-in-migrate_vma_insert_page.patch
mm-migratec-use-helper-migrate_vma_collect_skip-in-migrate_vma_collect_hole.patch
revert-mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch

