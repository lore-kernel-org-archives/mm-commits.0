Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCDBC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55EB161074
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347519AbhIBVYZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347065AbhIBVYI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B008261074;
        Thu,  2 Sep 2021 21:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617789;
        bh=KBV3qKpBKDWu4Ois6fAja1UvQl+mQHkUFhCaNdLeNMY=;
        h=Date:From:To:Subject:From;
        b=fRiuhwmGy7YHFKA7LT37WfcdEvM7UoZ+5v1VVli6WYBN9HqGPWELRsAddbxze7Efl
         P58W/YemHsbK80O41YFCZjcBeRIfKminguZi2mfhLZhWBs0Jzi5a7ZlTmflhADuM+T
         Yn0DJeBEeEzo5bhSPlGH6pfpiSp3ZFOOEvl6jcwg=
Date:   Thu, 02 Sep 2021 14:23:09 -0700
From:   akpm@linux-foundation.org
To:     feng.tang@intel.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, nathan@kernel.org
Subject:  [folded-merged]
 mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-fix.patch
 removed from -mm tree
Message-ID: <20210902212309.Dk7FRv55o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: Initialize page to NULL in alloc_buddy_huge_page_with_mpol()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-fix.patch

This patch was dropped because it was folded into mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch

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

--- a/mm/hugetlb.c~mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-fix
+++ a/mm/hugetlb.c
@@ -2152,7 +2152,7 @@ static
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

mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch
maintainers-update-clangbuiltlinux-mailing-list.patch
documentation-llvm-update-mailing-list.patch
documentation-llvm-update-irc-location.patch

