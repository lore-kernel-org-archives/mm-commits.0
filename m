Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2968AC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1312227BF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbhAXB5E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:57:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726288AbhAXB5D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:57:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48A16225AC;
        Sun, 24 Jan 2021 01:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611453383;
        bh=D12gYQkR2rCm8lch2qOxATI5iZ7kA3Xbj0ol3sa9ry0=;
        h=Date:From:To:Subject:From;
        b=DlQ7eM5Pc63/3iqzq09Ww5gW6fU9Wah+ZMCM3XdImAB6KjDdRZc2qIO1Wt+KlEZqu
         Huq/oefjkDwLBTTTNuIiI3WTXaao8z0ERwCRRrfDEjAQJnDLIAdZg63uEAvCxzRF6Q
         IvSKm+BPecrOg+xlbqu2Vvm+O7tPkL7yF9lxPFT4=
Date:   Sat, 23 Jan 2021 17:56:19 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 hugetlbfs-make-hugepage-size-conversion-more-readable.patch added to -mm
 tree
Message-ID: <20210124015619.Y7yBpmxR3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: make hugepage size conversion more readable
has been added to the -mm tree.  Its filename is
     hugetlbfs-make-hugepage-size-conversion-more-readable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-make-hugepage-size-conversion-more-readable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-make-hugepage-size-conversion-more-readable.patch

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
Subject: hugetlbfs: make hugepage size conversion more readable

The calculation 1U << (h->order + PAGE_SHIFT - 10) is actually equal to
(PAGE_SHIFT << (h->order)) >> 10.  So we can make it more readable by
replace it with huge_page_size(h) >> 10.

Link: https://lkml.kernel.org/r/20210122083141.24548-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-make-hugepage-size-conversion-more-readable
+++ a/fs/hugetlbfs/inode.c
@@ -1513,8 +1513,8 @@ static struct vfsmount *__init mount_one
 		put_fs_context(fc);
 	}
 	if (IS_ERR(mnt))
-		pr_err("Cannot mount internal hugetlbfs for page size %uK",
-		       1U << (h->order + PAGE_SHIFT - 10));
+		pr_err("Cannot mount internal hugetlbfs for page size %luK",
+		       huge_page_size(h) >> 10);
 	return mnt;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
hugetlbfs-make-hugepage-size-conversion-more-readable.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

