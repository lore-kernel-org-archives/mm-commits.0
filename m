Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3EDC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C0A464E20
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbhBXUMr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:12:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235486AbhBXUKg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 235C064F0C;
        Wed, 24 Feb 2021 20:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197412;
        bh=M/TTcjgjOb3SjPpWj5Hs3N3IiOT6/aEzVseG2KL1nZE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sOHCBslAvpWXgGcvo5pdpxMYaJ0T9e1arwSrv3qWHTo8TWysr9d/uNOGP6WwbKTfr
         ibwzPMUIyIUpcVzmzV05kKy9I4PN8gJ+6iUBBOk5MANNKewkWON42+ZVTQGeAE0yEN
         tokXRI3prZebaZFuxuwFQVGGzrt9v6/v6tsyyAK0=
Date:   Wed, 24 Feb 2021 12:10:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 168/173] hugetlbfs: remove meaningless variable
 avoid_reserve
Message-ID: <20210224201011.D0Jwjhk-w%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: remove meaningless variable avoid_reserve

The variable avoid_reserve is meaningless because we never changed its
value and just passed it to alloc_huge_page().  So remove it to make code
more clear that in hugetlbfs_fallocate, we never avoid reserve when alloc
hugepage yet.  Also add a comment offered by Mike Kravetz to explain this.

Link: https://lkml.kernel.org/r/20210120071508.9078-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-remove-meaningless-variable-avoid_reserve
+++ a/fs/hugetlbfs/inode.c
@@ -680,7 +680,6 @@ static long hugetlbfs_fallocate(struct f
 		 */
 		struct page *page;
 		unsigned long addr;
-		int avoid_reserve = 0;
 
 		cond_resched();
 
@@ -716,8 +715,15 @@ static long hugetlbfs_fallocate(struct f
 			continue;
 		}
 
-		/* Allocate page and add to page cache */
-		page = alloc_huge_page(&pseudo_vma, addr, avoid_reserve);
+		/*
+		 * Allocate page without setting the avoid_reserve argument.
+		 * There certainly are no reserves associated with the
+		 * pseudo_vma.  However, there could be shared mappings with
+		 * reserves for the file at the inode level.  If we fallocate
+		 * pages in these areas, we need to consume the reserves
+		 * to keep reservation accounting consistent.
+		 */
+		page = alloc_huge_page(&pseudo_vma, addr, 0);
 		hugetlb_drop_vma_policy(&pseudo_vma);
 		if (IS_ERR(page)) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
_
