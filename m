Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEE4C4743D
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BBD822D73
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgLOX7f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729173AbgLOXZG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:06 -0500
Date:   Tue, 15 Dec 2020 15:22:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074556;
        bh=E9zHN0O4T5tDqp5fVqebKF8jXR6L0AbuTZdwyR8Ochc=;
        h=From:To:Subject:From;
        b=ljh6sH8c1hoZDbh4KMowYcV8brIPIezdyjuWJfX4Ts0+DOhYgePMKOl1LpbYAsNoK
         SlgZdilivdq6ImQppITsbNuVJJTMiQJD7MD/CYTrPTJuNHX1M789RBpsUizLbCM6lu
         G0zie5rpK5EC9x5ODhAIKG//eFDQ6haq67s8UqXI=
From:   akpm@linux-foundation.org
To:     liu.xiang@zlingsmart.com, liuxiang_1999@126.com,
        ma.chenggong@zlingsmart.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, pan.jiagen@zlingsmart.com
Subject:  [merged]
 =?US-ASCII?Q?mm-hugetlb-fix-type-of-delta-parameter-and-related-local-var?=
 =?US-ASCII?Q?iables-in-gather=5Fsurplus=5Fpages.patch?= removed from -mm
 tree
Message-ID: <20201215232236.JJaadkck9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix type of delta parameter and related local variables in gather_surplus_pages()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-type-of-delta-parameter-and-related-local-variables-in-gather_surplus_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liu Xiang <liu.xiang@zlingsmart.com>
Subject: mm: hugetlb: fix type of delta parameter and related local variables in gather_surplus_pages()

On 64-bit machine, delta variable in hugetlb_acct_memory() may be larger
than 0xffffffff, but gather_surplus_pages() can only use the low 32-bit
value now.  So we need to fix type of delta parameter and related local
variables in gather_surplus_pages().

Link: https://lkml.kernel.org/r/1605793733-3573-1-git-send-email-liu.xiang@zlingsmart.com
Reported-by: Ma Chenggong <ma.chenggong@zlingsmart.com>
Signed-off-by: Liu Xiang <liu.xiang@zlingsmart.com>
Signed-off-by: Pan Jiagen <pan.jiagen@zlingsmart.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Liu Xiang <liuxiang_1999@126.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-type-of-delta-parameter-and-related-local-variables-in-gather_surplus_pages
+++ a/mm/hugetlb.c
@@ -1944,13 +1944,14 @@ struct page *alloc_huge_page_vma(struct
  * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
  */
-static int gather_surplus_pages(struct hstate *h, int delta)
+static int gather_surplus_pages(struct hstate *h, long delta)
 	__must_hold(&hugetlb_lock)
 {
 	struct list_head surplus_list;
 	struct page *page, *tmp;
-	int ret, i;
-	int needed, allocated;
+	int ret;
+	long i;
+	long needed, allocated;
 	bool alloc_ok = true;
 
 	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
_

Patches currently in -mm which might be from liu.xiang@zlingsmart.com are


