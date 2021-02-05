Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501FBC433DB
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BE3D64FD6
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhBFDHc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:07:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231858AbhBFDCE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 22:02:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F314364FD8;
        Fri,  5 Feb 2021 23:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612567490;
        bh=K0bRW15VVCsLMfeggUTfJuUsP5VPaDg9/Fpo65oeZbY=;
        h=Date:From:To:Subject:From;
        b=V0JQ2/LiHrL4lG/04rX5sNdROmCd5M4k/RUxxUBvTi63DlQlwQ/JUZqoYPw5a1p/X
         5K9LZrc1EdaKFmikb9jv38XoVYlCHADDsGgkzLLC2OcXcFzm0kHdDfQahKggHc3i8e
         nn08KBxtU3NNq+zTxIPxcROT0RzPpCQg3qqe/Q9M=
Date:   Fri, 05 Feb 2021 15:24:49 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch added to
 -mm tree
Message-ID: <20210205232449.K0Pvi1_DN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: stop counting mlocked pages when none vma is found
has been added to the -mm tree.  Its filename is
     mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch

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
Subject: mm/mlock: stop counting mlocked pages when none vma is found

There will be no vma satisfies addr < vm_end when find_vma() returns NULL.
Thus it's meaningless to traverse the vma list below because we can't
find any vma to count mlocked pages.  Stop counting mlocked pages in this
case to save some vma list traversal cycles.

Link: https://lkml.kernel.org/r/20210204110705.17586-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mlock.c~mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found
+++ a/mm/mlock.c
@@ -622,7 +622,7 @@ static unsigned long count_mm_mlocked_pa
 
 	vma = find_vma(mm, start);
 	if (vma == NULL)
-		vma = mm->mmap;
+		return 0;
 
 	for (; vma ; vma = vma->vm_next) {
 		if (start >= vma->vm_end)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
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
mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

