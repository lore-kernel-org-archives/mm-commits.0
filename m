Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1122C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiGRAVr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiGRAUc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B9E14D19
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7831460F32
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB1FC341C0;
        Mon, 18 Jul 2022 00:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103519;
        bh=JV3DHdvc1Ct7H0Zx4kyHTGgE+MNEFzDBCS2w2nGiV0M=;
        h=Date:To:From:Subject:From;
        b=EmCFkWmwVimyZ7E+hmXEZB5wtr0HF8WrDXAlxx+hjMjiU+6SQ/9AZqnwGmANdPoyx
         JtKFKT0rkPM/+dYNuZL0lslWlAYB8jEeLLVOzleqnnuTLl2Y9fwZ3z2sN4Xxs7WHNR
         QCX2ss5HaS+g2wBMixQEwSp8UPWLJHvhrVvhON2E=
Date:   Sun, 17 Jul 2022 17:18:39 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-comment-the-subtly-logic-in-__split_huge_pmd.patch removed from -mm tree
Message-Id: <20220718001839.CCB1FC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: comment the subtly logic in __split_huge_pmd
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-comment-the-subtly-logic-in-__split_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2235,6 +2235,10 @@ void __split_huge_pmd(struct vm_area_str
 
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

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

