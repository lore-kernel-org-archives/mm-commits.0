Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3984C43334
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 17:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiGMRZl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 13:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiGMRZk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 13:25:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1A62314E
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 10:25:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 059CD61CF8
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 17:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC32C34114;
        Wed, 13 Jul 2022 17:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657733138;
        bh=pOdZAjaewi80wEWb9tNFJqtZidq60fWzFwSQgx3bwFM=;
        h=Date:To:From:Subject:From;
        b=Dvz+OzcOBWcXRr0FFEiurcR5ileabjh/MI2Pq7Jdi/L0LrTVFuygZAIkSRDPx+HBl
         F9+Oojge87Sp1DTdnXDq4OlW0yCxEWtAwCx8uYAGTIXg4M9oUyqCcEEdU1NOEmvMpR
         IjdhA8Wkko8EzqY9TWKl/SCSqU1RPnhL3qe8eSz0=
Date:   Wed, 13 Jul 2022 10:25:37 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        mike.kravetz@oracle.com, axelrasmussen@google.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch added to mm-hotfixes-unstable branch
Message-Id: <20220713172538.4FC32C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: avoid corrupting page->mapping in hugetlb_mcopy_atomic_pte
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: avoid corrupting page->mapping in hugetlb_mcopy_atomic_pte
Date: Tue, 12 Jul 2022 21:05:42 +0800

In MCOPY_ATOMIC_CONTINUE case with a non-shared VMA, pages in the page
cache are installed in the ptes.  But hugepage_add_new_anon_rmap is called
for them mistakenly because they're not vm_shared.  This will corrupt the
page->mapping used by page cache code.

Link: https://lkml.kernel.org/r/20220712130542.18836-1-linmiaohe@huawei.com
Fixes: f619147104c8 ("userfaultfd: add UFFDIO_CONTINUE ioctl")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte
+++ a/mm/hugetlb.c
@@ -6015,7 +6015,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	if (!huge_pte_none_mostly(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
 
-	if (vm_shared) {
+	if (page_in_pagecache) {
 		page_dup_file_rmap(page, true);
 	} else {
 		ClearHPageRestoreReserve(page);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb-fix-memoryleak-in-hugetlb_mcopy_atomic_pte.patch
mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-huge_memory-use-flush_pmd_tlb_range-in-move_huge_pmd.patch
mm-huge_memory-access-vm_page_prot-with-read_once-in-remove_migration_pmd.patch
mm-huge_memory-fix-comment-of-__pud_trans_huge_lock.patch
mm-huge_memory-use-helper-touch_pud-in-huge_pud_set_accessed.patch
mm-huge_memory-use-helper-touch_pmd-in-huge_pmd_set_accessed.patch
mm-huge_memory-rename-mmun_start-to-haddr-in-remove_migration_pmd.patch
mm-huge_memory-use-helper-function-vma_lookup-in-split_huge_pages_pid.patch
mm-huge_memory-use-helper-macro-__attr_rw.patch
mm-huge_memory-fix-comment-in-zap_huge_pud.patch
mm-huge_memory-check-pmd_present-first-in-is_huge_zero_pmd.patch
mm-huge_memory-try-to-free-subpage-in-swapcache-when-possible.patch
mm-huge_memory-minor-cleanup-for-split_huge_pages_all.patch
mm-huge_memory-fix-comment-of-page_deferred_list.patch
mm-huge_memory-correct-comment-of-prep_transhuge_page.patch
mm-huge_memory-comment-the-subtly-logic-in-__split_huge_pmd.patch
mm-huge_memory-use-helper-macro-is_err_or_null-in-split_huge_pages_pid.patch
mm-page_vma_mappedc-use-helper-function-huge_pte_lock.patch
mm-mmap-fix-obsolete-comment-of-find_extend_vma.patch

