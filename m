Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B66FC4332D
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 445AA64F18
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhBYTcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234851AbhBYTaP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EB5F64F2A;
        Thu, 25 Feb 2021 19:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280617;
        bh=73MppLhaaSGZq2gvJWhvNmVh6QLAtvZQBiGlTi84w+0=;
        h=Date:From:To:Subject:From;
        b=jjfF9k/iQQwFYH585mEdMzS3FOwhgAK3hu9RbX3s4fEeoyVxrOrEw8Lvz71mAMvCA
         HF1S4CtrQ5ueZsnJMaflAJtdO98JjoRZjhAEd6Pj6EkJLWNFTQKpn0MuJ7AqRWtZmD
         gDSotQ5BZ4KT36E1YJ+3WJeQcRNi3U0cV0Qvo/HU=
Date:   Thu, 25 Feb 2021 11:16:57 -0800
From:   akpm@linux-foundation.org
To:     jrdr.linux@gmail.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged] mm-hugetlb-fix-some-comment-typos.patch removed
 from -mm tree
Message-ID: <20210225191657.-GQhLVtU_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix some comment typos
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-some-comment-typos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix some comment typos

Fix typos sasitfy to satisfy, reservtion to reservation, hugegpage to
hugepage and uniprocesor to uniprocessor in comments.

Link: https://lkml.kernel.org/r/20210128112028.64831-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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
@@ -4491,7 +4491,7 @@ u32 hugetlb_fault_mutex_hash(struct addr
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

