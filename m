Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B64CC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 11 Jul 2022 20:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiGKUb2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jul 2022 16:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiGKUbG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2022 16:31:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0268E1D9
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 13:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 118DF615FE
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 20:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580CFC34115;
        Mon, 11 Jul 2022 20:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657571304;
        bh=sxLLTqUfv0cXtyG9QhhK5PFbiQAULVAqZJA6mKvPrYA=;
        h=Date:To:From:Subject:From;
        b=Vzf01aVP6SYS2uW4kUEGBFYEaL3XtDTfPRiwNGgap5W7jgFp+d/+3CK8dGrRr6bqB
         awW8ammRveNK+vQnzWTE2Wa1Y1eCXy+7lOLu30JYrwvCwdJpWsNgJ6B3dR/ICIBUto
         RXEGViYfWoZmOE69olMJth1VzgzQhjNyNWOJps1A=
Date:   Mon, 11 Jul 2022 13:28:23 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_vma_mappedc-use-helper-function-huge_pte_lock.patch added to mm-unstable branch
Message-Id: <20220711202824.580CFC34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_vma_mapped.c: use helper function huge_pte_lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_vma_mappedc-use-helper-function-huge_pte_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_vma_mappedc-use-helper-function-huge_pte_lock.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/page_vma_mapped.c: use helper function huge_pte_lock
Date: Sat, 9 Jul 2022 17:24:40 +0800

Use helper function huge_pte_lock() to lock the huge pte to simplify the
code a bit.  No functional change intended.

Link: https://lkml.kernel.org/r/20220709092440.43018-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mappedc-use-helper-function-huge_pte_lock
+++ a/mm/page_vma_mapped.c
@@ -174,8 +174,7 @@ bool page_vma_mapped_walk(struct page_vm
 		if (!pvmw->pte)
 			return false;
 
-		pvmw->ptl = huge_pte_lockptr(hstate, mm, pvmw->pte);
-		spin_lock(pvmw->ptl);
+		pvmw->ptl = huge_pte_lock(hstate, mm, pvmw->pte);
 		if (!check_pte(pvmw))
 			return not_found(pvmw);
 		return true;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb-fix-memoryleak-in-hugetlb_mcopy_atomic_pte.patch
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

