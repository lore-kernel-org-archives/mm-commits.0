Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53C1C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbiGRAVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiGRAUU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE22414D08
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5259C60F54
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A930DC3411E;
        Mon, 18 Jul 2022 00:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103513;
        bh=jGRy5JtKii3iHfz+fTuEUNIEgK3E6s+aLz8c2ZfOODw=;
        h=Date:To:From:Subject:From;
        b=AJg/aiq9Q7FTrwviaQm4c/q3p6IywzbUj4fAz8Egef7WEwFRk8gYN757rBLsGCTk4
         dNjsBKYly+7djTCqUd7kOxgNa18SHGTAUwB4w4Trvm36P/2kmoVFLSNlpo5FD1IPSZ
         fLs/+mvJiBLcgOUfNPE19mQiq5A2uMsSXg/xbiiI=
Date:   Sun, 17 Jul 2022 17:18:33 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-fix-comment-in-zap_huge_pud.patch removed from -mm tree
Message-Id: <20220718001833.A930DC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: fix comment in zap_huge_pud
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-comment-in-zap_huge_pud.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: fix comment in zap_huge_pud
Date: Mon, 4 Jul 2022 21:21:54 +0800

The comment about deposited pgtable is borrowed from zap_huge_pmd but
there's no deposited pgtable stuff for huge pud in zap_huge_pud. Remove
it to avoid confusion.

Link: https://lkml.kernel.org/r/20220704132201.14611-10-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-comment-in-zap_huge_pud
+++ a/mm/huge_memory.c
@@ -1913,12 +1913,7 @@ int zap_huge_pud(struct mmu_gather *tlb,
 	ptl = __pud_trans_huge_lock(pud, vma);
 	if (!ptl)
 		return 0;
-	/*
-	 * For architectures like ppc64 we look at deposited pgtable
-	 * when calling pudp_huge_get_and_clear. So do the
-	 * pgtable_trans_huge_withdraw after finishing pudp related
-	 * operations.
-	 */
+
 	pudp_huge_get_and_clear_full(tlb->mm, addr, pud, tlb->fullmm);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
 	if (vma_is_special_huge(vma)) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

