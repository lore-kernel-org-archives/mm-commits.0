Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BD0C47436
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B747722D57
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgLOX7c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:59718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbgLOXZG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:06 -0500
Date:   Tue, 15 Dec 2020 15:22:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074561;
        bh=5WWpBsw5jGUrUPE+RN887T7Blx3tmvdaHm5Yyl3hAGs=;
        h=From:To:Subject:From;
        b=w/mfMnNNc+ICOLRDpM8gkIY0Vkfx5LOZJBE0aRUCuQ2n36V3xQRqmO99zsWtQnESS
         lBSEmdui6QiA1+5b31kqe/G+Mmly9H62xAv7oIL4rg4JKftn7rTahM4MYMUftqp1Cb
         OA8TxGHhr4I+ZSP+ZVGBRuPxGiKJH+0V1+9Vk5+M=
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, dan.carpenter@oracle.com, david@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com
Subject:  [merged]
 hugetlb-fix-an-error-code-in-hugetlb_reserve_pages.patch removed from -mm
 tree
Message-ID: <20201215232241.iHtYIIATq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix an error code in hugetlb_reserve_pages()
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-an-error-code-in-hugetlb_reserve_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: hugetlb: fix an error code in hugetlb_reserve_pages()

Preserve the error code from region_add() instead of returning success.

Link: https://lkml.kernel.org/r/X9NGZWnZl5/Mt99R@mwanda
Fixes: 0db9d74ed884 ("hugetlb: disable region_add file_region coalescing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~hugetlb-fix-an-error-code-in-hugetlb_reserve_pages
+++ a/mm/hugetlb.c
@@ -5113,6 +5113,7 @@ int hugetlb_reserve_pages(struct inode *
 
 		if (unlikely(add < 0)) {
 			hugetlb_acct_memory(h, -gbl_reserve);
+			ret = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
 			/*
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are


