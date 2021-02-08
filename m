Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FA4C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 21:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BF7964DE1
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 21:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbhBHVq4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 16:46:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236774AbhBHVpf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 16:45:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E369C64E8F;
        Mon,  8 Feb 2021 21:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612820689;
        bh=+SQ6w208SDzl9N1mCuzbH8qaABnS0/GDLNvXmRRTZOY=;
        h=Date:From:To:Subject:From;
        b=UibOWxyDAY9HtEyoCAtcI9uB3twjNeNMVewnjiEmjrvsMVfObthH82xCZ50jTHKzb
         ZPkkAmNd1MY0RnmmZNifGU6eej4GHKUrW3e6TxuN2O120GTJYwZjqVxr8Cual6aN9l
         d7DWzeej2n3N/RSDbHG8Q2iK4cG5K1k9G1ugwMUQ=
Date:   Mon, 08 Feb 2021 13:44:48 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 hugetlbfs-remove-unneeded-return-value-of-hugetlb_vmtruncate.patch added to
 -mm tree
Message-ID: <20210208214448.lrezA7dr4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove unneeded return value of hugetlb_vmtruncate()
has been added to the -mm tree.  Its filename is
     hugetlbfs-remove-unneeded-return-value-of-hugetlb_vmtruncate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-remove-unneeded-return-value-of-hugetlb_vmtruncate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-remove-unneeded-return-value-of-hugetlb_vmtruncate.patch

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
Subject: hugetlbfs: remove unneeded return value of hugetlb_vmtruncate()

The function hugetlb_vmtruncate() is guaranteed to always success since
commit 7aa91e104028 ("hugetlb: allow extending ftruncate on hugetlbfs").
So we should remove the unneeded return value which is always 0.

Link: https://lkml.kernel.org/r/20210208084637.47789-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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
@@ -780,9 +779,7 @@ static int hugetlbfs_setattr(struct dent
 		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
-		error = hugetlb_vmtruncate(inode, newsize);
-		if (error)
-			return error;
+		hugetlb_vmtruncate(inode, newsize);
 	}
 
 	setattr_copy(inode, attr);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-simplify-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch
mm-pgtable-genericc-optimize-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch
mm-memoryc-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch
mm-hugetlb-fix-some-comment-typos.patch
mm-remove-unused-return-value-of-set_huge_zero_page.patch
hugetlb_cgroup-use-helper-pages_per_huge_page-in-hugetlb_cgroup.patch
mm-hugetlb-use-helper-function-range_in_vma-in-page_table_shareable.patch
mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
hugetlbfs-make-hugepage-size-conversion-more-readable.patch
hugetlbfs-correct-some-obsolete-comments-about-inode-i_mutex.patch
hugetlbfs-fix-some-comment-typos.patch
hugetlbfs-remove-unneeded-return-value-of-hugetlb_vmtruncate.patch
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

