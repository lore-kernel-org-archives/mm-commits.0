Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7AEDC433DB
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A68BD64F64
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhBDA2h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:28:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhBDA20 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Feb 2021 19:28:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54B3F64DAF;
        Thu,  4 Feb 2021 00:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612398465;
        bh=YVw41h8eBgqO+pJUfnRD5+EFuZj33ziJLLUyutvusZQ=;
        h=Date:From:To:Subject:From;
        b=IhndFSaTd4SEj+ckjUEmPIMlV++U7AXP6Zm6wMHaYi88cQh4MI6qMvsjfx6DFAk0Y
         eQWOGvE+br9QSIA3+Hv0EnAmVxZSOJ3u9T+BswmC2gHCsTzCcDp+KHL+flvN8OBwJn
         Q2aM4PmL9PMm+M6lNeQHLwhNsFZethPnere0w4mc=
Date:   Wed, 03 Feb 2021 16:27:44 -0800
From:   akpm@linux-foundation.org
To:     a.p.zijlstra@chello.nl, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch added to -mm
 tree
Message-ID: <20210204002744.W_8zhLSDo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: correct obsolete comment of page_get_anon_vma()
has been added to the -mm tree.  Its filename is
     mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch

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
Subject: mm/rmap: correct obsolete comment of page_get_anon_vma()

Since commit 746b18d421da ("mm: use refcounts for page_lock_anon_vma()"),
page_lock_anon_vma() is renamed to page_get_anon_vma() and converted to
return a refcount increased anon_vma.  But it forgot to change the
relevant comment.

Link: https://lkml.kernel.org/r/20210203093215.31990-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-correct-obsolete-comment-of-page_get_anon_vma
+++ a/mm/rmap.c
@@ -462,8 +462,8 @@ void __init anon_vma_init(void)
  * Getting a lock on a stable anon_vma from a page off the LRU is tricky!
  *
  * Since there is no serialization what so ever against page_remove_rmap()
- * the best this function can do is return a locked anon_vma that might
- * have been relevant to this page.
+ * the best this function can do is return a refcount increased anon_vma
+ * that might have been relevant to this page.
  *
  * The page might have been remapped to a different anon_vma or the anon_vma
  * returned may already be freed (and even reused).
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-simplify-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch
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
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

