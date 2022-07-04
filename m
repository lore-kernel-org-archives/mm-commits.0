Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240FCC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 23:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiGDXEr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jul 2022 19:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiGDXEd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jul 2022 19:04:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FA1FD28
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 16:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F1AA617A2
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 23:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAC5C3411E;
        Mon,  4 Jul 2022 23:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656975870;
        bh=6ee7czDD1UA97+BiRdVjVtlnJ4+xkmFcGXXFKRfa81E=;
        h=Date:To:From:Subject:From;
        b=f3z96VZIjL7xnqeJqZC3SuGrgImdO1LmCPzgeZ3mefu7S+oLz3oYlsQsEz13/edS2
         O0sRA9unh2BvjMVTT6G9FSCfmIiCdLavHxCCwWUMXZ1VBJ7gam43X15RCIyDG05n8n
         kv0xJEjgEQkrI4y8+bP+RM3QyQpA8Ni2bhVZw69M=
Date:   Mon, 04 Jul 2022 16:04:30 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-comment-the-subtly-logic-in-__split_huge_pmd.patch added to mm-unstable branch
Message-Id: <20220704230430.AFAC5C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: comment the subtly logic in __split_huge_pmd
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-comment-the-subtly-logic-in-__split_huge_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-comment-the-subtly-logic-in-__split_huge_pmd.patch

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
Subject: mm/huge_memory: comment the subtly logic in __split_huge_pmd
Date: Mon, 4 Jul 2022 21:22:00 +0800

It's dangerous and wrong to call page_folio(pmd_page(*pmd)) when pmd isn't
present. But the caller guarantees pmd is present when folio is set. So we
should be safe here. Add comment to make it clear.

Link: https://lkml.kernel.org/r/20220704132201.14611-16-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-comment-the-subtly-logic-in-__split_huge_pmd
+++ a/mm/huge_memory.c
@@ -2335,6 +2335,10 @@ void __split_huge_pmd(struct vm_area_str
 
 	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
 	    is_pmd_migration_entry(*pmd)) {
+		/*
+		 * It's safe to call pmd_page when folio is set because it's
+		 * guaranteed that pmd is present.
+		 */
 		if (folio && folio != page_folio(pmd_page(*pmd)))
 			goto out;
 		__split_huge_pmd_locked(vma, pmd, range.start, freeze);
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

