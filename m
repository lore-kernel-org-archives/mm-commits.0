Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55074CCA485
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiGRAVQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiGRATi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F06140AC
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD2E8B80EEA
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5DCC341CA;
        Mon, 18 Jul 2022 00:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103505;
        bh=2Yg3dsK99GxEjsiDIsB12ocsFnoA84hbNaEdyX5VraY=;
        h=Date:To:From:Subject:From;
        b=SVvqsV2YpclqdZbIBGk4V16jsvIT5QlMw9HLXUxE/2hjGtDOxNX08awiCuVajpAEj
         oRoANmrn/fYseF4rXLF5J8NjCQ1V4pHQJmmjPo6l0FISAjKcTrzLHuq5zqt2Wdkla1
         54CsIFZivl2qyOsuLeXxq65mkPU2bLewBMv+yWVQ=
Date:   Sun, 17 Jul 2022 17:18:24 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-flush_pmd_tlb_range-in-move_huge_pmd.patch removed from -mm tree
Message-Id: <20220718001825.6A5DCC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: use flush_pmd_tlb_range in move_huge_pmd
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-flush_pmd_tlb_range-in-move_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: use flush_pmd_tlb_range in move_huge_pmd
Date: Mon, 4 Jul 2022 21:21:46 +0800

Patch series "A few cleanup patches for huge_memory", v3.

This series contains a few cleaup patches to remove duplicated codes,
add/use helper functions, fix some obsolete comments and so on.  More
details can be found in the respective changelogs.


This patch (of 16):

Arches with special requirements for evicting THP backing TLB entries can
implement flush_pmd_tlb_range.  Otherwise also, it can help optimize TLB
flush in THP regime.  Using flush_pmd_tlb_range to take advantage of this
in move_huge_pmd.

Link: https://lkml.kernel.org/r/20220704132201.14611-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220704132201.14611-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-flush_pmd_tlb_range-in-move_huge_pmd
+++ a/mm/huge_memory.c
@@ -1749,7 +1749,7 @@ bool move_huge_pmd(struct vm_area_struct
 		pmd = move_soft_dirty_pmd(pmd);
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (force_flush)
-			flush_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
+			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
 		if (new_ptl != old_ptl)
 			spin_unlock(new_ptl);
 		spin_unlock(old_ptl);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

