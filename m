Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC4FC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 21:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F11B0652B5
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 21:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhCHVDG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 16:03:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229972AbhCHVCd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 16:02:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2895652B1;
        Mon,  8 Mar 2021 21:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615237353;
        bh=QQMLvtYG7ES8S+wa6Iq9ETy2t6yMzwsrAhGnQ4dB7jo=;
        h=Date:From:To:Subject:From;
        b=e7kPbgP/6sRI1lgpnVyP2wUedgf4gRdZ+RoZDM5e8abAzCy3g7hOWgbd85i5M2on8
         sSym2jOyeTcjZ5NsLzgI45vHLwCXBIkqtt0lWUaLlHykENUTq/LoBWD3hpAyph95C9
         9Hc86tJuxKGcZVjAcVDrlQl6tnj9ZKZpmzoVlRWY=
Date:   Mon, 08 Mar 2021 13:02:32 -0800
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, ebru.akagunduz@gmail.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        riel@redhat.com
Subject:  +
 =?US-ASCII?Q?khugepaged-fix-wrong-result-value-for-trace=5Fmm=5Fcollapse?=
 =?US-ASCII?Q?=5Fhuge=5Fpage=5Fisolate.patch?= added to -mm tree
Message-ID: <20210308210232.fvwDKwbT-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()
has been added to the -mm tree.  Its filename is
     khugepaged-fix-wrong-result-value-for-trace_mm_collapse_huge_page_isolate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/khugepaged-fix-wrong-result-value-for-trace_mm_collapse_huge_page_isolate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-fix-wrong-result-value-for-trace_mm_collapse_huge_page_isolate.patch

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
Subject: khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()

In writable and !referenced case, the result value should be
SCAN_LACK_REFERENCED_PAGE for trace_mm_collapse_huge_page_isolate()
instead of default 0 (SCAN_FAIL) here.

Link: https://lkml.kernel.org/r/20210306032947.35921-5-linmiaohe@huawei.com
Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/khugepaged.c~khugepaged-fix-wrong-result-value-for-trace_mm_collapse_huge_page_isolate
+++ a/mm/khugepaged.c
@@ -716,17 +716,17 @@ next:
 		if (pte_write(pteval))
 			writable = true;
 	}
-	if (likely(writable)) {
-		if (likely(referenced)) {
-			result = SCAN_SUCCEED;
-			trace_mm_collapse_huge_page_isolate(page, none_or_zero,
-							    referenced, writable, result);
-			return 1;
-		}
-	} else {
+
+	if (unlikely(!writable)) {
 		result = SCAN_PAGE_RO;
+	} else if (unlikely(!referenced)) {
+		result = SCAN_LACK_REFERENCED_PAGE;
+	} else {
+		result = SCAN_SUCCEED;
+		trace_mm_collapse_huge_page_isolate(page, none_or_zero,
+						    referenced, writable, result);
+		return 1;
 	}
-
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
 	trace_mm_collapse_huge_page_isolate(page, none_or_zero,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
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

