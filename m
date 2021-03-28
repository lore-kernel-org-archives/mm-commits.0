Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74857C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 461A56197F
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhC1TMS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhC1TLu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5938661999;
        Sun, 28 Mar 2021 19:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958710;
        bh=VFYUNNk6UVwmn+hwwejfliYaYKu7iMnWe/QqTuCs/Jw=;
        h=Date:From:To:Subject:From;
        b=gdl62wJAvQVi5mFUzE6z6QEUQrH4AIFEMC3z9etsPWLPURw9OSW8yaKaNTP0vvOY2
         +7QWsT8MRUtdUj/b9Q77nLtjaU0nM7t3NNLZNpSQ76FXS+/A4pjxKINOEC4zxSunPw
         Y/AO0tKOY2jGpaEjDkid1bbJxQk7xLI80Asq++So=
Date:   Sun, 28 Mar 2021 12:11:49 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, ziy@nvidia.com
Subject:  +
 khugepaged-remove-unnecessary-out-label-in-collapse_huge_page.patch added
 to -mm tree
Message-ID: <20210328191149.0yyy0Pao9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: remove unnecessary out label in collapse_huge_page()
has been added to the -mm tree.  Its filename is
     khugepaged-remove-unnecessary-out-label-in-collapse_huge_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/khugepaged-remove-unnecessary-out-label-in-collapse_huge_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-remove-unnecessary-out-label-in-collapse_huge_page.patch

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
Subject: khugepaged: remove unnecessary out label in collapse_huge_page()

The out label here is unneeded because it just goes to out_up_write label.
Remove it to make code more concise.

Link: https://lkml.kernel.org/r/20210325135647.64106-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~khugepaged-remove-unnecessary-out-label-in-collapse_huge_page
+++ a/mm/khugepaged.c
@@ -1128,10 +1128,10 @@ static void collapse_huge_page(struct mm
 	mmap_write_lock(mm);
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result)
-		goto out;
+		goto out_up_write;
 	/* check if the pmd is still valid */
 	if (mm_find_pmd(mm, address) != pmd)
-		goto out;
+		goto out_up_write;
 
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -1171,7 +1171,7 @@ static void collapse_huge_page(struct mm
 		spin_unlock(pmd_ptl);
 		anon_vma_unlock_write(vma->anon_vma);
 		result = SCAN_FAIL;
-		goto out;
+		goto out_up_write;
 	}
 
 	/*
@@ -1215,8 +1215,6 @@ out_nolock:
 		mem_cgroup_uncharge(*hpage);
 	trace_mm_collapse_huge_page(mm, isolated, result);
 	return;
-out:
-	goto out_up_write;
 }
 
 static int khugepaged_scan_pmd(struct mm_struct *mm,
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

