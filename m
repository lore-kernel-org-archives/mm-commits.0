Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B32C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 23:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACF256198A
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 23:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCSXPd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 19:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhCSXPL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 19:15:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B46F26197F;
        Fri, 19 Mar 2021 23:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616195711;
        bh=bnDzgBvdc7ycORl5pVd2dRsWkuaf3AaOrdy8HTewqF0=;
        h=Date:From:To:Subject:From;
        b=rpq8ScFuJGbtIwLpw3TettsXo1JpgOjZET84cu3549L4/mwh/YfoouU45qstrUYAQ
         umG/infanAYBoNSF2Qrps2086SRsbgM1vPax3RMLpXXri8YH7IVEdLVPUFxDAMJEpE
         ZLSPKrnq/MzBxvSa7Gk+5RdCiAmYlOVjWGLfkc44=
Date:   Fri, 19 Mar 2021 16:15:10 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, vbabka@suse.cz, walken@google.com,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  +
 =?US-ASCII?Q?mm-huge=5Fmemoryc-remove-unused-macro-transparent=5Fhugep?=
 =?US-ASCII?Q?age=5Fdebug=5Fcow=5Fflag.patch?= added to -mm tree
Message-ID: <20210319231510.QwEjFtPJh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: remove unused macro TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-remove-unused-macro-transparent_hugepage_debug_cow_flag.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memoryc-remove-unused-macro-transparent_hugepage_debug_cow_flag.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memoryc-remove-unused-macro-transparent_hugepage_debug_cow_flag.patch

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
Subject: mm/huge_memory.c: remove unused macro TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG

Commit 4958e4d86ecb ("mm: thp: remove debug_cow switch") forgot to remove
TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG macro.  Remove it here.

Link: https://lkml.kernel.org/r/20210318122722.13135-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Thomas Hellstrm (Intel) <thomas_os@shipmail.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: yuleixzhang <yulei.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memoryc-remove-unused-macro-transparent_hugepage_debug_cow_flag
+++ a/include/linux/huge_mm.h
@@ -87,9 +87,6 @@ enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
 	TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
-#ifdef CONFIG_DEBUG_VM
-	TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG,
-#endif
 };
 
 struct kobject;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings-v3.patch
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

