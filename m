Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CCEC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 149FE64F29
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhBYThV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234964AbhBYTfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A407864F3A;
        Thu, 25 Feb 2021 19:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280756;
        bh=4nqDT0uuTjp/xN2QGGRKj4gjQuY6c1ZMXqSq7Yf9PAc=;
        h=Date:From:To:Subject:From;
        b=S21z7zLOMK1IOq8umsaSFkRk1UXCuZAQO/HEqiZqeghURny52orpZKlu6KOzPQPw0
         vFF3g6DjF5vm4k9GJF82Yaclt8wpL48Nm4DBCFhVchqrT68Q08+Of16y4UToOSezAV
         O+8NdOwCuKBGSUvcIVZZQ2u4xC1v58bwKBiTt6ik=
Date:   Thu, 25 Feb 2021 11:19:16 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlbfs-remove-meaningless-variable-avoid_reserve.patch removed from -mm
 tree
Message-ID: <20210225191916.NTl9OcJRM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove meaningless variable avoid_reserve
has been removed from the -mm tree.  Its filename was
     hugetlbfs-remove-meaningless-variable-avoid_reserve.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

