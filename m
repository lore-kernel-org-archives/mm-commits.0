Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D23C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 31 Jan 2021 03:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4700664E21
	for <mm-commits@archiver.kernel.org>; Sun, 31 Jan 2021 03:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhAaDz5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 30 Jan 2021 22:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhAaDz5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 30 Jan 2021 22:55:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACFD164E1F;
        Sun, 31 Jan 2021 03:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612065316;
        bh=07f8+FvnUXGZQ2zldxYJDaEPYC2GCicdaHPDe9ObRyU=;
        h=Date:From:To:Subject:From;
        b=hIBKWBUu1SuQDAanNT6KZ7BIEIJXkj72ev9OKw1Yw7AoP2W9azGhT8scnVfZf7CWw
         pNSRrny5hV0eXtXkuJqOfGqaQQLYBa5aspFV52SNZKUqy50kGhb5PciTPFKWmgXD7e
         gbQsVqp2OaN4dkhiU77u1uFO38sFhlUqh0KLNn28=
Date:   Sat, 30 Jan 2021 19:55:16 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk.patch added
 to -mm tree
Message-ID: <20210131035516.3qmZMCCWQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: use helper range_in_vma() in queue_pages_test_walk()
has been added to the -mm tree.  Its filename is
     mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk.patch

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
Subject: mm/mempolicy: use helper range_in_vma() in queue_pages_test_walk()

The helper range_in_vma() is introduced via commit 017b1660df89 ("mm:
migration: fix migration of huge PMD shared pages"). But we forgot to
use it in queue_pages_test_walk().

Link: https://lkml.kernel.org/r/20210130091352.20220-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk
+++ a/mm/mempolicy.c
@@ -677,7 +677,7 @@ static int queue_pages_test_walk(unsigne
 	unsigned long flags = qp->flags;
 
 	/* range check first */
-	VM_BUG_ON_VMA((vma->vm_start > start) || (vma->vm_end < end), vma);
+	VM_BUG_ON_VMA(!range_in_vma(vma, start, end), vma);
 
 	if (!qp->first) {
 		qp->first = vma;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch
mm-hugetlb-fix-some-comment-typos.patch
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
mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

