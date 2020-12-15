Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B35C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E74122473
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgLODNJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbgLODNA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:00 -0500
Date:   Mon, 14 Dec 2020 19:12:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001926;
        bh=PHSp0F2R2WjJ2x8B1CwUz60l5UETzXOWbVBzqxtg+uE=;
        h=From:To:Subject:In-Reply-To:From;
        b=Jy/SDUSn5RcVmn1kcufgpsSRnqSWOKZ2l8J8xA3JW3WIpyjRHVXY1E08QnJi0LwQy
         6Lf+53/fHb72tVnY8pSuAD3rJigj7GTXGkvD6hwwV4Ut2nfGcRLAyChyPidx8gi6M0
         kxvN3Mavv1+hAq1gxPlCH/lpnUjr76SpcoYREsSU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        liu.xiang@zlingsmart.com, liuxiang_1999@126.com,
        ma.chenggong@zlingsmart.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, pan.jiagen@zlingsmart.com,
        torvalds@linux-foundation.org
Subject:  [patch 149/200] mm: hugetlb: fix type of delta parameter
 and related local variables in gather_surplus_pages()
Message-ID: <20201215031205.IRg2pwdxl%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
