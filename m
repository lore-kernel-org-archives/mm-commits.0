Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A74BC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 16 Jul 2022 22:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiGPWvP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jul 2022 18:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbiGPWvN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Jul 2022 18:51:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F68E1F2F7
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 15:51:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF73061331
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 22:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFD5C34114;
        Sat, 16 Jul 2022 22:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658011868;
        bh=lAuE9bqg1hp3shDp4m7PAKXyCYsNhfui95sfC7IMx3s=;
        h=Date:To:From:Subject:From;
        b=QIjFuRC51gxM5ErBv/1qlM604gACzexcsla22fIMBn9Y7FZ//BRP2NzqfKvzVyIb1
         ymSpCmq92bP31pY+HbpUSsjH3oYaCTyarWJJo6RgcScWOG40TWAcFWJc1gsbe5t1uz
         XM1BZrjLByiiFV5pVM6ZACnclqdZfYLwcFn4dPsM=
Date:   Sat, 16 Jul 2022 15:51:07 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-obsolete-comment-in-do_fault_around.patch added to mm-unstable branch
Message-Id: <20220716225108.4DFD5C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove obsolete comment in do_fault_around()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-obsolete-comment-in-do_fault_around.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-obsolete-comment-in-do_fault_around.patch

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
Subject: mm: remove obsolete comment in do_fault_around()
Date: Sat, 16 Jul 2022 16:03:59 +0800

Since commit 7267ec008b5c ("mm: postpone page table allocation until we
have page to map"), do_fault_around is not called with page table lock
held.  Cleanup the corresponding comments.

Link: https://lkml.kernel.org/r/20220716080359.38791-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/memory.c~mm-remove-obsolete-comment-in-do_fault_around
+++ a/mm/memory.c
@@ -4458,10 +4458,6 @@ late_initcall(fault_around_debugfs);
  * It uses vm_ops->map_pages() to map the pages, which skips the page if it's
  * not ready to be mapped: not up-to-date, locked, etc.
  *
- * This function is called with the page table lock taken. In the split ptlock
- * case the page table lock only protects only those entries which belong to
- * the page table corresponding to the fault address.
- *
  * This function doesn't cross the VMA boundaries, in order to call map_pages()
  * only once.
  *
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
mm-remove-obsolete-comment-in-do_fault_around.patch

