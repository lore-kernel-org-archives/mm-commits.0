Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F268E7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbjJDUSo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244030AbjJDUSn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E664D93
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1C3C433C8;
        Wed,  4 Oct 2023 20:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450717;
        bh=9mVo4YTbEvJlxxwn+PVDtSkzFAef7oCJ8gE8ni6XtoE=;
        h=Date:To:From:Subject:From;
        b=gus5tfm6l1WomQP7mnmmOm+qCYD+2g9jtRzrY0M0Rd3xJP/sIcK621xLF/GrNsHGP
         Cm8sczie1px9TWZ63i0a+t9jZGhntTa+TvEVVDb7kLe1+RW9jXTKouL2CqdPOwz7ln
         gJXxugOvrWLnHJYPs/zQ3Ge3zQ45YOn+6xaXMOR8=
Date:   Wed, 04 Oct 2023 13:18:35 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, yuancan@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-allow-alloc-vmemmap-pages-fallback-to-other-nodes.patch removed from -mm tree
Message-Id: <20231004201837.4B1C3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: allow alloc vmemmap pages fallback to other nodes
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-allow-alloc-vmemmap-pages-fallback-to-other-nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


