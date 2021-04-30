Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C1DC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45B6961477
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhD3F4q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3F4o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBEFD61459;
        Fri, 30 Apr 2021 05:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762157;
        bh=L9R/gTdIUN0WiHIohzMCFn+9/5nixHM5NRDy3lefAYU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SJ3JgRvyK6/MzDoAk+odu7+73UjIbormO/6AnpC6B5WFFFySiO/tvv7Ji9QNZwa3j
         Y/C90Iuo+xS1qeKTtW+iWHdR0kyqqsJwIooS8LaVmbm8jGhOfTf043UeYSnNOR3QOr
         8spdOmx6zTcIjTFpOKkJz8WU3vSqe2IseYF/ox9w=
Date:   Thu, 29 Apr 2021 22:55:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jgg@nvidia.com, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 054/178] mm: gup: remove FOLL_SPLIT
Message-ID: <20210430055556.xcmsU3Fo2%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: gup: remove FOLL_SPLIT

Since commit 5a52c9df62b4 ("uprobe: use FOLL_SPLIT_PMD instead of
FOLL_SPLIT") and commit ba925fa35057 ("s390/gmap: improve THP splitting")
FOLL_SPLIT has not been used anymore.  Remove the dead code.

Link: https://lkml.kernel.org/r/20210330203900.9222-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.rst |    5 -----
 include/linux/mm.h             |    1 -
 mm/gup.c                       |   28 ++--------------------------
 3 files changed, 2 insertions(+), 32 deletions(-)

--- a/Documentation/vm/transhuge.rst~mm-gup-remove-foll_split
+++ a/Documentation/vm/transhuge.rst
@@ -53,11 +53,6 @@ prevent the page from being split by any
    of handling GUP on hugetlbfs will also work fine on transparent
    hugepage backed mappings.
 
-In case you can't handle compound pages if they're returned by
-follow_page, the FOLL_SPLIT bit can be specified as a parameter to
-follow_page, so that it will split the hugepages before returning
-them.
-
 Graceful fallback
 =================
 
--- a/include/linux/mm.h~mm-gup-remove-foll_split
+++ a/include/linux/mm.h
@@ -2791,7 +2791,6 @@ struct page *follow_page(struct vm_area_
 #define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
 				 * and return without waiting upon it */
 #define FOLL_POPULATE	0x40	/* fault in page */
-#define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
--- a/mm/gup.c~mm-gup-remove-foll_split
+++ a/mm/gup.c
@@ -516,18 +516,6 @@ retry:
 		}
 	}
 
-	if (flags & FOLL_SPLIT && PageTransCompound(page)) {
-		get_page(page);
-		pte_unmap_unlock(ptep, ptl);
-		lock_page(page);
-		ret = split_huge_page(page);
-		unlock_page(page);
-		put_page(page);
-		if (ret)
-			return ERR_PTR(ret);
-		goto retry;
-	}
-
 	/* try_grab_page() does nothing unless FOLL_GET or FOLL_PIN is set. */
 	if (unlikely(!try_grab_page(page, flags))) {
 		page = ERR_PTR(-ENOMEM);
@@ -672,7 +660,7 @@ retry_locked:
 		spin_unlock(ptl);
 		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
 	}
-	if (flags & (FOLL_SPLIT | FOLL_SPLIT_PMD)) {
+	if (flags & FOLL_SPLIT_PMD) {
 		int ret;
 		page = pmd_page(*pmd);
 		if (is_huge_zero_page(page)) {
@@ -681,19 +669,7 @@ retry_locked:
 			split_huge_pmd(vma, pmd, address);
 			if (pmd_trans_unstable(pmd))
 				ret = -EBUSY;
-		} else if (flags & FOLL_SPLIT) {
-			if (unlikely(!try_get_page(page))) {
-				spin_unlock(ptl);
-				return ERR_PTR(-ENOMEM);
-			}
-			spin_unlock(ptl);
-			lock_page(page);
-			ret = split_huge_page(page);
-			unlock_page(page);
-			put_page(page);
-			if (pmd_none(*pmd))
-				return no_page_table(vma, flags);
-		} else {  /* flags & FOLL_SPLIT_PMD */
+		} else {
 			spin_unlock(ptl);
 			split_huge_pmd(vma, pmd, address);
 			ret = pte_alloc(mm, pmd) ? -ENOMEM : 0;
_
