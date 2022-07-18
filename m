Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBFFDCCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiGRAVQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiGRATi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B886140B5
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DFB960F4B
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F82BC341C0;
        Mon, 18 Jul 2022 00:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103506;
        bh=ZS1m+qKbW+S8kAj2FD2SIaC84xsSMc7Evi4XbpIfU9M=;
        h=Date:To:From:Subject:From;
        b=qbml/pXLYtt4+QKrWKf+OnE1BB9AQNOJU0+6Ax6bTeyy5nCo1u9TL4vX/DvxMr8Sh
         5qRdjxRuRBG1x65bnQgew3EizzCklFccjIaLY3p+RppOxlXlR1yxvUWCy1V/cyawSY
         TGODkfvwiDfElo0PByarPhfTQOiv1Vvz1Ld0Lyf0=
Date:   Sun, 17 Jul 2022 17:18:25 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-access-vm_page_prot-with-read_once-in-remove_migration_pmd.patch removed from -mm tree
Message-Id: <20220718001826.6F82BC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: access vm_page_prot with READ_ONCE in remove_migration_pmd
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-access-vm_page_prot-with-read_once-in-remove_migration_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3205,7 +3205,7 @@ void remove_migration_pmd(struct page_vm
 
 	entry = pmd_to_swp_entry(*pvmw->pmd);
 	get_page(new);
-	pmde = pmd_mkold(mk_huge_pmd(new, vma->vm_page_prot));
+	pmde = pmd_mkold(mk_huge_pmd(new, READ_ONCE(vma->vm_page_prot)));
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_writable_migration_entry(entry))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

