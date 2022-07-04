Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C262C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 23:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiGDXEJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jul 2022 19:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiGDXEI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jul 2022 19:04:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FA4BC81
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 16:04:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 712E16175C
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 23:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6F9C3411E;
        Mon,  4 Jul 2022 23:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656975846;
        bh=IJyM/e2iqHBQFRELsWi+FxQ8Ud8cmUo2qZ0c4hh5BGw=;
        h=Date:To:From:Subject:From;
        b=UmN94PZP61+iZu0tkUY8wUMQNeJOFKbVjrEJEozuIobIh2m/f6fHwvrjhyhZ3n0xa
         mv2choCl3/t7UmimcHO1l3h2Hctb8eQI9lVAlWenH1LXY5vle6FhhqRqvTeQq0ZcuY
         m1dUd7z0pCXH90MmYMvXylDGDllEe1rkg5SzZKsQ=
Date:   Mon, 04 Jul 2022 16:04:06 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-access-vm_page_prot-with-read_once-in-remove_migration_pmd.patch added to mm-unstable branch
Message-Id: <20220704230406.BC6F9C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: access vm_page_prot with READ_ONCE in remove_migration_pmd
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-access-vm_page_prot-with-read_once-in-remove_migration_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-access-vm_page_prot-with-read_once-in-remove_migration_pmd.patch

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
Subject: mm/huge_memory: access vm_page_prot with READ_ONCE in remove_migration_pmd
Date: Mon, 4 Jul 2022 21:21:47 +0800

vma->vm_page_prot is read lockless from the rmap_walk, it may be updated
concurrently.  Using READ_ONCE to prevent the risk of reading intermediate
values.

Link: https://lkml.kernel.org/r/20220704132201.14611-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-access-vm_page_prot-with-read_once-in-remove_migration_pmd
+++ a/mm/huge_memory.c
@@ -3304,7 +3304,7 @@ void remove_migration_pmd(struct page_vm
 
 	entry = pmd_to_swp_entry(*pvmw->pmd);
 	get_page(new);
-	pmde = pmd_mkold(mk_huge_pmd(new, vma->vm_page_prot));
+	pmde = pmd_mkold(mk_huge_pmd(new, READ_ONCE(vma->vm_page_prot)));
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_writable_migration_entry(entry))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

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

