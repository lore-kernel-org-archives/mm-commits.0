Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD3AC43461
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F01861404
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhEEBfK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhEEBfI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:35:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7933B613FE;
        Wed,  5 May 2021 01:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178452;
        bh=sdfnsO70M8Ltp1wioWUxSgGD1EdnyX/pvWylNy0Z6To=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jtiitdgrdc9MWBTE9fIaTsPUWRtkazR/PXWSAhb/wb3SrA4aPrRd8uNWYaBxC4Y46
         m9lSuYg1GZ94MLhChmWxVDtnVMzLsXP2Xwd8xx7q9I3RhYI+WCdhw8915vYf29sTYf
         rKdZTtP1TS7ESPY0roRIrftmTWgcOGhlX7NDgWfs=
Date:   Tue, 04 May 2021 18:34:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yanfei.xu@windriver.com
Subject:  [patch 028/143] mm/khugepaged.c: replace barrier() with
 READ_ONCE() for a selective variable
Message-ID: <20210505013412.wFqTFyLJJ%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
