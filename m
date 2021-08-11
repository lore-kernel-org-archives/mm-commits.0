Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D701FC4338F
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 01:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B18EA60EE9
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 01:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhHKBS5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Aug 2021 21:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhHKBS4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Aug 2021 21:18:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B36D660232;
        Wed, 11 Aug 2021 01:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628644712;
        bh=ebLM5QXcv6dCOfI2tFc8UN0pfJi/8sjHltuz9sfdZiA=;
        h=Date:From:To:Subject:From;
        b=mIrx0Sz02/bBN6p53UxsjNFyXx9RD9r/8CF+MJPk7Jrsp4ObweT5MBzsKionlna99
         vOFDJ5LMiXyHLnKz0Yhw/aCjoPkc55uQmi/eC6Ser/NTRSw7+DNFMoBhamg6LKN72+
         Qgyvp5010412F40U1khHuTtjZch0HVLVC5trA4WY=
Date:   Tue, 10 Aug 2021 18:18:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        feng.tang@intel.com, nathan@kernel.org
Subject:  +
 mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol.patch
 added to -mm tree
Message-ID: <20210811011832.fuoJM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: Initialize page to NULL in alloc_buddy_huge_page_with_mpol()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: mm/hugetlb: Initialize page to NULL in alloc_buddy_huge_page_with_mpol()

Clang warns:

mm/hugetlb.c:2162:6: warning: variable 'page' is used uninitialized
whenever 'if' condition is false [-Wsometimes-uninitialized]
        if (mpol_is_preferred_many(mpol)) {
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/hugetlb.c:2172:7: note: uninitialized use occurs here
        if (!page)
             ^~~~
mm/hugetlb.c:2162:2: note: remove the 'if' if its condition is always
true
        if (mpol_is_preferred_many(mpol)) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/hugetlb.c:2155:19: note: initialize the variable 'page' to silence
this warning
        struct page *page;
                         ^
                          = NULL
1 warning generated.

Initialize page to NULL like in dequeue_huge_page_vma() so that page is
not used uninitialized.

Link: https://lkml.kernel.org/r/20210810200632.3812797-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol
+++ a/mm/hugetlb.c
@@ -2088,7 +2088,7 @@ static
 struct page *alloc_buddy_huge_page_with_mpol(struct hstate *h,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct page *page;
+	struct page *page = NULL;
 	struct mempolicy *mpol;
 	gfp_t gfp_mask = htlb_alloc_mask(h);
 	int nid;
_

Patches currently in -mm which might be from nathan@kernel.org are

mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol.patch

