Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F8D7C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5203961410
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhEEBfg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhEEBfg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28A4C6140F;
        Wed,  5 May 2021 01:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178479;
        bh=MvDoYypCFaJ8oxLTqbzShNdXjx+1iMNKcFQfnDIZ4dg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DazzxwgZbMAZsaaezG3zVICervuwO1IXGb9NA85A8hpOal96JCQZ2qIYIjPFW2Wh+
         0XB7/+sFZyc3SMk0bNhbvNW5KDi3Ej/LUe9wkGP3xXQQ2FgsIdVbBmr97Fgb+2gpz4
         yl7fcyJ+emQydDy+SiKsbaCynu2cg1YlhDjYREHQ=
Date:   Tue, 04 May 2021 18:34:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linfeilong@huawei.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 037/143] mm/hugeltb: handle the error case in
 hugetlb_fix_reserve_counts()
Message-ID: <20210505013438.YLG8JGt3o%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugeltb: handle the error case in hugetlb_fix_reserve_counts()

A rare out of memory error would prevent removal of the reserve map region
for a page.  hugetlb_fix_reserve_counts() handles this rare case to avoid
dangling with incorrect counts.  Unfortunately, hugepage_subpool_get_pages
and hugetlb_acct_memory could possibly fail too.  We should correctly
handle these cases.

Link: https://lkml.kernel.org/r/20210410072348.20437-5-linmiaohe@huawei.com
Fixes: b5cec28d36f5 ("hugetlbfs: truncate_hugepages() takes a range of pages")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugeltb-handle-the-error-case-in-hugetlb_fix_reserve_counts
+++ a/mm/hugetlb.c
@@ -742,13 +742,20 @@ void hugetlb_fix_reserve_counts(struct i
 {
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	long rsv_adjust;
+	bool reserved = false;
 
 	rsv_adjust = hugepage_subpool_get_pages(spool, 1);
-	if (rsv_adjust) {
+	if (rsv_adjust > 0) {
 		struct hstate *h = hstate_inode(inode);
 
-		hugetlb_acct_memory(h, 1);
+		if (!hugetlb_acct_memory(h, 1))
+			reserved = true;
+	} else if (!rsv_adjust) {
+		reserved = true;
 	}
+
+	if (!reserved)
+		pr_warn("hugetlb: Huge Page Reserved count may go negative.\n");
 }
 
 /*
_
