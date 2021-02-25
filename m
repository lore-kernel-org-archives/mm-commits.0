Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63265C43381
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AA5164F39
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbhBYThb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232770AbhBYTfR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 979A664F3E;
        Thu, 25 Feb 2021 19:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280768;
        bh=pOM0SVw01dmQEhK8q56vjWKMcRzPqrR4kFKSZK1hDX0=;
        h=Date:From:To:Subject:From;
        b=0ViBBWlCGf69A7p6L1jSvNTPHxPQRZJhST5wkelKUhgyYDorMAxBrZ2h0FHkP4a0D
         wQ7l3Ev5JodFdO483nC8V21qR49qepbdAnqTBc6tsJEhpZ8rGEqw3CuXVkQ1qZwR8/
         dVsabcvI+f80Lu3ttlMww6Y/7Y1X9FqLA+AWzxHY=
Date:   Thu, 25 Feb 2021 11:19:28 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlbfs-remove-unneeded-return-value-of-hugetlb_vmtruncate.patch removed
 from -mm tree
Message-ID: <20210225191928.5GvIX8Vfr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove unneeded return value of hugetlb_vmtruncate()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-remove-unneeded-return-value-of-hugetlb_vmtruncate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: remove unneeded return value of hugetlb_vmtruncate()

The function hugetlb_vmtruncate() is guaranteed to always success since
commit 7aa91e104028 ("hugetlb: allow extending ftruncate on hugetlbfs").
So we should remove the unneeded return value which is always 0.

Link: https://lkml.kernel.org/r/20210208084637.47789-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-remove-unneeded-return-value-of-hugetlb_vmtruncate
+++ a/fs/hugetlbfs/inode.c
@@ -567,7 +567,7 @@ static void hugetlbfs_evict_inode(struct
 	clear_inode(inode);
 }
 
-static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
+static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 {
 	pgoff_t pgoff;
 	struct address_space *mapping = inode->i_mapping;
@@ -582,7 +582,6 @@ static int hugetlb_vmtruncate(struct ino
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0);
 	i_mmap_unlock_write(mapping);
 	remove_inode_hugepages(inode, offset, LLONG_MAX);
-	return 0;
 }
 
 static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
@@ -781,9 +780,7 @@ static int hugetlbfs_setattr(struct user
 		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
-		error = hugetlb_vmtruncate(inode, newsize);
-		if (error)
-			return error;
+		hugetlb_vmtruncate(inode, newsize);
 	}
 
 	setattr_copy(&init_user_ns, inode, attr);
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

