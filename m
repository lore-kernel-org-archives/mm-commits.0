Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E15B9C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiGRAVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiGRAUT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465ED14D03
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5E6FB80E27
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996DAC3411E;
        Mon, 18 Jul 2022 00:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103511;
        bh=V63RxILzeL7vCJ+a4earrKo4Ir+qhYqEvAnQVczZGRo=;
        h=Date:To:From:Subject:From;
        b=nGjNBRw3ERqetBMWZRlob3Lu+JpyX9AFClrJKsgbuP94/wroWP3o9O1koxZ+zQt1y
         6/UBDJF6Fl91u3RSAHRUgLaG9Ua8QCgRM4XEPNwEEia0XET4JEkaZ+pNYLWx8KZimc
         W/8eP92pH2sYHCO+y/sYaP06oGCJooy+cDlwwSG4=
Date:   Sun, 17 Jul 2022 17:18:31 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-helper-function-vma_lookup-in-split_huge_pages_pid.patch removed from -mm tree
Message-Id: <20220718001831.996DAC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: use helper function vma_lookup in split_huge_pages_pid
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-helper-function-vma_lookup-in-split_huge_pages_pid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: use helper function vma_lookup in split_huge_pages_pid
Date: Mon, 4 Jul 2022 21:21:52 +0800

Use helper function vma_lookup to lookup the needed vma to simplify the
code. Minor readability improvement.

Link: https://lkml.kernel.org/r/20220704132201.14611-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-helper-function-vma_lookup-in-split_huge_pages_pid
+++ a/mm/huge_memory.c
@@ -2941,10 +2941,10 @@ static int split_huge_pages_pid(int pid,
 	 * table filled with PTE-mapped THPs, each of which is distinct.
 	 */
 	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
-		struct vm_area_struct *vma = find_vma(mm, addr);
+		struct vm_area_struct *vma = vma_lookup(mm, addr);
 		struct page *page;
 
-		if (!vma || addr < vma->vm_start)
+		if (!vma)
 			break;
 
 		/* skip special VMA and hugetlb VMA */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

