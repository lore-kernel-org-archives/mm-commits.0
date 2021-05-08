Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C914C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 801EA6141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWsK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWsK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8272761402;
        Sat,  8 May 2021 22:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514028;
        bh=l1u3LXe627mFwAhwcP77E9DAjhYV9yzipPDeBOuBmb4=;
        h=Date:From:To:Subject:From;
        b=qYRPQGxP3Y8wMRlxnYcT9upjjqDRSbkubzAggdVAv92rIAggnRxNNwHl9E626j5zi
         plYTWASvMZdsdBPC+X856dUCjD2zOs2bnUPId5hEQdQMJsCkryCngmtkmW2IafDp10
         VrkZDean8btpaAWz6m3GP+jA6WWQlCTS9WCYo3g4=
Date:   Sat, 08 May 2021 15:47:08 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, yanfei.xu@windriver.com
Subject:  [merged]
 khugepaged-raplace-barrier-with-read_once-for-a-selective-variable.patch
 removed from -mm tree
Message-ID: <20210508224708.cpcQvtp_X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged.c: replace barrier() with READ_ONCE() for a selective variable
has been removed from the -mm tree.  Its filename was
     khugepaged-raplace-barrier-with-read_once-for-a-selective-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/khugepaged.c: replace barrier() with READ_ONCE() for a selective variable

READ_ONCE() is more selective and lightweight.  It is more appropriate
that using a READ_ONCE() for the certain variable to prevent the compiler
from reordering.

Link: https://lkml.kernel.org/r/20210323092730.247583-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/khugepaged.c~khugepaged-raplace-barrier-with-read_once-for-a-selective-variable
+++ a/mm/khugepaged.c
@@ -2202,11 +2202,9 @@ static void khugepaged_do_scan(void)
 {
 	struct page *hpage = NULL;
 	unsigned int progress = 0, pass_through_head = 0;
-	unsigned int pages = khugepaged_pages_to_scan;
+	unsigned int pages = READ_ONCE(khugepaged_pages_to_scan);
 	bool wait = true;
 
-	barrier(); /* write khugepaged_pages_to_scan to local stack */
-
 	lru_add_drain_all();
 
 	while (progress < pages) {
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are


