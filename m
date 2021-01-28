Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA30C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 21:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A0B64DED
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 21:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhA1VTf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jan 2021 16:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhA1VTe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Jan 2021 16:19:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C585464DEE;
        Thu, 28 Jan 2021 21:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611868733;
        bh=3t6qTXJO4yWa3G20iPSJFdQFwG5gnZubgkiGUWlzH0k=;
        h=Date:From:To:Subject:From;
        b=B5pjzC/BcHInqYkFEF9Cra3AaiRHEWGwuDCXgBRnkYmVM2qMKEKZvJnvQVj85K6cv
         u2pSBP37pDBYwIZjLjFwyK1StL7FcdwGXu6Q41gT9am//XRuToWlsrp0p4qOevv+iX
         PV9Qt7kiZjAh+g/4T8BSZkZxbq1+G23GyiQsXohM=
Date:   Thu, 28 Jan 2021 13:18:53 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  + mm-hugetlb-fix-some-comment-typos.patch added to -mm
 tree
Message-ID: <20210128211853.S_DkUjFRz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix some comment typos
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-some-comment-typos.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-some-comment-typos.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-some-comment-typos.patch

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
Subject: mm/hugetlb: fix some comment typos

Fix typos sasitfy to satisfy, reservtion to reservation, hugegpage to
hugepage and uniprocesor to uniprocessor in comments.

Link: https://lkml.kernel.org/r/20210128112028.64831-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-some-comment-typos
+++ a/include/linux/hugetlb.h
@@ -37,7 +37,7 @@ struct hugepage_subpool {
 	struct hstate *hstate;
 	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
 	long rsv_hpages;	/* Pages reserved against global pool to */
-				/* sasitfy minimum size. */
+				/* satisfy minimum size. */
 };
 
 struct resv_map {
--- a/mm/hugetlb.c~mm-hugetlb-fix-some-comment-typos
+++ a/mm/hugetlb.c
@@ -1434,7 +1434,7 @@ static void __free_huge_page(struct page
 	 * reservation.  If the page was associated with a subpool, there
 	 * would have been a page reserved in the subpool before allocation
 	 * via hugepage_subpool_get_pages().  Since we are 'restoring' the
-	 * reservtion, do not call hugepage_subpool_put_pages() as this will
+	 * reservation, do not call hugepage_subpool_put_pages() as this will
 	 * remove the reserved page from the subpool.
 	 */
 	if (!restore_reserve) {
@@ -3707,7 +3707,7 @@ static unsigned long hugetlb_vm_op_pages
 /*
  * We cannot handle pagefaults against hugetlb pages at all.  They cause
  * handle_mm_fault() to try to instantiate regular-sized pages in the
- * hugegpage VMA.  do_page_fault() is supposed to trap this, so BUG is we get
+ * hugepage VMA.  do_page_fault() is supposed to trap this, so BUG is we get
  * this far.
  */
 static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
@@ -4505,7 +4505,7 @@ u32 hugetlb_fault_mutex_hash(struct addr
 }
 #else
 /*
- * For uniprocesor systems we always use a single mutex, so just
+ * For uniprocessor systems we always use a single mutex, so just
  * return 0 and avoid the hashing overhead.
  */
 u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx)
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
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
hugetlbfs-make-hugepage-size-conversion-more-readable.patch
hugetlbfs-correct-some-obsolete-comments-about-inode-i_mutex.patch
mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

