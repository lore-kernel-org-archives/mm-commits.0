Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753C7C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 20:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4562F23A5C
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 20:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbhAUUK1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 15:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727011AbhAUUKK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 15:10:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5327023A5D;
        Thu, 21 Jan 2021 20:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611259769;
        bh=jJ4kqKSzMIGSfFyHMwJRvpx4QG2t6P4nX7PzyEalHOQ=;
        h=Date:From:To:Subject:From;
        b=bjDdt+ubWOZT4R0n2ILKddMkfXyPL5/Sz82OC0sWQEBDDfoL2tgdMkxEXnFQvzdqL
         3LBXSvYQpuEiRGG3N74FNKMnZjzNP6MI+WcO/9mYGnVLRyHkG3YHwJgexYqLMEhXS3
         q/OIaB8q95RhsW7kEu1ST3pI3ox7bDrB/FKanlec=
Date:   Thu, 21 Jan 2021 12:09:28 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 hugetlbfs-remove-meaningless-variable-avoid_reserve.patch added to -mm tree
Message-ID: <20210121200928.-RJgA3DKe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove meaningless variable avoid_reserve
has been added to the -mm tree.  Its filename is
     hugetlbfs-remove-meaningless-variable-avoid_reserve.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-remove-meaningless-variable-avoid_reserve.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

