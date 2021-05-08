Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA271C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD18610D2
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhEHWrs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhEHWrr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97147613E8;
        Sat,  8 May 2021 22:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514005;
        bh=UTcVmI5ZlfgH6qtQ4+qwxewfYF7XdLLGS0RCW5JhDMY=;
        h=Date:From:To:Subject:From;
        b=cI5L4Ae2YZ2Nh9XZNUkwpsxlW8oIJpv5X81/gyqA2VDMp45sEMZ/AQ4EQUSTBdw7g
         6ULoLY8f9NxSCqAkQXVd3yTXWgA/thRByYYuwtZXFsuSBXAfqyGUKH2FEaSqXFYiuK
         N0p6tSb1fenhOB0hhqUL45Ejs2thq+UC2KTpBuOI=
Date:   Sat, 08 May 2021 15:46:45 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, ebru.akagunduz@gmail.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        riel@redhat.com
Subject:  [merged]
 =?US-ASCII?Q?khugepaged-fix-wrong-result-value-for-trace=5Fmm=5Fcollapse?=
 =?US-ASCII?Q?=5Fhuge=5Fpage=5Fisolate.patch?= removed from -mm tree
Message-ID: <20210508224645.wc7eN8MZj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()
has been removed from the -mm tree.  Its filename was
     khugepaged-fix-wrong-result-value-for-trace_mm_collapse_huge_page_isolate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


