Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F712CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiGRAVg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiGRAUF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10BE140D7
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4289E60F57
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933EAC3411E;
        Mon, 18 Jul 2022 00:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103510;
        bh=23zLI8dWyyKQGjEHnrs72vlW3WnbN2MvrmcWw2maDDU=;
        h=Date:To:From:Subject:From;
        b=Az6o75L3ugLWfXL0pBIR7fkyAlgiZzWSYEItjuIWwQS0u6MU5YWWSj0vhJ18xyF0k
         lBiw8BgcYGaTN9ZLXWNl/+YcycaaE9yO/ky+96YntJ0UIucPvJtjrSkLvYi2wGM2eb
         LOsUGGBj+xJq7RH5WW/bzJw021mIwJz0itYA20Tc=
Date:   Sun, 17 Jul 2022 17:18:30 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-rename-mmun_start-to-haddr-in-remove_migration_pmd.patch removed from -mm tree
Message-Id: <20220718001830.933EAC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: rename mmun_start to haddr in remove_migration_pmd
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-rename-mmun_start-to-haddr-in-remove_migration_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: rename mmun_start to haddr in remove_migration_pmd
Date: Mon, 4 Jul 2022 21:21:51 +0800

mmun_start indicates mmu_notifier start address but there's no mmu_notifier
stuff in remove_migration_pmd. This will make it hard to get the meaning of
mmun_start. Rename it to haddr to avoid confusing readers and also imporve
readability.

Link: https://lkml.kernel.org/r/20220704132201.14611-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-rename-mmun_start-to-haddr-in-remove_migration_pmd
+++ a/mm/huge_memory.c
@@ -3180,7 +3180,7 @@ void remove_migration_pmd(struct page_vm
 	struct vm_area_struct *vma = pvmw->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address = pvmw->address;
-	unsigned long mmun_start = address & HPAGE_PMD_MASK;
+	unsigned long haddr = address & HPAGE_PMD_MASK;
 	pmd_t pmde;
 	swp_entry_t entry;
 
@@ -3203,12 +3203,12 @@ void remove_migration_pmd(struct page_vm
 		if (!is_readable_migration_entry(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
-		page_add_anon_rmap(new, vma, mmun_start, rmap_flags);
+		page_add_anon_rmap(new, vma, haddr, rmap_flags);
 	} else {
 		page_add_file_rmap(new, vma, true);
 	}
 	VM_BUG_ON(pmd_write(pmde) && PageAnon(new) && !PageAnonExclusive(new));
-	set_pmd_at(mm, mmun_start, pvmw->pmd, pmde);
+	set_pmd_at(mm, haddr, pvmw->pmd, pmde);
 
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache_pmd(vma, address, pvmw->pmd);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

