Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6C5C71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 21:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjIJV2V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 17:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjIJV2V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 17:28:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E553133
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 14:28:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD5AC433C8;
        Sun, 10 Sep 2023 21:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694381296;
        bh=PCPFFzUKenncIanS/azFb1i/5JtAg/1hBYPSrVx1IJw=;
        h=Date:To:From:Subject:From;
        b=kWjwaEs16VfajiBligpWMvxQVJsB6Is4rM19zFdBlxZeK3w2Yn/mDqXrld9ESbizI
         wv9ntfNe4UW1KeEHhmOrBwUgjhwzWE5+mCxViAHOouuy6mhWvcPoRg6pmRBYbOLfCD
         OX/HprlcrvR+MuqsqEVjXlV6EZSsORFigCwTICnI=
Date:   Sun, 10 Sep 2023 14:28:15 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, yuancan@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-allow-alloc-vmemmap-pages-fallback-to-other-nodes.patch added to mm-unstable branch
Message-Id: <20230910212816.2CD5AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: allow alloc vmemmap pages fallback to other nodes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-allow-alloc-vmemmap-pages-fallback-to-other-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-allow-alloc-vmemmap-pages-fallback-to-other-nodes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yuan Can <yuancan@huawei.com>
Subject: mm: hugetlb_vmemmap: allow alloc vmemmap pages fallback to other nodes
Date: Wed, 6 Sep 2023 17:31:57 +0800

In vmemmap_remap_free(), a new head vmemmap page is allocated to avoid
breaking a contiguous block of struct page memory, however, the allocation
can always fail when the given node is movable node.  Remove the
__GFP_THISNODE to help avoid fragmentation.

Link: https://lkml.kernel.org/r/20230906093157.9737-1-yuancan@huawei.com
Signed-off-by: Yuan Can <yuancan@huawei.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-allow-alloc-vmemmap-pages-fallback-to-other-nodes
+++ a/mm/hugetlb_vmemmap.c
@@ -320,8 +320,7 @@ static int vmemmap_remap_free(unsigned l
 		.vmemmap_pages	= &vmemmap_pages,
 	};
 	int nid = page_to_nid((struct page *)start);
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_THISNODE | __GFP_NORETRY |
-			__GFP_NOWARN;
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
 
 	/*
 	 * Allocate a new head vmemmap page to avoid breaking a contiguous
_

Patches currently in -mm which might be from yuancan@huawei.com are

mm-hugetlb_vmemmap-fix-hugetlb-page-number-decrease-failed-on-movable-nodes.patch
mm-hugetlb_vmemmap-allow-alloc-vmemmap-pages-fallback-to-other-nodes.patch

